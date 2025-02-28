--Câu 2 - Tạo bảng
-- tạo cơ sở dữ liệu 
CREATE DATABASE quanlybanhang
use quanlybanhang
--- tao bang

CREATE TABLE customers(
	customer_id int PRIMARY KEY AUTO_INCREMENT,
    customer_name varchar(100) not null,
    phone varchar(20) not null UNIQUE,
    address varchar(255)
);
CREATE TABLE products (
	product_id int PRIMARY KEY AUTO_INCREMENT,
    product_name varchar(100) not null UNIQUE,
    price decimal(10,2) not null,
    quantity int not null CHECK (quantity >=0),
    category VARCHAR(10) not null
);
CREATE TABLE employees(
	employee_id int PRIMARY KEY AUTO_INCREMENT,
    employee_name varchar(100) not null,
    birthday date,
    position varchar(50) NOT null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) DEFAULT 0
);
CREATE TABLE orders (
	order_id int PRIMARY KEY AUTO_INCREMENT,
    customer_id int,
    employee_id int,
    order_date datetime DEFAULT CURRENT_TIMESTAMP(),
    total_amount decimal(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
CREATE TABLE orderDEtails(
	order_detail_id int AUTO_INCREMENT PRIMARY KEY,
    order_id int,
    product_id int,
    quantity int NOT null check (quantity >0),
    unit_price decimal(10,2) NOT null
);

--Câu 3 - Chỉnh sửa cấu trúc bảng
--3.1 Thêm cột email có kiểu dữ liệu varchar(100) not null unique vào bảng Customers
ALTER TABLE customers
ADD COLUMN email varchar(100) not null UNIQUE
--3.2 Xóa cột ngày sinh ra khỏi bảng Employees
ALTER TABLE employees 
DROP COLUMN birthday
--Câu 4 - Chèn dữ liệu

-- Customers table
INSERT INTO customers (customer_name, phone, address, email)
VALUES ('bin', '09092783826', 'LT', 'a@gmail.com'),
       ('Ha', '0878738233', 'DN', 'b@gmail.com'),
       ('Han', '087865136465', 'HN', 'c@gmail.com'),
       ('Hai', '087546546321', 'HCM', 'd@gmail.com'),
       ('Hau', '0654895233', 'DN', 'e@gmail.com');
       
-- Products table
INSERT INTO products (product_name, price, quantity, category)
VALUES ('iphone 16', 2000, 10, 'dien thoai'),
       ('oppo', 2000, 10, 'dien thoai'),
       ('may giat', 2000, 10, 'dien gia dung'),
       ('asus pro 1', 2000, 10, 'laptop'),
       ('lenovo 1', 2000, 10, 'laptop');

-- Employees table
INSERT INTO employees (employee_name, position, salary, revenue)
VALUES ('TA', 'NV', 1, 900),
       ('TAN', 'NV', 2, 900),
       ('NGOC', 'QL', 100, 90000),
       ('TRAN', 'NV', 10, 900),
       ('TRA', 'NV', 100, 900);

-- Orders table
INSERT INTO orders (customer_id, employee_id, order_date, total_amount)
VALUES (1, 1, CURRENT_TIMESTAMP, 4000),
       (2, 3, CURRENT_TIMESTAMP, 2000),
       (3, 2, CURRENT_TIMESTAMP, 6000),
       (4, 3, CURRENT_TIMESTAMP, 2000),
       (5, 4, CURRENT_TIMESTAMP, 8000);

-- OrderDetails table
INSERT INTO orderdetails (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 2, 2000),
       (2, 2, 1, 2000),
       (3, 3, 3, 2000),
       (4, 4, 1, 2000),
       (5, 5, 4, 2000);


-- Câu 5 - Truy vấn cơ bản 
-- 5.1 Lấy danh sách tất cả khách hàng từ bảng Customers. Thông tin gồm : mã khách hàng, tên khách hàng, email, số điện thoại và địa chỉ
SELECT * FROM customers;


-- 5.2 Sửa thông tin của sản phẩm có product_id = 1 theo yêu cầu : product_name= “Laptop Dell XPS” và price = 99.99
UPDATE products
SET product_name = 'Laptop Dell XPS', price = 99.99
WHERE product_id = 1;

-- 5.3 Lấy thông tin những đơn đặt hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt hàng.
SELECT orders.order_id, customers.customer_name, employees.employee_name, orders.total_amount,orders.total_amount
FROM orders
JOIN customers ON orders.customer_id= customers.customer_id
JOIN employees ON employees.employee_id =orders.employee_id

-- Câu 6 - Truy vấn đầy đủ 
-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên khách hàng, tổng số đơn
SELECT customers.customer_id, customers.customer_name, COUNT(orders.order_id) AS tong_don_hang
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.customer_name;



-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm : mã nhân viên, tên nhân viên, doanh thu
SELECT employees.employee_id, employees.employee_name, SUM(orders.total_amount) AS doanh_thu
FROM employees
JOIN orders ON employees.employee_id = orders.employee_id
WHERE YEAR(orders.order_date) = YEAR(CURRENT_DATE())
GROUP BY employees.employee_id, employees.employee_name;

-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại. Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng giảm dần
SELECT p.product_id, p.product_name, SUM(od.quantity) AS so_luot_dat
FROM products p
JOIN orderdetails od ON p.product_id = od.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE MONTH(o.order_date) = MONTH(CURRENT_DATE()) 
  AND YEAR(o.order_date) = YEAR(CURRENT_DATE())
GROUP BY p.product_id, p.product_name
HAVING SUM(od.quantity) > 1
ORDER BY so_luot_dat DESC;

-- Câu 7 - Truy vấn nâng cao 
-- 7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và tên khách hàng
SELECT customers.customer_id, customers.customer_name
FROM customers
LEFT JOIN orders ON orders.customer_id =customers.customer_id
WHERE orders.customer_id IS NULL

-- 7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
SELECT * FROM products
WHERE products.price > (SELECT AVG(price) FROM products)
ORDER BY price DESC


-- 7.3 Tìm những khách hàng có mức chi tiêu cao nhất. Thông tin gồm : mã khách hàng, tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết)
WITH CustomerSpending AS (
    SELECT 
        c.customer_id, 
        c.customer_name, 
        SUM(o.total_amount) AS tong_chi_tieu
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
),
MaxSpending AS (
    SELECT MAX(tong_chi_tieu) AS max_spending
    FROM CustomerSpending
)
SELECT 
    cs.customer_id, 
    cs.customer_name, 
    cs.tong_chi_tieu
FROM CustomerSpending cs, MaxSpending ms
WHERE cs.tong_chi_tieu = ms.max_spending;

-- Câu 8 - Tạo view
-- 8.1 Tạo view có tên view_order_list hiển thị thông tin đơn hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt. Các bản ghi sắp xếp theo thứ tự ngày đặt mới nhất

CREATE VIEW view_order_list AS
SELECT orders.order_id, customers.customer_name, employees.employee_name, orders.total_amount, orders.order_date
FROM orders
JOIN customers ON customers.customer_id= orders.customer_id
JOIN employees ON employees.employee_id = orders.employee_id
ORDER BY orders.order_date DESC
-- 8.2 Tạo view có tên view_order_detail_product hiển thị chi tiết đơn hàng gồm : Mã chi tiết đơn hàng, tên sản phẩm, số lượng và giá tại thời điểm mua. Thông tin sắp xếp theo số lượng giảm dần
CREATE VIEW view_order_detail_product  AS
SELECT orderdetails.order_detail_id, products.product_name, orderdetails.quantity,orderdetails.unit_price
FROM orderdetails
 LEFT JOIN products ON products.product_id = orderdetails.product_id
 ORDER BY orderdetails.quantity DESC


-- Câu 9 - Tạo thủ tục lưu trữ
-- 9.1 Tạo thủ tục có tên proc_insert_employee nhận vào các thông tin cần thiết (trừ mã nhân viên và tổng doanh thu) , thực hiện thêm mới dữ liệu vào bảng nhân viên và trả về mã nhân viên vừa mới thêm. 
DELIMITER //
CREATE PROCEDURE proc_insert_employee (IN name varchar(100) ,IN salary decimal(10,2) , IN position varchar(50), OUT id int )
BEGIN
	INSERT INTO employees(employee_name,position,salary,revenue)
    VALUES (name,position,salary,0);
    SET id = LAST_INSERT_ID();
END //
DELIMITER ;

-- goi ham 
set @id=0;
CALL proc_insert_employee('helo',10.2,'abc', @id);
SELECT @id as 'id nhan vien moi';


-- 9.2 Tạo thủ tục có tên proc_get_orderdetails lọc những chi tiết đơn hàng dựa theo mã đặt hàng.
DELIMITER //
CREATE PROCEDURE proc_get_orderdetails (IN order_id int )
BEGIN
    SELECT * FROM orderdetails
    WHERE orderdetails.order_id = order_id
 
END //
DELIMITER ;
-- 9.3 Tạo thủ tục có tên proc_cal_total_amount_by_order nhận vào tham số là mã đơn hàng và trả về số lượng loại sản phẩm trong đơn hàng đó.
DELIMITER //
CREATE PROCEDURE proc_cal_total_amount_by_order (IN p_order_id int, OUT count_product int)
BEGIN
    SELECT COUNT(product_id) INTO count_product
    FROM orderdetails
    WHERE order_id = p_order_id;
END //
DELIMITER ;
-- Câu 10 - Tạo trigger
-- Tạo trigger có tên trigger_after_insert_order_details để tự động cập nhật số lượng sản phẩm trong kho mỗi khi thêm một chi tiết đơn hàng mới. Nếu số lượng trong kho không đủ thì ném ra thông báo lỗi “Số lượng sản phẩm trong kho không đủ” và hủy thao tác chèn.


DELIMITER //
CREATE TRIGGER trigger_after_insert_order_details 
BEFORE INSERT ON orderdetails 
FOR EACH ROW
BEGIN
	DECLARE product_quantity INT;
 	SELECT quantity INTO product_quantity FROM products 
	 WHERE product_id = NEW.product_id; 
	IF product_quantity < NEW.quantity THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='so luong san pham khong du roi';
     ELSE 
     	UPDATE products
        SET quantity = quantity - NEW.quantity
        WHERE product_id - NEW.product_id;
      END IF;


END //
DELIMITER ;