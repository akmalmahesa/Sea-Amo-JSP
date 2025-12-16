<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Produk Saya - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        body { background: var(--bg-gray); padding-top: 80px; font-family: 'Open Sans', sans-serif; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        .nav-links { display: flex; gap: 32px; }
        .nav-link { text-decoration: none; color: #6D7588; font-weight: 600; font-size: 14px; }
        .nav-link.active { color: var(--primary); border-bottom: 2px solid var(--primary); padding-bottom: 22px; }

        .main-container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        
        .header-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-title { font-size: 24px; font-weight: 700; }
        .btn-add { padding: 12px 24px; background: var(--primary); color: white; text-decoration: none; border-radius: 8px; font-weight: 700; display: flex; align-items: center; gap: 8px; transition: 0.2s; }
        .btn-add:hover { background: #084d66; }

        .products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .product-card { background: var(--white); border-radius: 12px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.1); transition: 0.2s; border: 1px solid transparent; }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-color: var(--primary); }

        .card-img { height: 180px; background: #EBF5F9; display: flex; align-items: center; justify-content: center; font-size: 60px; overflow: hidden; position: relative; }
        .card-img img { width: 100%; height: 100%; object-fit: cover; }
        .status-badge { position: absolute; top: 12px; right: 12px; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; background: rgba(255,255,255,0.9); }
        .status-approved { color: #28a745; border: 1px solid #28a745; }
        .status-pending { color: #ffc107; border: 1px solid #ffc107; }

        .card-body { padding: 16px; }
        .prod-category { font-size: 12px; color: #6D7588; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.5px; }
        .prod-name { font-size: 16px; font-weight: 700; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .prod-price { font-size: 18px; font-weight: 800; color: var(--primary); margin-bottom: 12px; }
        .prod-stock { font-size: 13px; color: #4A5568; background: #F0F3F7; display: inline-block; padding: 4px 8px; border-radius: 4px; margin-bottom: 16px; }

        .card-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; border-top: 1px solid #F0F3F7; padding-top: 16px; }
        .btn-action { padding: 8px; text-align: center; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .btn-edit { background: white; border: 1px solid var(--primary); color: var(--primary); }
        .btn-edit:hover { background: #EBF5F9; }
        .btn-delete { background: white; border: 1px solid #FF5E4D; color: #FF5E4D; }
        .btn-delete:hover { background: #FFF5F5; }
        
        .alert { padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; }
        .alert-success { background: #D4EDDA; color: #155724; }
        
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
                <a href="<%= request.getContextPath() %>/product?action=myProducts" class="nav-link active">Produk Saya</a>
                <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="nav-link">Pesanan Masuk</a>
                <a href="<%= request.getContextPath() %>/fisherman/profile.jsp" class="nav-link">Profil</a>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="nav-link" style="color: #FF5E4D;">Keluar</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="header-row">
            <h1 class="page-title">Etalase Produk (${products.size()})</h1>
            <a href="<%= request.getContextPath() %>/fisherman/addProduct.jsp" class="btn-add">➕ Tambah Produk</a>
        </div>

        <c:if test="${param.success == 'added'}"><div class="alert alert-success">✅ Produk berhasil ditambahkan!</div></c:if>
        <c:if test="${param.success == 'updated'}"><div class="alert alert-success">✅ Stok dan harga berhasil diperbarui!</div></c:if>
        <c:if test="${param.success == 'deleted'}"><div class="alert alert-success">🗑️ Produk berhasil dihapus.</div></c:if>

        <div class="products-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <div class="card-img">
                        <c:choose>
                            <c:when test="${not empty product.imageUrl && product.imageUrl != 'default-product.jpg'}">
                                <img src="<%= request.getContextPath() %>/${product.imageUrl}" alt="${product.productName}">
                            </c:when>
                            <c:otherwise>🐟</c:otherwise>
                        </c:choose>
                        
                        <span class="status-badge ${product.status == 'approved' ? 'status-approved' : 'status-pending'}">
                            ${product.status == 'approved' ? 'Aktif' : 'Menunggu'}
                        </span>
                    </div>
                    
                    <div class="card-body">
                        <div class="prod-category">${product.category}</div>
                        <div class="prod-name">${product.productName}</div>
                        <div class="prod-price">
                            <fmt:formatNumber value="${product.price}" pattern="#,##0" var="price"/>
                            Rp${price}
                        </div>
                        <div class="prod-stock">📦 Stok: <b>${product.stock}</b> kg</div>
                        
                        <div class="card-actions">
                            <a href="<%= request.getContextPath() %>/product?action=edit&id=${product.productId}" class="btn-action btn-edit">Edit</a>
                            <a href="<%= request.getContextPath() %>/product?action=delete&id=${product.productId}" class="btn-action btn-delete" onclick="return confirm('Hapus produk ini?')">Hapus</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty products}">
            <div style="text-align: center; padding: 60px; background: white; border-radius: 12px; margin-top: 20px;">
                <div style="font-size: 50px; margin-bottom: 20px;">🎣</div>
                <h3>Belum ada produk</h3>
                <p style="color: #666; margin-bottom: 20px;">Mulai jual hasil tangkapanmu sekarang!</p>
                <a href="<%= request.getContextPath() %>/fisherman/addProduct.jsp" class="btn-add" style="display: inline-flex;">Tambah Produk Pertama</a>
            </div>
        </c:if>
    </div>

</body>
</html>