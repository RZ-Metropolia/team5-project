DROP DATABASE IF EXISTS assignment_submission_system;
CREATE DATABASE homework_submission_system;

USE homework_submission_system;

CREATE TABLE users (
    user_id       INT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    role          ENUM('teacher', 'student') NOT NULL,
    username      VARCHAR(50)     NOT NULL UNIQUE,
    password_hash VARCHAR(255)    NOT NULL,
    full_name     VARCHAR(120)    NOT NULL,
    email         VARCHAR(255)    NOT NULL,
    created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_users_role (role)
);

CREATE TABLE courses (
    course_id   INT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150)    NOT NULL,
    course_code VARCHAR(30)     NOT NULL UNIQUE,
    is_archived BOOLEAN         NOT NULL DEFAULT FALSE,
    created_by  INT UNSIGNED    NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_courses_created_by FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE course_enrollments (
    enrollment_id INT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    course_id     INT UNSIGNED    NOT NULL,
    user_id       INT UNSIGNED    NOT NULL,
    role          ENUM('teacher', 'student') NOT NULL,
    enrolled_at   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES courses(course_id),
    CONSTRAINT fk_enroll_user   FOREIGN KEY (user_id)   REFERENCES users(user_id),
    UNIQUE KEY uq_enrollment (course_id, user_id)
);

CREATE TABLE assignments (
    assignment_id      INT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    course_id          INT UNSIGNED    NOT NULL,
    created_by         INT UNSIGNED    NOT NULL,
    title              VARCHAR(255)    NOT NULL,
    description        TEXT            NULL,
    due_date           DATETIME        NULL,
    status             ENUM('draft', 'published')  NOT NULL DEFAULT 'draft',
    allowed_file_types VARCHAR(255)    NULL,
    max_file_size_mb   DECIMAL(6,2)   NULL,
    created_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_assign_course  FOREIGN KEY (course_id)  REFERENCES courses(course_id),
    CONSTRAINT fk_assign_teacher FOREIGN KEY (created_by)  REFERENCES users(user_id),

    INDEX idx_assign_course_status (course_id, status),
    INDEX idx_assign_due_date (due_date)
);

CREATE TABLE submissions (
    submission_id  INT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    assignment_id  INT UNSIGNED    NOT NULL,
    student_id     INT UNSIGNED    NOT NULL,
    status         ENUM('draft', 'submitted') NOT NULL DEFAULT 'draft',
    submitted_at   DATETIME        NULL,
    created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_sub_assignment FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_sub_student    FOREIGN KEY (student_id)    REFERENCES users(user_id),
    UNIQUE KEY uq_student_assignment (assignment_id, student_id),

    INDEX idx_sub_status (status),
    INDEX idx_sub_submitted_at (submitted_at)
);

CREATE TABLE submission_files (
    file_id        INT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    submission_id  INT UNSIGNED    NOT NULL,
    file_name  VARCHAR(255)    NOT NULL,
    stored_path    VARCHAR(500)    NOT NULL,
    file_type      VARCHAR(20)     NOT NULL,
    file_size_bytes BIGINT UNSIGNED NOT NULL,
    uploaded_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_file_submission FOREIGN KEY (submission_id) REFERENCES submissions(submission_id)
        ON DELETE CASCADE,
    UNIQUE KEY uq_submission_version (submission_id),

    INDEX idx_file_uploaded_at (uploaded_at)
);

CREATE TABLE grades (
    grade_id       INT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    submission_id  INT UNSIGNED    NOT NULL UNIQUE,
    graded_by      INT UNSIGNED    NOT NULL,
    score          DECIMAL(6,2)   NOT NULL,
    comments       TEXT            NULL,
    graded_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_grade_submission FOREIGN KEY (submission_id) REFERENCES submissions(submission_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_grade_teacher    FOREIGN KEY (graded_by)     REFERENCES users(user_id)
);
