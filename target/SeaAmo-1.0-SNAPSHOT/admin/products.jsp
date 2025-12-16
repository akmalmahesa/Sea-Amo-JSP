<!-- ============================================================================ -->
<!-- admin/products.jsp -->
<!-- ============================================================================ -->
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kelola Produk - SeaAmo</title>
</head>
<body style="background: linear-gradient(135deg, #154D71 0%, #1C6EA4 100%); min-height: 100vh; font-family: 'Segoe UI';">
    <nav style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); padding: 15px 0;">
        <div style="max-width: 1400px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between;">
            <a href="../index.jsp" style="color: #FFF9AF; font-size: 1.8rem; text-decoration: none; font-weight: 700;">🌊 SeaAmo</a>
            <div style="display: flex; gap: 30px;">
                <a href="../admin" style="color: white; text-decoration: none;">Dashboard</a>
                <a href="../admin?action=users" style="color: white; text-decoration: none;">Users</a>
                <a href="../admin?action=products" style="color: #FFF9AF; text-decoration: none;">Produk</a>
                <a href="../admin?action=orders" style="color: white; text-decoration: none;">Pesanan</a>
                <a href="../auth?action=logout" style="color: white; text-decoration: none;">Logout</a>
            </div>
        </div>
    </nav>
    
    <div style="max-width: 1400px; margin: 30px auto; padding: 0 20px;">
        <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 30px; margin-bottom: 20px;">
            <h1 style="color: white; font-size: 2rem;">🐟 Kelola Produk</h1>
            <div style="margin-top: 15px; display: flex; gap: 10px;">
                <a href="../admin?action=products" style="padding: 8px 16px; background: ${empty statusFilter ? 'rgba(51,161,224,0.5)' : 'rgba(255,255,255,0.2)'}; color: white; text-decoration: none; border-radius: 8px;">Semua</a>
                <a href="../admin?action=products&status=pending" style="padding: 8px 16px; background: ${statusFilter == 'pending' ? 'rgba(255,193,7,0.5)' : 'rgba(255,255,255,0.2)'}; color: white; text-decoration: none; border-radius: 8px;">Pending</a>
                <a href="../admin?action=products&status=approved" style="padding: 8px 16px; background: ${statusFilter == 'approved' ? 'rgba(40,167,69,0.5)' : 'rgba(255,255,255,0.2)'}; color: white; text-decoration: none; border-radius: 8px;">Approved</a>
                <a href="../admin?action=products&status=rejected" style="padding: 8px 16px; background: ${statusFilter == 'rejected' ? 'rgba(220,53,69,0.5)' : 'rgba(255,255,255,0.2)'}; color: white; text-decoration: none; border-radius: 8px;">Rejected</a>
            </div>
        </div>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px;">
            <c:forEach var="product" items="${products}">
                <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; overflow: hidden;">
                    <div style="height: 180px; background: linear-gradient(135deg, #33A1E0, #1C6EA4); display: flex; align-items: center; justify-content: center; font-size: 4rem;">🐟</div>
                    <div style="padding: 20px;">
                        <span style="background: rgba(255,249,175,0.3); color: #FFF9AF; padding: 5px 12px; border-radius: 20px; font-size: 0.8rem;">${product.category}</span>
                        <h3 style="color: white; font-size: 1.1rem; margin: 10px 0;">${product.productName}</h3>
                        <p style="color: rgba(255,255,255,0.7); font-size: 0.85rem; margin-bottom: 8px;">Nelayan: ${product.fishermanName}</p>
                        <p style="color: #FFF9AF; font-size: 1.3rem; font-weight: 700; margin: 10px 0;">
                            <fmt:formatNumber value="${product.price}" pattern="#,##0" var="price"/>
                            Rp ${price}
                        </p>
                        <div style="padding: 8px; background: rgba(${product.status == 'approved' ? '40,167,69' : product.status == 'pending' ? '255,193,7' : '220,53,69'},0.3); border-radius: 8px; text-align: center; color: white; margin-bottom: 15px; font-size: 0.85rem;">
                            ${product.status == 'approved' ? '✅ Disetujui' : product.status == 'pending' ? '⏳ Menunggu' : '❌ Ditolak'}
                        </div>
                        <c:if test="${product.status == 'pending'}">
                            <div style="display: flex; gap: 5px;">
                                <form action="../admin" method="post" style="flex: 1;">
                                    <input type="hidden" name="action" value="updateProductStatus">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <input type="hidden" name="status" value="approved">
                                    <button type="submit" style="width: 100%; padding: 8px; border: none; background: rgba(220,53,69,0.5); color: white; border-radius: 6px; cursor: pointer; font-size: 0.85rem;">❌ Tolak</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html> border: none; background: rgba(40,167,69,0.5); color: white; border-radius: 6px; cursor: pointer; font-size: 0.85rem;">✅ Setuju</button>
                                </form>
                                <form action="../admin" method="post" style="flex: 1;">
                                    <input type="hidden" name="action" value="updateProductStatus">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <input type="hidden" name="status" value="rejected">
                                    <button type="submit" style="width: 100%; padding: 8px;