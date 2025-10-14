package dao;

import java.sql.*;
import java.util.*;
import model.Product;
import connect.DBConnection;

public class ProductDAO {

    // ✅ Hàm thêm sản phẩm
    public void addProduct(Product p) throws SQLException {
        // ... (phần bạn đã có)
    }

    // ✅ Hàm lấy toàn bộ danh sách sản phẩm (JOIN với Category & Brand)
    public List<Product> getAllProducts() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT 
                p.ProductId, p.ProductCode, p.ProductName, 
                p.Description, p.PriceImport, p.Price, p.Quantity, 
                p.Status, p.CreatedAt, p.UpdatedAt,
                c.CategoryName, b.BrandName
            FROM Product p
            LEFT JOIN Category c ON p.CategoryId = c.CategoryId
            LEFT JOIN Brand b ON p.BrandId = b.BrandId
            ORDER BY p.ProductId DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getLong("ProductId"));
                p.setProductCode(rs.getString("ProductCode"));
                p.setProductName(rs.getString("ProductName"));
                p.setDescription(rs.getString("Description"));
                p.setPriceImport(rs.getBigDecimal("PriceImport"));
                p.setPrice(rs.getBigDecimal("Price"));
                p.setQuantity(rs.getInt("Quantity"));
                p.setStatus(rs.getInt("Status"));
                p.setCreatedAt(rs.getTimestamp("CreatedAt"));
                p.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                // Thêm tên danh mục và thương hiệu (để hiển thị JSP)
                p.setCategoryName(rs.getString("CategoryName"));
                p.setBrandName(rs.getString("BrandName"));

                list.add(p);
            }
        }

        return list;
    }
}


