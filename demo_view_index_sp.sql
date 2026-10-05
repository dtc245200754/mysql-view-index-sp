-- ============================================================================
-- BÀI TẬP: VIEW, INDEX, STORED PROCEDURE
-- CSDL: demo | Bảng: Products
-- ============================================================================

-- BƯỚC 1: Tạo cơ sở dữ liệu demo
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- BƯỚC 2: Tạo bảng Products và chèn dữ liệu mẫu
CREATE TABLE IF NOT EXISTS Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL UNIQUE,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10,2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus BIT DEFAULT 1
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) 
VALUES 
    ('P001', 'iPhone 15', 25000000.00, 10, 'Apple Smartphone', 1),
    ('P002', 'Samsung Galaxy S24', 22000000.00, 15, 'Samsung Smartphone', 1),
    ('P003', 'MacBook Air M2', 28000000.00, 8, 'Apple Laptop', 1),
    ('P004', 'Dell XPS 13', 30000000.00, 5, 'Dell Laptop', 1),
    ('P005', 'iPad Pro', 20000000.00, 12, 'Apple Tablet', 0);

-- BƯỚC 3: Tạo Index và dùng EXPLAIN so sánh
-- 3.1. Kiểm tra câu lệnh truy vấn trước khi tạo Index thêm
EXPLAIN SELECT * FROM Products WHERE productCode = 'P001';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15' AND productPrice = 25000000.00;

-- 3.2. Tạo Unique Index trên cột productCode
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- 3.3. Tạo Composite Index trên 2 cột productName và productPrice
CREATE INDEX idx_productName_price ON Products(productName, productPrice);

-- 3.4. Kiểm tra câu lệnh truy vấn sau khi tạo Index (Số dòng quét 'rows' sẽ giảm tối đa)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P001';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15' AND productPrice = 25000000.00;

-- BƯỚC 4: Thao tác với View
-- 4.1. Tạo View lấy thông tin: productCode, productName, productPrice, productStatus
CREATE VIEW view_product_info AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Xem dữ liệu từ View
SELECT * FROM view_product_info;

-- 4.2. Sửa đổi View (Bổ sung thêm cột productAmount)
CREATE OR REPLACE VIEW view_product_info AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;

-- 4.3. Xoá View
DROP VIEW view_product_info;

-- BƯỚC 5: Tạo các Stored Procedure
DELIMITER //

-- 5.1. SP lấy tất cả thông tin của sản phẩm
CREATE PROCEDURE sp_get_all_products()
BEGIN
    SELECT * FROM Products;
END //

-- 5.2. SP thêm một sản phẩm mới
CREATE PROCEDURE sp_add_product(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status BIT
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //

-- 5.3. SP sửa thông tin sản phẩm theo id
CREATE PROCEDURE sp_update_product(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status BIT
)
BEGIN
    UPDATE Products
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //

-- 5.4. SP xoá sản phẩm theo id
CREATE PROCEDURE sp_delete_product(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;

-- Test thử gọi các Stored Procedure:
-- CALL sp_get_all_products();
-- CALL sp_add_product('P006', 'Apple Watch', 10000000.00, 20, 'Smartwatch', 1);
-- CALL sp_update_product(1, 'P001', 'iPhone 15 Pro', 27000000.00, 8, 'Apple Smartphone Pro', 1);
-- CALL sp_delete_product(5);