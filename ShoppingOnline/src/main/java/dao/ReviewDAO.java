package dao;

import model.Review;
import connect.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý dữ liệu Review
 */
public class ReviewDAO {

    /**
     * Lấy tất cả feedback, join với User và Product
     */
    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.Id, r.UserId, u.FullName AS UserName, r.ProductId, p.ProductName, " +
                     "r.Rating, r.Comment, r.CreatedAt, r.Status " +
                     "FROM Review r " +
                     "JOIN User u ON r.UserId = u.UserID " +
                     "JOIN Product p ON r.ProductId = p.ProductId " +
                     "ORDER BY r.CreatedAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Review r = new Review();
                r.setId(rs.getLong("Id"));
                r.setUserId(rs.getInt("UserId"));
                r.setUserName(rs.getString("UserName"));
                r.setProductId(rs.getLong("ProductId"));
                r.setProductName(rs.getString("ProductName"));
                r.setRating(rs.getInt("Rating"));
                r.setComment(rs.getString("Comment"));
                r.setCreatedAt(rs.getTimestamp("CreatedAt"));
                r.setStatus(rs.getInt("Status"));
                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Ẩn hoặc hiển thị feedback
     * @param id reviewId
     * @param status 0 = ẩn, 1 = hiển thị
     */
    public boolean updateStatus(long id, int status) {
        String sql = "UPDATE Review SET Status = ? WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setLong(2, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}




