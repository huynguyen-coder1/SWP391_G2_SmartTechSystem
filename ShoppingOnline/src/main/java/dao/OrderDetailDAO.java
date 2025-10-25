package dao;

import connect.DBConnection;
import model.OrderItem;
import model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAO {

    public List<OrderItem> getOrderItemsByOrderId(long orderId) {
        List<OrderItem> list = new ArrayList<>();

        String sql = """
            SELECT od.Id, od.OrderId, od.ProductId, od.Quantity, od.Price,
                   p.ProductName, p.Images
            FROM OrderDetail od
            JOIN Product p ON od.ProductId = p.ProductId
            WHERE od.OrderId = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getLong("Id"));
                item.setOrderId(rs.getLong("OrderId"));
                item.setProductId(rs.getLong("ProductId"));
                item.setQuantity(rs.getInt("Quantity"));
                item.setPrice(rs.getDouble("Price"));

                Product p = new Product();
                p.setProductId(rs.getInt("ProductId"));
                p.setProductName(rs.getString("ProductName"));
                p.setImages(rs.getString("Images"));
                item.setProduct(p);
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
