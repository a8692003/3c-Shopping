import React, { useState, useRef, useEffect } from 'react';
import defaultImage from '../../assets/img/normal/defaultImage.jpg';
function FileUploader({ onFilesSelect, initialMainImageIndex, onMainImageChange }) {
    const [fileNames, setFileNames] = useState([]);
    const [fileInputs, setFileInputs] = useState([]);
    const fileInputRefs = useRef([]);
    const [mainImageIndex, setMainImageIndex] = useState(initialMainImageIndex);
    const [objectURLs, setObjectURLs] = useState({});

    const handleFileChange = (index, event) => {
        const file = event.target.files[0];
        const updatedFiles = [...fileInputs];
        const updatedFileNames = [...fileNames];
        const filenameRegex = /^[a-zA-Z0-9_-]+(\.[a-z]+)?$/;

        if (file && !filenameRegex.test(file.name)) {
            alert('文件名只能包含英文字母、數字、底線。請重新選擇一個有效的文件。');
            event.target.value = '';
            return;
        }

        if (file && !file.type.startsWith("image/")) {
            alert('請上傳一個圖片檔。');
            event.target.value = '';
            return;
        }

        if (file) {
            updatedFiles[index] = file;
            updatedFileNames[index] = file.name;
            setFileInputs(updatedFiles);
            setFileNames(updatedFileNames);

            if (typeof onFilesSelect === "function") {
                onFilesSelect(updatedFiles.filter(f => f));
            }
        }
    };

    const removeFileInput = (indexToRemove) => {
        const updatedFileInputs = fileInputs.filter((_, index) => index !== indexToRemove);
        const updatedFileNames = fileNames.filter((_, index) => index !== indexToRemove);
        if (fileInputRefs.current[indexToRemove]) {
            fileInputRefs.current[indexToRemove].value = '';
        }

        setFileInputs(updatedFileInputs);
        setFileNames(updatedFileNames);

        if (typeof onFilesSelect === "function") {
            onFilesSelect(updatedFileInputs.filter(f => f));
        }

        if (objectURLs[indexToRemove]) {
            URL.revokeObjectURL(objectURLs[indexToRemove]);
            setObjectURLs(prev => {
                const newURLs = { ...prev };
                delete newURLs[indexToRemove];
                return newURLs;
            });
        }
    };

    const addNewFileInput = (event) => {
        event.preventDefault();

        if (fileInputs.length >= 6) {
            alert('最多只能上傳6張圖片！');
            return;
        }
        setFileInputs([...fileInputs, {}]);
    };

    const displayImage = (index) => {
        if (fileInputs[index] && fileInputs[index] instanceof Blob) {
            if (!objectURLs[index]) {
                const url = URL.createObjectURL(fileInputs[index]);
                setObjectURLs(prev => ({ ...prev, [index]: url }));
                return url;
            }
            return objectURLs[index];
        }
        return defaultImage;  // 注意，你必須在某處定義這個defaultImage
    };

    useEffect(() => {
        return () => {
            Object.values(objectURLs).forEach(URL.revokeObjectURL);
        };
    }, [objectURLs]);
    return (
        <>

            <div className="row align-items-center mt-5">
                <label className="col-1 col-form-label">圖片</label>
                <div className="col">
                    <div className="row">
                        {fileInputs.map((_, index) => (
                            <div className="col-4 mb-3" key={index}>
                                <div className="input-group">
                                    <div className="custom-file">
                                        <input
                                            type="file"
                                            className="custom-file-input"
                                            id={`inputGroupFile${index + 1}`}
                                            onChange={(e) => handleFileChange(index, e)}
                                            accept="image/*"
                                            name="productImage"
                                            ref={(el) => fileInputRefs.current[index] = el}
                                        />

                                        <label className="custom-file-label" htmlFor={`inputGroupFile${index + 1}`}>
                                            {fileNames[index] || '選擇檔案'}
                                        </label>
                                        <div className="form-check">
                                            <input
                                                className="form-check-input"
                                                type="radio"
                                                name="mainImageChoice"
                                                id={`mainImageChoice${index + 1}`}
                                                value={index}
                                                checked={mainImageIndex === index}
                                                onChange={() => {
                                                    setMainImageIndex(index);
                                                    if (onMainImageChange) {
                                                        onMainImageChange(index); // selectedIndex 是被選擇的圖像索引
                                                    }
                                                }}
                                            />
                                            <label className="form-check-label" htmlFor={`mainImageChoice${index + 1}`}>
                                                作為介紹圖
                                            </label>
                                        </div>
                                    </div>
                                    <div className="input-group-append">
                                        <button className="btn btn-danger" type="button" onClick={() => removeFileInput(index)}>取消</button>
                                     
                                    </div>
                                    <img
                                        src={displayImage(index)}
                                        alt={`Uploaded ${index + 1}`}
                                        className="img-fluid rounded shadow ms-3"
                                        style={{ width: "80px", height: "auto", objectFit: "cover" }}
                                    />
                                </div>
                            </div>
                        ))}
                    </div>

                    {fileInputs.length < 7 && (
                        <button type="button" onClick={(e) => addNewFileInput(e)} className="btn btn-secondary m-1">新增更多圖片</button>
                    )}
                    <span className="col ms-3">已上傳的圖片數量：{fileNames.length}</span>
                </div>
            </div>

        </>
    );
}

export default FileUploader;