package controller.Staff;

import dao.ShippingHistoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ShippingHistory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ShippingHistoryServlet", urlPatterns = {"/staff/shippinghistory"})
public class ShippingHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 🔹 Lấy tham số tìm kiếm và trạng thái từ form
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        ShippingHistoryDAO dao = new ShippingHistoryDAO();
        List<ShippingHistory> shippingHistoryList = dao.getShippingHistory(search, status);

        // Trả lại dữ liệu + trạng thái hiện tại để giữ lại lựa chọn trong form
        request.setAttribute("shippingHistoryList", shippingHistoryList);
        request.setAttribute("currentSearch", search);
        request.setAttribute("currentStatus", status);

        request.getRequestDispatcher("/staff/shippingHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}