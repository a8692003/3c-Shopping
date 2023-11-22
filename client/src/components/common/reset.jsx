import { useState, useEffect, useRef, useCallback } from 'react';
import axios from 'axios';
import Swal from 'sweetalert2';

function EditProductPage() {
    // =====================================
    // State and Ref Declarations
    // =====================================

    const { id, sid } = useParams();
    const inputFileRef = useRef(null);

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

    const navigate = useNavigate();

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
}