package controller.User;

import dao.CategoryDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/categories"})
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        CategoryDAO dao = new CategoryDAO();
        List<Category> list = new ArrayList<>(); // Khởi tạo để tránh null

        try {
            list = dao.getAllCategories();
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi lấy danh sách Category từ database");
        }

        request.setAttribute("categoryList", list);
        RequestDispatcher rd = request.getRequestDispatcher("/categories.jsp"); // Forward tới trang hiển thị
        rd.forward(request, response);
    }
}

