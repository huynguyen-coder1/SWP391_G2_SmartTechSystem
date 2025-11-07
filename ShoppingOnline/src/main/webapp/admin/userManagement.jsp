<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Người Dùng | TechMart Admin</title>
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
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(20px);
            padding: 25px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            animation: fadeSlideDown 0.7s ease;
        }

        .header h2 {
            font-size: 26px;
            font-weight: 700;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header h2 i {
            color: #667eea;
        }

        /* ===== Thanh lọc & tìm kiếm ===== */
        .filter-bar {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 25px;
            animation: fadeSlideDown 0.7s ease;
        }

        .filter-bar input, .filter-bar select {
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

        /* ===== Nút ===== */
        .btn {
            border: none;
            padding: 10px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
        }

        .btn-outline {
            border: 2px solid #667eea;
            color: #667eea;
            background: transparent;
        }
        .btn-outline:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }

        /* ===== Thẻ chứa bảng ===== */
        .card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            animation: fadeIn 0.8s ease-in;
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
            font-size: 13px;
            text-transform: uppercase;
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

        /* ===== Trạng thái (Badge) ===== */
        .badge {
            border-radius: 15px;
            padding: 5px 10px;
            font-size: 12px;
            color: white;
        }
        .badge.active { background: #28a745; }
        .badge.inactive { background: #e74c3c; }

        /* ===== Hành động ===== */
        .action-btns {
            display: flex;
            gap: 8px;
        }

        .action-btns a {
            padding: 6px 10px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: 0.25s;
        }

        .lock-btn {
            background: #f39c12;
            color: white;
        }
        .unlock-btn {
            background: #27ae60;
            color: white;
        }

        .action-btns a:hover {
            opacity: 0.8;
            transform: scale(1.05);
        }

        /* ===== Thông báo không có dữ liệu ===== */
        .no-data {
            text-align: center;
            padding: 20px;
            color: #777;
            animation: fadeIn 0.6s ease;
        }

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

<%@ include file="sidebar.jsp" %>

<div class="main-content">
    <div class="header">
        <h2><i class="fas fa-users"></i> Quản Lý Người Dùng</h2>
    </div>

    <form action="${pageContext.request.contextPath}/admin/userManagement" method="get" class="filter-bar">
        <input type="text" name="search" placeholder="Tìm theo tên hoặc email..." value="${param.search}">
        <select name="statusFilter">
            <option value="">-- Lọc theo trạng thái --</option>
            <option value="1" ${param.statusFilter == '1' ? 'selected' : ''}>Đang hoạt động</option>
            <option value="0" ${param.statusFilter == '0' ? 'selected' : ''}>Đã khóa</option>
        </select>
        <button type="submit" class="btn btn-outline"><i class="fas fa-search"></i> Tìm kiếm</button>
    </form>

    <div class="card">
        <div style="padding: 20px;">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Email</th>
                        <th>Họ tên</th>
                        <th>Điện thoại</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${userList}" varStatus="i">
                        <tr style="animation-delay: ${i.index * 0.05}s;">
                            <td>${u.userID}</td>
                            <td>${u.email}</td>
                            <td>${u.fullName}</td>
                            <td>${u.phone}</td>
                            <td>
                                <span class="badge ${u.active ? 'active' : 'inactive'}">
                                    ${u.active ? 'Đang hoạt động' : 'Đã khóa'}
                                </span>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <c:choose>
                                        <c:when test="${u.active}">
                                            <a href="${pageContext.request.contextPath}/admin/updateUserStatus?userId=${u.userID}&isActive=false"
                                               class="lock-btn"
                                               onclick="return confirm('Bạn có chắc muốn KHÓA người dùng [${u.fullName}] không?');">
                                                <i class="fas fa-lock"></i> Khóa
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/admin/updateUserStatus?userId=${u.userID}&isActive=true"
                                               class="unlock-btn"
                                               onclick="return confirm('Bạn có chắc muốn MỞ KHÓA người dùng [${u.fullName}] không?');">
                                                <i class="fas fa-unlock"></i> Mở khóa
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${empty userList}">
                <div class="no-data">
                    <i class="fas fa-info-circle"></i> Không tìm thấy người dùng nào.
                </div>
            </c:if>
        </div>
    </div>
</div>

</body>
</html>