<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String contextPath = request.getContextPath();
    Integer cartCount = (Integer) session.getAttribute("cartCount");
    if (cartCount == null) cartCount = 0;
    
    if (session.getAttribute("user") == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        body { background: var(--bg-gray); padding-top: 80px; font-family: 'Open Sans', sans-serif; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1000px; margin: 0 auto; width: 100%; display: flex; align-items: center; gap: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; border-right: 1px solid #ddd; padding-right: 20px; margin-right: 10px; }
        
        .main-container { max-width: 1000px; margin: 24px auto; padding: 0 16px; display: grid; grid-template-columns: 1fr 350px; gap: 24px; }
        .page-title { grid-column: 1/-1; font-size: 24px; font-weight: 700; margin-bottom: 10px; }

        .card { background: var(--white); border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .card-header { font-weight: 700; font-size: 16px; margin-bottom: 16px; display: flex; align-items: center; gap: 8px; }

        textarea { width: 100%; padding: 12px; border: 1px solid #E5E7E9; border-radius: 8px; font-family: inherit; font-size: 14px; min-height: 100px; resize: vertical; }
        textarea:focus { outline: none; border-color: var(--primary); }

        .item-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; color: #666; }
        .total-row { display: flex; justify-content: space-between; margin-top: 16px; padding-top: 16px; border-top: 1px dashed #E5E7E9; font-weight: 800; font-size: 18px; color: var(--primary); }

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

            <span style="font-size: 18px; font-weight: 600;">Checkout</span>
        </div>
    </nav>

    <div class="main-container">
        <h1 class="page-title">Pengiriman</h1>
        
        <form action="<%= contextPath %>/order" method="post" id="checkoutForm">
            <input type="hidden" name="action" value="create">
            
            <div class="card">
                <div class="card-header">📍 Alamat Pengiriman</div>
                <p style="font-size: 13px; color: #666; margin-bottom: 8px;">Pastikan alamat anda benar agar kurir tidak nyasar.</p>
                <textarea name="shippingAddress" required placeholder="Tulis nama jalan, nomor rumah, RT/RW, dan patokan...">${sessionScope.user.address}</textarea>
            </div>

            <div class="card">
                <div class="card-header">🚚 Pilih Kurir</div>
                <select name="courier" style="width: 100%; padding: 10px; border: 1px solid #E5E7E9; border-radius: 8px;">
                    <option value="JNE">JNE Express (Rp 10.000)</option>
                    <option value="GoSend">GoSend Instant (Rp 20.000)</option>
                    <option value="SeaAmo">SeaAmo Courier (Gratis)</option>
                </select>
            </div>
        </form>

        <div style="position: sticky; top: 100px; height: fit-content;">
            <div class="card">
                <div class="card-header">Ringkasan Belanja</div>
                <c:forEach var="item" items="${cartItems}">
                    <div class="item-row">
                        <span>${item.product.productName} <b>x${item.quantity}</b></span>
                        <span>${item.formattedSubtotal}</span>
                    </div>
                </c:forEach>
                
                <div class="total-row">
                    <span>Total Tagihan</span>
                    <span>
                        <fmt:formatNumber value="${totalAmount}" pattern="#,##0" var="total"/>
                        Rp${total}
                    </span>
                </div>
                
                <button type="submit" form="checkoutForm" class="btn-pay" style="margin-top: 20px;">
                    Bayar Sekarang
                </button>
            </div>
        </div>
    </div>

</body>
</html>