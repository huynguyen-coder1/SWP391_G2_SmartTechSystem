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
                // ✅ Cập nhật trạng thái đơn hàng sang 'Hoàn tất' (3)
                orderDAO.updateOrderStatus(orderId, 3);

                // ✅ Ghi lại lịch sử giao hàng: 2 = Delivered
                orderDAO.insertShippingHistory(orderId, 2);

                // ❌ Không xóa đơn (nếu muốn xóa sau khi hoàn tất thì bỏ comment dưới)
                // orderDAO.deleteOrder(orderId);

            } else if (action.equals("cancel")) {
                // ❌ Cập nhật trạng thái đơn hàng sang 'Đã hủy' (4)
                orderDAO.updateOrderStatus(orderId, 4);

                // ✅ Ghi lại lịch sử giao hàng: 3 = Failed
                orderDAO.insertShippingHistory(orderId, 3);

                // ✅ Cộng lại số lượng sản phẩm về kho
                productDAO.restoreProductQuantity(orderId);

                // ✅ (Tùy chọn) Xóa đơn khỏi danh sách shipper
                // orderDAO.deleteOrder(orderId);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Quay lại trang shipper sau khi xử lý
        response.sendRedirect("shipperPage");
    }
}
