
import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';
import { API_ENDPOINTS } from '../contexts/constants';


function AdminIcon() {
    return (
        <svg xmlns="http://www.w3.org/2000/svg" width={40} height={40} viewBox="0 0 24 24">
            <g fill="none" fillRule="evenodd">
                <path d="M24 0v24H0V0h24ZM12.594 23.258l-.012.002l-.071.035l-.02.004l-.014-.004l-.071-.036c-.01-.003-.019 0-.024.006l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427c-.002-.01-.009-.017-.016-.018Zm.264-.113l-.014.002l-.184.093l-.01.01l-.003.011l.018.43l.005.012l.008.008l.201.092c.012.004.023 0 .029-.008l.004-.014l-.034-.614c-.003-.012-.01-.02-.02-.022Zm-.715.002a.023.023 0 0 0-.027.006l-.006.014l-.034.614c0 .012.007.02.017.024l.015-.002l.201-.093l.01-.008l.003-.011l.018-.43l-.003-.012l-.01-.01l-.184-.092Z" />
                <path fill="currentColor" d="M12 2c5.523 0 10 4.477 10 10a9.959 9.959 0 0 1-2.258 6.33l.02.022l-.132.112A9.978 9.978 0 0 1 12 22c-2.95 0-5.6-1.277-7.43-3.307l-.2-.23l-.132-.11l.02-.024A9.958 9.958 0 0 1 2 12C2 6.477 6.477 2 12 2Zm0 15c-1.86 0-3.541.592-4.793 1.405A7.965 7.965 0 0 0 12 20a7.965 7.965 0 0 0 4.793-1.595A8.897 8.897 0 0 0 12 17Zm0-13a8 8 0 0 0-6.258 12.984C7.363 15.821 9.575 15 12 15s4.637.821 6.258 1.984A8 8 0 0 0 12 4Zm0 2a4 4 0 1 1 0 8a4 4 0 0 1 0-8Zm0 2a2 2 0 1 0 0 4a2 2 0 0 0 0-4Z" />
            </g>
        </svg>
    );
}

function ProductManagementIcon() {
    return (
        <svg xmlns="http://www.w3.org/2000/svg" width={35} height={35} viewBox="0 0 15 15">
            <path fill="currentColor" d="M10 7.995V10H8V7.995h2Zm0-2.998v1.998H8V4.997h2Zm-3 0H5v1.998h2V4.997Zm0 2.998H5V10h2V7.995Z" />
            <path fill="currentColor" fillRule="evenodd" d="M1 1.5A1.5 1.5 0 0 1 2.5 0h8.207L14 3.293V13.5a1.5 1.5 0 0 1-1.5 1.5h-10A1.5 1.5 0 0 1 1 13.5v-12Zm10 2.497H4V11h7V3.997Z" clipRule="evenodd" />
        </svg>
    );
}


function AddProductIcon() {
    return (
        <svg xmlns="http://www.w3.org/2000/svg" width={35} height={35} viewBox="0 0 1024 1024">
            <path fill="currentColor" d="M192 352h640l64 544H128l64-544zm128 224h64V448h-64v128zm320 0h64V448h-64v128zM384 288h-64a192 192 0 1 1 384 0h-64a128 128 0 1 0-256 0z" />
        </svg>
    );
}
function Offgoods() {
    return (
        <svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 640 512">
            <path d="M38.8 5.1C28.4-3.1 13.3-1.2 5.1 9.2S-1.2 34.7 9.2 42.9l592 464c10.4 8.2 25.5 6.3 33.7-4.1s6.3-25.5-4.1-33.7l-54.8-43V224H512V376L384 275.7V224H320v1.5L277.2 192H603.2c20.3 0 36.8-16.5 36.8-36.8c0-7.3-2.2-14.4-6.2-20.4L558.2 21.4C549.3 8 534.4 0 518.3 0H121.7c-16 0-31 8-39.9 21.4L74.1 32.8 38.8 5.1zM36.8 192h85L21 112.5 6.2 134.7c-4 6.1-6.2 13.2-6.2 20.4C0 175.5 16.5 192 36.8 192zM320 384H128V224H64V384v80c0 26.5 21.5 48 48 48H336c26.5 0 48-21.5 48-48V398.5l-64-50.4V384z" />
        </svg>
    );
}


function Aside() {
    const [userName, setUserName] = useState('');
    const navigate = useNavigate();  // React Router 的導航方法

    useEffect(() => {
        fetch('/api/current-user')
            .then(response => {
                // 檢查回應的狀態是否為 401
                if (response.status === 401) {
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
                } else {
                    return response.json();  // 如果狀態不是 401，繼續處理
                }
            })
            .then(data => {
                if (data && data.u_name) {
                    setUserName(data.u_name);
                }
            })
            .catch(error => console.error('Error fetching user:', error));
    }, [navigate]);

    return (
        <div className="sidenav">
               <Link to="/" className="mt-5">
                <AdminIcon />
                <span className="titlefont-blue"> {userName}</span>
            </Link>
            <Link to="/" className="mt-5">
                <ProductManagementIcon />
                商品管理
            </Link>
            {/* <Link to="/product-list" className="mt-5">
                <ProductListIcon />
                商品列表
            </Link> */}
            <Link to="/add-product" className="mt-5">
                <AddProductIcon />
                新增商品
            </Link>

            <Link to="/downproducts" className="mt-5">
                <Offgoods />
                下架商品
            </Link>
        </div>
    );
}

export default Aside;




