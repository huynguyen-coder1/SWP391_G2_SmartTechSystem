package dao;

import java.sql.*;
import java.util.*;
import model.Product;
import java.io.File;
import jakarta.servlet.ServletContext;
import connect.DBConnection;

public class ProductDAO {

    // ✅ Thêm sản phẩm mới
    public boolean addProduct(Product p) throws SQLException {
        String sql = """
            INSERT INTO Product
            (ProductCode, ProductName, Description, PriceImport, Price, Quantity, CategoryId, BrandId, Status, Images)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            // ✅ dùng mã do người dùng nhập, không tự sinh nữa
            ps.setString(1, p.getProductCode());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPriceImport());
            ps.setBigDecimal(5, p.getPrice());
            ps.setInt(6, p.getQuantity());
            ps.setLong(7, p.getCategoryId());
            ps.setLong(8, p.getBrandId());
            ps.setInt(9, p.getStatus());
            ps.setString(10, p.getImages());

            return ps.executeUpdate() > 0;
        }
    }

    // ✅ Lấy toàn bộ sản phẩm
    public List<Product> getAllProducts() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT 
                p.ProductId, p.ProductCode, p.ProductName, 
                p.Description, p.PriceImport, p.Price, p.Quantity, 
                p.Status, p.CreatedAt, p.UpdatedAt, p.Images,
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
                p.setImages(rs.getString("Images"));

                p.setCategoryName(rs.getString("CategoryName"));
                p.setBrandName(rs.getString("BrandName"));

                list.add(p);
            }
        }
        return list;
    }

    // ✅ Tìm kiếm + lọc sản phẩm
    public List<Product> searchProducts(String keyword, String categoryId, String status) throws SQLException {
        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT 
                p.ProductId, p.ProductCode, p.ProductName, 
                p.Description, p.PriceImport, p.Price, p.Quantity, 
                p.Status, p.CreatedAt, p.UpdatedAt, p.Images,
                c.CategoryName, b.BrandName
            FROM Product p
            LEFT JOIN Category c ON p.CategoryId = c.CategoryId
            LEFT JOIN Brand b ON p.BrandId = b.BrandId
            WHERE 1 = 1
        """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.ProductName LIKE ?");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append(" AND p.CategoryId = ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND p.Status = ?");
        }

