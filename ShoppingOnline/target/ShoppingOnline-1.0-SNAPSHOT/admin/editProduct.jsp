<%@ page contentType="text/html;charset=UTF-8" language="java" import="
    java.util.List,
    java.math.BigDecimal,
    model.Product,
    model.Category,
    model.Brand,
    dao.ProductDAO,
    dao.CategoryDAO,
    dao.BrandDAO
"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // --- Lấy thông tin sản phẩm cần chỉnh sửa ---
    String idStr = request.getParameter("id");
    int productId = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : 0;

    ProductDAO productDAO = new ProductDAO();
    Product product = productDAO.getProductById(productId);

    // Nếu không tìm thấy sản phẩm -> quay lại trang quản lý
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/admin/productManagement?update=fail");
        return;
    }

    // Lấy danh sách danh mục và thương hiệu
    CategoryDAO categoryDAO = new CategoryDAO();
    List<Category> categoryList = categoryDAO.getAllCategories();

    BrandDAO brandDAO = new BrandDAO();
    List<Brand> brandList = brandDAO.getAllBrands();

    request.setAttribute("product", product);
    request.setAttribute("categoryList", categoryList);
    request.setAttribute("brandList", brandList);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Sản Phẩm | TechMart Admin</title>
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
            padding: 35px 45px;
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
            <h2><i class="fas fa-edit"></i> Chỉnh sửa sản phẩm</h2>
            <a href="${pageContext.request.contextPath}/admin/productManagement" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <form action="${pageContext.request.contextPath}/admin/productManagement" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="productId" value="${product.productId}">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Tên sản phẩm</label>
                    <input type="text" class="form-control" name="productName" 
                           value="${product.productName}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Mã sản phẩm</label>
                    <input type="text" class="form-control" name="productCode" 
                           value="${product.productCode}" readonly>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Danh mục</label>
                    <select class="form-select" name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="cat" items="${categoryList}">
                            <option value="${cat.categoryId}" 
                                <c:if test="${cat.categoryId == product.categoryId}">selected</c:if>>
                                ${cat.categoryName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Thương hiệu</label>
                    <select class="form-select" name="brandId" required>
                        <option value="">-- Chọn thương hiệu --</option>
                        <c:forEach var="b" items="${brandList}">
                            <option value="${b.brandId}" 
                                <c:if test="${b.brandId == product.brandId}">selected</c:if>>
                                ${b.brandName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">Giá nhập (VNĐ)</label>
                    <input type="number" class="form-control" name="priceImport"
                           value="${product.priceImport}" min="0" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Giá bán (VNĐ)</label>
                    <input type="number" class="form-control" name="price"
                           value="${product.price}" min="0" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Số lượng</label>
                    <input type="number" class="form-control" name="quantity" 
                           value="${product.quantity}" min="1" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Mô tả</label>
                <textarea class="form-control" name="description" rows="3">${product.description}</textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Trạng thái</label>
                <div class="radio-group">
                    <div>
                        <input type="radio" id="inStock" name="status" value="1"
                            <c:if test="${product.status == 1}">checked</c:if>>
                        <label for="inStock">Còn hàng</label>
                    </div>
                    <div>
                        <input type="radio" id="outStock" name="status" value="0"
                            <c:if test="${product.status == 0}">checked</c:if>>
                        <label for="outStock">Hết hàng</label>
                    </div>
                </div>
            </div>

            <div class="text-end mt-4">
                <button type="submit" class="btn-submit">
                    <i class="fas fa-check-circle"></i> Cập nhật sản phẩm
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
