package dao;

import connect.DBConnection;
import java.sql.*;
import java.util.*;

public class AdminDashboardDAO {

    // ====== Tổng số khách hàng ======
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM User";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy tổng khách hàng: " + e.getMessage());
        }
        return 0;
    }

    // ====== Tổng số sản phẩm ======
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM Product";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy tổng sản phẩm: " + e.getMessage());
        }
        return 0;
    }

    // ====== Tổng số đơn hàng ======
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy tổng đơn hàng: " + e.getMessage());
        }
        return 0;
    }

    // ====== Số đơn đang xử lý ======
    public int getPendingOrders() {
        String sql = "SELECT COUNT(*) FROM Orders WHERE Status = 'Pending' OR Status = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi đếm đơn đang xử lý: " + e.getMessage());
        }
        return 0;
    }

    // ====== Doanh thu hôm nay ======
    public double getRevenueToday() {
        String sql = """
            SELECT COALESCE(SUM(TotalAmount), 0)
            FROM Orders
            WHERE DATE(OrderDate) = CURDATE()
            AND (Status = 'Completed' OR Status = 1 OR Status = 2)
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy doanh thu hôm nay: " + e.getMessage());
        }
        return 0.0;
    }

    // ====== Doanh thu tháng hiện tại ======
    public double getRevenueThisMonth() {
        String sql = """
            SELECT COALESCE(SUM(TotalAmount), 0)
            FROM Orders
            WHERE MONTH(OrderDate) = MONTH(CURDATE())
              AND YEAR(OrderDate) = YEAR(CURDATE())
              AND (Status = 'Completed' OR Status = 1 OR Status = 2)
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy doanh thu tháng này: " + e.getMessage());
        }
        return 0.0;
    }

    // ====== 5 đơn hàng gần nhất ======
    public List<Map<String, Object>> getRecentOrders() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT o.Id, u.FullName, o.TotalAmount, o.Status, o.OrderDate
            FROM Orders o
            JOIN User u ON o.UserId = u.Id
            ORDER BY o.OrderDate DESC
            LIMIT 5
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("id", rs.getLong("Id"));
                order.put("customerName", rs.getString("FullName"));
                order.put("total", rs.getDouble("TotalAmount"));

                // Map status
                String status;
                String dbStatus = rs.getString("Status");
                if (dbStatus.equalsIgnoreCase("Completed") || dbStatus.equals("1")) {
                    status = "Completed";
                } else if (dbStatus.equalsIgnoreCase("Pending") || dbStatus.equals("0")) {
                    status = "Pending";
                } else {
                    status = "Cancelled";
                }

                order.put("status", status);
                order.put("date", rs.getTimestamp("OrderDate"));
                list.add(order);
            }
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy đơn hàng mới nhất: " + e.getMessage());
        }
        return list;
    }

    // ====== 5 người dùng mới nhất ======
    public List<Map<String, Object>> getRecentUsers() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT FullName, Email, CreatedAt, Nationality
            FROM User
            ORDER BY UserID DESC
            LIMIT 5
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("fullName", rs.getString("FullName"));
                user.put("email", rs.getString("Email"));
                user.put("createdAt", rs.getTimestamp("CreatedAt"));
                user.put("role", rs.getString("Nationality"));
                list.add(user);
            }
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy người dùng mới nhất: " + e.getMessage());
        }
        return list;
    }

    // ====== Top 5 sản phẩm bán chạy ======
    public List<Map<String, Object>> getTopProducts() {
    List<Map<String, Object>> list = new ArrayList<>();
    String sql = """
        SELECT 
            p.ProductId,
            p.ProductName,
            p.ProductCode,
            c.CategoryName,
            SUM(od.Quantity) AS TotalSold,
            SUM(od.Quantity * od.Price) AS TotalRevenue
        FROM OrderDetail od
        JOIN Orders o ON od.OrderId = o.Id
        JOIN Product p ON od.ProductId = p.ProductId
        JOIN Category c ON p.CategoryId = c.CategoryId
        WHERE o.Status = 3  -- chỉ tính đơn hàng đã hoàn tất
        GROUP BY p.ProductId, p.ProductName, p.ProductCode, c.CategoryName
        ORDER BY TotalSold DESC
        LIMIT 5
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> prod = new HashMap<>();
            prod.put("name", rs.getString("ProductName"));
            prod.put("category", rs.getString("CategoryName"));
            prod.put("sold", rs.getInt("TotalSold"));
            prod.put("revenue", rs.getDouble("TotalRevenue"));
            list.add(prod);
        }
    } catch (SQLException e) {
        System.err.println("[AdminDashboardDAO] Lỗi khi lấy sản phẩm bán chạy: " + e.getMessage());
    }
    return list;
    }

    // ====== Dữ liệu biểu đồ doanh thu 7 ngày gần nhất ======
    public List<String> getRevenueChartLabels() {
        List<String> labels = new ArrayList<>();
        String sql = """
            SELECT DATE_FORMAT(OrderDate, '%d/%m') AS DayLabel
            FROM Orders
            WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            GROUP BY DATE(OrderDate)
            ORDER BY DATE(OrderDate)
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) labels.add(rs.getString("DayLabel"));
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy nhãn biểu đồ: " + e.getMessage());
        }
        return labels;
    }

    public List<Double> getRevenueChartValues() {
        List<Double> values = new ArrayList<>();
        String sql = """
            SELECT COALESCE(SUM(TotalAmount), 0) AS Revenue
            FROM Orders
            WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            GROUP BY DATE(OrderDate)
            ORDER BY DATE(OrderDate)
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) values.add(rs.getDouble("Revenue"));
        } catch (SQLException e) {
            System.err.println("[AdminDashboardDAO] Lỗi khi lấy giá trị biểu đồ: " + e.getMessage());
        }
        return values;
    }
}


