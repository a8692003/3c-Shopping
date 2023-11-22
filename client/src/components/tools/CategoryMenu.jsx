import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { API_ENDPOINTS } from '../contexts/constants';
import WarningMessage from './WarningMessage';
const LAPTOP_CATEGORY = '筆電';

function CategoryMenu({ onCategorySelect, onBrandSelect, formikErrors, formikTouched, ...props }) {
    // console.log('formikTouched:', formikTouched, 'formikErrors:', formikErrors)
    const [showCategories, setShowCategories] = useState(false);
    const [mainCategories, setMainCategories] = useState([]);
    const [brands, setBrands] = useState([]);
    const [selectedCategory, setSelectedCategory] = useState(null);
    const [selectedBrand, setSelectedBrand] = useState(null);

    useEffect(() => {
        fetchMainCategories();
        fetchBrands();
    }, []);

    const fetchMainCategories = async () => {
        try {
            const response = await axios.get(API_ENDPOINTS.CATEGORY);
            if (response.data && Array.isArray(response.data)) {
                setMainCategories(response.data);
            }
        } catch (error) {
            console.error('Error fetching main categories:', error);
           
        }
    };

    const fetchBrands = async () => {
        try {
            const response = await axios.get(API_ENDPOINTS.BRAND);
            if (response.data && Array.isArray(response.data)) {
                setBrands(response.data);
            }
        } catch (error) {
            console.error('Error fetching brands:', error);
            // TODO: Provide feedback to the user here if needed
        }
    };


    const toggleCategories = () => {
        setShowCategories(prev => !prev);
        setSelectedCategory(null);
        setSelectedBrand(null);

        onCategorySelect(null, null);
    };

    const selectMainCategory = (categoryName, categoryId) => {
        setSelectedCategory(categoryName);
        setSelectedBrand(null);
        if (categoryName === LAPTOP_CATEGORY) {
            console.log("筆電的categoryId是:", categoryId);
            fetchBrands();
           
            onCategorySelect(categoryName, categoryId);
        } else {
            onCategorySelect(null, null); 
        }
    };


    const handleBrandClick = (brandId, brandName) => {
        onBrandSelect(brandId);
        setSelectedBrand(brandName);
        setShowCategories(false);
        console.log(brandId);
    };
    return (
        <>

            <div className="row align-items-center mt-5">
                <label className="col-1">商品類別</label>

                <div className="menu col">
                    {!selectedCategory && !selectedBrand && (
                        <button type='button' id="main-category" onClick={toggleCategories} className='m-1 btn btn-secondary'>選擇分類</button>
                    )}
                   
                    {/* 分類偽填警告 */}
                    {formikTouched.categoryId && formikErrors.categoryId ? (
                        <WarningMessage message={formikErrors.categoryId} />
                    ) : null} 
                    {/* 品牌偽填警告 */}
                    {formikTouched.brandId && formikErrors.brandId ? (
                        <WarningMessage message={formikErrors.brandId} />
                    ) : null}
                    {showCategories && !selectedCategory && (
                        <>
                            {mainCategories.map(category => (
                                <button
                                    type='button'
                                    key={category.category_id}
                                    onClick={() => selectMainCategory(category.category, category.category_id)}
                                    className='m-1 btn btn-info'>
                                    {category.category}
                                </button>
                            ))}
                            <button type='button' onClick={toggleCategories} className='m-1 btn btn-danger'>返回</button>
                            {/* 品牌偽填警告 */}
                            {formikTouched.brandId && formikErrors.brandId ? (
                                <WarningMessage message={formikErrors.brandId} />
                            ) : null}
                        </>
                    )}

                    {selectedCategory && (selectedCategory !== LAPTOP_CATEGORY) && !selectedBrand && (
                        <>
                            <button type='button' className='m-1 btn btn-info'>{selectedCategory}</button>
                            <button type='button' onClick={toggleCategories} className='m-1 btn btn-danger'>返回</button>
                        </>
                    )}

                    {showCategories && selectedCategory === LAPTOP_CATEGORY && !selectedBrand && (
                        <>
                            {brands.map(brand => (
                                <button
                                    type='button'
                                    key={brand.brand_id}
                                    onClick={() => handleBrandClick(brand.brand_id, brand.brand)} // 傳遞品牌 ID 和品牌名稱
                                    className={`m-1 btn btn-info ${selectedBrand === brand.brand ? 'btn-success' : ''}`}>
                                    {brand.brand}
                                </button>
                            ))}
                            <button type='button' onClick={toggleCategories} className='m-1 btn btn-danger'>返回</button>
                            {/* 品牌偽填警告 */}
                            {formikTouched.brandId && formikErrors.brandId ? (
                                <WarningMessage message={formikErrors.brandId} />
                            ) : null}
                        </>
                    )}

                    {selectedBrand && (
                        <>
                            <button type='button' className='m-1 btn btn-info'>筆記型電腦 &gt; {selectedBrand}</button>
                            <button type='button' onClick={toggleCategories} className='m-1 btn btn-danger'>返回</button>
                        </>
                    )}
                </div>

            </div>
        </>

    );

}

CategoryMenu.defaultProps = {
    onSelectProduct: () => { },
    onCategorySelect: () => { },
    onBrandSelect: () => { }
};

export default CategoryMenu;
