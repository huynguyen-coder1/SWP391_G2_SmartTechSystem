<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Sử Giao Hàng</title>
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
        .staff-welcome i { color: #667eea; font-size: 20px; }
        .btn-logout {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-logout:hover { opacity: 0.85; }
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
        .badge.success { background: #28a745; }
        .badge.cancelled { background: #e74c3c; }
        .badge.info { background: #17a2b8; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
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
                                : "Nhân viên" %></strong>
                </span>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <i class="fas fa-right-from-bracket"></i> Đăng xuất
            </a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="header fade-in">
            <h2><i class="fas fa-truck"></i> Lịch Sử Giao Hàng</h2>
        </div>

        <div class="card fade-in">
            <div class="card-header">
                <h5>Chi tiết lịch sử giao hàng</h5>
            </div>
            <div class="card-body">
                <%
                    List<Map<String, Object>> historyList = (List<Map<String, Object>>) request.getAttribute("historyList");
                %>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Mã đơn hàng</th>
                            <th>Mã shipper</th>
                            <th>Trạng thái</th>
                            <th>Thời gian cập nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (historyList != null && !historyList.isEmpty()) {
                               for (Map<String, Object> h : historyList) {
                                   Long id = ((Number) h.get("Id")).longValue();
                                   Long orderId = ((Number) h.get("OrderId")).longValue();
                                   Integer shipperId = ((Number) h.get("ShipperId")).intValue();
                                   Integer status = ((Number) h.get("Status")).intValue();
                                   java.sql.Timestamp updateTime = (java.sql.Timestamp) h.get("UpdateTime");

                                   String statusText = "";
                                   String badgeClass = "";
                                   switch (status) {
                                       case 2 -> { statusText = "Comleted"; badgeClass = "success"; }
                                       case 3 -> { statusText = "Cancelled"; badgeClass = "cancelled"; }
                                       default -> { statusText = "Không xác định"; badgeClass = "info"; }
                                   }
                        %>
                        <tr>
                            <td>#<%= id %></td>
                            <td><%= orderId %></td>
                            <td><%= shipperId %></td>
                            <td><span class="badge <%= badgeClass %>"><%= statusText %></span></td>
                            <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(updateTime) %></td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="5" style="text-align:center;">Không có dữ liệu lịch sử giao hàng</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>
