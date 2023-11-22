const mysql = require('mysql')
const bluebird = require('bluebird')
const Setting = require('./config')

var conn = mysql.createConnection(Setting.db_setting)
conn.connect(function (err) {
  if (err) {
    return
  }
})
bluebird.promisifyAll(conn)
module.exports = conn
