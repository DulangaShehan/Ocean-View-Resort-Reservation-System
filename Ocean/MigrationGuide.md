# Database Connection Migration Guide

## Overview
This guide documents the refactoring of the Ocean application to centralize database connections. All controllers now use `Utils.DBCon` instead of creating individual connections.

## Changes Applied

### 1. Centralized Database Connection Class (`Utils.DBCon.java`)
- **Location**: `src/main/java/Utils/DBCon.java`
- **Changes**:
  - Converted to a static utility class.
  - Added `getConnection()` method to return `java.sql.Connection`.
  - Moved JDBC driver loading (`Class.forName`) to a static block.
  - Centralized DB credentials (`DB_URL`, `DB_USER`, `DB_PASSWORD`).

### 2. Controller Refactoring
The following controllers were refactored to remove inline `DriverManager` calls and use `DBCon.getConnection()`:

| Controller File | Changes Made |
|----------------|--------------|
| `billing.java` | Removed `DB_URL`, `DB_USER`, `DB_PASSWORD`. Replaced `DriverManager.getConnection` with `DBCon.getConnection()`. Added logging. |
| `dashboard.java` | Removed inline credentials. Used `DBCon.getConnection()`. |
| `guests.java` | Removed inline credentials. Used `DBCon.getConnection()`. |
| `login.java` | Removed inline credentials. Used `DBCon.getConnection()`. |
| `reservations.java` | Removed inline credentials. Used `DBCon.getConnection()` in all handler methods. |
| `roomavailability.java` | Removed inline credentials. Used `DBCon.getConnection()`. |
| `rooms.java` | Removed inline credentials. Used `DBCon.getConnection()` in `doGet` and `doPost`. |

### 3. Code Comparison Example

**Before (Inline Connection):**
```java
// Database credentials
private static final String DB_URL = "jdbc:mysql://localhost:3306/ocean_view_db";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "Dulanga@2022";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    // ...
} catch (Exception e) {
    e.printStackTrace();
}
```

**After (Centralized Connection):**
```java
import Utils.DBCon;

try {
    Connection con = DBCon.getConnection();
    // ...
} catch (Exception e) {
    e.printStackTrace();
    request.setAttribute("error", "Database connection error in [Controller]: " + e.getMessage());
}
```

## Configuration Changes
- **Driver Loading**: The MySQL driver is now loaded once in `DBCon`'s static block.
- **Credentials**: Managed in `Utils.DBCon.java`. Update them there to change for the whole app.

## Verification
- **Unit Tests**: See `src/test/java/ControllerDBTest.java` (requires JUnit/Mockito).
- **Manual Test**: Check that all pages (Dashboard, Rooms, Guests, Billing) load data correctly without errors.
