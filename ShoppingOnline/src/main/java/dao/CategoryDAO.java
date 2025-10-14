package dao;

import connect.DBConnection;
import model.Category;
import java.sql.*;
import java.util.*;

public class CategoryDAO {
private Connection conn;

    public CategoryDAO() {
        conn = DBConnection.getConnection(); // ✅ Gọi hàm lấy connection
    }
    
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getLong("CategoryId"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setDescription(rs.getString("Description"));
                c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                c.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                c.setStatus(rs.getInt("Status"));
                list.add(c);
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Category> filterCategories(String search, String status) {
        List<Category> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Category WHERE 1=1");

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND CategoryName LIKE ?");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
        }

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setInt(index++, Integer.parseInt(status));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getLong("CategoryId"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setDescription(rs.getString("Description"));
                c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                c.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                c.setStatus(rs.getInt("Status"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean addCategory(Category category) {
    String sql = "INSERT INTO Category (CategoryName, Description, Status, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, category.getCategoryName());
        ps.setString(2, category.getDescription());
        ps.setInt(3, category.getStatus());
        ps.setTimestamp(4, category.getCreatedAt());
        ps.setTimestamp(5, category.getUpdatedAt());
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
 public Category getCategoryById(long id) {
    String sql = "SELECT * FROM Category WHERE CategoryId = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setLong(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Category c = new Category();
            c.setCategoryId(rs.getLong("CategoryId"));
            c.setCategoryName(rs.getString("CategoryName"));
            c.setDescription(rs.getString("Description"));
            c.setStatus(rs.getInt("Status"));
            c.setCreatedAt(rs.getTimestamp("CreatedAt"));
            c.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
            return c;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}


    // 🔹 Cập nhật category
   public boolean updateCategory(Category category) {
    String sql = "UPDATE Category SET CategoryName=?, Description=?, Status=?, UpdatedAt=? WHERE CategoryId=?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, category.getCategoryName());
        ps.setString(2, category.getDescription());
        ps.setInt(3, category.getStatus());
        ps.setTimestamp(4, category.getUpdatedAt());
        ps.setLong(5, category.getCategoryId());

        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

    public boolean deleteCategory(long categoryId) {
    String sql = "DELETE FROM Category WHERE CategoryID = ?";
    try {
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setLong(1, categoryId);
        int rows = ps.executeUpdate();
        return rows > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}



}