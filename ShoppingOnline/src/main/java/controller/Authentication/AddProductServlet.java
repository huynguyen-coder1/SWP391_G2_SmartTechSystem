package controller.Authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

import dao.ProductDAO;
import model.Product;

@WebServlet("/addProduct") 
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddProductServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            String productName = request.getParameter("productName");
            long categoryId = Long.parseLong(request.getParameter("categoryId"));
            long brandId = Long.parseLong(request.getParameter("brandId"));
            BigDecimal priceImport = new BigDecimal(request.getParameter("priceImport"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String description = request.getParameter("description");
            int status = Integer.parseInt(request.getParameter("status"));

            // Tạo đối tượng Product
            Product p = new Product();
            p.setProductName(productName);
            p.setCategoryId(categoryId);
            p.setBrandId(brandId);
            p.setPriceImport(priceImport);
            p.setPrice(price);
            p.setQuantity(quantity);
            p.setDescription(description);
            p.setStatus(status);

            // Gọi DAO để thêm sản phẩm
            ProductDAO dao = new ProductDAO();
            dao.addProduct(p);

            // Quay lại trang quản lý sản phẩm
            response.sendRedirect("productManagement.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addProduct.jsp?error=1");
        }
    }
}
