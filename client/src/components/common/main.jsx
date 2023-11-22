import React, { useState, useEffect } from 'react'
import axios from 'axios'
import MainButton from '../tools/main_button'
import { API_ENDPOINTS } from '../contexts/constants'
import { Link } from 'react-router-dom'
import Swal from 'sweetalert2';
function Main() {
  const [product, setProduct] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchProducts = () => {
    setIsLoading(true);
    setError(null);

    axios
      .get(API_ENDPOINTS.PRODUCT)
      .then(response => {
        setProduct(response.data);
        setIsLoading(false);
      })
      .catch(error => {
        console.error('Error fetching data: ', error);

        // 打印整個 error 物件，以及 error.response 的內容
        console.log('Complete Error:', error);
        if (error.response) {
          console.log('Error Response:', error.response);
          console.log('Error Status:', error.response.status);
        }

        setIsLoading(false);
        setError(error);

        // 檢查伺服器的回應是否為 401 (未授權)
        if (error.response && error.response.status === 401) {
          console.log("401 detected!");
          Swal.fire({
            title: '未授權!',
            text: '請先登入才能訪問此頁面。',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '去登入',
            cancelButtonText: '取消'
          }).then((result) => {
            if (result.isConfirmed) {
              window.location.href = API_ENDPOINTS.LOGING_PAGE;
            }
          });
        }
      });

  }

  useEffect(() => {
    fetchProducts();
  }, []);

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  const notPublishedProducts = Array.isArray(product) ? product.filter(prod => prod.publish === 1) : [];
  return (
    <div>
      <div className="top2 top2-b10px mt-3 top2-bgray">
        <div >
          <div className="titlefont ">
            <span className="titlefont-blue">商品管理</span> / 商品列表
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
      <div className="top2 top2-bgray ">
        {notPublishedProducts.length === 0 ? (
          <div className="row text-center d-flex align-items-center">
            <b className="col-12 titlefont">目前沒有上架商品</b>
          </div>
        ) : (
          notPublishedProducts.map((prodItem, index) => (
            <div key={index} className={index % 2 === 0 ? 'even-row' : 'odd-row'}>
              <div className="row text-center d-flex align-items-center">
                <div className="col-2 titlefont">{index + 1}</div>
                <div className="col-2 titlefont">
                  {prodItem.prod_name}
                  <br />
                  {prodItem.spec_name}
                </div>
                <img
                  src={`/public${API_ENDPOINTS.LOCALHOST}/${prodItem.img_src}`}
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
                  <div className="btn btn-danger">
                    <MainButton
                      productId={prodItem.prod_id}
                      specId={prodItem.spec_id}
                      fetchProducts={fetchProducts}
                      productName={prodItem.prod_name + prodItem.spec_name}
                    />
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );

}

export default Main
