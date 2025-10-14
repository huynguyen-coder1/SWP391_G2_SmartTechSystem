package dao;

import connect.DBConnection;
import model.Cart;
import model.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    // Lấy giỏ hàng theo user
    public Cart getCartByUserId(int userId) {
        Cart cart = null;
        String sql = "SELECT * FROM Cart WHERE UserId = ? AND Status = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                cart = new Cart(
                        rs.getLong("Id"),
                        rs.getInt("UserId"),
                        rs.getDouble("TotalMoney"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getTimestamp("UpdatedAt"),
                        rs.getInt("Status")
                );
                cart.setItems(getCartItems(cart.getId()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cart;
    }

    // Lấy danh sách sản phẩm trong giỏ
    public List<CartItem> getCartItems(long cartId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT ci.Id, ci.CartId, ci.ProductId, ci.Quantity, ci.Price, p.ProductName "
                   + "FROM CartItem ci "
                   + "JOIN Product p ON ci.ProductId = p.ProductId "
                   + "WHERE ci.CartId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CartItem(
                        rs.getLong("Id"),
                        rs.getLong("CartId"),
                        rs.getLong("ProductId"),
                        rs.getString("ProductName"),
                        rs.getInt("Quantity"),
                        rs.getDouble("Price")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tạo hoặc lấy cart hiện tại
    private long getOrCreateCartId(int userId) throws SQLException {
        long cartId = -1;
        try (Connection conn = DBConnection.getConnection()) {
            String checkSql = "SELECT Id FROM Cart WHERE UserId = ? AND Status = 1";
            PreparedStatement ps = conn.prepareStatement(checkSql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                cartId = rs.getLong("Id");
            } else {
                // Đã sửa GETDATE() thành NOW() cho MySQL
                String insertSql = "INSERT INTO Cart (UserId, TotalMoney, CreatedAt, UpdatedAt, Status) "
                                 + "VALUES (?, 0, NOW(), NOW(), 1)";
                PreparedStatement insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                insertPs.setInt(1, userId);
                insertPs.executeUpdate();
                ResultSet keys = insertPs.getGeneratedKeys();
                if (keys.next()) cartId = keys.getLong(1);
            }
        }
        return cartId;
    }

    // Lấy số lượng tồn kho
    public int getProductStock(long productId) {
        int stock = 0;
        String sql = "SELECT Quantity FROM Product WHERE ProductId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) stock = rs.getInt("Quantity");
        } catch (Exception e) { e.printStackTrace(); }
        return stock;
    }

    // Lấy số lượng sản phẩm đã có trong giỏ
    public int getQuantityInCart(int userId, long productId) {
        int qty = 0;
        String sql = "SELECT ci.Quantity FROM CartItem ci " +
                     "JOIN Cart c ON ci.CartId = c.Id " +
                     "WHERE c.UserId = ? AND ci.ProductId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setLong(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) qty = rs.getInt("Quantity");
        } catch (Exception e) { e.printStackTrace(); }
        return qty;
    }

    // Thêm sản phẩm vào giỏ
    public void addToCart(int userId, long productId, int quantity) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch

            // Lấy số lượng tồn kho và số lượng đã có trong giỏ
            int stock = getProductStock(productId);
            int currentQty = getQuantityInCart(userId, productId);

            // Kiểm tra số lượng có đủ để thêm không
            int remaining = stock - currentQty;
            if (remaining <= 0) {
                conn.rollback(); // Khôi phục giao dịch
                return; // không còn hàng để thêm
            }
            int addQty = Math.min(quantity, remaining);

            // Lấy hoặc tạo giỏ hàng mới
            long cartId = getOrCreateCartId(userId);

            // Kiểm tra xem sản phẩm đã có trong giỏ chưa
            String checkItemSql = "SELECT Id, Quantity FROM CartItem WHERE CartId = ? AND ProductId = ?";
            PreparedStatement ps = conn.prepareStatement(checkItemSql);
            ps.setLong(1, cartId);
            ps.setLong(2, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Cập nhật số lượng nếu sản phẩm đã có
                int newQty = rs.getInt("Quantity") + addQty;
                String updateSql = "UPDATE CartItem SET Quantity = ? WHERE Id = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, newQty);
                updatePs.setLong(2, rs.getLong("Id"));
                updatePs.executeUpdate();
            } else {
                // Thêm mới sản phẩm vào giỏ
                double price = 0;
                String priceSql = "SELECT Price FROM Product WHERE ProductId = ?";
                PreparedStatement pricePs = conn.prepareStatement(priceSql);
                pricePs.setLong(1, productId);
                ResultSet priceRs = pricePs.executeQuery();
                if (priceRs.next()) {
                    price = priceRs.getDouble("Price");
                }
                String insertSql = "INSERT INTO CartItem (CartId, ProductId, Quantity, Price) VALUES (?, ?, ?, ?)";
                PreparedStatement insertPs = conn.prepareStatement(insertSql);
                insertPs.setLong(1, cartId);
                insertPs.setLong(2, productId);
                insertPs.setInt(3, addQty);
                insertPs.setDouble(4, price);
                insertPs.executeUpdate();
            }

          
            String totalSql = "UPDATE Cart SET TotalMoney = (SELECT IFNULL(SUM(Quantity * Price), 0) FROM CartItem WHERE CartId = ?) WHERE Id = ?";
            PreparedStatement totalPs = conn.prepareStatement(totalSql);
            totalPs.setLong(1, cartId);
            totalPs.setLong(2, cartId);
            totalPs.executeUpdate();

            conn.commit(); 
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); 
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Xóa sản phẩm
    public void removeItem(int userId, long productId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE ci FROM CartItem ci " +
                         "JOIN Cart c ON ci.CartId = c.Id " +
                         "WHERE c.UserId = ? AND ci.ProductId = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setLong(2, productId);
            ps.executeUpdate();

            String cartIdSql = "SELECT Id FROM Cart WHERE UserId = ? AND Status = 1";
            PreparedStatement psCart = conn.prepareStatement(cartIdSql);
            psCart.setInt(1, userId);
            ResultSet rsCart = psCart.executeQuery();
            if (rsCart.next()) {
                long cartId = rsCart.getLong("Id");
             
                String totalSql = "UPDATE Cart SET TotalMoney = (SELECT IFNULL(SUM(Quantity * Price),0) FROM CartItem WHERE CartId = ?) WHERE Id = ?";
                PreparedStatement totalPs = conn.prepareStatement(totalSql);
                totalPs.setLong(1, cartId);
                totalPs.setLong(2, cartId);
                totalPs.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Cập nhật số lượng
    public void updateQuantity(int userId, long productId, int delta) {
        try (Connection conn = DBConnection.getConnection()) {
            String select = "SELECT ci.Id, ci.Quantity, ci.CartId FROM CartItem ci " +
                            "JOIN Cart c ON ci.CartId = c.Id " +
                            "WHERE c.UserId = ? AND ci.ProductId = ?";
            PreparedStatement ps = conn.prepareStatement(select);
            ps.setInt(1, userId);
            ps.setLong(2, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                long id = rs.getLong("Id");
                int qty = rs.getInt("Quantity") + delta;
                long cartId = rs.getLong("CartId");

                if (delta > 0) {
                    int stock = getProductStock(productId);
                    if (qty > stock) return;
                }

                if (qty <= 0) {
                    removeItem(userId, productId);
                } else {
                    String update = "UPDATE CartItem SET Quantity = ? WHERE Id = ?";
                    PreparedStatement ps2 = conn.prepareStatement(update);
                    ps2.setInt(1, qty);
                    ps2.setLong(2, id);
                    ps2.executeUpdate();
                }

                
                String totalSql = "UPDATE Cart SET TotalMoney = (SELECT IFNULL(SUM(Quantity * Price),0) FROM CartItem WHERE CartId = ?) WHERE Id = ?";
                PreparedStatement totalPs = conn.prepareStatement(totalSql);
                totalPs.setLong(1, cartId);
                totalPs.setLong(2, cartId);
                totalPs.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
}