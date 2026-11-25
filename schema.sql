CREATE DATABASE IF NOT EXISTS university_portal; USE university_portal;
CREATE TABLE departments(id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL UNIQUE,office VARCHAR(100));
CREATE TABLE students(id INT AUTO_INCREMENT PRIMARY KEY,department_id INT NOT NULL,name VARCHAR(120) NOT NULL,email VARCHAR(150) NOT NULL UNIQUE,semester TINYINT NOT NULL,FOREIGN KEY(department_id) REFERENCES departments(id));
CREATE TABLE teachers(id INT AUTO_INCREMENT PRIMARY KEY,department_id INT NOT NULL,name VARCHAR(120) NOT NULL,email VARCHAR(150) NOT NULL UNIQUE,FOREIGN KEY(department_id) REFERENCES departments(id));
CREATE TABLE courses(id INT AUTO_INCREMENT PRIMARY KEY,department_id INT NOT NULL,teacher_id INT,course_code VARCHAR(20) NOT NULL UNIQUE,title VARCHAR(120) NOT NULL,credit_hours TINYINT NOT NULL,FOREIGN KEY(department_id) REFERENCES departments(id),FOREIGN KEY(teacher_id) REFERENCES teachers(id));
CREATE TABLE enrollments(id INT AUTO_INCREMENT PRIMARY KEY,student_id INT NOT NULL,course_id INT NOT NULL,enrolled_on DATE NOT NULL,UNIQUE(student_id,course_id),FOREIGN KEY(student_id) REFERENCES students(id),FOREIGN KEY(course_id) REFERENCES courses(id));
CREATE TABLE attendance(id INT AUTO_INCREMENT PRIMARY KEY,enrollment_id INT NOT NULL,attendance_date DATE NOT NULL,status ENUM('Present','Absent','Late') NOT NULL,UNIQUE(enrollment_id,attendance_date),FOREIGN KEY(enrollment_id) REFERENCES enrollments(id));
INSERT INTO departments(name,office) VALUES('Software Engineering','Block A'),('Computer Science','Block B'),('Data Science','Block C'),('Information Technology','Block D');
INSERT INTO students(department_id,name,email,semester) VALUES(1,'Ayesha Khan','ayesha@example.com',6),(1,'Bilal Ahmed','bilal@example.com',4),(2,'Sara Noor','sara@example.com',5),(2,'Usman Shah','usman@example.com',3),(3,'Hina Raza','hina@example.com',2),(4,'Zain Abbas','zain@example.com',7);
INSERT INTO teachers(department_id,name,email) VALUES(1,'Dr Kamran Ali','kamran@example.com'),(2,'Ms Sana Ahmed','sana@example.com'),(3,'Mr Faraz Noor','faraz@example.com'),(4,'Dr Nadia Shah','nadia@example.com');
INSERT INTO courses(department_id,teacher_id,course_code,title,credit_hours) VALUES(1,1,'SE301','Web Technologies',3),(1,1,'SE302','Software Quality Assurance',3),(2,2,'CS201','Database Systems',4),(3,3,'DS101','Data Science',3),(4,4,'IT205','Computer Networks',3);
INSERT INTO enrollments(student_id,course_id,enrolled_on) VALUES(1,1,'2026-09-01'),(1,2,'2026-09-01'),(2,1,'2026-09-02'),(3,3,'2026-09-01'),(4,3,'2026-09-02'),(5,4,'2026-09-03'),(6,5,'2026-09-03'),(3,1,'2026-09-04');
INSERT INTO attendance(enrollment_id,attendance_date,status) VALUES(1,'2026-09-10','Present'),(1,'2026-09-11','Present'),(1,'2026-09-12','Absent'),(2,'2026-09-10','Present'),(3,'2026-09-10','Late'),(4,'2026-09-10','Present'),(5,'2026-09-10','Absent'),(6,'2026-09-10','Present'),(7,'2026-09-10','Present'),(8,'2026-09-10','Present');
-- 1
SELECT * FROM departments;
-- 2
SELECT * FROM students;
-- 3
SELECT * FROM teachers;
-- 4
SELECT * FROM courses;
-- 5 Students with department names
SELECT s.id,s.name,s.email,d.name AS department FROM students s JOIN departments d ON s.department_id=d.id;
-- 6 Courses with department and teacher
SELECT c.course_code,c.title,d.name AS department,t.name AS teacher FROM courses c JOIN departments d ON c.department_id=d.id LEFT JOIN teachers t ON c.teacher_id=t.id;
-- 7 Students per department
SELECT d.name,COUNT(s.id) AS student_count FROM departments d LEFT JOIN students s ON d.id=s.department_id GROUP BY d.id,d.name;
-- 8 Enrollments per course
SELECT c.title,COUNT(e.id) AS enrollment_count FROM courses c LEFT JOIN enrollments e ON c.id=e.course_id GROUP BY c.id,c.title;
-- 9 Student course list
SELECT s.name,c.title FROM enrollments e JOIN students s ON e.student_id=s.id JOIN courses c ON e.course_id=c.id;
-- 10 Semester 6 or above
SELECT name,semester FROM students WHERE semester>=6;
-- 11 Three-credit courses
SELECT course_code,title FROM courses WHERE credit_hours=3;
-- 12 Attendance detail
SELECT s.name,c.title,a.attendance_date,a.status FROM attendance a JOIN enrollments e ON a.enrollment_id=e.id JOIN students s ON e.student_id=s.id JOIN courses c ON e.course_id=c.id;
-- 13 Attendance percentage by student
SELECT s.name,ROUND(100*SUM(a.status='Present')/COUNT(a.id),2) AS attendance_percentage FROM students s JOIN enrollments e ON s.id=e.student_id JOIN attendance a ON e.id=a.enrollment_id GROUP BY s.id,s.name;
-- 14 Students with no enrollments
SELECT s.name FROM students s LEFT JOIN enrollments e ON s.id=e.student_id WHERE e.id IS NULL;
-- 15 Overall record counts
SELECT (SELECT COUNT(*) FROM students) AS students,(SELECT COUNT(*) FROM teachers) AS teachers,(SELECT COUNT(*) FROM courses) AS courses;
-- 16 Update example
UPDATE students SET semester=7 WHERE email='ayesha@example.com';
-- 17 Optional delete example (uncomment to execute)
-- DELETE FROM attendance WHERE id=10;
