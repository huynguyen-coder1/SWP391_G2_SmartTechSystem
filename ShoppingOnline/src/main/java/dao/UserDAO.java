package dao;

import connect.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLIntegrityConstraintViolationException;
import model.User;

public class UserDAO {

    // Đếm tổng số User
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM `User`";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy danh sách user mới đăng ký gần đây (limit)
    public List<User> getRecentRegisteredUsers(int limit) {
        List<User> users = new ArrayList<>();
        // MySQL dùng LIMIT thay vì TOP
        String sql = "SELECT * FROM `User` ORDER BY CreatedAt DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // Thêm user mới
    public boolean insertUser(User user) {
        // MySQL: NOW() thay cho GETDATE()
        String sql = "INSERT INTO `User` (Email, FullName, Phone, PasswordHash, DateOfBirth, IsActive, CreatedAt, UpdatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // Lấy tất cả user
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM `User`";

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
}
