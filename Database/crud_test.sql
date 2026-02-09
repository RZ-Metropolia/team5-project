-- ============================================================
-- CRUD TEST SCRIPT for homework_submission_system
-- Tests Create, Read, Update, and Delete for every table.
-- Run against a fresh instance created by db_script.sql.
-- ============================================================

USE homework_submission_system;

-- Turn off safe-update mode so DELETEs/UPDATEs without key work
SET SQL_SAFE_UPDATES = 0;

-- ============================================================
--  HELPER: clean slate  (reverse FK order)
-- ============================================================
DELETE FROM grades;
DELETE FROM submission_files;
DELETE FROM submissions;
DELETE FROM assignments;
DELETE FROM course_enrollments;
DELETE FROM courses;
DELETE FROM users;

-- Reset auto-increment counters
ALTER TABLE users             AUTO_INCREMENT = 1;
ALTER TABLE courses           AUTO_INCREMENT = 1;
ALTER TABLE course_enrollments AUTO_INCREMENT = 1;
ALTER TABLE assignments       AUTO_INCREMENT = 1;
ALTER TABLE submissions       AUTO_INCREMENT = 1;
ALTER TABLE submission_files  AUTO_INCREMENT = 1;
ALTER TABLE grades            AUTO_INCREMENT = 1;

-- ############################################################
--  1. USERS TABLE — CRUD
-- ############################################################

SELECT '========== USERS: CREATE ==========' AS test_section;

INSERT INTO users (role, username, password_hash, full_name, email)
VALUES
    ('teacher', 'prof_jones',  SHA2('password1', 256), 'Dr. Alice Jones',   'alice.jones@university.edu'),
    ('teacher', 'prof_smith',  SHA2('password2', 256), 'Dr. Bob Smith',     'bob.smith@university.edu'),
    ('student', 'jdoe',        SHA2('password3', 256), 'John Doe',          'jdoe@student.edu'),
    ('student', 'mgarcia',     SHA2('password4', 256), 'Maria Garcia',      'mgarcia@student.edu'),
    ('student', 'tnguyen',     SHA2('password5', 256), 'Trang Nguyen',      'tnguyen@student.edu');

-- Verify 5 rows inserted
SELECT 'USERS CREATE — expect 5 rows:' AS test_label, COUNT(*) AS row_count FROM users;

-- --------------------------------------------------------
SELECT '========== USERS: READ ==========' AS test_section;

-- Read all users
SELECT * FROM users ORDER BY user_id;

-- Read by role
SELECT 'Teachers:' AS test_label;
SELECT user_id, username, full_name FROM users WHERE role = 'teacher';

SELECT 'Students:' AS test_label;
SELECT user_id, username, full_name FROM users WHERE role = 'student';

-- Read single user by username
SELECT 'Single user lookup (jdoe):' AS test_label;
SELECT user_id, role, username, full_name, email
FROM users
WHERE username = 'jdoe';

-- --------------------------------------------------------
SELECT '========== USERS: UPDATE ==========' AS test_section;

-- Update email for jdoe
UPDATE users
SET email = 'john.doe.new@student.edu'
WHERE username = 'jdoe';

-- Verify update
SELECT 'USERS UPDATE — jdoe email should be john.doe.new@student.edu:' AS test_label;
SELECT user_id, username, email, updated_at
FROM users
WHERE username = 'jdoe';

-- Update full_name for prof_jones
UPDATE users
SET full_name = 'Dr. Alice M. Jones'
WHERE username = 'prof_jones';

SELECT 'USERS UPDATE — prof_jones name should be Dr. Alice M. Jones:' AS test_label;
SELECT user_id, username, full_name
FROM users
WHERE username = 'prof_jones';

-- --------------------------------------------------------
SELECT '========== USERS: DELETE ==========' AS test_section;

-- Insert a throwaway user to delete
INSERT INTO users (role, username, password_hash, full_name, email)
VALUES ('student', 'temp_user', SHA2('temp', 256), 'Temp User', 'temp@student.edu');

SELECT 'USERS before DELETE — expect 6 rows:' AS test_label, COUNT(*) AS row_count FROM users;

DELETE FROM users WHERE username = 'temp_user';

