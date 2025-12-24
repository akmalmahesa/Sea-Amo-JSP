<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    if (request.getAttribute("totalUsers") == null) {
        response.sendRedirect(request.getContextPath() + "/admin");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin - SeaAmo</title>
    <style>
        :root {
            --primary: #0A5F7F;
            --primary-dark: #084d66;
            --accent: #FF5E4D;
            --bg-gray: #F0F3F7;
            --white: #FFFFFF;
            --text-dark: #212121;
            --text-gray: #6D7588;
            --shadow-sm: 0 1px 6px 0 rgba(49,53,59,0.12);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background-color: var(--bg-gray); color: var(--text-dark); padding-top: 80px; }
        a { text-decoration: none; color: inherit; }

        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: var(--shadow-sm); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); display: flex; align-items: center; gap: 8px; }
        
        .nav-links { display: flex; gap: 32px; }
        .nav-link { color: var(--text-gray); font-weight: 600; font-size: 14px; transition: 0.2s; }
        .nav-link:hover, .nav-link.active { color: var(--primary); }
        .nav-link.logout { color: var(--accent); }

        .main-container { max-width: 1200px; margin: 24px auto; padding: 0 20px; }
        
        .header-section { margin-bottom: 24px; }
        .header-title { font-size: 24px; font-weight: 700; color: var(--text-dark); }
        .header-subtitle { color: var(--text-gray); font-size: 14px; margin-top: 4px; }

        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: var(--white); padding: 24px; border-radius: 12px; box-shadow: var(--shadow-sm); transition: 0.2s; }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-icon { font-size: 28px; margin-bottom: 12px; }
        .stat-label { color: var(--text-gray); font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-value { font-size: 28px; font-weight: 800; color: var(--primary); margin-top: 4px; }

        .quick-actions { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 30px; }
        .action-card { background: var(--white); padding: 20px; border-radius: 12px; box-shadow: var(--shadow-sm); text-align: center; border: 1px solid transparent; transition: 0.2s; cursor: pointer; }
        .action-card:hover { border-color: var(--primary); color: var(--primary); transform: translateY(-2px); }
        .action-icon { font-size: 32px; margin-bottom: 8px; }
        .action-text { font-weight: 700; font-size: 14px; }

        .section-card { background: var(--white); border-radius: 12px; box-shadow: var(--shadow-sm); padding: 24px; }
        .section-header { font-size: 18px; font-weight: 700; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        
        .order-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f5f5f5; }
        .order-item:last-child { border-bottom: none; }
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-pending { background: #FFF4E5; color: #FF9800; }
        .status-paid { background: #E6F4EA; color: #1E8E3E; }
        .status-sent { background: #E8F0FE; color: #1967D2; }
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
                <a href="${pageContext.request.contextPath}/admin" class="nav-link active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin?action=users" class="nav-link">Users</a>
                <a href="${pageContext.request.contextPath}/admin?action=products" class="nav-link">Produk</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="nav-link logout">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="header-section">
            <h1 class="header-title">Ringkasan Sistem</h1>
            <p class="header-subtitle">Pantau kinerja SeaAmo hari ini</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-label">Total Users</div>
                <div class="stat-value">${totalUsers != null ? totalUsers : 0}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🐟</div>
                <div class="stat-label">Total Produk</div>
                <div class="stat-value">${totalProducts != null ? totalProducts : 0}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📦</div>
                <div class="stat-label">Total Pesanan</div>
                <div class="stat-value">${totalOrders != null ? totalOrders : 0}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⏳</div>
                <div class="stat-label">Produk Pending</div>
                <div class="stat-value" style="color: #FF9800;">${pendingProducts != null ? pendingProducts : 0}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">💰</div>
                <div class="stat-label">Total Revenue</div>
                <div class="stat-value" style="color: #1E8E3E;">
                    <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" pattern="#,##0" var="revenue"/>
                    Rp${revenue}
                </div>
            </div>
        </div>
        
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/admin?action=users" class="action-card">
                <div class="action-icon">👥</div>
                <div class="action-text">Kelola Users</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=products" class="action-card">
                <div class="action-icon">🐟</div>
                <div class="action-text">Kelola Produk</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin?action=orders" class="action-card">
                <div class="action-icon">📦</div>
                <div class="action-text">Kelola Pesanan</div>
            </a>
        </div>
        
        <div class="section-card">
            <div class="section-header">📋 Pesanan Terbaru</div>
            <c:forEach var="order" items="${recentOrders}" begin="0" end="9">
                <div class="order-item">
                    <div>
                        <div style="font-weight: 600;">Pesanan #${order.orderId}</div>
                        <div style="font-size: 13px; color: var(--text-gray);">${order.customerName}</div>
                    </div>
                    <div>
                        <span class="status-badge 
                            ${order.statusLabel == 'Menunggu Pembayaran' ? 'status-pending' : 
                              order.statusLabel == 'Lunas' ? 'status-paid' : 'status-sent'}">
                            ${order.statusLabel}
                        </span>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>