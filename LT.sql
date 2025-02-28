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
ADD email varchar(100) not null UNIQUE
--3.2 Xóa cột ngày sinh ra khỏi bảng Employees
ALTER TABLE employees 
DROP COLUMN birthday


