import React from 'react';
import '../../assets/styles/WarningMessage.css'

function WarningMessage({ message }) {
    return (
        <div className="warning-message-container">
            {message ? (<>
                <label className="fas fa-info-circle">⚠️</label> 
                <b>{message}</b>
            </>) : "No error message"}
        </div>
    );
}


export default WarningMessage;
