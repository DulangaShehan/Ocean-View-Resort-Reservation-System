package Utils;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * JUnit 5 test for DBCon.
 */
public class DBConTest {

    @Test
    @DisplayName("Test getting a database connection")
    void testGetConnection() {
        try (Connection con = DBCon.getConnection()) {
            assertNotNull(con, "DBCon.getConnection() should not return null");
            assertFalse(con.isClosed(), "Connection should be open");
        } catch (SQLException e) {
            fail("SQL Exception occurred during connection test: " + e.getMessage());
        }
    }
}
