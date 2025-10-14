package controller.Category;

import dao.CategoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteCategoryServlet", urlPatterns = {"/DeleteCategoryServlet"})
public class DeleteCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy categoryId từ URL
        String idStr = request.getParameter("categoryId");

        // ✅ Kiểm tra nếu không có id
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categoryManagement.jsp?error=missing_id");
            return;
        }

        try {
            long categoryId = Long.parseLong(idStr);
            CategoryDAO dao = new CategoryDAO();
            boolean deleted = dao.deleteCategory(categoryId);

            if (deleted) {
                // ✅ Xóa thành công
                response.sendRedirect(request.getContextPath() + "/admin/categoryManagement.jsp?success=deleted");
            } else {
                // ✅ Không tìm thấy danh mục hoặc xóa thất bại
                response.sendRedirect(request.getContextPath() + "/admin/categoryManagement.jsp?error=not_found");
            }

        } catch (NumberFormatException e) {
            // ✅ Khi ID không hợp lệ
            response.sendRedirect(request.getContextPath() + "/admin/categoryManagement.jsp?error=invalid_id");
        } catch (Exception e) {
            // ✅ Lỗi bất ngờ
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categoryManagement.jsp?error=server_error");
        }
    }
}