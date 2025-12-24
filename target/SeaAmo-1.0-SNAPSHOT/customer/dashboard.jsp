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
    <title>SeaAmo - Segar dari Laut</title>
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
            --shadow-hover: 0 4px 12px 0 rgba(49,53,59,0.12);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', 'Segoe UI', Roboto, sans-serif; }
        body { background-color: var(--bg-gray); color: var(--text-dark); padding-top: 80px; }
        a { text-decoration: none; color: inherit; }

        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; left: 0; right: 0; z-index: 999; box-shadow: var(--shadow-sm); padding: 0 20px; }
        .nav-container { width: 100%; max-width: 1200px; margin: 0 auto; display: flex; align-items: center; gap: 24px; }
        
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
        .logo span:first-child { font-size: 32px; }
        

        .search-wrapper { flex: 1; position: relative; }
        .search-input { width: 100%; height: 40px; padding: 0 45px 0 16px; border: 1px solid #E5E7E9; border-radius: 8px; font-size: 14px; color: var(--text-dark); transition: all 0.2s; background: #F3F4F5; }
        .search-input:focus { background: var(--white); border-color: var(--primary); outline: none; }
        .search-btn-icon { position: absolute; right: 0; top: 0; height: 40px; width: 40px; border: none; background: transparent; color: var(--text-gray); cursor: pointer; display: flex; align-items: center; justify-content: center; }

        .nav-icons { display: flex; align-items: center; gap: 20px; flex-shrink: 0; }
        .icon-btn { position: relative; color: var(--text-gray); font-size: 20px; transition: 0.2s; display: flex; align-items: center; }
        .icon-btn:hover { color: var(--primary); }
        .cart-badge { position: absolute; top: -5px; right: -8px; background: var(--accent); color: white; font-size: 10px; font-weight: bold; padding: 2px 6px; border-radius: 10px; border: 2px solid var(--white); }

        .user-profile { display: flex; align-items: center; gap: 8px; cursor: pointer; padding: 4px 8px; border-radius: 6px; transition: 0.2s; }
        .user-profile:hover { background: #F3F4F5; }
        .avatar { width: 32px; height: 32px; background: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 14px; }
        .username { font-size: 14px; font-weight: 600; color: var(--text-dark); white-space: nowrap; max-width: 120px; overflow: hidden; text-overflow: ellipsis; }

        .main-container { max-width: 1200px; margin: 24px auto; padding: 0 16px; }
        
        
        .hero-section {
            position: relative;
            height: 400px;
            overflow: hidden;
        }

        .hero-bg {
            position: absolute;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            color: white;
            text-align: center;
        }
        .hero-section::before {
            background: linear-gradient(
                to bottom,
                rgba(0,0,0,0.6),
                rgba(0,0,0,0.2)
            );
        }
        
        .hero-section { margin-bottom: 24px; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-sm); position: relative; height: 300px; background: linear-gradient(135deg, #0A5F7F, #2196F3); display: flex; align-items: center; justify-content: center; color: white; text-align: center; }
        .hero-content h1 { font-size: 32px; margin-bottom: 12px; }
        .hero-content p { font-size: 16px; opacity: 0.9; max-width: 600px; margin: 0 auto; }
        /* Placeholder styling to simulate an image slider */
        .hero-dots { position: absolute; bottom: 16px; left: 50%; transform: translateX(-50%); display: flex; gap: 8px; }
        .dot { width: 8px; height: 8px; background: rgba(255,255,255,0.5); border-radius: 50%; }
        .dot.active { background: white; width: 24px; border-radius: 4px; }

        .section-title { font-size: 20px; font-weight: 700; color: var(--text-dark); margin-bottom: 16px; }
        .categories-wrapper { background: var(--white); padding: 16px; border-radius: 12px; box-shadow: var(--shadow-sm); margin-bottom: 24px; }
        .categories-grid { display: flex; justify-content: space-between; overflow-x: auto; gap: 16px; padding-bottom: 8px; }
        .cat-item { display: flex; flex-direction: column; align-items: center; gap: 8px; min-width: 80px; cursor: pointer; transition: 0.2s; }
        .cat-item:hover { transform: translateY(-4px); }
        .cat-icon { width: 48px; height: 48px; border-radius: 12px; background: #EBF5F9; display: flex; align-items: center; justify-content: center; font-size: 24px; border: 1px solid #E0E0E0; }
        .cat-name { font-size: 13px; color: var(--text-dark); font-weight: 500; text-align: center; }

        .products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 16px; }
        .product-card { background: var(--white); border-radius: 8px; overflow: hidden; box-shadow: var(--shadow-sm); transition: all 0.2s; cursor: pointer; display: flex; flex-direction: column; height: 100%; border: 1px solid transparent; }
        .product-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-hover); border-color: var(--primary); }
        
        .prod-img-box { width: 100%; padding-top: 100%; /* 1:1 Aspect Ratio */ position: relative; background: #f8f8f8; }
        .prod-img-box img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; }
        .prod-img-placeholder { position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-size: 40px; color: #ddd; }
        
        .prod-info { padding: 10px; flex: 1; display: flex; flex-direction: column; }
        .prod-name { font-size: 14px; font-weight: 400; line-height: 1.4; color: var(--text-dark); margin-bottom: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 40px; }
        .prod-price { font-size: 16px; font-weight: 800; color: var(--text-dark); margin-bottom: 6px; }
        .prod-meta { display: flex; align-items: center; gap: 4px; font-size: 12px; color: var(--text-gray); margin-bottom: 12px; }
        .prod-loc { display: flex; align-items: center; gap: 2px; }
        .prod-rating { display: flex; align-items: center; gap: 2px; }
        .star { color: #FFC400; font-size: 10px; }

        .prod-actions { margin-top: auto; display: flex; flex-direction: column; gap: 6px; }
        .btn { width: 100%; padding: 6px 0; border-radius: 6px; font-weight: 700; font-size: 12px; cursor: pointer; border: none; transition: 0.2s; }
        .btn-outline { background: white; border: 1px solid var(--primary); color: var(--primary); }
        .btn-outline:hover { background: #EBF5F9; }
        .btn-fill { background: var(--primary); color: white; border: 1px solid var(--primary); }
        .btn-fill:hover { background: var(--primary-dark); }

        @media (max-width: 768px) {
            .navbar { padding: 0 16px; }
            .username, .nav-text { display: none; }
            .hero-section { height: 180px; }
            .hero-content h1 { font-size: 20px; }
            .categories-grid { justify-content: flex-start; }
            .products-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= contextPath %>/product?action=customerDashboard" class="logo">
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
            </a>

            <form class="search-wrapper" action="<%= contextPath %>/product" method="get">
                <input type="text" name="search" class="search-input" placeholder="Cari ikan segar, udang, atau cumi...">
                <button type="submit" class="search-btn-icon">🔍</button>
            </form>

            <div class="nav-icons">
                <a href="<%= contextPath %>/cart" class="icon-btn">
                    🛒
                    <c:if test="${cartCount > 0}">
                        <span class="cart-badge">${cartCount}</span>
                    </c:if>
                </a>
                <a href="#" class="icon-btn">📧</a> <div class="user-profile" onclick="window.location='<%= contextPath %>/customer/profile.jsp'">
                    <div class="avatar">${sessionScope.user.fullName.substring(0,1).toUpperCase()}</div>
                    <span class="username">${sessionScope.user.fullName}</span>
                </div>
            </div>
        </div>
    </nav>

    <div class="main-container">
        
        <div class="hero-section">
            <img src="${pageContext.request.contextPath}/uploads/seafood-background.jpg" class="hero-bg">

            <div class="hero-content">
                <h1>Tangkapan Segar Hari Ini 🎣</h1>
                <p>Langsung dari nelayan lokal ke dapur Anda dengan kualitas terbaik.</p>
            </div>
        </div>



        <div class="categories-wrapper">
            <h3 class="section-title">Kategori Pilihan</h3>
            <div class="categories-grid">
                 <div class="cat-item" onclick="window.location='<%= contextPath %>/product?action=list'">
                    <div class="cat-icon" style="color: #0A5F7F;">⭐</div>
                    <span class="cat-name">Semua</span>
                </div>
                <div class="cat-item" onclick="window.location='<%= contextPath %>/product?action=list&category=Ikan Laut'">
                    <div class="cat-icon" style="color: #2196F3;">🐟</div>
                    <span class="cat-name">Ikan Laut</span>
                </div>
                <div class="cat-item" onclick="window.location='<%= contextPath %>/product?action=list&category=Ikan Air Tawar'">
                    <div class="cat-icon" style="color: #00BCD4;">️🐠</div>
                    <span class="cat-name">Ikan Air Tawar</span>
                </div>
                <div class="cat-item" onclick="window.location='<%= contextPath %>/product?action=list&category=Udang'">
                    <div class="cat-icon" style="color: #FF5E4D;">🦐</div>
                    <span class="cat-name">Udang</span>
                </div>
                <div class="cat-item" onclick="window.location='<%= contextPath %>/product?action=list&category=Cumi'">
                    <div class="cat-icon" style="color: #9C27B0;">🦑</div>
                    <span class="cat-name">Cumi</span>
                </div>
                <div class="cat-item" onclick="window.location='<%= contextPath %>/product?action=list&category=Kerang'">
                    <div class="cat-icon" style="color: #FF9800;">🦀</div>
                    <span class="cat-name">Kepiting & Kerang</span>
                </div>
            </div>
        </div>

        <h3 class="section-title">Rekomendasi Untukmu</h3>
        <div class="products-grid">
            <c:choose>
                <c:when test="${not empty products}">
                    <c:forEach var="product" items="${products}">
                        <div class="product-card" onclick="window.location='<%= contextPath %>/product?action=view&id=${product.productId}'">
                            <div class="prod-img-box">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl && product.imageUrl != 'default-product.jpg'}">
                                        <img src="<%= contextPath %>/${product.imageUrl}" alt="${product.productName}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="prod-img-placeholder">🐟</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="prod-info">
                                <h4 class="prod-name">${product.productName}</h4>
                                <div class="prod-price">
                                    <fmt:formatNumber value="${product.price}" pattern="#,##0" var="price"/>
                                    Rp${price}
                                </div>
                                <div class="prod-meta">
                                    <div class="prod-loc">📍 ${product.fishermanName}</div>
                                    <div style="margin: 0 4px;">•</div>
                                    <div class="prod-rating"><span class="star">⭐</span> 4.8</div>
                                </div>

                                <div class="prod-actions" onclick="event.stopPropagation();">
                                    <form action="<%= contextPath %>/cart" method="post" style="display: flex; gap: 5px; flex-direction: column;">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        
                                        <button type="submit" name="action" value="add" class="btn btn-outline">
                                            + Keranjang
                                        </button>
                                        
                                        <button type="submit" name="action" value="buyNow" class="btn btn-fill">
                                            Beli Langsung
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="grid-column: 1 / -1; padding: 40px; text-align: center; color: var(--text-gray); background: white; border-radius: 8px;">
                        <span style="font-size: 40px; display: block; margin-bottom: 10px;">🏝️</span>
                        Belum ada produk yang tersedia saat ini.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>