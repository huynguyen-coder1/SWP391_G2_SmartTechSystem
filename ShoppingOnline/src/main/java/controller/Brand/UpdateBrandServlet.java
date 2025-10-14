package controller.Brand;

import dao.BrandDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Brand;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/admin/updateBrand")
public class UpdateBrandServlet extends HttpServlet {
    private BrandDAO brandDAO;

    @Override
    public void init() {
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                long brandId = Long.parseLong(idParam);
                Brand brand = brandDAO.getBrandById(brandId);
                if (brand != null) {
                    request.setAttribute("brand", brand);
                    request.getRequestDispatcher("/admin/updateBrand.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/brandManagement");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String brandIdParam = request.getParameter("brandId");
        if (brandIdParam == null || brandIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/brandManagement");
            return;
        }

        try {
            long brandId = Long.parseLong(brandIdParam);
            String brandName = request.getParameter("brandName");
            String description = request.getParameter("description");
            int status = Integer.parseInt(request.getParameter("status"));

            Brand brand = new Brand();
            brand.setBrandId(brandId);
            brand.setBrandName(brandName);
            brand.setDescription(description);
            brand.setStatus(status);
            brand.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));

            brandDAO.updateBrand(brand);

        } catch (NumberFormatException e) {
        }

        response.sendRedirect(request.getContextPath() + "/admin/brandManagement");
    }
}
