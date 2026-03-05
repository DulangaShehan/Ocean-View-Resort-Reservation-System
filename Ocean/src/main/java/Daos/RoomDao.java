package Daos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import Models.Room;
import Utils.DBCon;

public class RoomDao {

    public List<Room> getAllRooms() throws SQLException {
        List<Room> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT * FROM rooms ORDER BY r_id DESC";
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                Room r = new Room();
                r.setId(rs.getInt("r_id"));
                r.setRoomType(rs.getString("r_room_type"));
                r.setAcType(rs.getString("r_ac_type"));
                r.setBedType(rs.getString("r_bed_type"));
                r.setView(rs.getString("r_view"));
                r.setMaxMembers(rs.getInt("r_max_members"));
                r.setStatus(rs.getString("r_status"));
                r.setOneNightPrice(rs.getDouble("r_one_night_price"));
                list.add(r);
            }
            
            // Dynamic Status Logic moved from Controller to DAO (or kept here as helper)
            updateDynamicStatus(con, list);
            
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return list;
    }
    
    // Check availability against both reservations and re_history
    public List<Room> getAvailableRooms(String checkInStr, String checkOutStr) throws SQLException {
        List<Room> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            Set<Integer> bookedIds = new HashSet<>();
            
            // 1. Check reservations table
            // Overlap: (StartA < EndB) and (EndA > StartB)
            // Note: We use string comparison for dates YYYY-MM-DD which is lexicographically correct
            String sqlRes = "SELECT res_room_id FROM reservations WHERE res_check_in < ? AND res_check_out > ?";
            pst = con.prepareStatement(sqlRes);
            pst.setString(1, checkOutStr);
            pst.setString(2, checkInStr);
            rs = pst.executeQuery();
            while (rs.next()) {
                bookedIds.add(rs.getInt("res_room_id"));
            }
            rs.close();
            pst.close();
            
            // 2. Check re_history table
            // re_his_room is like "R001 - Single"
            String sqlHist = "SELECT re_his_room FROM re_history WHERE re_his_check_in < ? AND re_his_check_out > ?";
            pst = con.prepareStatement(sqlHist);
            pst.setString(1, checkOutStr);
            pst.setString(2, checkInStr);
            rs = pst.executeQuery();
            while (rs.next()) {
                String roomStr = rs.getString("re_his_room");
                if (roomStr != null && roomStr.length() >= 4 && roomStr.startsWith("R")) {
                    try {
                        // Extract "001" from "R001..."
                        String idPart = roomStr.substring(1, 4); 
                        bookedIds.add(Integer.parseInt(idPart));
                    } catch (Exception e) {
                        // Ignore parse errors if format doesn't match
                    }
                }
            }
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            
            // 3. Get All Rooms and Filter
            String sqlRooms = "SELECT * FROM rooms ORDER BY r_id DESC";
            pst = con.prepareStatement(sqlRooms);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                int rId = rs.getInt("r_id");
                if (!bookedIds.contains(rId)) {
                    Room r = new Room();
                    r.setId(rId);
                    r.setRoomType(rs.getString("r_room_type"));
                    r.setAcType(rs.getString("r_ac_type"));
                    r.setBedType(rs.getString("r_bed_type"));
                    r.setView(rs.getString("r_view"));
                    r.setMaxMembers(rs.getInt("r_max_members"));
                    r.setStatus(rs.getString("r_status"));
                    r.setOneNightPrice(rs.getDouble("r_one_night_price"));
                    list.add(r);
                }
            }
            
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return list;
    }

    // Helper to update status based on reservations
    private void updateDynamicStatus(Connection con, List<Room> rooms) throws SQLException {
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            LocalDate today = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            String todayStr = today.format(formatter);
            
            String checkSql = "SELECT res_room_id, res_check_in, res_check_out FROM reservations WHERE res_check_out >= ?";
            pst = con.prepareStatement(checkSql);
            pst.setString(1, todayStr);
            rs = pst.executeQuery();
            
            Set<Integer> bookedIds = new HashSet<>();
            while (rs.next()) {
                String checkInStr = rs.getString("res_check_in");
                String checkOutStr = rs.getString("res_check_out");
                int rId = rs.getInt("res_room_id");
                
                if (checkInStr != null && checkOutStr != null) {
                    try {
                        LocalDate checkIn = LocalDate.parse(checkInStr, formatter);
                        LocalDate checkOut = LocalDate.parse(checkOutStr, formatter);
                        
                        if (!today.isBefore(checkIn) && !today.isAfter(checkOut)) {
                            bookedIds.add(rId);
                        }
                    } catch (DateTimeParseException e) {
                        e.printStackTrace();
                    }
                }
            }
            
            for (Room r : rooms) {
                if (bookedIds.contains(r.getId())) {
                    r.setStatus("Booked");
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        }
    }

    public boolean addRoom(Room r) throws SQLException {
        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = DBCon.getConnection();
            String sql = "INSERT INTO rooms (r_room_type, r_ac_type, r_bed_type, r_view, r_max_members, r_status, r_one_night_price) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pst = con.prepareStatement(sql);
            pst.setString(1, r.getRoomType());
            pst.setString(2, r.getAcType());
            pst.setString(3, r.getBedType());
            pst.setString(4, r.getView());
            pst.setInt(5, r.getMaxMembers());
            pst.setString(6, "Available"); // Default
            pst.setDouble(7, r.getOneNightPrice());
            return pst.executeUpdate() > 0;
        } finally {
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
    }

    public boolean updateRoom(Room r) throws SQLException {
        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = DBCon.getConnection();
            String sql = "UPDATE rooms SET r_room_type=?, r_ac_type=?, r_bed_type=?, r_view=?, r_max_members=?, r_one_night_price=? WHERE r_id=?";
            pst = con.prepareStatement(sql);
            pst.setString(1, r.getRoomType());
            pst.setString(2, r.getAcType());
            pst.setString(3, r.getBedType());
            pst.setString(4, r.getView());
            pst.setInt(5, r.getMaxMembers());
            pst.setDouble(6, r.getOneNightPrice());
            pst.setInt(7, r.getId());
            return pst.executeUpdate() > 0;
        } finally {
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
    }

    public boolean deleteRoom(int id) throws SQLException {
        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = DBCon.getConnection();
            String sql = "DELETE FROM rooms WHERE r_id = ?";
            pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            return pst.executeUpdate() > 0;
        } finally {
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
    }
    
    // For Reservation Form: Get rooms with their latest booking dates
    // This returns a list of Maps or custom objects? Ideally Models. 
    // But Room model doesn't have booking dates. I'll stick to basic Room and fetch dates if needed or modify Room model.
    // Given the complexity of `getAvailableRooms` in controller, I'll return a raw list of Rooms and handle the dates in a specialized DTO or just use Map in controller if needed, OR enhance Room model.
    // Let's enhance Room model via a subclass or just use a helper method that returns a custom structure if strict MVC is desired.
    // For now, I will replicate the logic in Controller using this DAO, but let's expose a method that does the join.
    
    public List<Object[]> getRoomsWithLatestBooking() throws SQLException {
        // Returns Object[] { Room object, checkIn String, checkOut String }
        List<Object[]> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT r.*, res.res_check_in, res.res_check_out " +
                         "FROM rooms r " +
                         "LEFT JOIN (" +
                         "    SELECT res_room_id, res_check_in, res_check_out " +
                         "    FROM reservations " +
                         "    WHERE res_id IN (" +
                         "        SELECT MAX(res_id) " +
                         "        FROM reservations " +
                         "        GROUP BY res_room_id" +
                         "    )" +
                         ") res ON r.r_id = res.res_room_id " +
                         "ORDER BY r.r_id ASC";
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                Room r = new Room();
                r.setId(rs.getInt("r_id"));
                r.setRoomType(rs.getString("r_room_type"));
                r.setAcType(rs.getString("r_ac_type"));
                r.setBedType(rs.getString("r_bed_type"));
                r.setView(rs.getString("r_view"));
                r.setStatus(rs.getString("r_status"));
                r.setOneNightPrice(rs.getDouble("r_one_night_price"));
                
                String checkIn = rs.getString("res_check_in");
                String checkOut = rs.getString("res_check_out");
                
                list.add(new Object[]{r, checkIn, checkOut});
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return list;
    }

    public int getRoomCount() throws SQLException {
        int count = 0;
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT COUNT(*) FROM rooms";
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return count;
    }
}
