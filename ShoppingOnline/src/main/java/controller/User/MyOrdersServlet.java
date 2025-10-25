package controller;

import dao.OrderDAO;
import model.Order;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/myOrders")
public class MyOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        int userId = currentUser.getUserID();
        String statusFilter = request.getParameter("status"); // 👈 lấy trạng thái từ query

        OrderDAO dao = new OrderDAO();
        List<Order> orders;

        if (statusFilter != null && !statusFilter.isEmpty()) {
            orders = dao.getOrdersByUserIdAndStatus(userId, statusFilter);
        } else {
            orders = dao.getOrdersByUserId(userId);
        }

        request.setAttribute("orders", orders);
        request.setAttribute("selectedStatus", statusFilter); // để giữ lại chọn
        request.getRequestDispatcher("/user/myOrders.jsp").forward(request, response);
    }
}
