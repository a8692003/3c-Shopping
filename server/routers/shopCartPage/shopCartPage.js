var express = require("express");
var router = express.Router();
var db = require("../../models/shopCartPage/db");
const { login_render, login_api } = require("../../middlewares/isLogin");

router.get("/", login_render, (req, res) => {
  res.render("shopCartPage/shopCart", {
    setting: req.session.setting,
    userId: req.session.member ? req.session.member.u_id : null,
  });
});

// 獲取商品
router.get("/getProd", function (req, res) {
  var query = "Call user_shopcart(?)";
  db.query(query, [req.session.member.u_id], function (err, result) {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "資料讀取失敗。" });
    } else {
      res.status(200).json(result);
    }
  });
});
// 獲取購買人的地址
router.get("/getUser", function (req, res) {
  console.log(req.session.member.u_id);
  var query = "SELECT * FROM user where user_id = ?";
  db.query(query, [req.session.member.u_id], function (err, result) {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "資料讀取失敗。" });
    } else {
      res.status(200).json(result);
    }
  });
});
// 獲取信用卡資訊
router.get("/getUserCards", function (req, res) {
  var query = "Call user_cards(?)";
  db.query(query, [req.session.member.u_id], function (err, result) {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "資料讀取失敗。" });
    } else {
      res.status(200).json(result);
    }
  });
});

// 把購買者購買的商品傳送回資料庫
router.post("/postorder_product", function (req, res) {
  var prod_id = req.body.prod_id;
  var spec_id = req.body.spec_id;
  var price;
  var count = req.body.count;
  var order_id = req.body.order_id;

  const sql = "SELECT price FROM sellspec WHERE prod_id = ? AND spec_id = ?";
  db.query(sql, [prod_id, spec_id], function (err, result) {
    if (err) {
      res.status(500).json({ error: "查無資料" });
    }
    price = result[0].price;
    var query =
      "INSERT INTO order_product (order_id,prod_id,spec_id,price,count) VALUES(?,?,?,?,?)";
    db.query(
      query,
      [order_id, prod_id, spec_id, price, count],
      function (err, result) {
        if (err) {
          console.error(err);
          res.status(500).json({ error: "傳送資料失敗。" });
        } else {
          res.status(200).json({ insertId: result.insertId });
        }
      }
    );
  });
});

// 把購買者的地址傳送回資料庫
router.post("/postUserAddress", function (req, res) {
  var user_id = req.session.member.u_id;
  var recipient = req.body.recipient;
  var recipient_address = req.body.recipient_address;
  var recipient_phone = req.body.recipient_phone;
  var pay_method = req.body.pay;

  var query =
    "INSERT INTO orders (user_id,recipient,recipient_address,recipient_phone,pay_method) VALUES(?,?,?,?,?)";
  db.query(
    query,
    [user_id, recipient, recipient_address, recipient_phone, pay_method],
    function (err, result) {
      if (err) {
        console.error(err);
        res.status(500).json({ error: "傳送資料失敗。" });
      } else {
        console.log(result);
        res.status(200).json(result);
      }
    }
  );
});

// 把購買者的地址放進訂單資訊頁面
router.post("/getOrderList", function (req, res) {
  var query = "Call user_orderList(?)";
  db.query(query, [req.session.member.u_id], function (err, result) {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "資料讀取失敗。" });
    } else {
      res.status(200).json(result);
    }
  });
});

// 把已下單的商品放進訂單資訊頁面

router.post("/getOrderProduct", function (req, res) {
  var getLatestOrderQuery =
    "SELECT MAX(order_id) AS latest_order_id FROM order_product";
  db.query(getLatestOrderQuery, function (err, result) {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "資料讀取失敗。" });
    } else {
      var latestOrderId = result[0].latest_order_id;

      var getOrderQuery = "CALL `user_order`(?, ?)";
      db.query(
        getOrderQuery,
        [req.session.member.u_id, latestOrderId],
        function (err, result) {
          if (err) {
            console.error(err);
            res.status(500).json({ error: "資料讀取失敗。" });
          } else {
            res.status(200).json(result);
          }
        }
      );
    }
  });
});

// 刪除購物車的商品
router.get("/delProd", function (req, res) {
  var prod_id = req.query.prod_id;
  // var user_id = req.query.user_id;
  var user_id = req.session.member.u_id;
  var spec_id = req.query.spec_id;
  console.log(
    "Received delete request for prod_id:",
    prod_id,
    "user_id:",
    user_id,
    "spec_id:",
    spec_id
  );

  var query =
    "DELETE FROM shopcart WHERE prod_id = ? and user_id = ? and spec_id = ?";
  db.query(query, [prod_id, user_id, spec_id], function (err, result) {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "資料讀取失敗。" });
    } else {
      res.status(200).json(result);
    }
  });
});

// 更新訂單完成 / 已付款
router.post("/postState", function (req, res) {
  const sql = `
            UPDATE orders
            SET state = ?, pay = ?
            WHERE order_id = ?;
            `;
  db.query(sql, [2, 1, req.body.order_id], function (err, result) {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "資料讀取失敗。" });
    } else {
      res.status(200).json(result);
    }
  });
});

router.get("/orderPage", (req, res) => {
  res.render("orderPage/orderPage.ejs", {
    setting: req.session.setting,
    userId: req.session.member ? req.session.member.u_id : null,
  });
});

module.exports = router;
