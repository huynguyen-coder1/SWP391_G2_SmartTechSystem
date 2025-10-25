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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminDashboardDAO dao = new AdminDashboardDAO();

        // Lấy dữ liệu thống kê
        int totalProducts = dao.getTotalProducts();
        int totalCustomers = dao.getTotalUsers(); // đổi tên cho khớp
        double monthlyRevenue = dao.getRevenueThisMonth();
        int pendingOrders = dao.getPendingOrders();

        // Gán sang JSP theo đúng tên trong adminPage.jsp
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("pendingOrders", pendingOrders);

        // Dữ liệu danh sách
        request.setAttribute("recentUsers", dao.getRecentUsers());
        request.setAttribute("bestSellers", dao.getTopProducts());

        // Biểu đồ doanh thu
        request.setAttribute("revenueChartLabels", dao.getRevenueChartLabels());
        request.setAttribute("revenueChartValues", dao.getRevenueChartValues());

        // Chuyển sang trang admin
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

