package Daos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Models.Guest;
import Utils.DBCon;

public class GuestDao {

    public List<Guest> getAllGuests() throws SQLException {
        List<Guest> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT * FROM guests ORDER BY g_id DESC";
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                Guest g = new Guest();
                g.setId(rs.getInt("g_id"));
                g.setName(rs.getString("g_name"));
                g.setAddress(rs.getString("g_address"));
                g.setNic(rs.getString("g_nic"));
                g.setContact(rs.getString("g_contact"));
                list.add(g);
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return list;
    }
    
    public List<Guest> getAllGuestsByName() throws SQLException {
        List<Guest> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT * FROM guests ORDER BY g_name ASC";
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                Guest g = new Guest();
                g.setId(rs.getInt("g_id"));
                g.setName(rs.getString("g_name"));
                g.setAddress(rs.getString("g_address"));
                g.setNic(rs.getString("g_nic"));
                g.setContact(rs.getString("g_contact"));
                list.add(g);
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return list;
    }

    public Guest getGuestById(int id) throws SQLException {
        Guest g = null;
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT * FROM guests WHERE g_id = ?";
            pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();

            if (rs.next()) {
                g = new Guest();
                g.setId(rs.getInt("g_id"));
                g.setName(rs.getString("g_name"));
                g.setAddress(rs.getString("g_address"));
                g.setNic(rs.getString("g_nic"));
                g.setContact(rs.getString("g_contact"));
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return g;
    }

    public boolean addGuest(Guest guest) throws SQLException {
        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = DBCon.getConnection();
            String sql = "INSERT INTO guests (g_name, g_address, g_nic, g_contact) VALUES (?, ?, ?, ?)";
            pst = con.prepareStatement(sql);
            pst.setString(1, guest.getName());
            pst.setString(2, guest.getAddress());
            pst.setString(3, guest.getNic());
            pst.setString(4, guest.getContact());
            return pst.executeUpdate() > 0;
        } finally {
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
    }

    public boolean updateGuest(Guest guest) throws SQLException {
        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = DBCon.getConnection();
            String sql = "UPDATE guests SET g_name=?, g_address=?, g_nic=?, g_contact=? WHERE g_id=?";
            pst = con.prepareStatement(sql);
            pst.setString(1, guest.getName());
            pst.setString(2, guest.getAddress());
            pst.setString(3, guest.getNic());
            pst.setString(4, guest.getContact());
            pst.setInt(5, guest.getId());
            return pst.executeUpdate() > 0;
        } finally {
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
    }

    public boolean deleteGuest(int id) throws SQLException {
        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = DBCon.getConnection();
            String sql = "DELETE FROM guests WHERE g_id=?";
            pst = con.prepareStatement(sql);
            pst.setInt(1, id);
            return pst.executeUpdate() > 0;
        } finally {
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
    }

    public int getGuestCount() throws SQLException {
        int count = 0;
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT COUNT(*) FROM guests";
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