SELECT 'USERS after DELETE — expect 5 rows:' AS test_label, COUNT(*) AS row_count FROM users;

-- Verify the specific user is gone
SELECT 'USERS DELETE verification — expect 0 rows:' AS test_label, COUNT(*) AS row_count
FROM users WHERE username = 'temp_user';


-- ############################################################
--  2. COURSES TABLE — CRUD
-- ############################################################

SELECT '========== COURSES: CREATE ==========' AS test_section;

INSERT INTO courses (course_name, course_code, created_by)
VALUES
    ('Intro to Databases',   'CS301', (SELECT user_id FROM users WHERE username = 'prof_jones')),
    ('Web Development',      'CS302', (SELECT user_id FROM users WHERE username = 'prof_jones')),
    ('Data Structures',      'CS201', (SELECT user_id FROM users WHERE username = 'prof_smith'));

SELECT 'COURSES CREATE — expect 3 rows:' AS test_label, COUNT(*) AS row_count FROM courses;

-- --------------------------------------------------------
SELECT '========== COURSES: READ ==========' AS test_section;

SELECT * FROM courses ORDER BY course_id;

-- Read with join to get creator name
SELECT 'Courses with creator info:' AS test_label;
SELECT c.course_id, c.course_name, c.course_code, u.full_name AS created_by_name
FROM courses c
JOIN users u ON c.created_by = u.user_id;

-- Read a specific course by code
SELECT 'Single course lookup (CS301):' AS test_label;
SELECT * FROM courses WHERE course_code = 'CS301';

-- --------------------------------------------------------
SELECT '========== COURSES: UPDATE ==========' AS test_section;

-- Archive a course
UPDATE courses
SET is_archived = TRUE
WHERE course_code = 'CS302';

SELECT 'COURSES UPDATE — CS302 should be archived (1):' AS test_label;
SELECT course_id, course_name, course_code, is_archived
FROM courses
WHERE course_code = 'CS302';

-- Rename a course
UPDATE courses
SET course_name = 'Introduction to Database Systems'
WHERE course_code = 'CS301';

SELECT 'COURSES UPDATE — CS301 renamed:' AS test_label;
SELECT course_id, course_name, course_code
FROM courses
WHERE course_code = 'CS301';

-- --------------------------------------------------------
SELECT '========== COURSES: DELETE ==========' AS test_section;

-- Insert a throwaway course
INSERT INTO courses (course_name, course_code, created_by)
VALUES ('Temp Course', 'TEMP100', (SELECT user_id FROM users WHERE username = 'prof_smith'));

SELECT 'COURSES before DELETE — expect 4 rows:' AS test_label, COUNT(*) AS row_count FROM courses;

DELETE FROM courses WHERE course_code = 'TEMP100';

SELECT 'COURSES after DELETE — expect 3 rows:' AS test_label, COUNT(*) AS row_count FROM courses;


-- ############################################################
--  3. COURSE_ENROLLMENTS TABLE — CRUD
-- ############################################################

SELECT '========== COURSE_ENROLLMENTS: CREATE ==========' AS test_section;

INSERT INTO course_enrollments (course_id, user_id, role)
VALUES
    -- CS301 enrollments
    ((SELECT course_id FROM courses WHERE course_code = 'CS301'),
     (SELECT user_id FROM users WHERE username = 'prof_jones'), 'teacher'),
    ((SELECT course_id FROM courses WHERE course_code = 'CS301'),
     (SELECT user_id FROM users WHERE username = 'jdoe'), 'student'),
    ((SELECT course_id FROM courses WHERE course_code = 'CS301'),
     (SELECT user_id FROM users WHERE username = 'mgarcia'), 'student'),
    -- CS201 enrollments
    ((SELECT course_id FROM courses WHERE course_code = 'CS201'),
     (SELECT user_id FROM users WHERE username = 'prof_smith'), 'teacher'),
    ((SELECT course_id FROM courses WHERE course_code = 'CS201'),
     (SELECT user_id FROM users WHERE username = 'tnguyen'), 'student');

SELECT 'ENROLLMENTS CREATE — expect 5 rows:' AS test_label, COUNT(*) AS row_count FROM course_enrollments;

-- --------------------------------------------------------
SELECT '========== COURSE_ENROLLMENTS: READ ==========' AS test_section;

