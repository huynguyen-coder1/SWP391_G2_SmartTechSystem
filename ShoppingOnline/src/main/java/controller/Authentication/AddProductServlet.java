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

/**
 * Servlet xử lý thêm sản phẩm mới cho admin
 * Đường dẫn: /admin/addProduct
 */
@WebServlet("/admin/addProduct")
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddProductServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // ===== Lấy dữ liệu từ form =====
            String productName = request.getParameter("productName");
            String categoryIdStr = request.getParameter("categoryId");
            String brandIdStr = request.getParameter("brandId");
            String priceImportStr = request.getParameter("priceImport");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");
            String description = request.getParameter("description");
            String statusStr = request.getParameter("status");

            // ===== Kiểm tra dữ liệu bắt buộc =====
            if (productName == null || productName.trim().isEmpty()
                    || categoryIdStr == null || categoryIdStr.isEmpty()
                    || brandIdStr == null || brandIdStr.isEmpty()
                    || priceImportStr == null || priceImportStr.isEmpty()
                    || priceStr == null || priceStr.isEmpty()
                    || quantityStr == null || quantityStr.isEmpty()) {

                response.sendRedirect(request.getContextPath() + "/admin/productManagement?add=missing");
                return;
            }

            // ===== Parse dữ liệu =====
            long categoryId = Long.parseLong(categoryIdStr);
            long brandId = Long.parseLong(brandIdStr);
            BigDecimal priceImport = new BigDecimal(priceImportStr);
            BigDecimal price = new BigDecimal(priceStr);
            int quantity = Integer.parseInt(quantityStr);
            int status = (statusStr != null && !statusStr.isEmpty())
                    ? Integer.parseInt(statusStr)
                    : 1; // mặc định còn hàng

            // ===== Tạo đối tượng Product =====
            Product product = new Product();
            product.setProductName(productName.trim());
            product.setCategoryId(categoryId);
            product.setBrandId(brandId);
            product.setPriceImport(priceImport);
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setDescription(description);
            product.setStatus(status);

            // ===== Gọi DAO để thêm vào DB =====
            ProductDAO dao = new ProductDAO();
            boolean inserted = dao.addProduct(product);

            // ===== Điều hướng hiển thị thông báo =====
            if (inserted) {
                response.sendRedirect(request.getContextPath() + "/admin/productManagement?add=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/productManagement?add=fail");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/productManagement?add=formaterror");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/productManagement?add=exception");
        }
    }
}


