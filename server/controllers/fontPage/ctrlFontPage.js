const db = require("../../models/productPage/productData");

exports.fontPage = (req, res) => {
  db.getBrandData([], (bdata) => {
    res.render("fontPage/fontPage", {
      brand: bdata,
      setting: req.session.setting,
      userId: req.session.member ? req.session.member.u_id : null,
    });
  });
};
