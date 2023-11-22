const RegisterModel = require("../../models/memberPage/registerModel");

const RegisterController = {
  registerSucRender: async (req, res) => {
    const result = await RegisterModel.registerSucRender(req.body.acc);
    if (result.err == 0) {
      res.render("member/message", {
        title: "註冊帳號",
        setting: req.session.setting,
        content: `${result.message}，成功註冊`,
        btns: [{ linkTo: "/login", linkText: "馬上登入" }],
        userId: req.session.member ? req.session.member.u_id : null,
      });
    } else {
      res.render("member/message", {
        title: "註冊帳號",
        setting: req.session.setting,
        content: `註冊失敗`,
        btns: [{ linkTo: "/register", linkText: "重新註冊" }],
        userId: req.session.member ? req.session.member.u_id : null,
      });
    }
  },
  registerAPI: async (req, res) => {
    console.log(req.body);
    const result = await RegisterModel.registerAPI(req.body);
    console.log(result);
    res.end(JSON.stringify(result));
  },
  duplicateAccAPI: async (req, res) => {
    const acc = req.body.acc;
    const result = await RegisterModel.duplicateAccAPI(acc);
    res.end(JSON.stringify(result));
  },
};
module.exports = RegisterController;
