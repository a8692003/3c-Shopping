const db = require("../../models/productPage/productData");

let getBrand = "";
let filter = `ORDER BY ""`;
let setDESC = false;
let getPriceRange = {
  form: 0,
  to: 999999,
};
let prodSelTag = "";
exports.changeProduct = (req, res) => {
  let randerProdItme = false;
  let prodItemPage = 1;
  let productItem = 12;
  let offset = (prodItemPage - 1) * productItem;
  //ctrl req brand
  if (req.query.getBrand) {
    getBrand = Number(req.query.getBrand);
  }
  //ctrl req getUpdateTime & desc
  if (setDESC && filter.includes("update_time")) {
    filter = `ORDER BY vw_products_info.update_time DESC`;
    setDESC = false;
  } else if (setDESC && filter.includes("price")) {
    filter = `ORDER BY vw_products_info.price DESC`;
    setDESC = false;
  } else if (Number(req.query.getUpdateTime)) {
    filter = `ORDER BY vw_products_info.update_time`;
    setDESC = true;
  } else if (Number(req.query.getPriceDesc)) {
    filter = `ORDER BY vw_products_info.price`;
    setDESC = true;
  }
  //ctrl req PriceRange
  if (req.query.getPriceRange && !randerProdTag) {
    getPriceRange.form = req.query.getPriceRange.form;
    getPriceRange.to = req.query.getPriceRange.to;
  }
  if (getPriceRange.form == 0 && getPriceRange.to == 0) {
    getPriceRange.form = 0;
    getPriceRange.to = 999999;
  }
  //ctrl productItemPage
  if (req.query.prodItemPage) {
    prodItemPage = Number(req.query.prodItemPage);
    offset = (prodItemPage - 1) * productItem;
    randerProdItme = true;
  }
  //ctrl productTagItem
  if (req.query.prodSelTag && req.query.prodSelTag !== "") {
    prodSelTag = `product_tag.tag=${Number(req.query.prodSelTag)} AND`;
  }
  if (req.query.prodSelTag == "") {
    prodSelTag = "";
  }
  //module db
  db.getTagprodItemData(
    [
      prodSelTag,
      getBrand,
      getPriceRange.form,
      getPriceRange.to,
      offset,
      productItem,
      filter,
    ],
    (productData) => {
      db.getAllTagProdItemNumData(
        [prodSelTag, getBrand, getPriceRange.form, getPriceRange.to],
        async (productTotalData) => {
          let lastPage = Math.ceil(
            productTotalData[0].productTagTotal / productItem
          );
          if (randerProdItme) {
            return await res.render(
              `productPage/chageProduct.ejs`,
              {
                product: productData,
                randomProd: false,
              },
              (err, html) => standardResponse(err, html, res)
            );
          } else {
            return await res.render(
              `productPage/chageProdAndPage.ejs`,
              {
                getUserBrand: getBrand,
                product: productData,
                lastPage: lastPage,
                randomProd: false,
              },
              (err, html) => standardResponse(err, html, res)
            );
          }
        }
      );
    }
  );
  const standardResponse = (err, html, res) => {
    // If error, return 500 page
    if (err) {
      console.log(err);
      // Passing null to the error response to avoid infinite loops XP
      return res
        .status(500)
        .render(`layout.ejs`, { page: "500", error: err }, (err, html) =>
          standardResponse(null, html, res)
        );
      // Otherwise return the html
    } else {
      return res.status(200).send(html);
    }
  };
};
