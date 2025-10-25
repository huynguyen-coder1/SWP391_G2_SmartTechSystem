<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page import="model.Brand" %>
<%@ page import="dao.CategoryDAO" %>
<%@ page import="dao.BrandDAO" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TechMart Header</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* Tổng quan */
        body { margin:0; font-family:'Roboto',sans-serif; }

        /* Header sticky */
        header {
            position: sticky;
            top: 0;
            z-index: 1200;
            background-color: #18498d;
            transition: all .25s ease;
            box-shadow: 0 2px 6px rgba(0,0,0,0.12);
        }
        header.scrolled { background-color:#153b73; box-shadow:0 6px 18px rgba(0,0,0,0.2); }

        .container-header {
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:20px;
            padding:12px 16px;
            max-width:1200px;
            margin:0 auto;
        }

        /* Logo */
        .logo-wrap { display:flex; align-items:center; gap:10px; flex:0 0 auto; }
        .logo-wrap img { height:48px; width:auto; display:block; }
        .brand { color:#ff9800; font-weight:700; font-size:20px; letter-spacing:0.4px; }

        /* Menu chính (giữa) */
        .main-menu { display:flex; align-items:center; gap:18px; flex:1 1 auto; justify-content:center; }
        .main-menu a, .main-menu .dropdown-toggle {
            color:#fff; text-decoration:none; font-weight:600; padding:6px 6px;
        }
        .main-menu a:hover, .main-menu .dropdown-toggle:hover { color:#ffd54f; }

        /* Đặt dropdown parent relative để menu con căn chính giữa trigger */
        .main-menu .dropdown { position:relative; }

        /* Dropdown: căn giữa, fixed width, không tràn */
        .main-menu .dropdown-menu {
            position:absolute;
            top: calc(100% + 8px);
            left: 50%;
            transform: translateX(-50%);
            background-color: #122f5f !important; /* xanh đậm */
            border: 1px solid rgba(0,0,0,0.15) !important;
            border-radius:8px;
            padding:6px 6px;
            min-width:170px;
            max-width:260px;
            box-shadow:0 8px 18px rgba(0,0,0,0.25);
            white-space:normal; /* cho phép xuống dòng nếu quá dài */
            z-index:1300;
        }

        .main-menu .dropdown-menu::before {
            content: "";
            position: absolute;
            top: -6px;
            left: 50%;
            transform: translateX(-50%);
            border: 6px solid transparent;
            border-bottom-color: #122f5f;
            z-index:1301;
        }

        .dropdown-item {
            color:#f1f5f9 !important;
            background:transparent !important;
            padding:10px 14px;
            border-radius:6px;
            display:block;
            transition: all .18s ease;
            font-weight:600;
        }

        .dropdown-item:hover {
            background: #ff9800 !important;
            color:#ffffff !important;
            transform: translateX(6px);
        }

        /* Nếu viewport nhỏ: đặt dropdown full width trong container */
        @media (max-width: 767px) {
            .container-header { padding:10px; }
            .main-menu { justify-content:flex-start; gap:10px; overflow:auto; padding-left:6px; }
            .main-menu .dropdown-menu { left: 0; transform: none; min-width:160px; }
        }

        /* Khung phải: account + cart */
        .account-wrap { display:flex; align-items:center; gap:10px; flex:0 0 auto; }
        .account-wrap a { color:#fff; text-decoration:none; font-weight:500; }
        .account-wrap a:hover { color:#ffd54f; }
        .btn-join { background:#ff9800; color:#fff; border-radius:6px; padding:6px 10px; border:none; font-weight:700; }
        .btn-join:hover { background:#e68a00; }

        /* Thanh tìm kiếm */
        .search-row { background:#153b73; padding:10px 0; box-shadow:inset 0 -1px 0 rgba(255,255,255,0.04); }
        .search-wrap { max-width:1100px; margin:0 auto; display:flex; justify-content:center; }
        .search-box { display:flex; width:70%; max-width:900px; }
        .search-box input {
            flex:1; padding:10px 16px; border-radius:30px 0 0 30px; border:none; outline:none; font-size:15px;
        }
        .search-box button {
            background:#ff9800; border:none; padding:10px 18px; border-radius:0 30px 30px 0; color:#fff; font-weight:700;
        }

    </style>
</head>
<body>
<header id="siteHeader">
    <div class="container-header">
        <!-- Logo -->
        <div class="logo-wrap">
            <a href="<%= request.getContextPath() %>/home.jsp" style="display:flex;align-items:center;gap:10px;text-decoration:none;">
                <img src="<%= request.getContextPath() %>/images/logo.png" alt="TechMart">
                <span class="brand">TechMart</span>
            </a>
        </div>

        <!-- Menu chính -->
        <nav class="main-menu" aria-label="Main menu">
            <a href="<%= request.getContextPath() %>/home.jsp">Trang chủ</a>

            <!-- Danh sách sản phẩm -->
            <div class="dropdown">
                <a class="dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    Danh sách sản phẩm
                </a>
                <ul class="dropdown-menu" aria-labelledby="categoryMenu">
                    <%
                        CategoryDAO cdao = new CategoryDAO();
                        List<Category> categories = cdao.getAllCategories();
                        for (Category c : categories) {
                    %>
                    <li>
                       <a class="dropdown-item" href="<%= request.getContextPath() %>/ProductListServlet?categoryId=<%= c.getCategoryId() %>">
                            <%= c.getCategoryName() %>
                       </a>
                    </li>
                    <% } %>
                </ul>
            </div>

            <!-- Thương hiệu -->
            <div class="dropdown">
                <a class="dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    Thương hiệu sản phẩm
                </a>
                <ul class="dropdown-menu">
                    <%
                        BrandDAO bdao = new BrandDAO();
                        List<Brand> brands = bdao.getAllBrands();
                        for (Brand b : brands) {
                    %>
                    <li>
                        <a class="dropdown-item" href="<%= request.getContextPath() %>/ProductListServlet?brandId=<%= b.getBrandId() %>">
                            <%= b.getBrandName() %>
                        </a>
                    </li>
                    <% } %>
                </ul>
            </div>
        </nav>

        <!-- Tài khoản / giỏ hàng -->
        <div class="account-wrap">
            <%
                model.User currentUser = (model.User) session.getAttribute("currentUser");
                if (currentUser != null) {
            %>
                <a href="<%= request.getContextPath() %>/account/profile.jsp"><i class="fa-solid fa-user"></i>&nbsp;<%= currentUser.getFullName()!=null?currentUser.getFullName():currentUser.getEmail() %></a>
                 <!-- ✅ Nút My Orders nằm ngay cạnh profile -->
        <a href="<%= request.getContextPath() %>/myOrders"
           class="btn btn-outline-light btn-sm fw-bold"
           style="border-radius:6px; padding:6px 10px;">
            <i class="fa-solid fa-box"></i>&nbsp;My Orders
        </a>
                <form action="<%= request.getContextPath() %>/logout" method="get" style="display:inline;">
                    <button type="submit" class="btn-join">Đăng xuất</button>
                </form>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/account/login.jsp">Đăng nhập</a>
                <a class="btn-join" href="<%= request.getContextPath() %>/account/register.jsp">Đăng ký</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/cart" title="Giỏ hàng" style="color:#fff;">
                <i class="fa-solid fa-cart-shopping"></i>
            </a>
        </div>
    </div>
               

    <!-- Thanh tìm kiếm -->
    <div class="search-row">
        <div class="search-wrap">
            <form action="<%= request.getContextPath() %>/search" method="get" class="search-box">
                <input type="text" name="query" placeholder="Tìm kiếm sản phẩm, thương hiệu, mã..." aria-label="Tìm kiếm">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i>&nbsp;Tìm kiếm</button>
            </form>
        </div>
    </div>
</header>

<script>
    // Thêm hiệu ứng đổi màu khi cuộn
    window.addEventListener('scroll', function() {
        var h = document.getElementById('siteHeader');
        if (window.scrollY > 20) h.classList.add('scrolled');
        else h.classList.remove('scrolled');
    });

    // ===== Dropdown mở khi di chuột hoặc bấm =====
    document.querySelectorAll('.main-menu .dropdown').forEach(function(dropdown) {
        const toggle = dropdown.querySelector('.dropdown-toggle');
        const menu = dropdown.querySelector('.dropdown-menu');
        let hideTimeout;

        // Khi bấm vào nút => toggle hiển thị
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            const isShown = dropdown.classList.contains('show');
            document.querySelectorAll('.main-menu .dropdown.show').forEach(d => {
                d.classList.remove('show');
                d.querySelector('.dropdown-menu').classList.remove('show');
            });

            if (!isShown) {
                dropdown.classList.add('show');
                menu.classList.add('show');
            }
        });

        // Khi rê chuột vào => hiển thị menu
        dropdown.addEventListener('mouseenter', function() {
            clearTimeout(hideTimeout);
            dropdown.classList.add('show');
            menu.classList.add('show');
        });

        // Khi rê ra => đợi 300ms rồi ẩn (nếu không hover lại)
        dropdown.addEventListener('mouseleave', function() {
            hideTimeout = setTimeout(() => {
                dropdown.classList.remove('show');
                menu.classList.remove('show');
            }, 20);
        });
    });

    // Khi click ra ngoài menu => ẩn toàn bộ dropdown
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.main-menu .dropdown')) {
            document.querySelectorAll('.main-menu .dropdown.show').forEach(dropdown => {
                dropdown.classList.remove('show');
                dropdown.querySelector('.dropdown-menu').classList.remove('show');
            });
        }
    });
</script>
</body>
</html>
