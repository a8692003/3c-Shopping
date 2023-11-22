const express = require('express')

const prodItem = require('../../controllers/productPage/changeProductItem')
const fontPage = require('../../controllers/fontPage/ctrlFontPage')
const {
  login_render,
  login_api,
  notlogin_render,
  notlogin_api,
} = require('../../middlewares/isLogin')
var db = require('../../models/fontPage/db')

const router = express.Router()

//font page
router.get('/', (req, res) => {
  fontPage.fontPage(req, res)
})

router.get('/prod', (req, res) => {
  prodItem.productItem(req, res)
})

router.get('/product', (req, res) => {})

// 獲取熱銷商品
router.get('/getHotIndexProd', function (req, res) {
  var query =
    'SELECT * FROM vw_products_info WHERE publish != 0 AND inventory > 0 ORDER BY sales DESC ,update_time DESC LIMIT 8'
  db.query(query, function (err, result) {
    if (err) {
      console.error(err)
      res.status(500).json({ error: '資料讀取失敗。' })
    } else {
      res.status(200).json(result)
    }
  })
})

// 獲取學生開學季商品
router.get('/getStudentIndexProd', function (req, res) {
  var query =
    'SELECT * FROM vw_products_info LEFT JOIN product_tag ON vw_products_info.prod_id = product_tag.prod_id WHERE publish != 0 AND inventory > 0 AND tag = 6 ORDER BY sales DESC LIMIT 3'
  db.query(query, function (err, result) {
    if (err) {
      console.error(err)
      res.status(500).json({ error: '資料讀取失敗。' })
    } else {
      res.status(200).json(result)
    }
  })
})

// 獲取電競機商品
router.get('/getGamingIndexProd', function (req, res) {
  var query =
    'SELECT * FROM vw_products_info LEFT JOIN product_tag ON vw_products_info.prod_id = product_tag.prod_id WHERE publish != 0 AND inventory > 0 AND tag = 3 ORDER BY sales DESC LIMIT 3'
  db.query(query, function (err, result) {
    if (err) {
      console.error(err)
      res.status(500).json({ error: '資料讀取失敗。' })
    } else {
      res.status(200).json(result)
    }
  })
})

// 加入最愛
router.post('/postFavoriteProd', function (req, res) {
  var user_id = req.session.member ? req.session.member.u_id : null
  var prod_id = req.body.prod_id
  var spec_id = req.body.spec_id
  var query = 'INSERT INTO collect (user_id,prod_id, spec_id)VALUES(?,?,?)'
  db.query(query, [user_id, prod_id, spec_id], function (err, result) {
    if (err) {
      console.error(err)
      res.status(500).json({ error: '資料讀取失敗。' })
    } else {
      res.status(200).json(result)
    }
  })
})

// 移除最愛
router.delete('/deleteFavoriteProd', function (req, res) {
  var user_id = req.session.member ? req.session.member.u_id : null
  var prod_id = req.body.prod_id
  var spec_id = req.body.spec_id
  var query = 'DELETE FROM collect WHERE user_id = ? AND prod_id = ? AND spec_id = ?'
  db.query(query, [user_id, prod_id, spec_id], function (err, result) {
    if (err) {
      console.error(err)
      res.status(500).json({ error: '資料讀取失敗。' })
    } else {
      res.status(200).json(result)
    }
  })
})

// 渲染已經加入最愛的商品
router.get('/getFavoriteProd', login_api, function (req, res) {
  var query = 'SELECT * FROM collect WHERE user_id = ?'
  db.query(query, [req.session.member.u_id], function (err, result) {
    if (err) {
      console.error(err)
      res.status(500).json({ error: '資料讀取失敗。' })
    } else {
      res.status(200).json(result)
    }
  })
})

// 渲染已經加入購物車的商品
router.get('/getCartProd', login_api, function (req, res) {
  var query = 'SELECT * FROM shopcart WHERE user_id = ?'
  db.query(query, [req.session.member.u_id], function (err, result) {
    if (err) {
      console.error(err)
      res.status(500).json({ error: '資料讀取失敗。' })
    } else {
      res.status(200).json(result)
    }
  })
})

module.exports = router
