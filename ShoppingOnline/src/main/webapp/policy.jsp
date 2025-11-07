<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TechMart - Chính sách</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Roboto -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f6f8fb;
            color: #333;
            margin: 0;
            padding: 0;
        }

        /* Header cố định */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        main {
            padding-top: 160px;
            padding-bottom: 60px;
        }

        h2.section-title {
            font-weight: 700;
            color: #18498d;
            margin-bottom: 25px;
            position: relative;
            display: inline-block;
        }

        h2.section-title::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: -10px;
            width: 60%;
            height: 3px;
            background-color: #ff9800;
            border-radius: 3px;
        }

        .policy-card {
            background: #fff;
            border-radius: 12px;
            padding: 25px 30px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .policy-card h3 {
            color: #18498d;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .policy-card p {
            text-align: justify;
            line-height: 1.7;
        }

        @media (max-width: 768px) {
            main { padding-top: 140px; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <%@ include file="/includes/header.jsp" %>
    </div>

    <main>
        <div class="container">
            <h2 class="section-title"><i class="fa-solid fa-scale-balanced"></i> Chính sách của TechMart</h2>
            
            <!-- Chính sách bảo mật -->
            <div class="policy-card">
                <h3><i class="fa-solid fa-shield-halved"></i> Chính sách bảo mật</h3>
                <p>
                    TechMart cam kết bảo mật tuyệt đối thông tin cá nhân của khách hàng. 
                    Dữ liệu như họ tên, số điện thoại, email và địa chỉ chỉ được sử dụng cho mục đích xử lý đơn hàng, 
                    giao hàng, và hỗ trợ khách hàng. Chúng tôi không chia sẻ thông tin này cho bất kỳ bên thứ ba nào 
                    khi chưa có sự đồng ý của khách hàng. 
                </p>
                <p>
                    TechMart áp dụng các biện pháp kỹ thuật và quản lý tiên tiến nhằm bảo vệ dữ liệu khỏi mất mát, 
                    truy cập trái phép hoặc rò rỉ thông tin.
                </p>
            </div>

            <!-- Chính sách hủy -->
            <div class="policy-card">
                <h3><i class="fa-solid fa-ban"></i> Chính sách hủy đơn hàng</h3>
                <p>
                    Khách hàng có thể hủy đơn hàng trước khi đơn được chuyển sang trạng thái "Đang giao". 
                    Sau khi đơn đã được vận chuyển, việc hủy sẽ không được chấp nhận. 
                    Trong trường hợp cần thay đổi hoặc điều chỉnh đơn hàng, vui lòng liên hệ ngay với bộ phận 
                    chăm sóc khách hàng của TechMart qua hotline hoặc email.
                </p>
                <p>
                    Mọi yêu cầu hủy đơn được xử lý trong vòng 24 giờ làm việc.
                </p>
            </div>

            <!-- Chính sách kiểm hàng -->
            <div class="policy-card">
                <h3><i class="fa-solid fa-box-open"></i> Chính sách kiểm hàng</h3>
                <p>
                    Khi nhận hàng, khách hàng có quyền kiểm tra sản phẩm trước khi thanh toán. 
                    Nếu phát hiện sản phẩm không đúng với đơn hàng, bị hư hỏng hoặc thiếu linh kiện, 
                    quý khách có thể từ chối nhận hàng và liên hệ TechMart để được hỗ trợ đổi/trả.
                </p>
                <p>
                    Sau khi khách hàng đã xác nhận nhận hàng thành công, TechMart sẽ chỉ tiếp nhận các yêu cầu 
                    bảo hành hoặc đổi trả theo chính sách bảo hành riêng của từng sản phẩm.
                </p>
            </div>

            <!-- Chính sách thanh toán -->
            <div class="policy-card">
                <h3><i class="fa-solid fa-credit-card"></i> Chính sách thanh toán</h3>
                <p>
                    TechMart hỗ trợ nhiều hình thức thanh toán linh hoạt:
                    <ul>
                        <li>💵 Thanh toán khi nhận hàng (COD)</li>
                        <li>🏦 Chuyển khoản ngân hàng</li>
                        <li>💳 Thanh toán trực tuyến qua cổng thanh toán an toàn</li>
                    </ul>
                </p>
                <p>
                    Mọi giao dịch thanh toán trực tuyến đều được mã hóa và bảo mật bởi hệ thống đạt chuẩn quốc tế. 
                    TechMart không lưu trữ thông tin thẻ thanh toán của khách hàng.
                </p>
            </div>
        </div>
    </main>

    <%@ include file="/includes/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
