<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Sử Hoạt Động | TechMart Admin</title>
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
            font-size: 28px;
            color: #333;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
            transition: 0.3s ease;
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
            font-size: 26px;
            color: white;
            margin-bottom: 15px;
        }

        .view .stat-icon { background: linear-gradient(135deg, #3182ce, #2b6cb0); }
        .edit .stat-icon { background: linear-gradient(135deg, #f6ad55, #ed8936); }
        .login .stat-icon { background: linear-gradient(135deg, #48bb78, #38a169); }
        .logout .stat-icon { background: linear-gradient(135deg, #a0aec0, #718096); }

        .stat-title {
            text-transform: uppercase;
            font-size: 13px;
            font-weight: 600;
            color: #555;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #222;
            margin-top: 8px;
        }

        .filter-box {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 20px 25px;
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 40px;
        }

        .filter-box input,
        .filter-box select {
            padding: 12px 15px;
            border-radius: 10px;
            border: 1px solid #ccc;
            font-size: 15px;
            flex: 1;
            transition: 0.3s;
        }

        .filter-box input:focus,
        .filter-box select:focus {
            border-color: #667eea;
            outline: none;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.2);
        }

        .activities-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 25px;
        }

        .activity-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            transition: 0.3s;
        }

        .activity-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .activity-user {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }

        .user-info h4 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
            color: #2d3748;
        }

        .user-info p {
            margin: 3px 0 0;
            color: #718096;
            font-size: 13px;
        }

        .activity-description {
            font-size: 14px;
            color: #2d3748;
            margin: 10px 0;
            line-height: 1.5;
        }

        .activity-time {
            font-size: 13px;
            color: #a0aec0;
        }

        .activity-type {
            display: inline-block;
            margin-top: 10px;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            color: white;
        }

        .type-view { background: #3182ce; }
        .type-edit { background: #ed8936; }
        .type-login { background: #38a169; }
        .type-logout { background: #718096; }

        .fade-in {
            animation: fadeIn 0.7s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>

<body>
<%@ include file="sidebar.jsp" %>

<div class="main-content fade-in">

    <div class="header fade-in">
        <h2><i class="fas fa-history"></i> Lịch Sử Hoạt Động Người Dùng</h2>
    </div>

    <!-- Thống kê -->
    <div class="stats-grid fade-in">
        <div class="stat-card view">
            <div class="stat-icon"><i class="fas fa-eye"></i></div>
            <div class="stat-title">Xem Thông Tin</div>
            <div class="stat-value">
                <c:set var="viewCount" value="0"/>
                <c:forEach var="a" items="${activityList}">
                    <c:if test="${a.type == 'VIEW'}">
                        <c:set var="viewCount" value="${viewCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${viewCount}
            </div>
        </div>

        <div class="stat-card edit">
            <div class="stat-icon"><i class="fas fa-edit"></i></div>
            <div class="stat-title">Chỉnh Sửa</div>
            <div class="stat-value">
                <c:set var="editCount" value="0"/>
                <c:forEach var="a" items="${activityList}">
                    <c:if test="${a.type == 'EDIT'}">
                        <c:set var="editCount" value="${editCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${editCount}
            </div>
        </div>

        <div class="stat-card login">
            <div class="stat-icon"><i class="fas fa-sign-in-alt"></i></div>
            <div class="stat-title">Đăng Nhập</div>
            <div class="stat-value">
                <c:set var="loginCount" value="0"/>
                <c:forEach var="a" items="${activityList}">
                    <c:if test="${a.type == 'LOGIN'}">
                        <c:set var="loginCount" value="${loginCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${loginCount}
            </div>
        </div>

        <div class="stat-card logout">
            <div class="stat-icon"><i class="fas fa-sign-out-alt"></i></div>
            <div class="stat-title">Đăng Xuất</div>
            <div class="stat-value">
                <c:set var="logoutCount" value="0"/>
                <c:forEach var="a" items="${activityList}">
                    <c:if test="${a.type == 'LOGOUT'}">
                        <c:set var="logoutCount" value="${logoutCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${logoutCount}
            </div>
        </div>
    </div>

    <!-- Bộ lọc -->
    <div class="filter-box fade-in">
        <input type="text" id="searchInput" placeholder="🔍 Tìm kiếm người dùng hoặc mô tả...">
        <select id="typeFilter">
            <option value="">Tất cả loại</option>
            <option value="VIEW">Xem</option>
            <option value="EDIT">Chỉnh sửa</option>
            <option value="LOGIN">Đăng nhập</option>
            <option value="LOGOUT">Đăng xuất</option>
        </select>
        <select id="dateFilter">
            <option value="">Tất cả thời gian</option>
            <option value="today">Hôm nay</option>
            <option value="week">Tuần này</option>
            <option value="month">Tháng này</option>
        </select>
    </div>

    <!-- Danh sách -->
    <c:if test="${empty activityList}">
        <div style="text-align:center; padding:60px; color:white;">
            <i class="fas fa-history" style="font-size:70px; opacity:0.6;"></i>
            <h3>Không có hoạt động nào</h3>
        </div>
    </c:if>

    <c:if test="${not empty activityList}">
        <div class="activities-container fade-in" id="activitiesContainer">
            <c:forEach var="act" items="${activityList}">
                <div class="activity-card"
                     data-type="${act.type}"
                     data-user="${fn:toLowerCase(act.userName)}"
                     data-desc="${fn:toLowerCase(act.description)}">
                    <div class="activity-user">
                        <div class="user-avatar">${fn:substring(act.userName, 0, 1)}</div>
                        <div class="user-info">
                            <h4>${act.userName}</h4>
                            <p>${act.userEmail}</p>
                        </div>
                    </div>
                    <div class="activity-description">${act.description}</div>
                    <div class="activity-time"><fmt:formatDate value="${act.timestamp}" pattern="dd/MM/yyyy HH:mm"/></div>
                    <div class="activity-type type-${fn:toLowerCase(act.type)}">
                        <c:out value="${act.type}"/>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

</div>

<script>
    document.getElementById("searchInput").addEventListener("input", filterActivities);
    document.getElementById("typeFilter").addEventListener("change", filterActivities);

    function filterActivities() {
        const search = document.getElementById("searchInput").value.toLowerCase();
        const type = document.getElementById("typeFilter").value;

        document.querySelectorAll(".activity-card").forEach(card => {
            const user = card.getAttribute("data-user");
            const desc = card.getAttribute("data-desc");
            let show = true;

            if (type && card.getAttribute("data-type") !== type) show = false;
            if (search && !user.includes(search) && !desc.includes(search)) show = false;

            card.style.display = show ? "block" : "none";
        });
    }
</script>

</body>
</html>
