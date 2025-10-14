<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Thương Hiệu | TechMart Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* Sử dụng CSS giống như categoryManagement.jsp */
        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            color: #333;
            overflow-x: hidden;
        }
        .main-content { margin-left: 270px; padding: 30px; min-height: 100vh; }
        .header { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(20px); padding: 25px 30px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
        .header h2 { font-weight: 700; font-size: 26px; color: #333; display: flex; align-items: center; gap: 10px; }
        .btn { border: none; padding: 10px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; text-transform: uppercase; cursor: pointer; transition: 0.3s; text-decoration: none; }
        .btn-primary { background: linear-gradient(135deg, #667eea, #764ba2); color: white; }
        .btn-primary:hover { opacity: 0.9; }
        .btn-outline { border: 2px solid #667eea; background: transparent; color: #667eea; }
        .btn-outline:hover { background: #667eea; color: white; }
        .filter-bar { display: flex; gap: 15px; align-items: center; margin-bottom: 25px; flex-wrap: wrap; }
        .filter-bar input, .filter-bar select { padding: 10px 12px; border-radius: 8px; border: 1px solid #ccc; font-size: 14px; min-width: 200px; }
        .card { background: rgba(255,255,255,0.95); border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border-bottom: 1px solid rgba(0,0,0,0.1); text-align: left; }
        th { background: rgba(102,126,234,0.1); text-transform: uppercase; font-size: 13px; }
        .action-btns { display: flex; gap: 8px; }
        .action-btns a { padding: 6px 10px; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600; transition: 0.2s; }
        .edit-btn { background: #4facfe; color: white; }
        .delete-btn { background: #f5576c; color: white; }
        .badge { border-radius: 15px; padding: 5px 10px; font-size: 12px; color: white; }
        .badge.active { background: #28a745; }
        .badge.inactive { background: #e74c3c; }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

<div class="main-content">
    <div class="header">
        <h2><i class="fas fa-tag"></i> Quản Lý Thương Hiệu</h2>
        <a href="addBrand.jsp" class="btn btn-primary"><i class="fas fa-plus"></i> Thêm thương hiệu</a>
    </div>

    <!-- FORM TÌM KIẾM -->
    <form action="${pageContext.request.contextPath}/admin/brandManagement" method="get" class="filter-bar">
        <input type="text" name="search" placeholder="Tìm theo tên thương hiệu..." value="${param.search}">
        <select name="statusFilter">
            <option value="">-- Lọc theo trạng thái --</option>
            <option value="1" ${param.statusFilter == '1' ? 'selected' : ''}>Đang hoạt động</option>
            <option value="0" ${param.statusFilter == '0' ? 'selected' : ''}>Ngừng hoạt động</option>
        </select>
        <button type="submit" class="btn btn-outline"><i class="fas fa-search"></i> Tìm kiếm</button>
    </form>

    <div class="card">
        <div style="padding: 20px;">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên Thương Hiệu</th>
                        <th>Mô Tả</th>
                        <th>Trạng Thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="brand" items="${brandList}">
                        <tr>
                            <td>${brand.brandId}</td>
                            <td>${brand.brandName}</td>
                            <td>${brand.description}</td>
                            <td>
                                <span class="badge ${brand.status == 1 ? 'active' : 'inactive'}">
                                    ${brand.status == 1 ? 'Đang hoạt động' : 'Ngừng hoạt động'}
                                </span>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <a href="updateBrand?id=${brand.brandId}" class="edit-btn"><i class="fas fa-edit"></i> Sửa</a>
                                    <a href="${pageContext.request.contextPath}/DeleteBrandServlet?brandId=${brand.brandId}"
                                       onclick="return confirm('Bạn có chắc muốn xóa thương hiệu [${brand.brandName}] này?');"
                                       class="delete-btn">
                                       <i class="fas fa-trash-alt"></i> Xóa
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${empty brandList}">
                <div style="text-align:center;padding:20px;color:#777;">
                    <i class="fas fa-info-circle"></i> Không tìm thấy thương hiệu nào.
                </div>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
