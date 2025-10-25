package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // --- Redirect "/" hoặc "/home.jsp" theo role ---
        if (path.equals("/") || path.equals("/home.jsp")) {
            if (currentUser != null) {
                if (currentUser.isAdmin()) {
                    res.sendRedirect(req.getContextPath() + "/AdminDashboardServlet");
                    return;
                } else if (currentUser.isStaff()) {
                    res.sendRedirect(req.getContextPath() + "/ordermanagement");
                    return;
                } else if (currentUser.isShipper()) {
                    res.sendRedirect(req.getContextPath() + "/shipper/shipperPage");
                    return;
                }
            }
        }

        // --- Cho phép truy cập trang công khai ---
        if (path.equals("/about") ||
            path.startsWith("/account/login") ||
            path.startsWith("/account/register") ||
            path.startsWith("/assets/") ||
            path.startsWith("/css/") ||
            path.startsWith("/js/") ||
            path.startsWith("/images/")) {

            chain.doFilter(request, response);
            return;
        }

        // --- Kiểm soát quyền truy cập admin ---
        if (path.startsWith("/admin")) {
            if (currentUser == null || !currentUser.isAdmin()) {
                res.sendRedirect(req.getContextPath() + "/account/login.jsp");
                return;
            }
        }

        // --- Kiểm soát quyền truy cập staff ---
        if (path.startsWith("/staff")) {
            if (currentUser == null || !currentUser.isStaff()) {
                res.sendRedirect(req.getContextPath() + "/account/login.jsp");
                return;
            }
        }

        // --- Kiểm soát quyền truy cập shipper ---
        if (path.startsWith("/shipper")) {
            if (currentUser == null || !currentUser.isShipper()) {
                res.sendRedirect(req.getContextPath() + "/account/login.jsp");
                return;
            }
        }

        // --- Các request khác ---
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { }
}
