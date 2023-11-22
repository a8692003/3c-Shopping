const mysql = require('mysql')
const Setting = require('../../../config/config')

const db = mysql.createPool(Setting.db_setting)

module.exports = db
