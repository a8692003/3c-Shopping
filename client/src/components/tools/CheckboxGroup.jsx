function CheckboxGroup({ title, name, options, onChange, value }) {
    const isAllSelected = value.includes("2");

    const handleCheckboxChange = (selectedValue) => {
        let newValues;

        if (selectedValue === "2") { // 全選
            if (isAllSelected) {
                newValues = [];
            } else {
                newValues = options.map(o => o.value);
                newValues.push("2"); // 代表全選
            }
        } else {
            if (value.includes(selectedValue)) {
                newValues = value.filter(v => v !== selectedValue);
            } else {
                newValues = [...value, selectedValue];
            }

            // 檢查是否全部都被選中
            if (options.every(o => newValues.includes(o.value))) {
                newValues.push("2");
            } else {
                newValues = newValues.filter(v => v !== "2");
            }
        }

        onChange(name, newValues);
    };

    return (
        <div className="col">
            <div className="gray3 incontentText titlerow top2-r10px ps-2">方式</div>
            <div className="txtara">
                <div className="p-3 row">
                    {/* 全選選項 */}
                    <div className="ms-3 col form-check">
                        <input
                            type="checkbox"
                            className="form-check-input"
                            id={`selectAll-${name}`} // 使用name屬性作為前綴
                            value="2"
                            checked={isAllSelected}
                            onChange={() => handleCheckboxChange("2")}
                        />
                        <label className="form-check-label" htmlFor={`selectAll-${name}`}>
                            全選
                        </label>
                    </div>
                    {options.map((option, index) => (
                        <div key={index} className="ms-3 col form-check">
                            <input
                                type="checkbox"
                                className="form-check-input"
                                id={option.id}
                                value={option.value}
                                checked={value.includes(option.value)}
                                onChange={() => handleCheckboxChange(option.value)}
                            />
                            <label className="form-check-label" htmlFor={option.id}>
                                {option.label}
                            </label>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
}

export default CheckboxGroup;
