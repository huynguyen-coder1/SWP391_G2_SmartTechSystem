package controller.Authentication; 

import dao.ReviewDAO;
import model.Review;


import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;



@WebServlet(name = "ReviewManagementServlet", urlPatterns = {"/admin/reviewManagement"})
public class ReviewManagementServlet extends HttpServlet {

    private ReviewDAO reviewDAO = new ReviewDAO();

    /**
     * Hiển thị danh sách review
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tất cả review
        List<Review> reviews = reviewDAO.getAllReviews();
        request.setAttribute("reviews", reviews);

        // Forward sang JSP
        request.getRequestDispatcher("/admin/reviewManagement.jsp").forward(request, response);
    }

    /**
     * Xử lý toggle ẩn/hiện review
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy reviewId và trạng thái từ form
        String idStr = request.getParameter("id");
        String statusStr = request.getParameter("status");

        if (idStr != null && statusStr != null) {
            try {
                long id = Long.parseLong(idStr);
                int status = Integer.parseInt(statusStr);
                reviewDAO.updateStatus(id, status);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Quay lại trang review management
        response.sendRedirect(request.getContextPath() + "/admin/reviewManagement");
    }

    @Override
    public String getServletInfo() {
        return "Servlet quản lý feedback/ review cho admin";
    }
}

