const express = require('express')
const router = express.Router()
const productController = require('./productController')
const upload = require('./multerConfig')

router.get('/products', productController.getProducts)
router.get('/image', productController.getImage)
router.get('/downproducts', productController.getDownProducts)
router.put('/down/:productId/:specId', productController.updateProduct)
router.post('/createProduct', productController.createProduct)
router.get('/getProductsAllData/:prod_id/:spec_id', productController.getProductsAllData)
router.patch('/updateProductPartially/:prod_id/:spec_id', productController.partiallyUpdateProduct)
router.post(
  '/products/:prod_id/upload-image',
  upload.single('productImage'),
  productController.addProductImage
)

router.post(
  '/products/:prod_id/:spec_id/upload-image',
  upload.single('productImage'),
  productController.addProductImage
)

router.delete('/product-images/:imageId', productController.deleteProductImage)
router.post('/update-cover', productController.updateCoverImage)

module.exports = router
