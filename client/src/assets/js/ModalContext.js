import React, { createContext, useState } from 'react';

export const ModalContext = createContext();

export const ModalProvider = ({ children }) => {
    const [isVisible, setIsVisible] = useState(false);
    const [modalContent, setModalContent] = useState(null);

    return (
        <ModalContext.Provider value={{ isVisible, setIsVisible, modalContent, setModalContent }}>
            {children}
        </ModalContext.Provider>
    );
};
