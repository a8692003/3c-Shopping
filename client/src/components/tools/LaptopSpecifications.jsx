// LaptopSpecifications.jsx

import axios from 'axios';
import React, { useState, useEffect } from 'react';
import { API_ENDPOINTS } from '../contexts/constants';
// import Swal from 'sweetalert2';
import { toast } from 'react-toastify';

function LaptopSpecifications({ isVisible, onSpecificationsChange }) {

    const [cpu, setCpu] = useState('');
    const [gpu, setGpu] = useState('');
    const [ram, setRam] = useState('');
    const [os, setOs] = useState('');
    const [screen, setScreen] = useState('');
    const [battery, setBattery] = useState('');
    const [warranty, setWarranty] = useState('');
    const [size, setSize] = useState('');
    const [weight, setWeight] = useState('');
    const [tag, setTag] = useState([]);
    const [selectCount, setSelectCount] = useState(1);
    useEffect(() => {
        if (onSpecificationsChange) {
            onSpecificationsChange({
                cpu, gpu, ram, os, screen, battery, warranty, size, weight
            });
        }
    }, [cpu, gpu, ram, os, screen, battery, warranty, size, weight, onSpecificationsChange]);

    useEffect(() => {
        fetchTags();
    })

    const fetchTags = async () => {
        try {
            const response = await axios.get(API_ENDPOINTS.TAG);
            if (response.data && Array.isArray(response.data)) {
                setTag(response.data)
            }
        } catch (error) {
            console.log('Error fetchTag:', error);
        }

    }
    const handleAddSelect = () => {
        if (selectCount < 3) {
            setSelectCount(prevCount => prevCount + 1);
        } else {
            toast.error('最多只能選擇3個標籤!')
        }
    };
    const handleMinSelect = () => {
        if (selectCount > 1) {
            setSelectCount(prevCount => prevCount - 1);
        } else {
            toast.error('最少不能小於1個標籤!')
        }
    };


    return (
        isVisible && (
            <>

                <div className="row mt-5 ">
                    <label className="col-1 align-self-start titlerow">商品標籤</label>

                    {[...Array(selectCount)].map((_, index) => (
                        <div className='col'>
                            <select key={index} className="form-select" aria-label="Default select example">
                                <option selected>選擇標籤</option>
                                {tag.map(tagItem => (
                                    <option key={tagItem.tag} value={tagItem.tag}>
                                        {tagItem.content}
                                    </option>
                                ))}
                            </select>
                            <button className="btn btn-light mt-1" type="button" onClick={handleAddSelect}>
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle-dotted" viewBox="0 0 16 16">
                                    <path d="M8 0c-.176 0-.35.006-.523.017l.064.998a7.117 7.117 0 0 1 .918 0l.064-.998A8.113 8.113 0 0 0 8 0zM6.44.152c-.346.069-.684.16-1.012.27l.321.948c.287-.098.582-.177.884-.237L6.44.153zm4.132.271a7.946 7.946 0 0 0-1.011-.27l-.194.98c.302.06.597.14.884.237l.321-.947zm1.873.925a8 8 0 0 0-.906-.524l-.443.896c.275.136.54.29.793.459l.556-.831zM4.46.824c-.314.155-.616.33-.905.524l.556.83a7.07 7.07 0 0 1 .793-.458L4.46.824zM2.725 1.985c-.262.23-.51.478-.74.74l.752.66c.202-.23.418-.446.648-.648l-.66-.752zm11.29.74a8.058 8.058 0 0 0-.74-.74l-.66.752c.23.202.447.418.648.648l.752-.66zm1.161 1.735a7.98 7.98 0 0 0-.524-.905l-.83.556c.169.253.322.518.458.793l.896-.443zM1.348 3.555c-.194.289-.37.591-.524.906l.896.443c.136-.275.29-.54.459-.793l-.831-.556zM.423 5.428a7.945 7.945 0 0 0-.27 1.011l.98.194c.06-.302.14-.597.237-.884l-.947-.321zM15.848 6.44a7.943 7.943 0 0 0-.27-1.012l-.948.321c.098.287.177.582.237.884l.98-.194zM.017 7.477a8.113 8.113 0 0 0 0 1.046l.998-.064a7.117 7.117 0 0 1 0-.918l-.998-.064zM16 8a8.1 8.1 0 0 0-.017-.523l-.998.064a7.11 7.11 0 0 1 0 .918l.998.064A8.1 8.1 0 0 0 16 8zM.152 9.56c.069.346.16.684.27 1.012l.948-.321a6.944 6.944 0 0 1-.237-.884l-.98.194zm15.425 1.012c.112-.328.202-.666.27-1.011l-.98-.194c-.06.302-.14.597-.237.884l.947.321zM.824 11.54a8 8 0 0 0 .524.905l.83-.556a6.999 6.999 0 0 1-.458-.793l-.896.443zm13.828.905c.194-.289.37-.591.524-.906l-.896-.443c-.136.275-.29.54-.459.793l.831.556zm-12.667.83c.23.262.478.51.74.74l.66-.752a7.047 7.047 0 0 1-.648-.648l-.752.66zm11.29.74c.262-.23.51-.478.74-.74l-.752-.66c-.201.23-.418.447-.648.648l.66.752zm-1.735 1.161c.314-.155.616-.33.905-.524l-.556-.83a7.07 7.07 0 0 1-.793.458l.443.896zm-7.985-.524c.289.194.591.37.906.524l.443-.896a6.998 6.998 0 0 1-.793-.459l-.556.831zm1.873.925c.328.112.666.202 1.011.27l.194-.98a6.953 6.953 0 0 1-.884-.237l-.321.947zm4.132.271a7.944 7.944 0 0 0 1.012-.27l-.321-.948a6.954 6.954 0 0 1-.884.237l.194.98zm-2.083.135a8.1 8.1 0 0 0 1.046 0l-.064-.998a7.11 7.11 0 0 1-.918 0l-.064.998zM8.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3v-3z" />
                                </svg>
                            </button>
                            <button className="btn btn-light mt-1 ms-1" type="button" onClick={handleMinSelect}>
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-dash-circle-dotted" viewBox="0 0 16 16">
                                    <path d="M8 0c-.176 0-.35.006-.523.017l.064.998a7.117 7.117 0 0 1 .918 0l.064-.998A8.113 8.113 0 0 0 8 0zM6.44.152c-.346.069-.684.16-1.012.27l.321.948c.287-.098.582-.177.884-.237L6.44.153zm4.132.271a7.946 7.946 0 0 0-1.011-.27l-.194.98c.302.06.597.14.884.237l.321-.947zm1.873.925a8 8 0 0 0-.906-.524l-.443.896c.275.136.54.29.793.459l.556-.831zM4.46.824c-.314.155-.616.33-.905.524l.556.83a7.07 7.07 0 0 1 .793-.458L4.46.824zM2.725 1.985c-.262.23-.51.478-.74.74l.752.66c.202-.23.418-.446.648-.648l-.66-.752zm11.29.74a8.058 8.058 0 0 0-.74-.74l-.66.752c.23.202.447.418.648.648l.752-.66zm1.161 1.735a7.98 7.98 0 0 0-.524-.905l-.83.556c.169.253.322.518.458.793l.896-.443zM1.348 3.555c-.194.289-.37.591-.524.906l.896.443c.136-.275.29-.54.459-.793l-.831-.556zM.423 5.428a7.945 7.945 0 0 0-.27 1.011l.98.194c.06-.302.14-.597.237-.884l-.947-.321zM15.848 6.44a7.943 7.943 0 0 0-.27-1.012l-.948.321c.098.287.177.582.237.884l.98-.194zM.017 7.477a8.113 8.113 0 0 0 0 1.046l.998-.064a7.117 7.117 0 0 1 0-.918l-.998-.064zM16 8a8.1 8.1 0 0 0-.017-.523l-.998.064a7.11 7.11 0 0 1 0 .918l.998.064A8.1 8.1 0 0 0 16 8zM.152 9.56c.069.346.16.684.27 1.012l.948-.321a6.944 6.944 0 0 1-.237-.884l-.98.194zm15.425 1.012c.112-.328.202-.666.27-1.011l-.98-.194c-.06.302-.14.597-.237.884l.947.321zM.824 11.54a8 8 0 0 0 .524.905l.83-.556a6.999 6.999 0 0 1-.458-.793l-.896.443zm13.828.905c.194-.289.37-.591.524-.906l-.896-.443c-.136.275-.29.54-.459.793l.831.556zm-12.667.83c.23.262.478.51.74.74l.66-.752a7.047 7.047 0 0 1-.648-.648l-.752.66zm11.29.74c.262-.23.51-.478.74-.74l-.752-.66c-.201.23-.418.447-.648.648l.66.752zm-1.735 1.161c.314-.155.616-.33.905-.524l-.556-.83a7.07 7.07 0 0 1-.793.458l.443.896zm-7.985-.524c.289.194.591.37.906.524l.443-.896a6.998 6.998 0 0 1-.793-.459l-.556.831zm1.873.925c.328.112.666.202 1.011.27l.194-.98a6.953 6.953 0 0 1-.884-.237l-.321.947zm4.132.271a7.944 7.944 0 0 0 1.012-.27l-.321-.948a6.954 6.954 0 0 1-.884.237l.194.98zm-2.083.135a8.1 8.1 0 0 0 1.046 0l-.064-.998a7.11 7.11 0 0 1-.918 0l-.064.998zM4.5 7.5a.5.5 0 0 0 0 1h7a.5.5 0 0 0 0-1h-7z" />
                                </svg>
                            </button>
                        </div>
                    ))}

                </div>



                <div className="row mt-5 ">
                    <label className="col-1 align-self-start titlerow">商品規格</label>

                    <div className="col">
                        <div className="gray3 incontentText titlerow top2-r10px ps-2">庫存與規格</div>
                        <div className="txtara">
                            <div className="container">
                                <div className="row">
                                    <div className="col-md-4">
                                        <div>
                                            <label className='mt-3'>處理器 (CPU):</label>
                                            <input
                                                type="text"
                                                name="cpu"
                                                placeholder="輸入處理器規格"
                                                className="form-control"
                                                value={cpu}
                                                onChange={(e) => setCpu(e.target.value)}
                                            />
                                        </div>
                                        <div>
                                            <label className='mt-3'>顯示卡 (GPU):</label>
                                            <input
                                                type="text"
                                                name="gpu"
                                                placeholder="輸入顯示卡規格"
                                                className="form-control"
                                                value={gpu}
                                                onChange={(e) => setGpu(e.target.value)}
                                            />
                                        </div>
                                        <div>
                                            <label className='mt-3'>記憶體 (RAM):</label>
                                            <input
                                                type="text"
                                                name="ram"
                                                placeholder="輸入記憶體規格"
                                                className="form-control"
                                                value={ram}
                                                onChange={(e) => setRam(e.target.value)}
                                            />
                                        </div>
                                    </div>
                                    <div className="col-md-4">
                                        <div>
                                            <label className='mt-3'>作業系統 (OS):</label>
                                            <input
                                                type="text"
                                                name="os"
                                                placeholder="輸入作業系統版本"
                                                className="form-control"
                                                value={os}
                                                onChange={(e) => setOs(e.target.value)}
                                            />
                                        </div>
                                        <div>
                                            <label className='mt-3'>螢幕 (Screen):</label>
                                            <input
                                                type="text"
                                                name="screen"
                                                placeholder="輸入螢幕規格"
                                                className="form-control"
                                                value={screen}
                                                onChange={(e) => setScreen(e.target.value)}
                                            />
                                        </div>
                                        <div>
                                            <label className='mt-3'>電池 (Battery):</label>
                                            <input
                                                type="text"
                                                name="battery"
                                                placeholder="輸入電池資訊"
                                                className="form-control"
                                                value={battery}
                                                onChange={(e) => setBattery(e.target.value)}
                                            />
                                        </div>
                                    </div>
                                    <div className="col-md-4 mb-2" >
                                        <div>
                                            <label className='mt-3'>保固期 (Warranty):</label>
                                            <input
                                                type="text"
                                                name="warranty"
                                                placeholder="輸入保固期資訊"
                                                className="form-control"
                                                value={warranty}
                                                onChange={(e) => setWarranty(e.target.value)}
                                            />
                                        </div>
                                        <div>
                                            <label className='mt-3'>尺寸 (Size):</label>
                                            <input
                                                type="text"
                                                name="size"
                                                placeholder="輸入尺寸資訊"
                                                className="form-control"
                                                value={size}
                                                onChange={(e) => setSize(e.target.value)}
                                            />
                                        </div>
                                        <div>
                                            <label className='mt-3'>重量 (Weight):</label>
                                            <input
                                                type="text"
                                                name="weight"
                                                placeholder="輸入重量資訊"
                                                className="form-control"
                                                value={weight}
                                                onChange={(e) => setWeight(e.target.value)}
                                            />
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>
            </>

        )
    );
}

export default LaptopSpecifications;
