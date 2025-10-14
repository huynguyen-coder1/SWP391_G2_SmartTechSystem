package controller.Brand;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.BrandDAO;
import model.Brand;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/brandManagement")
public class BrandManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BrandDAO brandDAO;

    @Override
    public void init() throws ServletException {
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String search = request.getParameter("search");
        String statusFilter = request.getParameter("statusFilter");

        try {
            List<Brand> brandList = brandDAO.filterBrands(search, statusFilter);
            request.setAttribute("brandList", brandList);
            request.getRequestDispatcher("/admin/brandManagement.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách thương hiệu!");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
