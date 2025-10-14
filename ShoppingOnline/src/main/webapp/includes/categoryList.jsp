<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Category"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách danh mục</title>
    <style>
        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
    </style>
</head>
<body>
    <h2 style="text-align:center;">Danh sách danh mục</h2>
    <table>
        <tr>
            <th>Id</th>
            <th>Tên danh mục</th>
            <th>Mô tả</th>
            <th>Ngày tạo</th>
            <th>Ngày cập nhật</th>
            <th>Trạng thái</th>
        </tr>
        <%
            List<Category> list = (List<Category>) request.getAttribute("listCategory");
            if (list != null && !list.isEmpty()) {
                for (Category c : list) {
        %>
        <tr>
            <td><%= c.getCategoryId() %></td>
            <td><%= c.getCategoryName() %></td>
            <td><%= c.getDescription() %></td>
            <td><%= c.getCreatedAt() %></td>
            <td><%= c.getUpdatedAt() %></td>
            <td><%= c.getStatus() == 1 ? "Hoạt động" : "Ngừng" %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="6">Không có dữ liệu</td></tr>
        <% } %>
    </table>
</body>
</html>
