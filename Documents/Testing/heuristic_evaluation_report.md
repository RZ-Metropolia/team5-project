# Consolidated Heuristic Evaluation Report
**Project:** Assignment Submission System
**Evaluators:** Rui Zhao, Zongru Li, He Chun, Juyin

## 1. Introduction
This document serves as a consolidated Heuristic Evaluation Report for the Assignment Submission System, synthesizing the individual findings from four evaluators. The evaluation was conducted against Nielsen's 10 Usability Heuristics to identify usability problems in the user interface across both teacher and student workflows.

## 2. Severity Ratings Guide
Issues identified in this report are rated based on their impact on the user experience:
- **0** = Not a usability problem (or heuristic is satisfied)
- **1** = Cosmetic problem
- **2** = Minor usability problem
- **3** = Major usability problem
- **4** = Usability catastrophe

## 3. Consolidated Findings by Heuristic

### H1-1: Visibility of system status (Simple and natural dialog)
- **Issue 1:** Leftover development artifacts in the UI logic (e.g., `console.log`) clutter the console. *(Severity: 1)*
  - *Recommendation:* Remove development logs before production builds.
- **Issue 2:** Mismatch between assignment configuration and student submission workflow. Teachers can require files, but the student submission page only focuses on text. *(Severity: 3)*
  - *Recommendation:* Add a clear file upload section to the student submission page, displaying allowed file types and sizes.

### H1-2: Match between system and the real world (Speak the users' language)
- **Issue 1:** The interface mixes terminology like "Workspace" and "Course" interchangeably, and uses system-oriented terms like "Management". *(Severity: 2)*
  - *Recommendation:* Standardize terminology. Use "Courses" instead of "Workspace", and "Course Settings" instead of "Management".
- **Issue 2:** Login error message generic ("Login failed") instead of matching user expectations. *(Severity: 2)*
  - *Recommendation:* Change message to "Invalid username or password."
- **Issue 3:** Vague language when loading data in some pages. *(Severity: 1)*
  - *Recommendation:* Use clearer language to describe the current state.

### H1-3: User control and freedom (Minimize users' memory load)
- **Issue 1:** The password field lacks a "show/hide" toggle button, increasing memory load. *(Severity: 2)*
  - *Recommendation:* Add an eye icon toggle within the password input field.
- **Issue 2:** Course enrollment requires teachers to manually enter a User ID, increasing memory load and risk of error. *(Severity: 3)*
  - *Recommendation:* Provide a search function to find students by username or email.

### H1-4: Consistency and standards
- **Issue 1:** In LoginForm, the username label is linked to `htmlFor="email"`, while the input has `id="username"`, breaking accessibility. *(Severity: 3)*
  - *Recommendation:* Update the label to correctly use `htmlFor="username"`.
- **Issue 2:** Assignment status labels and terminology are inconsistent across the system (e.g., Draft, Published, Submitted, Completed). *(Severity: 2)*
  - *Recommendation:* Standardize status names and use consistent visual styles (badges, colors) for each status throughout the app.

### H1-5: Error prevention (Feedback)
- **Issue 1:** No loading state in WorkspaceList when fetching data, leaving the UI unresponsive. *(Severity: 3)*
  - *Recommendation:* Implement a loading spinner or skeleton loader for visual feedback.
- **Issue 2:** The register form does not have a double-check input for the password. *(Severity: 3)*
  - *Recommendation:* Add a confirm password field.
- **Issue 3:** State updates after actions (publishing assignments, saving grades) are not immediately visible on the page, relying only on toast notifications. *(Severity: 2)*
  - *Recommendation:* Update visible page elements immediately after important actions.

### H1-6: Recognition rather than recall (Clearly marked exits)
- **Issue 1:** In Login and Signup flows, there is no clear back button to return to a public landing page. *(Severity: 2)*
  - *Recommendation:* Provide a clear "Cancel" or "Return to Homepage" link.
- **Issue 2:** Confirmation dialogs (like Archiving) are too generic and force users to recall background text. *(Severity: 2)*
  - *Recommendation:* Improve confirmation dialogs by clearly explaining the consequence of the specific action.

### H1-7: Flexibility and efficiency of use (Shortcuts)
- **Issue 1:** The Teacher Dashboard requires navigating the workspaces list to access specific actions. *(Severity: 2)*
  - *Recommendation:* Add quick-access links or a "Recent Workspaces" section directly on the dashboard.
- **Issue 2:** No shortcuts or bulk actions exist for teachers to review and grade multiple submissions efficiently. *(Severity: 1-2)*
  - *Recommendation:* Add efficiency features like quick navigation between submissions, bulk actions, and keyboard shortcuts.

### H1-8: Aesthetic and minimalist design (Precise & constructive error messages)
- **Issue 1:** Error messages are generic ("Login Failed", "Failed to save"). They do not explain the cause or how to fix it. *(Severity: 2-3)*
  - *Recommendation:* Extract and display specific error messages from the backend (e.g., "User not found", "Submission content cannot be empty").

### H1-9: Help users recognize, diagnose, and recover from errors
- **Issue 1:** "Forgot Password" link redirects to a generic external YouTube video or cannot be completed. *(Severity: 2-4)*
  - *Recommendation:* Implement a functional password reset flow (collect email, send reset link).
- **Issue 2:** Login and signup forms lack client-side input formatting validation before network requests. *(Severity: 2)*
  - *Recommendation:* Add client-side validation logic (e.g., Zod, Regex).
- **Issue 3:** Lack of validation in the enrollment form before submission, and lack of requirements shown on the submission page. *(Severity: 3)*
  - *Recommendation:* Add stronger validation and preventive guidance before users submit forms.

### H1-10: Help and documentation
- **Issue 1:** The system provides limited help or documentation for first-time users for workflows like enrolling students or submitting assignments. *(Severity: 1-2)*
  - *Recommendation:* Add short help text, tooltips, or a simple help section for key workflows.

## 4. Conclusion
The heuristic evaluation of the Assignment Submission System highlights a generally solid foundation with significant opportunities for improvement in feedback, error handling, and memory load reduction. High-priority items to address include:
- Standardizing terminology across the app.
- Clarifying the student submission workflow (handling file uploads vs. text).
- Replacing manual User ID entry with a search-based enrollment system.
- Implementing clear loading states and constructive, specific error messages.
- Fixing broken flows like the "Forgot Password" mechanism and accessibility link errors.

Addressing these issues will improve the clarity, efficiency, and robustness of the application for both teachers and students.
