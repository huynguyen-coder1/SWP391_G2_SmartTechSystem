package dao;

import java.sql.*;
import java.util.*;
import connect.DBConnection;
import model.Category;

public class CategoryDAO {

    public List<Category> getAllCategories() throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category ORDER BY CategoryName ASC";

        try (Connection conn = DBConnection.getConnection();
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
        }
        return list;
    }
}
