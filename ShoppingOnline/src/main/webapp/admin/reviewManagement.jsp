<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Feedback - TechMart Admin</title>

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

        .card-custom {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            padding: 30px 40px;
            margin-bottom: 30px;
            transition: 0.4s;
        }

        h2 {
            font-weight: 700;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }

        th {
            background: rgba(102,126,234,0.1);
            text-transform: uppercase;
            font-size: 13px;
        }

        .btn-toggle {
            border: none;
            padding: 6px 12px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            color: #fff;
        }

        .btn-hide { background: #e74c3c; }
        .btn-show { background: #28a745; }

        .fade-in {
            animation: fadeIn 0.7s ease-in;
        }

        @keyframes fadePage {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

<div class="main-content fade-in">
    <div class="card-custom">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-comment-dots me-2"></i> Quản lý Feedback</h2>
            <a href="${pageContext.request.contextPath}/admin/adminPage.jsp" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-1"></i> Quay lại
            </a>
        </div>

        <c:if test="${not empty reviews}">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Người dùng</th>
                        <th>Rating</th>
                        <th>Bình luận</th>
                        <th>Ngày tạo</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${reviews}">
                        <tr>
                            <td>${r.id}</td>
                            <td>${r.productName}</td>
                            <td>${r.userName}</td>
                            <td>${r.rating} <i class="fas fa-star text-warning"></i></td>
                            <td>${r.comment}</td>
                            <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <span class="${r.status == 1 ? 'text-success fw-bold' : 'text-danger fw-bold'}">
                                    ${r.status == 1 ? 'Hiện' : 'Ẩn'}
                                </span>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/admin/reviewManagement">
                                    <input type="hidden" name="id" value="${r.id}"/>
                                    <input type="hidden" name="status" value="${r.status == 1 ? 0 : 1}"/>
                                    <button type="submit" class="btn-toggle ${r.status == 1 ? 'btn-hide' : 'btn-show'}">
                                        ${r.status == 1 ? 'Ẩn' : 'Hiện'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty reviews}">
            <div class="text-center py-5">
                <h5>Chưa có feedback nào.</h5>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>
