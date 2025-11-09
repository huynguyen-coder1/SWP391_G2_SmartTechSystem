<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Order" %>
<%@ page import="model.OrderItem" %>
<%@ page import="java.util.List" %>

<%
    Order order = (Order) request.getAttribute("order");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        body { font-family: "Roboto", sans-serif; background: #f8f9fa; }
        .header {
            width: 100%;
            z-index: 999;
            background-color: white;
        }
        main {
                margin-top: 120px;
                margin-bottom: 30px;
            }
        .container h2 { font-weight: 700; margin-bottom: 40px; text-align: left; }

        table img { border-radius: 5px; }

        .status-badge {
            padding: 5px 10px;
            border-radius: 10px;
            color: #fff;
        }
        .pending { background-color: #ffc107; }
        .confirmed { background-color: #17a2b8; }
        .shipping { background-color: #007bff; }
        .completed { background-color: #28a745; }
        .canceled { background-color: #dc3545; }
    </style>
</head>
<body>
    <div class="header">
        <%@ include file="/includes/header.jsp" %>
    </div>

    <main>
        <div class="container">
            <h2>Chi tiết đơn hàng #<%= order.getOrderId() %></h2>

            <%
                String badgeClass = "pending";
                String status = order.getStatus();
                if (status != null) {
                    if (status.equals("Chờ xác nhận")) badgeClass = "pending";
                    else if (status.equals("Đã xác nhận")) badgeClass = "confirmed";
                    else if (status.equals("Đang giao")) badgeClass = "shipping";
                    else if (status.equals("Hoàn tất")) badgeClass = "completed";
                    else if (status.equals("Đã hủy")) badgeClass = "canceled";
                }
            %>

            <p><strong>Trạng thái:</strong> 
                <span class="status-badge <%= badgeClass %>"><%= status %></span>
            </p>
            <p><strong>Ngày đặt:</strong> <%= order.getOrderDate() %></p>
            <p><strong>Tổng tiền:</strong> <%= String.format("%,.0f", order.getTotalAmount()) %>₫</p>

            <table class="table table-bordered mt-4 bg-white">
                <thead class="table-secondary">
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Giá</th>
                        <th>Tạm tính</th>
                         <% if ("Hoàn tất".equals(order.getStatus())) { %>
            <th>Feedback</th>
        <% } %>

                    </tr>
                </thead>
                <tbody>
                    <%
                        if (orderItems != null && !orderItems.isEmpty()) {
                            for (OrderItem item : orderItems) {
                    %>
                    <tr>
                        <td><img src="<%= request.getContextPath() + "/images/" + item.getProduct().getImages() %>" width="70" height="70" alt=""></td>
                        <td><%= item.getProduct().getProductName() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td><%= String.format("%,.0f", item.getPrice()) %>₫</td>
                        <td><%= String.format("%,.0f", item.getPrice() * item.getQuantity()) %>₫</td>
                       <td class="text-center">
        <% if ("Hoàn tất".equals(order.getStatus())) { %>
            <a href="<%= request.getContextPath() %>/user/feedbackForm?productId=<%= item.getProduct().getProductId() %>&orderId=<%= order.getOrderId() %>&userId=<%= order.getUserId() %>"
   class="btn btn-outline-primary btn-sm">
   <i class="fa-solid fa-comment-dots"></i> Đánh giá
</a>

        <% } %>
    </td>

                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr><td colspan="5" class="text-center">Không có sản phẩm trong đơn này.</td></tr>
                    <% } %>
                </tbody>
            </table>

            <a href="<%= request.getContextPath() %>/myOrders" class="btn btn-secondary">Quay lại danh sách đơn hàng</a>
        </div>
    </main>

    <%@ include file="/includes/footer.jsp" %>
</body>
</html>
