package dao;

import connect.DBConnection;
import model.ShippingHistory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShippingHistoryDAO {

    /**
     * 🔹 Lấy lịch sử giao hàng, có thể lọc theo tên khách hàng và trạng thái giao hàng
     */
    public List<ShippingHistory> getShippingHistory(String search, String status) {
        List<ShippingHistory> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT 
                sh.Id AS ShippingHistoryId,
                sh.OrderId,
                sh.ShipperId,
                sh.Status AS ShippingStatus,
                sh.UpdateTime,
                s.ShipperName,
                u.FullName AS CustomerName,
                o.Status AS OrderStatus
            FROM ShippingHistory sh
            JOIN Shipper s ON sh.ShipperId = s.Id
            JOIN Orders o ON sh.OrderId = o.Id
            JOIN User u ON o.UserId = u.UserID
            WHERE 1=1
        """);

        // Nếu có từ khóa tìm kiếm
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND u.FullName LIKE ? ");
        }

        // Nếu có trạng thái
        if (status != null && !status.equals("all") && !status.isEmpty()) {
            sql.append(" AND sh.Status = ? ");
        }

        sql.append(" ORDER BY sh.UpdateTime DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search.trim() + "%");
            }
            if (status != null && !status.equals("all") && !status.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(status));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ShippingHistory sh = new ShippingHistory();
                sh.setId(rs.getLong("ShippingHistoryId"));
                sh.setOrderId(rs.getLong("OrderId"));
                sh.setShipperId(rs.getLong("ShipperId"));
                sh.setStatus(rs.getInt("ShippingStatus"));
                sh.setUpdateTime(rs.getTimestamp("UpdateTime"));
                sh.setShipperName(rs.getString("ShipperName"));
                sh.setCustomerName(rs.getString("CustomerName"));

                int orderStatus = rs.getInt("OrderStatus");
                String orderStatusText = switch (orderStatus) {
                    case 0 -> "Chờ xác nhận";
                    case 1 -> "Đã thanh toán";
                    case 2 -> "Đang giao";
                    case 3 -> "Hoàn tất";
                    case 4 -> "Đã hủy";
                    default -> "Không xác định";
                };
                sh.setOrderStatus(orderStatusText);

                list.add(sh);
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy dữ liệu ShippingHistory: " + e.getMessage());
        }

        return list;
    }
}