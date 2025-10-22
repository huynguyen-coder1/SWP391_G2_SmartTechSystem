package controller;

import dao.OrderDetailDAO;
import dao.OrderDAO;
import model.Order;
import model.OrderItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/orderDetail")
public class OrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/myOrders");
            return;
        }

        long orderId = Long.parseLong(idParam);

        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderById(orderId); // bạn thêm hàm này nếu chưa có

        OrderDetailDAO detailDAO = new OrderDetailDAO();
        List<OrderItem> orderItems = detailDAO.getOrderItemsByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.getRequestDispatcher("/user/orderDetail.jsp").forward(request, response);
    }
}
