<!-- ============================================================================ -->
<!-- admin/dashboard.jsp -->
<!-- ============================================================================ -->
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin - SeaAmo</title>
</head>
<body style="background: linear-gradient(135deg, #154D71 0%, #1C6EA4 100%); min-height: 100vh; font-family: 'Segoe UI';">
    <nav style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); padding: 15px 0;">
        <div style="max-width: 1200px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between;">
            <a href="../index.jsp" style="color: #FFF9AF; font-size: 1.8rem; text-decoration: none; font-weight: 700;">🌊 SeaAmo</a>
            <div style="display: flex; gap: 30px;">
                <a href="../admin" style="color: #FFF9AF; text-decoration: none;">Dashboard</a>
                <a href="../admin?action=users" style="color: white; text-decoration: none;">Users</a>
                <a href="../admin?action=products" style="color: white; text-decoration: none;">Produk</a>
                <a href="../admin?action=orders" style="color: white; text-decoration: none;">Pesanan</a>
                <a href="../auth?action=logout" style="color: white; text-decoration: none;">Logout</a>
            </div>
        </div>
    </nav>
    
    <div style="max-width: 1400px; margin: 30px auto; padding: 0 20px;">
        <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 30px; margin-bottom: 30px;">
            <h1 style="color: white; font-size: 2rem;">⚙️ Admin Dashboard</h1>
            <p style="color: rgba(255,255,255,0.8);">Kelola seluruh sistem SeaAmo</p>
        </div>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px;">
            <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 20px;">
                <div style="font-size: 2.5rem; margin-bottom: 10px;">👥</div>
                <div style="color: rgba(255,255,255,0.8); font-size: 0.9rem;">Total Users</div>
                <div style="color: #FFF9AF; font-size: 2rem; font-weight: 700;">${totalUsers != null ? totalUsers : 0}</div>
            </div>
            
            <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 20px;">
                <div style="font-size: 2.5rem; margin-bottom: 10px;">🐟</div>
                <div style="color: rgba(255,255,255,0.8); font-size: 0.9rem;">Total Produk</div>
                <div style="color: #FFF9AF; font-size: 2rem; font-weight: 700;">${totalProducts != null ? totalProducts : 0}</div>
            </div>
            
            <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 20px;">
                <div style="font-size: 2.5rem; margin-bottom: 10px;">📦</div>
                <div style="color: rgba(255,255,255,0.8); font-size: 0.9rem;">Total Pesanan</div>
                <div style="color: #FFF9AF; font-size: 2rem; font-weight: 700;">${totalOrders != null ? totalOrders : 0}</div>
            </div>
            
            <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 20px;">
                <div style="font-size: 2.5rem; margin-bottom: 10px;">⏳</div>
                <div style="color: rgba(255,255,255,0.8); font-size: 0.9rem;">Produk Pending</div>
                <div style="color: #FFF9AF; font-size: 2rem; font-weight: 700;">${pendingProducts != null ? pendingProducts : 0}</div>
            </div>
            
            <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 20px;">
                <div style="font-size: 2.5rem; margin-bottom: 10px;">💰</div>
                <div style="color: rgba(255,255,255,0.8); font-size: 0.9rem;">Total Revenue</div>
                <div style="color: #FFF9AF; font-size: 1.5rem; font-weight: 700;">
                    <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" pattern="#,##0" var="revenue"/>
                    Rp ${revenue}
                </div>
            </div>
        </div>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 30px;">
            <a href="../admin?action=users" style="background: linear-gradient(135deg, #33A1E0, #1C6EA4); color: white; padding: 20px; border-radius: 10px; text-decoration: none; text-align: center; font-weight: 600;">
                <div style="font-size: 2rem; margin-bottom: 10px;">👥</div>
                Kelola Users
            </a>
            <a href="../admin?action=products" style="background: linear-gradient(135deg, #33A1E0, #1C6EA4); color: white; padding: 20px; border-radius: 10px; text-decoration: none; text-align: center; font-weight: 600;">
                <div style="font-size: 2rem; margin-bottom: 10px;">🐟</div>
                Kelola Produk
            </a>
            <a href="../admin?action=orders" style="background: linear-gradient(135deg, #33A1E0, #1C6EA4); color: white; padding: 20px; border-radius: 10px; text-decoration: none; text-align: center; font-weight: 600;">
                <div style="font-size: 2rem; margin-bottom: 10px;">📦</div>
                Kelola Pesanan
            </a>
        </div>
        
        <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 30px;">
            <h2 style="color: white; margin-bottom: 20px;">📋 Pesanan Terbaru</h2>
            <c:forEach var="order" items="${recentOrders}" begin="0" end="9">
                <div style="background: rgba(255,255,255,0.1); border-radius: 10px; padding: 15px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center;">
                    <div style="color: white;">
                        <strong>Pesanan #${order.orderId}</strong> - ${order.customerName}
                    </div>
                    <div>
                        <span style="padding: 6px 12px; border-radius: 15px; background: rgba(51,161,224,0.3); color: #33A1E0; font-size: 0.85rem; font-weight: 600;">
                            ${order.statusLabel}
                        </span>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>