package controller.Authentication;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminProfileServlet", urlPatterns = {"/admin/adminProfile"})
public class AdminProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            request.setAttribute("error", "Không thể tải thông tin tài khoản admin.");
            request.getRequestDispatcher("/admin/adminProfile.jsp").forward(request, response);
            return;
        }

        // ✅ Lấy lại từ DB để luôn cập nhật mới nhất
        User admin = userDAO.getUserById(currentUser.getUserID());
        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/admin/adminProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            request.setAttribute("profileMessage", "Không xác định được tài khoản admin.");
            request.getRequestDispatcher("/admin/adminProfile.jsp").forward(request, response);
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dobStr = request.getParameter("dateOfBirth");

        Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            dob = Date.valueOf(dobStr);
        }

        User u = new User();
        u.setUserID(currentUser.getUserID());
        u.setFullName(fullName);
        u.setPhone(phone);
        u.setAddress(address);
        u.setDateOfBirth(dob);

        boolean updated = userDAO.updateAdminProfile(u);
        if (updated) {
            request.setAttribute("profileMessage", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("profileMessage", "❌ Cập nhật thất bại.");
        }

        // ✅ Lấy lại bản ghi mới nhất
        User admin = userDAO.getUserById(currentUser.getUserID());
        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/admin/adminProfile.jsp").forward(request, response);
    }
}

