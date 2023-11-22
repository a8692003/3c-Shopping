const express = require('express');
const router = express.Router();
const db = require('./database');

router.get('/tag', (req, res) => {
    const query = `SELECT * FROM tag`;
    db.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

module.exports = router;
