package controller.User;

import dao.ProductDAO;
import dao.CategoryDAO;
import dao.BrandDAO;
import model.Product;
import model.Category;
import model.Brand;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ProductListServlet", urlPatterns = {"/ProductListServlet"})
public class ProductListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String categoryId = request.getParameter("categoryId");
        String brandId = request.getParameter("brandId");
        String status = request.getParameter("status");

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        BrandDAO brandDAO = new BrandDAO();

        try {
            List<Product> productList = productDAO.filterProducts(search, categoryId, brandId, status);
            List<Category> categoryList = categoryDAO.getAllCategories();
            List<Brand> brandList = brandDAO.getAllBrands();

            request.setAttribute("productList", productList);
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("brandList", brandList);

            request.setAttribute("search", search);
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("selectedBrand", brandId);
            request.setAttribute("selectedStatus", status);
            if (categoryId != null && !categoryId.isEmpty()) {
                try {
                    Category c = categoryDAO.getCategoryById(Long.parseLong(categoryId));
                    if (c != null) {
                        request.setAttribute("categoryName", c.getCategoryName());
                    }
                } catch (NumberFormatException ignore) {}
            }

            if (brandId != null && !brandId.isEmpty()) {
                try {
                    Brand b = brandDAO.getBrandById(Long.parseLong(brandId));
                    if (b != null) {
                        request.setAttribute("brandName", b.getBrandName());
                    }
                } catch (NumberFormatException ignore) {}
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách sản phẩm!");
        }

        // ✅ Trang hiển thị sản phẩm
        request.getRequestDispatcher("/product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}


