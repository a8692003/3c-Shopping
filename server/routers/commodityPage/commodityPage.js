var express = require("express");
var router = express.Router();
var mysql = require("mysql");
const Setting = require("../../config/config");
const { login_render, login_api } = require("../../middlewares/isLogin");

var conn = mysql.createConnection(Setting.db_setting);

// 封裝資料庫查詢為 Promise
function queryDatabase(sql, params) {
  return new Promise((resolve, reject) => {
    conn.query(sql, params, (err, results) => {
      if (err) {
        reject(err);
      } else {
        resolve(results);
      }
    });
  });
}

// 定義路由處理程式
router.get("/", async (req, res) => {
  res.redirect("/product/:prodId/:specId");
});

// 商品詳細頁面
router.get("/:prodId/:specId", async (req, res) => {
  try {
    var prodId = req.params.prodId;
    var specId = req.params.specId;
    var brandId = req.params.brandId;
    var productData = {};
    var userId = req.session.member ? req.session.member.u_id : null;
    // console.log(userId)

    var data = await queryDatabase(
      "SELECT * FROM sellspec WHERE prod_id = ? AND spec_id = ?",
      [prodId, specId, brandId]
    );
    var imageDataT0 = await queryDatabase(
      "SELECT * FROM productimg WHERE prod_id = ? AND spec_id = ? AND type = 0",
      [prodId, specId]
    );
    var imageDataT1 = await queryDatabase(
      "SELECT * FROM productimg WHERE prod_id = ? AND spec_id = ? AND type = 1",
      [prodId, specId]
    );
    var nameData = await queryDatabase(
      "SELECT prod_name FROM product WHERE prod_id = ?",
      [prodId]
    );
    var brandData = await queryDatabase(
      "SELECT product.prod_id, product.brand_id, brand.brand FROM product JOIN brand ON product.brand_id = brand.brand_id WHERE prod_id = ?",
      [prodId]
    );
    var priceData = await queryDatabase(
      "SELECT price, stock FROM sellspec WHERE prod_id = ? AND spec_id = ?",
      [prodId, specId]
    );
    var totalCountData = await queryDatabase(
      "SELECT COUNT(*) AS COUNT FROM productimg"
    );
    var totalCount = totalCountData[0].COUNT;
    var relatedProducts = await queryDatabase(
      "SELECT * FROM productimg WHERE type = 0 ORDER BY RAND() LIMIT 8"
    );
    var commentData = await queryDatabase(
      "SELECT vw_comment.comment, vw_comment.comment_grade, vw_comment.comment_time, vw_comment.name, vw_comment.spec_name,user.photo FROM vw_comment JOIN user ON vw_comment.user_id = user.user_id WHERE prod_id = ? AND spec_id = ? AND comment_time IS NOT null",
      [prodId, specId]
    );
    commentData.forEach((comment) => {
      comment.comment_time = new Date(comment.comment_time).toLocaleString();
    });

    // 抓取賣出產品的數量
    var countData = await queryDatabase(
      "SELECT SUM(count) AS total_count FROM order_product WHERE prod_id = ? AND spec_id = ?",
      [prodId, specId]
    );

    var stock = priceData[0].stock;
    var totalSole = countData[0].total_count;
    var remainingStock = stock - totalSole;

    // 通知
    var orderDate = await queryDatabase(
      "SELECT order_id, order_date FROM `vw_order_info` WHERE state = 2 AND pay = 1 AND user_id = ?",
      [userId]
    );
    orderDate.forEach((date) => {
      date.order_date = new Date(date.order_date).toLocaleString();
      date.order_id = String(date.order_id).padStart(8, "0");
    });

    // 顯示tag
    var tagData = await queryDatabase(
      "SELECT tag.content FROM product_tag JOIN tag ON product_tag.tag = tag.tag WHERE product_tag.prod_id = ? ",
      [prodId]
    );

    // 排列相關產品
    // 使用 Promise.all 處理所有資料庫的查詢
    await Promise.all(
      relatedProducts.map(async (product) => {
        var prodId = product.prod_id;
        var specId = product.spec_id;

        var productNameData = await queryDatabase(
          "SELECT prod_name FROM product WHERE prod_id = ?",
          [prodId]
        );
        var productPriceData = await queryDatabase(
          "SELECT price FROM sellspec WHERE prod_id = ? AND spec_id = ?",
          [prodId, specId]
        );
        var productSpecname = await queryDatabase(
          "SELECT spec_name FROM sellspec WHERE prod_id =? AND spec_id = ?",
          [prodId, specId]
        );

        productData[prodId] = {
          prod_name: productNameData[0].prod_name,
          price: productPriceData[0].price,
          spec_name: productSpecname[0].spec_name,
        };
      })
    );
    res.render("commodityPage/index", {
      data,
      imageDataT0: imageDataT0[0],
      imageDataT1: imageDataT1,
      nameData,
      brandData,
      priceData,
      attributes: [
        "spec_name",
        "price",
        "cpu",
        "gpu",
        "ram",
        "os",
        "screen",
        "warranty",
        "size",
        "battery",
        "weight",
      ],
      totalCount: totalCount,
      relatedProducts: relatedProducts.map((product) => ({
        ...product,
        ...productData[product.prod_id],
      })),
      commentData,
      prodId,
      specId,
      orderDate,
      userId,
      setting: req.session.setting,
      countData,
      remainingStock,
      tagData,
    });
  } catch (err) {
    // console.error("Error:", err);
    res.status(500).send("Internal Server Error");
  }
});

