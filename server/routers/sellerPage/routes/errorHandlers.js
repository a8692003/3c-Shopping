// errorHandlers.js

exports.handleDbError = (err, res) => {
    if (err.code === 'ER_DUP_ENTRY') {
        res.status(400).json({ success: false, message: 'Duplicate entry detected!' });
    } else {
        res.status(500).json({ success: false, message: 'Server error.' });
    }
};
