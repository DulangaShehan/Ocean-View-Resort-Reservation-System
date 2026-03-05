# Test Plan: Ocean View Hotel Management System

This document details the automated testing strategy for the Ocean View Hotel system, ensuring that the refactored Model-View-Controller (MVC) architecture is robust and error-free.

## 1. Rationale for Approach (TDD)
Test-Driven Development (TDD) was adopted to ensure that the core logic of the system is verified before it is integrated into the web controllers. This approach guarantees that:
-   **Core Logic is Decoupled**: DAOs are tested in isolation from the Servlet environment.
-   **Regression Testing**: Any future changes to the database schema or DAO logic can be verified immediately.
-   **Live Documentation**: The test cases serve as a specification of how each DAO should behave.

## 2. Automated Test Suite (JUnit 5)
The system uses the **JUnit 5 (JUnit Platform)** for all automated tests.

### **How to Run the Test Plan**
To execute the entire test suite and view the results in your IDE:
1.  **Locate the Test Suite**: Open `src/test/java/Daos/FullTestPlan.java`.
2.  **Execute**: Right-click the file and select **Run As → JUnit Test**.
3.  **View Results**:
    -   The **JUnit view** will open in your IDE (usually at the bottom or left).
    -   A **Green bar** indicates all tests passed.
    -   A **Red bar** indicates one or more tests failed, with details provided in the failure trace.
4.  **Troubleshooting**: If you don't see the JUnit view, go to **Window → Show View → Other... → Java → JUnit**.

## 3. Test Cases & Data Derivation

### **3.1. User Authentication ([UserDaoTest.java](file:///d:/eclips/New%20folder/Ocean/src/test/java/Daos/UserDaoTest.java))**
-   **TC-01: Invalid Credentials**: Verify that the system returns `null` for non-existent users.
-   **TC-02: Admin Login**: Verify that the `admin` user (if present in the DB) is correctly validated.

### **3.2. Guest Management ([GuestDaoTest.java](file:///d:/eclips/New%20folder/Ocean/src/test/java/Daos/GuestDaoTest.java))**
-   **TC-03: Fetch All Guests**: Ensures the system can retrieve the full guest list.
-   **TC-04: Guest Count**: Verifies that the count query matches the size of the retrieved list.

### **3.3. Room & Reservations ([RoomDaoTest.java](file:///d:/eclips/New%20folder/Ocean/src/test/java/Daos/RoomDaoTest.java))**
-   **TC-05: Room Inventory**: Checks that the room count is non-negative.
-   **TC-06: Booked Dates**: Verifies that date retrieval for reservations does not crash and returns a valid set.

### **3.4. Billing ([BillingDaoTest.java](file:///d:/eclips/New%20folder/Ocean/src/test/java/Daos/BillingDaoTest.java))**
-   **TC-07: Fetch Bills**: Ensures that billing data can be retrieved with full reservation details.
-   **TC-08: Price Verification**: Verifies that total prices are non-negative for all bills.

### **3.5. Architectural Auditing ([ControllerDBTest.java](file:///d:/eclips/New%20folder/Ocean/src/test/java/Utils/ControllerDBTest.java))**
-   **TC-09: No Inline SQL**: Scans all Controllers to ensure no direct `DriverManager` or inline SQL credentials exist, confirming full MVC separation.

## 4. Execution Summary (2026-03-01)
The test suite has been successfully executed in the development environment.

| Test Category | Results | Status |
| :--- | :--- | :--- |
| **DAO Layer** | All methods (validate, getAll, getCount) | **PASS** |
| **Model Layer** | POJO consistency and null handling | **PASS** |
| **Database Connection** | Connection pool and driver availability | **PASS** |
| **Architecture Audit** | Zero inline SQL violations in Controllers | **PASS** |

## 5. Traceability Matrix
| Requirement ID | Requirement Description | Test Class |
| :--- | :--- | :--- |
| **REQ-001** | Secure User Authentication | `UserDaoTest` |
| **REQ-002** | Guest Management CRUD | `GuestDaoTest` |
| **REQ-003** | Room Inventory Tracking | `RoomDaoTest` |
| **REQ-004** | Reservation Management | `ReservationDaoTest` |
| **REQ-005** | Automated Billing System | `BillingDaoTest` |
| **REQ-006** | MVC Architecture Compliance | `ControllerDBTest` |
