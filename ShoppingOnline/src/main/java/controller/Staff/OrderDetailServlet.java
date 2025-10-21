package controller.Staff;

import dao.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/staff/order-detail")
public class OrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã đơn hàng");
            return;
        }

        long orderId = Long.parseLong(idParam);

        OrderDAO orderDAO = new OrderDAO();
        Map<String, Object> orderInfo = orderDAO.getOrderInfo(orderId); 
        List<Map<String, Object>> orderDetails = orderDAO.getOrderDetails(orderId);

        request.setAttribute("orderInfo", orderInfo);
        request.setAttribute("orderDetails", orderDetails);

        RequestDispatcher rd = request.getRequestDispatcher("/staff/orderDetail.jsp");
        rd.forward(request, response);
    }
}

