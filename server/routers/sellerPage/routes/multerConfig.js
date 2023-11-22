const { request } = require('express')
const multer = require('multer')
const path = require('path')

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // cb(null, path.join(__dirname, '..', 'public', 'images', 'products'))
    cb(
      null,
      path.join(
        path.dirname('server', path.dirname(require.main.filename)),
        'public',
        'images',
        'products'
      )
    )
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname)
  },
})

const upload = multer({ storage: storage })

module.exports = upload
