<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pesanan Masuk - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        body { background: var(--bg-gray); padding-top: 80px; font-family: 'Open Sans', sans-serif; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        .nav-links { display: flex; gap: 32px; }
        .nav-link { text-decoration: none; color: #6D7588; font-weight: 600; font-size: 14px; }
        .nav-link.active { color: var(--primary); border-bottom: 2px solid var(--primary); padding-bottom: 22px; }

        .main-container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .page-title { font-size: 24px; font-weight: 700; margin-bottom: 24px; }

        .order-card { background: var(--white); border-radius: 12px; padding: 24px; margin-bottom: 16px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); border: 1px solid transparent; transition: 0.2s; }
        .order-card:hover { border-color: var(--primary); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }

        .order-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #F0F3F7; padding-bottom: 12px; margin-bottom: 12px; }
        .order-id { font-weight: 700; font-size: 16px; color: var(--primary); }
        .order-date { font-size: 13px; color: #666; }

        .order-status { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; text-transform: uppercase; }
        .status-paid { background: #E5F9F6; color: #00A79D; }
        .status-processing { background: #FFF4E5; color: #FA591D; }
        .status-pending { background: #E5E7E9; color: #666; }

        .order-body { display: flex; justify-content: space-between; align-items: flex-end; }
        .customer-info { font-size: 14px; color: #4A5568; line-height: 1.6; }
        .customer-info b { color: var(--text-dark); }
        
        .order-total { text-align: right; }
        .total-label { font-size: 12px; color: #666; }
        .total-value { font-size: 18px; font-weight: 800; color: var(--text-dark); }

        .order-actions { margin-top: 16px; padding-top: 16px; border-top: 1px dashed #E5E7E9; display: flex; justify-content: flex-end; gap: 10px; }
        .btn-process { padding: 10px 20px; background: var(--primary); color: white; border: none; border-radius: 6px; font-weight: 700; cursor: pointer; transition: 0.2s; }
        .btn-process:hover { background: #084d66; }
        
        @media (max-width: 768px) { .nav-links { display: none; } }
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
                </div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/fisherman/dashboard.jsp" class="nav-link">Dashboard</a>
                <a href="<%= request.getContextPath() %>/product?action=myProducts" class="nav-link">Produk Saya</a>
                <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="nav-link active">Pesanan Masuk</a>
                <a href="<%= request.getContextPath() %>/fisherman/profile.jsp" class="nav-link">Profil</a>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="nav-link" style="color: #FF5E4D;">Keluar</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <h1 class="page-title">Daftar Pesanan</h1>
        
        <c:if test="${empty orders}">
            <div style="text-align: center; padding: 60px; background: white; border-radius: 12px;">
                <div style="font-size: 50px; margin-bottom: 20px;">📦</div>
                <h3>Belum ada pesanan masuk</h3>
                <p style="color: #666;">Produkmu akan muncul di sini saat ada pembeli.</p>
            </div>
        </c:if>

        <c:forEach var="order" items="${orders}">
            <div class="order-card">
                <div class="order-header">
                    <div>
                        <span class="order-id">#${order.orderId}</span>
                        <span style="margin: 0 8px; color: #ccc;">|</span>
                        <span class="order-date"><fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, HH:mm"/></span>
                    </div>
                    <span class="order-status ${order.status == 'paid' ? 'status-paid' : 'status-pending'}">
                        ${order.status}
                    </span>
                </div>
                
                <div class="order-body">
                    <div class="customer-info">
                        Pembeli: <b>${order.customerName}</b><br>
                        Alamat: ${order.shippingAddress}
                    </div>
                    <div class="order-total">
                        <div class="total-label">Total Pendapatan</div>
                        <div class="total-value">
                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" var="total"/>
                            Rp${total}
                        </div>
                    </div>
                </div>

                <c:if test="${order.status == 'paid' || order.status == 'pending'}">
                    <div class="order-actions">
                        <form action="<%= request.getContextPath() %>/order" method="post">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <input type="hidden" name="status" value="processing"> 
                            <button type="submit" class="btn-process">Proses Pesanan & Kirim</button>
                        </form>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>

</body>
</html>