<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Shipper Dashboard</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                margin: 0;
                font-family: "Segoe UI", sans-serif;
                background: linear-gradient(135deg, #3a6073, #3a7bd5);
                color: #333;
                overflow-x: hidden;
            }
            .staff-header {
                background: rgba(255,255,255,0.95);
                backdrop-filter: blur(20px);
                padding: 20px 30px;
                margin-left: 270px;
                border-radius: 0 0 20px 20px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
                display: flex;
                justify-content: flex-end;
                align-items: center;
                position: sticky;
                top: 0;
                z-index: 1000;
            }
            .staff-info {
                display: flex;
                align-items: center;
                gap: 20px;
            }
            .staff-welcome {
                font-size: 16px;
                font-weight: 500;
                color: #333;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .staff-welcome i {
                color: #667eea;
                font-size: 20px;
            }
            .btn-logout {
                background: linear-gradient(135deg, #f093fb, #f5576c);
                color: white;
                padding: 8px 16px;
                border-radius: 8px;
                font-weight: 600;
                text-decoration: none;
                transition: 0.3s;
            }
            .btn-logout:hover {
                opacity: 0.85;
            }

            .main-content {
                margin-left: 270px;
                padding: 30px;
                min-height: 100vh;
            }
            .header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                padding: 25px 30px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }
            .header h2 {
                font-weight: 700;
                font-size: 30px;
                color: #333;
            }
            .card {
                background: rgba(255,255,255,0.95);
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                margin-bottom: 30px;
                overflow: hidden;
            }
            .card-header {
                padding: 20px 25px;
                border-bottom: 1px solid rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .card-header h5 {
                font-size: 18px;
                font-weight: 700;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                padding: 12px;
                border-bottom: 1px solid rgba(0,0,0,0.1);
                text-align: left;
            }
            th {
                background: rgba(102,126,234,0.1);
                text-transform: uppercase;
                font-size: 13px;
            }
            .action-btn {
                border: none;
                border-radius: 8px;
                padding: 8px 12px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.3s;
            }
            .btn-success {
                background: #28a745;
                color: white;
            }
            .btn-cancel {
                background: #e74c3c;
                color: white;
            }
            .btn-success:hover {
                opacity: 0.9;
            }
            .btn-cancel:hover {
                opacity: 0.9;
            }
        </style>
    </head>
    <body>

        <%@ include file="sidebar.jsp" %>

        <!-- Header -->
        <div class="staff-header fade-in">
            <div class="staff-info">
                <div class="staff-welcome">
                    <i class="fas fa-truck"></i>
                    <span>Xin chào, 
                        <strong><%= ((model.User) session.getAttribute("currentUser")) != null 
                                    ? ((model.User) session.getAttribute("currentUser")).getFullName() 
                                    : "Shipper" %>
                        </strong>
                    </span>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                    <i class="fas fa-right-from-bracket"></i> Đăng xuất
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h2><i class="fas fa-box-open"></i> Đơn Hàng Đang Giao</h2>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5>Danh sách đơn hàng Shipping</h5>
                </div>
                <div class="card-body">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Khách hàng</th>
                                <th>Địa chỉ giao hàng</th>
                                <th>Số điện thoại</th>
                                <th>Tổng tiền</th>
                                <th>Ngày đặt</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String, Object>> shippingOrders = (List<Map<String, Object>>) request.getAttribute("shippingOrders");
                                if (shippingOrders != null && !shippingOrders.isEmpty()) {
                                    for (Map<String, Object> o : shippingOrders) {
                                        Long id = (Long) o.get("Id");
                                        String fullName = (String) o.get("FullName");
                                        String address = (String) o.get("Address");
                                        String phone = (String) o.get("Phone");
                                        BigDecimal total = (BigDecimal) o.get("TotalAmount");
                                        Timestamp date = (Timestamp) o.get("OrderDate");
                            %>
                            <tr>
                                <td>#<%= id %></td>
                                <td><%= fullName %></td>
                                <td><%= address != null ? address : "—" %></td>
                                <td><%= phone != null ? phone : "—" %></td>
                                <td>₫<%= String.format("%,.0f", total) %></td>
                                <td><%= date != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(date) : "" %></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/shipper/updateOrder" method="post" style="display:inline;">
                                        <input type="hidden" name="orderId" value="<%= id %>">
                                        <input type="hidden" name="action" value="complete">
                                        <button class="action-btn btn-success">✅ Thành công</button>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/shipper/updateOrder" method="post" style="display:inline;">
                                        <input type="hidden" name="orderId" value="<%= id %>">
                                        <input type="hidden" name="action" value="cancel">
                                        <button class="action-btn btn-cancel">❌ Hủy hàng</button>
                                    </form>
                                </td>

                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" style="text-align:center;">Không có đơn hàng đang giao</td>
                            </tr>
                            <% } %>
                        </tbody>

                    </table>

                </div>
            </div>
        </div>
    </body>
</html>
