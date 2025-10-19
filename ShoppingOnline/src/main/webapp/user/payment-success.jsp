<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="java.text.DecimalFormat"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
        }

        .success-container {
            max-width: 700px;
            margin: 120px auto 60px auto;
            background: #ffffff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }

        .success-icon {
            font-size: 70px;
            color: #28a745;
            margin-bottom: 15px;
        }

        h1 {
            color: #198754;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        p {
            color: #555;
            font-size: 16px;
        }

        .info {
            text-align: left;
            margin-top: 25px;
            font-size: 16px;
            line-height: 1.8;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }

        .info strong {
            color: #333;
        }

        .btn-home {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 28px;
            background-color: #0d6efd;
            color: #000;
            font-weight: 600;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-home:hover {
            background-color: #0b5ed7;
            color: #fff;
            transform: translateY(-2px);
        }

        .order-box {
            background-color: #f1f9ff;
            border: 1px solid #cce5ff;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }

        .order-box p {
            margin: 5px 0;
        }
    </style>
</head>

<body>
    <!-- ✅ Include header -->
    <div class="header">
        <%@ include file="/includes/header.jsp" %>
    </div>

    <main>
        <div class="success-container">
            <div class="success-icon">
                <i class="fa-solid fa-circle-check"></i>
            </div>
            <h1>Đặt hàng thành công!</h1>
            <p>Cảm ơn bạn đã mua hàng tại <strong>SmartTech System</strong>.</p>

            <%
                long orderId = (long) request.getAttribute("orderId");
                User user = (User) request.getAttribute("checkoutUser");
                String paymentMethod = (String) request.getAttribute("paymentMethod");
                double totalAmount = (double) request.getAttribute("totalAmount");

                DecimalFormat df = new DecimalFormat("#,### VND");
            %>

            <!-- Thông tin đơn hàng -->
            <div class="order-box text-start">
                <p><strong>Mã đơn hàng:</strong> <%= orderId %></p>
                <p><strong>Tên người nhận:</strong> <%= user.getFullName() %></p>
                <p><strong>Số điện thoại:</strong> <%= user.getPhone() %></p>
                <p><strong>Địa chỉ giao hàng:</strong> <%= user.getAddress() %></p>
                <p><strong>Phương thức thanh toán:</strong> <%= paymentMethod != null ? paymentMethod : "COD" %></p>
                <p><strong>Tổng tiền:</strong> <%= df.format(totalAmount) %></p>
            </div>

            <p class="mt-3 text-muted">
                Chúng tôi sẽ liên hệ với bạn để xác nhận đơn hàng sớm nhất có thể.
            </p>

            <a href="home.jsp" class="btn-home">
                <i class="fa-solid fa-house me-2"></i> Quay lại trang chủ
            </a>
        </div>
    </main>

</body>
</html>
