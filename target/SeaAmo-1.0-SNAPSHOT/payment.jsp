<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String contextPath = request.getContextPath();
    if (session.getAttribute("user") == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pembayaran - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: var(--bg-gray); padding-top: 80px; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1000px; margin: 0 auto; width: 100%; display: flex; align-items: center; gap: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        
        .main-container { max-width: 1000px; margin: 24px auto; padding: 0 16px; display: grid; grid-template-columns: 1fr 350px; gap: 24px; }
        .page-title { grid-column: 1/-1; font-size: 24px; font-weight: 700; margin-bottom: 10px; }

        .card { background: var(--white); border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .card-header { font-weight: 700; font-size: 16px; margin-bottom: 16px; border-bottom: 1px solid #f0f0f0; padding-bottom: 12px; }

        .payment-option { display: block; position: relative; cursor: pointer; margin-bottom: 12px; }
        .payment-option input { position: absolute; opacity: 0; cursor: pointer; }
        .payment-content { display: flex; align-items: center; gap: 12px; padding: 16px; border: 1px solid #E5E7E9; border-radius: 8px; transition: 0.2s; }
        .payment-option input:checked ~ .payment-content { border-color: var(--primary); background-color: #EBF5F9; }
        .icon { font-size: 24px; width: 40px; text-align: center; }
        
        .form-section { display: none; margin-top: 16px; padding-top: 16px; border-top: 1px dashed #ddd; animation: slideDown 0.3s ease; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        
        .input-group { margin-bottom: 12px; }
        .input-group label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #666; }
        .form-input { width: 100%; padding: 10px; border: 1px solid #E5E7E9; border-radius: 6px; font-size: 14px; }
        .form-input:focus { outline: none; border-color: var(--primary); }

        .total-label { font-size: 14px; color: #666; }
        .total-amount { font-size: 24px; font-weight: 800; color: var(--primary); margin-bottom: 20px; }
        .btn-pay { width: 100%; padding: 14px; background: var(--primary); color: white; border: none; border-radius: 8px; font-weight: 700; font-size: 16px; cursor: pointer; transition: 0.2s; }
        .btn-pay:hover { background: #084d66; }

        @media (max-width: 768px) { .main-container { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
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

            <span style="font-size: 16px; color: #666;">Pembayaran</span>
        </div>
    </nav>

    <div class="main-container">
        <h1 class="page-title">Metode Pembayaran</h1>
        
        <form action="${pageContext.request.contextPath}/payment" method="post" id="paymentForm">
            <input type="hidden" name="orderId" value="${order.orderId}">
            
            <div class="card">
                <div class="card-header">Pilih Cara Bayar</div>
                
                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="bank_transfer" required onchange="toggleForm('bank')">
                    <div class="payment-content">
                        <span class="icon">🏦</span>
                        <div>
                            <div style="font-weight: 700;">Transfer Bank</div>
                            <div style="font-size: 13px; color: #666;">BCA, Mandiri, BNI, BRI</div>
                        </div>
                    </div>
                </label>
                
                <div id="bankForm" class="form-section">
                    <div class="input-group">
                        <label>Nama Bank</label>
                        <input type="text" name="bankName" class="form-input" placeholder="Contoh: BCA">
                    </div>
                    <div class="input-group">
                        <label>Nomor Rekening Anda</label>
                        <input type="text" name="accountNumber" class="form-input" placeholder="Nomor rekening pengirim">
                    </div>
                    <div class="input-group">
                        <label>Nama Pemilik Rekening</label>
                        <input type="text" name="accountName" class="form-input" placeholder="Nama sesuai buku tabungan">
                    </div>
                </div>

                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="e_wallet" onchange="toggleForm('wallet')">
                    <div class="payment-content">
                        <span class="icon">📱</span>
                        <div>
                            <div style="font-weight: 700;">E-Wallet / QRIS</div>
                            <div style="font-size: 13px; color: #666;">GoPay, OVO, Dana, ShopeePay</div>
                        </div>
                    </div>
                </label>

                <div id="walletForm" class="form-section">
                    <div class="input-group">
                        <label>Pilih E-Wallet</label>
                        <select name="walletProvider" class="form-input">
                            <option value="GoPay">GoPay</option>
                            <option value="OVO">OVO</option>
                            <option value="Dana">Dana</option>
                            <option value="ShopeePay">ShopeePay</option>
                        </select>
                    </div>
                    <div class="input-group">
                        <label>Nomor HP Terdaftar</label>
                        <input type="tel" name="phoneNumber" class="form-input" placeholder="08xxxxxxxxxx">
                    </div>
                </div>
            </div>
        </form>

        <div>
            <div class="card" style="position: sticky; top: 100px;">
                <div class="card-header">Ringkasan Tagihan</div>
                <div class="total-label">Total yang harus dibayar</div>
                <div class="total-amount">
                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" var="total"/>
                    Rp${total}
                </div>
                <hr style="border: none; border-top: 1px dashed #E5E7E9; margin: 15px 0;">
                <div style="font-size: 13px; color: #666; margin-bottom: 20px;">
                    Order ID: <b>#${order.orderId}</b><br>
                    Pastikan nominal transfer sesuai hingga 3 digit terakhir.
                </div>
                <button type="submit" form="paymentForm" class="btn-pay">Bayar Sekarang</button>
            </div>
        </div>
    </div>

    <script>
        function toggleForm(type) {
            document.getElementById('bankForm').style.display = 'none';
            document.getElementById('walletForm').style.display = 'none';
            
            if (type === 'bank') {
                document.getElementById('bankForm').style.display = 'block';
            } else {
                document.getElementById('walletForm').style.display = 'block';
            }
        }
    </script>
</body>
</html>