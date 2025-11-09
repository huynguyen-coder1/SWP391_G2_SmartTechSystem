package controller.Shipper;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import dao.OrderDAO; // tùy đường dẫn package dao của bạn

@WebServlet("/shipper/shipperPage")
public class ShipperPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        OrderDAO dao = new OrderDAO();
        List<Map<String, Object>> shippingOrders = dao.getOrdersByStatus(2); // 2 = shipping

        request.setAttribute("shippingOrders", shippingOrders);
        request.getRequestDispatcher("/shipper/shipperPage.jsp").forward(request, response);
    }
}