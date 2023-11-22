const conn = require('../config/db')
const { MemberData } = require('../config/user_data')
const { Success, Error } = require('../config/response')
const VerifyModel = {
  verifyAcc: async (uid, mail) => {
    try {
      const sql1 = 'SELECT * FROM user WHERE user_id = ? AND email = ? '
      const result1 = await conn.queryAsync(sql1, [uid, mail])
      if (result1.length == 0) {
        return new Error('not found')
      }
      const sql2 = 'UPDATE user SET verified = 1 WHERE user_id = ? AND email = ?'
      const result2 = await conn.queryAsync(sql2, [uid, mail])
      return new Success(result2)
    } catch (err) {
      console.log(err)
    }
  },
}
module.exports = VerifyModel
