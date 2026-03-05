package Daos;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.sql.SQLException;
import java.util.Set;
import java.time.LocalDate;

/**
 * JUnit 5 test for ReservationDao.
 */
public class ReservationDaoTest {

    private ReservationDao reservationDao;

    @BeforeEach
    void setUp() {
        reservationDao = new ReservationDao();
    }

    @Test
    @DisplayName("Test fetching booked dates for a room")
    void testGetBookedDates() throws SQLException {
        LocalDate now = LocalDate.now();
        Set<String> dates = reservationDao.getBookedDates(1, now.getMonthValue(), now.getYear());
        assertNotNull(dates, "Booked dates set should not be null");
    }

    @Test
    @DisplayName("Test reservation DAO initialization")
    void testInitialization() {
        assertNotNull(reservationDao, "ReservationDao should be initialized");
    }
}
