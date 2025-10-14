package controller.Category;

import dao.CategoryDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Category;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/admin/addCategory")
public class AddCategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("categoryName");
        String description = request.getParameter("description");
        int status = Integer.parseInt(request.getParameter("status"));

        Category c = new Category();
        c.setCategoryName(name);
        c.setDescription(description);
        c.setStatus(status);
        c.setCreatedAt(Timestamp.valueOf(LocalDateTime.now()));
        c.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));

        categoryDAO.addCategory(c);

        response.sendRedirect(request.getContextPath() + "/admin/categoryManagement");
    }
}