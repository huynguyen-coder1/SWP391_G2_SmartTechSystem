package controller.shipper;

import dao.OrderDAO;
import dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/shipper/updateOrder")
public class ShipperUpdateOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");
        String action = request.getParameter("action");

        if (orderIdStr == null || action == null) {
            response.sendRedirect("shipperPage");
            return;
        }

        int orderId = Integer.parseInt(orderIdStr);
        OrderDAO orderDAO = new OrderDAO();
        ProductDAO productDAO = new ProductDAO();

        try {
            if (action.equals("complete")) {
                // ✅ Chuyển trạng thái sang completed
                orderDAO.updateOrderStatus(orderId, 3);

                // ✅ Thêm vào ShippingHistory
                orderDAO.insertShippingHistory(orderId);

                // ✅ Xóa đơn
            //    orderDAO.deleteOrder(orderId);

            } else if (action.equals("cancel")) {
                // ❌ Hủy đơn
                orderDAO.updateOrderStatus(orderId, 4);
                
                orderDAO.insertShippingHistory(orderId);

                // ✅ Cộng lại số lượng sản phẩm
                productDAO.restoreProductQuantity(orderId);

                // ✅ Xóa đơn
                orderDAO.deleteOrder(orderId);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("shipperPage");
    }
}
