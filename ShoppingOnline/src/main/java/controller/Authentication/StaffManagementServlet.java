package controller.Authentication;

import dao.StaffDAO;
import dao.UserDAO;
import dao.RoleDAO;
import model.User;
import model.Role;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffManagementServlet", urlPatterns = {"/admin/staffManagement"})
public class StaffManagementServlet extends HttpServlet {

    private UserDAO userDAO;
    private RoleDAO roleDAO;
    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
        staffDAO = new StaffDAO();
    }

    /** 
     * GET: Hiển thị danh sách nhân viên + lọc + tìm kiếm
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Nếu có tham số ?action=delete thì thực hiện xóa
            String action = request.getParameter("action");
            if ("delete".equals(action)) {
                handleDelete(request, response);
                return;
            }

            // Lấy toàn bộ staff
            List<User> staffList = staffDAO.getAllStaff();
            List<Role> roles = roleDAO.getAllRoles();

            // ✅ Lọc theo trạng thái hoạt động
            String status = request.getParameter("status");
            if (status != null && !status.isEmpty()) {
                boolean isActive = status.equals("1");
                staffList = staffList.stream()
                        .filter(u -> u.isActive() == isActive)
                        .collect(Collectors.toList());
            }

            // ✅ Tìm kiếm theo tên hoặc email
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim().toLowerCase();
                staffList = staffList.stream()
                        .filter(u -> (u.getFullName() != null && u.getFullName().toLowerCase().contains(kw))
                                || (u.getEmail() != null && u.getEmail().toLowerCase().contains(kw)))
                        .collect(Collectors.toList());
            }

            request.setAttribute("staffList", staffList);
            request.setAttribute("roles", roles);
            request.setAttribute("status", status);
            request.setAttribute("keyword", keyword);

            request.getRequestDispatcher("/admin/staffManagement.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách nhân viên!");
            request.getRequestDispatcher("/admin/staffManagement.jsp").forward(request, response);
        }
    }

    /** 
     * POST: Cập nhật trạng thái hoặc role của nhân viên
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));

            if ("toggleStatus".equals(action)) {
                boolean currentStatus = Boolean.parseBoolean(request.getParameter("isActive"));
                userDAO.updateUserStatus(userId, !currentStatus);

            } else if ("updateRole".equals(action)) {
                int roleId = Integer.parseInt(request.getParameter("roleId"));
                staffDAO.updateUserRole(userId, roleId);
            }

            // Quay lại trang chính
            response.sendRedirect(request.getContextPath() + "/admin/staffManagement");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật thông tin nhân viên!");
            doGet(request, response);
        }
    }

    /**
     * Hàm xử lý xóa nhân viên
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("account");

        // Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Chỉ admin mới được quyền xóa
        if (!currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/staffManagement?error=permission");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User userToDelete = userDAO.getUserById(id);

            if (userToDelete == null) {
                response.sendRedirect(request.getContextPath() + "/admin/staffManagement?error=notfound");
                return;
            }

            // Không cho xóa admin
            if (userToDelete.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/staffManagement?error=cannotDeleteAdmin");
                return;
            }

            boolean deleted = userDAO.deleteUserById(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/staffManagement?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/staffManagement?error=deleteFailed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/staffManagement?error=invalidId");
        }
    }

    @Override
    public String getServletInfo() {
        return "Quản lý nhân viên - cập nhật, xóa role & trạng thái hoạt động";
    }
}
