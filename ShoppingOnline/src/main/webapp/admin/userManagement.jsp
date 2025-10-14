<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Người Dùng | TechMart Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            color: #333;
        }
        .main-content {
            margin-left: 270px;
            padding: 30px;
            min-height: 100vh;
        }
        .header {
            background: rgba(255,255,255,0.95);
            padding: 25px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .header h2 {
            font-size: 26px;
            font-weight: 700;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .filter-bar {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }
        .filter-bar input, .filter-bar select {
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
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
        .btn-outline:hover { background: #667eea; color: white; }
        .card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
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
        th { background: rgba(102,126,234,0.1); font-size: 13px; text-transform: uppercase; }
        .badge {
            border-radius: 15px;
            padding: 5px 10px;
            font-size: 12px;
            color: white;
        }
        .badge.active { background: #28a745; }
        .badge.inactive { background: #e74c3c; }
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
            transition: 0.2s;
        }
        .lock-btn { background: #f39c12; color: white; }
        .unlock-btn { background: #27ae60; color: white; }
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
                    <c:forEach var="u" items="${userList}">
                        <tr>
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
                <div style="text-align:center;padding:20px;color:#777;">
                    <i class="fas fa-info-circle"></i> Không tìm thấy người dùng nào.
                </div>
            </c:if>
        </div>
    </div>
</div>

</body>
</html>
