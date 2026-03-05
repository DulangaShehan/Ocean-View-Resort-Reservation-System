package Daos;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.sql.SQLException;
import java.util.List;
import Models.Room;

/**
 * JUnit 5 test for RoomDao.
 */
public class RoomDaoTest {

    private RoomDao roomDao;

    @BeforeEach
    void setUp() {
        roomDao = new RoomDao();
    }

    @Test
    @DisplayName("Test fetching all rooms")
    void testGetAllRooms() throws SQLException {
        List<Room> rooms = roomDao.getAllRooms();
        assertNotNull(rooms, "Room list should not be null");
    }

    @Test
    @DisplayName("Test room count")
    void testGetRoomCount() throws SQLException {
        int count = roomDao.getRoomCount();
        assertTrue(count >= 0, "Room count should be non-negative");
    }

    @Test
    @DisplayName("Test fetching rooms with latest booking")
    void testGetRoomsWithLatestBooking() throws SQLException {
        List<Object[]> roomsWithBooking = roomDao.getRoomsWithLatestBooking();
        assertNotNull(roomsWithBooking, "Rooms with booking list should not be null");
    }
}
