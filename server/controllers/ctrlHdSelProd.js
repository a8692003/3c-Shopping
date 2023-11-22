const db = require("../models/productPage/productData");
exports.herderSelProd = async (req, res) => {
  res.send(await db.productModels.hdSelProd(req.query.search));
};
