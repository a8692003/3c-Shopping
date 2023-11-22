// CategoryDropdown.js
import React from 'react';
import { Dropdown } from 'react-bootstrap';

const CategoryDropdown = ({ categories, selectedCategory, onCategorySelect }) => {
    return (
        <Dropdown className='dropdown-fullwidth'>
            <Dropdown.Toggle variant="secondary" id="categoryDropdown">
                {selectedCategory?.category || productState.product.categoryName || "選擇分類"}
            </Dropdown.Toggle>

            <Dropdown.Menu>
                {categories.map(category => (
                    <Dropdown.Item
                        key={category.category_id}
                        onClick={() => onCategorySelect(category)}
                    >
                        {category.category}
                    </Dropdown.Item>
                ))}
            </Dropdown.Menu>
        </Dropdown>
    );
};

export default CategoryDropdown;
