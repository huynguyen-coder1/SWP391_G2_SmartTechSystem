<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TechMart - Sản phẩm</title>

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
            padding-top: 150px;
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

        .product-card {
            background: #fff;
            border-radius: 12px;
            border: none;
            padding: 18px 15px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            text-align: center;
            transition: all 0.3s ease;
            overflow: hidden;
            position: relative;
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
            main { padding-top: 130px; }
            .product-img { height: 160px; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <%@ include file="/includes/header.jsp" %>
    </div>

    <main>
        <div class="container">
            <h2 class="section-title">
                <c:choose>
                    <c:when test="${not empty keyword}">
                        🔍 Kết quả tìm kiếm cho "<c:out value='${keyword}'/>"
                    </c:when>
                    <c:when test="${not empty selectedCategory}">
                        📂 Sản phẩm thuộc danh mục
                        <strong><c:out value="${categoryName}" /></strong>
                    </c:when>
                    <c:when test="${not empty selectedBrand}">
                        🏷️ Sản phẩm theo thương hiệu
                        <strong><c:out value="${brandName}" /></strong>
                    </c:when>
                    <c:otherwise>
                        🛒 Tất cả sản phẩm
                    </c:otherwise>
                </c:choose>
            </h2>

            <c:if test="${empty productList}">
                <p>Không tìm thấy sản phẩm nào phù hợp.</p>
            </c:if>

            <div class="row g-4">
                <c:forEach var="p" items="${productList}">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card">
                            <div class="product-img">
                                <img src="${pageContext.request.contextPath}/images/${p.images}" 
                                     alt="${p.productName}">
                            </div>
                            <h3 class="product-name">${p.productName}</h3>
                            <div class="price">
                                <span class="new-price">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                </span>
                            </div>
                            <div class="product-actions">
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button type="submit" title="Thêm vào giỏ">
                                        <i class="fa-solid fa-cart-plus"></i>
                                    </button>
                                </form>
                                <a href="${pageContext.request.contextPath}/user/productDetail.jsp?id=${p.productId}" title="Xem chi tiết">
                                    <i class="fa-regular fa-eye"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>

    <%@ include file="/includes/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