SELECT * FROM course_enrollments ORDER BY enrollment_id;

-- Read enrollments for a specific course with user names
SELECT 'CS301 roster:' AS test_label;
SELECT ce.enrollment_id, c.course_code, u.full_name, ce.role, ce.enrolled_at
FROM course_enrollments ce
JOIN courses c ON ce.course_id = c.course_id
JOIN users u ON ce.user_id = u.user_id
WHERE c.course_code = 'CS301'
ORDER BY ce.role, u.full_name;

-- Read all courses a specific student is enrolled in
SELECT 'Courses for jdoe:' AS test_label;
SELECT c.course_code, c.course_name, ce.enrolled_at
FROM course_enrollments ce
JOIN courses c ON ce.course_id = c.course_id
JOIN users u ON ce.user_id = u.user_id
WHERE u.username = 'jdoe';

-- --------------------------------------------------------
SELECT '========== COURSE_ENROLLMENTS: UPDATE ==========' AS test_section;

-- Promote a student to teacher role in a course (edge case)
UPDATE course_enrollments
SET role = 'teacher'
WHERE user_id = (SELECT user_id FROM users WHERE username = 'jdoe')
  AND course_id = (SELECT course_id FROM courses WHERE course_code = 'CS301');

SELECT 'ENROLLMENTS UPDATE — jdoe should be teacher in CS301:' AS test_label;
SELECT ce.enrollment_id, u.username, c.course_code, ce.role
FROM course_enrollments ce
JOIN users u ON ce.user_id = u.user_id
JOIN courses c ON ce.course_id = c.course_id
WHERE u.username = 'jdoe' AND c.course_code = 'CS301';

-- Revert back for downstream tests
UPDATE course_enrollments
SET role = 'student'
WHERE user_id = (SELECT user_id FROM users WHERE username = 'jdoe')
  AND course_id = (SELECT course_id FROM courses WHERE course_code = 'CS301');

-- --------------------------------------------------------
SELECT '========== COURSE_ENROLLMENTS: DELETE ==========' AS test_section;

-- Enroll tnguyen in CS301 temporarily then remove
INSERT INTO course_enrollments (course_id, user_id, role)
VALUES (
    (SELECT course_id FROM courses WHERE course_code = 'CS301'),
    (SELECT user_id FROM users WHERE username = 'tnguyen'),
    'student'
);

SELECT 'ENROLLMENTS before DELETE — expect 6 rows:' AS test_label, COUNT(*) AS row_count FROM course_enrollments;

DELETE FROM course_enrollments
WHERE user_id = (SELECT user_id FROM users WHERE username = 'tnguyen')
  AND course_id = (SELECT course_id FROM courses WHERE course_code = 'CS301');

SELECT 'ENROLLMENTS after DELETE — expect 5 rows:' AS test_label, COUNT(*) AS row_count FROM course_enrollments;


-- ############################################################
--  4. ASSIGNMENTS TABLE — CRUD
-- ############################################################

SELECT '========== ASSIGNMENTS: CREATE ==========' AS test_section;

INSERT INTO assignments (course_id, created_by, title, description, due_date, status, allowed_file_types, max_file_size_mb)
VALUES
    ((SELECT course_id FROM courses WHERE course_code = 'CS301'),
     (SELECT user_id FROM users WHERE username = 'prof_jones'),
     'ER Diagram Project', 'Design an ER diagram for a library system.',
     '2025-03-15 23:59:59', 'published', '.pdf,.png,.jpg', 10.00),

    ((SELECT course_id FROM courses WHERE course_code = 'CS301'),
     (SELECT user_id FROM users WHERE username = 'prof_jones'),
     'SQL Queries Homework', 'Write SELECT, JOIN, and subquery exercises.',
     '2025-03-22 23:59:59', 'published', '.sql,.txt', 5.00),

    ((SELECT course_id FROM courses WHERE course_code = 'CS301'),
     (SELECT user_id FROM users WHERE username = 'prof_jones'),
     'Normalization Quiz', 'Quiz on 1NF through BCNF.',
     '2025-04-01 23:59:59', 'draft', NULL, NULL),

    ((SELECT course_id FROM courses WHERE course_code = 'CS201'),
     (SELECT user_id FROM users WHERE username = 'prof_smith'),
     'Binary Tree Implementation', 'Implement a BST in Java or Python.',
     '2025-03-20 23:59:59', 'published', '.java,.py,.zip', 20.00);

