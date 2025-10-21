<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.sql.Timestamp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn hàng</title>
        <style>
            body {
                font-family: "Segoe UI";
                background: #f6f7fb;
                padding: 30px;
            }
            .container {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                max-width: 900px;
                margin: 0 auto;
            }
            h2 {
                color: #333;
                margin-bottom: 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }
            th, td {
                border-bottom: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            th {
                background: #f0f3f9;
                text-transform: uppercase;
                font-size: 13px;
            }
            .total {
                font-weight: bold;
                text-align: right;
            }
            .back {
                margin-top: 20px;
                display: inline-block;
                text-decoration: none;
                padding: 10px 15px;
                background: #3a7bd5;
                color: white;
                border-radius: 6px;
            }
            .back:hover {
                opacity: 0.9;
            }
            .info-box p {
                margin: 5px 0;
                font-size: 15px;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <%
                Map<String, Object> orderInfo = (Map<String, Object>) request.getAttribute("orderInfo");
                List<Map<String, Object>> orderDetails = (List<Map<String, Object>>) request.getAttribute("orderDetails");
            %>

            <h2>🧾 Chi tiết đơn hàng #<%= orderInfo.get("Id") %></h2>

            <div class="info-box">
                <p><strong>Khách hàng:</strong> <%= orderInfo.get("FullName") %></p>
                <p><strong>Email:</strong> <%= orderInfo.get("Email") %></p>
                <p><strong>Điện thoại:</strong> <%= orderInfo.get("Phone") %></p>
                <p><strong>Địa chỉ:</strong> <%= orderInfo.get("Address") %></p>
                <p><strong>Ngày đặt:</strong> <%= orderInfo.get("OrderDate") %></p>
            </div>

            <h3>Sản phẩm trong đơn hàng:</h3>
            <table>
                <thead>
                    <tr>
                        <th>Ảnh</th>
                        <th>Mã sản phẩm</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        BigDecimal total = BigDecimal.ZERO;
                        for (Map<String, Object> d : orderDetails) { 
                            BigDecimal lineTotal = (BigDecimal) d.get("Total");
                            total = total.add(lineTotal);
                    %>
                    <tr>
                        <td>
                            <img src="<%= request.getContextPath() %>/images/<%= d.get("Images") %>" 
                                 alt="<%= d.get("ProductName") %>" 
                                 style="width: 70px; height: 70px; border-radius: 8px; object-fit: cover;">
                        </td>
                        <td><%= d.get("ProductId") %></td>
                        <td><%= d.get("ProductName") %></td>
                        <td>₫<%= String.format("%,.0f", d.get("Price")) %></td>
                        <td><%= d.get("Quantity") %></td>
                        <td>₫<%= String.format("%,.0f", d.get("Total")) %></td>
                    </tr>
                    <% } %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="5" class="total">Tổng cộng:</td>
                        <td><strong>₫<%= String.format("%,.0f", total) %></strong></td>
                    </tr>
                </tfoot>
            </table>


            <a href="<%= request.getContextPath() %>/ordermanagement" class="back">← Quay lại danh sách</a>
        </div>

    </body>
</html>
