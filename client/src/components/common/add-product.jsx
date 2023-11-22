import React, { useState, useCallback, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import FileUploader from '../tools/FileUploader';
import CategoryMenu from '../tools/CategoryMenu';
import CheckboxGroup from '../tools/CheckboxGroup';
import LaptopSpecifications from '../tools/LaptopSpecifications';
import ProductContent from '../tools/ProductContent';
import axios from 'axios';
import { API_ENDPOINTS, PAYMENT_OPTIONS, TRANSPORT_OPTIONS, FAILSTEXT, USER_ID, SAVE } from '../contexts/constants';
import { useFormik } from 'formik';
import * as Yup from 'yup';
import WarningMessage from '../tools/WarningMessage';
import { toast } from 'react-toastify';
import Swal from 'sweetalert2';

function AddProduct() {
    const navigate = useNavigate();
    // const [productName] = useState('');
    const [mainImageIdx, setMainImageIndex] = useState('0');
    const [files, setFiles] = useState([]);
    const [brandId, setBrandId] = useState('');
    const [categoryId, setCategoryId] = useState('');
    const [payment, setPayment] = useState([]);
    const [transport, setTransport] = useState([]);

    const [laptopSpecs, setLaptopSpecs] = useState({
        cpu: '',
        gpu: '',
        ram: '',
        os: '',
        screen: '',
        battery: '',
        warranty: '',
        size: '',
        weight: '',
        price: '',
        description: '',
        stock: ''
    });

    // Callbacks

    const handleSubmit = (shouldPublish) => {
        Swal.fire({
            icon: 'question',
            title: '確認',
            text: '是否新增商品？',
            showCancelButton: true,
            confirmButtonText: '確定',
            cancelButtonText: '取消'
        }).then((result) => {
            if (result.isConfirmed) {
                formik.setFieldValue('shouldPublish', shouldPublish);
                formik.submitForm().then(() => {
                    if (formik.isValidating || formik.isSubmitting) {
                        return;
                    }
                    if (Object.keys(formik.errors).length > 0) {

                        Swal.fire({
                            icon: 'error',
                            title: '提交失敗',
                            text: '尚有商品資訊未填齊'
                        });
                    }
                });
            }
        });
    }


    const handleFilesSelect = useCallback((selectedFiles) => {
        setFiles(selectedFiles);
    }, []);

    const handleCheckboxGroupChange = useCallback((name, values) => {
        if (name === "payment") {
            if (values.includes("2")) {
                setPayment([2]);
            } else {
                setPayment(values);
            }
        } else if (name === "transport") {
            if (values.includes("2")) {
                setTransport([2]);
            } else {
                setTransport(values);
            }
        }
    }, []);

    const productValidationSchema = Yup.object({
        productName: Yup.string().required('商品名稱為必填'),
        brandId: Yup.string().required('品牌為必填'),
        categoryId: Yup.string().required('分類為必填'),
        payment: Yup.array().min(1, '至少選擇一種付款方式'),
        transport: Yup.array().min(1, '至少選擇一種運送方式'),
        spec: Yup.string().required('⚠️規格為必填'),
        quantity: Yup.number().required('⚠️數量為必填').min(0).max(999),
        price: Yup.number().required('⚠️價格為必填').min(0),

    });

    const fieldTranslations = useMemo(() => ({
        productName: '商品名稱',
        brandId: '品牌 ID',
        categoryId: '類別 ID',
        payment: '付款方式',
        transport: '運送方式',
        spec: '規格',
        quantity: '數量',
        price: '價格'
        // 其他字段翻譯
    }), []);  // 注意空的依賴數組，意味著此物件不會重新計算，除非組件重新渲染


    const formik = useFormik({
        initialValues: {
            productName: '',
            brandId: '',
            categoryId: '',
            payment: [],
            transport: [],
            spec: '',
            quantity: '',
            price: '',
            description: '',
            // 其他表單初始值
        },
        validationSchema: productValidationSchema,
        onSubmit: async (values, { setSubmitting }) => {
            console.log("Submitting form...");
            await formik.validateForm();
            console.log("Errors after validation:", formik.errors);
            if (Object.keys(formik.errors).length > 0) {
                const translatedFields = Object.keys(formik.errors).map(field =>
                    fieldTranslations[field] || field
                ).join(', ');

                toast.error(`以下欄位未完整填寫: ${translatedFields}`);
                setSubmitting(false);
                return;  // 因为有错误而返回
            }

            handleSaveProduct(values.shouldPublish).finally(() => {
                setSubmitting(false);
            });
        }
    });
    const specName = formik.values.spec;
    const content = formik.values.description;
    const price = formik.values.price;
    const stock = formik.values.quantity;
    // Helper functions
    const createFormData = (publishValue) => {
        const formData = new FormData();
        files.forEach((f) => formData.append('productImage', f));
        Object.keys(laptopSpecs).forEach(key => formData.append(`productData[${key}]`, laptopSpecs[key]));
        formData.append('productData[user_id]', USER_ID);
        formData.append('productData[prod_name]', formik.values.productName);
        formData.append('productData[brand_id]', brandId);
        formData.append('productData[category_id]', categoryId);
        formData.append('productData[transport]', transport.join(', '));
        formData.append('productData[payment]', payment.join(', '));
        formData.append('mainImageIdx', mainImageIdx);
        formData.append('productData[publish]', publishValue);
        formData.append('productData[spec_name]', specName);
        formData.append('productData[contnet]', content);
        formData.append('productData[price]', price);
        formData.append('productData[stock]', stock);


        return formData;
    };


    const handleSaveProduct = async (shouldPublish) => {

        console.log(formik.values.quantity);
        console.log(formik.values.spec);

        const publishValue = shouldPublish ? 1 : 0;
        const formData = createFormData(publishValue);
        for (let pair of formData.entries()) {
            console.log(pair[0] + ', ' + pair[1]);
        }

        try {
            const formData = createFormData(publishValue);
            const response = await axios.post(API_ENDPOINTS.CREATE_PRODUCT, formData);
            if (response.data.success) {
                toast.success("商品儲存並上架成功！");
            } else {
                alert(FAILSTEXT);
            }

            navigate('/');
        } catch (error) {
            toast.error('Failed to save product');
        }
    };

    const handleLaptopSpecsUpdate = (updatedForm) => {
        setLaptopSpecs(prevSpecs => ({ ...prevSpecs, ...updatedForm }));
    };

    const handleCancel = () => navigate('/');
    return (
        <>
            <form onSubmit={formik.handleSubmit}>


                <div className="top2 top2-bgray mt-3">
                    <div >
                        <div className="titlefont ">
                            <span className="titlefont-blue">商品管理</span> / 商品新增
                        </div>
                    </div>
                </div>
                <div className="top2 incontentText p-4 mt-2 top2-bgray">
                    <div className="row align-items-center">
                        <label className="col-1">商品名稱</label>
                        <div className="col">
                            <input
                                type="text"
                                className="form-control inputS"
                                value={formik.values.productName}
                                onChange={formik.handleChange}
                                onBlur={formik.handleBlur}
                                name='productName'
                            />
                        </div>
                        <div className="warning-message-container col mb-2">
                            {formik.touched.productName && formik.errors.productName ? (
                                <WarningMessage message={formik.errors.productName} />
                            ) : null}
                        </div>
                    </div>

                    <FileUploader
                        onFilesSelect={handleFilesSelect}
                        mainImageIndex={mainImageIdx}
                        onMainImageChange={index => setMainImageIndex(index)}
                    />



                    <CategoryMenu
                        onCategorySelect={(categoryName, categoryId) => {
                            setCategoryId(categoryId);
                            formik.setFieldValue('categoryId', categoryId);
                        }}
                        onBrandSelect={(brandId, brandName) => {
                            setBrandId(brandId);
                            formik.setFieldValue('brandId', brandId);
                        }}
                        formikErrors={formik.errors}
                        formikTouched={formik.touched}
                    />


                    <LaptopSpecifications
                        isVisible={categoryId === 1}
                        onSpecificationsChange={setLaptopSpecs}
                    />

                    <ProductContent
                        onUpdateForm={handleLaptopSpecsUpdate}
                        formik={formik}
                        formikErrors={formik.errors}
                        formikTouched={formik.touched}
                    />
                    <div className="row mt-5 mb-5">
                        <label className="col-1 align-self-start titlerow">付款方式</label>
                        <div className='col-11'>
                            <CheckboxGroup
                                title="收款方式"
                                name="payment"
                                options={PAYMENT_OPTIONS}
                                onChange={(name, values) => {
                                    handleCheckboxGroupChange(name, values);
                                    formik.setFieldValue('payment', values);
                                }}
                                value={formik.values.payment}
                                initialSelected={formik.values.payment}
                            />
                            <div className="warning-message-container mt-2">
                                {formik.touched.payment && formik.errors.payment ? (
                                    <WarningMessage message={formik.errors.payment} />
                                ) : null}
                            </div>
                        </div>
                    </div>

                    <div className="row mt-5 mb-5 hover-highlight">
                        <label className="col-1 align-self-start titlerow">運送方式</label>
                        <div className='col-11'>
                            <CheckboxGroup
                                title="運送方式"
                                name="transport"
                                options={TRANSPORT_OPTIONS}
                                onChange={(name, values) => {
                                    handleCheckboxGroupChange(name, values);
                                    formik.setFieldValue('transport', values);
                                }}
                                value={formik.values.transport}
                                initialSelected={formik.values.transport}
                            />
                            <div className="warning-message-container mt-2">
                                {formik.touched.transport && formik.errors.transport ? (
                                    <WarningMessage message={formik.errors.transport} />
                                ) : null}
                            </div>
                        </div>
                    </div>


                </div>
                <nav className="gray2 conarae d-flex justify-content-end align-items-center ">
                    <button style={{ marginRight: '16px' }} className="btn btn-danger mt-1" onClick={handleCancel}>取消</button>
                    <button
                        className="btn btn-success mt-1"
                        onClick={() => handleSubmit(false)}
                        type="button"  
                    >
                        {SAVE.SAVE}
                    </button>

                    <button
                        style={{ marginLeft: '16px' }}
                        className="btn btn-primary mt-1"
                        onClick={() => handleSubmit(true)}
                        type="button"  
                    >
                        {SAVE.SAVEANDPUBLISH}
                    </button>

                </nav>
            </form>
        </>
    );
}

export default AddProduct;