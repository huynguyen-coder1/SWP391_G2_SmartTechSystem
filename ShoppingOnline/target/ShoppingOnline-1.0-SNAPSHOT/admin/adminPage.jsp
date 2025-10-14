<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TechMart Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
    	.admin-header {
    	background: rgba(255,255,255,0.95);
    	backdrop-filter: blur(20px);
    	padding: 20px 30px;
    	margin-left: 270px;
    	border-radius: 0 0 20px 20px;
    	box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    	display: flex;
    	justify-content: flex-end;
    	align-items: center;
    	position: sticky;
    	top: 0;
    	z-index: 1000;
		}

		.admin-info {
    	display: flex;
    	align-items: center;
    	gap: 20px;
		}

		.admin-welcome {
    	font-size: 16px;
    	font-weight: 500;
    	color: #333;
    	display: flex;
    	align-items: center;
   		gap: 10px;
		}

		.admin-welcome i {
    	color: #667eea;
    	font-size: 20px;
		}

		.btn-logout {
    	background: linear-gradient(135deg, #f093fb, #f5576c);
    	color: white;
   	 	padding: 8px 16px;
   	 	border-radius: 8px;
    	font-weight: 600;
    	text-decoration: none;
    	transition: 0.3s;
		}
	
		.btn-logout:hover {
    	opacity: 0.85;
		}
    
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

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 25px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .header h2 {
            font-weight: 700;
            font-size: 30px;
            color: #333;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            transition: 0.3s;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .stat-icon {
            width: 55px;
            height: 55px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            margin-bottom: 15px;
        }

        .primary .stat-icon { background: linear-gradient(135deg, #667eea, #764ba2); }
        .success .stat-icon { background: linear-gradient(135deg, #56ab2f, #a8e6cf); }
        .warning .stat-icon { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .info .stat-icon { background: linear-gradient(135deg, #4facfe, #00f2fe); }

        .stat-title {
            text-transform: uppercase;
            color: #555;
            font-weight: 600;
            font-size: 14px;
        }

        .stat-value {
            font-size: 30px;
            font-weight: 700;
            color: #222;
            margin: 5px 0;
        }

        .card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            overflow: hidden;
            animation: fadeIn 0.6s ease-in;
        }

        .card-header {
            padding: 20px 25px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h5 {
            font-size: 18px;
            font-weight: 700;
        }

        .card-body {
            padding: 25px;
        }

        .btn {
            border: none;
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
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

        .badge.success { background: #28a745; }
        .badge.pending { background: #f39c12; }
        .badge.cancelled { background: #e74c3c; }

    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>
<!-- Header riêng cho Admin -->
<div class="admin-header fade-in">
    <div class="admin-info">
        <div class="admin-welcome">
            <i class="fas fa-user-shield"></i>
            <span>Xin chào, 
                <strong>
                    <%= ((model.User) session.getAttribute("currentUser")) != null 
                        ? ((model.User) session.getAttribute("currentUser")).getFullName() 
                        : "Quản trị viên" %>
                </strong>
            </span>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
            <i class="fas fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>
<div class="main-content">
    <div class="header fade-in">
        <h2><i class="fas fa-tachometer-alt"></i> Tổng Quan Hệ Thống TechMart</h2>
    </div>

    <!-- Thống kê tổng -->
    <div class="stats-grid fade-in">
        <div class="stat-card primary">
            <div class="stat-icon"><i class="fas fa-boxes"></i></div>
            <div class="stat-title">Tổng Sản Phẩm</div>
            <div class="stat-value">${totalProducts}</div>
        </div>

        <div class="stat-card success">
            <div class="stat-icon"><i class="fas fa-users"></i></div>
            <div class="stat-title">Khách Hàng</div>
            <div class="stat-value">${totalCustomers}</div>
        </div>

        <div class="stat-card info">
            <div class="stat-icon"><i class="fas fa-dollar-sign"></i></div>
            <div class="stat-title">Doanh Thu Tháng</div>
            <div class="stat-value">₫${monthlyRevenue}</div>
        </div>

        <div class="stat-card warning">
            <div class="stat-icon"><i class="fas fa-shopping-cart"></i></div>
            <div class="stat-title">Đơn Đang Xử Lý</div>
            <div class="stat-value">${pendingOrders}</div>
        </div>
    </div>

    <!-- Đơn hàng mới nhất -->
    <div class="card fade-in">
        <div class="card-header">
            <h5><i class="fas fa-clipboard-list"></i> Đơn Hàng Mới Nhất</h5>
            <a href="${pageContext.request.contextPath}/admin/orders.jsp" class="btn btn-outline">Xem chi tiết</a>
        </div>
        <div class="card-body">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Ngày đặt</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${recentOrders}">
                        <tr>
                            <td>#${order.id}</td>
                            <td>${order.customerName}</td>
                            <td>₫<fmt:formatNumber value="${order.total}" type="number"/></td>
                            <td><fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy"/></td>
                            <td><span class="badge ${order.status eq 'Pending' ? 'pending' : (order.status eq 'Completed' ? 'success' : 'cancelled')}">${order.status}</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Biểu đồ doanh thu -->
    <div class="card fade-in">
        <div class="card-header">
            <h5><i class="fas fa-chart-line"></i> Doanh Thu 7 Ngày Gần Đây</h5>
        </div>
        <div class="card-body">
            <canvas id="revenueChart" height="100"></canvas>
        </div>
    </div>

    <!-- Tài khoản đăng ký mới -->
    <div class="card fade-in">
        <div class="card-header">
            <h5><i class="fas fa-user-plus"></i> Người Dùng Mới</h5>
            <a href="${pageContext.request.contextPath}/admin/users.jsp" class="btn btn-outline">Quản lý</a>
        </div>
        <div class="card-body">
            <table>
                <thead>
                    <tr>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Ngày tạo</th>
                        <th>Vai trò</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${recentUsers}">
                        <tr>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></td>
                            <td>${user.role}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Top sản phẩm bán chạy -->
    <div class="card fade-in">
        <div class="card-header">
            <h5><i class="fas fa-star"></i> Sản Phẩm Bán Chạy</h5>
            <a href="${pageContext.request.contextPath}/admin/products.jsp" class="btn btn-outline">Quản lý sản phẩm</a>
        </div>
        <div class="card-body">
            <table>
                <thead>
                    <tr>
                        <th>Tên sản phẩm</th>
                        <th>Danh mục</th>
                        <th>Đã bán</th>
                        <th>Doanh thu</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${bestSellers}">
                        <tr>
                            <td>${p.name}</td>
                            <td>${p.category}</td>
                            <td>${p.sold}</td>
                            <td>₫<fmt:formatNumber value="${p.revenue}" type="number"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script>
    // Fake chart data (JSTL)
    const labels = [<c:forEach var="day" items="${revenueChartLabels}" varStatus="i">'${day}'<c:if test="${!i.last}">,</c:if></c:forEach>];
    const data = [<c:forEach var="amount" items="${revenueChartValues}" varStatus="i">${amount}<c:if test="${!i.last}">,</c:if></c:forEach>];

    new Chart(document.getElementById('revenueChart'), {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: data,
                fill: true,
                borderColor: '#667eea',
                backgroundColor: 'rgba(102,126,234,0.2)',
                tension: 0.3
            }]
        },
        options: {
            scales: {
                y: { beginAtZero: true }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: ctx => ctx.raw.toLocaleString('vi-VN') + ' ₫'
                    }
                }
            }
        }
    });
</script>
</body>
</html>
