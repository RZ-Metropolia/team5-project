# Project Plan: Homework Submission and Tracking System

## 1. Project Overview

This project is named the **Homework Submission and Tracking System**. It aims to digitize the assignment process to improve organization and communication.

Current methods of managing homework via email and paper are inefficient. Submissions get lost, feedback is delayed, and students struggle to track deadlines.

The intended users of the project are students and teachers. Students need to check due dates, upload homework, and view grades, while teachers need to create assignments, grade submissions, and provide feedback.

The main features of the project include:
- User authentication (Login/Register for Students and Teachers)
- Assignment creation and management (Teacher)
- File submission (Student)
- Grading and textual feedback system
- Dashboard for viewing pending tasks and grades

## 2. Project Objectives

2.1 Develop a functional application using JavaFX and MariaDB by the end of Sprint 4.

2.2 Implement secure login and role-based access control for teachers and students.

2.3 Create a system that can handle file uploads and database storage.

2.4 Ensure the application runs without critical bugs during the final demo.

## 3. Scope and Deliverables

### In-Scope
- Application development
- Database design and implementation
- User interface
- Core features: login, assignment creation, grading, and viewing grades

### Out-of-Scope
- Mobile application
- Live chat functionality

## 4. Project Timeline

The project follows an Agile methodology with 2-week Sprints, managed via Trello.

**Sprint 1 (Weeks 1-2)**: Project setup, requirements gathering, and database design
- Milestones: Project plan submission and environment setup

**Sprint 2 (Weeks 3-4)**: Core functionality implementation
- Milestones: User login, menu navigation, basic UI layout

**Sprint 3 (Weeks 5-6)**: Main features implementation
- Milestones: Student upload function, teacher grading function

**Sprint 4 (Weeks 7-8)**: Testing, bug fixing, and documentation
- Milestones: Final application demo, final report submission

## 5. Resource Allocation

### 5.1 Team Members and Roles

| Team Member | Role | Responsibilities |
|------------|------|------------------|
| Chun He | Developer and Tester | Coding UI, Testing features |
| Juyin Tang | Developer and Tester | Database connectivity, Testing features |
| Zongru Li | Backend Developer | Core functionality logic |
| Rui Zhao | Backend Developer | Main features |

### 5.2 Software, Hardware, and Tools

- **Development Language**: Java
- **Framework**: JavaFX (for UI)
- **Database**: MariaDB
- **IDE**: IntelliJ IDEA or VS Code
- **Project Management**: Trello
- **Version Control**: Git & GitHub

## 6. Risk Management

| Risk | Likelihood | Impact | Mitigation Strategies |
|------|-----------|--------|----------------------|
| Technical Difficulty | Medium | High | Use online tutorials, ask supervisors |
| Database Connection Problems | Medium | High | Test database connection, use local backups |
| Team Member Absence | Low | Medium | Use tools like GitHub, WhatsApp to communicate |
| Adding too many features | Medium | Medium | Stick strictly to the "In-Scope" list |

## 7. Testing and Quality Assurance

### 7.1 Testing Strategy

**Unit Testing**: We will test individual methods using JUnit. Every method should pass the test.

**Integration Testing**: Verifying that the Java app correctly saves or reads data from MariaDB. The database should work perfectly for the program.

**User Acceptance Testing (UAT)**: We will manually use the app as a "Teacher" and "Student" to ensure the flow works. It should work perfectly for both the teacher and the student.

### 7.2 Quality Assurance Criteria

- A user can successfully log in
- A file can be uploaded and retrieved
- Data persists in the database after restarting the app

## 8. Documentation and Reporting

### 8.1 Documentation

- Project Plan (This document)
- Product Vision report: The description of product vision
- Final Report: Summary of the project outcome

### 8.2 Reporting

- Daily reporting of project progress on the Trello board
- Sprint Review meetings and reports every two weeks
