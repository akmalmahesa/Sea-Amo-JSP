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
    <title>Keranjang Belanja - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --primary-dark: #084d66; --accent: #FF5E4D; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; --text-gray: #6D7588; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: var(--bg-gray); padding-top: 80px; color: var(--text-dark); }

        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        .nav-link { color: var(--text-dark); font-weight: 600; text-decoration: none; font-size: 14px; }

        .main-container { max-width: 1200px; margin: 24px auto; padding: 0 16px; display: grid; grid-template-columns: 1fr 350px; gap: 24px; }

        .section-title { font-size: 20px; font-weight: 700; margin-bottom: 16px; grid-column: 1 / -1; }

        .cart-items-wrapper { display: flex; flex-direction: column; gap: 16px; }
        .cart-card { background: var(--white); border-radius: 8px; padding: 16px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); display: flex; gap: 16px; align-items: flex-start; }
        
        .item-img { width: 80px; height: 80px; background: #EBF5F9; border-radius: 6px; object-fit: cover; display: flex; align-items: center; justify-content: center; font-size: 30px; flex-shrink: 0; }
        .item-details { flex: 1; }
        .item-name { font-weight: 600; font-size: 16px; margin-bottom: 4px; color: var(--text-dark); }
        .item-shop { font-size: 12px; color: var(--primary); display: flex; align-items: center; gap: 4px; margin-bottom: 8px; }
        .item-price { font-weight: 700; color: var(--text-dark); font-size: 16px; }

        .item-actions { display: flex; justify-content: space-between; align-items: center; margin-top: 12px; }
        .delete-btn { color: #999; font-size: 20px; cursor: pointer; text-decoration: none; transition: 0.2s; }
        .delete-btn:hover { color: var(--accent); }

        .qty-control { display: flex; align-items: center; border: 1px solid #E5E7E9; border-radius: 6px; overflow: hidden; }
        .qty-input { width: 40px; text-align: center; border: none; padding: 4px; font-weight: 600; outline: none; }
        .qty-btn { background: #fff; border: none; padding: 4px 10px; cursor: pointer; font-weight: bold; color: var(--primary); transition: 0.2s; }
        .qty-btn:hover { background: #f0f0f0; }

        .summary-card { background: var(--white); border-radius: 8px; padding: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); height: fit-content; position: sticky; top: 100px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; color: var(--text-gray); }
        .summary-total { display: flex; justify-content: space-between; margin-top: 16px; padding-top: 16px; border-top: 1px solid #E5E7E9; font-weight: 700; font-size: 18px; color: var(--text-dark); }
        
        .btn-checkout { display: block; width: 100%; background: var(--primary); color: white; text-align: center; padding: 12px; border-radius: 8px; font-weight: 700; text-decoration: none; margin-top: 20px; transition: 0.2s; }
        .btn-checkout:hover { background: var(--primary-dark); }

        .empty-cart { grid-column: 1 / -1; text-align: center; padding: 60px 20px; background: white; border-radius: 8px; }
        
        @media (max-width: 768px) {
            .main-container { grid-template-columns: 1fr; }
            .summary-card { position: static; }
        }
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

            <a href="<%= contextPath %>/product?action=list" class="nav-link">Lanjut Belanja</a>
        </div>
    </nav>

    <div class="main-container">
        <h2 class="section-title">Keranjang Belanja</h2>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-cart">
                    <div style="font-size: 60px; margin-bottom: 20px;">🛒</div>
                    <h3>Keranjangmu kosong</h3>
                    <p style="color: #666; margin-bottom: 20px;">Yuk isi dengan hasil laut segar!</p>
                    <a href="<%= contextPath %>/product?action=list" style="color: var(--primary); font-weight: 700;">Mulai Belanja</a>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="cart-items-wrapper">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-card">
                            <c:choose>
                                <c:when test="${not empty item.product.imageUrl && item.product.imageUrl != 'default-product.jpg'}">
                                    <img src="<%= contextPath %>/${item.product.imageUrl}" class="item-img" alt="${item.product.productName}">
                                </c:when>
                                <c:otherwise>
                                    <div class="item-img">🐟</div>
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="item-details">
                                <div class="item-name">${item.product.productName}</div>
                                <div class="item-shop">📍 ${item.product.fishermanName}</div>
                                <div class="item-price">
                                    <fmt:formatNumber value="${item.product.price}" pattern="#,##0" var="price"/>
                                    Rp${price}
                                </div>
                                
                                <div class="item-actions">
                                    <form action="<%= contextPath %>/cart" method="post" class="qty-control">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="cartId" value="${item.cartId}">
                                        
                                        <input type="number" name="quantity" value="${item.quantity}" min="1" class="qty-input">
                                        <button type="submit" class="qty-btn">Update</button>
                                    </form>
                                    
                                    <a href="<%= contextPath %>/cart?action=remove&id=${item.cartId}" class="delete-btn" title="Hapus">🗑️</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="summary-card">
                    <h3 style="margin-bottom: 20px; font-size: 16px;">Ringkasan Belanja</h3>
                    <div class="summary-row">
                        <span>Total Harga (${cartItems.size()} barang)</span>
                        <span>
                            <fmt:formatNumber value="${totalAmount}" pattern="#,##0" var="total"/>
                            Rp${total}
                        </span>
                    </div>
                    <div class="summary-total">
                        <span>Total Tagihan</span>
                        <span style="color: var(--primary);">Rp${total}</span>
                    </div>
                    <a href="<%= contextPath %>/order?action=checkout" class="btn-checkout">Pilih Pembayaran</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>