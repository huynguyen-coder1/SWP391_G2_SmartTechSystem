<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông tin đặt hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .checkout-container {
            max-width: 700px; margin: 40px auto; background: #fff;
            border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); padding: 30px;
        }
        .progress-steps { background: #fdeaea; border-radius: 10px; }
        .progress-steps i { font-size: 20px; }
        .btn-order {
            background-color: #dc3545; color: #fff; width: 100%; font-size: 18px; transition: 0.3s;
        }
        .btn-order:hover { background-color: #b71c1c; }
    </style>
</head>

<body>
<div class="checkout-container">
    <a href="cart" class="text-decoration-none text-secondary mb-3 d-block">
        &lt; Trở về giỏ hàng
    </a>

    <!-- Thanh tiến trình -->
    <div class="progress-steps mb-4 p-3">
        <ul class="nav justify-content-center">
            <li class="nav-item text-center me-4">
                <i class="fa-solid fa-bag-shopping text-danger"></i><br>
                <span class="fw-bold text-danger">Giỏ hàng</span>
            </li>
            <li class="nav-item text-center me-4">
                <i class="fa-solid fa-file-invoice text-danger"></i><br>
                <span class="fw-bold text-danger">Thông tin đặt hàng</span>
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

    <!-- Form đặt hàng -->
    <form action="payment" method="post">
        <!-- Thông tin người nhận -->
        <div class="mb-4">
            <h5 class="mb-3">Thông tin khách mua hàng</h5>
            <div class="row g-2">
                <div class="col-md-6">
                    <input type="text" class="form-control" name="fullname"
                           placeholder="Họ và tên"
                           value="${sessionScope.currentUser.fullName}" required>
                </div>
                <div class="col-md-6">
                    <input type="text" class="form-control" name="phone"
                           placeholder="Số điện thoại"
                           value="${sessionScope.currentUser.phone}" required>
                </div>
            </div>
        </div>

        <!-- Cách nhận hàng -->
        <div class="mb-4">
            <h5 class="mb-3">Chọn cách nhận hàng</h5>
            <div class="form-check mb-3">
                <input class="form-check-input" type="radio" name="shippingMethod" value="home" checked>
                <label class="form-check-label">Giao hàng tận nơi</label>
            </div>

         

            <input type="text" class="form-control mb-2" name="address"
                   placeholder="Địa chỉ"
                   value="${sessionScope.currentUser.address}" required>
            <input type="text" class="form-control" name="note" placeholder="Ghi chú thêm (không bắt buộc)">
        </div>

        <!-- Tổng tiền -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <span class="fw-bold">Tổng tiền:</span>
            <span class="text-danger fw-bold fs-5">
                <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number" groupingUsed="true" /> VNĐ
            </span>
        </div>

        <!-- Nút đặt hàng -->
        <button type="submit" class="btn btn-order">ĐẶT HÀNG NGAY</button>
        <p class="text-center text-muted mt-2" style="font-size: 14px;">
            Bạn có thể chọn hình thức thanh toán sau khi đặt hàng.
        </p>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