        sql.append(" ORDER BY p.ProductId DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword.trim() + "%");
            }
            if (categoryId != null && !categoryId.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(categoryId));
            }
            if (status != null && !status.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(status));
            }

            try (ResultSet rs = ps.executeQuery()) {
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
                    p.setImages(rs.getString("Images"));

                    p.setCategoryName(rs.getString("CategoryName"));
                    p.setBrandName(rs.getString("BrandName"));
                    list.add(p);
                }
            }
        }

        return list;
    }

    // ✅ Xóa sản phẩm
    public boolean deleteProduct(long productId) throws SQLException {
        String sql = "DELETE FROM Product WHERE ProductId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            return ps.executeUpdate() > 0;
        }
    }

    // ✅ Cập nhật sản phẩm
    public boolean updateProduct(Product p) throws SQLException {
        String sql = """
            UPDATE Product
            SET ProductName = ?, Description = ?, PriceImport = ?, Price = ?, Quantity = ?,
                CategoryId = ?, BrandId = ?, Status = ?, Images = ?, UpdatedAt = CURRENT_TIMESTAMP
            WHERE ProductId = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getProductName());
            ps.setString(2, p.getDescription());
            ps.setBigDecimal(3, p.getPriceImport());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getQuantity());
            ps.setLong(6, p.getCategoryId());
            ps.setLong(7, p.getBrandId());
            ps.setInt(8, p.getStatus());
            ps.setString(9, p.getImages()); // ✅ thêm images
            ps.setLong(10, p.getProductId());

            return ps.executeUpdate() > 0;
        }
    }

    // ✅ Lấy sản phẩm theo ID
    public Product getProductById(long productId) throws SQLException {
        String sql = """
            SELECT p.ProductId, p.ProductCode, p.ProductName, 

                   p.Description, p.PriceImport, p.Price, p.Quantity, 
                   p.Status, p.CreatedAt, p.UpdatedAt, p.Images,
                   c.CategoryName, b.BrandName, p.CategoryId, p.BrandId
            FROM Product p
            LEFT JOIN Category c ON p.CategoryId = c.CategoryId
            LEFT JOIN Brand b ON p.BrandId = b.BrandId
            WHERE p.ProductId = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getLong("ProductId"));
                    p.setProductCode(rs.getString("ProductCode"));
                    p.setProductName(rs.getString("ProductName"));
                    p.setDescription(rs.getString("Description"));
                    p.setPriceImport(rs.getBigDecimal("PriceImport"));
                    p.setPrice(rs.getBigDecimal("Price"));
                    p.setQuantity(rs.getInt("Quantity"));
                    p.setStatus(rs.getInt("Status"));
                    p.setCategoryId(rs.getLong("CategoryId"));
                    p.setBrandId(rs.getLong("BrandId"));
                    p.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    p.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    p.setImages(rs.getString("Images"));
                    p.setCategoryName(rs.getString("CategoryName"));
                    p.setBrandName(rs.getString("BrandName"));
                    p.setImages(rs.getString("Images"));
                    return p;
                }
            }
        }
        return null;
    }
    public void restoreProductQuantity(long orderId) {
    String sql = """
        UPDATE Product p
        JOIN OrderDetail od ON p.ProductId = od.ProductId
        SET p.Quantity = p.Quantity + od.Quantity
        WHERE od.OrderId = ?
    """;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setLong(1, orderId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
    }
    // ✅ Lấy danh sách tên ảnh trong thư mục images
    public List<String> getAllImageNames(ServletContext context) {
    List<String> imageNames = new ArrayList<>();
    try {
        // 🔥 Lấy đúng đường dẫn tuyệt đối đến thư mục /images trong webapp
        String imagePath = context.getRealPath("/images");

        File folder = new File(imagePath);
        if (folder.exists() && folder.isDirectory()) {
            for (File f : folder.listFiles()) {
                if (f.isFile()) {
                    String name = f.getName().toLowerCase();
                    if (name.endsWith(".jpg") || name.endsWith(".jpeg") || 
                        name.endsWith(".png") || name.endsWith(".gif")) {
                        imageNames.add(f.getName());
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return imageNames;
    }
    // ✅ Hàm mới - search & filter đầy đủ
    public List<Product> filterProducts(String keyword, String categoryId, String brandId, String status) throws SQLException {
    List<Product> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder("""
        SELECT 
            p.ProductId, p.ProductCode, p.ProductName, 
            p.Description, p.PriceImport, p.Price, p.Quantity, 
            p.Status, p.CreatedAt, p.UpdatedAt, p.Images,
            c.CategoryName, b.BrandName
        FROM Product p
        LEFT JOIN Category c ON p.CategoryId = c.CategoryId
        LEFT JOIN Brand b ON p.BrandId = b.BrandId
        WHERE 1 = 1
    """);

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND p.ProductName LIKE ?");
    }
    if (categoryId != null && !categoryId.isEmpty()) {
        sql.append(" AND p.CategoryId = ?");
    }
    if (brandId != null && !brandId.isEmpty()) {
        sql.append(" AND p.BrandId = ?");
    }
    if (status != null && !status.isEmpty()) {
        sql.append(" AND p.Status = ?");
    }

    sql.append(" ORDER BY p.ProductId DESC");

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        int index = 1;
        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(index++, "%" + keyword.trim() + "%");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            ps.setInt(index++, Integer.parseInt(categoryId));
        }
        if (brandId != null && !brandId.isEmpty()) {
            ps.setInt(index++, Integer.parseInt(brandId));
        }
        if (status != null && !status.isEmpty()) {
            ps.setInt(index++, Integer.parseInt(status));
        }

        try (ResultSet rs = ps.executeQuery()) {
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
                p.setImages(rs.getString("Images"));
                p.setCategoryName(rs.getString("CategoryName"));
                p.setBrandName(rs.getString("BrandName"));
                list.add(p);
            }
        }
    }

    return list;
    }
    // ✅ Tìm kiếm sản phẩm theo keyword (dành cho SearchServlet)
    public List<Product> searchProducts(String keyword) throws SQLException {
    List<Product> list = new ArrayList<>();

    String sql = """
        SELECT 
            p.ProductId, p.ProductCode, p.ProductName, 
            p.Description, p.PriceImport, p.Price, p.Quantity, 
            p.Status, p.CreatedAt, p.UpdatedAt, p.Images,
            c.CategoryName, b.BrandName
        FROM Product p
        LEFT JOIN Category c ON p.CategoryId = c.CategoryId
        LEFT JOIN Brand b ON p.BrandId = b.BrandId
        WHERE p.ProductName LIKE ?
        ORDER BY p.ProductId DESC
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, "%" + keyword.trim() + "%");

        try (ResultSet rs = ps.executeQuery()) {
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
                p.setImages(rs.getString("Images"));
                p.setCategoryName(rs.getString("CategoryName"));
                p.setBrandName(rs.getString("BrandName"));
                list.add(p);
            }
        }
    }

    return list;
    }
    public List<Product> getLatestProducts(int limit) throws SQLException {
    List<Product> list = new ArrayList<>();
    String sql = """
        SELECT 
            p.ProductId, p.ProductCode, p.ProductName, 
            p.Description, p.PriceImport, p.Price, p.Quantity, 
            p.Status, p.CreatedAt, p.UpdatedAt, p.Images,
            c.CategoryName, b.BrandName
        FROM Product p
        LEFT JOIN Category c ON p.CategoryId = c.CategoryId
        LEFT JOIN Brand b ON p.BrandId = b.BrandId
        WHERE p.Status = 1
        ORDER BY p.CreatedAt DESC
        LIMIT ?
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, limit);
        try (ResultSet rs = ps.executeQuery()) {
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
                p.setImages(rs.getString("Images"));
                p.setCategoryName(rs.getString("CategoryName"));
                p.setBrandName(rs.getString("BrandName"));
                list.add(p);
            }
        }
    }
    return list;
    }
    public List<Product> getTopSellingProducts(int limit) throws SQLException {
    List<Product> list = new ArrayList<>();
    String sql = """
        SELECT 
            p.ProductId, p.ProductCode, p.ProductName,
            p.Description, p.PriceImport, p.Price, p.Quantity,
            p.Status, p.CreatedAt, p.UpdatedAt, p.Images,
            c.CategoryName, b.BrandName,
            SUM(od.Quantity) AS TotalSold
        FROM OrderDetail od
        JOIN Product p ON od.ProductId = p.ProductId
        LEFT JOIN Category c ON p.CategoryId = c.CategoryId
        LEFT JOIN Brand b ON p.BrandId = b.BrandId
        GROUP BY p.ProductId
        ORDER BY TotalSold DESC
        LIMIT ?
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, limit);
        try (ResultSet rs = ps.executeQuery()) {
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
                p.setImages(rs.getString("Images"));
                p.setCategoryName(rs.getString("CategoryName"));
                p.setBrandName(rs.getString("BrandName"));
                list.add(p);
            }
        }
    }
    return list;
    }
}

    


