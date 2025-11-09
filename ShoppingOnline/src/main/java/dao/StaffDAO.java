package dao;

import connect.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Role;
import model.User;

/**
 *
 * @author Admin
 */
public class StaffDAO {
    // ✅ Lấy danh sách chỉ gồm nhân viên (STAFF)
    public List<User> getAllStaff() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT 
                u.UserID, u.Email, u.FullName, u.Phone, 
                u.Address, u.IsActive, u.CreatedAt,
                r.RoleID, r.RoleName
            FROM `User` u
            JOIN `UserRole` ur ON u.UserID = ur.UserID
            JOIN `Role` r ON ur.RoleID = r.RoleID
            WHERE UPPER(r.RoleName) IN  ('STAFF')
            ORDER BY u.CreatedAt DESC
        """;

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setAddress(rs.getString("Address"));
                u.setActive(rs.getBoolean("IsActive"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));

                // Gán role cho user
                Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                List<Role> roles = new ArrayList<>();
                roles.add(role);
                u.setRoles(roles);

                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

     // ✅ Tìm kiếm + lọc theo trạng thái
    public List<User> searchAndFilterStaff(String keyword, String statusFilter) {
        List<User> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT 
                u.UserID, u.Email, u.FullName, u.Phone, 
                u.Address, u.IsActive, u.CreatedAt,
                r.RoleID, r.RoleName
            FROM `User` u
            JOIN `UserRole` ur ON u.UserID = ur.UserID
            JOIN `Role` r ON ur.RoleID = r.RoleID
            WHERE UPPER(r.RoleName) = 'STAFF'
        """);

        // Thêm điều kiện nếu có keyword
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.FullName LIKE ? OR u.Email LIKE ?)");
        }

        // Thêm điều kiện nếu có lọc trạng thái
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND u.IsActive = ?");
        }

        sql.append(" ORDER BY u.CreatedAt DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
                ps.setString(paramIndex++, "%" + keyword + "%");
            }

            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setBoolean(paramIndex++, statusFilter.equalsIgnoreCase("active"));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setAddress(rs.getString("Address"));
                u.setActive(rs.getBoolean("IsActive"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));

                Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                List<Role> roles = new ArrayList<>();
                roles.add(role);
                u.setRoles(roles);

                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // ✅ Lấy danh sách user theo role cụ thể
    public List<User> getUsersByRole(String roleName) {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.UserID, u.Email, u.FullName, u.Phone, u.IsActive,
                   r.RoleID, r.RoleName
            FROM `User` u
            JOIN `UserRole` ur ON u.UserID = ur.UserID
            JOIN `Role` r ON ur.RoleID = r.RoleID
            WHERE r.RoleName = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roleName);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setActive(rs.getBoolean("IsActive"));

                Role r = new Role(rs.getInt("RoleID"), rs.getString("RoleName"));
                List<Role> roles = new ArrayList<>();
                roles.add(r);
                u.setRoles(roles);

                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Cập nhật Role cho user
    public boolean updateUserRole(int userId, int newRoleId) {
        String sql = "UPDATE `UserRole` SET RoleID = ? WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newRoleId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
