package controller.Authentication;

import dao.AdminDashboardDAO;  // import DAO, nhớ tạo package dao và class này
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Servlet implementation class AdminDashboardServlet
 */
@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminDashboardServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminDashboardDAO dao = new AdminDashboardDAO();

        // Gọi các hàm thống kê từ DAO
        int totalUsers = dao.getTotalUsers();
        int totalProducts = dao.getTotalProducts();
        int totalOrders = dao.getTotalOrders();
        double revenueToday = dao.getRevenueToday();
        double revenueMonth = dao.getRevenueThisMonth();

        // Gán dữ liệu sang request để JSP hiển thị
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("revenueToday", revenueToday);
        request.setAttribute("revenueMonth", revenueMonth);
        request.setAttribute("recentOrders", dao.getRecentOrders());
        request.setAttribute("topProducts", dao.getTopProducts());

        // Chuyển hướng tới giao diện admin dashboard
        request.getRequestDispatcher("/admin/adminPage.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

