package controller.Authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import dao.ProductDAO;
import dao.CategoryDAO;
import dao.BrandDAO;
import model.Product;
import model.Category;
import model.Brand;

@WebServlet("/admin/productManagement")
@MultipartConfig   // 👉 thêm dòng này để servlet hỗ trợ upload file
public class ProductManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private BrandDAO brandDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");

            if (action != null) {
                switch (action) {
                    // ================== XÓA SẢN PHẨM ==================
                    case "delete": {
                        String idStr = request.getParameter("id");
                        if (idStr != null && !idStr.isEmpty()) {
                            long id = Long.parseLong(idStr);
                            boolean deleted = productDAO.deleteProduct(id);

                            if (deleted) {
                                response.sendRedirect(request.getContextPath()
                                        + "/admin/productManagement?delete=success");
                            } else {
                                response.sendRedirect(request.getContextPath()
                                        + "/admin/productManagement?delete=fail");
                            }
                            return;
                        }
                        break;
                    }

                    // ================== CHỈNH SỬA SẢN PHẨM ==================
                    case "edit": {
                        String idStr = request.getParameter("id");
                        if (idStr != null && !idStr.isEmpty()) {
                            int productId = Integer.parseInt(idStr);
                            Product product = productDAO.getProductById(productId);

                            if (product == null) {
                                response.sendRedirect(request.getContextPath()
                                        + "/admin/productManagement?edit=notfound");
                                return;
                            }

                            List<Category> categoryList = categoryDAO.getAllCategories();
                            List<Brand> brandList = brandDAO.getAllBrands();

                            request.setAttribute("product", product);
                            request.setAttribute("categoryList", categoryList);
                            request.setAttribute("brandList", brandList);
                            request.getRequestDispatcher("/admin/editProduct.jsp").forward(request, response);
                            return;
                        }
                        break;
                    }

                    // ================== THÊM SẢN PHẨM (HIỂN THỊ FORM) ==================
                    case "add": {
                        List<Category> categoryList = categoryDAO.getAllCategories();
                        List<Brand> brandList = brandDAO.getAllBrands();

                        // 🩷 Đọc danh sách ảnh có sẵn trong thư mục /images
                        String imagePath = getServletContext().getRealPath("/images");
                        File folder = new File(imagePath);
                        java.util.List<String> imageList = new java.util.ArrayList<>();

                        if (folder.exists() && folder.isDirectory()) {
                            for (File file : folder.listFiles()) {
                                if (file.isFile() && !file.isHidden()) {
                                    imageList.add(file.getName());
                                }
                            }
                        }

                        // Gửi dữ liệu sang JSP
                        request.setAttribute("categoryList", categoryList);
                        request.setAttribute("brandList", brandList);
                        request.setAttribute("imageList", imageList);

                        request.getRequestDispatcher("/admin/addProduct.jsp").forward(request, response);
                        return;
                    }

                    default:
                        break;
                }
            }

            // ================== LỌC & TÌM KIẾM ==================
            String search = request.getParameter("search");
            String categoryFilter = request.getParameter("categoryId");
            String statusFilter = request.getParameter("status");

            List<Product> productList;
            if ((search != null && !search.trim().isEmpty())
                    || (categoryFilter != null && !categoryFilter.isEmpty())
                    || (statusFilter != null && !statusFilter.isEmpty())) {
                productList = productDAO.searchProducts(search, categoryFilter, statusFilter);
            } else {
                productList = productDAO.getAllProducts();
            }

            List<Category> categoryList = categoryDAO.getAllCategories();
            List<Brand> brandList = brandDAO.getAllBrands();

            request.setAttribute("productList", productList);
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("brandList", brandList);

            request.getRequestDispatcher("/admin/productManagement.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/admin/productManagement.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");

            // ================== THÊM SẢN PHẨM ==================
            if ("add".equals(action)) {
                String productCode = request.getParameter("productCode");
                String productName = request.getParameter("productName");
                String description = request.getParameter("description");
                String priceImportStr = request.getParameter("priceImport");
                String priceStr = request.getParameter("price");
                String quantityStr = request.getParameter("quantity");
                String categoryIdStr = request.getParameter("categoryId");
                String brandIdStr = request.getParameter("brandId");
                String statusStr = request.getParameter("status");

                // 👉 Xử lý ảnh
                Part filePart = request.getPart("imageFile");
                String selectedImage = request.getParameter("images");
                String imageName = null;

                // Ưu tiên: upload mới > ảnh có sẵn > ảnh mặc định
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName();
                    String uploadPath = getServletContext().getRealPath("/images");

                    // đảm bảo thư mục tồn tại
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    filePart.write(uploadPath + File.separator + fileName);
                    imageName = fileName;

                } else if (selectedImage != null && !selectedImage.trim().isEmpty()) {
                    imageName = selectedImage;
                } else {
                    imageName = "default.png";
                }

                if (productCode == null || productCode.isEmpty()
                        || productName == null || productName.isEmpty()
                        || priceStr == null || priceStr.isEmpty()
                        || quantityStr == null || quantityStr.isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/productManagement?add=missing");
                    return;
                }

                BigDecimal priceImport = new BigDecimal(priceImportStr);
                BigDecimal price = new BigDecimal(priceStr);
                int quantity = Integer.parseInt(quantityStr);
                int categoryId = Integer.parseInt(categoryIdStr);
                int brandId = Integer.parseInt(brandIdStr);
                int status = Integer.parseInt(statusStr);

                Product newProduct = new Product();
                newProduct.setProductCode(productCode);
                newProduct.setProductName(productName);
                newProduct.setDescription(description);
                newProduct.setPriceImport(priceImport);
                newProduct.setPrice(price);
                newProduct.setQuantity(quantity);
                newProduct.setCategoryId(categoryId);
                newProduct.setBrandId(brandId);
                newProduct.setStatus(status);
                newProduct.setImages(imageName);

                boolean success = productDAO.addProduct(newProduct);

                if (success) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/productManagement?add=success");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/productManagement?add=fail");
                }
                return;
            }

            // ================== CẬP NHẬT (UPDATE) SẢN PHẨM ==================
            if ("update".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                String productCode = request.getParameter("productCode");
                String productName = request.getParameter("productName");
                String description = request.getParameter("description");
                BigDecimal priceImport = new BigDecimal(request.getParameter("priceImport"));
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                int status = Integer.parseInt(request.getParameter("status"));

                Part filePart = request.getPart("imageFile");
                String selectedImage = request.getParameter("images");
                String imageName = null;

                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName();
                    String uploadPath = getServletContext().getRealPath("/images");

                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    filePart.write(uploadPath + File.separator + fileName);
                    imageName = fileName;

                } else if (selectedImage != null && !selectedImage.trim().isEmpty()) {
                    imageName = selectedImage;
                } else {
                    imageName = "default.png";
                }

                Product updatedProduct = new Product();
                updatedProduct.setProductId(productId);
                updatedProduct.setProductCode(productCode);
                updatedProduct.setProductName(productName);
                updatedProduct.setDescription(description);
                updatedProduct.setPriceImport(priceImport);
                updatedProduct.setPrice(price);
                updatedProduct.setQuantity(quantity);
                updatedProduct.setCategoryId(categoryId);
                updatedProduct.setBrandId(brandId);
                updatedProduct.setStatus(status);
                updatedProduct.setImages(imageName);

                boolean success = productDAO.updateProduct(updatedProduct);

                if (success) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/productManagement?update=success");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/productManagement?update=fail");
                }
                return;
            }

            // Mặc định quay lại danh sách
            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/productManagement?error=true");
        }
    }
}


