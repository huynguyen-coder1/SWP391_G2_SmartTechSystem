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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Không tìm thấy ID người dùng.");
            response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID người dùng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String birthdateStr = request.getParameter("birthdate");

        // Kiểm tra dữ liệu nhập
        if (fullName == null || fullName.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Họ tên không được để trống.");
            response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            return;
        }

        if (phone == null || phone.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Số điện thoại không được để trống.");
            response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            return;
        }

        phone = phone.replaceAll("\\D+", ""); // Chỉ giữ lại chữ số
        if (!phone.startsWith("0")) {
            session.setAttribute("errorMessage", "Số điện thoại phải bắt đầu bằng số 0.");
            response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            return;
        }

        if (phone.length() < 10) {
            session.setAttribute("errorMessage", "Số điện thoại phải có ít nhất 10 chữ số.");
            response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            return;
        }

        // Xử lý ngày sinh
        Date dateOfBirth = null;
        if (birthdateStr != null && !birthdateStr.isEmpty()) {
            try {
                dateOfBirth = new SimpleDateFormat("yyyy-MM-dd").parse(birthdateStr);
            } catch (ParseException e) {
                session.setAttribute("errorMessage", "Định dạng ngày sinh không hợp lệ (yyyy-MM-dd).");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }
        }

        // Cập nhật database
        try (Connection conn = DBConnection.getConnection()) {
            AccountDAO accountDAO = new AccountDAO(conn);
            User user = accountDAO.getUserById(userId);

            if (user == null) {
                session.setAttribute("errorMessage", "Người dùng không tồn tại.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
                return;
            }

            user.setFullName(fullName);
            user.setPhone(phone);
            user.setAddress(address);
            user.setDateOfBirth(dateOfBirth);

            boolean updated = accountDAO.updateUser(user);
            if (updated) {
                session.setAttribute("currentUser", user);
                session.setAttribute("successMessage", "Cập nhật hồ sơ thành công!");
                response.sendRedirect(request.getContextPath() + "/account/successProfile.jsp");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật hồ sơ. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/account/profile.jsp");
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi hệ thống khi cập nhật hồ sơ: " + e.getMessage(), e);
        }
    }
}
