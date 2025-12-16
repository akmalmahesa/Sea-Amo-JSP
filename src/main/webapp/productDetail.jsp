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
    <title>${product.productName} - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        body { background: var(--white); padding-top: 80px; font-family: 'Open Sans', sans-serif; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1100px; margin: 0 auto; width: 100%; display: flex; align-items: center; justify-content: space-between; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        
        .main-container { max-width: 1100px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 400px 1fr; gap: 40px; }
        
        .img-container { width: 100%; border-radius: 12px; overflow: hidden; border: 1px solid #E5E7E9; }
        .main-img { width: 100%; height: 400px; object-fit: cover; background: #f8f8f8; display: block; }
        .img-placeholder { width: 100%; height: 400px; display: flex; align-items: center; justify-content: center; font-size: 80px; background: #EBF5F9; color: var(--primary); }

        .info-container { display: flex; flex-direction: column; }
        .prod-title { font-size: 24px; font-weight: 700; margin-bottom: 8px; line-height: 1.3; }
        .prod-meta { display: flex; gap: 12px; font-size: 14px; color: #666; margin-bottom: 20px; align-items: center; }
        .rating { color: #FFC400; font-weight: 700; }
        
        .prod-price { font-size: 28px; font-weight: 800; color: var(--text-dark); margin-bottom: 24px; }
        
        .section-header { font-size: 16px; font-weight: 700; margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 8px; }
        .description { font-size: 14px; line-height: 1.6; color: #444; margin-bottom: 24px; }
        
        .seller-card { display: flex; align-items: center; gap: 12px; padding: 12px; background: #F5F8FA; border-radius: 8px; margin-bottom: 24px; }
        .seller-icon { font-size: 24px; }
        
        .action-box { display: flex; flex-direction: column; gap: 16px; }
        
        .qty-wrapper { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
        .qty-btn { width: 32px; height: 32px; border: 1px solid #ddd; background: white; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .qty-val { width: 50px; text-align: center; font-weight: 600; border: none; font-size: 16px; }
        
        .btn-group { display: flex; gap: 12px; }
        .btn { flex: 1; padding: 14px; border-radius: 8px; font-weight: 700; cursor: pointer; font-size: 14px; transition: 0.2s; }
        .btn-cart { border: 1px solid var(--primary); background: white; color: var(--primary); }
        .btn-cart:hover { background: #EBF5F9; }
        .btn-buy { border: 1px solid var(--primary); background: var(--primary); color: white; }
        .btn-buy:hover { background: #084d66; }

        @media (max-width: 768px) { .main-container { grid-template-columns: 1fr; } .main-img, .img-placeholder { height: 300px; } }
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

            <a href="<%= contextPath %>/cart" style="text-decoration: none; font-size: 20px;">🛒 <span style="font-size: 14px; vertical-align: top;">${cartCount}</span></a>
        </div>
    </nav>

    <div class="main-container">
        <div class="img-container">
            <c:choose>
                <c:when test="${not empty product.imageUrl && product.imageUrl != 'default-product.jpg'}">
                    <img src="<%= contextPath %>/${product.imageUrl}" class="main-img" alt="${product.productName}">
                </c:when>
                <c:otherwise>
                    <div class="img-placeholder">🐟</div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="info-container">
            <h1 class="prod-title">${product.productName}</h1>
            
            <div class="prod-meta">
                <span>Terjual 50+</span>
                <span>•</span>
                <span class="rating">⭐ 4.8</span>
                <span>•</span>
                <span>Stok: <b>${product.stock}</b> kg</span>
            </div>

            <div class="prod-price">
                <fmt:formatNumber value="${product.price}" pattern="#,##0" var="price"/>
                Rp${price} <span style="font-size: 14px; font-weight: 400; color: #666;">/ kg</span>
            </div>
            
            <div class="seller-card">
                <div class="seller-icon">⚓</div>
                <div>
                    <div style="font-weight: 700; font-size: 14px;">${product.fishermanName}</div>
                    <div style="font-size: 12px; color: #666;">Nelayan Terverifikasi • Jakarta Utara</div>
                </div>
            </div>

            <div class="section-header">Deskripsi Produk</div>
            <div class="description">
                ${product.description != null ? product.description : 'Ikan segar berkualitas tinggi langsung dari laut. Cocok untuk dibakar, digoreng, atau dimasak kuah.'}
            </div>

            <form action="<%= contextPath %>/cart" method="post" id="actionForm">
                <input type="hidden" name="productId" value="${product.productId}">
                <input type="hidden" name="action" id="formAction" value="add">

                <div class="qty-wrapper">
                    <span style="font-weight: 600; font-size: 14px;">Atur Jumlah:</span>
                    <button type="button" class="qty-btn" onclick="updateQty(-1)">-</button>
                    <input type="text" name="quantity" id="qtyInput" value="1" class="qty-val" readonly>
                    <button type="button" class="qty-btn" onclick="updateQty(1)">+</button>
                </div>

                <div class="btn-group">
                    <button type="button" class="btn btn-cart" onclick="submitForm('add')">+ Keranjang</button>
                    <button type="button" class="btn btn-buy" onclick="submitForm('buyNow')">Beli Langsung</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function updateQty(change) {
            var input = document.getElementById('qtyInput');
            var val = parseInt(input.value) + change;
            var max = ${product.stock};
            if (val >= 1 && val <= max) {
                input.value = val;
            }
        }

        function submitForm(type) {
            // Jika Beli Langsung, kita set action khusus atau handle di Servlet
            // Di sini kita pakai trik: Add to cart dulu, lalu redirect di server side jika parameternya 'buyNow'
            var inputAction = document.getElementById('formAction');
            if(type === 'buyNow') {
                inputAction.value = 'buyNow'; // Pastikan Servlet handle value ini
            } else {
                inputAction.value = 'add';
            }
            document.getElementById('actionForm').submit();
        }
    </script>

</body>
</html>