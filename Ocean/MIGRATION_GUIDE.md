# Migration Guide: Database Refactoring & MVC Transformation

## Overview
This document details the refactoring of the Ocean View Hotel Management System to use a centralized database connection utility (`Utils.DBCon`) and a proper Model-View-Controller (MVC) architecture.

## 1. Database Connection Refactoring
**Goal**: Eliminate redundant database connection code and centralize connection management.

### Changes Implemented:
*   **Centralized Utility**: Created `src/main/java/Utils/DBCon.java`.
    *   Provides a static `getConnection()` method.
    *   Manages JDBC driver loading and database credentials.
*   **Controller Cleanup**:
    *   **Removed**: All instances of `DriverManager.getConnection(...)`, `Class.forName("com.mysql.cj.jdbc.Driver")`, and inline SQL credentials from Controller classes.
    *   **Added**: Calls to `DBCon.getConnection()` (via DAOs).
    *   **Benefit**: Changing database credentials now requires editing only **one file** (`DBCon.java`).

### Validation:
*   **Static Analysis**: `src/test/java/Utils/ControllerDBTest.java` scans controllers to ensure no inline `DriverManager` calls remain.
*   **Connection Test**: `src/test/java/Utils/DBConTest.java` verifies that `DBCon` returns valid connections.

## 2. MVC Architecture Transformation
**Goal**: Separate business logic (Models/DAOs) from request handling (Controllers).

### New Structure:
*   **Models** (`src/main/java/Models`):
    *   `User.java`, `Guest.java`, `Room.java`, `Reservation.java`, `Bill.java`.
    *   Simple POJOs representing database entities.
*   **DAOs** (`src/main/java/Daos`):
    *   `UserDao.java`, `GuestDao.java`, `RoomDao.java`, `ReservationDao.java`, `BillingDao.java`.
    *   Encapsulate all JDBC/SQL operations.
    *   Handle transactions (commit/rollback) and connection lifecycle.

### Controller Refactoring Details:

| Controller File | Original State | Refactored State | DAO Used |
| :--- | :--- | :--- | :--- |
| `login.java` | Inline SQL to check user credentials | Calls `UserDao.validate()` | `UserDao` |
| `guests.java` | Inline SQL for CRUD on guests | Calls `GuestDao` methods | `GuestDao` |
| `rooms.java` | Inline SQL for room management | Calls `RoomDao` methods | `RoomDao` |
| `reservations.java` | Complex inline SQL & Transaction logic | Calls `ReservationDao` (transactional) | `ReservationDao`, `GuestDao`, `RoomDao` |
| `billing.java` | Inline SQL for billing/checkout | Calls `BillingDao` (transactional) | `BillingDao` |
| `roomavailability.java` | Inline SQL to check dates | Calls `ReservationDao.getBookedDates()` | `ReservationDao` |
| `dashboard.java` | Inline SQL to count records | Calls `GuestDao.getGuestCount()`, `RoomDao.getRoomCount()` | `GuestDao`, `RoomDao` |

## 3. Configuration & Usage

### Database Configuration
To update database credentials, modify `src/main/java/Utils/DBCon.java`:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/ocean_view_db";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "YOUR_PASSWORD";
```

### Running Tests
New test files have been added to verify the refactoring. Note that these are designed as standalone Java applications (for manual execution) or JUnit tests if dependencies are added.

*   **Location**: `src/test/java/`
*   **Key Tests**:
    *   `Utils/ControllerDBTest.java`: Verifies no inline SQL in controllers.
    *   `Daos/GuestDaoTest.java`: Tests Guest DAO functionality.
    *   `Daos/RoomDaoTest.java`: Tests Room DAO functionality.
    *   `Daos/ReservationDaoTest.java`: Tests Reservation DAO functionality.

## 4. Next Steps
*   Ensure `mysql-connector-j` is in your classpath (already present in `WEB-INF/lib`).
*   If using an IDE like Eclipse, ensure `src/test/java` is added as a Source Folder in the Build Path.
