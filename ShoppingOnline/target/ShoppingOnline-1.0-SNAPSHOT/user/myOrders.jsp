<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="model.Order"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Orders - TechMart</title>

        <!-- Bootstrap + Font -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

        <style>
            body {
                font-family: "Roboto", sans-serif;
                background: #f8f9fa;
            }
            .header {
            width: 100%;
            z-index: 999;
            background-color: white;
            }
            main {
                margin-top: 120px;
            }

            h2 {
                font-weight: 700;
                margin-bottom: 30px;
            }

            .status-badge {
                padding: 5px 10px;
                border-radius: 10px;
                color: #fff;
            }
            .pending {
                background-color: #ffc107;
            }
            .confirmed {
                background-color: #17a2b8;
            }
            .shipping {
                background-color: #007bff;
            }
            .completed {
                background-color: #28a745;
            }
            .canceled {
                background-color: #dc3545;
            }
        </style>
    </head>

    <body>
        <div class="header">
            <%@ include file="/includes/header.jsp" %>
        </div>

        <main>
            <div class="container">
                <h2>MY ORDERS</h2>

                <%                List<Order> orders = (List<Order>) request.getAttribute("orders");
                    if (orders == null || orders.isEmpty()) {
                %>
                <div class="alert alert-info text-center">Bạn chưa có đơn hàng nào.</div>
                <%
                } else {
                %>
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-primary text-center">
                        <tr>
                            <th>Mã đơn</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th> <!-- ✅ thêm cột -->
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Order o : orders) {
                                String badgeClass = "pending";
                                String status = o.getStatus();
                                if (status != null) {
                                    if (status.equals("Chờ xác nhận")) {
                                        badgeClass = "pending";
                                    } else if (status.equals("Đã xác nhận")) {
                                        badgeClass = "confirmed";
                                    } else if (status.equals("Đang giao")) {
                                        badgeClass = "shipping";
                                    } else if (status.equals("Hoàn tất")) {
                                        badgeClass = "completed";
                                    } else if (status.equals("Đã hủy")) {
                                        badgeClass = "canceled";
                                    }
                                }
                        %>
                        <tr class="text-center">
                            <td><%= o.getOrderId()%></td>
                            <td><%= o.getOrderDate() != null ? o.getOrderDate().toLocalDate() : ""%></td>
                            <td><%= String.format("%,.0f ₫", o.getTotalAmount())%></td>
                            <td><span class="status-badge <%= badgeClass%>"><%= status%></span></td>

                            <!-- ✅ Nút hành động -->
                            <td>
                                <a href="<%= request.getContextPath()%>/orderDetail?id=<%= o.getOrderId()%>" 
                                   class="btn btn-sm btn-outline-primary">Xem chi tiết</a>

                                <% if ("Chờ xác nhận".equals(status)) {%>
                                <a href="<%= request.getContextPath()%>/cancelOrder?id=<%= o.getOrderId()%>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này không?');">
                                    <i class="fa-solid fa-ban"></i> Hủy đơn
                                </a>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <%
                    }
                %>
            </div>
        </main>

        <%@ include file="/includes/footer.jsp" %>
    </body>
</html>