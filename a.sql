--tạo bảng
-- Create Student table
CREATE TABLE Student (
    student_id CHAR(5) PRIMARY KEY,
    student_full_name VARCHAR(150) NOT NULL,
    student_email VARCHAR(255) UNIQUE,
    student_bod DATE NOT NULL,
    student_rank ENUM('Yếu', 'Trung Bình', 'Khá', 'Giỏi', 'Xuất sắc'),
    student_status ENUM('Đang học', 'Đã tốt nghiệp', 'Đình chỉ', 'Bảo lưu') DEFAULT 'Đang học',
    student_phone CHAR(10) NOT NULL UNIQUE
);

-- Create Subject table
CREATE TABLE Subject (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(200) NOT NULL UNIQUE,
    subject_credit INT NOT NULL,
    subject_status TINYINT(1) DEFAULT 1
);

-- Create Enrollment table
CREATE TABLE Enrollment (
    enroll_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id CHAR(5) NOT NULL,
    subject_id INT NOT NULL,
    enroll_date DATE DEFAULT (CURRENT_DATE),
    registration_number INT DEFAULT 1,
    enroll_grade FLOAT,
    enroll_completion_date DATE,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

-- Create Grade table
CREATE TABLE Grade (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enroll_id INT NOT NULL,
    grade_score FLOAT NOT NULL,
    grade_date DATE,
    FOREIGN KEY (enroll_id) REFERENCES Enrollment(enroll_id)
);


----
ALTER TABLE grade 
ADD COLUMN grade_type ENUM('mid', 'final', 'attendance')
---
ALTER TABLE Grade
MODIFY COLUMN grade_score NOT NULL CHECK (grade_score BETWEEN 0 AND 100);