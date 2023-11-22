import React, { useState, useEffect } from 'react';
import Swal from 'sweetalert2';
import { Triangle as Loader } from 'react-loader-spinner';


function AuthLoader({ onAuthenticated }) {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [apiCallCompleted, setApiCallCompleted] = useState(false);
    const [navigatingToLogin, setNavigatingToLogin] = useState(false);
    useEffect(() => {
        const timer = setTimeout(() => {
            if (apiCallCompleted) {
                setIsLoading(false);
            }
        }, 100);
        return () => clearTimeout(timer);
    }, [apiCallCompleted]);

    useEffect(() => {
        fetch('/api/current-user')
            .then(response => response.json())
            .then(data => {
                if (data && data.islog) {
                    const userRole = data.right;

                    if (userRole === 0 || userRole === 1) { // 管理員或賣家
                        setIsAuthenticated(true);
                    } else if (userRole === 2) { // 買家
                        setIsAuthenticated(false);
                        Swal.fire({
                            title: '訪問被拒絕!',
                            text: '買家無法訪問上架中心。',
                            icon: 'error',
                            confirmButtonText: '確定'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                setNavigatingToLogin(true);
                                setTimeout(() => {
                                    window.location.href = 'http://localhost:2407/member/data';
                                }, 2000)
                            }; // 設置為3秒後跳轉，根據需要調整
                        });;
                    } else {
                        // 其他未知的身份
                        setIsAuthenticated(false);
                        Swal.fire({
                            title: '未知身份!',
                            text: '您的身份未被識別，無法訪問此頁面。',
                            icon: 'error',
                            confirmButtonText: '確定'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                setNavigatingToLogin(true);
                                setTimeout(() => {
                                    window.location.href = 'http://localhost:2407/login';
                                }, 3000)
                            } 
                        })
                    }
                } else {
                    setIsAuthenticated(false);
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
                            setNavigatingToLogin(true);
                            setTimeout(() => {
                                window.location.href = 'http://localhost:2407/login';
                            }, 3000)
                        }else if (result.dismiss === Swal.DismissReason.cancel) {
                            // 如果用戶點擊"取消"，則重定向到指定的頁面。
                            window.location.href = 'http://localhost:2407/';
                        } // 這裡我設置為3秒後跳轉，你可以根據需要調整
                    });
                }
            })
            .catch(error => {
                console.error('Error checking authentication:', error);
                setIsAuthenticated(false);
                Swal.fire({
                    title: '錯誤!',
                    text: '檢查身份驗證時出錯。',
                    icon: 'error',
                    confirmButtonText: '確定'
                });
            }).finally(() => {
                setApiCallCompleted(true);
            });

    }, []);


    useEffect(() => {
        if (apiCallCompleted && !isLoading) {
            setIsLoading(false);
        }
    }, [apiCallCompleted, isLoading]);

    if (isLoading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
                <Loader type="Puff" color="#00BFFF" height={100} width={100} />
                <b style={{ marginTop: '20px' }}>登入中…</b>
            </div>
        );
    }
    if (navigatingToLogin) {
        return (
            <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
                <Loader type="Puff" color="#00BFFF" height={100} width={100} />
                <b style={{ marginTop: '20px' }}>跳轉頁面中</b>
            </div>
        );
    }


    if (!isAuthenticated) {
        // 如果不希望在這裡立即重定向，您可以僅顯示提示或其他內容。
        return null;
    }

    onAuthenticated();

    return null;

}

export default AuthLoader;