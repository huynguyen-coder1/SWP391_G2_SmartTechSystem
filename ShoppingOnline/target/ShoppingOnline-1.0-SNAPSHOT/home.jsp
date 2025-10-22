<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="model.Product" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TechMart - Trang chủ</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Roboto -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f6f8fb;
            color: #333;
            margin: 0;
            padding: 0;
        }

        /* Header cố định */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        main {
            padding-top: 160px;
            padding-bottom: 60px;
        }

        h2.section-title {
            font-weight: 700;
            color: #18498d;
            margin-bottom: 40px;
            position: relative;
            display: inline-block;
        }

        h2.section-title::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: -10px;
            width: 60%;
            height: 3px;
            background-color: #ff9800;
            border-radius: 3px;
        }

        /* Banner */
        .carousel-item img {
            width: 100%;
            height: 420px;
            object-fit: cover;
        }

        /* Thẻ sản phẩm */
        .product-card {
            background: #fff;
            border-radius: 12px;
            border: none;
            padding: 18px 15px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            text-align: center;
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .product-img {
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            margin-bottom: 12px;
        }

        .product-img img {
            max-width: 100%;
            max-height: 100%;
            transition: transform 0.4s ease;
        }

        .product-card:hover img {
            transform: scale(1.05);
        }

        .product-name {
            font-size: 16px;
            font-weight: 600;
            color: #222;
            margin-top: 6px;
            height: 45px;
            overflow: hidden;
        }

        .price {
            font-size: 15px;
            margin: 8px 0;
        }

        .price .new-price {
            color: #e53935;
            font-weight: 700;
        }

        .price .old-price {
            text-decoration: line-through;
            color: #999;
            margin-left: 6px;
            font-size: 14px;
        }

        .product-actions {
            margin-top: 10px;
        }

        .product-actions button,
        .product-actions a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            margin: 0 6px;
            border-radius: 50%;
            background-color: #f2f3f5;
            color: #333;
            border: none;
            transition: all 0.3s ease;
        }

        .product-actions button:hover,
        .product-actions a:hover {
            background-color: #ff9800;
            color: #fff;
        }

        @media (max-width: 768px) {
            main { padding-top: 140px; }
            .product-img { height: 160px; }
            .carousel-item img { height: 260px; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <%@ include file="/includes/header.jsp" %>
    </div>

    <main>
        <!-- Banner trượt -->
        <div id="mainBanner" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3000">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="${pageContext.request.contextPath}/images/banner1.png" class="d-block w-100" alt="Banner 1">
                </div>
                <div class="carousel-item">
                    <img src="${pageContext.request.contextPath}/images/banner2.jpg" class="d-block w-100" alt="Banner 2">
                </div>
                <div class="carousel-item">
                    <img src="${pageContext.request.contextPath}/images/banner3.jpg" class="d-block w-100" alt="Banner 3">
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#mainBanner" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#mainBanner" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>

        <!-- Danh sách sản phẩm -->
        <div class="container mt-5">
            <h2 class="section-title">Sản phẩm mới</h2>
            <div class="row g-4">
                <%
                    ProductDAO dao = new ProductDAO();
                    List<Product> products = dao.getAllProducts();

                    if (products != null && !products.isEmpty()) {
                        for (Product p : products) {
                %>
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <div class="product-card">
                        <div class="product-img">
                            <img src="${pageContext.request.contextPath}/images/<%= p.getImages()%>"
                                 alt="<%= p.getProductName()%>">
                        </div>

                        <h3 class="product-name"><%= p.getProductName()%></h3>

                        <div class="price">
                            <%
                                java.text.NumberFormat currencyVN
                                        = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
                                String priceFormatted = currencyVN.format(p.getPrice());
                            %>
                            <span class="new-price"><%= priceFormatted %></span>
                        </div>

                        <div class="product-actions">
                            <form action="<%= request.getContextPath()%>/cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="<%= p.getProductId()%>">
                                <button type="submit" title="Thêm vào giỏ">
                                    <i class="fa-solid fa-cart-plus"></i>
                                </button>
                            </form>

                            <a href="<%= request.getContextPath()%>/user/productDetail.jsp?id=<%= p.getProductId()%>" 
                               title="Xem chi tiết">
                                <i class="fa-regular fa-eye"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <p>Không có sản phẩm nào.</p>
                <%
                    }
                %>
            </div>
        </div>
    </main>

    <%@ include file="/includes/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

