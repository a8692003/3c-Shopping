const path = require('path');

// function getRelativePath(absolutePath) {
//     console.log("Absolute Path:", absolutePath);
//     let relativePath = path.relative(path.join(__dirname, '..','public'), absolutePath);
//     console.log("Generated Relative Path:", relativePath);
//     return relativePath.replace(/\\/g, '/');
// }



function getRelativePath(absolutePath) {
    console.log("Absolute Path:", absolutePath);
    
    // 計算從 public 目錄到給定的絕對路徑的相對路徑
    let relativePath = path.relative(path.join(__dirname, '..','..', 'public'), absolutePath);
    
    console.log("Generated Relative Path:", relativePath);

    // 將所有反斜線替換為正斜線
    return relativePath.replace(/\\/g, '/');
}
module.exports = {
    getRelativePath
};