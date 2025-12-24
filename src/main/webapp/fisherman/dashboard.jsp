<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- PENGAMAN: Jika data statistik null, paksa lewat Servlet --%>
<%
    if (request.getAttribute("totalRevenue") == null) {
        response.sendRedirect(request.getContextPath() + "/fisherman?action=dashboard");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Nelayan - SeaAmo</title>
    <style>
        :root { 
            --primary: #0A5F7F; 
            --bg-gray: #F0F3F7; 
            --white: #FFFFFF; 
            --text-dark: #212121;
            --success: #00A79D;
            --warning: #FA591D;
            --info: #0A7AFF;
            --danger: #FF5E4D;
        }
        
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        
        body { 
            background: var(--bg-gray); 
            padding-top: 80px; 
            color: var(--text-dark);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
        }
        
        /* Navbar */
        .navbar { 
            background: var(--white); 
            height: 70px; 
            display: flex; 
            align-items: center; 
            position: fixed; 
            top: 0; 
            width: 100%; 
            z-index: 999; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.08); 
            padding: 0 20px; 
        }
        
        .nav-container { 
            max-width: 1200px; 
            margin: 0 auto; 
            width: 100%; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .logo-section {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .logo-section img {
            width: 36px;
            height: 36px;
        }
        
        .logo-section span {
            font-size: 20px;
            font-weight: 700;
            color: var(--primary);
            white-space: nowrap;
        }
        
        .nav-links { 
            display: flex; 
            gap: 32px; 
        }
        
        .nav-link { 
            text-decoration: none; 
            color: #6D7588; 
            font-weight: 600; 
            font-size: 14px; 
            transition: all 0.3s ease;
            padding-bottom: 22px;
        }
        
        .nav-link:hover { 
            color: var(--primary); 
        }
        
        .nav-link.active { 
            color: var(--primary); 
            border-bottom: 3px solid var(--primary); 
        }

        /* Main Container */
        .main-container { 
            max-width: 1200px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        
        /* Welcome Card */
        .welcome-card { 
            background: linear-gradient(135deg, #0A5F7F 0%, #0D7BA0 100%); 
            color: white; 
            padding: 40px; 
            border-radius: 16px; 
            margin-bottom: 30px; 
            box-shadow: 0 8px 24px rgba(10, 95, 127, 0.25);
            position: relative;
            overflow: hidden;
        }
        
        .welcome-card::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        
        .welcome-card h1 { 
            font-size: 32px; 
            margin-bottom: 8px;
            font-weight: 700;
            position: relative;
        }
        
        .welcome-card p { 
            opacity: 0.95;
            font-size: 16px;
            position: relative;
        }

        /* Revenue Breakdown Card - Highlighted */
        .revenue-card { 
            background: linear-gradient(135deg, #00A79D 0%, #00C9BC 100%); 
            color: white; 
            padding: 36px; 
            border-radius: 16px; 
            margin-bottom: 24px; 
            box-shadow: 0 12px 32px rgba(0, 167, 157, 0.3);
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        
        .revenue-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 40px rgba(0, 167, 157, 0.35);
        }
        
        .revenue-card::before {
            content: '';
            position: absolute;
            top: -80px;
            right: -80px;
            width: 250px;
            height: 250px;
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
        }
        
        .revenue-card::after {
            content: '';
            position: absolute;
            bottom: -60px;
            left: -60px;
            width: 180px;
            height: 180px;
            background: rgba(255,255,255,0.06);
            border-radius: 50%;
        }
        
        .revenue-title { 
            font-size: 14px; 
            opacity: 0.9; 
            margin-bottom: 12px; 
            font-weight: 600; 
            position: relative;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        
        .revenue-main { 
            font-size: 48px; 
            font-weight: 800; 
            margin-bottom: 24px; 
            position: relative;
            line-height: 1;
        }
        
        .revenue-breakdown { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 16px; 
            position: relative;
        }
        
        .revenue-item { 
            background: rgba(255,255,255,0.15); 
            padding: 20px; 
            border-radius: 12px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.3s ease;
        }
        
        .revenue-item:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }
        
        .revenue-item-label { 
            font-size: 12px; 
            opacity: 0.9; 
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .revenue-item-value { 
            font-size: 24px; 
            font-weight: 700;
            margin-bottom: 4px;
        }
        
        .revenue-item-desc {
            font-size: 11px; 
            opacity: 0.8; 
            margin-top: 6px;
            line-height: 1.4;
        }
        
        .revenue-badge { 
            display: inline-block; 
            background: rgba(255,255,255,0.25); 
            padding: 4px 12px; 
            border-radius: 12px; 
            font-size: 10px; 
            font-weight: 700;
            margin-left: 8px;
            letter-spacing: 0.5px;
        }

        /* Stats Grid */
        .stats-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); 
            gap: 20px; 
            margin-bottom: 40px; 
        }
        
        .stat-card { 
            background: var(--white); 
            padding: 28px; 
            border-radius: 12px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.08); 
            display: flex; 
            flex-direction: column; 
            justify-content: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
            border-color: var(--primary);
        }
        
        .stat-icon { 
            font-size: 36px; 
            margin-bottom: 16px; 
            width: 70px; 
            height: 70px; 
            background: #EBF5F9; 
            border-radius: 50%; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
        }
        
        .stat-label { 
            color: #6D7588; 
            font-size: 14px; 
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .stat-value { 
            font-size: 36px; 
            font-weight: 800; 
            color: var(--text-dark); 
        }

        /* Actions Section */
        .action-title { 
            font-size: 22px; 
            font-weight: 700; 
            margin-bottom: 20px;
            color: var(--text-dark);
        }
        
        .actions-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); 
            gap: 16px; 
        }
        
        .action-card { 
            background: var(--white); 
            padding: 24px; 
            border-radius: 12px; 
            text-decoration: none; 
            color: var(--text-dark); 
            border: 2px solid #E5E7E9; 
            transition: all 0.3s ease; 
            display: flex; 
            align-items: center; 
            gap: 16px; 
            font-weight: 600;
            font-size: 15px;
        }
        
        .action-card:hover { 
            border-color: var(--primary); 
            transform: translateY(-2px); 
            box-shadow: 0 6px 16px rgba(10, 95, 127, 0.15); 
            background: linear-gradient(135deg, rgba(10, 95, 127, 0.02) 0%, rgba(10, 95, 127, 0.05) 100%);
        }
        
        .action-icon {
            font-size: 28px;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #EBF5F9;
            border-radius: 12px;
        }

        /* Responsive Design */
        @media (max-width: 768px) { 
            .nav-links { 
                display: none; 
            }
            
            .stats-grid, 
            .actions-grid { 
                grid-template-columns: 1fr; 
            }
            
            .revenue-breakdown { 
                grid-template-columns: 1fr; 
            }
            
            .revenue-main { 
                font-size: 36px; 
            }
            
            .welcome-card h1 {
                font-size: 24px;
            }
            
            .welcome-card p {
                font-size: 14px;
            }
        }
        
        @media (max-width: 480px) {
            .revenue-main { 
                font-size: 28px; 
            }
            
            .revenue-item-value {
                font-size: 20px;
            }
            
            .stat-value {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <div class="logo-section">
                <img src="${pageContext.request.contextPath}/uploads/seaamo.svg" alt="SeaAmo Logo">
                <span>SeaAmo</span>
            </div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/fisherman?action=dashboard" class="nav-link active">Dashboard</a>
                <a href="<%= request.getContextPath() %>/product?action=myProducts" class="nav-link">Produk Saya</a>
                <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="nav-link">Pesanan Masuk</a>
                <a href="<%= request.getContextPath() %>/fisherman/profile.jsp" class="nav-link">Profil</a>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="nav-link" style="color: var(--danger);">Keluar</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <!-- Welcome Card -->
        <div class="welcome-card">
            <h1>Halo, ${sessionScope.user.fullName}! 👋</h1>
            <p>Siap untuk menjual hasil laut segar hari ini? Cek ringkasan penjualanmu di bawah.</p>
        </div>
        
        <!-- Revenue Breakdown Card (HIGHLIGHTED) -->
        <div class="revenue-card">
            <div class="revenue-title">💰 TOTAL PENDAPATAN</div>
            <div class="revenue-main">
                <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" pattern="#,##0" var="totalRev"/>
                Rp ${totalRev}
            </div>
            
            <div class="revenue-breakdown">
                <!-- Pendapatan Selesai -->
                <div class="revenue-item">
                    <div class="revenue-item-label">✅ Pendapatan Selesai</div>
                    <div class="revenue-item-value">
                        <fmt:formatNumber value="${completedSales != null ? completedSales : 0}" pattern="#,##0" var="completed"/>
                        Rp ${completed}
                    </div>
                    <div class="revenue-item-desc">
                        Pesanan sudah diterima customer
                    </div>
                </div>
                
                <!-- Pendapatan Dalam Proses -->
                <div class="revenue-item">
                    <div class="revenue-item-label">⏳ Dalam Proses</div>
                    <div class="revenue-item-value">
                        <fmt:formatNumber value="${pendingSales != null ? pendingSales : 0}" pattern="#,##0" var="pending"/>
                        Rp ${pending}
                        <span class="revenue-badge">DIPROSES</span>
                    </div>
                    <div class="revenue-item-desc">
                        Sedang dikemas & dikirim
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Other Stats -->
        <div class="stats-grid">
            <!-- Pesanan Perlu Dikirim -->
            <div class="stat-card">
                <div class="stat-icon" style="background: #FFE5E5;">📦</div>
                <div class="stat-label">Pesanan Perlu Dikirim</div>
                <div class="stat-value" style="color: var(--danger);">
                    ${pendingOrders != null ? pendingOrders : 0}
                </div>
            </div>
            
            <!-- Total Produk Aktif -->
            <div class="stat-card">
                <div class="stat-icon" style="background: #E5F4FF;">🐟</div>
                <div class="stat-label">Total Produk Aktif</div>
                <div class="stat-value" style="color: var(--info);">
                    ${totalProducts != null ? totalProducts : 0}
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <h3 class="action-title">Akses Cepat</h3>
        <div class="actions-grid">
            <a href="<%= request.getContextPath() %>/fisherman/addProduct.jsp" class="action-card">
                <div class="action-icon">➕</div>
                <span>Tambah Produk</span>
            </a>
            <a href="<%= request.getContextPath() %>/product?action=myProducts" class="action-card">
                <div class="action-icon">📋</div>
                <span>Kelola Stok</span>
            </a>
            <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="action-card">
                <div class="action-icon">🚚</div>
                <span>Proses Pesanan</span>
            </a>
        </div>
    </div>

</body>
</html>