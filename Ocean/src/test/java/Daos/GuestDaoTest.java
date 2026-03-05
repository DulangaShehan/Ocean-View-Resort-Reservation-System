package Daos;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.sql.SQLException;
import java.util.List;
import Models.Guest;

/**
 * JUnit 5 test for GuestDao.
 */
public class GuestDaoTest {

    private GuestDao guestDao;

    @BeforeEach
    void setUp() {
        guestDao = new GuestDao();
    }

    @Test
    @DisplayName("Test fetching all guests")
    void testGetAllGuests() throws SQLException {
        List<Guest> guests = guestDao.getAllGuests();
        assertNotNull(guests, "Guest list should not be null");
    }

    @Test
    @DisplayName("Test guest count consistency")
    void testGuestCountConsistency() throws SQLException {
        List<Guest> guests = guestDao.getAllGuests();
        int count = guestDao.getGuestCount();
        assertEquals(guests.size(), count, "Guest list size should match guest count");
    }
}
