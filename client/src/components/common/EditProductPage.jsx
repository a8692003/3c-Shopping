import React, { useState, useEffect, useCallback, useRef } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import axios from 'axios'
import { API_ENDPOINTS } from '../contexts/constants'
import { Dropdown, Accordion, Form, Button, Modal } from 'react-bootstrap'
import Swal from 'sweetalert2';
function EditProductPage() {
  // =====================================
  // State and Ref Declarations
  // =====================================

  const { id, sid } = useParams();
  const inputFileRef = useRef(null);
  const navigate = useNavigate();
  // Product states
  const [productState, setProductState] = useState({
    product: { sellspec: [] },
    updatedProduct: {},
    sellSpecs: [],
    images: [],
  });
  const [inputLength, setInputLength] = useState(0);
  const [editedSpecName, setEditedSpecName] = useState('');
  const [inputPrice, setInputPrice] = useState('')
  const [inputStock, setInputStock] = useState('')
  // Modal and UI states
  const [showModal, setShowModal] = useState(false);
  const [showDeleteButtons, setShowDeleteButtons] = useState(false);
  const [showHint, setShowHint] = useState(false);
  const [showImageModal, setShowImageModal] = useState(false);
  const [showChangeCoverModal, setShowChangeCoverModal] = useState(false);

  // Image states
  const [selectedImage, setSelectedImage] = useState(null);
  const [fileName, setFileName] = useState('');
  const [enlargedImageSrc, setEnlargedImageSrc] = useState(null);
  const [coverUpdated, setCoverUpdated] = useState(false);
  const [selectedImageId, setSelectedImageId] = useState(null);

  // Drop-down data states
  const [categories, setCategories] = useState([]);
  const [brands, setBrands] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState({});
  const [selectedBrand, setSelectedBrand] = useState({});
  const [textareaContent, setTextareaContent] = useState(
    productState.product.sellspec && productState.product.sellspec[0]
      ? productState.product.sellspec[0].contnet
      : ""
  );

  const [selectedTransports, setSelectedTransports] = useState([]);
  const [selectedPayments, setSelectedPayments] = useState([]);
  const [error, setError] = useState([]);



  // =====================================
  // Constants
  // =====================================

  const SPEC_FIELDS = [
    { key: 'cpu', label: 'CPU' },
    { key: 'gpu', label: 'GPU' },
    { key: 'ram', label: 'RAM' },
    { key: 'os', label: 'OS' },
    { key: 'screen', label: 'Screen' },
    { key: 'battery', label: 'Battery' },
    { key: 'warranty', label: 'Warranty' },
    { key: 'size', label: 'size' },
    { key: 'weight', label: 'weight' },
  ];
  const TRANSPORT_OPTIONS = [
    { id: 'all_transport', value: '2', label: '全選' },
    { id: 'mail_transport', value: '0', label: '郵寄寄送' },
    { id: 'express_transport', value: '1', label: '宅配/快遞' },
  ];
  const PAYMENT_OPTIONS = [
    { id: 'all_payment', value: '2', label: '全選' },
    { id: 'bank_transfer', value: '0', label: '銀行或郵局轉帳' },
    { id: 'credit_card', value: '1', label: '信用卡(一次付清)' },
  ];

  // =====================================
  // Helper Functions
  // =====================================

  const showDeleteResult = (success) => {
    if (success) {
      Swal.fire({
        title: '成功!',
        text: '圖片已成功刪除。',
        icon: 'success',
        timer: 2000,
        showConfirmButton: false,
        timerProgressBar: true,
      });
    } else {
      Swal.fire({
        title: '失敗!',
        text: '刪除圖片時出錯。',
        icon: 'error',
        timer: 2000,
        showConfirmButton: false,
        timerProgressBar: true,
      });
    }
  };
  const convertTransportToServerFormat = () => {
    if (selectedTransports.includes('2')) {
      return 2 // 全選
    }
    if (selectedTransports.includes('0') && selectedTransports.includes('1')) {
      return 2 // 所有選項都被選中
    }
    if (selectedTransports.includes('0')) {
      return 0 // 郵寄寄送
    }
    if (selectedTransports.includes('1')) {
      return 1 // 宅配/快遞
    }
    return null // 沒有選擇任何運送方式
  };
  const convertPaymentToServerFormat = () => {
    // console.log(selectedPayments);
    // console.log(selectedPayments);
    if (selectedPayments.includes('2')) {
      return 2 // 全選
    }
    if (selectedPayments.includes('0') && selectedPayments.includes('1')) {
      return 2 // 所有選項都被選中
    }
    if (selectedPayments.includes('0')) {
      return 0 // 銀行或郵局轉帳
    }
    if (selectedPayments.includes('1')) {
      return 1 // 信用卡(一次付清)
    }
    return null // 沒有選擇任何付款方式
  };
  const updateSpecName = () => {
    if (editedSpecName && productState.sellSpecs.length > 0) {
      const updatedSpecs = [...productState.sellSpecs]
      updatedSpecs[0].spec_name = editedSpecName
      return updatedSpecs
    }
    return productState.sellSpecs
  };

  // =====================================
  // Event Handlers
  // =====================================

  const handleDelete = async (imgId) => {
    const result = await Swal.fire({
      title: '確認',
      text: "確定要刪除此圖片嗎？",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: '確定',
      cancelButtonText: '取消'
    });

    if (result.isConfirmed) {
      deleteImage(imgId);
      const deleteSuccess = true;  // 假設刪除成功
      // replace with actual delete operation and result

      showDeleteResult(deleteSuccess);
    }
  };;
  const handleSpecNameChange = e => {
    setEditedSpecName(e.target.value)
  };
  const handleInput = e => {
    setInputLength(e.target.value.length)
  };
  const handleInputChange = useCallback(
    e => {
      const { name, value } = e.target;

      if (name === 'descriptionContent') {
        // 更新本地 state
        setTextareaContent(value);
      }
      else if (name === 'spec_name' && productState.sellSpecs.length > 0) {
        setProductState(prevState => {
          const updatedSpecs = [...prevState.sellSpecs];
          updatedSpecs[0].spec_name = value;
          return {
            ...prevState,
            sellSpecs: updatedSpecs,
            updatedProduct: {
              ...prevState.updatedProduct,
              sellSpecs: updatedSpecs,
            },
          };
        });
      }
      else {
        setProductState(prevState => ({
          ...prevState,
          updatedProduct: { ...prevState.updatedProduct, [name]: value },
        }));
      }
    }, [productState.sellSpecs]);
  const handleCancel = () => navigate('/'); // 替換成你要跳轉的路徑

  // =====================================
  // Effects
  // =====================================

  useEffect(() => {
    console.log('useEffect triggered!') // 這樣您可以看到每次useEffect被調用時的紀錄
    if (coverUpdated) {
      // 這裡進行您的邏輯

      setCoverUpdated(false)
    }
  }, [coverUpdated]);
  useEffect(() => {
    const fetchData = async () => {
      try {
        const [productResponse, categoryResponse, brandResponse] = await Promise.all([
          axios.get(API_ENDPOINTS.PRODUCT_BY_ID(id, sid)),
          axios.get(API_ENDPOINTS.CATEGORY),
          axios.get(API_ENDPOINTS.BRAND),
        ])

        const productData = {
          ...productResponse.data.product,
          sellspec: productResponse.data.sellspec || [],
        }

        setProductState(prevState => ({
          ...prevState,
          product: productData,
          updatedProduct: productData,
          sellSpecs: productResponse.data.sellspec || [],
          images: productResponse.data.images || [],
        }))

        setInputLength(productData.prod_name ? productData.prod_name.length : 0)

        setCategories(categoryResponse.data)
        setBrands(brandResponse.data)
      } catch (err) {
        setError(prevError => [...prevError, 'API call failed.'])
      }
    }

    fetchData()
  }, [id, sid]);
  useEffect(() => {
    const paymentFromServer = productState.product.payment
    const transportFromServer = productState.product.transport

    // 設定 selectedPayments 的初始值
    switch (paymentFromServer) {
      case 2:
        setSelectedPayments(['0', '1', '2']) // 銀行或郵局轉帳、信用卡(一次付清)
        break
      case 0:
        setSelectedPayments(['0']) // 銀行或郵局轉帳
        break
      case 1:
        setSelectedPayments(['1']) // 信用卡(一次付清)
        break
      default:
        break
    }

    // 設定 selectedTransports 的初始值
    switch (transportFromServer) {
      case 2:
        setSelectedTransports(['0', '1', '2']) // 郵寄寄送、宅配/快遞
        break
      case 0:
        setSelectedTransports(['0']) // 郵寄寄送
        break
      case 1:
        setSelectedTransports(['1']) // 宅配/快遞
        break
      default:
        break
    }
  }, [productState.product.payment, productState.product.transport]);
  useEffect(() => {
    const paymentFromServer = productState.product.payment
    const transportFromServer = productState.product.transport

    // 設定 selectedPayments 的初始值
    switch (paymentFromServer) {
      case 2:
        setSelectedPayments(['0', '1', '2']) // 銀行或郵局轉帳、信用卡(一次付清)
        break
      case 0:
        setSelectedPayments(['0']) // 銀行或郵局轉帳
        break
      case 1:
        setSelectedPayments(['1']) // 信用卡(一次付清)
        break
      default:
        break
    }

    // 設定 selectedTransports 的初始值
    switch (transportFromServer) {
      case 2:
        setSelectedTransports(['0', '1', '2']) // 郵寄寄送、宅配/快遞
        break
      case 0:
        setSelectedTransports(['0']) // 郵寄寄送
        break
      case 1:
        setSelectedTransports(['1']) // 宅配/快遞
        break
      default:
        break
    }
  }, [productState.product.payment, productState.product.transport])

  useEffect(() => {
    if (productState.product.sellspec && productState.product.sellspec[0]) {
      setTextareaContent(productState.product.sellspec[0].contnet);
    }
  }, [productState.product.sellspec]);

  // =====================================
  // Render
  // =====================================



  const handleSpecChange = (specIndex, key, value) => {

    setProductState(prevState => {
      if (!Array.isArray(prevState.sellSpecs)) {
        console.error('sellSpecs is not an array:', prevState.sellSpecs)
        return prevState // return the existing state without modification
      }
      const newSpecs = [...prevState.sellSpecs]
      if (typeof newSpecs[specIndex] !== 'object' || newSpecs[specIndex] === null) {
        console.error('Spec at index is not an object:', specIndex)
        return prevState // return the existing state without modification
      }
      newSpecs[specIndex][key] = value
      return { ...prevState, sellSpecs: newSpecs }
    })
  }
  const isOptionChecked = value => {
    return selectedTransports.includes(value)
  }
  const isPaymentOptionChecked = value => {
    return selectedPayments.includes(value)
  }
  const handlePaymentChange = value => {
    // console.log("Currently selected value:", value);

    if (value === '2') {
      // 當「全選」被選擇時，選擇所有選項；否則，取消所有選項
      if (isPaymentOptionChecked('2')) {
        setSelectedPayments([])
      } else {
        setSelectedPayments(['0', '1', '2'])
      }
    } else {
      const newPayments = [...selectedPayments]

      if (isPaymentOptionChecked(value)) {
        const index = newPayments.indexOf(value)
        newPayments.splice(index, 1)
      } else {
        newPayments.push(value)
      }

      // 如果所有選項都被選擇，那麼「全選」也應該被選擇
      if (newPayments.includes('0') && newPayments.includes('1')) {
        newPayments.push('2')
      } else {
        const index = newPayments.indexOf('2')
        if (index > -1) {
          newPayments.splice(index, 1)
        }
      }

      setSelectedPayments(newPayments)
    }
  }

  const handleTransportChange = value => {
    // console.log("Currently selected value:", value);
    if (value === '2') {
      // 當「全選」被選擇時，選擇所有選項；否則，取消所有選項
      if (isOptionChecked('2')) {
        setSelectedTransports([])
      } else {
        setSelectedTransports(['0', '1', '2'])
      }
    } else {
      const newTransports = [...selectedTransports]

      if (isOptionChecked(value)) {
        const index = newTransports.indexOf(value)
        newTransports.splice(index, 1)
      } else {
        newTransports.push(value)
      }

      // 如果所有選項都被選擇，那麼「全選」也應該被選擇
      if (newTransports.includes('0') && newTransports.includes('1')) {
        newTransports.push('2')
      } else {
        const index = newTransports.indexOf('2')
        if (index > -1) {
          newTransports.splice(index, 1)
        }
      }

      setSelectedTransports(newTransports)
    }
  }

  const renderProductImages = () => {
    if (!Array.isArray(productState.images)) {
      return null
    }
    return productState.images
      .filter(image => image && image.img_src)
      .map((image, index) => (
        <div key={index} className="image-item">
          <img
            src={`/public${API_ENDPOINTS.LOCALHOST}/${image.img_src}?t=${Date.now()}`}
            alt={image.originalname || 'Product Image'}
            className="editproduct-image1"
            onClick={() => {
              setEnlargedImageSrc(`${API_ENDPOINTS.LOCALHOST}/${image.img_src}?t=${Date.now()}`)
              setShowImageModal(true)
            }}
          />

          {image.type === 0 && <div className="introduce-badge custom-badge">介紹圖</div>}
        </div>
      ))
  }
  const renderProductImagesPutDel = (isModal = false) => {
    return productState.images
      .filter(image => image && image.img_src)
      .map((image, index) => (
        <div
          key={index}
          className={`image-item ${isModal && image.img_id === selectedImageId ? 'selected' : ''}`}
          onClick={() => {
            if (!showDeleteButtons) {
              setSelectedImageId(image.img_id)
            }
          }}
        >
          <img
            src={`/public${API_ENDPOINTS.LOCALHOST}/${image.img_src}?t=${Date.now()}`}
            alt={image.originalname || 'Product Image'}
            className="editproduct-image1"
          />
          {image.type === 0 && <div className="introduce-badge">封面圖</div>}
          {showDeleteButtons && (
            <Button
              variant="danger"
              size="sm"
              onClick={e => {
                e.stopPropagation(); // 阻止事件冒泡
                handleDelete(image.img_id);
              }}
            >
              刪除
            </Button>
          )}
        </div>
      ))
  }

  const uploadImage = async () => {
    const spec_id = productState.product.sellspec[0].spec_id;

    if (!selectedImage) {
      console.error('No image selected')
      return
    }

    if (typeof spec_id === 'undefined') { // 修改了這裡
      console.error('spec_id is not defined!')
      return;
    }

    const formData = new FormData();
    formData.append('productImage', selectedImage);
    formData.append('prod_id', productState.product.prod_id);
    formData.append('spec_id', spec_id);

    try {
      const response = await fetch(
        API_ENDPOINTS.UPLOAD_PRODUCT_IMAGE(
          productState.product.prod_id,
          spec_id // 修改了這裡
        ),
        // ... 其他代碼

        {
          method: 'POST',
          body: formData,
        }
      )

      const responseData = await response.json()

      if (response.ok) {
        // 使用伺服器回應中的path
        // console.log(response);

        const newImage = {
          img_src: `${responseData.path}`,
        }

        // 更新當前的圖片列表
        setProductState(prevState => {
          const newState = {
            ...prevState,
            images: [...prevState.images, newImage],
          }
          // console.log(newState.images);
          return newState
        })

        if (inputFileRef.current) {
          inputFileRef.current.value = ''
          setFileName('新增圖片')
        } else {
          console.error(responseData.message || 'Error uploading image')
        }
      } else {
        console.error(responseData.message || 'Error uploading image')
      }
    } catch (error) {
      console.error('Error uploading image:', error)
    }
  }

  const deleteImage = async imageId => {
    console.log(imageId)
    try {
      const response = await fetch(API_ENDPOINTS.DELETE_PRODUCT_IMAGE(imageId), {
        method: 'DELETE',
      })

      if (response.ok) {
        setProductState(prevState => ({
          ...prevState,
          images: prevState.images.filter(image => image.img_id !== imageId),
        }))
      } else {
        const data = await response.json()
        console.error(data.error)
      }
    } catch (error) {
      console.error('Error deleting image:', error)
    }
  }
  const changeCoverImage = async () => {
    if (selectedImageId) {
      try {
        const response = await axios.post(API_ENDPOINTS.UPDATE_COVER_IMAGE, {
          imageId: selectedImageId,
        })
        if (response.status === 200) {
          Swal.fire({
            icon: 'success',
            title: '成功',
            text: '封面圖更新成功！'
          });
          fetchProductImages() // 假設這是用來重新獲取產品圖片的函數
        } else {
          Swal.fire({
            icon: 'error',
            title: '失敗',
            text: '封面圖更新失敗！'
          });
        }
      } catch (error) {
        console.error('更新封面圖失敗: ', error)
        Swal.fire({
          icon: 'error',
          title: '出錯了',
          text: '更新封面圖失敗！'
        });
      }
      setSelectedImageId(null) // 清空所選的圖片ID
      setShowChangeCoverModal(false) // 關閉模態框
    } else {
      Swal.fire({
        icon: 'warning',
        title: '提示',
        text: '請選擇一個圖片！'
      }).then(() => {
        setTimeout(() => setShowHint(false), 5000) // 5秒後自動隱藏提示
      });
    }
  }
  // 假設這是用來重新獲取產品圖片的函數，你可能已經有這個功能，只是我在提供的代碼中沒有看到。
  const fetchProductImages = async () => {
    const response = await axios.get(API_ENDPOINTS.PRODUCT_BY_ID(id, sid

    ))
    if (response.status === 200 && Array.isArray(response.data.images)) {
      setProductState({ ...productState, images: response.data.images })
      console.log('Fetched and updated product images:', response.data)
    }
  }

  const handleImageChange = event => {
    if (event.target.files.length > 0) {
      setFileName(event.target.files[0].name)
      if (event.target.files.length > 5) {
        alert('最多只能上傳6張圖片！')
        return
      }
      // 其他處理...
    }
    setSelectedImage(event.target.files[0])
  }



  // const handleSave = async () => {
  //   const changesSummary = generateChangesSummary();

  //   const result = await Swal.fire({
  //     title: '確認更改',
  //     html: `以下是您的更改：<br/><br/>${changesSummary}<br/><br/>是否確定要保存？`,
  //     icon: 'question',
  //     showCancelButton: true,
  //     confirmButtonText: '確定',
  //     cancelButtonText: '取消'
  //   });

  //   if (result.isConfirmed) {
  //     // ... 其他的保存操作 ...
  //     saveProductToServer(productToUpdate);
  //   }
  // }

  const saveProductToServer = product => {
    axios
      .patch(API_ENDPOINTS.UPDATE_PRODUCT_PARTIALLY(id), product)
      .then(() => {
        setProductState(prevState => ({ ...prevState, product }))
        setSelectedCategory({})
        setSelectedBrand({})

        // 成功保存後，顯示sweetalert2提示
        Swal.fire({
          icon: 'success',
          title: '儲存成功!',
          showConfirmButton: false,
          timer: 1500 // 顯示1.5秒後自動消失
        }).then(() => {
          // 這裡是跳轉的部分，跳轉到您想要的頁面
          navigate(-1);
        });
      })
      .catch(error => {
        // Use the error message from the server response or a default message
        const errorMessage = error.response?.data?.message || 'Failed to update product.'
        setError([errorMessage])

        // 保存失敗時，也顯示sweetalert2的提示
        Swal.fire({
          icon: 'error',
          title: '儲存失敗',
          text: errorMessage // 使用從伺服器返回的錯誤訊息
        });
      })
  }

  const handleSave = () => {
    const updatedSpecs = updateSpecName()

    // 如果inputPrice有值，更新updatedSpecs[0].price，否則保持原樣
    if (inputPrice && updatedSpecs.length > 0) {
      updatedSpecs[0].price = Number(inputPrice)
    }
    if (inputStock && updatedSpecs.length > 0) {
      updatedSpecs[0].stock = Number(inputStock)
    }

    // 使用 textareaContent 更新 sellspec 的內容
    const updatedSellSpec = productState.updatedProduct.sellspec ? [...productState.updatedProduct.sellspec] : [];

    if (updatedSellSpec[0]) {
      updatedSellSpec[0].contnet = textareaContent;
    }

    const transportToUpdate = convertTransportToServerFormat()
    const paymentToUpdate = convertPaymentToServerFormat()
    const productToUpdate = {
      ...productState.updatedProduct,
      sellSpecs: updatedSpecs,
      sellspec: updatedSellSpec,  // 使用更新後的 sellspec
      categoryId: selectedCategory.category_id || productState.product.categoryId,
      brandId: selectedBrand.brand_id || productState.product.brandId,
      transport: transportToUpdate,
      payment: paymentToUpdate,
    }

    Swal.fire({
      icon: 'warning', // 提示圖示
      title: '確認更改',
      text: '您確定要保存對商品的更改嗎？',
      showCancelButton: true,  // 顯示取消按鈕
      confirmButtonText: '確定', // 確認按鈕文字
      cancelButtonText: '取消'  // 取消按鈕文字
    }).then((result) => {
      // 若使用者點擊“確定”，則繼續保存更改的邏輯
      if (result.isConfirmed) {
        saveProductToServer(productToUpdate)
      }
    });


  }




  if (error.length > 0) return <div>{error.join(', ')}</div>

  if (!productState.product) return <div>Loading...</div>

  const handleModalClose = () => {
    setShowModal(false)
    setShowDeleteButtons(false)
  }



  return (
    <>
      <div className="top2 top2-b10px mt-3 top2-bgray">
        <div className="mt-3">
          <div className="titlefont ">
            <span className="titlefont-blue ">商品管理</span> / 商品編輯
          </div>
        </div>
      </div>
      <div className="top2 top2-b10px incontentText mt-3 p-4 top2-bgray">
        <div className="row">
          <h5 className="col-2">{ }</h5>
          <h5 className="col-5 ">當前商品資訊</h5>
          <h5 className="col-5 ">編輯商品資訊</h5>
        </div>

        <div className="row mt-5">
          <label className="col-2 align-self-start titlerow">商品名稱</label>
          <div className="col">
            <div className="row">
              <div className="col-6">
                <div className="gray3 incontentText titlerowfit top2-r10px ps-2">
                  <b>{productState.product.prod_name}</b>
                </div>
              </div>
              <div className="col-6">
                <div className="col">
                  <input
                    type="text"
                    name="prod_name"
                    placeholder="請輸入要編輯名稱"
                    className="form-control ms-1 input-right-placeholder"
                    defaultValue={productState.product.prod_name}
                    onBlur={handleInputChange}
                    onChange={handleInput}
                    maxLength={50}
                  />
                  <div className="text-end">{inputLength}/50</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="row mt-5">
          <div className="col-2">商品圖片</div>
          <div className="col">
            {renderProductImages()}
            <Modal show={showImageModal} onHide={() => setShowImageModal(false)}>
              <Modal.Header closeButton>
                <Modal.Title>查看圖片</Modal.Title>
              </Modal.Header>
              <Modal.Body>
                {enlargedImageSrc && (
                  <img
                    src={'/public' + enlargedImageSrc}
                    alt="Enlarged Product "
                    className="enlarged-image"
                  />
                )}
              </Modal.Body>
              <Modal.Footer>
                <Button variant="secondary" onClick={() => setShowImageModal(false)}>
                  關閉
                </Button>
              </Modal.Footer>
            </Modal>
          </div>
          <div className="col">
            <Button variant="primary" onClick={() => setShowModal(true)}>
              新增/刪減圖片
            </Button>
            <div className="col-12 mt-2">
              <Button
                variant="info"
                onClick={() => {
                  setShowChangeCoverModal(true)
                  setShowHint(true)
                }}
              >
                更改封面圖
              </Button>
            </div>
            <Modal show={showModal} onHide={handleModalClose}>
              <Modal.Header closeButton>
                <Modal.Title>編輯商品圖片</Modal.Title>
              </Modal.Header>
              <div className="row">
                <Button
                  variant="danger"
                  onClick={() => setShowDeleteButtons(!showDeleteButtons)}
                  className="col"
                >
                  {showDeleteButtons ? '隱藏刪除按鈕' : '顯示刪除按鈕'}
                </Button>
              </div>
              <Modal.Body>
                {renderProductImagesPutDel()}
                <div className="custom-file">
                  <input
                    ref={inputFileRef} // Attach the ref here
                    type="file"
                    onChange={handleImageChange}
                    name="productImage"
                    className="custom-file-input"
                    id="productImageInput"
                  />
                  <label className="custom-file-label" htmlFor="productImageInput">
                    {fileName || '新增圖片'}
                  </label>
                </div>
              </Modal.Body>
              <Modal.Footer>
                <Button variant="secondary" onClick={handleModalClose}>
                  取消
                </Button>
                <Button variant="primary" onClick={uploadImage}>
                  上傳圖片
                </Button>
              </Modal.Footer>
            </Modal>

            <Modal show={showChangeCoverModal} onHide={() => setShowChangeCoverModal(false)}>
              <Modal.Header closeButton>
                <Modal.Title>更改封面圖</Modal.Title>
              </Modal.Header>
              <Modal.Body>
                {renderProductImagesPutDel(true)}

                {showHint && <div className="hint">請點擊想要設為封面的圖片</div>}
              </Modal.Body>
              <Modal.Footer>
                <Button variant="secondary" onClick={() => setShowChangeCoverModal(false)}>
                  取消
                </Button>
                <Button variant="primary" onClick={changeCoverImage}>
                  確認更改
                </Button>
              </Modal.Footer>
            </Modal>
          </div>
        </div>

        <div className="row mt-5">
          <label className="col-2 align-self-start titlerow">商品分類</label>
          <div className="col">
            <div className="row">
              <div className="col-6">
                <div className="gray3 incontentText titlerow top2-r10px ps-2">
                  <b>
                    {productState.product.categoryName}/{productState.product.brandName}
                  </b>
                </div>
              </div>
              <div className="col-6">
                <div className="row">
                  <Dropdown className="col-6 dropdown-fullwidth">
                    <Dropdown.Toggle variant="secondary" id="categoryDropdown">
                      {selectedCategory.category || productState.product.categoryName || '選擇分類'}
                    </Dropdown.Toggle>

                    <Dropdown.Menu>
                      {categories.map(category => (
                        <Dropdown.Item
                          key={category.category_id}
                          onClick={() => {
                            // console.log(`已點擊分類: ${category.category}`);
                            setSelectedCategory(category)
                          }}
                        >
                          {category.category}
                        </Dropdown.Item>
                      ))}
                    </Dropdown.Menu>
                  </Dropdown>

                  <Dropdown className="col-6 dropdown-fullwidth">
                    <Dropdown.Toggle variant="secondary" id="brandDropdown">
                      {selectedBrand.brand || productState.product.brandName || '選擇品牌'}
                    </Dropdown.Toggle>

                    <Dropdown.Menu>
                      {brands.map(brand => (
                        <Dropdown.Item
                          key={brand.brand_id}
                          onClick={() => {
                            // console.log(`已點擊品牌: ${brand.brand}`);
                            setSelectedBrand(brand)
                          }}
                        >
                          {brand.brand}
                        </Dropdown.Item>
                      ))}
                    </Dropdown.Menu>
                  </Dropdown>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="row mt-5">
          <div className="col-2 align-self-start titlerow">商品描述</div>
          <div className="col">
            <div className="gray3">
              <b>
                {productState.product.sellspec &&
                  productState.product.sellspec[0] &&
                  productState.product.sellspec[0].contnet}
              </b>
            </div>
          </div>
          <div className="col">
            <textarea
              className="form-control txtara"
              rows={4}
              value={textareaContent}
              onChange={handleInputChange}
              name="descriptionContent"
            />


          </div>
        </div>

        <div className="row mt-5">
          <div className="col-2 align-self-start titlerow">商品款式</div>
          <div className="col">
            <div className="gray3 incontentText titlerow top2-r10px ps-2">
              <b>
                {productState.sellSpecs &&
                  productState.sellSpecs.length > 0 &&
                  productState.sellSpecs[0].spec_name}
              </b>
            </div>
          </div>
          <div className="col">
            <input
              type="text"
              name="spec_name"
              placeholder="請輸入要編輯名稱"
              className="form-control ms-1 input-right-placeholder"
              defaultValue={
                productState.sellSpecs && productState.sellSpecs.length > 0
                  ? productState.sellSpecs[0].spec_name
                  : ''
              }
              onBlur={handleSpecNameChange}
            />
          </div>
        </div>

        <div className="row mt-5 ">
          <div className="col-2">產品規格</div>

          <Accordion className="col">
            {productState.sellSpecs.map((spec, specIndex) => (
              <Accordion.Item key={specIndex} eventKey={specIndex}>
                <Accordion.Header>產品規格編輯</Accordion.Header>
                <Accordion.Body>
                  <Form className="row">
                    {SPEC_FIELDS.map(field => (
                      <Form.Group className="col-4" key={field.key}>
                        <Form.Label>{field.label}</Form.Label>
                        <Form.Control
                          type="text"
                          value={spec[field.key] || ''}
                          onChange={e => handleSpecChange(specIndex, field.key, e.target.value)}
                        />
                      </Form.Group>
                    ))}
                  </Form>
                </Accordion.Body>
              </Accordion.Item>
            ))}
          </Accordion>
        </div>
        <div className="row mt-5 mb-5">
          <div className="col-2 align-self-start titlerow">商品價格</div>
          <div className="col">
            <div className="gray3 incontentText titlerow top2-r10px ps-2">
              <b>
                NT$
                {productState.sellSpecs &&
                  productState.sellSpecs.length > 0 &&
                  productState.sellSpecs[0].price.toLocaleString()}
              </b>
            </div>
          </div>
          <div className="col">
            <input
              type="number"
              name="price"
              placeholder="請輸入要編輯的價格"
              className="form-control ms-1 input-right-placeholder"
              defaultValue={
                productState.sellSpecs && productState.sellSpecs.length > 0
                  ? productState.sellSpecs[0].price
                  : ''
              }
              onChange={e => setInputPrice(e.target.value)}
            />
          </div>
        </div>
        <div className="row mt-5 mb-5">
          <div className="col-2 align-self-start titlerow">商品數量</div>
          <div className="col">
            <div className="gray3 incontentText titlerow top2-r10px ps-2">
              <b>
                {productState.sellSpecs &&
                  productState.sellSpecs.length > 0 &&
                  productState.sellSpecs[0].stock.toLocaleString()}
              </b>
            </div>
          </div>
          <div className="col">
            <input
              type="number"
              name="stock"
              placeholder="請輸入要編輯的數量"
              className="form-control ms-1 input-right-placeholder"
              defaultValue={
                productState.sellSpecs && productState.sellSpecs.length > 0
                  ? productState.sellSpecs[0].stock
                  : ''
              }
              onChange={e => setInputStock(e.target.value)}
            />
          </div>
        </div>

        <div className="row mt-5 mb-5">
          <div className="col-2 align-self-start titlerow">付款方式</div>
          <div className="col">
            <div className="gray3 incontentText titlerow top2-r10px ps-2">
              <b>
                {(() => {
                  switch (productState.product.payment) {
                    case 2:
                      return '銀行或郵局轉帳、信用卡(一次付清)'
                    case 0:
                      return '銀行或郵局轉帳'
                    case 1:
                      return '信用卡(一次付清)'
                    default:
                      return ''
                  }
                })()}
              </b>
            </div>
          </div>
          <div className="col">
            <div className="row">
              {PAYMENT_OPTIONS.map(option => (
                <div key={option.id} className="form-check col pt-2 ps-4">
                  <input
                    type="checkbox"
                    className="form-check-input"
                    id={option.id}
                    value={option.value}
                    // 假設您有一個叫做 isPaymentOptionChecked 的方法來檢查付款選項是否被選中
                    checked={isPaymentOptionChecked(option.value)}
                    // 假設您有一個叫做 handlePaymentChange 的方法來處理付款方式的改變
                    onChange={() => handlePaymentChange(option.value)}
                  />
                  <label className="form-check-label" htmlFor={option.id}>
                    {option.label}
                  </label>
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="row mt-5 mb-5">
          <div className="col-2 align-self-start titlerow">運送方式</div>
          <div className="col">
            <div className="gray3 incontentText titlerow top2-r10px ps-2">
              <b>
                {(() => {
                  switch (productState.product.transport) {
                    case 2:
                      return '郵寄寄送、宅配/快遞'
                    case 0:
                      return '郵寄寄送'
                    case 1:
                      return '宅配/快遞'
                    default:
                      return ''
                  }
                })()}
              </b>
            </div>
          </div>
          <div className="col">
            <div className="row">
              {TRANSPORT_OPTIONS.map(option => (
                <div key={option.id} className="form-check col pt-2 ps-4">
                  <input
                    type="checkbox"
                    className="form-check-input"
                    id={option.id}
                    value={option.value}
                    checked={isOptionChecked(option.value)}
                    onChange={() => handleTransportChange(option.value)}
                  />
                  <label className="form-check-label" htmlFor={option.id}>
                    {option.label}
                  </label>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      <nav className="gray2 conarae d-flex justify-content-end">
        <button style={{ marginRight: '16px' }} className="btn btn-danger m-1" onClick={handleCancel}>取消</button>
        <button onClick={handleSave} className="btn btn-primary m-1">
          保存更改
        </button>
      </nav>
    </>
  )
}

export default EditProductPage
