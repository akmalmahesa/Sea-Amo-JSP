<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Pembayaran Berhasil - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        body { background: var(--bg-gray); padding-top: 80px; font-family: 'Open Sans', sans-serif; text-align: center; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; justify-content: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }

        .container { max-width: 600px; margin: 40px auto; padding: 0 20px; }
        
        .success-card { background: var(--white); border-radius: 12px; padding: 40px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .success-icon { width: 80px; height: 80px; background: #E5F9F6; color: #00A79D; font-size: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; }
        
        h1 { font-size: 24px; margin-bottom: 8px; }
        p { color: #666; margin-bottom: 32px; }

        .receipt-box { background: #F8F9FA; border-radius: 8px; padding: 20px; text-align: left; margin-bottom: 32px; border: 1px dashed #E5E7E9; }
        .receipt-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; color: #666; }
        .receipt-total { display: flex; justify-content: space-between; margin-top: 16px; padding-top: 16px; border-top: 1px solid #E5E7E9; font-weight: 700; font-size: 18px; color: var(--primary); }

        .btn-group { display: flex; gap: 12px; }
        .btn { flex: 1; padding: 12px; border-radius: 8px; font-weight: 700; text-decoration: none; font-size: 14px; transition: 0.2s; }
        .btn-outline { border: 1px solid var(--primary); color: var(--primary); }
        .btn-outline:hover { background: #EBF5F9; }
        .btn-fill { background: var(--primary); color: white; border: 1px solid var(--primary); }
        .btn-fill:hover { background: #084d66; }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo-section" style="
            display: flex;
            align-items: center;
            gap: 8px;
        ">
            <a href="${pageContext.request.contextPath}/customer/dashboard.jsp"
               style="
                   display: flex;
                   align-items: center;
                   gap: 8px;
                   text-decoration: none;
                   color: inherit;
               ">

                <img src="${pageContext.request.contextPath}/uploads/seaamo.svg"
                     alt="SeaAmo Logo"
                     style="width:36px;">

                <span style="
                    font-size: 18px;
                    font-weight: 600;
                    line-height: 1;
                    white-space: nowrap;
                ">
                    SeaAmo
                </span>
            </a>
        </div>

    </nav>

    <div class="container">
        <div class="success-card">
            <div class="success-icon">✓</div>
            <h1>Pembayaran Berhasil!</h1>
            <p>Terima kasih, pesananmu sedang diteruskan ke nelayan.</p>

            <div class="receipt-box">
                <div class="receipt-row">
                    <span>No. Pesanan</span>
                    <span style="font-weight: 600; color: var(--text-dark);">#${order.orderId}</span>
                </div>
                <div class="receipt-row">
                    <span>Metode Bayar</span>
                    <span>${payment.paymentMethod}</span>
                </div>
                <div class="receipt-row">
                    <span>Waktu</span>
                    <span><fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, HH:mm" /></span>
                </div>
                <div class="receipt-total">
                    <span>Total Bayar</span>
                    <span>Rp<fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /></span>
                </div>
            </div>

            <div class="btn-group">
                <a href="<%= contextPath %>/customer/dashboard.jsp" class="btn btn-outline">Ke Beranda</a>
                <a href="${pageContext.request.contextPath}/order/detail?orderId=${order.orderId}" class="btn btn-fill">Lihat Pesanan</a>
            </div>
        </div>
    </div>

</body>
</html>