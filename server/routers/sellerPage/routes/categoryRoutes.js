const express = require('express');
const router = express.Router();
const db = require('./database');

router.get('/category', (req, res) => {
    const query = `SELECT * FROM category`;
    db.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

module.exports = router;
