package controller.Brand;

import dao.BrandDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Brand;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/admin/addBrand")
public class AddBrandServlet extends HttpServlet {
    private BrandDAO brandDAO;

    @Override
    public void init() {
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("brandName");
        String description = request.getParameter("description");
        int status = Integer.parseInt(request.getParameter("status"));

        Brand b = new Brand();
        b.setBrandName(name);
        b.setDescription(description);
        b.setStatus(status);
        b.setCreatedAt(Timestamp.valueOf(LocalDateTime.now()));
        b.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));

        brandDAO.addBrand(b);

        response.sendRedirect(request.getContextPath() + "/admin/brandManagement");
    }
}
