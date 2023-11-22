const express = require('express')
const path = require('path')
const bodyParser = require('body-parser')
// const cors = require('cors')

const db = require('./routes/database') // 引入資料庫連接模組
const brandRoutes = require('./routes/brandRoutes')
const categoryRoutes = require('./routes/categoryRoutes')
const productRoutes = require('./routes/productRoutes') // 引入路由模組
const tagRoutes = require('./routes/tagRoutes')
const router = express.Router()
// router.use(cors())
router.use(bodyParser.json())
// router.use(express.static(path.join(__dirname, 'public')))

router.use('/', brandRoutes)
router.use('/', categoryRoutes)
router.use('/', productRoutes) 
router.use('/', tagRoutes) 

router.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).send('Something broke!')
})

// const PORT = 2407;
// app.listen(PORT, () => {
//   console.log(`伺服器啟動中 ${PORT} ${new Date().toLocaleTimeString()}`);
//   console.log("------------------------------------");
//   console.log("------------------------------------");
//   console.log("------------------------------------");
//   console.log("------------------------------------");
// });
module.exports = router
