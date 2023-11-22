var mysql = require('mysql')
const Setting = require('../../config/config')

// module 被省略掉了
// 如果物件沒有 exec 屬性，就會立刻馬上被執行
// 當前新增的值是箭頭函式
exports.exec = (sql, data, callback) => {
  var connection = mysql.createConnection(Setting.db_setting)
  connection.connect()

  connection.query(sql, data, function (error, results, fields) {
    if (error) {
      console.log(error)
      callback(error, null)
    }
    callback(null, results, fields)
  })
  connection.end()
}
