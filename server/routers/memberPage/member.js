var express = require('express')

var router = express.Router()
const { admin_render, seller_render, buyer_render } = require('../../middlewares/userRight')
const MemberController = require('../../controllers/memberPage/memberController')

router.get('/', function (req, res) {
  res.redirect('/member/data')
})

router.get('/data', MemberController.dataRender)
router.post('/data', MemberController.dataUpadteSucRender)

router.use('/auth', MemberController.authRender)

router.get('/password_change', MemberController.pwdChangeRender)
router.post('/password_change', MemberController.pwdChangeSucRender)

router.get('/cards', MemberController.cardRender)

router.get('/orderlist/', function (req, res) {
  res.redirect('/member/orderlist/1')
})
router.get('/orderlist/:page', MemberController.orderlistRender)

router.get('/order', function (req, res) {
  res.redirect('/member/orderlist/1')
})
router.get('/order/:order_id', MemberController.orderRender)

router.get('/collect/', function (req, res) {
  res.redirect('/member/collect/1')
})
router.get('/collect/:page', MemberController.collectRender)

router.get('/comment/', function (req, res) {
  res.redirect('/member/comment/1')
})
router.get('/comment/:page', MemberController.commentRender)

router.get('/comment/edit/:order_id', buyer_render, MemberController.commentEditRender)
router.get(
  '/comment/edit/:order_id/:prod_id/:spec_id',
  buyer_render,
  MemberController.commentEditRender
)
router.get('/seller', seller_render, MemberController.sellerRender)
router.use(function (req, res) {
  res.redirect('/member/data')
})
module.exports = router
