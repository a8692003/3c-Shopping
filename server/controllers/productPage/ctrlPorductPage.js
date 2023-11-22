const db = require("../../models/productPage/productData.js");
//init
let filter = `ORDER BY ""`;
let getPriceRange = {
  form: 0,
  to: 999999,
};
let prodItemPage = 1;
let productItem = 12;
let offset = (prodItemPage - 1) * productItem;
exports.ctrlProdPage = (req, res) => {
  //ctrl req brand
  if (req.params.brand) {
    getBrand = req.params.brand;
    randerProdTag = false;
  }
  //module db
  //brand
  db.getBrandData([], (brandData) => {
    //product
    db.getprodItemData(
      [
        getBrand,
        getPriceRange.form,
        getPriceRange.to,
        offset,
        productItem,
        filter,
      ],
      (productData) => {
        //productItem total (Number)
        db.getAllProdItemNumData(
          [getBrand, getPriceRange.form, getPriceRange.to],
          (productTotalData) => {
            let lastPage = Math.ceil(
              productTotalData[0].productTotal / productItem
            );

            res.render("productPage/productPage.ejs", {
              getUserBrand: getBrand,
              brand: brandData,
              product: productData,
              lastPage: lastPage,
              userId: req.session.member ? req.session.member.u_id : null,
              setting: req.session.setting,
              randomProd: true,
            });
          }
        );
      }
    );
  });
};
