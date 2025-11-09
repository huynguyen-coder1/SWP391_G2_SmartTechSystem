package controller.Authentication;

import dao.RoleDAO;
import dao.ShipperDAO;
import model.Role;
import model.User;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ShipperManagementServlet", urlPatterns = {"/admin/shipperManagement"})
public class ShipperManagementServlet extends HttpServlet {

    private final ShipperDAO shipperDAO = new ShipperDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        // ✅ Lấy danh sách shipper
        List<User> shipperList = shipperDAO.getAllShippers();

        // ✅ Lọc theo từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            String lowerKeyword = keyword.toLowerCase();
            shipperList = shipperList.stream()
                    .filter(u -> u.getFullName().toLowerCase().contains(lowerKeyword)
                            || u.getEmail().toLowerCase().contains(lowerKeyword))
                    .collect(Collectors.toList());
        }

        // ✅ Lọc theo trạng thái
        if (status != null && !status.isEmpty()) {
            boolean active = "1".equals(status);
            shipperList = shipperList.stream()
                    .filter(u -> u.isActive() == active)
                    .collect(Collectors.toList());
        }

        // ✅ Lấy danh sách 3 role hợp lệ
        List<Role> roles = roleDAO.getAllRoles().stream()
                .filter(r -> r.getRoleName().equalsIgnoreCase("User")
                        || r.getRoleName().equalsIgnoreCase("Staff")
                        || r.getRoleName().equalsIgnoreCase("Shipper"))
                .collect(Collectors.toList());

        // ✅ Gửi sang JSP
        request.setAttribute("roles", roles);
        request.setAttribute("shipperList", shipperList);
        request.getRequestDispatcher("/admin/shipperManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String message = "";
        String error = "";

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));

            switch (action) {
                case "toggleStatus" -> {
                    boolean currentStatus = Boolean.parseBoolean(request.getParameter("isActive"));
                    shipperDAO.updateShipperStatus(userId, !currentStatus);
                    message = currentStatus ? "Đã khóa tài khoản shipper!" : "Đã mở khóa tài khoản shipper!";
                }

                case "delete" -> {
                    shipperDAO.deleteShipper(userId);
                    message = "Đã xóa shipper thành công!";
                }

                case "updateRole" -> {
                    int roleId = Integer.parseInt(request.getParameter("roleId"));
                    shipperDAO.updateShipperRole(userId, roleId);
                    message = "Đã cập nhật vai trò shipper thành công!";
                }

                default -> error = "Hành động không hợp lệ!";
            }

        } catch (Exception e) {
            e.printStackTrace();
            error = "Có lỗi xảy ra khi xử lý yêu cầu!";
        }

        // ✅ Encode tiếng Việt để tránh lỗi Unicode trong redirect header
        if (!error.isEmpty()) {
            String encodedError = URLEncoder.encode(error, StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/admin/shipperManagement?error=" + encodedError);
        } else {
            String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/admin/shipperManagement?success=" + encodedMessage);
        }
    }
}

