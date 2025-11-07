package controller.Authentication;

import dao.AdminDashboardDAO;
import dao.RevenueDAO;            // import DAO, nhớ tạo package dao và class này
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
        long monthlyRevenue = (long) dao.getRevenueThisMonth();
        int pendingOrders = dao.getPendingOrders();

        // Gán sang JSP theo đúng tên trong adminPage.jsp
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("pendingOrders", pendingOrders);

        // Dữ liệu danh sách
        request.setAttribute("recentUsers", dao.getRecentUsers());
        request.setAttribute("bestSellers", dao.getTopProducts());

        // ✅ Biểu đồ doanh thu 7 ngày gần đây
        RevenueDAO revenueDAO = new RevenueDAO();
        var revenueMap = revenueDAO.getRevenueLast7Days();
        request.setAttribute("revenueChartLabels", revenueMap.keySet());
        request.setAttribute("revenueChartValues", revenueMap.values());

        // ✅ (tuỳ chọn) lấy doanh thu tháng — nếu bạn muốn hiển thị ở biểu đồ tháng
        var monthlyRevenueMap = revenueDAO.getMonthlyRevenue();
        request.setAttribute("monthlyRevenueMap", monthlyRevenueMap);

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

