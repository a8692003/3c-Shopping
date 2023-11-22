const { Error } = require('../config/response')

// 需登入 但 未登入使用 , 轉跳回 登入頁
var login_render = function (req, res, next) {
  if (req.session.member) {
    next()
  } else {
    res.redirect('/login')
  }
}
// 需登入 但 未登入使用 API , 傳回 沒有許可 的錯誤訊息
var login_api = function (req, res, next) {
  if (req.session.member) {
    next()
  } else {
    // res.end(JSON.stringify(new Error('no permission')))
    res.end(JSON.stringify(new Error('滾')))
  }
}

// 需未登入 但 已登入後使用 , 轉跳回 首頁
var notlogin_render = function (req, res, next) {
  if (!req.session.member) {
    next()
  } else {
    res.redirect('/')
  }
}
// 需未登入 但 已登入後使用 API , 傳回 已登入 錯誤訊息
var notlogin_api = function (req, res, next) {
  if (!req.session.member) {
    next()
  } else {
    res.end(JSON.stringify(new Error('aleady login')))
  }
}

module.exports = {
  login_render,
  login_api,
  notlogin_render,
  notlogin_api,
}
