package controller.Staff;

import dao.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;


public class OrderManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

     
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        
        OrderDAO orderDAO = new OrderDAO();
        List<Map<String, Object>> orders = orderDAO.getAllOrdersWithUser();

      
        System.out.println("Orders size = " + orders.size());
        for (Map<String, Object> o : orders) {
            System.out.println(o);
        }

     
        request.setAttribute("orders", orders);

      
       RequestDispatcher rd = request.getRequestDispatcher("/staff/staffPage.jsp");

        rd.forward(request, response);
    }
}
