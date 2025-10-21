<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page import="dao.CategoryDAO" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>TechMart Header</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/header.css"> 
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body>
<header class="header-bg">
    <div class="header-row row-top">
        <div class="container">
            <div class="row header-top">
                <div class="col-sm-6">
                    <div class="logo">
                        <a href="home.jsp">
                            <img src="<%= request.getContextPath()%>/images/logo.png" alt="logo"/>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="header-row row-bottom">
        <div class="container">
            <div class="row header-menu">
                <div class="col-8 menu-wrapper">
                    <div class="item"><a href="<%= request.getContextPath()%>/home.jsp"><i class="fa-solid fa-house"></i></a></div>
                    <div class="item"><a href="<%= request.getContextPath()%>/home.jsp">Trang chủ</a></div>
                    <div class="dropdown item">
                        <a class="dropdown-toggle text-white text-decoration-none" href="#" id="categoryMenu"
                           role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Danh sách sản phẩm
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="categoryMenu">
                            <%
                                dao.CategoryDAO cdao = new dao.CategoryDAO();
                                List<model.Category> list = cdao.getAllCategories();
                                for (model.Category c : list) {
                            %>
                            <li>
                                <a class="dropdown-item" href="<%= request.getContextPath()%>/products?categoryId=<%= c.getCategoryId()%>">
                                    <%= c.getCategoryName()%>
                                </a>
                            </li>
                            <%
                                }
                            %>
                        </ul>
                    </div>

                    <div class="item"><a href="<%= request.getContextPath()%>/intro/introduce.jsp">Laptop</a></div>
                    <div class="item"><a href="<%= request.getContextPath()%>/intro/introduce.jsp">Keyboard</a></div>
                    <div class="item"><a href="<%= request.getContextPath()%>/intro/policy.jsp">Mouse</a></div>
                    <div class="item"><a href="<%= request.getContextPath()%>/intro/terms.jsp">Accessories</a></div>
                </div>

                <!-- Cột phải: tài khoản + giỏ hàng -->
                <div class="col-4 box-account d-flex justify-content-end align-items-center">
                    <%
                        model.User currentUser = (model.User) session.getAttribute("currentUser");
                        if (currentUser != null) {
                    %>
                        <!-- Khi user đã đăng nhập -->
                        <div class="user-info d-flex align-items-center gap-3">
                            <div class="user-name text-white">
                                <i class="fa-solid fa-user"></i>
                                <a href="<%= request.getContextPath()%>/account/profile.jsp" 
                                   class="text-white text-decoration-none ms-1">
                                    <%= currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getEmail()%>
                                </a>
                            </div>
                        </div>

                        <!-- 🟢 Nút My Orders (chỉ hiện khi đăng nhập) -->
                        <a href="<%= request.getContextPath()%>/myOrders" 
                           class="order-tile text-center me-3 ms-3" 
                           style="color: white; text-decoration: none;">
                            <span class="label text-white fw-bold">My Orders</span><br>
                            <i class="fa-solid fa-box fa-2x text-white"></i>
                        </a>

                        <!-- 🟡 Đăng xuất -->
                        <a href="<%= request.getContextPath()%>/logout" class="btn btn-warning btn-sm ms-2">
                            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                        </a>

                    <%
                        } else {
                    %>
                        <!-- 🟥 Nếu chưa đăng nhập -->
                        <div class="account item">
                            <a class="register me-2" href="<%= request.getContextPath()%>/account/register.jsp">Đăng ký</a>
                            <a href="<%= request.getContextPath()%>/account/login.jsp">Đăng nhập</a>
                        </div>
                    <%
                        }
                    %>

                    <!-- 🛒 Giỏ hàng (luôn hiển thị) -->
                    <div class="search-header item ms-3">
                        <a href="cart" class="text-white text-decoration-none">
                            <span>Your Cart</span>
                            <i class="fa-solid fa-cart-shopping"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
</body>
</html>
