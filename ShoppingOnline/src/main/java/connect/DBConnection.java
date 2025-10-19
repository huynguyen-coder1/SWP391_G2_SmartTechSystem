package connect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final String DRIVER_NAME = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/techmartdb?useSSL=false&serverTimezone=UTC";
    private static final String USER_NAME = "root";
    private static final String PASSWORD = "123";

    // ✅ Không dùng static connection để tránh lỗi connection closed hoặc chia sẻ connection
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(DRIVER_NAME);
            conn = DriverManager.getConnection(DB_URL, USER_NAME, PASSWORD);
            // System.out.println("✅ Connected to MySQL database.");
        } catch (ClassNotFoundException e) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "❌ JDBC Driver not found!", e);
        } catch (SQLException e) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "❌ Database connection failed!", e);
        }
        return conn;
    }

    // ✅ Hàm đóng kết nối an toàn
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                    // System.out.println("🔒 Connection closed.");
                }
            } catch (SQLException e) {
                Logger.getLogger(DBConnection.class.getName()).log(Level.WARNING, "⚠️ Failed to close connection!", e);
            }
        }
    }

    // ✅ Test nhanh (chạy độc lập)
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("🟢 Connection test successful.");
            } else {
                System.out.println("🔴 Connection test failed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
