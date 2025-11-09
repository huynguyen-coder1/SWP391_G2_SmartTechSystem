<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>

<%
    Product product = (Product) request.getAttribute("product");
    long orderId = (Long) request.getAttribute("orderId");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đánh giá sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        body { font-family: "Roboto", sans-serif; background: #f8f9fa; }
        .header { width: 100%; z-index: 999; background-color: white; }
        main { margin-top: 120px; margin-bottom: 30px; }
        .container h2 { font-weight: 700; margin-bottom: 40px; text-align: left; }
        .product-card { background: white; padding: 20px; border-radius: 10px; margin-bottom: 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .product-card img { max-width: 150px; border-radius: 5px; }
        .rating i { cursor: pointer; color: #ffc107; }
        textarea { resize: none; }
    </style>
    <script>
        function setRating(value) {
            document.getElementById('ratingInput').value = value;
            let stars = document.querySelectorAll('.rating i');
            stars.forEach((star, index) => {
                if(index < value) star.classList.add('fas');
                else star.classList.remove('fas');
                if(index < value) star.classList.remove('far');
                else star.classList.add('far');
            });
        }
    </script>
</head>
<body>
    <div class="header">
        <%@ include file="/includes/header.jsp" %>
    </div>

    <main>
        <div class="container">
            <h2>Đánh giá sản phẩm: <%= product.getProductName() %></h2>

            <div class="product-card d-flex align-items-center">
                <img src="<%= request.getContextPath() + "/images/" + product.getImages() %>" alt="<%= product.getProductName() %>">
                <div class="ms-4">
                    <h4><%= product.getProductName() %></h4>
                    <p>Giá: <strong><%= String.format("%,d", product.getPrice()) %>₫</strong></p>
                </div>
            </div>

            <form action="<%= request.getContextPath() %>/user/feedbackForm" method="post">
                <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                <input type="hidden" name="orderId" value="<%= orderId %>">
                <input type="hidden" name="rating" id="ratingInput" value="5">
                <input type="hidden" name="userId" value="<%= String.valueOf(request.getAttribute("userId")) %>">
                <div class="mb-3">
                    <label class="form-label"><strong>Đánh giá:</strong></label>
                    <div class="rating">
                        <i class="fas fa-star" onclick="setRating(1)"></i>
                        <i class="fas fa-star" onclick="setRating(2)"></i>
                        <i class="fas fa-star" onclick="setRating(3)"></i>
                        <i class="fas fa-star" onclick="setRating(4)"></i>
                        <i class="fas fa-star" onclick="setRating(5)"></i>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="comment" class="form-label"><strong>Bình luận:</strong></label>
                    <textarea class="form-control" id="comment" name="comment" rows="5" placeholder="Viết nhận xét của bạn..." required></textarea>
                </div>

                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-paper-plane"></i> Gửi đánh giá</button>
                <a href="<%= request.getContextPath() %>/myOrders" class="btn btn-secondary ms-2">Quay lại đơn hàng</a>
            </form>
        </div>
    </main>

    <%@ include file="/includes/footer.jsp" %>
</body>
</html>
