# Acceptance Test Plan
## Homework Submission and Tracking System — Group 5

---

## 1. Purpose

This document outlines the acceptance criteria and test cases used to confirm that the system meets stakeholder requirements before final release.

---

## 2. Acceptance Criteria

### Functional
- All Must-have user stories pass their corresponding test cases.
- No Severity 1 or Severity 2 defects remain open at sign-off.
- Role-based access control (TEACHER / STUDENT) is correctly enforced on all endpoints.
- Data persists correctly in the database after each operation.

### Usability
- A first-time user can complete each critical workflow without external help.
- All UI labels, buttons, and messages display correctly in all five supported languages.
- Error messages are clear, user-readable, and consistent across the application.

### Performance & Reliability
- Key API responses return within 2 seconds under normal load.
- The system handles invalid inputs and API errors gracefully without crashing.
- File upload and download operations complete successfully for typical file sizes.

---

## 3. Supported Languages

| Code | Language           |
|------|--------------------|
| en   | English            |
| zh   | Chinese (Simplified) |
| ja   | Japanese           |
| fa   | Persian            |
| ar   | Arabic             |

---

## 4. Coverage Matrix

| User Story | Description | Priority | Test Case(s) | Test Type |
|---|---|:---:|---|---|
| US-T01 | Teacher login | Must | TC-F-01 | Functional |
| US-T02 | Create assignment (title, description, due date) | Must | TC-F-02 | Functional |
| US-T03 | Save assignment as draft | Must | TC-F-03 | Functional |
| US-T04 | Publish assignment to students | Must | TC-F-04 | Functional |
| US-T05 | Edit assignment details | Must | TC-F-05 | Functional |
| US-T06 | Delete assignment | Must | TC-F-06 | Functional |
| US-T07 | View student submissions for an assignment | Must | TC-F-07 | Functional |
| US-T08 | Download a student's submitted file | Must | TC-F-08 | Functional |
| US-T09 | Grade a submission (score + comments) | Must | TC-F-09 | Functional |
| US-T10 | Update an existing grade | Must | TC-F-10 | Functional |
| US-T11 | View list of ungraded submissions | Must | TC-F-11 | Functional |
| US-T12 | Archive / unarchive a course | Should | TC-F-12 | Functional |
| US-T13 | Require specific file types on assignment | Should | TC-F-13 | Functional |
| US-S01 | Student login | Must | TC-F-14 | Functional |
| US-S02 | View all open (published) assignments | Must | TC-F-15 | Functional |
| US-S03 | Submit a file for an assignment | Must | TC-F-16 | Functional |
| US-S04 | Save submission as draft | Must | TC-F-17 | Functional |
| US-S05 | View grade and teacher comments | Must | TC-F-18 | Functional |
| US-S06 | See visual alert for assignments due within 24 hours | Must | TC-F-19 | Functional |
| US-S07 | File too large upload rejected with clear message | Should | TC-F-20 | Functional |
| US-G01 | Register a new user account | Must | TC-F-21 | Functional |
| US-G02 | Switch UI language (all 5 locales) | Must | TC-U-01 | Usability |
| US-G03 | Complete key workflow as new user without help | Must | TC-U-02 | Usability |
| NFR-01 | API response time under normal load | Must | TC-P-01 | Performance |
| NFR-02 | Graceful error handling on invalid input | Must | TC-P-02 | Reliability |

---

## 5. Test Cases

### 5.1 Functional Tests

**TC-F-01 — Teacher Login**
- Steps: POST `/api/users/login` with valid teacher credentials.
- Expected: HTTP 200, JWT token returned, role = `TEACHER`.

**TC-F-02 — Create Assignment**
- Steps: Authenticated teacher POSTs `/api/assignments` with title, description, due date, and course ID.
- Expected: HTTP 201, assignment created with status `DRAFT`.

**TC-F-03 — Save Assignment as Draft**
- Steps: Teacher creates assignment without publishing.
- Expected: Assignment status is `DRAFT`; not visible to students via `/api/assignments/student`.

**TC-F-04 — Publish Assignment**
- Steps: Teacher PUTs `/api/assignments/{id}/publish`.
- Expected: HTTP 200, status changes to `PUBLISHED`; assignment appears in student's list.

**TC-F-05 — Edit Assignment**
- Steps: Teacher PUTs `/api/assignments/{id}` with updated due date or description.
- Expected: HTTP 200, updated fields reflected in the response.

**TC-F-06 — Delete Assignment**
- Steps: Teacher DELETEs `/api/assignments/{id}`.
- Expected: HTTP 204, assignment no longer retrievable.

