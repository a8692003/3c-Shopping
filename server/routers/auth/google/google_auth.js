require('dotenv').config()

const express = require('express')
const router = express.Router()

const passport = require('passport')
const GoogleStrategy = require('passport-google-oauth20').Strategy

const AuthController = require('../../../controllers/authController')
const JWT = require('../../../middlewares/jwt')

passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CILENTID,
      clientSecret: process.env.GOOGLE_CLIENTSECRET,
      callbackURL: process.env.GOOGLE_CALLBACKURL,
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
  passport.authenticate('google', {
    scope: ['email', 'profile'],
  })
)

router.get(
  '/callback',
  passport.authenticate('google', {
    successRedirect: '/auth/google/suc',
    failureRedirect: '/login',
  })
)
router.use('/suc', JWT.decodingAndVerifyToken, AuthController.googleAuth)

module.exports = router
