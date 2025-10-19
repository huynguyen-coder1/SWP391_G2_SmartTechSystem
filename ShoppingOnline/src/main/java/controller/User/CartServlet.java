package controller.User;

import dao.CartDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Cart;
import model.User;
import java.io.IOException;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect("account/login.jsp");
            return;
        }

        int userId = user.getUserID();
        CartDAO dao = new CartDAO();

        // Xử lý hành động tăng/giảm/xóa
        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        if (action != null && productIdStr != null) {
            long productId = Long.parseLong(productIdStr);
            switch (action) {
                case "remove":
                    dao.removeItem(userId, productId);
                    break;
                case "increase":
                    dao.updateQuantity(userId, productId, 1);
                    break;
                case "decrease":
                    dao.updateQuantity(userId, productId, -1);
                    break;
            }
        }

        // Lấy giỏ hàng mới nhất từ DB
        Cart cart = dao.getCartByUserId(userId);
        session.setAttribute("cart", cart); // Lưu vào session

        // Forward đến JSP
        request.getRequestDispatcher("user/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect("account/login.jsp");
            return;
        }

        int userId = user.getUserID();
        long productId = Long.parseLong(request.getParameter("productId"));
        int quantity = 1; // mặc định

        CartDAO dao = new CartDAO();
        dao.addToCart(userId, productId, quantity);

        // Lấy giỏ hàng mới nhất
        Cart cart = dao.getCartByUserId(userId);
        session.setAttribute("cart", cart);

        response.sendRedirect("cart");
    }
}
