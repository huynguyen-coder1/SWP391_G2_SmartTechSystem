package controller.User;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.User;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        // Gửi thông tin user sang JSP để hiển thị sẵn
        request.setAttribute("user", user);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/includes/checkout.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user != null) {
            // Cập nhật thông tin từ form
            user.setFullName(request.getParameter("fullname"));
            user.setPhone(request.getParameter("phone"));
            user.setAddress(request.getParameter("address"));

            // Lưu thay đổi vào DB
            new UserDAO().updateUserProfile(user);

            // Cập nhật lại session
            session.setAttribute("currentUser", user);
        }

        // Ghi chú (nếu có)
        String note = request.getParameter("note");
        session.setAttribute("note", note);

        // Chuyển đến trang payment.jsp
        response.sendRedirect("payment");
    }
}
