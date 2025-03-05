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
-- Lấy 5 thông tin sinh viên gỗm mã, tên, email, ngày sinh, xếp loại và trạng thái được sắp xếp theo tên sinh viên tăng dần
SELECT Student_id,student_full_name,student_email,student_bod,student_rank,student_status
FROM student
ORDER BY student_full_name ASC
LIMIT 5
-- Lấy thông tin các môn học gồm mã, tên, số tín chỉ và sắp xếp theo số tín chỉ giảm dần
SELECT Subject_id,Subject_name,Subject_credit
FROM subject
ORDER BY Subject_credit 
-- Lấy thông tin sinh viên gồm mã sinh viên, tên sinh viên, tên môn học, điểm kết thúc đăng ký mà có điểm đăng ký nhỏ hơn 50 và chưa hoàn thành môn học
SELECT student.student_id,student.student_full_name,subject.subject_name, enrollment.enroll_grade
FROM student
JOIN enrollment ON student.student_id= enrollment.student_id
JOIN subject ON subject.subject_id = enrollment.subject_id
WHERE enrollment.enroll_grade < 50 AND enrollment.enroll_completion_date is null
-- Lấy danh sách sinh viên gồm mã lần đăng ký, mã sinh viên, mã môn học, điểm kết thúc đăng ký của môn học “Lập trình C” và sắp xếp theo điểm kết thúc giảm dần
SELECT enrollment.enroll_id, enrollment.student_id, enrollment.subject_id, enrollment.enroll_grade
FROM enrollment
JOIN subject ON subject.subject_id= enrollment.subject_id
WHERE subject.subject_name = 'Lập trình C'
--- Lấy danh sách sinh viên đã đăng ký ít nhất 2 môn học và có điểm cuối môn trên 50 gồm mã sinh viên, tên sinh viên, số môn học đã đăng ký
SELECT student.student_id, student.student_full_name, COUNT(enrollment.student_id) AS so_mon_dang_ky
FROM student
JOIN enrollment ON student.student_id =enrollment.student_id
WHERE enrollment.enroll_grade > 50
GROUP BY student.student_id, student.student_full_name
HAVING COUNT(enrollment.student_id) >= 2;
---Lấy danh sách các môn học có điểm trung bình dưới 50 và có ít nhất 3 sinh viên tham gia bao gồm mã sinh viên, tên sinh viên, tên môn học, điểm trung bình của môn học

SELECT student.student_id, student.student_full_name, subject.subject_name, AVG(enroll_grade) AS
diem_trung_binh
FROM student
JOIN enrollment ON student.student_id = enrollment.student_id
JOIN subject ON subject.subject_id = enrollment.subject_id
GROUP BY student.student_id, student.student_full_name, subject.subject_name
HAVING AVG(enroll_grade) < 50 AND COUNT(student.student_id) >= 3;

-- Lấy danh sách sinh viên có điểm trung bình các môn học lớn hơn 70 gồm mã sinh viên, tên sinh viên, mã môn học, điểm trung bình các môn học
SELECT student.student_id,student.student_full_name, enrollment.subject_id, AVG(enrollment.enroll_grade) as diem_TB
FROM student
JOIN enrollment ON enrollment.student_id = student.student_id
GROUP BY student.student_id, student.student_full_name, enrollment.subject_id
HAVING AVG(enrollment.enroll_grade) > 70;
--Lấy danh sách các sinh viên có điểm thi của lần đăng ký cao hơn điểm trung bình của tất cả các sinh viên cho cùng môn học

SELECT student.student_id, student.student_full_name, enrollment.enroll_id, enrollment.enroll_grade, AVG(enroll_grade) AS diem_TB
FROM student
JOIN enrollment ON student.student_id = enrollment.student_id
GROUP BY student.student_id, student.student_full_name, enrollment.enroll_id, enrollment.enroll_grade
HAVING enrollment.enroll_grade > (
    SELECT AVG(enroll_grade)
    FROM enrollment
    WHERE enrollment.subject_id = enrollment.subject_id
);
