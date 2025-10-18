package dao;

import model.Order;
import model.OrderItem;
import java.sql.*;
import java.util.*;
import connect.DBConnection; // dùng lớp kết nối sẵn có của bạn

public class OrderDAO {

    // ✅ Thêm đơn hàng mới (và trả về ID của đơn hàng vừa tạo)
    public int insertOrder(Order order) {
        String sql = "INSERT INTO `Order` (userId, shipperId, orderDate, totalAmount, status, address, note) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        int orderId = -1;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getShipperId());
            ps.setTimestamp(3, Timestamp.valueOf(order.getOrderDate()));
            ps.setDouble(4, order.getTotalAmount());
            ps.setString(5, order.getStatus());
            ps.setString(6, order.getAddress());
            ps.setString(7, order.getNote());

            ps.executeUpdate();

            // Lấy ID vừa tạo
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // ✅ Lưu chi tiết sản phẩm của đơn hàng
            if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
                insertOrderItems(conn, orderId, order.getOrderItems());
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderId;
    }

    // ✅ Lưu danh sách sản phẩm trong đơn hàng
    private void insertOrderItems(Connection conn, int orderId, List<OrderItem> items) throws SQLException {
        String sql = "INSERT INTO OrderItem (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (OrderItem item : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getQuantity());
                ps.setDouble(4, item.getPrice());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    // ✅ Lấy danh sách đơn hàng kèm thông tin user (JOIN User)
    /*   public List<Order> getAllOrdersWithUser() {
        List<Order> list = new ArrayList<>();
        String sql = """
            SELECT o.*, u.fullName, u.email, u.phone
            FROM `Order` o
            JOIN `User` u ON o.userId = u.userId
            ORDER BY o.orderDate DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("orderId"));
                o.setUserId(rs.getInt("userId"));
                o.setShipperId(rs.getInt("shipperId"));
                o.setOrderDate(rs.getTimestamp("orderDate").toLocalDateTime());
                o.setTotalAmount(rs.getDouble("totalAmount"));
                o.setStatus(rs.getString("status"));
                o.setAddress(rs.getString("address"));
                o.setNote(rs.getString("note"));

                // Có thể mở rộng thêm class User trong Order nếu muốn
                list.add(o);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }*/
    // ✅ Lấy danh sách tất cả đơn hàng (JOIN với user)
    public List<Map<String, Object>> getAllOrdersWithUser() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT o.*, u.FullName, u.Email, u.Phone
            FROM Orders o
            JOIN User u ON o.UserId = u.UserID
            ORDER BY o.OrderDate DESC
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("Id", rs.getLong("Id"));
                row.put("UserId", rs.getInt("UserId"));
                row.put("CartId", rs.getLong("CartId"));
                row.put("OrderDate", rs.getTimestamp("OrderDate"));
                row.put("TotalAmount", rs.getBigDecimal("TotalAmount"));
                row.put("Status", rs.getInt("Status"));
                row.put("FullName", rs.getString("FullName"));
                row.put("Email", rs.getString("Email"));
                row.put("Phone", rs.getString("Phone"));
                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public long createOrderFromCart(int userId, long cartId) {
        long orderId = -1;
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // bắt đầu transaction

            // 1️⃣ Kiểm tra tồn kho trước khi tạo đơn
            String checkStockSQL = "SELECT ci.ProductId, ci.Quantity, p.Quantity AS Stock "
                    + "FROM CartItem ci JOIN Product p ON ci.ProductId = p.ProductId "
                    + "WHERE ci.CartId = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkStockSQL)) {
                ps.setLong(1, cartId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int qtyInCart = rs.getInt("Quantity");
                    int stock = rs.getInt("Stock");
                    if (qtyInCart > stock) {
                        throw new SQLException("Sản phẩm ID " + rs.getLong("ProductId") + " vượt quá tồn kho.");
                    }
                }
            }

            // 2️⃣ Tạo đơn hàng
            String insertOrderSQL = "INSERT INTO Orders (UserId, CartId, TotalAmount, OrderDate, Status) "
                    + "SELECT UserId, Id, TotalMoney, NOW(), 0 FROM Cart WHERE Id = ?";
            try (PreparedStatement ps = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                ps.setLong(1, cartId);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getLong(1);
                    }
                }
            }

            if (orderId > 0) {
                // 3️⃣ Chuyển CartItem sang OrderDetail
                String insertOrderDetailSQL = "INSERT INTO OrderDetail (OrderId, ProductId, Quantity, Price) "
                        + "SELECT ?, ProductId, Quantity, Price FROM CartItem WHERE CartId = ?";
                try (PreparedStatement ps = conn.prepareStatement(insertOrderDetailSQL)) {
                    ps.setLong(1, orderId);
                    ps.setLong(2, cartId);
                    ps.executeUpdate();
                }

                // 4️⃣ Trừ tồn kho
                String updateStockSQL = "UPDATE Product p "
                        + "JOIN CartItem ci ON p.ProductId = ci.ProductId "
                        + "SET p.Quantity = p.Quantity - ci.Quantity "
                        + "WHERE ci.CartId = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateStockSQL)) {
                    ps.setLong(1, cartId);
                    ps.executeUpdate();
                }

                // 5️⃣ Đánh dấu giỏ hàng hoàn tất
                String updateCartStatusSQL = "UPDATE Cart SET Status = 0 WHERE Id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateCartStatusSQL)) {
                    ps.setLong(1, cartId);
                    ps.executeUpdate();
                }

                // 6️⃣ Xóa CartItem để dọn sạch
                String clearCartItemsSQL = "DELETE FROM CartItem WHERE CartId = ?";
                try (PreparedStatement ps = conn.prepareStatement(clearCartItemsSQL)) {
                    ps.setLong(1, cartId);
                    ps.executeUpdate();
                }
            }

            conn.commit(); // ✅ xác nhận transaction

        } catch (SQLException e) {
            e.printStackTrace();
            orderId = -1;
            if (conn != null) {
                try {
                    conn.rollback(); // rollback đúng connection
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }

        return orderId;
    }

}
