const express = require("express");
const cpp = require("../../controllers/productPage/ctrlPorductPage.js");
const router = express.Router();

router.get("/watchComparison", (req, res) => {
  res.render("productPage/watchComparison.ejs", {
    setting: req.session.setting,
    userId: req.session.member ? req.session.member.u_id : null,
  });
});

//product page
router.get("/:brand", cpp.ctrlProdPage);

module.exports = router;
