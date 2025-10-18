package controller.Staff;

import dao.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;


public class OrderManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra user đã login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        // Lấy danh sách orders từ DAO
        OrderDAO orderDAO = new OrderDAO();
        List<Map<String, Object>> orders = orderDAO.getAllOrdersWithUser();

        // Debug: kiểm tra dữ liệu đã lấy
        System.out.println("Orders size = " + orders.size());
        for (Map<String, Object> o : orders) {
            System.out.println(o);
        }

        // Gán dữ liệu cho JSP
        request.setAttribute("orders", orders);

        // Chuyển tiếp tới JSP
       RequestDispatcher rd = request.getRequestDispatcher("/staff/staffPage.jsp");

        rd.forward(request, response);
    }
}
