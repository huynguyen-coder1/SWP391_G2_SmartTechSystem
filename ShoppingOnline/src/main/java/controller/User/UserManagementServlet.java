package controller.User;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;

@WebServlet("/admin/userManagement")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số tìm kiếm và trạng thái
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("statusFilter");

        // Gọi DAO để lấy danh sách user
        UserDAO dao = new UserDAO();
        List<User> userList = dao.filterUsers(search, statusFilter);

        // Gửi danh sách sang JSP
        request.setAttribute("userList", userList);

        // Forward sang trang JSP hiển thị
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/userManagement.jsp");
        dispatcher.forward(request, response);
    }
    
}
