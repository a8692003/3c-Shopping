const express = require('express')
var router = express.Router()

const passport = require('passport')

router.use(passport.initialize())
router.use(passport.session())

const google = require('./google/google_auth')
router.use('/google', google)

const facebook = require('./facebook/facebook_auth')
router.use('/facebook', facebook)

module.exports = router