SELECT 'ASSIGNMENTS CREATE — expect 4 rows:' AS test_label, COUNT(*) AS row_count FROM assignments;

-- --------------------------------------------------------
SELECT '========== ASSIGNMENTS: READ ==========' AS test_section;

SELECT * FROM assignments ORDER BY assignment_id;

-- Read published assignments for CS301
SELECT 'Published assignments for CS301:' AS test_label;
SELECT a.assignment_id, a.title, a.status, a.due_date
FROM assignments a
JOIN courses c ON a.course_id = c.course_id
WHERE c.course_code = 'CS301' AND a.status = 'published'
ORDER BY a.due_date;

-- Read assignments with course and teacher info
SELECT 'Assignments with full context:' AS test_label;
SELECT a.title, c.course_code, u.full_name AS teacher, a.status, a.due_date
FROM assignments a
JOIN courses c ON a.course_id = c.course_id
JOIN users u ON a.created_by = u.user_id
ORDER BY a.due_date;

-- --------------------------------------------------------
SELECT '========== ASSIGNMENTS: UPDATE ==========' AS test_section;

-- Publish the draft assignment
UPDATE assignments
SET status = 'published'
WHERE title = 'Normalization Quiz';

SELECT 'ASSIGNMENTS UPDATE — Normalization Quiz should be published:' AS test_label;
SELECT assignment_id, title, status
FROM assignments
WHERE title = 'Normalization Quiz';

-- Extend a due date
UPDATE assignments
SET due_date = '2025-04-05 23:59:59'
WHERE title = 'ER Diagram Project';

SELECT 'ASSIGNMENTS UPDATE — ER Diagram due date extended:' AS test_label;
SELECT assignment_id, title, due_date
FROM assignments
WHERE title = 'ER Diagram Project';

-- Update description and file constraints
UPDATE assignments
SET description = 'Write advanced SELECT, JOIN, subquery, and CTE exercises.',
    max_file_size_mb = 8.00
WHERE title = 'SQL Queries Homework';

SELECT 'ASSIGNMENTS UPDATE — SQL Queries description + size updated:' AS test_label;
SELECT assignment_id, title, description, max_file_size_mb
FROM assignments
WHERE title = 'SQL Queries Homework';

-- --------------------------------------------------------
SELECT '========== ASSIGNMENTS: DELETE ==========' AS test_section;

-- Insert a throwaway assignment
INSERT INTO assignments (course_id, created_by, title, status)
VALUES (
    (SELECT course_id FROM courses WHERE course_code = 'CS201'),
    (SELECT user_id FROM users WHERE username = 'prof_smith'),
    'Temp Assignment', 'draft'
);

SELECT 'ASSIGNMENTS before DELETE — expect 5 rows:' AS test_label, COUNT(*) AS row_count FROM assignments;

DELETE FROM assignments WHERE title = 'Temp Assignment';

SELECT 'ASSIGNMENTS after DELETE — expect 4 rows:' AS test_label, COUNT(*) AS row_count FROM assignments;


-- ############################################################
--  5. SUBMISSIONS TABLE — CRUD
-- ############################################################

SELECT '========== SUBMISSIONS: CREATE ==========' AS test_section;

INSERT INTO submissions (assignment_id, student_id, status, submitted_at)
VALUES
    -- jdoe submits ER Diagram
    ((SELECT assignment_id FROM assignments WHERE title = 'ER Diagram Project'),
     (SELECT user_id FROM users WHERE username = 'jdoe'),
     'submitted', NOW()),

    -- mgarcia submits ER Diagram
    ((SELECT assignment_id FROM assignments WHERE title = 'ER Diagram Project'),
     (SELECT user_id FROM users WHERE username = 'mgarcia'),
     'submitted', NOW()),

    -- jdoe has a draft for SQL Queries
    ((SELECT assignment_id FROM assignments WHERE title = 'SQL Queries Homework'),
     (SELECT user_id FROM users WHERE username = 'jdoe'),
     'draft', NULL),

    -- tnguyen submits Binary Tree
    ((SELECT assignment_id FROM assignments WHERE title = 'Binary Tree Implementation'),
     (SELECT user_id FROM users WHERE username = 'tnguyen'),
     'submitted', NOW());

