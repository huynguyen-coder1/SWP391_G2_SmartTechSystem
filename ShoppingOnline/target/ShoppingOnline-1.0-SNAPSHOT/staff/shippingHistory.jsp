<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Sử Giao Hàng | TechMart Staff</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* ===== Tổng thể ===== */
        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            color: #333;
            overflow-x: hidden;
            animation: fadePage 0.6s ease-in;
        }

        .main-content {
            margin-left: 270px;
            padding: 30px;
            min-height: 100vh;
        }

        /* ===== Header ===== */
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 25px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: fadeSlideDown 0.7s ease;
        }

        .header h2 {
            font-weight: 700;
            font-size: 26px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header h2 i { color: #667eea; }

        /* ===== Thanh lọc & tìm kiếm ===== */
        .filter-bar {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            animation: fadeSlideDown 0.7s ease;
        }

        .filter-bar input, .filter-bar select, .filter-bar button {
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            min-width: 200px;
            transition: all 0.3s ease;
        }

        .filter-bar input:focus, .filter-bar select:focus {
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102,126,234,0.4);
            outline: none;
        }

        .filter-bar button {
            background: #667eea;
            color: #fff;
            border: none;
            font-weight: 600;
            cursor: pointer;
        }

        .filter-bar button:hover {
            background: #5563c1;
        }

        /* ===== Card bảng ===== */
        .card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            animation: fadeIn 0.8s ease-in;
        }

        .card-header {
            padding: 20px 25px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            font-size: 18px;
            font-weight: 700;
            background: rgba(102,126,234,0.05);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* ===== Bảng ===== */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid rgba(0,0,0,0.08);
            text-align: left;
        }

        th {
            background: rgba(102,126,234,0.1);
            text-transform: uppercase;
            font-size: 13px;
        }

        tbody tr {
            animation: fadeRow 0.4s ease-in forwards;
            opacity: 0;
        }

        tbody tr:nth-child(odd) {
            background: rgba(102,126,234,0.03);
        }

        tbody tr:hover {
            background: rgba(102,126,234,0.08);
            transition: background 0.3s ease;
        }

        /* ===== Badge trạng thái ===== */
        .badge {
            border-radius: 15px;
            padding: 6px 10px;
            font-size: 12px;
            font-weight: 600;
            color: white;
        }

        .badge.assigned { background: #3498db; }
        .badge.indelivery { background: #f39c12; }
        .badge.delivered { background: #28a745; }
        .badge.failed { background: #e74c3c; }

        /* ===== Hiệu ứng Keyframes ===== */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeSlideDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeRow {
            to { opacity: 1; transform: none; }
        }

        @keyframes fadePage {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
</head>

<body>

<%@ include file="staffsidebar.jsp" %>

<div class="main-content">

    <!-- Header -->
    <div class="header">
        <h2><i class="fas fa-truck"></i> Lịch Sử Giao Hàng</h2>
    </div>

    <!-- Bộ lọc -->
    <form method="get" action="shippinghistory" class="filter-bar">
        <input type="text" name="search" placeholder="Tìm theo tên khách hàng..." value="${param.search}">
        <select name="status">
            <option value="">-- Trạng thái giao hàng --</option>
            <option value="0" <c:if test="${param.status == '0'}">selected</c:if>>Assigned</option>
            <option value="1" <c:if test="${param.status == '1'}">selected</c:if>>In Delivery</option>
            <option value="2" <c:if test="${param.status == '2'}">selected</c:if>>Delivered</option>
            <option value="3" <c:if test="${param.status == '3'}">selected</c:if>>Failed</option>
        </select>
        <button type="submit"><i class="fas fa-search"></i> Tìm kiếm</button>
    </form>

    <!-- Bảng lịch sử -->
    <div class="card">
        <div class="card-header">
            <i class="fas fa-list"></i> Danh Sách Lịch Sử Giao Hàng
        </div>
        <div class="card-body">
            <table>
                <thead>
                <tr>
                    <th>#</th>
                    <th>Mã Đơn Hàng</th>
                    <th>Khách Hàng</th>
                    <th>Nhân Viên Giao</th>
                    <th>Trạng Thái Giao Hàng</th>
                    <th>Trạng Thái Đơn Hàng</th>
                    <th>Thời Gian Cập Nhật</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="sh" items="${shippingHistoryList}" varStatus="i">
                    <tr style="animation-delay: ${i.index * 0.05}s;">
                        <td>${i.index + 1}</td>
                        <td>${sh.orderId}</td>
                        <td>${sh.customerName}</td>
                        <td>${sh.shipperName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${sh.status == 0}">
                                    <span class="badge assigned">Assigned</span>
                                </c:when>
                                <c:when test="${sh.status == 1}">
                                    <span class="badge indelivery">In Delivery</span>
                                </c:when>
                                <c:when test="${sh.status == 2}">
                                    <span class="badge delivered">Delivered</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge failed">Failed</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${sh.orderStatus}</td>
                        <td><fmt:formatDate value="${sh.updateTime}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <c:if test="${empty shippingHistoryList}">
                <div style="text-align:center;padding:20px;color:#777;">
                    <i class="fas fa-info-circle"></i> Không có lịch sử giao hàng nào.
                </div>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>