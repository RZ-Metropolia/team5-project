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

---

## 3. Supported Languages

| Code    | Language              |
|---------|-----------------------|
| en-US   | English               |
| zh-CN   | Chinese (Simplified)  |
| ja-JP   | Japanese              |
| fa-IR   | Persian               |
| ar-AE   | Arabic                |

---

## 4. Coverage Matrix

| Test Case | User Story | Description | Priority | Test Type |
|---|---|---|:---:|---|
| TC-F-01 | US-G01 | Register a new user account | Must | Functional |
| TC-F-02 | US-T01 | Teacher login | Must | Functional |
| TC-F-03 | US-S01 | Student login | Must | Functional |
| TC-F-04 | US-T02 / US-T04 | Create assignment and publish it | Must | Functional |
| TC-F-05 | US-T05 / US-T06 | Edit and delete an assignment | Must | Functional |
| TC-F-06 | US-S02 | Student views published assignments | Must | Functional |
| TC-F-07 | US-S04 | Student saves a submission as draft | Must | Functional |
| TC-F-08 | US-S03 | Student finalizes and submits assignment | Must | Functional |
| TC-F-09 | US-T07 / US-T09 / US-T10 | Teacher views submissions and grades them | Must | Functional |
| TC-U-01 | US-G02 | Switch UI language across all 5 locales | Must | Usability |

---

## 5. Test Cases

---

**TC-F-01 — New User Registration**

- **Preconditions:** No existing account with the chosen username or email.
- **Steps:**
  1. Send `POST /api/users/register` with a JSON body containing `username`, `email`, `password`, and `role` (`TEACHER` or `STUDENT`).
  2. Repeat the same request to test duplicate handling.
- **Expected Results:**
  - First request: HTTP 201; user record is created and stored in the database.
  - Duplicate request: HTTP 400 with a readable error message indicating the conflict.

---

**TC-F-02 — Teacher Login**

- **Preconditions:** A TEACHER account exists in the database.
- **Steps:**
  1. Open the Electron app and navigate to the Login screen.
  2. Enter valid teacher credentials and click **Log In**.
  3. Verify the backend call: `POST /api/users/login` with `{ username, password }`.
- **Expected Results:**
  - HTTP 200; a JWT token is returned and stored in the application state.
  - The sidebar shows the user's name with a **Teacher** role badge.
  - The app navigates to the Dashboard showing a "Go to Workspaces" panel.

---

**TC-F-03 — Student Login**

- **Preconditions:** A STUDENT account exists in the database and is enrolled in at least one course.
- **Steps:**
  1. Open the Electron app and navigate to the Login screen.
  2. Enter valid student credentials and click **Log In**.
  3. Verify the backend call: `POST /api/users/login` with `{ username, password }`.
- **Expected Results:**
  - HTTP 200; a JWT token is returned.
  - The sidebar shows the user's name with a **Student** role badge.
  - The Dashboard displays the student's enrolled courses and any urgent deadlines.

---

**TC-F-04 — Create Assignment and Publish It**

- **Preconditions:** Logged in as a TEACHER; at least one course exists.
- **Steps:**
  1. Navigate to **Workspaces → [Course] → Assignments**.
  2. Click **Create Assignment**, fill in `title`, `description`, and `dueDate`, then confirm.
     - Verify: `POST /api/assignments` with `{ title, description, dueDate, courseId }`.
  3. Confirm the assignment appears in the list with status `DRAFT`.
  4. Click **Publish** on the newly created assignment.
     - Verify: `PUT /api/assignments/{id}/publish`.
- **Expected Results:**
  - After creation: HTTP 201; assignment stored with status `DRAFT`; not visible to students yet.
  - After publish: HTTP 200; assignment status changes to `PUBLISHED`; it appears in the student's assignment list.

---

**TC-F-05 — Edit and Delete an Assignment**

- **Preconditions:** Logged in as a TEACHER; a `DRAFT` or `PUBLISHED` assignment exists.
- **Steps:**
  1. Navigate to the assignment in the teacher's assignment list.
  2. Click **Edit**, update the `description` and `dueDate`, then save.
     - Verify: `PUT /api/assignments/{id}` with the updated fields.
  3. Confirm the updated values are reflected in the UI immediately.
  4. Click **Delete** on the same assignment and confirm the action.
     - Verify: `DELETE /api/assignments/{id}`.
- **Expected Results:**
  - Edit: HTTP 200; response body reflects the new `description` and `dueDate`.
  - Delete: HTTP 204; the assignment is removed from the list and can no longer be retrieved via `GET /api/assignments/{id}`.

---

**TC-F-06 — Student Views Published Assignments**

