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
        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            color: #333;
            overflow-x: hidden;
        }

        .main-content {
            margin-left: 270px;
            padding: 30px;
            min-height: 100vh;
        }
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
        }

        .header h2 {
            font-weight: 700;
            font-size: 26px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header h2 i {
            color: #667eea;
        }

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

        .btn-primary:hover {
            opacity: 0.9;
        }

        .btn-outline {
            border: 2px solid #667eea;
            background: transparent;
            color: #667eea;
        }

        .btn-outline:hover {
            background: #667eea;
            color: white;
        }

        .filter-bar {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .filter-bar input, .filter-bar select {
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            min-width: 200px;
        }

        .card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            animation: fadeIn 0.6s ease-in;
        }

        .card-header {
            padding: 20px 25px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            font-size: 18px;
            font-weight: 700;
            background: rgba(102,126,234,0.05);
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

        .edit-btn {
            background: #4facfe;
            color: white;
        }

        .delete-btn {
            background: #f5576c;
            color: white;
        }

        .edit-btn:hover, .delete-btn:hover {
            opacity: 0.8;
        }

        .fade-in {
            animation: fadeIn 0.7s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .badge {
            border-radius: 15px;
            padding: 5px 10px;
            font-size: 12px;
            color: white;
        }

        .badge.active { background: #28a745; }
        .badge.inactive { background: #e74c3c; }
    </style>
</head>

<body>

<%@ include file="sidebar.jsp" %>
<div class="main-content">
    <div class="header fade-in">
        <h2><i class="fas fa-boxes"></i> Quản Lý Sản Phẩm</h2>
        <a href="addProduct.jsp" class="btn btn-primary"><i class="fas fa-plus"></i> Thêm sản phẩm</a>
    </div>

    <div class="filter-bar fade-in">
        <input type="text" placeholder="Tìm theo tên sản phẩm..." name="search">
        <select name="categoryFilter">
            <option value="">-- Lọc theo danh mục --</option>
            <c:forEach var="cat" items="${categoryList}">
                <option value="${cat.categoryId}">${cat.categoryName}</option>
            </c:forEach>
        </select>
        <select name="statusFilter">
            <option value="">-- Trạng thái --</option>
            <option value="1">Đang bán</option>
            <option value="0">Ngừng bán</option>
        </select>
        <button class="btn btn-outline"><i class="fas fa-search"></i> Tìm kiếm</button>
    </div>

    <div class="card fade-in">
        <div class="card-header">
            <i class="fas fa-list"></i> Danh Sách Sản Phẩm
        </div>
        <div class="card-body">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
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
                    <c:forEach var="p" items="${productList}">
                        <tr>
                            <td>${p.productId}</td>
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
                                    <a href="deleteProduct?id=${p.productId}" 
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
        </div>
    </div>
</div>
</body>
</html>
