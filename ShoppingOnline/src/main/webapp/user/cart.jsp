<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng - TechMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: "Roboto", sans-serif;
        }
        .cart-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .btn-back {
            background-color: #f1f1f1;
            color: #333;
            border: none;
            padding: 8px 18px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-back i {
            margin-right: 6px;
        }
        .btn-back:hover {
            background-color: #e0e0e0;
            color: #000;
            transform: translateX(-3px);
        }
        .progress-steps {
            background-color: #fdeaea;
        }
        table th, table td {
            vertical-align: middle;
        }
        .btn-sm {
            padding: 4px 10px;
        }
    </style>
</head>

<body>
    <div class="header">
        <%@ include file="/includes/header.jsp" %>
    </div>

    <main class="container mt-5 pt-5">
        <!-- 🔙 Nút quay lại -->
        <a href="home.jsp" class="btn-back mb-4 d-inline-block">
            <i class="fa-solid fa-arrow-left"></i> Quay lại mua sắm
        </a>

        <!-- Bước tiến trình -->
        <div class="progress-steps mb-4 p-3 rounded text-center">
            <ul class="nav justify-content-center">
                <li class="nav-item text-center me-4">
                    <i class="fa-solid fa-bag-shopping text-danger"></i><br>
                    <span class="fw-bold text-danger">Giỏ hàng</span>
                </li>
                <li class="nav-item text-center me-4">
                    <i class="fa-solid fa-file-invoice"></i><br>
                    <span>Thông tin đặt hàng</span>
                </li>
                <li class="nav-item text-center me-4">
                    <i class="fa-solid fa-credit-card"></i><br>
                    <span>Thanh toán</span>
                </li>
                <li class="nav-item text-center">
                    <i class="fa-solid fa-circle-check"></i><br>
                    <span>Hoàn tất</span>
                </li>
            </ul>
        </div>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-warning">${sessionScope.errorMessage}</div>
        </c:if>

        <c:choose>
    <%-- Nếu giỏ hàng trống --%>
    <c:when test="${empty sessionScope.cart.items}">
        <div class="text-center py-5 bg-white rounded shadow-sm cart-container">
            <h5 class="mb-3">Giỏ hàng của bạn đang trống</h5>
            <a href="home.jsp" class="btn btn-primary">TIẾP TỤC MUA HÀNG</a>
        </div>
    </c:when>

    <%-- Nếu có sản phẩm trong giỏ --%>
    <c:otherwise>
        <div class="cart-container">
            <h4 class="mb-4">Giỏ hàng của bạn</h4>

            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${sessionScope.cart.items}">
                        <tr>
                            <td>${item.productName}</td>
                            <td>
                                <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true" /> VNĐ
                            </td>
                            <td>
                                <a href="cart?action=decrease&productId=${item.productId}" class="btn btn-outline-secondary btn-sm">-</a>
                                ${item.quantity}
                                <a href="cart?action=increase&productId=${item.productId}" class="btn btn-outline-secondary btn-sm">+</a>
                            </td>
                            <td>
                                <fmt:formatNumber value="${item.price * item.quantity}" type="number" groupingUsed="true" /> VNĐ
                            </td>
                            <td>
                                <a href="cart?action=remove&productId=${item.productId}" class="btn btn-danger btn-sm">
                                    <i class="fa-solid fa-trash"></i> Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="text-end mt-3">
                <h5>
                    Tổng cộng:
                    <strong><fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number" groupingUsed="true" /> VNĐ</strong>
                </h5>
                <a href="checkout" class="btn btn-success mt-2">Tiến hành đặt hàng</a>
            </div>
        </div>
    </c:otherwise>
</c:choose>
    </main>

</body>
</html>
