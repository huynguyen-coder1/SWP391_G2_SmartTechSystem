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

        // Gửi thông tin user sang JSP để hiển thị
        request.setAttribute("user", user);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/checkout.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user != null) {
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String note = request.getParameter("note");

            // Cập nhật user
            user.setFullName(fullname);
            user.setPhone(phone);
            user.setAddress(address);
            new UserDAO().updateUserProfile(user);

            // Lưu vào session
            session.setAttribute("currentUser", user);
            session.setAttribute("checkoutFullName", fullname);
            session.setAttribute("checkoutPhone", phone);
            session.setAttribute("checkoutAddress", address);
            session.setAttribute("checkoutNote", note);
        }

        // Chuyển sang trang chọn phương thức thanh toán
        response.sendRedirect("payment");
    }
}
