package controller.User;

import model.Role;
import dao.RoleDAO;
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;

@WebServlet("/admin/userManagement")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String statusFilter = request.getParameter("statusFilter");

        UserDAO dao = new UserDAO();
        List<User> userList = dao.filterUsers(search, statusFilter);

        // ✅ PHẢI LOAD ROLE ĐỂ JSP DÙNG
        List<Role> roles = new RoleDAO().getAllRoles();
        request.setAttribute("roles", roles);

        request.setAttribute("userList", userList);

        request.getRequestDispatcher("/admin/userManagement.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId_raw = request.getParameter("userId");
        String roleId_raw = request.getParameter("roleId");

        if (userId_raw != null && roleId_raw != null) {
            int userId = Integer.parseInt(userId_raw);
            int roleId = Integer.parseInt(roleId_raw);

            UserDAO dao = new UserDAO();
            dao.updateUserRole(userId, roleId);
        }

        // ✅ Redirect đúng đường
        response.sendRedirect(request.getContextPath() + "/admin/userManagement");
    }
}