SELECT 'SUBMISSIONS CREATE — expect 4 rows:' AS test_label, COUNT(*) AS row_count FROM submissions;

-- --------------------------------------------------------
SELECT '========== SUBMISSIONS: READ ==========' AS test_section;

SELECT * FROM submissions ORDER BY submission_id;

-- Read submissions for a specific assignment with student info
SELECT 'ER Diagram submissions:' AS test_label;
SELECT s.submission_id, u.full_name AS student, s.status, s.submitted_at
FROM submissions s
JOIN users u ON s.student_id = u.user_id
JOIN assignments a ON s.assignment_id = a.assignment_id
WHERE a.title = 'ER Diagram Project'
ORDER BY s.submitted_at;

-- Read all submissions by a specific student
SELECT 'All submissions by jdoe:' AS test_label;
SELECT s.submission_id, a.title, s.status, s.submitted_at
FROM submissions s
JOIN assignments a ON s.assignment_id = a.assignment_id
JOIN users u ON s.student_id = u.user_id
WHERE u.username = 'jdoe';

-- Read draft submissions (not yet submitted)
SELECT 'Draft submissions:' AS test_label;
SELECT s.submission_id, u.full_name, a.title, s.status
FROM submissions s
JOIN users u ON s.student_id = u.user_id
JOIN assignments a ON s.assignment_id = a.assignment_id
WHERE s.status = 'draft';

-- --------------------------------------------------------
SELECT '========== SUBMISSIONS: UPDATE ==========' AS test_section;

-- Submit the draft
UPDATE submissions
SET status = 'submitted', submitted_at = NOW()
WHERE student_id = (SELECT user_id FROM users WHERE username = 'jdoe')
  AND assignment_id = (SELECT assignment_id FROM assignments WHERE title = 'SQL Queries Homework');

SELECT 'SUBMISSIONS UPDATE — jdoe SQL Queries should be submitted:' AS test_label;
SELECT s.submission_id, u.username, a.title, s.status, s.submitted_at
FROM submissions s
JOIN users u ON s.student_id = u.user_id
JOIN assignments a ON s.assignment_id = a.assignment_id
WHERE u.username = 'jdoe' AND a.title = 'SQL Queries Homework';

-- --------------------------------------------------------
SELECT '========== SUBMISSIONS: DELETE ==========' AS test_section;

-- Insert a throwaway submission then delete
INSERT INTO submissions (assignment_id, student_id, status)
VALUES (
    (SELECT assignment_id FROM assignments WHERE title = 'SQL Queries Homework'),
    (SELECT user_id FROM users WHERE username = 'mgarcia'),
    'draft'
);

SELECT 'SUBMISSIONS before DELETE — expect 5 rows:' AS test_label, COUNT(*) AS row_count FROM submissions;

DELETE FROM submissions
WHERE student_id = (SELECT user_id FROM users WHERE username = 'mgarcia')
  AND assignment_id = (SELECT assignment_id FROM assignments WHERE title = 'SQL Queries Homework');

SELECT 'SUBMISSIONS after DELETE — expect 4 rows:' AS test_label, COUNT(*) AS row_count FROM submissions;


-- ############################################################
--  6. SUBMISSION_FILES TABLE — CRUD
-- ############################################################

SELECT '========== SUBMISSION_FILES: CREATE ==========' AS test_section;