// 加入購物車
router.post("/addcart", async (req, res) => {
  // console.log(req.body);
  // console.log(req.body);
  try {
    var { user_id, prod_id, spec_id } = req.body;
    // 判斷使用者是否登入
    if (!user_id) {
      return res.redirect("/login");
    }

    var spl =
      "INSERT INTO shopcart (user_id, prod_id, spec_id) VALUES (?, ?, ?)";
    await queryDatabase(spl, [user_id, prod_id, spec_id]);

    res.status(200).send("成功加入購物車");
  } catch (error) {
    // console.error("加入購物車失敗", error);
    res.status(500).send("內部伺服器錯誤");
  }
});

// 加入收藏
router.post("/addcollect", login_api, async (req, res) => {
  try {
    var { user_id, prod_id, spec_id } = req.body;
    var sqlcheck =
      "SELECT * FROM collect WHERE user_id = ? AND prod_id = ? AND spec_id = ?";
    const checkReasult = await queryDatabase(sqlcheck, [
      user_id,
      prod_id,
      spec_id,
    ]);

    if (checkReasult.length > 0) {
      res.status(200).json({ message: "商品已在收藏中" });
    } else {
      var sqlInsert =
        "INSERT INTO collect (user_id, prod_id, spec_id) VALUES (?, ?, ?)";
      await queryDatabase(sqlInsert, [user_id, prod_id, spec_id]);
      res.status(200).json({ message: "成功加入收藏" });
    }
  } catch (error) {
    // console.error("加入收藏失敗", error);
    res.status(500).send("內部伺服器錯誤");
  }
});

// 相關加入購物車
router.post("/addCart", async (req, res) => {
  try {
    var { user_id, prod_id, spec_id } = req.body;
    // 判斷使用者是否登入
    if (!user_id) {
      return res.redirect("/login");
    }
    var spl =
      "INSERT INTO shopcart (user_id, prod_id, spec_id) VALUES (?, ?, ?)";
    await queryDatabase(spl, [user_id, prod_id, spec_id]);

    res.status(200).send("成功加入購物車");
  } catch (error) {
    console.error("加入購物車失敗", error);
    res.status(500).send("內部伺服器錯誤");
  }
});

// 相關加入收藏
router.post("/addCollect", async (req, res) => {
  try {
    var { user_id, prod_id, spec_id } = req.body;
    // 判斷使用者是否登入
    if (!user_id) {
      return res.redirect("/login");
    }
    var sql =
      "INSERT INTO collect (user_id, prod_id, spec_id) VALUES (?, ?, ?)";
    await queryDatabase(sql, [user_id, prod_id, spec_id]);
    res.status(200).send("成功加入收藏");
  } catch (error) {
    console.error("加入收藏失敗", error);
    res.status(500).send("內部伺服器錯誤");
  }
});

// 直接購買 檢查購物車紀錄是否存在
router.post("/checkcart", async (req, res) => {
  try {
    var { user_id, prod_id, spec_id } = req.body;

    var spl =
      "SELECT COUNT(*) AS count FROM shopcart WHERE user_id = ? AND prod_id = ? AND spec_id = ?";
    var result = await queryDatabase(spl, [user_id, prod_id, spec_id]);

    if (result[0].count > 0) {
      res.status(200).json({ exists: true });
    } else {
      res.status(200).json({ exists: false });
    }
  } catch (error) {
    console.error("檢查購物車失敗", error);
    res.status(500).send("內部伺服器錯誤");
  }
});

module.exports = router;
