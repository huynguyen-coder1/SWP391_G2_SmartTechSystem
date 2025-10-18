<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 700px;
            margin: 60px auto;
            background: #fff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
        }
        h1 {
            color: #28a745;
            font-size: 28px;
        }
        .info {
            text-align: left;
            margin-top: 25px;
            font-size: 16px;
            line-height: 1.8;
        }
        .info strong {
            color: #333;
        }
        .btn {
            display: inline-block;
            margin-top: 25px;
            padding: 12px 24px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: background 0.3s;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .success-icon {
            font-size: 60px;
            color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">✔</div>
        <h1>Thanh toán thành công!</h1>
        <p>Cảm ơn bạn đã mua hàng tại <strong>Online Store</strong>.</p>

        <div class="info">
            <%
                long orderId = (long) request.getAttribute("orderId");
                User user = (User) request.getAttribute("checkoutUser");
                String paymentMethod = (String) request.getAttribute("paymentMethod");
                double totalAmount = (double) request.getAttribute("totalAmount");

                DecimalFormat df = new DecimalFormat("#,### VND");
            %>

            <p><strong>Mã đơn hàng:</strong> <%= orderId %></p>
            <p><strong>Tên người nhận:</strong> <%= user.getFullName() %></p>
            <p><strong>Số điện thoại:</strong> <%= user.getPhone() %></p>
            <p><strong>Địa chỉ giao hàng:</strong> <%= user.getAddress() %></p>
            <p><strong>Phương thức thanh toán:</strong> <%= paymentMethod %></p>
            <p><strong>Tổng tiền:</strong> <%= df.format(totalAmount) %></p>
            <p>Chúng tôi sẽ liên hệ với bạn để xác nhận đơn hàng sớm nhất có thể.</p>
        </div>

        <a href="home.jsp" class="btn">Quay lại trang chủ</a>
    </div>
</body>
</html>