INSERT INTO submission_files (submission_id, file_name, stored_path, file_type, file_size_bytes)
VALUES
    -- File for jdoe's ER Diagram submission
    ((SELECT s.submission_id FROM submissions s
      JOIN users u ON s.student_id = u.user_id
      JOIN assignments a ON s.assignment_id = a.assignment_id
      WHERE u.username = 'jdoe' AND a.title = 'ER Diagram Project'),
     'er_diagram_jdoe.pdf', '/uploads/2025/03/er_diagram_jdoe.pdf', '.pdf', 2048576),

    -- File for mgarcia's ER Diagram submission
    ((SELECT s.submission_id FROM submissions s
      JOIN users u ON s.student_id = u.user_id
      JOIN assignments a ON s.assignment_id = a.assignment_id
      WHERE u.username = 'mgarcia' AND a.title = 'ER Diagram Project'),
     'er_diagram_garcia.png', '/uploads/2025/03/er_diagram_garcia.png', '.png', 1536000),

    -- File for jdoe's SQL Queries submission
    ((SELECT s.submission_id FROM submissions s
      JOIN users u ON s.student_id = u.user_id
      JOIN assignments a ON s.assignment_id = a.assignment_id
      WHERE u.username = 'jdoe' AND a.title = 'SQL Queries Homework'),
     'queries_jdoe.sql', '/uploads/2025/03/queries_jdoe.sql', '.sql', 4096),

    -- File for tnguyen's Binary Tree submission
    ((SELECT s.submission_id FROM submissions s
      JOIN users u ON s.student_id = u.user_id
      JOIN assignments a ON s.assignment_id = a.assignment_id
      WHERE u.username = 'tnguyen' AND a.title = 'Binary Tree Implementation'),
     'bst_tnguyen.zip', '/uploads/2025/03/bst_tnguyen.zip', '.zip', 10240000);

SELECT 'FILES CREATE — expect 4 rows:' AS test_label, COUNT(*) AS row_count FROM submission_files;

-- --------------------------------------------------------
SELECT '========== SUBMISSION_FILES: READ ==========' AS test_section;

SELECT * FROM submission_files ORDER BY file_id;

-- Read files with submission and student context
SELECT 'Files with full context:' AS test_label;
SELECT sf.file_id, u.full_name AS student, a.title AS assignment,
       sf.file_name, sf.file_type, sf.file_size_bytes, sf.uploaded_at
FROM submission_files sf
JOIN submissions s ON sf.submission_id = s.submission_id
JOIN users u ON s.student_id = u.user_id
JOIN assignments a ON s.assignment_id = a.assignment_id
ORDER BY sf.uploaded_at;

-- Read files for a specific submission
SELECT 'Files for jdoe ER Diagram submission:' AS test_label;
SELECT sf.file_name, sf.file_type, sf.file_size_bytes
FROM submission_files sf
JOIN submissions s ON sf.submission_id = s.submission_id
JOIN users u ON s.student_id = u.user_id
JOIN assignments a ON s.assignment_id = a.assignment_id
WHERE u.username = 'jdoe' AND a.title = 'ER Diagram Project';

-- --------------------------------------------------------
SELECT '========== SUBMISSION_FILES: UPDATE ==========' AS test_section;

-- Simulate a file re-upload (update file name, path, size)
UPDATE submission_files
SET file_name = 'er_diagram_jdoe_v2.pdf',
    stored_path = '/uploads/2025/03/er_diagram_jdoe_v2.pdf',
    file_size_bytes = 3145728
WHERE submission_id = (
    SELECT s.submission_id FROM submissions s
    JOIN users u ON s.student_id = u.user_id
    JOIN assignments a ON s.assignment_id = a.assignment_id
    WHERE u.username = 'jdoe' AND a.title = 'ER Diagram Project'
);

SELECT 'FILES UPDATE — jdoe ER file should be v2, ~3MB:' AS test_label;
SELECT file_id, file_name, stored_path, file_size_bytes
FROM submission_files
WHERE submission_id = (
    SELECT s.submission_id FROM submissions s
    JOIN users u ON s.student_id = u.user_id
    JOIN assignments a ON s.assignment_id = a.assignment_id
    WHERE u.username = 'jdoe' AND a.title = 'ER Diagram Project'
);

-- --------------------------------------------------------
SELECT '========== SUBMISSION_FILES: DELETE ==========' AS test_section;

-- We'll delete tnguyen's file and re-insert after for downstream tests
-- First record current count
SELECT 'FILES before DELETE — expect 4 rows:' AS test_label, COUNT(*) AS row_count FROM submission_files;

-- Store the submission_id for later re-insert
SET @tnguyen_sub_id = (
    SELECT s.submission_id FROM submissions s
    JOIN users u ON s.student_id = u.user_id
    JOIN assignments a ON s.assignment_id = a.assignment_id
    WHERE u.username = 'tnguyen' AND a.title = 'Binary Tree Implementation'
);

