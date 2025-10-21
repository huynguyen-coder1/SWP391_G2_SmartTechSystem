package dao;

import java.sql.*;
import java.util.*;
import connect.DBConnection; 

public class ShippingHistoryDAO {

    public List<Map<String, Object>> getAllShippingHistory() {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
            SELECT sh.Id, sh.OrderId, sh.ShipperId, sh.Status, sh.UpdateTime,
                   CASE 
                       WHEN sh.Status = 2 THEN 'Hoàn thành'
                       WHEN sh.Status = 3 THEN 'Đã hủy'
                       ELSE 'Không xác định'
                   END AS StatusText,
                   o.TotalAmount, o.OrderDate,
                   u.FullName, u.Email
            FROM ShippingHistory sh
            JOIN Orders o ON sh.OrderId = o.Id
            JOIN User u ON o.UserId = u.UserId
            ORDER BY sh.UpdateTime DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("Id", rs.getInt("Id"));
                map.put("OrderId", rs.getInt("OrderId"));
                map.put("ShipperId", rs.getInt("ShipperId"));
                map.put("Status", rs.getInt("Status"));
                map.put("StatusText", rs.getString("StatusText"));
                map.put("UpdateTime", rs.getTimestamp("UpdateTime"));
                map.put("TotalAmount", rs.getBigDecimal("TotalAmount"));
                map.put("OrderDate", rs.getTimestamp("OrderDate"));
                map.put("FullName", rs.getString("FullName"));
                map.put("Email", rs.getString("Email"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