**TC-F-07 — View Submissions for Assignment**
- Steps: Teacher GETs `/api/submissions?assignmentId={id}`.
- Expected: HTTP 200, list of all student submissions returned.

**TC-F-08 — Download Student File**
- Steps: Teacher GETs `/api/submissions/{id}/file`.
- Expected: HTTP 200, file returned as attachment with correct filename.

**TC-F-09 — Grade a Submission**
- Steps: Teacher POSTs `/api/grades?submissionId={id}` with score and comments.
- Expected: HTTP 201, grade record created and linked to submission.

**TC-F-10 — Update a Grade**
- Steps: Teacher PUTs `/api/grades/{gradeId}` with new score/comments.
- Expected: HTTP 200, grade record updated.

**TC-F-11 — View Ungraded Submissions**
- Steps: Teacher GETs `/api/grades/ungraded`.
- Expected: HTTP 200, list of submitted but ungraded submissions returned.

**TC-F-12 — Archive a Course**
- Steps: Teacher PUTs `/api/courses/{courseId}/archive`.
- Expected: HTTP 200, `isArchived = true`; course no longer appears in active list.

**TC-F-13 — File Type Restriction Enforced**
- Steps: Student uploads a file with a type not in `allowedFileTypes`.
- Expected: Upload rejected with a descriptive error message.

**TC-F-14 — Student Login**
- Steps: POST `/api/users/login` with valid student credentials.
- Expected: HTTP 200, JWT token returned, role = `STUDENT`.

**TC-F-15 — Student Views Published Assignments**
- Steps: Student GETs `/api/assignments/student`.
- Expected: HTTP 200, only `PUBLISHED` assignments for enrolled courses returned.

**TC-F-16 — Student Submits File**
- Steps: Student POSTs `/api/submissions/{id}/file` and PUTs `/{id}/submit`.
- Expected: HTTP 200, submission status changes to `SUBMITTED`, `submittedAt` is set.

**TC-F-17 — Student Saves Submission as Draft**
- Steps: Student creates submission without calling `/submit`.
- Expected: Submission status remains `DRAFT`; not visible to teacher grading view.

**TC-F-18 — Student Views Grade**
- Steps: Student GETs `/api/grades/student`.
- Expected: HTTP 200, score and comments visible for graded submissions.

**TC-F-19 — Urgent Assignment Alert**
- Steps: Student GETs `/api/assignments/student/urgent`.
- Expected: HTTP 200, only assignments with due date within 24 hours returned.

**TC-F-20 — Oversized File Rejected**
- Steps: Student uploads a file exceeding the assignment's `maxFileSizeMB`.
- Expected: Request rejected with a clear error message; no file stored.

**TC-F-21 — New User Registration**
- Steps: POST `/api/users/register` with valid username, email, password, role.
- Expected: HTTP 201, user record created; duplicate username returns HTTP 400.

---

### 5.2 Usability Tests

**TC-U-01 — Language Switching (All 5 Locales)**
- Method: Tester switches language from the Settings panel or login screen to each of: English, Chinese, Japanese, Persian, Arabic.
- Expected: All UI strings, table headers, buttons, and status labels update immediately without a page reload; no untranslated keys (raw key strings) are visible.

**TC-U-02 — First-Time User Workflow Completion**
- Method: 3–5 representative users attempt to complete a target task (e.g., submit an assignment or grade a submission) without guidance.
- Expected: ≥80% complete the task successfully; no critical usability blockers observed.

---

### 5.3 Performance & Reliability Tests

**TC-P-01 — API Response Time**
- Method: Execute 50 repeated calls to key endpoints (login, get assignments, submit grade).
- Expected: P95 response time ≤ 2.0 seconds; error rate < 1%.

**TC-P-02 — Invalid Input Handling**
- Method: Send malformed requests (missing required fields, wrong data types, invalid IDs) to each major endpoint.
- Expected: All endpoints return appropriate HTTP error codes (400, 401, 404) with readable messages; no 500 errors or server crashes.

---

## 6. Entry / Exit Criteria

| | Criteria |
|---|---|
| **Entry** | Code complete; staging environment running; test data prepared; unit tests passing. |
| **Exit** | All Must-have test cases executed and passed; no open Sev 1/2 defects; stakeholder sign-off obtained. |

---

## 7. Defect Severity

| Severity | Definition | Release Decision |
|:---:|---|---|
| 1 – Critical | System unusable, data loss, or security breach | Must fix before release |
| 2 – High | Major feature broken, no workaround | Must fix before release |
| 3 – Medium | Feature partially broken, workaround exists | Fix or defer with approval |
| 4 – Low | Cosmetic or minor inconvenience | Add to backlog |