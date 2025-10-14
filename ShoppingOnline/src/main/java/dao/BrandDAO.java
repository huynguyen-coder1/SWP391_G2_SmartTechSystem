package dao;

import connect.DBConnection;
import model.Brand;
import java.sql.*;
import java.util.*;

public class BrandDAO {
    private Connection conn;

    public BrandDAO() {
        conn = DBConnection.getConnection(); // ✅ Gọi hàm lấy connection
    }

    // Lấy tất cả brand
    public List<Brand> getAllBrands() {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT * FROM Brand";
        try (Connection conn = new DBConnection().getConnection();
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

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lọc theo tên và trạng thái
    public List<Brand> filterBrands(String search, String status) {
        List<Brand> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Brand WHERE 1=1");

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND BrandName LIKE ?");
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
                Brand b = new Brand();
                b.setBrandId(rs.getLong("BrandId"));
                b.setBrandName(rs.getString("BrandName"));
                b.setDescription(rs.getString("Description"));
                b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                b.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                b.setStatus(rs.getInt("Status"));
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm brand
    public boolean addBrand(Brand brand) {
        String sql = "INSERT INTO Brand (BrandName, Description, Status, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, brand.getBrandName());
            ps.setString(2, brand.getDescription());
            ps.setInt(3, brand.getStatus());
            ps.setTimestamp(4, brand.getCreatedAt());
            ps.setTimestamp(5, brand.getUpdatedAt());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy brand theo ID
    public Brand getBrandById(long id) {
        String sql = "SELECT * FROM Brand WHERE BrandId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getLong("BrandId"));
                b.setBrandName(rs.getString("BrandName"));
                b.setDescription(rs.getString("Description"));
                b.setStatus(rs.getInt("Status"));
                b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                b.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                return b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật brand
    public boolean updateBrand(Brand brand) {
        String sql = "UPDATE Brand SET BrandName=?, Description=?, Status=?, UpdatedAt=? WHERE BrandId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, brand.getBrandName());
            ps.setString(2, brand.getDescription());
            ps.setInt(3, brand.getStatus());
            ps.setTimestamp(4, brand.getUpdatedAt());
            ps.setLong(5, brand.getBrandId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa brand
    public boolean deleteBrand(long brandId) {
        String sql = "DELETE FROM Brand WHERE BrandId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, brandId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
