package controller.Category;

import dao.CategoryDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.Category;

@WebServlet("/admin/updateCategory")
public class UpdateCategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
    }

    // Hiển thị form update
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            long id = Long.parseLong(request.getParameter("id"));
            Category category = categoryDAO.getCategoryById(id);

            if (category == null) {
                response.sendRedirect("categoryManagement.jsp");
                return;
            }

            request.setAttribute("category", category);
            request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("categoryManagement.jsp");
        }
    }

    // Cập nhật danh mục
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String idStr = request.getParameter("categoryId");
if (idStr == null || idStr.trim().isEmpty()) {
    throw new IllegalArgumentException("Category ID is missing or invalid.");
}
long categoryId = Long.parseLong(idStr);

            String name = request.getParameter("categoryName");
            String description = request.getParameter("description");
            String statusStr = request.getParameter("status");
int status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : 0;


            Category category = new Category();
            category.setCategoryId(categoryId);
            category.setCategoryName(name);
            category.setDescription(description);
            category.setStatus(status);
            category.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));

            boolean updated = categoryDAO.updateCategory(category);

            if (updated) {
                response.sendRedirect("categoryManagement.jsp?success=updated");
            } else {
                response.sendRedirect("categoryManagement.jsp?error=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("categoryManagement.jsp?error=exception");
        }
    }
}