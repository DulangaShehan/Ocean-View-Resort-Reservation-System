package Models;

public class User {
    private int adminId;
    private String username;
    private String password;
    private Integer roleId;

    public User() {}

    public User(int adminId, String username, String password, Integer roleId) {
        this.adminId = adminId;
        this.username = username;
        this.password = password;
        this.roleId = roleId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }
}
