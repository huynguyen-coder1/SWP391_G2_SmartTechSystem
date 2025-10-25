package controller.User;

import dao.ProductDAO;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("query");
        ProductDAO productDAO = new ProductDAO();
        List<Product> productList = null;

        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                productList = productDAO.searchProducts(keyword);
            } else {
                productList = productDAO.getAllProducts();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tìm kiếm sản phẩm!");
        }

        request.setAttribute("productList", productList);
        request.setAttribute("keyword", keyword);

        // ✅ Chuyển sang trang product.jsp
        request.getRequestDispatcher("/product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
