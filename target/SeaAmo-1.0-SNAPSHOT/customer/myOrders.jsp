<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String contextPath = request.getContextPath();
    if (session.getAttribute("user") == null || !"customer".equals(session.getAttribute("role"))) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }
    Integer cartCount = (Integer) session.getAttribute("cartCount");
    if (cartCount == null) cartCount = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Transaksi - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; --shadow-sm: 0 1px 6px 0 rgba(49,53,59,0.12); }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: var(--bg-gray); padding-top: 80px; }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: var(--shadow-sm); padding: 0 20px; }
        .nav-container { max-width: 1000px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        .nav-link { color: var(--text-dark); font-weight: 600; text-decoration: none; font-size: 14px; }

        .main-container { max-width: 1000px; margin: 24px auto; padding: 0 16px; }
        h2 { margin-bottom: 24px; color: var(--text-dark); font-size: 24px; }

        .order-card { background: var(--white); border-radius: 8px; box-shadow: var(--shadow-sm); margin-bottom: 16px; overflow: hidden; border: 1px solid #E5E7E9; }
        .card-header { padding: 16px; border-bottom: 1px solid #F3F4F5; display: flex; justify-content: space-between; align-items: center; background: #FAFAFA; }
        .meta-info { display: flex; align-items: center; gap: 12px; font-size: 13px; color: #6D7588; }
        .status-badge { padding: 4px 12px; border-radius: 4px; font-size: 12px; font-weight: 700; background: #E5E7E9; color: var(--text-dark); }
        
        .status-pending { background: #FFF4E5; color: #FA591D; }
        .status-paid { background: #E5F9F6; color: #00A79D; }
        .status-shipped { background: #EBF5F9; color: #0A5F7F; }
        .status-delivered { background: #E5F9F6; color: #00A79D; }
        
        .card-body { padding: 16px; display: flex; align-items: flex-start; gap: 16px; }
        .product-thumb { width: 80px; height: 80px; background: #EBF5F9; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 30px; }
        .order-info { flex: 1; }
        .order-title { font-weight: 700; font-size: 16px; color: var(--text-dark); margin-bottom: 4px; }
        .order-desc { font-size: 13px; color: #6D7588; margin-bottom: 8px; }
        .total-price { border-left: 1px solid #E5E7E9; padding-left: 16px; min-width: 150px; }
        .price-label { font-size: 12px; color: #6D7588; }
        .price-val { font-size: 16px; font-weight: 700; color: #FA591D; }

        .card-footer { padding: 12px 16px; display: flex; justify-content: flex-end; gap: 12px; border-top: 1px solid #F3F4F5; }
        .btn { padding: 8px 24px; border-radius: 6px; font-weight: 700; font-size: 14px; cursor: pointer; border: none; text-decoration: none; }
        .btn-ghost { background: transparent; color: var(--primary); }
        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: #084d66; }

        @media (max-width: 768px) {
            .card-body { flex-direction: column; }
            .total-price { border-left: none; padding-left: 0; margin-top: 10px; border-top: 1px dashed #E5E7E9; padding-top: 10px; width: 100%; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <div class="logo-section" style="display: flex; align-items: center; gap: 8px;">
                <img src="${pageContext.request.contextPath}/uploads/seaamo.svg" alt="SeaAmo Logo" style="width:36px;">
                <span style="font-size: 18px; font-weight: 600; line-height: 1; white-space: nowrap;">SeaAmo</span>
            </div>
            <a href="<%= contextPath %>/customer/dashboard.jsp" class="nav-link">Kembali ke Beranda</a>
        </div>
    </nav>

    <div class="main-container">
        <h2>Daftar Transaksi</h2>

        <c:if test="${empty orders}">
            <div style="text-align: center; padding: 60px; background: white; border-radius: 8px;">
                <div style="font-size: 60px; margin-bottom: 20px;">🧾</div>
                <h3 style="margin-bottom: 10px;">Belum ada transaksi</h3>
                <p style="color: #6D7588; margin-bottom: 20px;">Yuk, mulai belanja kebutuhan seafood segar sekarang!</p>
                <a href="<%= contextPath %>/customer/dashboard.jsp" class="btn btn-primary">Mulai Belanja</a>
            </div>
        </c:if>

        <c:forEach var="order" items="${orders}">
            <div class="order-card">
                <div class="card-header">
                    <div class="meta-info">
                        <span>🛒 Belanja</span>
                        <span>•</span>
                        <span><fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy"/></span>
                        <span>•</span>
                        <span>INV/${order.orderId}</span>
                    </div>
                    
                    <%-- Updated Status Logic --%>
                    <span class="status-badge 
                        ${order.status == 'delivered' ? 'status-delivered' : 
                          order.status == 'shipped' ? 'status-shipped' : 
                          order.paymentStatus == 'paid' ? 'status-paid' : 'status-pending'}">
                        
                        <c:choose>
                            <c:when test="${order.status == 'delivered'}">Selesai</c:when>
                            <c:when test="${order.status == 'shipped'}">Dikirim</c:when>
                            <c:when test="${order.paymentStatus == 'paid'}">Pembayaran Berhasil</c:when>
                            <c:otherwise>Menunggu Pembayaran</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="card-body">
                    <div class="product-thumb">📦</div>
                    <div class="order-info">
                        <div class="order-title">Pesanan Makanan Laut Segar</div>
                        <div class="order-desc">${order.shippingAddress}</div>
                        <c:if test="${not empty order.courierName}">
                            <div style="font-size: 12px; color: var(--primary); background: #EBF5F9; display: inline-block; padding: 2px 8px; border-radius: 4px;">
                                🚛 ${order.courierName}
                            </div>
                        </c:if>
                    </div>
                    <div class="total-price">
                        <div class="price-label">Total Belanja</div>
                        <div class="price-val">
                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" var="total"/>
                            Rp${total}
                        </div>
                    </div>
                </div>

                <div class="card-footer">
                    <a href="<%= contextPath %>/order/detail?orderId=${order.orderId}" class="btn btn-ghost">Lihat Detail Transaksi</a>
                    
                    <%-- Only show 'Bayar Sekarang' if payment is pending --%>
                    <c:if test="${order.paymentStatus != 'paid' && order.status != 'cancelled'}">
                         <a href="<%= contextPath %>/payment?orderId=${order.orderId}" class="btn btn-primary">Bayar Sekarang</a>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>

</body>
</html>