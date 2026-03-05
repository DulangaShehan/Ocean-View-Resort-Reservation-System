package Daos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.User;
import Utils.DBCon;

public class UserDao {

    public User validate(String username, String password) throws SQLException {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        User user = null;

        try {
            con = DBCon.getConnection();
            String sql = "SELECT admin_id, a_username, a_role_id FROM admin WHERE a_username = ? AND a_password = ?";
            pst = con.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, password);
            rs = pst.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setAdminId(rs.getInt("admin_id"));
                user.setUsername(rs.getString("a_username"));
                
                // Handle potential null value for a_role_id
                int roleIdInt = rs.getInt("a_role_id");
                Integer roleId = rs.wasNull() ? null : Integer.valueOf(roleIdInt);
                user.setRoleId(roleId);
            }
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        }
        return user;
    }
}