DELETE FROM submission_files WHERE submission_id = @tnguyen_sub_id;

SELECT 'FILES after DELETE — expect 3 rows:' AS test_label, COUNT(*) AS row_count FROM submission_files;

-- Re-insert for grades tests below
INSERT INTO submission_files (submission_id, file_name, stored_path, file_type, file_size_bytes)
VALUES (@tnguyen_sub_id, 'bst_tnguyen.zip', '/uploads/2025/03/bst_tnguyen.zip', '.zip', 10240000);

SELECT 'FILES after re-insert — expect 4 rows:' AS test_label, COUNT(*) AS row_count FROM submission_files;


-- ############################################################
--  7. GRADES TABLE — CRUD
-- ############################################################

SELECT '========== GRADES: CREATE ==========' AS test_section;

INSERT INTO grades (submission_id, graded_by, score, comments)
VALUES
    -- Grade jdoe's ER Diagram
    ((SELECT s.submission_id FROM submissions s
      JOIN users u ON s.student_id = u.user_id
      JOIN assignments a ON s.assignment_id = a.assignment_id
      WHERE u.username = 'jdoe' AND a.title = 'ER Diagram Project'),
     (SELECT user_id FROM users WHERE username = 'prof_jones'),
     92.50, 'Excellent work on the ER diagram. Minor issue with cardinality notation.'),

    -- Grade mgarcia's ER Diagram
    ((SELECT s.submission_id FROM submissions s
      JOIN users u ON s.student_id = u.user_id
      JOIN assignments a ON s.assignment_id = a.assignment_id
      WHERE u.username = 'mgarcia' AND a.title = 'ER Diagram Project'),
     (SELECT user_id FROM users WHERE username = 'prof_jones'),
     88.00, 'Good effort. Missing a few relationships.'),

    -- Grade tnguyen's Binary Tree
    ((SELECT s.submission_id FROM submissions s
      JOIN users u ON s.student_id = u.user_id
      JOIN assignments a ON s.assignment_id = a.assignment_id
      WHERE u.username = 'tnguyen' AND a.title = 'Binary Tree Implementation'),
     (SELECT user_id FROM users WHERE username = 'prof_smith'),
     95.00, 'Clean implementation with excellent test coverage.');

SELECT 'GRADES CREATE — expect 3 rows:' AS test_label, COUNT(*) AS row_count FROM grades;

-- --------------------------------------------------------
SELECT '========== GRADES: READ ==========' AS test_section;

SELECT * FROM grades ORDER BY grade_id;

-- Read grades with full context
SELECT 'Grades with full context:' AS test_label;
SELECT g.grade_id, u_student.full_name AS student, a.title AS assignment,
       c.course_code, g.score, g.comments,
       u_teacher.full_name AS graded_by, g.graded_at
FROM grades g
JOIN submissions s ON g.submission_id = s.submission_id
JOIN users u_student ON s.student_id = u_student.user_id
JOIN assignments a ON s.assignment_id = a.assignment_id
JOIN courses c ON a.course_id = c.course_id
JOIN users u_teacher ON g.graded_by = u_teacher.user_id
ORDER BY c.course_code, a.title, u_student.full_name;

-- Read grades for a specific student
SELECT 'Grades for jdoe:' AS test_label;
SELECT a.title, g.score, g.comments
FROM grades g
JOIN submissions s ON g.submission_id = s.submission_id
JOIN assignments a ON s.assignment_id = a.assignment_id
WHERE s.student_id = (SELECT user_id FROM users WHERE username = 'jdoe');

-- Read average score per assignment
SELECT 'Average scores per assignment:' AS test_label;
SELECT a.title, AVG(g.score) AS avg_score, COUNT(g.grade_id) AS num_graded
FROM grades g
JOIN submissions s ON g.submission_id = s.submission_id
JOIN assignments a ON s.assignment_id = a.assignment_id
GROUP BY a.assignment_id, a.title;

-- --------------------------------------------------------
SELECT '========== GRADES: UPDATE ==========' AS test_section;

-- Adjust grade after re-evaluation
UPDATE grades
SET score = 94.00,
    comments = 'Excellent work on the ER diagram. Minor issue with cardinality notation. Score adjusted after re-review.'
