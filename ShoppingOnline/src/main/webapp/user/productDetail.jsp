<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO" %>
<%@ page import="model.Product" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Detail - TechMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: "Roboto", sans-serif;
        }
        .product-detail {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .product-img img {
            max-width: 100%;
            border-radius: 10px;
        }
        .product-info h2 {
            font-weight: 700;
            margin-bottom: 10px;
        }
        .product-info .price {
            color: red;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .product-info p {
            font-size: 15px;
            color: #333;
        }
        .btn-add-cart {
            background-color: #0d6efd;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .btn-add-cart:hover {
            background-color: #084298;
            transform: translateY(-2px);
        }
        .btn-back {
            background-color: #f1f1f1;
            color: #333;
            border: none;
            padding: 8px 18px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-back i {
            margin-right: 6px;
        }
        .btn-back:hover {
            background-color: #e0e0e0;
            color: #000;
            transform: translateX(-3px);
        }
        .stock-status {
            font-weight: bold;
            color: green;
        }
        .stock-status.out-of-stock {
            color: red;
        }
    </style>
</head>
<body>
    <div class="header">
        <%@ include file="/includes/header.jsp" %>
    </div>

    <main class="container mt-5 pt-5">
        <%
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int productId = Integer.parseInt(idParam);
                    ProductDAO dao = new ProductDAO();
                    Product p = dao.getProductById(productId);

                    if (p != null) {
        %>

        <!-- 🔙 Nút quay lại -->
        <a href="javascript:history.back()" class="btn-back mb-4 d-inline-block">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>

        <div class="row product-detail align-items-center">
            <div class="col-md-5 product-img text-center">
                <img src="<%= request.getContextPath() %>/images/<%= p.getImages() %>" 
     alt="<%= p.getProductName() %>" class="img-fluid">

            </div>
            <div class="col-md-7 product-info">
                <h2><%= p.getProductName() %></h2>

                <p class="price">
                    <%
                        java.text.NumberFormat currencyVN = 
                            java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
                        String priceFormatted = currencyVN.format(p.getPrice());
                    %>
                    <%= priceFormatted %>
                </p>

                <p><strong>Category:</strong> <%= p.getCategoryName() != null ? p.getCategoryName() : "N/A" %></p>
                <p><strong>Brand:</strong> <%= p.getBrandName() != null ? p.getBrandName() : "Unknown" %></p>
                <p>
                    <strong>Quantity:</strong> 
                    <span class="stock-status <%= (p.getQuantity() <= 0) ? "out-of-stock" : "" %>">
                        <%= p.getQuantity() > 0 ? p.getQuantity() + " in stock" : "Out of stock" %>
                    </span>
                </p>

                <p><strong>Description:</strong></p>
                <p><%= p.getDescription() != null ? p.getDescription() : "No description available." %></p>

                <% if (p.getQuantity() > 0) { %>
                <form action="<%= request.getContextPath() %>/cart" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                    <button type="submit" class="btn-add-cart mt-2">
                        <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                    </button>
                </form>
                <% } else { %>
                <button class="btn btn-secondary mt-2" disabled>
                    <i class="fa-solid fa-ban"></i> Hết hàng
                </button>
                <% } %>
            </div>
        </div>

        <%
                    } else {
        %>
            <div class="alert alert-warning mt-5">Product not found.</div>
        <%
                    }
                } catch (NumberFormatException e) {
        %>
            <div class="alert alert-danger mt-5">Invalid product ID.</div>
        <%
                }
            } else {
        %>
            <div class="alert alert-info mt-5">No product selected.</div>
        <%
            }
        %>
    </main>

    <%@ include file="/includes/footer.jsp" %>
</body>
</html>