- **Preconditions:** Logged in as a STUDENT enrolled in a course that has at least one `PUBLISHED` and one `DRAFT` assignment.
- **Steps:**
  1. Navigate to **Workspaces → [Course] → Assignments**.
     - Verify: `GET /api/assignments?courseId={id}` is called.
  2. Inspect the assignment list displayed.
- **Expected Results:**
  - HTTP 200; only `PUBLISHED` assignments are visible to the student.
  - `DRAFT` assignments created by the teacher do not appear in the student's view.
  - Assignment cards display the correct title, description, and due date.

---

**TC-F-07 — Student Saves a Submission as Draft**

- **Preconditions:** Logged in as a STUDENT; a `PUBLISHED` assignment exists with no prior submission.
- **Steps:**
  1. Navigate to **Workspaces → [Course] → Assignments → [Assignment]**.
  2. Type content into the submission text area.
  3. Click **Save Draft**.
     - Verify: `POST /api/submissions?assignmentId={id}` is called on first save; subsequent saves call `PUT /api/submissions/{id}/description`.
- **Expected Results:**
  - HTTP 200/201; submission is stored with status `DRAFT`.
  - The student can leave and return to the assignment and see the saved draft content.
  - The submission does not appear in the teacher's grading view while in `DRAFT` status.

---

**TC-F-08 — Student Finalizes and Submits Assignment**

- **Preconditions:** Logged in as a STUDENT; a `DRAFT` submission exists for a `PUBLISHED` assignment.
- **Steps:**
  1. Navigate to the assignment detail page.
  2. Review the draft content and click **Submit Assignment**.
     - Verify: `PUT /api/submissions/{id}/submit`.
- **Expected Results:**
  - HTTP 200; submission status changes from `DRAFT` to `SUBMITTED`.
  - A `submittedAt` timestamp is set on the record.
  - The UI updates the status badge to **Submitted** and the submit button is no longer active.
  - The submission now appears in the teacher's submissions table for that assignment.

---

**TC-F-09 — Teacher Views Submissions and Grades Them**

- **Preconditions:** Logged in as a TEACHER; at least one student has a `SUBMITTED` submission for an assignment.
- **Steps:**
  1. Navigate to **Workspaces → [Course] → Assignments → [Assignment]**.
     - Verify: `GET /api/submissions?assignmentId={id}` is called.
  2. Confirm the submitted student appears in the submissions table.
  3. Click **View & Grade** to open the grading dialog.
  4. Enter a numeric `score` and `comments`, then click **Submit Grade**.
     - Verify: `POST /api/grades?submissionId={id}` with `{ score, comments }`.
  5. Reopen the same submission, change the score, and click **Update Grade**.
     - Verify: `PUT /api/grades/{gradeId}` with the updated values.
  6. As the student, navigate to the graded assignment detail page.
     - Verify: `GET /api/grades/submission/{submissionId}` is called.
- **Expected Results:**
  - Step 2: HTTP 200; table lists all `SUBMITTED` student submissions.
  - Step 4: HTTP 201; grade record created and linked to the submission.
  - Step 5: HTTP 200; grade record updated with the new score and comments.
  - Step 6: Student sees a "Grade & Feedback" card displaying the correct score and instructor comments.

---

**TC-U-01 — Language Switching Across All 5 Locales**

- **Preconditions:** App is running; user is on the Login screen or is logged in.
- **Steps:**
  1. On the Login screen, click the **Language Switcher** icon (bottom-right corner) and select each locale in turn: `en-US`, `zh-CN`, `ja-JP`, `fa-IR`, `ar-AE`.
  2. For each locale, verify that all visible UI strings (labels, buttons, placeholders) are translated.
  3. Log in and navigate to **Settings → Appearance → Language Switcher**; repeat the locale cycle from within the app.
  4. For Arabic (`ar-AE`) and Persian (`fa-IR`), verify the layout direction.
- **Expected Results:**
  - Language change takes effect immediately without a page reload.
  - No untranslated key strings (e.g., `auth.loginButton`) appear anywhere in the UI.
  - For RTL locales (`fa-IR`, `ar-AE`): `document.documentElement.dir` is set to `rtl`; the sidebar renders on the right side.
  - The selected language persists after navigating between pages (stored under `app_i18next_lng` in `localStorage`).

---

## 6. Entry / Exit Criteria

| | Criteria |
|---|---|
| **Entry** | Code complete; staging environment running; test data prepared; unit tests passing. |
| **Exit** | All 10 test cases executed and passed; no open Sev 1/2 defects; stakeholder sign-off obtained. |

---

## 7. Defect Severity

| Severity | Definition | Release Decision |
|:---:|---|---|
| 1 – Critical | System unusable, data loss, or security breach | Must fix before release |
| 2 – High | Major feature broken, no workaround | Must fix before release |
| 3 – Medium | Feature partially broken, workaround exists | Fix or defer with approval |
| 4 – Low | Cosmetic or minor inconvenience | Add to backlog |