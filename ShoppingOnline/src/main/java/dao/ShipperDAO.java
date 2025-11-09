package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;
import model.Role;
import connect.DBConnection;

public class ShipperDAO {

    // ✅ Lấy danh sách tất cả shipper (kèm role)
    public List<User> getAllShippers() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.*, r.RoleID, r.RoleName
            FROM User u
            JOIN UserRole ur ON u.UserID = ur.UserID
            JOIN Role r ON ur.RoleID = r.RoleID
            WHERE r.RoleName IN ('Shipper', 'Staff', 'User')
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
                u.setActive(rs.getBoolean("IsActive"));
                u.setAddress(rs.getString("Address"));
                u.setAvatarUrl(rs.getString("AvatarUrl"));

                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));

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

    // ✅ Cập nhật trạng thái hoạt động
    public void updateShipperStatus(int userId, boolean isActive) {
        String sql = "UPDATE User SET IsActive = ? WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Xóa shipper (bao gồm bản ghi trong bảng UserRole)
    public void deleteShipper(int userId) {
        String sqlRole = """
            DELETE FROM UserRole 
            WHERE UserID = ? 
              AND RoleID IN (SELECT RoleID FROM Role WHERE RoleName IN ('User','Staff','Shipper'))
        """;
        String sqlUser = "DELETE FROM User WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlRole);
                 PreparedStatement ps2 = conn.prepareStatement(sqlUser)) {
                ps1.setInt(1, userId);
                ps1.executeUpdate();

                ps2.setInt(1, userId);
                ps2.executeUpdate();

                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật vai trò (chỉ giữa Staff, Shipper, User)
    public void updateShipperRole(int userId, int roleId) {
        String sql = """
            UPDATE UserRole
            SET RoleID = ?
            WHERE UserID = ?
              AND RoleID IN (SELECT RoleID FROM Role WHERE RoleName IN ('User','Staff','Shipper'))
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Tìm kiếm shipper theo tên hoặc email + trạng thái
    public List<User> searchShipper(String keyword, String status) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT u.*, r.RoleID, r.RoleName
            FROM User u
            JOIN UserRole ur ON u.UserID = ur.UserID
            JOIN Role r ON ur.RoleID = r.RoleID
            WHERE r.RoleName = 'Shipper'
        """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.FullName LIKE ? OR u.Email LIKE ?)");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND u.IsActive = ?");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (status != null && !status.isEmpty()) {
                boolean active = "1".equals(status);
                ps.setBoolean(index++, active);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setActive(rs.getBoolean("IsActive"));
                u.setAddress(rs.getString("Address"));
                u.setAvatarUrl(rs.getString("AvatarUrl"));

                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));

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
}