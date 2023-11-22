const express = require('express')
var router = express.Router()

const {
  login_render,
  login_api,
  notlogin_render,
  notlogin_api,
} = require('../../middlewares/isLogin')

const LoginController = require('../../controllers/memberPage/loginController')

router.get('/', notlogin_render, function (req, res) {
  res.render('member/login', {
    title: '會員登入',
    setting: req.session.setting,
    userId: req.session.member ? req.session.member.u_id : null,
  })
})
router.post('/', login_render, LoginController.loginSucRender)

router.get('/forgetPassword', notlogin_render, function (req, res) {
  res.render('member/forgetPwd', {
    title: '忘記密碼',
    setting: req.session.setting,
    userId: req.session.member ? req.session.member.u_id : null,
  })
})
router.post(
  '/forgetPassword',
  notlogin_render,
  express.urlencoded({ extended: true }),
  LoginController.forgetPasswordSend
)

router.get('/resetPassword', notlogin_render, LoginController.resetPassword)
router.post(
  '/resetPassword',
  notlogin_render,
  express.urlencoded({ extended: true }),
  LoginController.resetPasswordSend
)
router.get('/resetPassword/suc', notlogin_render, function (req, res) {
  res.render('member/message', {
    title: '忘記密碼',
    setting: req.session.setting,
    content: '修改成功',
    btns: [
      { linkTo: '/login', linkText: '前往登入' },
      { linkTo: '/', linkText: '返回首頁' },
    ],
    userId: req.session.member ? req.session.member.u_id : null,
  })
})
router.get('/resetPassword/failed', notlogin_render, function (req, res) {
  res.render('member/message', {
    title: '忘記密碼',
    setting: req.session.setting,
    content: '修改失敗',
    btns: [
      { linkTo: '/login/forgetPassword', linkText: '重新申請' },
      { linkTo: '/', linkText: '返回首頁' },
    ],
    userId: req.session.member ? req.session.member.u_id : null,
  })
})

router.use(function (req, res) {
  res.redirect('/member/')
})

module.exports = router
