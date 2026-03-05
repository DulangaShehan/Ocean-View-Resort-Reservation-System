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

import Models.Bill;
import Utils.DBCon;

public class BillingDao {

    public List<Bill> getAllBillsWithDetails() throws SQLException {
        List<Bill> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            
            // Sync Logic call
            syncReservationsToBilling(con);
            
            String sql = "SELECT b.*, r.res_contact, r.res_check_in, r.res_check_out, r.res_room_id " +
                         "FROM billing b " +
                         "LEFT JOIN reservations r ON b.b_res_id = r.res_id " +
                         "ORDER BY b.b_id DESC";
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                Bill b = new Bill();
                b.setId(rs.getInt("b_id"));
                b.setName(rs.getString("b_name"));
                b.setResId(rs.getInt("b_res_id"));
                b.setNight(rs.getString("b_night"));
                b.setNightPrice(rs.getDouble("b_night_price"));
                b.setTotalPrice(rs.getDouble("b_total_price"));
                b.setStatus(rs.getString("b_status"));
                
                b.setResContact(rs.getString("res_contact"));
                b.setResCheckIn(rs.getString("res_check_in"));
                b.setResCheckOut(rs.getString("res_check_out"));
                b.setResRoomId(rs.getInt("res_room_id"));
                
                list.add(b);
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return list;
    }
    
    private void syncReservationsToBilling(Connection con) throws SQLException {
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            String findMissingSql = "SELECT r.* FROM reservations r LEFT JOIN billing b ON r.res_id = b.b_res_id WHERE b.b_res_id IS NULL";
            pst = con.prepareStatement(findMissingSql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                int resId = rs.getInt("res_id");
                String name = rs.getString("res_name");
                String checkInStr = rs.getString("res_check_in");
                String checkOutStr = rs.getString("res_check_out");
                double nightPrice = rs.getDouble("res_night_price");
                double totalPrice = rs.getDouble("res_total_price");
                
                long nights = 1;
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    LocalDate checkIn = LocalDate.parse(checkInStr, formatter);
                    LocalDate checkOut = LocalDate.parse(checkOutStr, formatter);
                    nights = ChronoUnit.DAYS.between(checkIn, checkOut);
                    if (nights <= 0) nights = 1;
                } catch (Exception e) {
                    // Ignore
                }
                
                String insertSql = "INSERT INTO billing (b_name, b_res_id, b_night, b_night_price, b_total_price, b_status) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement insertPst = con.prepareStatement(insertSql);
                insertPst.setString(1, name);
                insertPst.setInt(2, resId);
                insertPst.setString(3, String.valueOf(nights));
                insertPst.setDouble(4, nightPrice);
                insertPst.setDouble(5, totalPrice);
                insertPst.setString(6, "Pending");
                insertPst.executeUpdate();
                insertPst.close();
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        }
    }
    
    public void checkout(int billingId) throws Exception {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            con.setAutoCommit(false);
            
            // 1. Fetch Billing + Reservation Details
            String fetchSql = "SELECT b.*, r.*, rom.r_room_type, rom.r_id as room_db_id " +
                              "FROM billing b " +
                              "JOIN reservations r ON b.b_res_id = r.res_id " +
                              "JOIN rooms rom ON r.res_room_id = rom.r_id " +
                              "WHERE b.b_id = ?";
            pst = con.prepareStatement(fetchSql);
            pst.setInt(1, billingId);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                // Extract Data
                int resId = rs.getInt("res_id");
                String resName = rs.getString("res_name");
                String resContact = rs.getString("res_contact");
                int roomId = rs.getInt("room_db_id");
                String roomName = "R" + String.format("%03d", roomId) + " - " + rs.getString("r_room_type");
                String checkIn = rs.getString("res_check_in");
                String checkOut = rs.getString("res_check_out");
                double resTotal = rs.getDouble("res_total_price");
                
                int billId = rs.getInt("b_id");
                String billName = rs.getString("b_name");
                String billNights = rs.getString("b_night");
                double billNightPrice = rs.getDouble("b_night_price");
                double billTotal = rs.getDouble("b_total_price");
                
                // 2. Insert into re_history
                String insertReHis = "INSERT INTO re_history (re_his_res_id, re_his_name, re_his_contact, re_his_room, re_his_check_in, re_his_check_out, re_his_total, re_his_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstRe = con.prepareStatement(insertReHis);
                pstRe.setString(1, "RES" + String.format("%03d", resId));
                pstRe.setString(2, resName);
                pstRe.setString(3, resContact);
                pstRe.setString(4, roomName);
                pstRe.setString(5, checkIn);
                pstRe.setString(6, checkOut);
                pstRe.setDouble(7, resTotal);
                pstRe.setString(8, "Completed");
                pstRe.executeUpdate();
                pstRe.close();
                
                // 3. Insert into bi_history
                String insertBiHis = "INSERT INTO bi_history (bi_his_inv_id, bi_his_name, bi_his_res_id, bi_his_nights, bi_his_night_price, bi_his_total, bi_his_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstBi = con.prepareStatement(insertBiHis);
                pstBi.setString(1, "INV" + String.format("%03d", billId));
                pstBi.setString(2, billName);
                pstBi.setString(3, "RES" + String.format("%03d", resId));
                pstBi.setString(4, billNights);
                pstBi.setDouble(5, billNightPrice);
                pstBi.setDouble(6, billTotal);
                pstBi.setString(7, "Paid");
                pstBi.executeUpdate();
                pstBi.close();
                
                // 4. Update Room Status to Available
                String updateRoom = "UPDATE rooms SET r_status = 'Available' WHERE r_id = ?";
                PreparedStatement pstRoom = con.prepareStatement(updateRoom);
                pstRoom.setInt(1, roomId);
                pstRoom.executeUpdate();
                pstRoom.close();
                
                // 5. Delete from billing
                String deleteBill = "DELETE FROM billing WHERE b_id = ?";
                PreparedStatement pstDelBill = con.prepareStatement(deleteBill);
                pstDelBill.setInt(1, billId);
                pstDelBill.executeUpdate();
                pstDelBill.close();
                
                // 6. Delete from reservations
                String deleteRes = "DELETE FROM reservations WHERE res_id = ?";
                PreparedStatement pstDelRes = con.prepareStatement(deleteRes);
                pstDelRes.setInt(1, resId);
                pstDelRes.executeUpdate();
                pstDelRes.close();
                
                con.commit();
            } else {
                throw new Exception("Billing record not found");
            }
            
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw e;
        } finally {
            if (con != null) try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        }
    }
}
