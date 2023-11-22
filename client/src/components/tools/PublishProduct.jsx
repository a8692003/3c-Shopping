import React from 'react';
import axios from 'axios';
import { API_ENDPOINTS } from '../contexts/constants';
import { toast } from 'react-toastify';
import Swal from 'sweetalert2';

function PublishProduct({ productId, specId, fetchProducts, productName }) {

    const showPublishModal = () => {
        Swal.fire({
          icon: 'info',
          title: '上架商品',
          html: `是否將商品<strong>『${productName}』</strong>上架？`,
          showCancelButton: true,
          confirmButtonText: '確定上架',
          cancelButtonText: '取消',
          reverseButtons: true
        }).then((result) => {
          if (result.isConfirmed) {
            handlePublish(productId, specId);
          }
        });
    }

    const handlePublish = async (prod_id, spec_id) => {
        try {
            const response = await axios.put(`${API_ENDPOINTS.DOWN}/${prod_id}/${spec_id}`, { publish: 1 });
            if (response.status === 200) {
                toast.success('商品已上架');
                fetchProducts(); // 刷新商品列表
            } else {
                throw new Error('Server responded with a non-200 status code');
            }
        } catch (error) {
            console.error("在handlePublish中出現錯誤:", error);
            toast.error('上架失敗，請再試一次');
        }
    }

    return (
        <div className="publishProduct" onClick={showPublishModal}>上架</div>
    );
}

export default PublishProduct;
