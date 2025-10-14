package controller.Brand;

import dao.BrandDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteBrandServlet", urlPatterns = {"/DeleteBrandServlet"})
public class DeleteBrandServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy brandId từ URL
        String idStr = request.getParameter("brandId");

        // Kiểm tra nếu không có id
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/brandManagement?error=missing_id");
            return;
        }

        try {
            long brandId = Long.parseLong(idStr);
            BrandDAO dao = new BrandDAO();
            boolean deleted = dao.deleteBrand(brandId);

            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/brandManagement?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/brandManagement?error=not_found");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/brandManagement?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/brandManagement?error=server_error");
        }
    }
}
