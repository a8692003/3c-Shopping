import React from 'react';

function ProductContent({ formik }) {

    const validateInput = (name, value) => {
        if (name === "quantity") {
            return /^\d+$/.test(value) && !value.startsWith("0") && parseInt(value) <= 999;
        } else if (name === "price") {
            return /^\d+$/.test(value) && !value.startsWith("0");
        }
        return true;
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        if (validateInput(name, value)) {
            formik.setFieldValue(name, value);
        }
    };

    return (
        <>
            <div className="row mt-5">
                <label className="col-1 align-self-start titlerow">商品描述</label>
                <div className="col">
                    <div className="gray3 incontentText titlerow top2-r10px ps-2 ">描述內容</div>
                    <textarea
                        className="form-control txtara"
                        rows={4}
                        value={formik.values.description}
                        onChange={formik.handleChange}  // 使用formik的handleChange
                        name="description"
                    />

                </div>
            </div>
            <div className="row mt-5">
                <label className="col-1 align-self-start titlerow">商品內容</label>
                <div className="col">
                    <div className="gray3 incontentText titlerow top2-r10px ps-2">庫存與規格</div>
                    <div className="container">
                        <div className="row txtara ">
                            <div className="col-md-4 ">
                                <div className='m-2'>
                                    <label htmlFor="spec">規格</label>
                                    <input
                                        type="text"
                                        name="spec"
                                        id="spec"
                                        value={formik.values.spec}
                                        onChange={formik.handleChange}
                                        onBlur={formik.handleBlur}
                                        className={`form-control ms-1 ${formik.touched.spec && formik.errors.spec ? 'error-input' : ''}`}
                                        placeholder="例如:基本款"
                                    />
                                    {formik.touched.spec && formik.errors.spec ? (
                                        <div className="text-danger">{formik.errors.spec}</div>
                                    ) : null}
                                </div>
                            </div>

                            <div className="col-md-4">
                                <div className='m-2'>
                                    <label htmlFor="quantity">數量</label>
                                    <input
                                        type="number"
                                        name="quantity"
                                        id="quantity"
                                        className={`form-control ms-1 ${formik.touched.quantity && formik.errors.quantity ? 'error-input' : ''}`}
                                        value={formik.values.quantity}
                                        onChange={formik.handleChange}
                                        onBlur={formik.handleBlur}
                                        min={0}
                                        max={999}
                                    />
                                    {formik.touched.quantity && formik.errors.quantity ? (
                                        <div className="text-danger">{formik.errors.quantity}</div>
                                    ) : null}
                                </div>
                            </div>

                            <div className="col-md-4">
                                <div className='m-2'>
                                    <label htmlFor="price">價格</label>
                                    <input
                                        type="text"
                                        name="price"
                                        id="price"
                                        className={`form-control ms-1 ${formik.touched.price && formik.errors.price ? 'error-input' : ''}`}
                                        value={formik.values.price}
                                        onChange={handleInputChange}
                                        onBlur={handleInputChange}
                                        min={0}
                                    />
                                    {formik.touched.price && formik.errors.price ? (
                                        <div className="text-danger">{formik.errors.price}</div>
                                    ) : null}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}

export default ProductContent;