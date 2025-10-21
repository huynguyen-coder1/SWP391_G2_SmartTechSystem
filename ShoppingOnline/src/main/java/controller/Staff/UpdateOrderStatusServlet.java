package controller.Staff;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.OrderDAO;

@WebServlet("/updateorderstatus")
public class UpdateOrderStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");
        String statusStr = request.getParameter("status");

        if (orderIdStr == null || orderIdStr.trim().isEmpty() ||
            statusStr == null || statusStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu dữ liệu đầu vào");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            int status = Integer.parseInt(statusStr);

            OrderDAO dao = new OrderDAO();
            boolean updated = dao.updateOrderStatus(orderId, status);

            if (updated) {
                // Sau khi cập nhật xong, chuyển hướng về lại trang staff
                response.sendRedirect(request.getContextPath() + "/ordermanagement");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật thất bại");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng số không hợp lệ");
        }
    }
}
