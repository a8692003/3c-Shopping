import React, { useState } from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'

// Global styles
import './assets/styles/bootstrap-5.2.3-dist/css/bootstrap.css'
// import 'bootstrap/dist/css/bootstrap.css';
import './assets/styles/productStyle.css'
import './assets/styles/navtop.css'
import './assets/styles/GoodSys_1.css'
import 'react-toastify/dist/ReactToastify.css';
import './assets/styles/WarningMessage.css'
import { ToastContainer } from 'react-toastify';

// Components and local styles
import Head from './components/common/head'
import Aside from './components/common/aside'
import Main from './components/common/main'
import Downproducts from './components/common/de-list a product'
import AddProduct from './components/common/add-product'
import EditProductPage from './components/common/EditProductPage'
import AuthLoader from './components/contexts/AuthLoader';
function App() {
  const [authCompleted, setAuthCompleted] = useState(false);

  const handleAuthenticated = () => {
    // 在這裡處理認證後的行為，例如轉到特定頁面或渲染特定內容
    setAuthCompleted(true); // 身份驗證完成後，更新state
  };

  if (!authCompleted) {
    return <AuthLoader onAuthenticated={handleAuthenticated} />;
  }

  return (
    <Router>
      <ToastContainer />
      <Head />
      <Aside />
      <Routes>
        <Route path="/" element={<Main />} />
        <Route path="/downproducts" element={<Downproducts />} />
        <Route path="/add-product" element={<AddProduct />} />
        <Route path="/products/edit/:id/:sid" element={<EditProductPage />} />
      </Routes>
    </Router>
  );
}


export default App;