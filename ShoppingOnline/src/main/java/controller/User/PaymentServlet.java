package controller.User;

import dao.CartDAO;
import dao.OrderDAO;
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.*;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu người dùng truy cập trực tiếp /payment -> quay lại trang checkout
        response.sendRedirect("checkout");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // --- Lấy thông tin từ form ---
        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        // --- Lấy user từ session ---
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // --- Lấy giỏ hàng hiện tại trong DB ---
        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getCartByUserId(currentUser.getUserID());

        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        // --- Cập nhật thông tin người dùng ---
        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);
        currentUser.setAddress(address);
        UserDAO userDAO = new UserDAO();
      //  userDAO.updateUserProfile(currentUser);

        // --- Tạo đơn hàng từ giỏ hàng ---
        OrderDAO orderDAO = new OrderDAO();
        long orderId = orderDAO.createOrderFromCart(currentUser.getUserID(), cart.getId(),address,phone);

        if (orderId > 0) {
            // --- Xóa giỏ hàng trong session ---
            session.removeAttribute("cart");

            // --- Truyền dữ liệu sang trang thành công ---
            request.setAttribute("orderId", orderId);
            request.setAttribute("checkoutUser", currentUser);
            request.setAttribute("paymentMethod", paymentMethod);
            request.setAttribute("totalAmount", cart.getTotalMoney());

            RequestDispatcher rd = request.getRequestDispatcher("/user/payment-success.jsp");
            rd.forward(request, response);
        } else {
            // Nếu có lỗi
            request.setAttribute("error", "Thanh toán thất bại, vui lòng thử lại!");
            RequestDispatcher rd = request.getRequestDispatcher("/user/payment.jsp");
            rd.forward(request, response);
        }
    }
}
