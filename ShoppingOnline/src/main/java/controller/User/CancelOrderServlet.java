package controller;

import dao.OrderDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/cancelOrder")
public class CancelOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            OrderDAO dao = new OrderDAO();

            boolean success = dao.cancelOrder(orderId, currentUser.getUserID());

            if (success) {
                session.setAttribute("message", "Đã hủy đơn hàng #" + orderId + " thành công.");
            } else {
                session.setAttribute("errorMessage", "Không thể hủy đơn hàng. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi khi hủy đơn.");
        }

        response.sendRedirect(request.getContextPath() + "/myOrders");
    }
}
