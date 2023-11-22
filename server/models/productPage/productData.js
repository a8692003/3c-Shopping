const mysql = require("mysql");
const sqlConn = require("../../config/db");

const Setting = require("../../config/config");

exports.getBrandData = (setCondition, callBackData) => {
  var connection = mysql.createConnection(Setting.db_setting);
  connection.connect((err) => {
    if (err) {
      console.log("sql syntax error");
      console.log(err);
    }
  });
  connection.query("SELECT brand_id,brand,img FROM brand", (err, data) => {
    if (err) {
      console.log(err);
    } else {
      callBackData(data);
    }
  });
  connection.end();
};
// sqlDB.getBrandData([], (data) => {
//   console.log(data);
// });
exports.getprodItemData = (setCondition, callBackData) => {
  var connection = mysql.createConnection(Setting.db_setting);
  connection.connect((err) => {
    if (err) {
      console.log("sql syntax error");
      console.log(err);
    }
  });
  let filter = setCondition[5];
  setCondition.pop();
  connection.query(
    `SELECT * FROM vw_products_info
        WHERE brand_id=? AND vw_products_info.publish=1 AND price BETWEEN ? AND ?
        ${filter}
        LIMIT ?,?;`,
    setCondition,
    (err, data) => {
      if (err) {
        console.log(err);
      } else {
        callBackData(data);
      }
    }
  );
  connection.end();
};
// sqlDB.getprodItemData(
//   [
//     getBrand,
//     getPriceRange.form,
//     getPriceRange.to,
//     filter,
//     offset,
//     productItem,
//   ],
//   (data) => {
//     console.log(data);
//   }
// );
exports.getAllProdItemNumData = (setCondition, callBackData) => {
  const connection = mysql.createConnection(Setting.db_setting);
  connection.connect((err) => {
    if (err) {
      console.log("sql syntax error");
      console.log(err);
    }
  });
  connection.query(
    `SELECT COUNT(*) as productTotal FROM vw_products_info
        WHERE brand_id=? AND vw_products_info.publish=1 AND price BETWEEN ? AND ?`,
    setCondition,
    (err, data) => {
      if (err) {
        console.log(err);
      } else {
        callBackData(data);
      }
    }
  );
  connection.end();
};
// sqlDB.getAllProdItemNumData(
//   [getBrand, getPriceRange.form, getPriceRange.to],
//   (data) => {
//     console.log(data);
//   }
// );
exports.getTagprodItemData = (setCondition, callBackData) => {
  var connection = mysql.createConnection(Setting.db_setting);
  connection.connect((err) => {
    if (err) {
      console.log("sql syntax error");
      console.log(err);
    }
  });
  let filter = setCondition[6];
  setCondition.pop();
  let tag = setCondition[0];
  setCondition.shift();
  connection.query(
    `SELECT * FROM product_tag
    RIGHT join vw_products_info ON product_tag.prod_id = vw_products_info.prod_id
    WHERE ${tag} vw_products_info.brand_id=? AND vw_products_info.publish=1 AND vw_products_info.price BETWEEN ? AND ?
   ${filter}
    LIMIT ?,?`,
    setCondition,
    (err, data) => {
      if (err) {
        console.log(err);
      } else {
        callBackData(data);
      }
    }
  );
  connection.end();
};
// sqlDB.getTagprodItemData(
//   [
//     prodSelTag,
//     getPriceRange.form,
//     getPriceRange.to,
//     filter,
//     offset,
//     productItem,
//   ],
//   (data) => {
//     console.log(data);
//   }
// );
exports.getAllTagProdItemNumData = (setCondition, callBackData) => {
  var connection = mysql.createConnection(Setting.db_setting);
  connection.connect((err) => {
    if (err) {
      console.log("sql syntax error");
      console.log(err);
    }
  });
  let tag = setCondition[0];
  setCondition.shift();
  connection.query(
    `SELECT COUNT(*) as productTagTotal FROM product_tag
    RIGHT join vw_products_info ON product_tag.prod_id = vw_products_info.prod_id
    WHERE ${tag} vw_products_info.brand_id=? AND vw_products_info.publish=1 AND vw_products_info.price BETWEEN ? AND ?`,
    setCondition,
    (err, data) => {
      if (err) {
        console.log(err);
      } else {
        callBackData(data);
      }
    }
  );
  connection.end();
};
// sqlDB.getAllTagProdItemNumData(
//   [prodSelTag, getPriceRange.form, getPriceRange.to],
//   (data) => {
//     console.log(data);
//   }
// );
exports.productModels = {
  getAllProduct: async () => {
    const sql = "SELECT * FROM vw_products_info";
    const data = await sqlConn.queryAsync(sql);
    return data;
  },
  hdSelProd: async (req, res) => {
    req = `%${req}%`;
    const sql = `SELECT prod,prod_id,spec_id,prod_name,spec_name from (
      SELECT concat(prod_name,spec_name) as prod ,prod_id,spec_id,prod_name,spec_name  FROM vw_products_info 
          ) as info
          WHERE prod LIKE ? 
          LIMIT 5 OFFSET 0`;
    const data = await sqlConn.queryAsync(sql, req);
    return data;
  },
};
