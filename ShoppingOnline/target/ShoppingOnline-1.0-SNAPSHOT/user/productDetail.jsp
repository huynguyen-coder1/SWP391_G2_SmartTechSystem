<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO, dao.ReviewDAO, model.Product, model.Review, java.util.*" %>

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
        main {
            margin-bottom: 80px;
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
            display: flex;
            align-items: center;
            flex-wrap: wrap;
        }
        .rating-summary {
            margin-left: 15px;
            font-size: 16px;
        }
        .product-info .price {
            color: red;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 20px;
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
        .btn-back:hover {
            background-color: #e0e0e0;
            transform: translateX(-3px);
        }
        .stock-status {
            font-weight: bold;
            color: green;
        }
        .stock-status.out-of-stock {
            color: red;
        }
        /* Review section */
        .review-section {
            margin-top: 60px;
        }
        .review-card {
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Shopee-style filter buttons */
        .rating-filter {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 25px;
        }
        .rating-btn {
            border: 1px solid #ccc;
            border-radius: 20px;
            background: white;
            color: #333;
            padding: 6px 16px;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.25s;
        }
        .rating-btn:hover {
            border-color: #ee4d2d;
            color: #ee4d2d;
        }
        .rating-btn.active {
            background: #ffeee8;
            border-color: #ee4d2d;
            color: #ee4d2d;
            font-weight: 500;
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
                        ReviewDAO reviewDAO = new ReviewDAO();

                        // --- Lọc theo số sao ---
                        String ratingParam = request.getParameter("rating");
                        int ratingFilter = 0;
                        if (ratingParam != null && !ratingParam.isEmpty()) {
                            try {
                                ratingFilter = Integer.parseInt(ratingParam);
                            } catch (NumberFormatException ex) {
                                ratingFilter = 0;
                            }
                        }

                        List<Review> reviews = reviewDAO.getReviewsByProductIdAndRating(p.getProductId(), ratingFilter);

                        // --- Tính trung bình đánh giá ---
                        double avgRating = 0.0;
                        int reviewCount = reviews.size();
                        if (reviewCount > 0) {
                            int sum = 0;
                            for (Review r : reviews) sum += r.getRating();
                            avgRating = (double) sum / reviewCount;
                        }

                        int fullStars = (int) avgRating;
                        boolean halfStar = (avgRating - fullStars >= 0.5);
                        int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
        %>

        <!-- Nút quay lại -->
        <a href="javascript:history.back()" class="btn-back mb-4 d-inline-block">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>

        <div class="row product-detail align-items-center">
            <div class="col-md-5 product-img text-center">
                <img src="<%= request.getContextPath() %>/images/<%= p.getImages() %>" 
                     alt="<%= p.getProductName() %>" class="img-fluid">
            </div>
            <div class="col-md-7 product-info">
                

                <p class="price">
                    <%
                        java.text.NumberFormat currencyVN = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi","VN"));
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

                <% if(p.getQuantity() > 0){ %>
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

        <!-- Review Section -->
        <div class="review-section">
            <h4 class="mb-4">Đánh giá từ khách hàng</h4>

            <!-- Bộ lọc kiểu Shopee -->
            <div class="rating-filter">
                <a href="?id=<%= p.getProductId() %>&rating=0" class="rating-btn <%= (ratingFilter==0)?"active":"" %>">Tất cả</a>
                <a href="?id=<%= p.getProductId() %>&rating=5" class="rating-btn <%= (ratingFilter==5)?"active":"" %>">5 sao</a>
                <a href="?id=<%= p.getProductId() %>&rating=4" class="rating-btn <%= (ratingFilter==4)?"active":"" %>">4 sao</a>
                <a href="?id=<%= p.getProductId() %>&rating=3" class="rating-btn <%= (ratingFilter==3)?"active":"" %>">3 sao</a>
                <a href="?id=<%= p.getProductId() %>&rating=2" class="rating-btn <%= (ratingFilter==2)?"active":"" %>">2 sao</a>
                <a href="?id=<%= p.getProductId() %>&rating=1" class="rating-btn <%= (ratingFilter==1)?"active":"" %>">1 sao</a>
            </div>

            <% if(reviews.isEmpty()){ %>
                <p class="text-muted fst-italic">Chưa có đánh giá nào cho sản phẩm này.</p>
            <% } else { %>
                <% for(Review r : reviews){ %>
                    <div class="card mb-3 review-card">
                        <div class="card-body">
                            <div class="review-header mb-2">
                                <strong><i class="fa-solid fa-user"></i> <%= r.getUserName() %></strong>
                                <small class="text-muted">
                                    <i class="fa-regular fa-clock"></i>
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(r.getCreatedAt()) %>
                                </small>
                            </div>
                            <div class="mb-2">
                                <% for(int i=1;i<=5;i++){ %>
                                    <% if(i<=r.getRating()){ %>
                                        <i class="fa-solid fa-star text-warning"></i>
                                    <% } else { %>
                                        <i class="fa-regular fa-star text-secondary"></i>
                                    <% } %>
                                <% } %>
                            </div>
                            <p class="mb-0"><%= r.getComment() %></p>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <%
                    } else {
        %>
            <div class="alert alert-warning mt-5">Product not found.</div>
        <%
                    }
                } catch(NumberFormatException e){
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
