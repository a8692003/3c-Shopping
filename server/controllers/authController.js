require('dotenv').config()
const jwt = require('jsonwebtoken')
const AuthModel = require('../models/AuthModel')

const AuthController = {
  googleAuth: async (req, res, next) => {
    console.log(req.session)

    if (req.user == undefined) {
      res.redirect('/')
      return
    }

    if (req.session.member) {
      const result = await AuthModel.googleBind(req.session.member.u_id, req.user)
      res.redirect(`/member/data?p=GOOGLE&r=${result.message}`)
    } else {
      const result = await AuthModel.google(req.user)
      if (result.err == 0) {
        req.session.member = result.data.member_data
        res.render('member/message', {
          title: '會員登入',
          setting: req.session.setting,
          content: `${req.session.member.u_name}，${
            result.data.type == 'register' ? 'Google 註冊成功。' : ''
          }歡迎登入`,
          btns: [
            { linkTo: '/', linkText: '前往首頁' },
            { linkTo: '/member', linkText: '會員中心' },
          ],
          userId: req.session.member ? req.session.member.u_id : null,
        })
      }
    }
  },
  facebookAuth: async (req, res, next) => {
    console.log(req.user)
    if (req.user == undefined) {
      res.redirect('/')
      return
    }
    if (req.session.member) {
      console.log('bind')
      const result = await AuthModel.facebookBind(req.session.member.u_id, req.user)
      res.redirect(`/member/data?p=FACEBOOK&r=${result.message}`)
    } else {
      const result = await AuthModel.facebook(req.user)
      console.log(result)
      if (result.err == 0) {
        req.session.member = result.data.member_data
        res.render('member/message', {
          title: '會員登入',
          setting: req.session.setting,
          content: `${req.session.member.u_name}，${
            result.data.type == 'register' ? 'FACEBOOK 註冊成功。' : ''
          }歡迎登入`,
          btns: [
            { linkTo: '/', linkText: '前往首頁' },
            { linkTo: '/member', linkText: '會員中心' },
          ],
          userId: req.session.member ? req.session.member.u_id : null,
        })
      }
    }
  },
}
module.exports = AuthController
