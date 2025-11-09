<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    User staff = (User) request.getAttribute("staff");
    String message = (String) session.getAttribute("profileMessage");
    if (message != null) {
        session.removeAttribute("profileMessage");
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ Nhân viên - TechMart Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {margin:0;font-family:"Segoe UI",sans-serif;background:linear-gradient(135deg,#3a7bd5,#3a6073);color:#333;overflow-x:hidden;animation:fadePage .6s ease-in;}
        .main-content{margin-left:270px;padding:50px 40px;min-height:100vh;}
        .profile-card{background:#fff;border-radius:20px;box-shadow:0 10px 40px rgba(0,0,0,0.08);padding:40px 50px;max-width:900px;margin:0 auto;position:relative;transition:.4s;animation:fadeInUp .8s ease;}
        .back-btn{position:absolute;top:20px;right:20px;background:linear-gradient(135deg,#667eea,#764ba2);color:white;padding:8px 14px;border-radius:8px;text-decoration:none;font-size:14px;transition:.3s;}
        .back-btn:hover{background:linear-gradient(135deg,#5a6edc,#6d3c9c);}
        .avatar{width:160px;height:160px;border-radius:50%;border:4px solid #667eea;object-fit:cover;}
        .role-badge{display:inline-block;padding:6px 14px;border-radius:20px;background:linear-gradient(135deg,#667eea,#764ba2);color:white;font-weight:600;font-size:13px;margin-top:8px;}
        .form-control:focus{border-color:#667eea;box-shadow:0 0 0 .2rem rgba(102,126,234,.25);}
        .btn-save{background:linear-gradient(135deg,#667eea,#764ba2);color:white;font-weight:600;border-radius:10px;padding:12px 20px;width:100%;transition:.3s;}
        .btn-save:hover{background:linear-gradient(135deg,#5a6edc,#6d3c9c);}
        .fade-message{animation:fadeIn .8s ease;}
        @keyframes fadePage{from{opacity:0;transform:translateY(20px);}to{opacity:1;transform:translateY(0);}}
        @keyframes fadeInUp{from{opacity:0;transform:translateY(30px);}to{opacity:1;transform:translateY(0);}}
        @keyframes fadeIn{from{opacity:0;}to{opacity:1;}}
    </style>
</head>
<body>
<%@ include file="staffsidebar.jsp" %>
<div class="main-content">
    <div class="profile-card">
        <div class="text-center mb-4">
            <img src="${empty staff.avatarUrl ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png' : staff.avatarUrl}"
                 alt="Avatar" class="avatar mb-3">
            <h3 class="fw-bold mb-1">${staff.fullName}</h3>
            <c:forEach var="role" items="${staff.roles}">
                <div class="role-badge">${role.roleName}</div>
            </c:forEach>
        </div>
        <c:if test="${not empty message}">
            <div class="alert alert-info text-center fade-message">${message}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/staff/staffProfile" method="post">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label"><i class="fas fa-user me-1"></i> Họ và tên</label>
                    <input type="text" name="fullName" value="${staff.fullName}" class="form-control" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label"><i class="fas fa-envelope me-1"></i> Email</label>
                    <input type="email" value="${staff.email}" class="form-control" disabled>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label"><i class="fas fa-phone me-1"></i> Số điện thoại</label>
                    <input type="text" name="phone" value="${staff.phone}" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label"><i class="fas fa-calendar-alt me-1"></i> Ngày sinh</label>
                    <input type="date" name="dateOfBirth"
                           value="<%= staff.getDateOfBirth() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(staff.getDateOfBirth()) : "" %>"
                           class="form-control">
                </div>
                <div class="col-md-12 mb-3">
                    <label class="form-label"><i class="fas fa-map-marker-alt me-1"></i> Địa chỉ</label>
                    <input type="text" name="address" value="${staff.address}" class="form-control">
                </div>
            </div>
            <button type="submit" class="btn btn-save mt-3">
                <i class="fas fa-save me-1"></i> Lưu thay đổi
            </button>
        </form>
    </div>
</div>
</body>
</html>