WHERE submission_id = (
    SELECT s.submission_id FROM submissions s
    JOIN users u ON s.student_id = u.user_id
    JOIN assignments a ON s.assignment_id = a.assignment_id
    WHERE u.username = 'jdoe' AND a.title = 'ER Diagram Project'
);

SELECT 'GRADES UPDATE — jdoe ER Diagram score should be 94.00:' AS test_label;
SELECT g.grade_id, g.score, g.comments, g.updated_at
FROM grades g
JOIN submissions s ON g.submission_id = s.submission_id
JOIN users u ON s.student_id = u.user_id
JOIN assignments a ON s.assignment_id = a.assignment_id
WHERE u.username = 'jdoe' AND a.title = 'ER Diagram Project';

-- --------------------------------------------------------
SELECT '========== GRADES: DELETE ==========' AS test_section;

SELECT 'GRADES before DELETE — expect 3 rows:' AS test_label, COUNT(*) AS row_count FROM grades;

-- Delete mgarcia's grade (teacher wants to re-grade)
DELETE FROM grades
WHERE submission_id = (
    SELECT s.submission_id FROM submissions s
    JOIN users u ON s.student_id = u.user_id
    JOIN assignments a ON s.assignment_id = a.assignment_id
    WHERE u.username = 'mgarcia' AND a.title = 'ER Diagram Project'
);

SELECT 'GRADES after DELETE — expect 2 rows:' AS test_label, COUNT(*) AS row_count FROM grades;

-- Verify the grade is gone
SELECT 'GRADES DELETE verification — expect 0 rows for mgarcia ER Diagram:' AS test_label;
SELECT COUNT(*) AS row_count
FROM grades g
JOIN submissions s ON g.submission_id = s.submission_id
JOIN users u ON s.student_id = u.user_id
JOIN assignments a ON s.assignment_id = a.assignment_id
WHERE u.username = 'mgarcia' AND a.title = 'ER Diagram Project';


-- ############################################################
--  8. CASCADE DELETE TESTS
-- ############################################################

SELECT '========== CASCADE DELETE TESTS ==========' AS test_section;

-- Test ON DELETE CASCADE: deleting an assignment should cascade to
-- submissions, submission_files, and grades

-- First, verify counts before cascade
SELECT 'Before cascade — assignments:' AS test_label, COUNT(*) AS cnt FROM assignments;
SELECT 'Before cascade — submissions:' AS test_label, COUNT(*) AS cnt FROM submissions;
SELECT 'Before cascade — files:'       AS test_label, COUNT(*) AS cnt FROM submission_files;
SELECT 'Before cascade — grades:'      AS test_label, COUNT(*) AS cnt FROM grades;

-- Delete the 'ER Diagram Project' assignment — should cascade
DELETE FROM assignments WHERE title = 'ER Diagram Project';

SELECT 'After cascade delete of ER Diagram Project:' AS test_label;
SELECT 'Assignments — expect 3:' AS test_label, COUNT(*) AS cnt FROM assignments;
SELECT 'Submissions — expect 2 (jdoe SQL + tnguyen BST):' AS test_label, COUNT(*) AS cnt FROM submissions;
SELECT 'Files — expect 2:' AS test_label, COUNT(*) AS cnt FROM submission_files;
SELECT 'Grades — expect 1 (tnguyen BST only):' AS test_label, COUNT(*) AS cnt FROM grades;


-- ############################################################
--  9. FINAL STATE SUMMARY
-- ############################################################

SELECT '========== FINAL STATE SUMMARY ==========' AS test_section;

SELECT 'users'               AS table_name, COUNT(*) AS total_rows FROM users
UNION ALL
SELECT 'courses',                            COUNT(*) FROM courses
UNION ALL
SELECT 'course_enrollments',                 COUNT(*) FROM course_enrollments
UNION ALL
SELECT 'assignments',                        COUNT(*) FROM assignments
UNION ALL
SELECT 'submissions',                        COUNT(*) FROM submissions
UNION ALL
SELECT 'submission_files',                   COUNT(*) FROM submission_files
UNION ALL
SELECT 'grades',                             COUNT(*) FROM grades;


SELECT '========== ALL CRUD TESTS COMPLETE ==========' AS test_result;

-- Re-enable safe updates
SET SQL_SAFE_UPDATES = 1;
