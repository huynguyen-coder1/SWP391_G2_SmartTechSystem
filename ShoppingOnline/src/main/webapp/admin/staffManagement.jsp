<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Nhân Viên | TechMart Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            color: #333;
            overflow-x: hidden;
            animation: fadePage 0.8s ease-in;
        }
        @keyframes fadePage { from {opacity:0;transform:translateY(20px);} to {opacity:1;transform:translateY(0);} }
        @keyframes fadeRow { from {opacity:0;transform:translateY(15px);} to {opacity:1;transform:translateY(0);} }

        .main-content { margin-left:270px; padding:30px; min-height:100vh; }
        .header {
            background:rgba(255,255,255,0.95);
            backdrop-filter:blur(20px);
            padding:25px 30px;
            border-radius:20px;
            box-shadow:0 10px 30px rgba(0,0,0,0.1);
            margin-bottom:30px;
            display:flex;justify-content:space-between;align-items:center;
        }
        .header h2 { font-weight:700; font-size:26px; color:#333; display:flex; align-items:center; gap:10px; }
        .header h2 i { color:#667eea; }

        .filter-bar {
            display:flex;
            gap:15px;
            flex-wrap:wrap;
            margin-bottom:25px;
            animation:fadeSlideDown 0.7s ease;
        }
        @keyframes fadeSlideDown {
            from {opacity:0;transform:translateY(-20px);}
            to {opacity:1;transform:translateY(0);}
        }
        .filter-bar input, .filter-bar select {
            padding:10px 12px;
            border-radius:8px;
            border:1px solid #ccc;
            font-size:14px;
            min-width:200px;
            transition:all 0.3s ease;
        }
        .filter-bar input:focus, .filter-bar select:focus {
            border-color:#667eea;
            box-shadow:0 0 5px rgba(102,126,234,0.4);
            outline:none;
        }

        .btn {
            border:none;padding:10px 16px;border-radius:8px;
            font-size:14px;font-weight:600;cursor:pointer;
            transition:0.3s;text-decoration:none;
        }
        .btn-primary { background:linear-gradient(135deg,#667eea,#764ba2);color:white; }
        .btn-primary:hover { opacity:0.9;transform:translateY(-2px); }
        .btn-outline { border:2px solid #667eea;background:transparent;color:#667eea; }
        .btn-outline:hover { background:#667eea;color:white; }

        .card {
            background:rgba(255,255,255,0.95);
            border-radius:20px;
            box-shadow:0 10px 30px rgba(0,0,0,0.1);
            overflow:hidden;
        }
        .card-header {
            padding:20px 25px;
            border-bottom:1px solid rgba(0,0,0,0.1);
            font-size:18px;font-weight:700;
            background:rgba(102,126,234,0.05);
        }
        table { width:100%; border-collapse:collapse; }
        th, td { padding:12px; border-bottom:1px solid rgba(0,0,0,0.08); text-align:left; }
        th { background:rgba(102,126,234,0.1); text-transform:uppercase; font-size:13px; }
        tbody tr:nth-child(odd) { background:rgba(102,126,234,0.03); }
        tbody tr:hover { background:rgba(102,126,234,0.08); transition:background 0.3s ease; }
        tbody tr { animation:fadeRow 0.6s ease forwards; }

        .action-btns { display:flex; gap:8px; align-items:center; }
        .action-btns a {
            display:inline-flex; align-items:center; gap:6px;
            padding:8px 14px; border-radius:8px; font-size:13px;
            font-weight:600; text-decoration:none; transition:all 0.25s ease;
            box-shadow:0 2px 6px rgba(0,0,0,0.1);
        }
        .btn-info { background:linear-gradient(135deg,#42a5f5,#478ed1);color:white; }
        .btn-info:hover { opacity:0.9;transform:translateY(-2px); }
        .delete-btn { background:linear-gradient(135deg,#ff6b6b,#ee5253);color:white; }
        .delete-btn:hover { opacity:0.9;transform:translateY(-2px); }

        .alert {
            margin:20px 0;padding:15px 20px;border-radius:8px;
            font-weight:600;animation:fadeAlert 0.4s ease-in-out;
            position:relative;box-shadow:0 4px 15px rgba(0,0,0,0.1);
        }
        .alert i { margin-right:8px; }
        .alert.success { background:#e6ffed;color:#2e7d32;border-left:5px solid #43a047; }
        .alert.error { background:#ffebee;color:#c62828;border-left:5px solid #e53935; }
        @keyframes fadeAlert { from {opacity:0;transform:translateY(-10px);} to {opacity:1;transform:translateY(0);} }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

<div class="main-content">
    <c:if test="${not empty param.success}">
        <div class="alert success">
            <i class="fas fa-check-circle"></i> ${param.success}
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert error">
            <i class="fas fa-exclamation-triangle"></i> ${param.error}
        </div>
    </c:if>

    <div class="header">
        <h2><i class="fas fa-users"></i> Quản Lý Nhân Viên</h2>
    </div>

    <!-- 🔍 Thanh lọc và tìm kiếm -->
    <form action="${pageContext.request.contextPath}/admin/staffManagement" method="get" class="filter-bar">
        <input type="text" name="keyword" placeholder="Tìm theo tên hoặc email..." value="${param.keyword}">
        <select name="status">
            <option value="">-- Lọc theo trạng thái --</option>
            <option value="1" ${param.status == '1' ? 'selected' : ''}>Đang hoạt động</option>
            <option value="0" ${param.status == '0' ? 'selected' : ''}>Đã khóa</option>
        </select>
        <button type="submit" class="btn btn-outline"><i class="fas fa-search"></i> Tìm kiếm</button>
    </form>

    <div class="card">
        <div class="card-header">
            <i class="fas fa-list"></i> Danh Sách Nhân Viên
        </div>
        <div class="card-body">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                        <th>Vai trò</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${staffList}" varStatus="i">
                        <c:if test="${not empty u.roles and u.roles[0].roleName == 'Staff'}">
                            <tr style="animation-delay:${i.index * 0.05}s;">
                                <td>${u.userID}</td>
                                <td>${u.fullName}</td>
                                <td>${u.email}</td>
                                <td>${u.phone}</td>

                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/staffManagement" method="post">
                                        <input type="hidden" name="action" value="toggleStatus">
                                        <input type="hidden" name="userId" value="${u.userID}">
                                        <input type="hidden" name="isActive" value="${u.active}">
                                        <button type="submit" 
                                            class="btn ${u.active ? 'btn-outline' : 'btn-primary'}" 
                                            style="padding:5px 10px;">
                                            <i class="fas ${u.active ? 'fa-toggle-on' : 'fa-toggle-off'}"></i>
                                            ${u.active ? 'Đang hoạt động' : 'Đã khóa'}
                                        </button>
                                    </form>
                                </td>

                                <td>
                                    <div class="action-btns">
                                        <a href="${pageContext.request.contextPath}/admin/viewProfile?id=${u.userID}" class="btn btn-info">
                                            <i class="fas fa-eye"></i> Xem
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/staffManagement?action=delete&id=${u.userID}"
                                           class="delete-btn"
                                           onclick="return confirm('Bạn có chắc muốn xóa nhân viên này không?');">
                                            <i class="fas fa-trash"></i> Xóa
                                        </a>
                                    </div>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/staffManagement" method="post">
                                        <input type="hidden" name="action" value="updateRole">
                                        <input type="hidden" name="userId" value="${u.userID}">

                                        <select name="roleId" class="btn btn-outline" style="padding:5px 10px;" onchange="this.form.submit()">
                                            <c:forEach var="r" items="${roles}">
                                                <c:if test="${r.roleName eq 'Staff' or r.roleName eq 'User' or r.roleName eq 'Shipper'}">
                                                    <option value="${r.roleID}" ${u.roles[0].roleID == r.roleID ? 'selected' : ''}>
                                                        ${r.roleName}
                                                    </option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${empty staffList}">
                <div style="text-align:center;padding:20px;color:#777;">
                    <i class="fas fa-info-circle"></i> Không có nhân viên nào được tìm thấy.
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    setTimeout(() => {
        document.querySelectorAll('.alert').forEach(a => {
            a.style.transition = 'opacity 0.6s';
            a.style.opacity = '0';
            setTimeout(() => a.remove(), 600);
        });
    }, 3000);
</script>
</body>
</html>

