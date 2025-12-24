<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kelola Produk - SeaAmo</title>
    <style>
        :root {
            --primary: #0A5F7F;
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
        .nav-link.logout { color: #FF5E4D; }

        .main-container { max-width: 1200px; margin: 24px auto; padding: 0 20px; }
        
        .header-card { background: var(--white); border-radius: 12px; padding: 24px; box-shadow: var(--shadow-sm); margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-size: 24px; font-weight: 700; }
        
        .filter-group { display: flex; gap: 10px; }
        .filter-btn { padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; border: 1px solid #E5E7E9; background: white; color: var(--text-gray); cursor: pointer; transition: 0.2s; }
        .filter-btn:hover { border-color: var(--primary); color: var(--primary); }
        .filter-btn.active { background: var(--primary); color: white; border-color: var(--primary); }

        .products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .product-card { background: var(--white); border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-sm); transition: 0.2s; border: 1px solid transparent; }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 4px 12px 0 rgba(0,0,0,0.1); border-color: var(--primary); }
        
        .card-img-placeholder { height: 160px; background: #F8F9FA; display: flex; align-items: center; justify-content: center; font-size: 48px; color: #ddd; }
        .card-body { padding: 16px; }
        .badge-cat { background: #EBF5F9; color: var(--primary); padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; display: inline-block; margin-bottom: 8px; }
        .prod-name { font-size: 16px; font-weight: 700; margin-bottom: 4px; color: var(--text-dark); }
        .prod-owner { color: var(--text-gray); font-size: 13px; margin-bottom: 12px; }
        .prod-price { font-size: 18px; font-weight: 800; color: var(--primary); }
        
        .status-box { padding: 8px; border-radius: 6px; text-align: center; font-size: 13px; font-weight: 600; margin: 12px 0; }
        .st-approved { background: #E6F4EA; color: #1E8E3E; }
        .st-pending { background: #FFF4E5; color: #B25E09; }
        .st-rejected { background: #FCE8E6; color: #C5221F; }

        .action-row { display: flex; gap: 8px; }
        .btn-action { flex: 1; padding: 8px; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 13px; transition: 0.2s; }
        .btn-approve { background: #1E8E3E; color: white; }
        .btn-reject { background: #D93025; color: white; }
        .btn-action:hover { opacity: 0.9; }
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
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
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
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/admin" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin?action=users" class="nav-link">Users</a>
                <a href="${pageContext.request.contextPath}/admin?action=products" class="nav-link active">Produk</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="nav-link logout">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="header-card">
            <div class="page-title">🐟 Kelola Produk</div>
            <div class="filter-group">
                <a href="${pageContext.request.contextPath}/admin?action=products" 
                   class="filter-btn ${empty statusFilter ? 'active' : ''}">Semua</a>
                <a href="${pageContext.request.contextPath}/admin?action=products&status=pending" 
                   class="filter-btn ${statusFilter == 'pending' ? 'active' : ''}">Pending</a>
                <a href="${pageContext.request.contextPath}/admin?action=products&status=approved" 
                   class="filter-btn ${statusFilter == 'approved' ? 'active' : ''}">Approved</a>
                <a href="${pageContext.request.contextPath}/admin?action=products&status=rejected" 
                   class="filter-btn ${statusFilter == 'rejected' ? 'active' : ''}">Rejected</a>
            </div>
        </div>
        
        <div class="products-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <div class="card-img-placeholder">🐟</div>
                    <div class="card-body">
                        <span class="badge-cat">${product.category}</span>
                        <h3 class="prod-name">${product.productName}</h3>
                        <p class="prod-owner">Nelayan: ${product.fishermanName}</p>
                        <div class="prod-price">
                            <fmt:formatNumber value="${product.price}" pattern="#,##0" var="price"/>
                            Rp ${price}
                        </div>
                        
                        <div class="status-box ${product.status == 'approved' ? 'st-approved' : product.status == 'pending' ? 'st-pending' : 'st-rejected'}">
                            ${product.status == 'approved' ? '✅ Disetujui' : product.status == 'pending' ? '⏳ Menunggu Review' : '❌ Ditolak'}
                        </div>
                        
                        <c:if test="${product.status == 'pending'}">
                            <div class="action-row">
                                <form action="${pageContext.request.contextPath}/admin" method="post" style="flex: 1;">
                                    <input type="hidden" name="action" value="updateProductStatus">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <input type="hidden" name="status" value="approved">
                                    <button type="submit" class="btn-action btn-approve">✅ Terima</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin" method="post" style="flex: 1;">
                                    <input type="hidden" name="action" value="updateProductStatus">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <input type="hidden" name="status" value="rejected">
                                    <button type="submit" class="btn-action btn-reject">❌ Tolak</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>