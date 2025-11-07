package dao;

import connect.DBConnection;
import java.sql.*;
import java.util.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class RevenueDAO {

    // ✅ Lấy doanh thu 7 ngày gần nhất (tính theo ngày có đơn hàng đã giao)
    public Map<String, Double> getRevenueLast7Days() {
        Map<String, Double> revenueMap = new LinkedHashMap<>();
        String sql = """
            SELECT DATE(OrderDate) AS order_date, SUM(TotalAmount) AS revenue
            FROM Orders
            WHERE Status = 3
              AND OrderDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            GROUP BY DATE(OrderDate)
            ORDER BY order_date ASC;
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // Lấy danh sách 7 ngày gần nhất (để đảm bảo đủ ngày kể cả khi không có đơn)
            LocalDate today = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM");
            for (int i = 6; i >= 0; i--) {
                LocalDate day = today.minusDays(i);
                revenueMap.put(day.format(formatter), 0.0);
            }

            // Cập nhật giá trị doanh thu từ DB
            while (rs.next()) {
                LocalDate orderDate = rs.getDate("order_date").toLocalDate();
                double revenue = rs.getDouble("revenue");
                String key = orderDate.format(formatter);
                if (revenueMap.containsKey(key)) {
                    revenueMap.put(key, revenue);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenueMap;
    }

    // ✅ Lấy doanh thu theo từng tháng trong năm hiện tại
    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> revenueMap = new LinkedHashMap<>();
        String sql = """
            SELECT MONTH(OrderDate) AS month, SUM(TotalAmount) AS revenue
            FROM Orders
            WHERE Status = 3 AND YEAR(OrderDate) = YEAR(CURDATE())
            GROUP BY MONTH(OrderDate)
            ORDER BY month;
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // Khởi tạo 12 tháng mặc định = 0
            for (int i = 1; i <= 12; i++) {
                revenueMap.put(String.format("Tháng %02d", i), 0.0);
            }

            // Cập nhật từ DB
            while (rs.next()) {
                int month = rs.getInt("month");
                double revenue = rs.getDouble("revenue");
                revenueMap.put(String.format("Tháng %02d", month), revenue);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenueMap;
    }
}
