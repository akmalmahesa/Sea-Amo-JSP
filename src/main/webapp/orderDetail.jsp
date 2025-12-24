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
    <title>Detail Pesanan #${order.orderId} - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: var(--bg-gray); padding-top: 80px; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; align-items: center; gap: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        
        .main-container { max-width: 1200px; margin: 24px auto; padding: 0 16px; display: grid; grid-template-columns: 1fr 350px; gap: 24px; }
        
        .header-row { grid-column: 1/-1; display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .back-link { text-decoration: none; color: #666; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .back-link:hover { color: var(--primary); }

        .card { background: var(--white); border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .card-title { font-weight: 700; font-size: 16px; margin-bottom: 16px; border-bottom: 1px solid #f0f0f0; padding-bottom: 12px; }

        .order-item { display: flex; gap: 16px; padding-bottom: 16px; margin-bottom: 16px; border-bottom: 1px dashed #E5E7E9; }
        .order-item:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
        .item-thumb { width: 70px; height: 70px; background: #EBF5F9; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; object-fit: cover; }
        
        .item-info { flex: 1; }
        .item-name { font-weight: 600; color: var(--text-dark); margin-bottom: 4px; }
        .item-qty { font-size: 13px; color: #666; }
        .item-total { font-weight: 700; color: var(--text-dark); text-align: right; }

        .timeline { padding-left: 10px; border-left: 2px solid #E5E7E9; margin-left: 10px; margin-top: 10px; }
        .timeline-item { position: relative; padding-left: 20px; padding-bottom: 24px; }
        .timeline-item:last-child { padding-bottom: 0; }
        .timeline-dot { position: absolute; left: -7px; top: 0; width: 12px; height: 12px; border-radius: 50%; background: #E5E7E9; border: 2px solid white; }
        .timeline-item.active .timeline-dot { background: var(--primary); box-shadow: 0 0 0 2px rgba(10, 95, 127, 0.2); }
        .timeline-status { font-weight: 600; font-size: 14px; margin-bottom: 2px; }
        .timeline-time { font-size: 12px; color: #999; }
        .timeline-item.active .timeline-status { color: var(--primary); }

        .status-badge { padding: 4px 12px; border-radius: 4px; font-size: 12px; font-weight: 700; background: #E5E7E9; color: var(--text-dark); text-transform: uppercase; }
        .status-paid { background: #E5F9F6; color: #00A79D; }
        .status-pending { background: #FFF4E5; color: #FA591D; }

        .btn-action { width: 100%; padding: 10px; border-radius: 6px; text-decoration: none; text-align: center; display: block; font-weight: 700; font-size: 14px; margin-top: 10px; }
        .btn-cancel { background: #FFF4E5; color: #FA591D; border: 1px solid #FA591D; }

        @media (max-width: 768px) { .main-container { grid-template-columns: 1fr; } .header-row { flex-direction: column; align-items: flex-start; gap: 10px; } }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <div class="logo-section" style="display: flex; align-items: center; gap: 8px;">
                <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: inherit;">
                    <img src="${pageContext.request.contextPath}/uploads/seaamo.svg" alt="SeaAmo Logo" style="width:36px;">
                    <span style="font-size: 18px; font-weight: 600; line-height: 1; white-space: nowrap;">SeaAmo</span>
                </a>
            </div>
            <div class="user-menu">
                <a href="<%= contextPath %>/order?action=myOrders" style="text-decoration: none; font-weight: 600; color: var(--text-dark);">Pesanan Saya</a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        
        <div class="header-row">
            <a href="${pageContext.request.contextPath}/order?action=myOrders" class="back-link">← Kembali</a>
            <div>
                <span style="color: #666; margin-right: 10px;">No. Pesanan <b>#${order.orderId}</b></span>
                <span class="status-badge ${order.paymentStatus == 'paid' ? 'status-paid' : 'status-pending'}">
                    ${order.paymentStatus == 'paid' ? 'Telah Dibayar' : 'Menunggu Pembayaran'}
                </span>
            </div>
        </div>

        <div>
            <div class="card">
                <div class="card-title">Detail Produk</div>
                <c:forEach items="${orderItems}" var="item">
                    <div class="order-item">
                        <img src="${pageContext.request.contextPath}/assets/images/products/${item.productName}.jpg" 
                             onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'"
                             class="item-thumb">
                        <div class="item-info">
                            <div class="item-name">${item.productName}</div>
                            <div class="item-qty">${item.quantity} kg x Rp <fmt:formatNumber value="${item.price}" pattern="#,###" /></div>
                        </div>
                        <div class="item-total">
                            Rp <fmt:formatNumber value="${item.quantity * item.price}" pattern="#,###" />
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="card">
                <div class="card-title">Info Pengiriman</div>
                <div style="display: grid; grid-template-columns: 100px 1fr; gap: 10px; font-size: 14px;">
                    <div style="color: #666;">Kurir</div>
                    <div><b>JNE Express</b> (Resi: -)</div>
                    
                    <div style="color: #666;">Alamat</div>
                    <div>${order.shippingAddress}</div>
                </div>
            </div>
        </div>

        <div>
            <div class="card">
                <div class="card-title">Status Pesanan</div>
                <div class="timeline">
                    <div class="timeline-item active">
                        <div class="timeline-dot"></div>
                        <div class="timeline-status">Pesanan Dibuat</div>
                        <div class="timeline-time"><fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, HH:mm" /></div>
                    </div>
                    
                    <div class="timeline-item ${order.paymentStatus == 'paid' ? 'active' : ''}">
                        <div class="timeline-dot"></div>
                        <div class="timeline-status">Pembayaran Dikonfirmasi</div>
                        <div class="timeline-time">
                            <c:if test="${payment != null}">
                                <fmt:formatDate value="${payment.paymentDate}" pattern="dd MMM, HH:mm" />
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="timeline-item ${order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''}">
                        <div class="timeline-dot"></div>
                        <div class="timeline-status">Dalam Pengiriman</div>
                    </div>
                    
                    <div class="timeline-item ${order.status == 'delivered' ? 'active' : ''}">
                        <div class="timeline-dot"></div>
                        <div class="timeline-status">Pesanan Selesai</div>
                    </div>
                </div>

                <c:if test="${order.status == 'pending' && order.paymentStatus == 'unpaid'}">
                    <form action="${pageContext.request.contextPath}/order/cancel" method="post" onsubmit="return confirm('Yakin batalkan pesanan ini?');">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <button type="submit" class="btn-action btn-cancel">Batalkan Pesanan</button>
                    </form>
                </c:if>
            </div>

            <div class="card">
                <div class="card-title">Rincian Harga</div>
                <div style="display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 8px; color: #666;">
                    <span>Total Harga</span>
                    <span>Rp <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /></span>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 16px; color: #666;">
                    <span>Biaya Ongkir</span>
                    <span>Gratis</span>
                </div>
                <hr style="border: none; border-top: 1px dashed #E5E7E9; margin-bottom: 12px;">
                <div style="display: flex; justify-content: space-between; font-weight: 800; font-size: 18px; color: var(--primary);">
                    <span>Total Bayar</span>
                    <span>Rp <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /></span>
                </div>
            </div>
        </div>
    </div>

</body>
</html>