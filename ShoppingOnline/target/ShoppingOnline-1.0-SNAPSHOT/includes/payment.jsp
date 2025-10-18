<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thanh toán đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .payment-container {
                max-width: 700px;
                margin: 40px auto;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                padding: 30px;
            }
            .progress-steps {
                background: #fdeaea;
                border-radius: 10px;
            }
            .progress-steps i {
                font-size: 20px;
            }
            .btn-pay {
                background-color: #dc3545;
                color: #fff;
                width: 100%;
                font-size: 18px;
                transition: 0.3s;
            }
            .btn-pay:hover {
                background-color: #b71c1c;
            }
            .price-text {
                color: #dc3545;
                font-weight: 600;
            }
            hr {
                border-color: #ddd;
            }
        </style>
    </head>
    <body>

        <div class="payment-container">
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
                        <i class="fa-solid fa-credit-card text-danger"></i><br>
                        <span class="fw-bold text-danger">Thanh toán</span>
                    </li>
                    <li class="nav-item text-center">
                        <i class="fa-solid fa-circle-check"></i><br>
                        <span>Hoàn tất</span>
                    </li>
                </ul>
            </div>

            <h5 class="fw-bold mb-3">Thông tin đặt hàng</h5>
            <div class="mb-3">
                <p><strong>Khách hàng:</strong> ${checkoutUser.fullName}</p>
                <p><strong>Số điện thoại:</strong> ${checkoutUser.phone}</p>
                <p><strong>Địa chỉ nhận hàng:</strong> ${checkoutUser.address}</p>

            </div>

            <div class="border rounded p-3 mb-4 bg-light">
                <div class="d-flex justify-content-between">
                    <span>Tạm tính</span>
                    <span class="price-text">
                        <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number" groupingUsed="true"/>đ
                    </span>
                </div>
                <div class="d-flex justify-content-between mt-2">
                    <span>Phí vận chuyển</span>
                    <span class="price-text">40.000đ</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between fs-5">
                    <strong>Tổng tiền</strong>
                    <strong class="price-text">
                        <fmt:formatNumber value="${requestScope.totalAmount}" type="number" groupingUsed="true"/>đ
                    </strong>
                </div>
            </div>

            <!-- Mã giảm giá -->
            <div class="mb-4">
                <button class="btn btn-outline-secondary w-100" type="button">
                    <i class="fa-solid fa-ticket me-2"></i> Sử dụng mã giảm giá
                </button>
            </div>

            <!-- Hình thức thanh toán -->
            <h5 class="fw-bold mb-3">Chọn hình thức thanh toán</h5>
            <form action="payment" method="post">
                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="paymentMethod" value="COD" id="cod" checked>
                    <label class="form-check-label" for="cod">
                        <i class="fa-solid fa-truck me-2 text-danger"></i> Thanh toán khi giao hàng (COD)
                    </label>
                </div>

                <div class="form-check mb-4">
                    <input class="form-check-input" type="radio" name="paymentMethod" value="Online" id="online">
                    <label class="form-check-label" for="online">
                        <i class="fa-brands fa-paypal me-2 text-primary"></i> Thanh toán online qua Cổng Payoo
                    </label>
                </div>

                <div class="d-flex justify-content-between mb-3">
                    <span>Phí vận chuyển:</span>
                    <span class="price-text">40.000đ</span>
                </div>
                <div class="d-flex justify-content-between fs-5 mb-4">
                    <strong>Tổng tiền:</strong>
                    <strong class="price-text">
                        <fmt:formatNumber value="${requestScope.totalAmount}" type="number" groupingUsed="true"/>đ
                    </strong>
                </div>

                <button type="submit" class="btn btn-pay">THANH TOÁN NGAY</button>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
