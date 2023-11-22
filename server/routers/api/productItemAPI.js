const express = require('express')
const mysql = require('mysql')

const cpp = require('../../controllers/productPage/changeProductItem')
const hsp = require('../../controllers/ctrlHdSelProd.js')
const Setting = require('../../config/config')

var router = express.Router()
let conn = mysql.createConnection(Setting.db_setting)

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

router.get('/', (req, res) => {
  cpp.changeProduct(req, res)
  //res string
})

//product comparison
router.get('/prodComparison', async (req, res) => {
  try {
    let prodId = req.query.prod_id
    let specId = req.query.spec_id
    let specProdData = await queryDatabase(
      `SELECT vw_products_detail.prod_id,vw_products_detail.spec_id,vw_products_detail.prod_name,
      vw_products_detail.spec_name,vw_products_detail.brand,vw_products_detail.cpu,vw_products_detail.gpu,vw_products_detail.ram,
      vw_products_detail.os,vw_products_detail.screen,vw_products_detail.battery,vw_products_detail.size,vw_products_detail.weight,
      vw_products_detail.warranty,productimg.dir,productimg.filename,vw_products_info.price  FROM vw_products_detail
      RIGHT JOIN productimg ON vw_products_detail.prod_id=productimg.prod_id AND vw_products_detail.spec_id = productimg.spec_id
      RIGHT JOIN vw_products_info ON vw_products_detail.prod_id=vw_products_info.prod_id AND vw_products_detail.spec_id = vw_products_info.spec_id
      where vw_products_detail.prod_id=? AND vw_products_detail.spec_id= ? AND type=0`,
      [prodId, specId]
    )
    res.send(specProdData)
  } catch (err) {
    console.error(err)
  }
})

//header select tool
router.get('/search', hsp.herderSelProd)

module.exports = router
