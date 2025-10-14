package controller.Authentication;

import connect.DBConnection;
import dao.AccountDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/changePassword"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null
                || currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);
            User freshUser = accountDAO.getUserById(currentUser.getUserID());

            if (freshUser == null) {
                request.setAttribute("errorMessage", "Người dùng không tồn tại.");
                request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
                return;
            }

            // ✅ So sánh hash đúng cách
            if (!BCrypt.checkpw(currentPassword, freshUser.getPasswordHash())) {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
                return;
            }

            // ✅ Hash mật khẩu mới
            String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            freshUser.setPasswordHash(hashedNewPassword);

            boolean updated = accountDAO.updateUser(freshUser);

            if (updated) {
                session.setAttribute("currentUser", freshUser);
                request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("errorMessage", "Đổi mật khẩu thất bại.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        request.getRequestDispatcher("/account/profile.jsp").forward(request, response);
    }
}
