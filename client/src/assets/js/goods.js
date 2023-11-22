function showCategories() {
    resetMenu();
    document.getElementById('category-selection').style.display = 'block';
}

function resetMenu() {
    document.getElementById('category-selection').style.display = 'none';
    document.getElementById('sub-category-selection').style.display = 'none';
    document.getElementById('main-category').innerText = '選擇分類';
}

function selectMainCategory(category, subCategoryType) {
    document.getElementById('main-category').innerText = category;
    document.getElementById('category-selection').style.display = 'none';

    var subCategoryDiv = document.getElementById('sub-category-selection');
    subCategoryDiv.innerHTML = '';

    if (subCategoryType === '品牌') {
        subCategoryDiv.innerHTML += '<button onclick="selectSubCategory(\'品牌1\')">品牌1</button>';
        subCategoryDiv.innerHTML += '<button onclick="selectSubCategory(\'品牌2\')">品牌2</button>';
    } else if (subCategoryType === '種類') {
        subCategoryDiv.innerHTML += '<button onclick="selectSubCategory(\'種類1\')">種類1</button>';
        subCategoryDiv.innerHTML += '<button onclick="selectSubCategory(\'種類2\')">種類2</button>';
    }

    subCategoryDiv.style.display = 'block';
}

function selectSubCategory(subCategory) {
    var mainCategory = document.getElementById('main-category').innerText;
    document.getElementById('main-category').innerText = mainCategory + ' > ' + subCategory;
    document.getElementById('sub-category-selection').style.display = 'none';
}
