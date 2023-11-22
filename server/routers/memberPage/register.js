const express = require('express')
var router = express.Router()

const bodyparse = require('body-parser')

var bp_json = bodyparse.json()
var bp_uncode = bodyparse.urlencoded({ extended: true })

const RegisterController = require('../../controllers/memberPage/registerController')

router.get('/', function (req, res) {
  res.render('member/register', {
    title: '註冊帳號',
    setting: req.session.setting,
    userId: req.session.member ? req.session.member.u_id : null,
  })
})
router.post('/', bp_uncode, RegisterController.registerSucRender)

module.exports = router
