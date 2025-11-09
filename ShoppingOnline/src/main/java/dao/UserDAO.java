package dao;

import connect.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import java.sql.SQLIntegrityConstraintViolationException;
import model.User;
import model.Role;

public class UserDAO {

    // ✅ Đếm tổng số User
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM `User`";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Lấy danh sách user mới đăng ký gần đây (limit)
    public List<User> getRecentRegisteredUsers(int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM `User` ORDER BY CreatedAt DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setFullName(rs.getString("FullName"));
                u.setEmail(rs.getString("Email"));
                u.setPhone(rs.getString("Phone"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                users.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }

    // ✅ Thêm user mới
    public boolean insertUser(User user) {
        String sql = """
            INSERT INTO `User` (Email, FullName, Phone, PasswordHash, DateOfBirth, IsActive, CreatedAt, UpdatedAt)
            VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPasswordHash());

            if (user.getDateOfBirth() != null) {
                ps.setDate(5, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }

            ps.setBoolean(6, user.isActive());
            return ps.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("❌ Email đã tồn tại trong hệ thống.");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Lấy tất cả user
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM `User`";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setActive(rs.getBoolean("IsActive"));
                u.setPasswordHash(rs.getString("PasswordHash"));
                u.setDateOfBirth(rs.getDate("DateOfBirth"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lọc User (tìm kiếm + trạng thái)
    public List<User> filterUsers(String search, String status) {
        List<User> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT u.* FROM `User` u "
                + "JOIN `UserRole` ur ON u.UserID = ur.UserID "
                + "JOIN `Role` r ON ur.RoleID = r.RoleID "
                + "WHERE r.RoleName = 'User'"
        );
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (u.Email LIKE ? OR u.FullName LIKE ?)");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND u.IsActive = ?");
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search + "%");
                ps.setString(i++, "%" + search + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setInt(i++, Integer.parseInt(status));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setEmail(rs.getString("Email"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setAddress(rs.getString("Address"));
                u.setDateOfBirth(rs.getDate("DateOfBirth"));
                u.setActive(rs.getBoolean("IsActive"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Cập nhật trạng thái hoạt động của user (khoá / mở khoá)
    public boolean updateUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE `User` SET IsActive = ?, UpdatedAt = NOW() WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public User getUserById(int userId) {
        String sql = """
            SELECT u.*, r.RoleID, r.RoleName
            FROM `User` u
            LEFT JOIN `UserRole` ur ON u.UserID = ur.UserID
            LEFT JOIN `Role` r ON ur.RoleID = r.RoleID
            WHERE u.UserID = ?
        """;
        User user = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                if (user == null) {
                    user = new User();
                    user.setUserID(rs.getInt("UserID"));
                    user.setEmail(rs.getString("Email"));
                    user.setFullName(rs.getString("FullName"));
                    user.setPhone(rs.getString("Phone"));
                    user.setAddress(rs.getString("Address"));
                    user.setDateOfBirth(rs.getDate("DateOfBirth"));
                    user.setActive(rs.getBoolean("IsActive"));
                    user.setAvatarUrl(rs.getString("AvatarUrl"));
                    user.setGoogleID(rs.getString("GoogleID"));
                    user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                }

                // Thêm Role vào danh sách roles
                int roleId = rs.getInt("RoleID");
                String roleName = rs.getString("RoleName");

                if (roleName != null) {
                    Role role = new Role();
                    role.setRoleID(roleId);
                    role.setRoleName(roleName);
                    user.getRoles().add(role);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    // ✅ Cập nhật thông tin cá nhân (FullName, Phone, Address, DateOfBirth, Avatar)
    public void updateUserProfile(User user) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, address = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setInt(4, user.getUserID());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public boolean updateAdminProfile(User user) {
        String sql = """
            UPDATE `User`
            SET FullName = ?, Phone = ?, Address = ?, DateOfBirth = ?, AvatarUrl = ?, UpdatedAt = NOW()
            WHERE UserID = ?
        """;

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());

            if (user.getDateOfBirth() != null) {
                ps.setDate(4, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }

            ps.setString(5, user.getAvatarUrl());
            ps.setInt(6, user.getUserID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean deleteUserById(int id) {
        String sql = "DELETE FROM `User` WHERE UserID = ?";
        try (Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean updateUserRole(int userId, int roleId) {
    String deleteOld = "DELETE FROM `UserRole` WHERE UserID = ?";
    String insertNew = "INSERT INTO `UserRole` (UserID, RoleID) VALUES (?, ?)";

    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false);

        // Xóa role cũ
        try (PreparedStatement ps1 = conn.prepareStatement(deleteOld)) {
            ps1.setInt(1, userId);
            ps1.executeUpdate();
        }

        // Thêm role mới
        try (PreparedStatement ps2 = conn.prepareStatement(insertNew)) {
            ps2.setInt(1, userId);
            ps2.setInt(2, roleId);
            ps2.executeUpdate();
        }

        conn.commit();
        return true;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
    }
}
