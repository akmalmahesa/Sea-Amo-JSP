<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String contextPath = request.getContextPath();
    Integer cartCount = (Integer) session.getAttribute("cartCount");
    if (cartCount == null) cartCount = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Belanja - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: var(--bg-gray); padding-top: 80px; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; align-items: center; justify-content: space-between; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        .nav-icons { display: flex; gap: 20px; align-items: center; }
        .nav-link { text-decoration: none; color: #6D7588; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .nav-link:hover { color: var(--primary); }

        .main-container { max-width: 1200px; margin: 24px auto; padding: 0 16px; }

        .filter-bar { background: var(--white); padding: 16px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); margin-bottom: 24px; display: flex; gap: 16px; flex-wrap: wrap; align-items: center; }
        .search-input { flex: 1; padding: 10px 14px; border: 1px solid #E5E7E9; border-radius: 6px; }
        .filter-select { padding: 10px; border: 1px solid #E5E7E9; border-radius: 6px; background: white; min-width: 150px; }
        .btn-filter { padding: 10px 24px; background: var(--primary); color: white; border: none; border-radius: 6px; font-weight: 700; cursor: pointer; }

        .products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(190px, 1fr)); gap: 16px; }
        .product-card { background: var(--white); border-radius: 8px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.1); transition: all 0.2s; cursor: pointer; border: 1px solid transparent; display: flex; flex-direction: column; }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-color: var(--primary); }
        
        .card-img { width: 100%; padding-top: 100%; position: relative; background: #f8f8f8; }
        .card-img img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; }
        .card-placeholder { position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-size: 40px; }
        
        .card-body { padding: 12px; flex: 1; display: flex; flex-direction: column; }
        .prod-name { font-size: 14px; line-height: 1.4; margin-bottom: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 40px; }
        .prod-price { font-size: 16px; font-weight: 800; color: var(--text-dark); margin-bottom: 8px; }
        .prod-seller { font-size: 12px; color: #999; display: flex; align-items: center; gap: 4px; margin-bottom: 12px; }
        
        .btn-add { width: 100%; margin-top: auto; padding: 8px; border: 1px solid var(--primary); background: white; color: var(--primary); border-radius: 6px; font-weight: 700; cursor: pointer; transition: 0.2s; font-size: 12px; }
        .btn-add:hover { background: #EBF5F9; }

        @media (max-width: 768px) { .products-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; } }
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

            <div class="nav-icons">
                 <a href="<%= contextPath %>/cart" class="nav-link">Keranjang (${cartCount})</a>
                 <a href="<%= contextPath %>/customer/dashboard.jsp" class="nav-link">Home</a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        
        <form class="filter-bar" action="<%= contextPath %>/product" method="get">
            <input type="hidden" name="action" value="list">
            <input type="text" name="search" class="search-input" placeholder="Cari ikan, udang..." value="${param.search}">
            
            <select name="category" class="filter-select">
                <option value="">Semua Kategori</option>
                <option value="Ikan Laut" ${param.category == 'Ikan Laut' ? 'selected' : ''}>Ikan Laut</option>
                <option value="Udang" ${param.category == 'Udang' ? 'selected' : ''}>Udang</option>
                <option value="Cumi" ${param.category == 'Cumi' ? 'selected' : ''}>Cumi</option>
                <option value="Kerang" ${param.category == 'Kerang' ? 'selected' : ''}>Kerang</option>
            </select>
            
            <button type="submit" class="btn-filter">Cari</button>
        </form>

        <div class="products-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card" onclick="window.location='<%= contextPath %>/product?action=view&id=${product.productId}'">
                    <div class="card-img">
                        <c:choose>
                            <c:when test="${not empty product.imageUrl && product.imageUrl != 'default-product.jpg'}">
                                <img src="<%= contextPath %>/${product.imageUrl}" alt="${product.productName}">
                            </c:when>
                            <c:otherwise>
                                <div class="card-placeholder">🐟</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="card-body">
                        <div class="prod-name">${product.productName}</div>
                        <div class="prod-price">
                            <fmt:formatNumber value="${product.price}" pattern="#,##0" var="price"/>
                            Rp${price}
                        </div>
                        <div class="prod-seller">📍 ${product.fishermanName}</div>
                        
                        <form action="<%= contextPath %>/cart" method="post" onclick="event.stopPropagation();">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <button type="submit" class="btn-add">+ Keranjang</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty products}">
            <div style="text-align: center; padding: 60px; color: #999;">
                <h3>Produk tidak ditemukan</h3>
                <p>Coba kata kunci lain atau reset filter.</p>
            </div>
        </c:if>
    </div>

</body>
</html>