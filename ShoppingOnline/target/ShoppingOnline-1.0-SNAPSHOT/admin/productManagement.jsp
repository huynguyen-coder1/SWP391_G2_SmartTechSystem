<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm | TechMart Admin</title>
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

        /* ===== Button ===== */
        .btn {
            border: none;
            padding: 10px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        .btn-primary:hover { opacity: 0.9; transform: translateY(-2px); }

        .btn-outline {
            border: 2px solid #667eea;
            background: transparent;
            color: #667eea;
        }
        .btn-outline:hover { background: #667eea; color: white; }

        /* ===== Thanh lọc & tìm kiếm ===== */
        .filter-bar {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
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

        /* ===== Nút hành động ===== */
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

        .edit-btn { background: #4facfe; color: white; }
        .delete-btn { background: #f5576c; color: white; }

        .edit-btn:hover, .delete-btn:hover {
            opacity: 0.8;
            transform: scale(1.05);
        }

        /* ===== Badge trạng thái ===== */
        .badge {
            border-radius: 15px;
            padding: 5px 10px;
            font-size: 12px;
            color: white;
        }

        .badge.active { background: #28a745; }
        .badge.inactive { background: #e74c3c; }

        /* ===== Thông báo ===== */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            animation: fadeIn 0.6s ease;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 6px solid #28a745;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 6px solid #e74c3c;
        }

        .alert i { font-size: 18px; }

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
    <!-- Thông báo -->
    <c:if test="${param.add eq 'success'}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> Thêm sản phẩm thành công!</div>
    </c:if>
    <c:if test="${param.delete eq 'success'}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> Xóa sản phẩm thành công!</div>
    </c:if>
    <c:if test="${param.delete eq 'fail'}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Xóa sản phẩm thất bại!</div>
    </c:if>
    <c:if test="${param.update eq 'success'}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> Cập nhật sản phẩm thành công!</div>
    </c:if>
    <c:if test="${param.update eq 'fail'}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Cập nhật sản phẩm thất bại!</div>
    </c:if>

    <!-- Header -->
    <div class="header">
        <h2><i class="fas fa-boxes"></i> Quản Lý Sản Phẩm</h2>
        <a href="${pageContext.request.contextPath}/admin/productManagement?action=add" class="btn btn-primary"><i class="fas fa-plus"></i> Thêm sản phẩm</a>
    </div>

    <!-- Bộ lọc -->
    <form method="get" class="filter-bar">
        <input type="text" name="search" placeholder="Tìm theo tên sản phẩm..." value="${param.search}">
        <select name="categoryId">
            <option value="">-- Lọc theo danh mục --</option>
            <c:forEach var="cat" items="${categoryList}">
                <option value="${cat.categoryId}" <c:if test="${param.categoryId == cat.categoryId}">selected</c:if>>
                    ${cat.categoryName}
                </option>
            </c:forEach>
        </select>
        <select name="status">
            <option value="">-- Trạng thái --</option>
            <option value="1" <c:if test="${param.status == '1'}">selected</c:if>>Đang bán</option>
            <option value="0" <c:if test="${param.status == '0'}">selected</c:if>>Ngừng bán</option>
        </select>
        <button type="submit" class="btn btn-outline"><i class="fas fa-search"></i> Tìm kiếm</button>
    </form>

    <!-- Bảng sản phẩm -->
    <div class="card">
        <div class="card-header">
            <i class="fas fa-list"></i> Danh Sách Sản Phẩm
        </div>
        <div class="card-body">
            <table>
                <thead>
    <tr>
        <th>ID</th>
        <th>Ảnh</th> <!-- thêm cột ảnh -->
        <th>Mã SP</th>
        <th>Tên sản phẩm</th>
        <th>Danh mục</th>
        <th>Thương hiệu</th>
        <th>Giá nhập</th>
        <th>Giá bán</th>
        <th>Số lượng</th>
        <th>Trạng thái</th>
        <th>Hành động</th>
    </tr>
</thead>

<tbody>
    <c:forEach var="p" items="${productList}" varStatus="i">
        <tr style="animation-delay: ${i.index * 0.05}s;">
            <td>${p.productId}</td>

            <!-- 🌸 Hiển thị ảnh -->
            <td>
    <c:choose>
        <c:when test="${not empty p.images}">
            <img src="${pageContext.request.contextPath}/images/${p.images}"
                 alt="${p.productName}"
                 style="width:60px;height:60px;object-fit:cover;border-radius:8px;border:1px solid #ccc;">
        </c:when>
        <c:otherwise>
            <img src="${pageContext.request.contextPath}/images/default.png"
                 alt="No image"
                 style="width:60px;height:60px;object-fit:cover;border-radius:8px;border:1px solid #ccc;">
        </c:otherwise>
    </c:choose>
</td>

            <td>${p.productCode}</td>
            <td>${p.productName}</td>
            <td>${p.categoryName}</td>
            <td>${p.brandName}</td>
            <td>₫<fmt:formatNumber value="${p.priceImport}" type="number"/></td>
            <td>₫<fmt:formatNumber value="${p.price}" type="number"/></td>
            <td>${p.quantity}</td>

            <td>
                <span class="badge ${p.status == 1 ? 'active' : 'inactive'}">
                    ${p.status == 1 ? 'Đang bán' : 'Ngừng bán'}
                </span>
            </td>

            <td>
                <div class="action-btns">
                    <a href="editProduct.jsp?id=${p.productId}" class="edit-btn">
                        <i class="fas fa-edit"></i> Sửa
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/productManagement?action=delete&id=${p.productId}"
                       onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?');"
                       class="delete-btn">
                        <i class="fas fa-trash-alt"></i> Xóa
                    </a>
                </div>
            </td>
        </tr>
    </c:forEach>
</tbody>
            </table>

            <c:if test="${empty productList}">
                <div style="text-align:center;padding:20px;color:#777;">
                    <i class="fas fa-info-circle"></i> Không tìm thấy sản phẩm nào.
                </div>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>



