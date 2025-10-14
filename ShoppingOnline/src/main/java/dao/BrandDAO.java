package dao;

import java.sql.*;
import java.util.*;
import connect.DBConnection;
import model.Brand;

public class BrandDAO {

    public List<Brand> getAllBrands() throws SQLException {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT * FROM Brand ORDER BY BrandName ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getLong("BrandId"));
                b.setBrandName(rs.getString("BrandName"));
                b.setDescription(rs.getString("Description"));
                b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                b.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                b.setStatus(rs.getInt("Status"));
                list.add(b);
            }
        }
        return list;
    }
}
