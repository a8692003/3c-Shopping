var express = require('express')
var router = express.Router()
var mysql = require('mysql')
const Setting = require('../../config/config')
const { login_render, login_api } = require('../../middlewares/isLogin')

var conn = mysql.createConnection(Setting.db_setting)

// 封裝資料庫查詢為 Promise
function queryDatabase(sql, params) {
  return new Promise((resolve, reject) => {
    conn.query(sql, params, (err, results) => {
      if (err) {
        reject(err)
      } else {
        resolve(results)
      }
    })
  })
}

// 通知
router.get('/', async (req, res) => {
  try {
    var userId = req.session.member ? req.session.member.u_id : null
    // console.log(userId);

    // 通知
    var orderDate = await queryDatabase(
      'SELECT order_id, order_date FROM `vw_order_info` WHERE state = 2 AND pay = 1 AND user_id = ?',
      [userId]
    )
    orderDate.forEach(date => {
      date.order_date = new Date(date.order_date).toLocaleString()
      date.order_id = String(date.order_id).padStart(8, '0')
    })
    return await res.render(
      `universal/notification.ejs`,
      {
        orderDate: orderDate,
      },
      (err, html) => standardResponse(err, html, res)
    )
  } catch (err) {
    console.error('Error:', err)
    res.status(500).send('Internal Server Error')
  }
})
const standardResponse = (err, html, res) => {
  // If error, return 500 page
  if (err) {
    console.log(err)
    // Passing null to the error response to avoid infinite loops XP
    return res
      .status(500)
      .render(`layout.ejs`, { page: '500', error: err }, (err, html) =>
        standardResponse(null, html, res)
      )
    // Otherwise return the html
  } else {
    return res.status(200).send(html)
  }
}

module.exports = router
