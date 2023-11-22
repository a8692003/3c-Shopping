import React, { useState, useEffect } from 'react'
import axios from 'axios'
import PublishProduct from '../tools/PublishProduct'
import { API_ENDPOINTS } from '../contexts/constants'
import { Link } from 'react-router-dom'
function Downproducts() {
  const [product, setProduct] = useState(null)

  // 定義fetchProducts函數
  const fetchProducts = () => {
    axios
      .get(API_ENDPOINTS.DOWN_API)
      .then(response => {
        setProduct(response.data)
      })
      .catch(error => {
        console.error('Error fetching data: ', error)
      })
  }

  useEffect(() => {
    fetchProducts() // 使用fetchProducts函數
  }, [])

  // 如果資料還沒被取得，顯示載入訊息
  if (!product) return <div>Loading...</div>

  return (
    <div>
      <div className="top2 top2-b10px mt-3 top2-bgray" >
        <div>
          <div className="titlefont ">
            <span className="titlefont-blue">商品管理</span> / 下架商品
          </div>
        </div>
      </div>
      <div className="top2 top2-b10px mt-4 top2-bgray">
        <div className="col-12 gray1 titlefont-blue titlefont ">商品搜尋</div>
        <div className="col-12 titlefont d-flex align-items-center">
          名稱: 
          <input type="text" className="form-control me-3 ml-2 ms-1" style={{ width: 'auto' }} />
          <button className="butt1"> 搜尋</button>
        </div>

      </div>
      <div className="top2 top2-r10px mt-4">
        <div className="row text-center">
          <div className="col-2 titlefont">編號</div>
          <div className="col-2 titlefont">商品名稱</div>
          <div className="col-2 titlefont">商品圖片</div>
          <div className="col-2 titlefont">商品價格</div>
          <div className="col-2 titlefont">數量</div>
          <div className="col-2 titlefont">狀態</div>
        </div>
      </div>
      <div className="top2 top2-bgray">
        {product.length === 0 ? (
          // 這部分是當product長度為0時顯示的內容
          <div className="row text-center d-flex align-items-center">
            <b className="col-12 titlefont"> 目前沒有下架商品</b>
          </div>
        ) : (
          // 這部分是當product有內容時渲染的列表
          product.map((prodItem, index) => (
            <div key={index} className={index % 2 === 0 ? 'even-row' : 'odd-row'}>
              <div className="row text-center d-flex align-items-center">
                <div className="col-2 titlefont">{index + 1}</div>
                <div className="col-2 titlefont">
                  {prodItem.prod_name} <br />
                  {prodItem.spec_name}
                </div>
                <img
                  src={`public/${API_ENDPOINTS.LOCALHOST}/${prodItem.img_src}`}
                  className="col-2 titlefont"
                  alt=""
                />
                <div className="col-2 titlefont">{'NT$ ' + prodItem.price.toLocaleString()}</div>
                <div className="col-2 titlefont">{prodItem.stock.toLocaleString()}</div>

                <div className="col-2 titlefont">
                  <Link
                    to={`/products/edit/${prodItem.prod_id}/${prodItem.spec_id}`}
                    className="btn btn-success m-1"
                  >
                    修改
                  </Link>
                  <div className="btn btn-primary ">
                    <PublishProduct
                      productId={prodItem.prod_id}
                      specId={prodItem.spec_id}
                      fetchProducts={fetchProducts}
                      productName={prodItem.prod_name + prodItem.spec_name} />
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  )
}

export default Downproducts
