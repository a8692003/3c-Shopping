const express = require('express')

var router = express.Router()

router.get('/darkMode', function (req, res) {
  req.session.setting.darkmode = !req.session.setting.darkmode
  res.send({ change: req.session.setting.darkmode })
})

module.exports = router
