package dao;

import connect.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Role;

public class RoleDAO {

    /**
     * ✅ Lấy toàn bộ danh sách vai trò
     */
    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT RoleID, RoleName FROM Role";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));
                roles.add(role);
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy danh sách vai trò: " + e.getMessage());
        }

        return roles;
    }

    /**
     * ✅ Lấy thông tin vai trò theo ID
     */
    public Role getRoleById(int roleId) {
        Role role = null;
        String sql = "SELECT RoleID, RoleName FROM Role WHERE RoleID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    role = new Role();
                    role.setRoleID(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy vai trò theo ID: " + e.getMessage());
        }

        return role;
    }

    /**
     * ✅ Lấy vai trò theo tên (dự phòng dùng sau)
     */
    public Role getRoleByName(String roleName) {
        Role role = null;
        String sql = "SELECT RoleID, RoleName FROM Role WHERE RoleName = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roleName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    role = new Role();
                    role.setRoleID(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy vai trò theo tên: " + e.getMessage());
        }

        return role;
    }
}
