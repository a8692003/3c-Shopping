const bcrypt = require('bcrypt')
const conn = require('../../config/db')
const { MemberData } = require('../../config/user_data')
const { Success, Error } = require('../../config/response')
const GoogleMail = require('../../config/googleMail')
const { pwdVerify } = require('../../lib/dataVerify')

const LoginModel = {
  loginAPI: async data => {
    const { acc, pwd } = data
    try {
      sql =
        'SELECT * FROM user WHERE acc= ? OR (verified=1 AND google_auth_id IS NOT NULL AND google_auth_mail = ? )'
      const response = await conn.queryAsync(sql, [acc, acc])

      if (response.length == 1) {
        if (bcrypt.compareSync(pwd, response[0].pwd)) {
          var member_data = new MemberData(
            response[0].user_id,
            response[0].name,
            response[0].rights,
            response[0].verified,
            response[0].google_auth_mail || response[0].email,
            true
          )
          GoogleMail.loginMail(response[0].email, response[0].verified, true)

          return new Success(member_data)
        } else {
          GoogleMail.loginMail(response[0].email, response[0].verified, false)
          return new Error('帳號或密碼輸入錯誤')
          // return new Error('login failed')
        }
      } else {
        return new Error('帳號或密碼輸入錯誤')
        return new Error('login failed')
      }
    } catch (err) {
      throw err
      return new Error(err)
    }
  },
  logoutAPI: data => {
    return new Success(`user ${data.u_name} , logout`)
  },
  forgetPasswordSend: async data => {
    const { mail } = data
    try {
      sql = 'SELECT * FROM user WHERE email= ? AND verified = 1'
      const response = await conn.queryAsync(sql, [mail])
      console.log(response)
      if (response.length == 1) {
        GoogleMail.forgetPwdMail(response[0].user_id, response[0].email, response[0].verified)
      } else {
        return new Error('notfoun')
        return new Error('login failed')
      }
    } catch (err) {
      throw err
      return new Error(err)
    }
  },
  resetPasswordSend: async (data, uid) => {
    console.log(data)
    const { pwd, pwdCheck } = data

    if (!pwdVerify(pwd)) {
      return new Error('failed 1')
    } else if (pwd != pwdCheck) {
      return new Error('failed 2')
    }
    try {
      const hashPwd = bcrypt.hashSync(pwd, 10)
      console.log(hashPwd)

      sql = 'UPDATE user SET pwd = ? WHERE user_id =  ? '
      const response = await conn.queryAsync(sql, [hashPwd, uid])
      console.log(response)
      return new Success(response)
    } catch (err) {
      console.log(err)
      return new Error('failed 3')
    }
  },
}
module.exports = LoginModel
