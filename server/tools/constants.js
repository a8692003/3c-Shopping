// API Endpoints
const BASE_URL = 'http://localhost:2407';
// 預設圖片的路徑
// export const defaultImage = '/server/public/images/testimg/defaultImg.jpg'; 
//...


export const API_ENDPOINTS = {
    LOCALHOST: BASE_URL,
    PRODUCT: `${BASE_URL}/products`,
    CREATE_PRODUCT: `${BASE_URL}/createProduct`,
    CATEGORY: `${BASE_URL}/category`,           // 假設您在`categoryRoutes`中有一個`/category`的路由
    BRAND: `${BASE_URL}/brand`,                 // 假設您在`brandRoutes`中有一個`/brand`的路由
    DOWN: `${BASE_URL}/down`,
    DOWN_API: `${BASE_URL}/downproducts`,
    // ... 其他API端點
};
