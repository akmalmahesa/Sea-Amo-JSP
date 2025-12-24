<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pesanan Masuk - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; --success: #00A79D; --warning: #FA591D; --danger: #FF5E4D; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: var(--bg-gray); padding-top: 80px; font-family: 'Open Sans', sans-serif; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        .nav-links { display: flex; gap: 32px; }
        .nav-link { text-decoration: none; color: #6D7588; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .nav-link:hover { color: var(--primary); }
        .nav-link.active { color: var(--primary); border-bottom: 2px solid var(--primary); padding-bottom: 22px; }

        .main-container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-title { font-size: 24px; font-weight: 700; }
        
        /* Alert Messages */
        .alert { padding: 14px 20px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; display: flex; align-items: center; gap: 10px; }
        .alert-success { background: #E5F9F6; color: var(--success); border: 1px solid var(--success); }
        .alert-error { background: #FFE5E5; color: var(--danger); border: 1px solid var(--danger); }
        .alert .close-btn { margin-left: auto; cursor: pointer; font-size: 18px; font-weight: bold; opacity: 0.7; }
        .alert .close-btn:hover { opacity: 1; }

        /* Status Filter */
        .filter-tabs { display: flex; gap: 12px; margin-bottom: 20px; overflow-x: auto; padding-bottom: 4px; }
        .filter-tab { padding: 8px 16px; background: var(--white); border: 2px solid #E5E7E9; border-radius: 20px; cursor: pointer; font-size: 13px; font-weight: 600; white-space: nowrap; transition: 0.2s; }
        .filter-tab:hover { border-color: var(--primary); }
        .filter-tab.active { background: var(--primary); color: white; border-color: var(--primary); }

        .order-card { background: var(--white); border-radius: 12px; padding: 24px; margin-bottom: 16px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); border: 1px solid transparent; transition: 0.2s; }
        .order-card:hover { border-color: var(--primary); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }

        .order-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #F0F3F7; padding-bottom: 12px; margin-bottom: 12px; }
        .order-id { font-weight: 700; font-size: 16px; color: var(--primary); }
        .order-date { font-size: 13px; color: #666; }

        .order-status { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; text-transform: uppercase; }
        .status-paid { background: #FFF4E5; color: var(--warning); }
        .status-processing { background: #E5F4FF; color: #0A7AFF; }
        .status-shipped { background: #F0E5FF; color: #8B4DFF; }
        .status-delivered { background: #E5F9F6; color: var(--success); }
        .status-pending { background: #E5E7E9; color: #666; }
        .status-cancelled { background: #FFE5E5; color: var(--danger); }

        .order-body { display: flex; justify-content: space-between; align-items: flex-start; gap: 20px; }
        .customer-info { font-size: 14px; color: #4A5568; line-height: 1.8; flex: 1; }
        .customer-info b { color: var(--text-dark); }
        
        .order-total { text-align: right; }
        .total-label { font-size: 12px; color: #666; margin-bottom: 4px; }
        .total-value { font-size: 18px; font-weight: 800; color: var(--text-dark); }

        .order-actions { margin-top: 16px; padding-top: 16px; border-top: 1px dashed #E5E7E9; display: flex; justify-content: flex-end; gap: 10px; }
        
        .btn { padding: 10px 20px; border: none; border-radius: 6px; font-weight: 700; font-size: 14px; cursor: pointer; transition: 0.2s; text-decoration: none; display: inline-block; }
        .btn-confirm { background: var(--success); color: white; }
        .btn-confirm:hover { background: #008a82; transform: translateY(-1px); }
        .btn-ship { background: var(--primary); color: white; }
        .btn-ship:hover { background: #084d66; transform: translateY(-1px); }
        .btn-view { background: #E5E7E9; color: var(--text-dark); }
        .btn-view:hover { background: #d0d3d6; }

        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 12px; }
        .empty-state-icon { font-size: 50px; margin-bottom: 20px; }
        .empty-state h3 { margin-bottom: 8px; color: var(--text-dark); }
        .empty-state p { color: #666; }

        @media (max-width: 768px) { 
            .nav-links { display: none; } 
            .order-body { flex-direction: column; }
            .order-actions { flex-direction: column; }
            .btn { width: 100%; text-align: center; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <div class="logo-section" style="display: flex; align-items: center; gap: 8px;">
                <img src="${pageContext.request.contextPath}/uploads/seaamo.svg" alt="SeaAmo Logo" style="width:36px;">
                <span style="font-size: 18px; font-weight: 600; line-height: 1; white-space: nowrap;">SeaAmo</span>
            </div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/fisherman/dashboard.jsp" class="nav-link">Dashboard</a>
                <a href="<%= request.getContextPath() %>/product?action=myProducts" class="nav-link">Produk Saya</a>
                <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="nav-link active">Pesanan Masuk</a>
                <a href="<%= request.getContextPath() %>/fisherman/profile.jsp" class="nav-link">Profil</a>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="nav-link" style="color: #FF5E4D;">Keluar</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Daftar Pesanan</h1>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <span>✓ ${sessionScope.success}</span>
                <span class="close-btn" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-error">
                <span>✕ ${sessionScope.error}</span>
                <span class="close-btn" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Filter by Status -->
        <div class="filter-tabs">
            <div class="filter-tab active" onclick="filterOrders('all')">Semua</div>
            <div class="filter-tab" onclick="filterOrders('paid')">Perlu Konfirmasi</div>
            <div class="filter-tab" onclick="filterOrders('processing')">Sedang Diproses</div>
            <div class="filter-tab" onclick="filterOrders('shipped')">Sedang Dikirim</div>
            <div class="filter-tab" onclick="filterOrders('delivered')">Selesai</div>
        </div>
        
        <c:if test="${empty orders}">
            <div class="empty-state">
                <div class="empty-state-icon">📦</div>
                <h3>Belum ada pesanan masuk</h3>
                <p>Produkmu akan muncul di sini saat ada pembeli.</p>
            </div>
        </c:if>

        <div id="ordersList">
            <c:forEach var="order" items="${orders}">
                <div class="order-card" data-status="${order.status}">
                    <div class="order-header">
                        <div>
                            <span class="order-id">#${order.orderId}</span>
                            <span style="margin: 0 8px; color: #ccc;">|</span>
                            <span class="order-date">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, HH:mm"/>
                            </span>
                        </div>
                        <span class="order-status status-${order.status}">
                            ${order.statusLabel}
                        </span>
                    </div>
                    
                    <div class="order-body">
                        <div class="customer-info">
                            <div><b>Pembeli:</b> ${order.customerName}</div>
                            <div><b>Alamat:</b> ${order.shippingAddress}</div>
                            <c:if test="${order.status == 'paid'}">
                                <div style="margin-top: 8px; padding: 8px; background: #FFF4E5; border-radius: 6px; color: var(--warning); font-size: 13px;">
                                    ⚠️ Pesanan sudah dibayar, silakan konfirmasi untuk memproses
                                </div>
                            </c:if>
                        </div>
                        <div class="order-total">
                            <div class="total-label">Total Pendapatan</div>
                            <div class="total-value">
                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" var="total"/>
                                Rp${total}
                            </div>
                        </div>
                    </div>

                    <div class="order-actions">
                        <!-- Tombol untuk status PAID: Konfirmasi Pesanan -->
                        <c:if test="${order.status == 'paid'}">
                            <form action="<%= request.getContextPath() %>/fisherman" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="confirmOrder">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <button type="submit" class="btn btn-confirm" 
                                        onclick="return confirm('Konfirmasi pesanan #${order.orderId}? Setelah dikonfirmasi, status akan berubah menjadi Diproses.')">
                                    ✓ Konfirmasi Pesanan
                                </button>
                            </form>
                        </c:if>

                        <!-- Tombol untuk status PROCESSING: Tandai Sedang Dikirim -->
                        <c:if test="${order.status == 'processing'}">
                            <form action="<%= request.getContextPath() %>/fisherman" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <input type="hidden" name="status" value="shipped">
                                <button type="submit" class="btn btn-ship"
                                        onclick="return confirm('Tandai pesanan #${order.orderId} sebagai sedang dikirim?')">
                                    🚚 Tandai Sedang Dikirim
                                </button>
                            </form>
                        </c:if>

                        <!-- Tombol Lihat Detail (selalu muncul) -->
                        <a href="<%= request.getContextPath() %>/order/detail?orderId=${order.orderId}" class="btn btn-view">
                            👁️ Lihat Detail
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script>
        // Filter orders by status
        function filterOrders(status) {
            const cards = document.querySelectorAll('.order-card');
            const tabs = document.querySelectorAll('.filter-tab');
            
            // Update active tab
            tabs.forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
            
            // Show/hide cards
            cards.forEach(card => {
                if (status === 'all' || card.dataset.status === status) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.3s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 300);
            });
        }, 5000);
    </script>

</body>
</html>