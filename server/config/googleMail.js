require('dotenv').config()
const nodemailer = require('nodemailer')
const jwt = require('jsonwebtoken')

const loginMail = function async(mail, verified, suc = true) {
  if (verified == 0) {
    return
  }
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.GMAIL_USER,
      pass: process.env.GMAIL_PASS,
    },
  })

  const mailOptions = {
    from: process.env.GMAIL_USER,
    to: mail,
    subject: suc ? 'ComBuy - 已成功登入' : 'ComBuy - 登入失敗',
    text: suc ? '你已成功登入 ComBuy - 3C 選購網站' : '登入失敗 ComBuy - 3C 選購網站',
  }

  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      console.error(err)
      // res.status(500).send('Error sending email')
      return
    } else {
      console.log(info)
      // res.send('Email sent')
    }
  })
}

const checkAccMail = function async(uid, mail) {
  const token = jwt.sign(
    { user_id: uid, mail: mail, type: 'verifyAcc' },
    process.env.JWT_TOKEN_KEY,
    {
      expiresIn: 600,
    }
  )

  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.GMAIL_USER,
      pass: process.env.GMAIL_PASS,
    },
  })

  const mailOptions = {
    from: process.env.GMAIL_USER,
    to: mail,
    subject: 'ComBuy - 新帳號註冊',
    // text: '你已成功登入ComBuy',
    html: `<p>
      請在 10 分鐘內點擊以下連結來驗證帳號
      <br/>
      若您未使用過本網站進行註冊，請忽略此信進。
    </p>
    <a href="http://localhost:2407/verify/account?t=${token}">前往驗證</a>`,
  }

  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      console.error(err)
      // res.status(500).send('Error sending email')
      return
    } else {
      console.log(info)
      // res.send('Email sent')
    }
  })
}

const forgetPwdMail = function async(uid, mail, verified) {
  if (verified == 0) {
    return
  }
  const token = jwt.sign(
    { user_id: uid, mail: mail, type: 'forgetPwd' },
    process.env.JWT_TOKEN_KEY,
    {
      expiresIn: 600,
    }
  )

  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.GMAIL_USER,
      pass: process.env.GMAIL_PASS,
    },
  })

  const mailOptions = {
    from: process.env.GMAIL_USER,
    to: mail,
    subject: 'ComBuy - 忘記密碼申請',
    // text: '你已成功登入ComBuy',
    html: `<p>
      請在 10 分鐘內點擊以下連結來進行密碼設置
      <br/>
      若您未使用過本網站進行忘記密碼申請，請忽略此信進。
    </p>
    <a href="http://localhost:2407/login/resetPassword?t=${token}">前往驗證</a>`,
  }

  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      console.error(err)
      // res.status(500).send('Error sending email')
      return
    } else {
      console.log(info)
      // res.send('Email sent')
    }
  })
}

module.exports = {
  loginMail,
  checkAccMail,
  forgetPwdMail,
}
