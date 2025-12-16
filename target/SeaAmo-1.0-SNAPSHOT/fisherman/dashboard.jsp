<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Nelayan - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: var(--bg-gray); padding-top: 80px; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .nav-links { display: flex; gap: 32px; }
        .nav-link { text-decoration: none; color: #6D7588; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .nav-link.active, .nav-link:hover { color: var(--primary); }
        .nav-link.active { border-bottom: 2px solid var(--primary); padding-bottom: 22px; }

        .main-container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        
        .welcome-card { background: linear-gradient(135deg, #0A5F7F 0%, #0D7BA0 100%); color: white; padding: 40px; border-radius: 12px; margin-bottom: 30px; box-shadow: 0 4px 12px rgba(10, 95, 127, 0.2); }
        .welcome-card h1 { font-size: 28px; margin-bottom: 8px; }
        .welcome-card p { opacity: 0.9; }

        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: var(--white); padding: 24px; border-radius: 12px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); display: flex; flex-direction: column; justify-content: center; }
        .stat-icon { font-size: 32px; margin-bottom: 12px; width: 60px; height: 60px; background: #EBF5F9; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
        .stat-label { color: #6D7588; font-size: 14px; font-weight: 600; }
        .stat-value { font-size: 32px; font-weight: 800; color: var(--text-dark); margin-top: 4px; }

        .action-title { font-size: 20px; font-weight: 700; margin-bottom: 20px; }
        .actions-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; }
        .action-card { background: var(--white); padding: 20px; border-radius: 12px; text-decoration: none; color: var(--text-dark); border: 1px solid #E5E7E9; transition: 0.2s; display: flex; align-items: center; gap: 16px; font-weight: 600; }
        .action-card:hover { border-color: var(--primary); transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }

        @media (max-width: 768px) { .nav-links { display: none; } .stats-grid { grid-template-columns: 1fr; } }
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
                <a href="<%= request.getContextPath() %>/fisherman/dashboard.jsp" class="nav-link active">Dashboard</a>
                <a href="<%= request.getContextPath() %>/product?action=myProducts" class="nav-link">Produk Saya</a>
                <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="nav-link">Pesanan Masuk</a>
                <a href="<%= request.getContextPath() %>/fisherman/profile.jsp" class="nav-link">Profil</a>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="nav-link" style="color: #FF5E4D;">Keluar</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="welcome-card">
            <h1>Halo, ${sessionScope.user.fullName}! 👋</h1>
            <p>Siap untuk menjual hasil laut segar hari ini? Cek ringkasan penjualanmu di bawah.</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">💰</div>
                <div class="stat-label">Total Pendapatan</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${totalSales != null ? totalSales : 0}" pattern="#,##0" var="sales"/>
                    Rp${sales}
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">📦</div>
                <div class="stat-label">Pesanan Perlu Dikirim</div>
                <div class="stat-value" style="color: #FF5E4D;">${pendingOrders != null ? pendingOrders : 0}</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">🐟</div>
                <div class="stat-label">Total Produk Aktif</div>
                <div class="stat-value">${totalProducts != null ? totalProducts : 0}</div>
            </div>
        </div>
        
        <h3 class="action-title">Akses Cepat</h3>
        <div class="actions-grid">
            <a href="<%= request.getContextPath() %>/fisherman/addProduct.jsp" class="action-card">
                <span style="font-size: 24px;">➕</span> Tambah Produk
            </a>
            <a href="<%= request.getContextPath() %>/product?action=myProducts" class="action-card">
                <span style="font-size: 24px;">📋</span> Kelola Stok
            </a>
            <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="action-card">
                <span style="font-size: 24px;">🚚</span> Proses Pesanan
            </a>
        </div>
    </div>

</body>
</html>