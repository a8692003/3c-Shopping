const { Error } = require('../config/response')

// 非管理員使用 轉跳回首頁
const admin_render = function (req, res, next) {
  if (req.session.member) {
    if (req.session.member.right == 0) {
      return next()
    }
  }
  res.redirect('/')
}
// 非賣家使用 轉跳回首頁
const seller_render = function (req, res, next) {
  if (req.session.member) {
    if (req.session.member.right == 1) {
      return next()
    }
  }
  res.redirect('/')
}
const seller_api = function (req, res, next) {
  if (req.session.member) {
    if (req.session.member.right == 1) {
      return next();
    } else {
      res.end(JSON.stringify(new Error('滾')));
      return; 
    }
  }
  res.end(JSON.stringify(new Error('no permission')));
  return;  
}

// 非買家使用 轉跳回首頁
const buyer_render = function (req, res, next) {
  if (req.session.member) {
    if (req.session.member.right == 2) {
      return next()
    }
  }
  res.redirect('/')
}

module.exports = {
  admin_render,
  seller_render,
  seller_api,
  buyer_render,
}
