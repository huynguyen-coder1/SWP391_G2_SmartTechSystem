<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông Tin Nhân Viên - TechMart Admin</title>

    <!-- Bootstrap & Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
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
            padding: 50px 40px;
            min-height: 100vh;
        }

        .form-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            padding: 40px 50px;
            max-width: 900px;
            margin: 0 auto;
            transition: 0.4s;
        }

        .avatar {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            border: 4px solid #667eea;
            object-fit: cover;
        }

        .info-item {
            font-size: 16px;
            margin-bottom: 12px;
        }

        .info-item i {
            color: #667eea;
            width: 25px;
        }

        .status-active {
            color: #27ae60;
            font-weight: 600;
        }

        .status-inactive {
            color: #e74c3c;
            font-weight: 600;
        }

        .role-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            font-weight: 600;
            font-size: 13px;
            margin-top: 8px;
        }

        .btn-outline-primary {
            border: 2px solid #667eea;
            color: #667eea;
            font-weight: 600;
            border-radius: 10px;
            transition: 0.3s;
            padding: 10px 20px;
        }

        .btn-outline-primary:hover {
            background: #667eea;
            color: white;
        }

        @keyframes fadePage {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

<div class="main-content fade-in">
    <div class="form-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-user-circle me-2"></i> Thông tin nhân viên</h2>
            <a href="${pageContext.request.contextPath}/admin/staffManagement" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-1"></i> Quay lại
            </a>
        </div>

        <c:if test="${not empty user}">
            <div class="text-center mb-4">
                <img src="${empty user.avatarUrl ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png' : user.avatarUrl}"
                     alt="Avatar" class="avatar mb-3">
                <h3 class="fw-bold mb-1">${user.fullName}</h3>

                <!-- Hiển thị danh sách vai trò -->
                <c:forEach var="role" items="${user.roles}">
                    <div class="role-badge">${role.roleName}</div>
                </c:forEach>
            </div>

            <div class="px-2">
                <div class="info-item"><i class="fas fa-envelope"></i> <strong>Email:</strong> ${user.email}</div>
                <div class="info-item"><i class="fas fa-phone"></i> <strong>Số điện thoại:</strong> ${user.phone}</div>
                <div class="info-item"><i class="fas fa-calendar-alt"></i> <strong>Ngày tạo:</strong> ${user.createdAt}</div>
                <div class="info-item"><i class="fas fa-map-marker-alt"></i> <strong>Địa chỉ:</strong> ${user.address}</div>
                <div class="info-item"><i class="fas fa-check-circle"></i>
                    <strong>Trạng thái:</strong>
                    <span class="${user.active ? 'status-active' : 'status-inactive'}">
                        ${user.active ? 'Đang hoạt động' : 'Bị khóa'}
                    </span>
                </div>
            </div>
        </c:if>

        <c:if test="${empty user}">
            <div class="text-center py-5">
                <h5>Không tìm thấy thông tin người dùng.</h5>
                <a href="${pageContext.request.contextPath}/admin/staffManagement" class="btn btn-outline-primary mt-3">
                    <i class="fas fa-arrow-left me-1"></i> Trở về
                </a>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>
