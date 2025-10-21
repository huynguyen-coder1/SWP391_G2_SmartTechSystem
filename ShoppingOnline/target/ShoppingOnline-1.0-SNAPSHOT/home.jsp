<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="model.Product" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>TechMart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

        <style>
            body {
                font-family: "Roboto", sans-serif;
                background: #f8f9fa;
            }
            .header {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                z-index: 999;
                background-color: white;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            main {
                margin-top: 120px;
            }
            .container h2 {
                font-weight: 700;
                margin-bottom: 40px;
                text-align: left;
            }
            .product-card {
                border: 1px solid #eee;
                padding: 15px;
                text-align: center;
                position: relative;
                background: #fff;
                transition: all 0.3s ease;
            }
            .product-card:hover {
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transform: translateY(-5px);
            }
            .product-label {
                position: absolute;
                top: 10px;
                left: 10px;
            }
            .product-label .sale {
                background: red;
                color: #fff;
                padding: 2px 6px;
                margin-right: 5px;
                font-size: 12px;
            }
            .product-label .new {
                background: #c00;
                color: #fff;
                padding: 2px 6px;
                font-size: 12px;
            }
            .product-img img {
                width: 100%;
                height: auto;
            }
            .category {
                color: #999;
                margin: 10px 0 5px;
                font-size: 13px;
            }
            .product-name {
                font-size: 16px;
                font-weight: bold;
            }
            .price {
                font-size: 14px;
                margin: 8px 0;
            }
            .price .new-price {
                color: red;
                font-weight: bold;
            }
            .price .old-price {
                text-decoration: line-through;
                color: #aaa;
                margin-left: 5px;
            }
            .rating i {
                color: #ff9800;
            }
            .product-actions {
                margin-top: 12px;
            }
            .product-actions i {
                margin: 0 8px;
                cursor: pointer;
                font-size: 16px;
                color: #333;
            }
            .product-actions i:hover {
                color: red;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <%@ include file="/includes/header.jsp" %>
        </div>
        <main>
            <div class="container">
                <h2>NEW PRODUCTS</h2>
                <div class="row g-4">
                    <%
                        ProductDAO dao = new ProductDAO();
                        List<Product> products = dao.getAllProducts();

                        if (products != null && !products.isEmpty()) {
                            for (Product p : products) {
                    %>
                    <div class="col-md-3 col-sm-6">
                        <div class="product-card">
                            <div class="product-img">
                                <img src="${pageContext.request.contextPath}/images/<%= p.getImages() %>" 
                                     alt="<%= p.getProductName() %>" width="200">


                            </div>
                            <h3 class="product-name"><%= p.getProductName() %></h3>
                            <p class="price">
                                <%
                                    java.text.NumberFormat currencyVN = 
                                            java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
                                    String priceFormatted = currencyVN.format(p.getPrice());
                                %>
                                <span class="new-price"><%= priceFormatted %></span>

                            </p>

                            <div class="product-actions">
                                <!-- Add to cart -->
                                <form action="<%= request.getContextPath() %>/cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                    <button type="submit" title="Add to cart">
                                        <i class="fa-solid fa-cart-shopping"></i>
                                    </button>
                                </form>
                                <!-- View detail -->
                              <a href="<%= request.getContextPath() %>/user/productDetail.jsp?id=<%= p.getProductId() %>" title="View detail">
    <i class="fa-regular fa-eye"></i>
</a>

                            </div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <p>No products available.</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </main>

        <%@ include file="/includes/footer.jsp" %>
    </body>
</html>