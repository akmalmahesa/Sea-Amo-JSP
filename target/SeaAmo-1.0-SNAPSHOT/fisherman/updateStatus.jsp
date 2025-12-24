<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Status Pesanan - SeaAmo</title>
    <style>
        :root { 
            --primary: #0A5F7F; 
            --bg-gray: #F0F3F7; 
            --white: #FFFFFF; 
            --text-dark: #212121; 
            --success: #00A79D;
            --warning: #FA591D;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background: var(--bg-gray); padding-top: 80px; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .nav-links { display: flex; gap: 32px; }
        .nav-link { text-decoration: none; color: #6D7588; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .nav-link:hover { color: var(--primary); }

        .main-container { max-width: 600px; margin: 40px auto; padding: 0 20px; }
        
        .card { background: var(--white); border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden; }
        .card-header { background: var(--primary); color: white; padding: 20px; text-align: center; }
        .card-header h2 { font-size: 20px; }

        .card-body { padding: 30px; }
        .order-summary { background: #F8FAFB; border-radius: 8px; padding: 15px; margin-bottom: 25px; border-left: 4px solid var(--primary); }
        .summary-item { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 14px; }
        .summary-label { color: #6D7588; }
        .summary-value { font-weight: 700; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: 700; font-size: 14px; margin-bottom: 8px; color: #4A5568; }
        
        /* Select & Input Style */
        .form-control { width: 100%; padding: 12px; border: 2px solid #E5E7E9; border-radius: 8px; font-size: 14px; transition: 0.2s; outline: none; }
        .form-control:focus { border-color: var(--primary); }

        .btn-container { display: flex; gap: 12px; margin-top: 30px; }
        .btn { flex: 1; padding: 14px; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; transition: 0.2s; text-align: center; text-decoration: none; font-size: 14px; }
        
        .btn-submit { background: var(--primary); color: white; }
        .btn-submit:hover { background: #084d66; transform: translateY(-2px); }
        
        .btn-cancel { background: #E5E7E9; color: var(--text-dark); }
        .btn-cancel:hover { background: #D0D3D6; }

        .info-box { background: #EBF5F9; color: var(--primary); padding: 12px; border-radius: 8px; font-size: 13px; margin-top: 15px; display: flex; gap: 10px; align-items: center; }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <div class="logo-section" style="display: flex; align-items: center; gap: 8px;">
                <img src="${pageContext.request.contextPath}/uploads/seaamo.svg" alt="SeaAmo Logo" style="width:36px;">
                <span style="font-size: 18px; font-weight: 600; color: var(--primary);">SeaAmo</span>
            </div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="nav-link">Kembali ke Pesanan</a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <div class="card">
            <div class="card-header">
                <h2>Update Status Pengiriman</h2>
            </div>
            <div class="card-body">
                <div class="order-summary">
                    <div class="summary-item">
                        <span class="summary-label">ID Pesanan:</span>
                        <span class="summary-value">#${order.orderId}</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Pembeli:</span>
                        <span class="summary-value">${order.customerName}</span>
                    </div>
                </div>

                <form action="<%= request.getContextPath() %>/order" method="post">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="orderId" value="${order.orderId}">

                    <div class="form-group">
                        <label>Pilih Status Terbaru</label>
                        <select name="status" class="form-control" required>
                            <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>Sedang Diproses (Siapkan Produk)</option>
                            <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>Sedang Dikirim</option>
                            <option value="delivered" ${order.status == 'delivered' ? 'selected' : ''}>Selesai (Sudah Diterima)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Catatan / Nomor Resi (Opsional)</label>
                        <input type="text" name="trackingInfo" class="form-control" placeholder="Contoh: Kurir JNE - 12345XXX">
                    </div>

                    <div class="info-box">
                        <span>ℹ️</span>
                        <span>Perubahan status akan memberitahu pembeli melalui notifikasi aplikasi.</span>
                    </div>

                    <div class="btn-container">
                        <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="btn btn-cancel">Batal</a>
                        <button type="submit" class="btn btn-submit">Simpan Perubahan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>