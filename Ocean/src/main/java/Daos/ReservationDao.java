package Daos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import Models.Guest;
import Models.Reservation;
import Utils.DBCon;

public class ReservationDao {

    public List<Reservation> getAllReservationsWithRoomType() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT res.*, r.r_room_type FROM reservations res JOIN rooms r ON res.res_room_id = r.r_id ORDER BY res.res_id DESC";
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getInt("res_id"));
                r.setName(rs.getString("res_name"));
                r.setContact(rs.getString("res_contact"));
                r.setRoomId(rs.getInt("res_room_id"));
                r.setCheckIn(rs.getString("res_check_in"));
                r.setCheckOut(rs.getString("res_check_out"));
                r.setDates(rs.getString("res_dates"));
                r.setNightPrice(rs.getDouble("res_night_price"));
                r.setTotalPrice(rs.getDouble("res_total_price"));
                r.setRoomType(rs.getString("r_room_type"));
                list.add(r);
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return list;
    }

    public Reservation getReservationById(int id) throws SQLException {
        Reservation r = null;
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT * FROM reservations WHERE res_id = ?";
            pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();

            if (rs.next()) {
                r = new Reservation();
                r.setId(rs.getInt("res_id"));
                r.setName(rs.getString("res_name"));
                r.setContact(rs.getString("res_contact"));
                r.setRoomId(rs.getInt("res_room_id"));
                r.setCheckIn(rs.getString("res_check_in"));
                r.setCheckOut(rs.getString("res_check_out"));
                r.setDates(rs.getString("res_dates"));
                r.setNightPrice(rs.getDouble("res_night_price"));
                r.setTotalPrice(rs.getDouble("res_total_price"));
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return r;
    }
    
    // Transactional Method: Save Reservation + Guest (if needed) + Room Update
    public void saveReservation(Reservation res, Guest guest) throws Exception {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            con.setAutoCommit(false);

            // 0. Check Availability (Prevent Double Booking)
            String checkResSql = "SELECT COUNT(*) FROM reservations WHERE res_room_id = ? AND res_check_in < ? AND res_check_out > ?";
            pst = con.prepareStatement(checkResSql);
            pst.setInt(1, res.getRoomId());
            pst.setString(2, res.getCheckOut());
            pst.setString(3, res.getCheckIn());
            rs = pst.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new Exception("Room is already booked for these dates (Reservation Conflict)");
            }
            rs.close();
            pst.close();

            String roomIdFormatted = String.format("R%03d%%", res.getRoomId());
            String checkHisSql = "SELECT COUNT(*) FROM re_history WHERE re_his_room LIKE ? AND re_his_check_in < ? AND re_his_check_out > ?";
            pst = con.prepareStatement(checkHisSql);
            pst.setString(1, roomIdFormatted);
            pst.setString(2, res.getCheckOut());
            pst.setString(3, res.getCheckIn());
            rs = pst.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new Exception("Room is not available for these dates (History Conflict)");
            }
            rs.close();
            pst.close();

            // 1. Check and Save Guest if not exists (based on NIC)
            if (guest.getNic() != null && !guest.getNic().trim().isEmpty()) {
                String checkGuestSql = "SELECT g_id FROM guests WHERE g_nic = ?";
                pst = con.prepareStatement(checkGuestSql);
                pst.setString(1, guest.getNic());
                rs = pst.executeQuery();
                
                boolean guestExists = rs.next();
                rs.close();
                pst.close();
                
                if (!guestExists) {
                    String insertGuestSql = "INSERT INTO guests (g_name, g_nic, g_address, g_contact) VALUES (?, ?, ?, ?)";
                    pst = con.prepareStatement(insertGuestSql);
                    pst.setString(1, guest.getName());
                    pst.setString(2, guest.getNic());
                    pst.setString(3, guest.getAddress() != null ? guest.getAddress() : "");
                    pst.setString(4, guest.getContact());
                    pst.executeUpdate();
                    pst.close();
                }
            }
            
            // 2. Get room price
            String priceSql = "SELECT r_one_night_price FROM rooms WHERE r_id = ?";
            pst = con.prepareStatement(priceSql);
            pst.setInt(1, res.getRoomId());
            rs = pst.executeQuery();
            
            double pricePerNight = 0;
            if (rs.next()) {
                pricePerNight = rs.getDouble("r_one_night_price");
            } else {
                throw new Exception("Room not found");
            }
            rs.close();
            pst.close();
            
            // 3. Calculate nights and total
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate checkIn = LocalDate.parse(res.getCheckIn(), formatter);
            LocalDate checkOut = LocalDate.parse(res.getCheckOut(), formatter);
            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            if (nights <= 0) nights = 1;
            
            double totalPrice = pricePerNight * nights;
            
            // 4. Insert reservation
            String insertSql = "INSERT INTO reservations (res_name, res_contact, res_room_id, res_check_in, res_check_out, res_dates, res_night_price, res_total_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pst = con.prepareStatement(insertSql);
            pst.setString(1, res.getName());
            pst.setString(2, res.getContact());
            pst.setInt(3, res.getRoomId());
            pst.setString(4, res.getCheckIn());
            pst.setString(5, res.getCheckOut());
            pst.setString(6, nights + " nights");
            pst.setDouble(7, pricePerNight);
            pst.setDouble(8, totalPrice);
            pst.executeUpdate();
            pst.close();
            
            // 5. Update room status
            String updateRoomSql = "UPDATE rooms SET r_status = 'Booked' WHERE r_id = ?";
            pst = con.prepareStatement(updateRoomSql);
            pst.setInt(1, res.getRoomId());
            pst.executeUpdate();
            
            con.commit();
            
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (con != null) try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        }
    }
    
    public void updateReservation(Reservation res) throws Exception {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            con.setAutoCommit(false);
            
            // 1. Get existing reservation details (price)
            String getResSql = "SELECT res_night_price FROM reservations WHERE res_id = ?";
            pst = con.prepareStatement(getResSql);
            pst.setInt(1, res.getId());
            rs = pst.executeQuery();
            
            double pricePerNight = 0;
            if (rs.next()) {
                pricePerNight = rs.getDouble("res_night_price");
            } else {
                throw new Exception("Reservation not found");
            }
            rs.close();
            pst.close();
            
            // 2. Calculate new nights and total
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate checkIn = LocalDate.parse(res.getCheckIn(), formatter);
            LocalDate checkOut = LocalDate.parse(res.getCheckOut(), formatter);
            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            if (nights <= 0) nights = 1;
            
            double totalPrice = pricePerNight * nights;
            
            // 3. Update reservation
            String updateSql = "UPDATE reservations SET res_name=?, res_contact=?, res_check_in=?, res_check_out=?, res_dates=?, res_total_price=? WHERE res_id=?";
            pst = con.prepareStatement(updateSql);
            pst.setString(1, res.getName());
            pst.setString(2, res.getContact());
            pst.setString(3, res.getCheckIn());
            pst.setString(4, res.getCheckOut());
            pst.setString(5, nights + " nights");
            pst.setDouble(6, totalPrice);
            pst.setInt(7, res.getId());
            pst.executeUpdate();
            pst.close();
            
            // 4. Update Billing Table (Sync)
            String updateBillingSql = "UPDATE billing SET b_name=?, b_night=?, b_total_price=? WHERE b_res_id=?";
            pst = con.prepareStatement(updateBillingSql);
            pst.setString(1, res.getName());
            pst.setString(2, String.valueOf(nights));
            pst.setDouble(3, totalPrice);
            pst.setInt(4, res.getId());
            pst.executeUpdate();
            
            con.commit();
            
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (con != null) try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        }
    }
    
    public void deleteReservation(int id) throws Exception {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            con.setAutoCommit(false);
            
            // 1. Get room ID
            String getRoomSql = "SELECT res_room_id FROM reservations WHERE res_id = ?";
            pst = con.prepareStatement(getRoomSql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
            
            int roomId = 0;
            if (rs.next()) {
                roomId = rs.getInt("res_room_id");
            } else {
                throw new Exception("Reservation not found");
            }
            rs.close();
            pst.close();
            
            // 2. Delete reservation
            String deleteSql = "DELETE FROM reservations WHERE res_id = ?";
            pst = con.prepareStatement(deleteSql);
            pst.setInt(1, id);
            pst.executeUpdate();
            pst.close();
            
            // 3. Update room status to Available
            String updateRoomSql = "UPDATE rooms SET r_status = 'Available' WHERE r_id = ?";
            pst = con.prepareStatement(updateRoomSql);
            pst.setInt(1, roomId);
            pst.executeUpdate();
            pst.close();
            
            // 4. Delete from Billing Table (Sync)
            String deleteBillingSql = "DELETE FROM billing WHERE b_res_id = ?";
            pst = con.prepareStatement(deleteBillingSql);
            pst.setInt(1, id);
            pst.executeUpdate();
            
            con.commit();
            
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (con != null) try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        }
    }
    
    public java.util.Set<String> getBookedDates(int roomId, int month, int year) throws SQLException {
        java.util.Set<String> bookedDates = new java.util.HashSet<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            con = DBCon.getConnection();

            // Calculate start and end of the month
            java.time.YearMonth yearMonth = java.time.YearMonth.of(year, month);
            LocalDate startOfMonth = yearMonth.atDay(1);
            LocalDate endOfMonth = yearMonth.atEndOfMonth();
            
            DateTimeFormatter dbFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            String somStr = startOfMonth.format(dbFormatter);
            String eomStr = endOfMonth.format(dbFormatter);

            // 1. Query 'reservations' table
            String sqlRes = "SELECT res_check_in, res_check_out FROM reservations WHERE res_room_id = ? AND res_check_in <= ? AND res_check_out >= ?";
            pst = con.prepareStatement(sqlRes);
            pst.setInt(1, roomId);
            pst.setString(2, eomStr);
            pst.setString(3, somStr);
            rs = pst.executeQuery();

            processBookings(rs, bookedDates, startOfMonth, endOfMonth, "res_check_in", "res_check_out");
            rs.close();
            pst.close();

            // 2. Query 're_history' table
            String roomPattern = String.format("R%03d%%", roomId);
            String sqlHist = "SELECT re_his_check_in, re_his_check_out FROM re_history WHERE re_his_room LIKE ? AND re_his_check_in <= ? AND re_his_check_out >= ?";
            pst = con.prepareStatement(sqlHist);
            pst.setString(1, roomPattern);
            pst.setString(2, eomStr);
            pst.setString(3, somStr);
            rs = pst.executeQuery();

            processBookings(rs, bookedDates, startOfMonth, endOfMonth, "re_his_check_in", "re_his_check_out");
            
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return bookedDates;
    }
    
    private void processBookings(ResultSet rs, java.util.Set<String> bookedDates, LocalDate startOfMonth, LocalDate endOfMonth, String colCheckIn, String colCheckOut) throws SQLException {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        while (rs.next()) {
            String checkInStr = rs.getString(colCheckIn);
            String checkOutStr = rs.getString(colCheckOut);

            if (checkInStr != null && checkOutStr != null) {
                try {
                    LocalDate checkIn = LocalDate.parse(checkInStr, formatter);
                    LocalDate checkOut = LocalDate.parse(checkOutStr, formatter);

                    LocalDate current = checkIn;
                    while (!current.isAfter(checkOut)) {
                        if (!current.isBefore(startOfMonth) && !current.isAfter(endOfMonth)) {
                            bookedDates.add(current.format(formatter));
                        }
                        current = current.plusDays(1);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
