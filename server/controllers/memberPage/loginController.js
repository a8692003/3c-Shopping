require('dotenv').config()
const jwt = require('jsonwebtoken')
const LoginModel = require('../../models/memberPage/loginModel')

const LoginController = {
  loginSucRender: (req, res) => {
    res.render('member/message', {
      title: '會員登入',
      setting: req.session.setting,
      content: `${req.session.member.u_name}，歡迎登入`,
      btns: [
        { linkTo: '/', linkText: '前往首頁' },
        { linkTo: '/member', linkText: '會員中心' },
      ],
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },
  loginAPI: async (req, res) => {
    const result = await LoginModel.loginAPI(req.body)
    if (result.err == 0) {
      req.session.member = result.data
    }

    console.log(req.session)
    res.end(JSON.stringify(result))
  },
  logoutAPI: (req, res) => {
    res.setHeader('Content-type', 'text/html;charset=utf-8')
    const result = LoginModel.logoutAPI(req.session.member)
    // req.session.destroy()
    delete req.session.member
    res.end(JSON.stringify(result))
  },

  getCurrentUser: (req, res) => {
    console.log('req.session_member',req.session.member);
    
    if (req.session.member) {
      res.json(req.session.member)
    } else {
      res.status(401).json({ error: 'Not logged in' })
    }
  },
  forgetPasswordSend: async (req, res) => {
    const result = await LoginModel.forgetPasswordSend(req.body)
    res.render('member/message', {
      title: '忘記密碼',
      setting: req.session.setting,
      content: '忘記密碼信件已發送',
      btns: [{ linkTo: '/', linkText: '返回首頁' }],
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },
  resetPassword: async (req, res) => {
    const token = req.query.t
    try {
      if (token) {
        const decoded = jwt.verify(token, process.env.JWT_TOKEN_KEY)

        if (decoded.type !== 'forgetPwd') {
          content = `驗證連結錯誤`
        } else {
          const currentTimestamp = Math.floor(Date.now() / 1000)
          if (decoded.exp && decoded.exp < currentTimestamp) {
            content = `驗證連結已過期`
          } else {
            console.log(decoded)
            console.log(decoded.user_id)
            content = `驗證成功`
          }
        }
      } else {
        content = `驗證連結錯誤`
      }
    } catch (err) {
      console.log(err)
      if (err.message == 'jwt expired') {
        content = `驗證連結已過期`
      } else {
        content = `驗證連結錯誤`
      }
    }
    if (content != '驗證成功') {
      res.render('member/message', {
        title: '忘記密碼',
        setting: req.session.setting,
        content: content,
        btns: [{ linkTo: '/', linkText: '返回首頁' }],
        userId: req.session.member ? req.session.member.u_id : null,
      })
    } else {
      res.render('member/resetPwd', {
        title: '忘記密碼',
        setting: req.session.setting,
        userId: req.session.member ? req.session.member.u_id : null,
      })
    }
  },
  resetPasswordSend: async (req, res) => {
    let uid = ''
    const token = req.query.t
    try {
      if (token) {
        const decoded = jwt.verify(token, process.env.JWT_TOKEN_KEY)

        if (decoded.type !== 'forgetPwd') {
        } else {
          const currentTimestamp = Math.floor(Date.now() / 1000)
          if (decoded.exp && decoded.exp < currentTimestamp) {
            content = `驗證連結已過期`
          } else {
            uid = decoded.user_id
          }
        }
      } else {
      }
    } catch (err) {
      console.log(err)
    }
    console.log('x', uid)
    const result = await LoginModel.resetPasswordSend(req.body, uid)
    console.log(result)

    if (result.err == 0) {
      res.redirect('/login/resetPassword/suc')
    } else {
      res.redirect('/login/resetPassword/failed')
    }
  },
}
module.exports = LoginController
