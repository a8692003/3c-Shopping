require('dotenv').config()

const express = require('express')
const router = express.Router()

const passport = require('passport')
const FacebookStrategy = require('passport-facebook')

const AuthController = require('../../../controllers/authController')
const JWT = require('../../../middlewares/jwt')

passport.use(
  new FacebookStrategy(
    {
      clientID: process.env.FACEBOOK_CILENTID,
      clientSecret: process.env.FACEBOOK_CLIENTSECRET,
      callbackURL: process.env.FACEBOOK_CALLBACKURL,
      profileFields: ['id', 'emails', 'name'],
    },
    (accessToken, refreshToken, profile, cb) => {
      return cb(null, profile)
    }
  )
)

passport.serializeUser(function (user, done) {
  done(null, user)
})

passport.deserializeUser(function (obj, done) {
  done(null, obj)
})

router.get(
  '/',
  JWT.createAndVerifyToken,
  passport.authenticate('facebook', {
    scope: ['email', 'public_profile'],
  })
)

router.get(
  '/callback',
  passport.authenticate('facebook', {
    session: true,
    successRedirect: '/auth/facebook/suc',
    failureRedirect: '/login',
  })
)

router.use('/suc', JWT.decodingAndVerifyToken, AuthController.facebookAuth)

module.exports = router
