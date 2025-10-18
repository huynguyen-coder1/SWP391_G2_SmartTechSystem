package controller.Authentication;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewProfileServlet", urlPatterns = {"/admin/viewProfile"})
public class ViewProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/staffManagement");
                return;
            }

            int userId = Integer.parseInt(idParam);
            System.out.println(">>> ViewProfileServlet: idParam = " + idParam);
            User user = userDAO.getUserById(userId);
            System.out.println(">>> user = " + (user != null ? user.getFullName() : "null"));

            if (user == null) {
                request.setAttribute("error", "Không tìm thấy thông tin người dùng!");
                request.getRequestDispatcher("/admin/viewProfile.jsp").forward(request, response);
                return;
            }

            request.setAttribute("user", user);
            request.getRequestDispatcher("/admin/viewProfile.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "ID người dùng không hợp lệ!");
            request.getRequestDispatcher("/admin/viewProfile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tải thông tin người dùng!");
            request.getRequestDispatcher("/admin/viewProfile.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị thông tin chi tiết người dùng cho admin xem";
    }
}
