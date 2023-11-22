const MemberModel = require('../../models/memberPage/memberModel')

const MemberController = {
  dataRender: async (req, res) => {
    const p = req.query.p
    const r = req.query.r

    if ((p == 'google' || p == 'facebook') && (r == 'bind' || r == 'unbind' || r == 'cantuse')) {
      res.render('member/message', {
        title: '資料綁定',
        setting: req.session.setting,
        right: req.session.member.right,
        type: 0.5,
        content: `${p}${r == 'bind' ? '綁定' : r == 'unbind' ? '解除' : '，已被他人綁定'}`,
        btns: [{ linkTo: '/member/auth', linkText: '確 定' }],
        userId: req.session.member ? req.session.member.u_id : null,
      })
      return
    }

    const uid = req.session.member.u_id
    const result1 = await MemberModel.dataRender(uid)
    const result2 = await MemberModel.authRender(uid)

    if (result1.err == 0) {
      res.render('member/data', {
        title: '會員資料',
        setting: req.session.setting,
        right: req.session.member.right,
        type: 0,
        ...result1.data,
        ...result2.data,
        userId: req.session.member ? req.session.member.u_id : null,
      })
    } else {
      res.redirect('back')
    }
  },
  dataUpadteSucRender: (req, res) => {
    res.render('member/message', {
      title: '會員資料',
      setting: req.session.setting,
      content: `資料修改成功`,
      btns: [{ linkTo: '/member/data', linkText: '確 定' }],
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },

  dataUpdateAPI: async (req, res) => {
    try {
      const uid = req.session.member.u_id
      var result = await MemberModel.dataUpdateAPI(uid, req.body)
      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },

  authRender: async (req, res) => {
    const uid = req.session.member.u_id

    const p = req.query.p
    const r = req.query.r

    if ((p == 'google' || p == 'facebook') && (r == 'bind' || r == 'unbind' || r == 'cantuse')) {
      res.render('member/message', {
        title: '資料綁定',
        setting: req.session.setting,
        right: req.session.member.right,
        type: 0.5,
        content: `${p}${r == 'bind' ? '綁定' : r == 'unbind' ? '解除' : '，已被他人綁定'}`,
        btns: [{ linkTo: '/member/auth', linkText: '確 定' }],
        userId: req.session.member ? req.session.member.u_id : null,
      })
      return
    }

    const result = await MemberModel.authRender(uid)
    res.render('member/auth', {
      title: '資料綁定',
      setting: req.session.setting,
      right: req.session.member.right,
      type: 0.5,
      ...result.data,
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },

  pwdChangeRender: (req, res) => {
    res.render('member/pwdChange', {
      title: '修改密碼',
      setting: req.session.setting,
      right: req.session.member.right,
      type: 1,
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },

  pwdChangeSucRender: (req, res) => {
    let o_right = req.session.member.right
    delete req.session.member

    res.render('member/message', {
      title: '修改密碼',
      right: o_right,
      setting: req.session.setting,
      content: `密碼修改成功，請重新登入`,
      btns: [
        { linkTo: '/login', linkText: '重新登入' },
        { linkTo: '/', linkText: '前往首頁' },
      ],
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },

  pwdChangeAPI: async (req, res) => {
    try {
      const uid = req.session.member.u_id
      const result = await MemberModel.pwdChangeAPI(uid, req.body)
      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },

  cardRender: async (req, res) => {
    const uid = req.session.member.u_id
    const result = await MemberModel.cardRender(uid)

    res.render('member/cards', {
      title: '付款設定',
      right: req.session.member.right,
      setting: req.session.setting,
      type: 2,
      ...result.data,
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },

  addCradAPI: async (req, res) => {
    try {
      const uid = req.session.member.u_id
      const result = await MemberModel.addCradAPI(uid, req.body)
      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },
  editCardAPI: async (req, res) => {
    try {
      const uid = req.session.member.u_id
      const result = await MemberModel.editCardAPI(uid, req.body)
      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },
  deleteCardAPI: async (req, res) => {
    try {
      const uid = req.session.member.u_id

      const result = await MemberModel.deleteCardAPI(uid, req.body)
      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },

  orderlistRender: async (req, res) => {
    var page = req.params.page
    if (isNaN(page) || page <= 0) {
      res.redirect('/member/orderlist/1')
      return
    }
    const uid = req.session.member.u_id

    const result = await MemberModel.orderlistRender(uid, parseInt(page))

    if (page > result.data.max_pages) {
      res.redirect(`/member/orderlist/${result.data.max_pages}`)
      return
    }
    res.render('member/orderList', {
      title: '查看訂單',
      right: req.session.member.right,
      setting: req.session.setting,
      type: 3,
      page: page,
      ...result.data,
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },

  orderRender: async (req, res) => {
    const uid = req.session.member.u_id
    var order_id = req.params.order_id
    const result = await MemberModel.orderRender(uid, order_id)

    if (result.err == 1) {
      res.redirect('/member/orderlist')
    } else {
      res.render('member/order', {
        title: '訂單資料',
        right: req.session.member.right,
        setting: req.session.setting,
        type: 3,
        ...result.data,
        userId: req.session.member ? req.session.member.u_id : null,
      })
    }
  },
  cancelOrderAPI: async (req, res) => {
    try {
      const uid = req.session.member.u_id
      const order_id = req.body.order_id
      const result = await MemberModel.cancelOrderAPI(uid, order_id)

      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },

  collectRender: async (req, res) => {
    const uid = req.session.member.u_id
    var page = req.params.page
    if (isNaN(page) || page <= 0) {
      res.redirect('/member/collect/1')
      return
    }
    const result = await MemberModel.collectRender(uid, parseInt(page))
    if (page > result.data.max_pages) {
      res.redirect(`/member/collect/${result.data.max_pages}`)
      return
    }
    res.render('member/collect', {
      title: '收藏商品',
      right: req.session.member.right,
      userId: req.session.member ? req.session.member.u_id : null,
      setting: req.session.setting,
      type: 4,
      page: page,
      ...result.data,
    })
  },
  collectProdAPI: async (req, res) => {
    try {
      const uid = req.session.member.u_id
      const result = await MemberModel.collectProdAPI(uid, req.body.prod_id, req.body.spec_id)

      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },
  cartProdAPI: async (req, res) => {
    try {
      const uid = req.session.member.u_id
      const result = await MemberModel.cartProdAPI(uid, req.body.prod_id, req.body.spec_id)

      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },

  commentRender: async (req, res) => {
    const uid = req.session.member.u_id
    let page = req.params.page
    if (isNaN(page) || page <= 0) {
      res.redirect('/member/comment/1')
      return
    }
    const result = await MemberModel.commentRender(uid, parseInt(page))
    if (page > result.data.max_pages) {
      res.redirect(`/member/comment/${result.data.max_pages}`)
      return
    }
    res.render('member/comment', {
      title: '留言紀錄',
      right: req.session.member.right,
      setting: req.session.setting,
      type: 5,
      page: page,
      ...result.data,
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },
  commentEditRender: async (req, res) => {
    const uid = req.session.member.u_id
    const order_id = req.params.order_id || ''
    const prod_id = req.params.prod_id || ''
    const spec_id = req.params.spec_id || ''

    const result = await MemberModel.commentEditRender(uid, order_id, prod_id, spec_id)

    if (result.data.total == 0) {
      res.redirect('/member/comment')
    } else {
      res.render('member/commentEdit', {
        title: '留言紀錄',
        right: req.session.member.right,
        setting: req.session.setting,
        type: 5,
        ...result.data,
        userId: req.session.member ? req.session.member.u_id : null,
      })
      // res.setHeader('Content-type', 'text/html;charset=utf-8')
      // res.end(JSON.stringify(result))
    }
  },
  commentUpdateAPI: async (req, res) => {
    const uid = req.session.member.u_id
    try {
      const result = await MemberModel.commentUpdateAPI(uid, req.body)
      res.end(JSON.stringify(result))
    } catch (err) {
      throw err
    }
  },
  sellerRender: (req, res) => {
    res.render('member/seller', {
      title: '上架中心',
      right: req.session.member.right,
      setting: req.session.setting,
      type: 6,
      userId: req.session.member ? req.session.member.u_id : null,
    })
  },
}
module.exports = MemberController

// res.setHeader('Content-type', 'text/html;charset=utf-8')
// res.end(JSON.stringify(result))
