require('dotenv').config()
const jwt = require('jsonwebtoken')
const express = require('express')
var router = express.Router()

const VerifyModel = require('../../models/verifyModel')

router.use('/account', async (req, res) => {
  const token = req.query.t
  let content = ''

  try {
    if (token) {
      const decoded = jwt.verify(token, process.env.JWT_TOKEN_KEY)

      if (decoded.type !== 'verifyAcc') {
        content = `信箱驗證連結錯誤`
      } else {
        const currentTimestamp = Math.floor(Date.now() / 1000)
        if (decoded.exp && decoded.exp < currentTimestamp) {
          content = `信箱驗證連結已過期`
        } else {
          const response = await VerifyModel.verifyAcc(decoded.user_id, decoded.mail)
          if (response.err === 0) {
            content = `信箱驗證成功`
          } else {
            content = `信箱驗證失敗`
          }
        }
      }
    } else {
      content = `信箱驗證連結錯誤`
    }
  } catch (err) {
    console.log(err)
    if (err.message == 'jwt expired') {
      content = `信箱驗證連結已過期`
    } else {
      content = `信箱驗證連結錯誤`
    }
  }

  res.render('member/message', {
    title: '信箱驗證',
    setting: req.session.setting,
    content: content,
    btns: [{ linkTo: '/', linkText: '返回首頁' }],
    userId: req.session.member ? req.session.member.u_id : null,
  })
})

module.exports = router
