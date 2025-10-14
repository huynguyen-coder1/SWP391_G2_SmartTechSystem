package controller.User;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/updateUserStatus")
public class UpdateUserStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("userId");
        String statusStr = request.getParameter("isActive");

        if (idStr == null || statusStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/userManagement.jsp?error=missing_param");
            return;
        }

        try {
            int userId = Integer.parseInt(idStr);
            boolean isActive = Boolean.parseBoolean(statusStr);

            UserDAO dao = new UserDAO();
            boolean updated = dao.updateUserStatus(userId, isActive);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/userManagement?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/userManagement?error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/userManagement?error=exception");
        }
    }
}
