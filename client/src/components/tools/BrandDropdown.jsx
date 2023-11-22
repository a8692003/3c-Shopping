// BrandDropdown.js
import React from 'react';
import { Dropdown } from 'react-bootstrap';

const BrandDropdown = ({ brands, selectedBrand, onBrandSelect }) => {
    return (
        <Dropdown className='dropdown-fullwidth'>
            <Dropdown.Toggle variant="secondary" id="brandDropdown">
                {selectedBrand.brand || "選擇品牌"}
            </Dropdown.Toggle>

            <Dropdown.Menu>
                {brands.map(brand => (
                    <Dropdown.Item
                        key={brand.brand_id}
                        onClick={() => onBrandSelect(brand)}
                    >
                        {brand.brand}
                    </Dropdown.Item>
                ))}
            </Dropdown.Menu>
        </Dropdown>
    );
};

export default BrandDropdown;
