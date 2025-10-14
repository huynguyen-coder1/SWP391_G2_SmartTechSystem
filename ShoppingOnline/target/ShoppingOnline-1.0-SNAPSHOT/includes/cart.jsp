<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="bg-light">
<div class="container mt-3">
    <div class="mb-3">
        <a href="home.jsp" class="btn btn-primary btn-sm float-start">
            <i class="fa-solid fa-house"></i> Trang chủ
        </a>
    </div>
</div>
<div class="container mt-5">
    <!-- Bước tiến trình -->
    <div class="progress-steps mb-4 p-3 rounded" style="background-color:#fdeaea;">
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

    <!-- Hiển thị giỏ hàng -->
    <c:choose>
        <c:when test="${empty sessionScope.cart.items}">
            <div class="text-center py-5 bg-white rounded shadow-sm">
                <h5 class="mb-3">Giỏ hàng của bạn đang trống</h5>
                <a href="home.jsp" class="btn btn-primary">TIẾP TỤC MUA HÀNG</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bg-white p-4 rounded shadow-sm">
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
                                <td>${item.price} VNĐ</td>
                                <td>
                                    <a href="cart?action=decrease&productId=${item.productId}" class="btn btn-outline-secondary btn-sm">-</a>
                                    ${item.quantity}
                                    <a href="cart?action=increase&productId=${item.productId}" class="btn btn-outline-secondary btn-sm">+</a>
                                </td>
                                <td>${item.price * item.quantity} VNĐ</td>
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
                    <h5>Tổng cộng: <strong>${sessionScope.cart.totalMoney} VNĐ</strong></h5>
                    <a href="checkout.jsp" class="btn btn-success mt-2">Tiến hành đặt hàng</a
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    
</div>

</body>
</html>
