const conn = require('../config/db')
const { MemberData } = require('../config/user_data')
const { Success, Error } = require('../config/response')
const GoogleMail = require('../config/googleMail')

const AuthModel = {
  google: async data => {
    try {
      sql = 'select * from user where google_auth_id= ? '
      const result = await conn.queryAsync(sql, [data.id])

      if (result.length == 1) {
        var member_data = new MemberData(
          result[0].user_id,
          result[0].name,
          result[0].rights,
          result[0].verified,
          result[0].google_auth_mail || result[0].email,
          true
        )
        GoogleMail.loginMail(result[0].email, result[0].verified, true)
        return new Success({ type: 'login', member_data: member_data })
      } else if (result.length == 0) {
        sql =
          'INSERT INTO user(rights,acc,pwd,name,phone,email,verified,google_auth_id,google_auth_mail) VALUES(?,?,?,?,?,?,?,?,?);'
        const result = await conn.queryAsync(sql, [
          2,
          '',
          '',
          data.displayName,
          '',
          data.emails[0].value,
          1,
          data.id,
          data.emails[0].value,
        ])
        console.log(result.insertId)
        var member_data = new MemberData(
          result.insertId,
          data.displayName,
          2,
          1,
          data.emails[0].value,
          true
        )
        return new Success({ type: 'register', member_data: member_data })
        // return new Success('regester by google')
      } else {
        return new Error({})
      }
    } catch (err) {
      console.log(err)
    }
  },
  googleBind: async (uid, data) => {
    console.log('bind')
    try {
      sql1 = 'SELECT * FROM user WHERE google_auth_id = ? '
      const result1 = await conn.queryAsync(sql1, [data.id])

      if (result1.length == 0) {
        // 綁定
        sql2 =
          'UPDATE user SET 	verified = 1,	google_auth_id = ? ,google_auth_mail = ? WHERE user_id = ? '
        const result2 = await conn.queryAsync(sql2, [data.id, data.emails[0].value, uid])
        return new Success('bind')
      } else {
        if (result1[0].user_id == uid) {
          // 解除綁定
          // sql2 =
          //   'UPDATE user SET 	verified= 0,	google_auth_id = ? ,google_auth_mail = ? WHERE user_id = ? '
          // const result2 = await conn.queryAsync(sql2, [null, null, uid])
          // return new Success('unbind')
          return new Success('')
        } else {
          return new Error('cantuse')
        }
      }
    } catch (err) {
      throw err
      console.log(err)
    }
  },

  facebook: async data => {
    try {
      sql = 'select * from user where facebook_auth_id= ? '
      const result = await conn.queryAsync(sql, [data.id])

      if (result.length == 1) {
        var member_data = new MemberData(result[0].user_id, result[0].name, result[0].rights, true)
        return new Success({ type: 'login', member_data: member_data })
      } else if (result.length == 0) {
        sql =
          'INSERT INTO user(rights,acc,pwd,name,phone,email,verified,facebook_auth_id,facebook_auth_mail) VALUES(?,?,?,?,?,?,?,?,?);'
        const result = await conn.queryAsync(sql, [
          2,
          '',
          '',
          data.name.familyName + data.name.givenName,
          '',
          data.emails[0].value || '',
          1,
          data.id,
          data.emails[0].value || '',
        ])
        console.log(result.insertId)
        var member_data = new MemberData(
          result.insertId,
          data.name.familyName + data.name.givenName,
          2,
          1,
          data.emails[0].value,
          true
        )
        return new Success({ type: 'register', member_data: member_data })
        // return new Success('regester by fb')
      } else {
        return new Error({})
      }
    } catch (err) {
      console.log(err)
    }
  },
  facebookBind: async (uid, data) => {
    console.log('bind')
    try {
      sql1 = 'SELECT * FROM user WHERE facebook_auth_id = ? '
      const result1 = await conn.queryAsync(sql1, [data.id])

      if (result1.length == 0) {
        // 綁定
        sql2 =
          'UPDATE user SET 	verified = 1,	facebook_auth_id = ? ,facebook_auth_mail = ? WHERE user_id = ? '
        const result2 = await conn.queryAsync(sql2, [data.id, data.emails[0].value, uid])
        return new Success('bind')
      } else {
        if (result1[0].user_id == uid) {
          return new Success('')
        } else {
          return new Error('cantuse')
        }
      }
    } catch (err) {
      throw err
      console.log(err)
    }
  },
}
module.exports = AuthModel
