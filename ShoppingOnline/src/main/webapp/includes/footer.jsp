<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Footer</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            /* Tổng thể footer */
            .footer-row {
                background-color: #0b3c91; /* xanh đậm */
                color: #fff;
                padding: 40px 0 20px 0;
                font-family: 'Roboto', sans-serif;
                font-size: 15px;
            }

            .footer-row h3 {
                font-weight: 700;
                color: #ffcc00;
                margin-bottom: 15px;
                border-bottom: 2px solid #ffcc00;
                display: inline-block;
                padding-bottom: 5px;
                text-transform: uppercase;
            }

            .footer-row ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .footer-row ul li {
                margin-bottom: 8px;
            }

            .footer-row a {
                color: #f5f5f5;
                text-decoration: none;
                transition: all 0.2s ease-in-out;
            }

            .footer-row a:hover {
                color: #ffd54f;
                text-decoration: underline;
            }

            .footer-row .box-footer {
                margin-bottom: 25px;
            }

            /* Giới thiệu */
            .introduce-detail ul li::before {
                content: "•";
                color: #ffd54f;
                margin-right: 8px;
            }

            /* Thông tin công ty */
            .football-contact span {
                font-weight: 600;
                color: #ffcc00;
            }

            /* Liên hệ */
            .support h4 {
                color: #ffcc00;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .support .tel {
                display: block;
                font-size: 18px;
                color: #fff;
                font-weight: bold;
            }

            .support .tel:hover {
                color: #ffd54f;
            }

            .support a[href="url"] {
                display: inline-block;
                margin-top: 6px;
                background-color: #ffcc00;
                color: #0b3c91;
                font-weight: 600;
                padding: 6px 14px;
                border-radius: 4px;
                text-decoration: none;
                transition: background-color 0.2s;
            }

            .support a[href="url"]:hover {
                background-color: #ffd54f;
                color: #0b3c91;
            }

            /* Dòng bản quyền */
            .footer-bottom {
                text-align: center;
                background-color: #072b6b;
                padding: 12px 0;
                color: #ddd;
                font-size: 14px;
                margin-top: 30px;
                border-top: 1px solid rgba(255,255,255,0.2);
            }
        </style>
    </head>

    <body>
        <footer class="footer-row">
            <div class="container">
                <div class="row">
                    <!-- Giới thiệu -->
                    <div class="col-md-4">
                        <div class="introduce box-footer">
                            <h3>Giới thiệu</h3>
                            <div class="introduce-detail">
                                <ul>
                                    <li><a href="<%= request.getContextPath() %>/policy.jsp">Chính sách bảo mật</a></li>
                                    <li><a href="<%= request.getContextPath() %>/policy.jsp">Chính sách hủy</a></li>
                                    <li><a href="<%= request.getContextPath() %>/policy.jsp">Chính sách kiểm hàng</a></li>
                                    <li><a href="<%= request.getContextPath() %>/policy.jsp">Chính sách thanh toán</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin công ty -->
                    <div class="col-md-4">
                        <div class="football-contact box-footer">
                            <h3>Thông tin</h3>
                            <ul>
                                <li><span><i class="fa-solid fa-building"></i></span> Công ty Cổ phần Thương mại và Dịch vụ Công nghệ TechMart</li>
                                <li><span>MST:</span> 0345643121</li>
                                <li><span>Mail:</span> contact@techmart.com</li>
                                <li><span>Địa chỉ:</span> Số 3 ngõ 612/34/15 Đường La Thành, Phường Giảng Võ, Quận Ba Đình, Thành phố Hà Nội, Việt Nam</li>
                                <li><span>Điện thoại:</span> 0247.303.0247</li>
                                <li><span>Giấy phép:</span> ĐKKD số 0110175404 do Sở KH&ĐT TP Đà Nẵng cấp ngày 12/5/2025</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Liên hệ -->
                    <div class="col-md-4">
                        <div class="footer-contact2 box-footer">
                            <h3>Liên hệ</h3>
                            <div class="support">
                                <h4>Chăm sóc khách hàng</h4>
                                <a class="tel">0345.643.121</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dòng bản quyền -->
            <div class="footer-bottom">
                Copyright © 2025 Công ty Cổ phần Thương mại và Dịch vụ Công nghệ TechMart. 
                GPKD số: 0101417128 - Sở KH&ĐT Hà Nội cấp ngày 07/10/2003. 
                Người chịu trách nhiệm nội dung: Trần Ngọc Tân
            </div>
        </footer>
    </body>
</html>
