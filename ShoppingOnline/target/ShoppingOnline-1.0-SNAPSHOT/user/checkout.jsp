<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông tin đặt hàng - TechMart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: "Roboto", sans-serif;
            }
            .checkout-container {
                background: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                max-width: 750px;
                margin: auto;
            }
            .progress-steps {
                background-color: #fdeaea;
                border-radius: 10px;
            }
            .progress-steps i {
                font-size: 20px;
            }
            .btn-order {
                background-color: #dc3545;
                color: #fff;
                width: 100%;
                font-size: 18px;
                transition: all 0.3s ease;
            }
            .btn-order:hover {
                background-color: #b71c1c;
                transform: translateY(-2px);
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
            .order-box {
                border: 1px solid #eee;
                background-color: #fff8f8;
                transition: 0.3s ease;
            }
            .order-box:hover {
                box-shadow: 0 0 15px rgba(220, 53, 69, 0.15);
                transform: translateY(-2px);
            }
            .btn-order {
                background-color: #0d6efd;
                ;
                color: #0d6efd;
                width: 100%;
                font-size: 18px;
                transition: 0.3s;
            }
            .btn-order:hover {
                background-color: #b71c1c;
            }

        </style>
    </head>

    <body>
        <!-- Header -->
        <div class="header">
            <%@ include file="/includes/header.jsp" %>
        </div>

        <main class="container mt-5 pt-5">
            <!-- 🔙 Nút quay lại -->
            <a href="cart" class="btn-back mb-4 d-inline-block">
                <i class="fa-solid fa-arrow-left"></i> Quay lại giỏ hàng
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
            <div class="checkout-container">
                <form action="payment" method="post">
                    <!-- Thông tin người nhận -->
                    <div class="mb-4">
                        <h5 class="mb-3">Thông tin khách mua hàng</h5>
                        <div class="row g-3">
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
                               placeholder="Địa chỉ nhận hàng"
                               value="${sessionScope.currentUser.address}" required>

                        <input type="text" class="form-control" name="note"
                               placeholder="Ghi chú thêm (không bắt buộc)">
                    </div>

                    <!-- Tổng tiền -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fw-bold">Tổng tiền:</span>
                        <span class="text-danger fw-bold fs-5">
                            <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number" groupingUsed="true" /> VNĐ
                        </span>
                    </div>

                   
                    <div class="order-box text-center p-4 mt-4 shadow-sm rounded-3 bg-light">
                        <button type="submit" class="btn btn-order mb-2">
                            <i class="fa-solid fa-paper-plane me-2"></i> ĐẶT HÀNG NGAY
                        </button>
                        <p class="text-muted mb-0" style="font-size: 14px;">
                            Đây là thanh toán COD
                        </p>
                    </div>

                </form>
            </div>
        </main>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
