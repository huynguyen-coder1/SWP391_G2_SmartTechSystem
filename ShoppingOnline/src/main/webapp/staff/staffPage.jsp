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
        <title>TechMart Staff Dashboard</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                margin: 0;
                font-family: "Segoe UI", sans-serif;
                background: linear-gradient(135deg, #3a7bd5, #3a6073);
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
                animation: fadeIn 0.6s ease-in;
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
            .card-body {
                padding: 25px;
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
            .badge {
                border-radius: 15px;
                padding: 5px 10px;
                font-size: 12px;
                color: white;
            }
            .badge.success {
                background: #28a745;
            }
            .badge.pending {
                background: #f39c12;
            }
            .badge.cancelled {
                background: #e74c3c;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>

        <%@ include file="staffsidebar.jsp" %>

        <!-- Header Staff -->
        <div class="staff-header fade-in">
            <div class="staff-info">
                <div class="staff-welcome">
                    <i class="fas fa-user-tie"></i>
                    <span>Xin chào, 
                        <strong><%= ((model.User) session.getAttribute("currentUser")) != null 
                                    ? ((model.User) session.getAttribute("currentUser")).getFullName() 
                                    : "Nhân viên" %>
                        </strong>
                    </span>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                    <i class="fas fa-right-from-bracket"></i> Đăng xuất
                </a>
            </div>
        </div>

        <div class="main-content">
            <div class="header fade-in">
                <h2><i class="fas fa-clipboard-list"></i> Quản Lý Đơn Hàng</h2>
            </div>

            <!-- Order Management -->
            <div class="card fade-in">
                <div class="card-header">
                    <h5>Đơn Hàng Mới Nhất</h5>
                </div>
                <div class="card-body">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Khách hàng</th>
                                <th>Tổng tiền</th>
                                <th>Ngày đặt</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <%
    List<Map<String, Object>> orders = (List<Map<String, Object>>) request.getAttribute("orders");
                        %>

                        <tbody>
                            <% if (orders != null && !orders.isEmpty()) {
                                   for (Map<String,Object> o : orders) { 
                                       Long id = (Long) o.get("Id");
                                       String fullName = (String) o.get("FullName");
                                       java.math.BigDecimal totalAmount = (java.math.BigDecimal) o.get("TotalAmount");
                                       java.sql.Timestamp orderDate = (java.sql.Timestamp) o.get("OrderDate");
                                       Integer status = (Integer) o.get("Status");
                            %>
                            <tr>
                                <td>#<%= id %></td>
                                <td><%= fullName %></td>
                                <td>₫<%= String.format("%,.0f", totalAmount) %></td>
                                <td><%= orderDate != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(orderDate) : "" %></td>
                                <td>
                                    <%
                                        if (status != null) {
                                            switch(status) {
                                                case 0: out.print("Pending"); break;
                                                case 1: out.print("Paid"); break;
                                                case 2: out.print("Shipping"); break;
                                                case 3: out.print("Completed"); break;
                                                case 4: out.print("Cancelled"); break;
                                                default: out.print("Unknown"); break;
                                            }
                                        } else {
                                            out.print("Unknown");
                                        }
                                    %>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/staff/OrderDetailServlet?orderId=<%= id %>" class="btn btn-outline">Chi tiết</a>
                                    <a href="<%= request.getContextPath() %>/staff/UpdateOrderStatusServlet?orderId=<%= id %>" class="btn btn-outline">Cập nhật</a>
                                </td>
                            </tr>
                            <%   } // end for
   } else { %>
                            <tr>
                                <td colspan="6" style="text-align:center;">Không có dữ liệu orders</td>
                            </tr>
                            <% } %>
                        </tbody>

                    </table>
                </div>
            </div>


    </body>
</html>
