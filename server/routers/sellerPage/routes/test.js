// 數據提取
const extractData = (req, res, next) => {
    console.log('req.body', req.body);

    const { productData, prod_name, brand_id, category_id, transport, payment } = req.body;

    req.productData = {
        user_id: req.session.member.u_id,
        prod_name: productData.prod_name,
        brand_id: productData.brand_id,
        category_id: productData.category_id,
        transport: productData.transport,
        payment: productData.payment,
    };

    req.mainImageIdx = Number(req.body.mainImageIdx);
    req.specData = {
        cpu: productData.cpu,
        gpu: productData.gpu,
        // ... (其他 specData 屬性)
    };

    next();
};

// 商品資料插入
const insertProductData = async (req, res, next) => {
    try {
        const results = await dbQuery('INSERT INTO product SET ?', req.productData);
        req.prodId = results.insertId;
        next();
    } catch (error) {
        handleDbError(error, res);
    }
};

// 圖片數據處理和插入
const processAndInsertImages = async (req, res, next) => {
    try {
        const DEFAULT_IMAGE_PATH = '../images/products/defaultImage.jpg';
        let imagesData = [];

        if (req.files && req.files.length > 0) {
            imagesData = req.files.map((file, idx) => {
                let relativePath
                if (file.path) {
                    relativePath = getRelativePath(file.path)
                }
                return {
                    prod_id: prodId,
                    spec_id: 10,
                    originalname: file.originalname,
                    stored_name: file.filename,
                    filename: file.filename,
                    upload_date: new Date(),
                    file_size: file.size,
                    mime_type: file.mimetype,
                    // img_src: relativePath,
                    img_src: '../images/products/' + file.filename,
                    // products_info: mainImageIdx === idx ? 0 : 1,
                    type: mainImageIdx === idx ? 0 : 1,
                }
            })

        } else {
            // 如果沒有上傳圖片，使用預設圖片
            imagesData.push({
                prod_id: prodId,
                spec_id: 10,
                originalname: 'defaultImage.jpg',
                stored_name: 'defaultImage.jpg',
                filename: 'defaultImage.jpg',
                upload_date: new Date(),
                file_size: '999', // defaultData
                mime_type: 'image/jpeg',
                img_src: DEFAULT_IMAGE_PATH,
                // products_info: 0, // defaultPic
                type: 0, // defaultPic})
            })
        }

        const imgInsertPromises = imagesData.map(imgData => {
            return dbQuery('INSERT INTO productimg SET ?', imgData);
        });

        await Promise.all(imgInsertPromises);
        next();
    } catch (error) {
        handleDbError(error, res);
    }
};

// 插入銷售規格
const insertSellingSpecs = async (req, res, next) => {
    try {
        const sellSpecData = {
            prod_id: prodId,
            spec_id: '10',
            spec_name: spec_name,
            contnet: description,
            price: price,
            cpu,
            gpu,
            ram,
            os,
            screen,
            battery,
            warranty,
            size,
            weight,
            publish: publishValue,
            stock: quantityValue,
        };

        await dbQuery('INSERT INTO sellspec SET ?', sellSpecData);
        next();
    } catch (error) {
        handleDbError(error, res);
    }
};

// 回應客戶端
const sendResponse = (req, res) => {
    res.json({
        success: true,
        message: 'Product, images, and tags added successfully!',
    });
};

// 最後，組合所有的中間件和函式
exports.createProduct = [
    extractData,
    insertProductData,
    processAndInsertImages,
    insertSellingSpecs,
    sendResponse
];
