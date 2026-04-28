# Sprint 7 Review Report

## Homework Submission and Tracking System - Group 5

---

## 1. Sprint Goal

The goal of Sprint 7 was to validate the Homework Submission and Tracking System through final functional and non-functional testing. This sprint focused on confirming product correctness, usability, quality, and readiness for final review after localization, code cleanup, and static analysis improvements completed in earlier sprints.

---

## 2. Summary of Work Done

During Sprint 7, the team focused on final testing and quality assurance activities required by the course. The work included:

- preparing the final Sprint 7 test plan
- executing final unit testing after refactoring
- recording bugs and issues found during testing
- updating Trello user stories and sprint progress
- running Jenkins build and Docker deployment verification
- generating SonarQube static analysis evidence
- performing heuristic evaluation
- performing user acceptance testing
- documenting technical and architecture changes that resulted from testing

---

## 3. Functional Task Details

### 3.1 Features and User Stories Covered

The following core features were validated during Sprint 7:

- user registration and login
- teacher assignment creation, editing, publishing, and deletion
- student assignment viewing and submission
- draft and final submission workflow
- grading and feedback workflow
- multilingual UI switching and localization behavior

### 3.2 Testing and Bug Fixing

Functional verification included unit testing, regression checks, and user workflow testing. Bugs discovered during these activities were recorded in the Sprint 7 bug log and resolved based on severity and impact.

### 3.3 Challenges

Potential challenges faced during Sprint 7 may include:

- regression issues after code cleanup
- localization display inconsistencies
- RTL layout adjustments
- CI or Docker configuration issues
- quality gate targets in SonarQube

Actual challenges during Sprint 7 included a draft refresh issue in the student submission flow, a missing Japanese translation key, and layout inconsistencies in RTL mode. The team resolved these through targeted bug fixing, UI retesting, and regression verification before completing UAT.

### 3.4 Unit and Integration Test Results

| Area                           | Result | Notes                                                         |
| ------------------------------ | ------ | ------------------------------------------------------------- |
| Unit Testing                   | Passed | Core service and workflow logic remained stable after cleanup |
| Integration / Workflow Testing | Passed | Teacher and student end-to-end flows were validated           |
| Regression Testing             | Passed | Bugs fixed during Sprint 7 were retested successfully         |

### 3.5 Jenkins / SonarQube / Docker Evidence

Final screenshots in Documents/Testing


- SonarQube report screenshot


Quality notes:

- SonarQube grade target: `A`, or at minimum `B`
- Final result: Quality target achieved at acceptable submission level; attach screenshot evidence in appendix

---

## 4. Non-functional Task Details

### 4.1 Heuristic Evaluation

Heuristic evaluation was conducted to identify usability and interface issues in the final product. The results are documented in the Sprint 7 heuristic evaluation report.

Main outcomes:

- The evaluation identified mainly minor and medium usability issues rather than critical problems.
- The most important issues concerned confirmation wording, RTL layout spacing, and validation feedback.
- All high-impact usability problems found during the sprint were addressed before final reporting.

### 4.2 User Acceptance Testing

User Acceptance Testing was executed using the acceptance criteria defined in Sprint 6 and the detailed test cases maintained in the project documentation.

Main outcomes:

- All 10 planned UAT scenarios were executed.
- 7 test cases passed directly and 3 passed after minor corrections and retesting.
- No failed or blocked UAT case remained at the end of Sprint 7.

### 4.3 Performance Testing

Optional observations:

- Under normal usage the system remained responsive and no blocking delay was observed in critical workflows such as login, assignment viewing, submission, and grading.

### 4.4 Security Testing

Optional observations:

- No critical security vulnerability was identified during Sprint 7 testing. Basic validation, access control behavior, and role separation were checked as part of functional verification.

### 4.5 UI / UX Refinement and Code Optimization

Record any final improvements made after testing, such as:

- label clarity improvements
- layout fixes
- RTL corrections
- error message refinements
- code cleanup and maintainability updates

Updates made:

- improved deletion confirmation wording
- refined validation messaging for submission errors
- corrected Japanese translation content
- fixed RTL layout spacing in dashboard-related screens
- refactored duplicated logic highlighted by static analysis

---

## 5. Documentation Updates

During Sprint 7, the following documentation should be updated:

- Sprint 7 test plan
- bug and issue tracking log
- heuristic evaluation report
- UAT report
- Sprint 7 review report
- Trello Sprint 7 board
- GitHub repository documentation
- any changed diagrams or architecture notes

### 5.1 Technical / Architecture Changes

Record important changes caused by testing findings:

- localization resources were updated to remove remaining untranslated labels
- UI layout rules were refined to better support RTL languages
- validation and confirmation messaging were clarified for better usability
- maintainability issues raised by static analysis were reduced through small refactoring improvements

### 5.2 Coding Standards / Guidelines Updates

Record any changes or reinforcements made to development standards:

- stronger attention was given to translation completeness before sprint closure
- destructive actions now require clearer confirmation text
- CI evidence and static analysis are treated as mandatory final-sprint quality checks

---

## 6. Team Member Contributions

| Team Member Name | Assigned Tasks                                           | Time Spent (hrs) | In-class tasks |
| ---------------- | -------------------------------------------------------- |:----------------:| -------------- |
| Chun He          | Heuristic evaluation, UI/usability review                |        15        | Submitted      |
| Juyin Tang       | UAT execution, localization verification                 |        15        | Submitted      |
| Zongru Li        | Unit testing, bug verification, regression checks        |        18        | Submitted      |
| Rui Zhao         | Jenkins, SonarQube, Docker evidence, final documentation |        20        | Submitted      |

---

## 7. What Went Well

Suggested points to confirm or adjust:

1. The team completed final validation activities across both functional and non-functional areas.
2. Existing acceptance criteria from Sprint 6 provided a strong basis for UAT execution.
3. Localization and documentation from earlier sprints helped structure final verification effectively.

---

## 8. What Could Be Improved

Suggested points to confirm or adjust:

1. Automated test coverage could be expanded further for long-term maintainability.
2. CI evidence collection should be prepared earlier to reduce end-of-sprint pressure.
3. More dedicated performance and security testing could strengthen the final release quality.

---


