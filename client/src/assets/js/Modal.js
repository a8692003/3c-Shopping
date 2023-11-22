import React, { useContext } from 'react';
import ReactDOM from 'react-dom';
import { ModalContext } from './ModalContext';

const Modal = () => {
    const { isVisible, setIsVisible, modalContent } = useContext(ModalContext);

    if (!isVisible) return null;

    return ReactDOM.createPortal(
        <div className="modal-overlay">
            <div className="modal-content">
                {modalContent}
                <button onClick={() => setIsVisible(false)}>Close</button>
            </div>
        </div>,
        document.body
    );
};

export default Modal;
