<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm - TechMart Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            margin: 0;
            color: #333;
        }

        .main-content {
            margin-left: 270px;
            padding: 40px;
            min-height: 100vh;
        }

        .form-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 30px 40px;
            max-width: 850px;
            margin: 0 auto;
            animation: fadeIn 0.6s ease-in;
        }

        h2 {
            font-weight: 700;
            font-size: 26px;
            margin-bottom: 25px;
            color: #333;
        }

        .form-label {
            font-weight: 600;
            color: #555;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #ddd;
            padding: 10px 14px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.2);
        }
		.btn-outline-primary {
    	border: 2px solid #667eea;
    	color: #667eea;
    	font-weight: 600;
    	border-radius: 10px;
    	transition: 0.3s;
    	padding: 10px 18px;
		}

		.btn-outline-primary:hover {
    	background: #667eea;
   	 	color: white;
		}
        .btn-submit {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            font-weight: 600;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            transition: 0.3s;
        }

        .btn-submit:hover {
            opacity: 0.9;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .radio-group {
            display: flex;
            gap: 30px;
            margin-top: 8px;
        }

        .radio-group label {
            font-weight: 500;
        }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div class="main-content">
    <div class="form-card">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-plus-circle"></i> Thêm sản phẩm mới</h2>
        <a href="productManagement.jsp" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <form action="addProduct" method="post">
        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label">Admin</label>
                <input type="text" class="form-control" 
                       value="<%= ((model.User) session.getAttribute("currentUser")).getFullName() %>" 
                       readonly>
            </div>
            <div class="col-md-6">
                <label class="form-label">Mã sản phẩm</label>
                <input type="text" class="form-control" placeholder="Tự động sinh" disabled>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Tên sản phẩm</label>
            <input type="text" class="form-control" name="productName" 
                   placeholder="VD: Laptop Dell XPS 13" required>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label">Danh mục</label>
                <select class="form-select" name="categoryId" required>
                    <option value="">-- Chọn danh mục --</option>
                    <option value="1">Laptop</option>
                    <option value="2">Bàn phím</option>
                    <option value="3">Chuột</option>
                    <option value="4">Phụ kiện</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">Thương hiệu</label>
                <select class="form-select" name="brandId" required>
                    <option value="">-- Chọn thương hiệu --</option>
                    <option value="1">Dell</option>
                    <option value="2">HP</option>
                    <option value="3">Asus</option>
                </select>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <label class="form-label">Giá nhập (VNĐ)</label>
                <input type="number" class="form-control" name="priceImport" 
                       placeholder="VD: 12000000" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Giá bán (VNĐ)</label>
                <input type="number" class="form-control" name="price" 
                       placeholder="VD: 15000000" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Số lượng</label>
                <input type="number" class="form-control" name="quantity" 
                       placeholder="VD: 10" min="1" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Mô tả</label>
            <textarea class="form-control" name="description" rows="3" 
                      placeholder="Mô tả ngắn về sản phẩm"></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Trạng thái</label>
            <div class="radio-group">
                <div>
                    <input type="radio" name="status" id="inStock" value="1" checked>
                    <label for="inStock">Còn hàng</label>
                </div>
                <div>
                    <input type="radio" name="status" id="outStock" value="0">
                    <label for="outStock">Hết hàng</label>
                </div>
            </div>
        </div>

        <div class="text-end mt-4">
            <button type="submit" class="btn-submit">
                <i class="fas fa-check-circle"></i> Lưu sản phẩm
            </button>
        </div>
    </form>
</div>
</div>

</body>
</html>
