const express = require("express");

var router = express.Router();

const RegisterController = require("../../controllers/memberPage/registerController");

// 註冊使用者
router.post("/", RegisterController.registerAPI);

// 註冊頁面 檢查 帳號是否已被用過
router.post("/duplicateAcc", RegisterController.duplicateAccAPI);

module.exports = router;
