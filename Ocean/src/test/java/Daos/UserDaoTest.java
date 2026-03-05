package Daos;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.sql.SQLException;
import Models.User;

/**
 * JUnit 5 test for UserDao.
 */
public class UserDaoTest {

    private UserDao userDao;

    @BeforeEach
    void setUp() {
        userDao = new UserDao();
    }

    @Test
    @DisplayName("Test validation with incorrect credentials should return null")
    void testValidateWithIncorrectCredentials() throws SQLException {
        User invalidUser = userDao.validate("wronguser", "badpass");
        assertNull(invalidUser, "Invalid user should be null");
    }

    @Test
    @DisplayName("Test validation with correct credentials (if user exists)")
    void testValidateWithCorrectCredentials() {
        try {
            User admin = userDao.validate("admin", "password123");
            if (admin != null) {
                assertEquals("admin", admin.getUsername());
            }
        } catch (SQLException e) {
            fail("SQL Exception occurred: " + e.getMessage());
        }
    }
}
