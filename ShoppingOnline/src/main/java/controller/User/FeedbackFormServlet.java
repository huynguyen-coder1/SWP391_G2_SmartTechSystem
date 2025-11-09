package controller.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Product;
import model.Review;
import dao.ProductDAO;
import dao.ReviewDAO;
import dao.OrderDAO;

@WebServlet(name = "FeedbackFormServlet", urlPatterns = {"/user/feedbackForm"})
public class FeedbackFormServlet extends HttpServlet {

    private ProductDAO productDAO;
    private ReviewDAO reviewDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        reviewDAO = new ReviewDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String productParam = request.getParameter("productId");
            String orderParam = request.getParameter("orderId");
            String userParam = request.getParameter("userId");

            if (productParam == null || orderParam == null || userParam == null) {
                response.sendRedirect(request.getContextPath() + "/myOrders?error=invalidparams");
                return;
            }

            long productId = Long.parseLong(productParam);
            long orderId = Long.parseLong(orderParam);
            int userId = Integer.parseInt(userParam);

            // Kiểm tra quyền đánh giá
            if (!orderDAO.userBoughtProduct(userId, orderId, productId)) {
                response.sendRedirect(request.getContextPath() + "/myOrders?error=notallowed");
                return;
            }

            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/myOrders?error=noproduct");
                return;
            }

            request.setAttribute("product", product);
            request.setAttribute("orderId", orderId);
            request.setAttribute("userId", userId);

            request.getRequestDispatcher("/user/feedbackForm.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/myOrders?error=invalidparams");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/myOrders?error=server");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            long productId = Long.parseLong(request.getParameter("productId"));
            long orderId = Long.parseLong(request.getParameter("orderId"));
            int userId = Integer.parseInt(request.getParameter("userId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            if (rating < 1 || rating > 5) rating = 5;
            if (comment == null) comment = "";
            comment = comment.trim();

            if (!orderDAO.userBoughtProduct(userId, orderId, productId)) {
                response.sendRedirect(request.getContextPath() + "/myOrders?error=notallowed");
                return;
            }

            Review review = new Review();
            review.setUserId(userId);
            review.setProductId(productId);
            review.setRating(rating);
            review.setComment(comment);

            boolean success = reviewDAO.insertReview(review);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/myOrders?success=reviewed");
            } else {
                response.sendRedirect(request.getContextPath() + "/myOrders?error=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/myOrders?error=server");
        }
    }
}
