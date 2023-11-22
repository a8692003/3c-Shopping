import React, { useState } from 'react'
import axios from 'axios';
import { API_ENDPOINTS } from '../contexts/constants';
import { toast } from 'react-toastify';
import Swal from 'sweetalert2';

function MainButton({ productId, specId, fetchProducts, productName }) {
    const [isUnpublished] = useState(false);

    const showUnpublishModal = () => {
        Swal.fire({
          icon: 'warning',
          title: '⚠️下架商品',
          html: `是否將商品<strong>『${productName}』</strong>下架？`,
          showCancelButton: true,
          confirmButtonText: '確定下架',
          cancelButtonText: '取消',
          reverseButtons: true,
          confirmButtonColor: '#d33' 
        }).then((result) => {
          if (result.isConfirmed) {
            handleUnpublish();
          }
        });
    }

    const handleUnpublish = async () => {
        console.log(productId);

        try {
            await axios.put(`${API_ENDPOINTS.DOWN}/${productId}/${specId}`, { publish: 0 });

            // 使用 react-toastify 來顯示成功提示
            toast.success('商品已下架');

            fetchProducts(); // 刷新商品列表
        } catch (error) {
            console.error("Error in handleUnpublish:", error);

            // 使用 react-toastify 來顯示錯誤提示
            toast.error('下架失敗，請再試一次');
        }
    }

    if (isUnpublished) {
        return null; // 如果商品已經下架，不再顯示這個元件
    }

    return (
        <>
            <div className="" onClick={showUnpublishModal}>下架</div>
        </>
    );
}

export default MainButton;
