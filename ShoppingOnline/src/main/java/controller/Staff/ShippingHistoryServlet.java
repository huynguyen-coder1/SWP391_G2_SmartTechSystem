package controller.Staff;

import dao.ShippingHistoryDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/staff/shippinghistory")
public class ShippingHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ShippingHistoryDAO dao = new ShippingHistoryDAO();
        List<Map<String, Object>> historyList = dao.getAllShippingHistory();

        request.setAttribute("historyList", historyList);
        RequestDispatcher rd = request.getRequestDispatcher("/staff/shippingHistory.jsp");
        rd.forward(request, response);
    }
}
