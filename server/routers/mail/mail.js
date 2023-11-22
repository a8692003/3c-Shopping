require('dotenv').config()
const express = require('express')
const router = express.Router()
const nodemailer = require('nodemailer')

router.use('/server/send', async (req, res, next) => {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.GMAIL_USER,
      pass: process.env.GMAIL_PASS,
    },
  })

  const mailOptions = {
    from: process.env.GMAIL_USER,
    to: 'a41.aa9839@gmail.com',
    subject: '這是信件的主旨',
    text: '這是信件的內容',
  }

  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      console.error(err)
      res.status(500).send('Error sending email')
    } else {
      console.log(info)
      res.send('Email sent')
    }
  })
})

module.exports = router
