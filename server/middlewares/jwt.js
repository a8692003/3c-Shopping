require('dotenv').config()
const jwt = require('jsonwebtoken')

const createAndVerifyToken = function (req, res, next) {
  const member = req.session.member
  const setting = req.session.setting

  const token = jwt.sign({ member: member, setting: setting }, process.env.JWT_TOKEN_KEY)

  res.cookie('jwt', token, { httpOnly: true, secure: false })
  next()
}

const decodingAndVerifyToken = function (req, res, next) {
  const token = req.cookies.jwt

  if (!token) {
    res.redirect('/')
    return
  } else {
    jwt.verify(token, process.env.JWT_TOKEN_KEY, (err, decoded) => {
      if (err) {
        console.log(err)
        return
      }
      console.log(decoded)
      const currentTimestamp = Math.floor(Date.now() / 1000)
      if (currentTimestamp >= decoded.iat) {
        // JWT is valid
        if (decoded.member) {
          req.session.member = decoded.member
        }
        if (decoded.setting) {
          req.session.setting = decoded.setting
        }
      } else {
        // JWT is not yet valid
        res.redirect('/')
        return
      }
    })
    next()
  }
}

module.exports = {
  createAndVerifyToken,
  decodingAndVerifyToken,
}
