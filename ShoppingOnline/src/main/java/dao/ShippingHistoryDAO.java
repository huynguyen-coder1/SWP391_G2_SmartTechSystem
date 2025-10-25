package dao;

import connect.DBConnection;
import model.ShippingHistory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShippingHistoryDAO {

    /**
     * 🔹 Lấy danh sách lịch sử giao hàng (có thể lọc theo tên khách, tên shipper, hoặc trạng thái)
     */
    public List<ShippingHistory> getShippingHistory(String keyword, String status) {
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

        // 🔍 Thêm điều kiện tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.FullName LIKE ? OR s.ShipperName LIKE ?) ");
        }

        // 🔍 Lọc theo trạng thái
        if (status != null && !status.equalsIgnoreCase("all") && !status.isEmpty()) {
            sql.append(" AND sh.Status = ? ");
        }

        sql.append(" ORDER BY sh.UpdateTime DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword.trim() + "%");
                ps.setString(index++, "%" + keyword.trim() + "%");
            }

            if (status != null && !status.equalsIgnoreCase("all") && !status.isEmpty()) {
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

                // 🧩 Map trạng thái đơn hàng
                int orderStatus = rs.getInt("OrderStatus");
                String orderStatusText = switch (orderStatus) {
                    case 0 -> "Chờ xác nhận";
                    case 1 -> "Đã xác nhận";
                    case 2 -> "Đang giao";
                    case 3 -> "Hoàn tất";
                    case 4 -> "Đã hủy";
                    default -> "Không xác định";
                };
                sh.setOrderStatus(orderStatusText);

                list.add(sh);
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy lịch sử giao hàng: " + e.getMessage());
        }

        return list;
    }

    /**
     * ✅ Thêm bản ghi lịch sử giao hàng mới
     */
    public boolean insertShippingHistory(long orderId, int shipperId, int status) {
        String sql = """
            INSERT INTO ShippingHistory (OrderId, ShipperId, Status, UpdateTime)
            VALUES (?, ?, ?, NOW())
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, orderId);
            ps.setInt(2, shipperId);
            ps.setInt(3, status);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi thêm ShippingHistory: " + e.getMessage());
            return false;
        }
    }

    /**
     * ✅ Lấy lịch sử theo ID đơn hàng (ví dụ khi muốn hiển thị chi tiết)
     */
    public List<ShippingHistory> getHistoryByOrderId(long orderId) {
        List<ShippingHistory> list = new ArrayList<>();
        String sql = """
            SELECT 
                sh.Id, sh.OrderId, sh.ShipperId, sh.Status, sh.UpdateTime, 
                s.ShipperName
            FROM ShippingHistory sh
            JOIN Shipper s ON sh.ShipperId = s.Id
            WHERE sh.OrderId = ?
            ORDER BY sh.UpdateTime DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ShippingHistory sh = new ShippingHistory();
                sh.setId(rs.getLong("Id"));
                sh.setOrderId(rs.getLong("OrderId"));
                sh.setShipperId(rs.getLong("ShipperId"));
                sh.setStatus(rs.getInt("Status"));
                sh.setUpdateTime(rs.getTimestamp("UpdateTime"));
                sh.setShipperName(rs.getString("ShipperName"));
                list.add(sh);
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy lịch sử giao hàng theo OrderId: " + e.getMessage());
        }

        return list;
    }

    /**
     * ✅ Map trạng thái giao hàng (cho UI)
     */
    public static String mapShippingStatus(int status) {
        return switch (status) {
            case 0 -> "Đang chờ giao";
            case 1 -> "Đang vận chuyển";
            case 2 -> "Giao thành công";
            case 3 -> "Giao thất bại";
            default -> "Không xác định";
        };
    }
}