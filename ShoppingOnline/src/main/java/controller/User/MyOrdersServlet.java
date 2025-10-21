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

        OrderDAO dao = new OrderDAO();
        List<Order> orders = dao.getOrdersByUserId(userId);

//response.setContentType("text/plain;charset=UTF-8");
//        response.getWriter().println(">>> MyOrdersServlet: userId = " + userId);
//        response.getWriter().println(">>> MyOrdersServlet: số đơn hàng = " + orders.size());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/user/myOrders.jsp").forward(request, response);
    }
}
