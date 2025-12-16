<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Produk - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        body { background: var(--bg-gray); padding-top: 80px; font-family: 'Open Sans', sans-serif; color: var(--text-dark); }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 800px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .nav-links { display: flex; gap: 32px; }
        .nav-link { text-decoration: none; color: #6D7588; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .nav-link:hover { color: var(--primary); }

        .main-container { max-width: 800px; margin: 30px auto; padding: 0 20px; }
        .form-card { background: var(--white); padding: 32px; border-radius: 12px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); }
        .form-title { font-size: 24px; font-weight: 700; margin-bottom: 24px; border-bottom: 1px solid #F0F3F7; padding-bottom: 16px; }
        
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-weight: 600; font-size: 14px; margin-bottom: 8px; color: #4A5568; }
        .form-input, .form-select, .form-textarea { width: 100%; padding: 12px; border: 1px solid #E5E7E9; border-radius: 8px; font-family: inherit; font-size: 14px; transition: 0.2s; }
        .form-input:focus, .form-select:focus, .form-textarea:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(10, 95, 127, 0.1); }
        
        .row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        
        .img-type-group { display: flex; gap: 20px; margin-bottom: 10px; }
        .radio-label { display: flex; align-items: center; gap: 8px; font-size: 14px; cursor: pointer; }
        
        .current-img-box { margin-bottom: 15px; text-align: center; background: #f9f9f9; padding: 10px; border-radius: 8px; border: 1px dashed #ddd; }
        .current-img { max-height: 150px; border-radius: 6px; }
        
        .img-preview { width: 100px; height: 100px; border-radius: 8px; background: #eee; margin-top: 10px; object-fit: cover; display: none; border: 1px solid #ddd; }

        .btn-submit { width: 100%; padding: 14px; background: var(--primary); color: white; border: none; border-radius: 8px; font-weight: 700; font-size: 16px; cursor: pointer; transition: 0.2s; margin-top: 10px; }
        .btn-submit:hover { background: #084d66; }
        .btn-cancel { display: block; text-align: center; margin-top: 16px; color: #666; text-decoration: none; font-size: 14px; font-weight: 600; }
        
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
                <a href="<%= request.getContextPath() %>/product?action=myProducts" class="nav-link">Produk Saya</a>
                <a href="<%= request.getContextPath() %>/order?action=fishermanOrders" class="nav-link">Pesanan Masuk</a>
                <a href="<%= request.getContextPath() %>/fisherman/profile.jsp" class="nav-link">Profil</a>
                <a href="<%= request.getContextPath() %>/auth?action=logout" class="nav-link" style="color: #FF5E4D;">Keluar</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="form-card">
            <h1 class="form-title">✏️ Edit Produk</h1>
            
            <form action="<%= request.getContextPath() %>/product" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update"> 
                <input type="hidden" name="productId" value="${product.productId}">
                
                <div class="form-group">
                    <label class="form-label">Nama Produk</label>
                    <input type="text" name="productName" class="form-input" value="${product.productName}" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Kategori</label>
                    <select name="category" class="form-select" required>
                        <option value="">Pilih Kategori...</option>
                        <option value="Ikan Laut" ${product.category == 'Ikan Laut' ? 'selected' : ''}>Ikan Laut</option>
                        <option value="Ikan Air Tawar" ${product.category == 'Ikan Air Tawar' ? 'selected' : ''}>Ikan Air Tawar</option>
                        <option value="Udang" ${product.category == 'Udang' ? 'selected' : ''}>Udang</option>
                        <option value="Cumi" ${product.category == 'Cumi' ? 'selected' : ''}>Cumi</option>
                        <option value="Kerang" ${product.category == 'Kerang' ? 'selected' : ''}>Kerang</option>
                        <option value="Lainnya" ${product.category == 'Lainnya' ? 'selected' : ''}>Lainnya</option>
                    </select>
                </div>
                
                <div class="row">
                    <div class="form-group">
                        <label class="form-label">Harga per Kg (Rp)</label>
                        <input type="number" name="price" class="form-input" value="${product.price}" min="1000" step="500" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Stok Tersedia (Kg)</label>
                        <input type="number" name="stock" class="form-input" value="${product.stock}" min="1" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Deskripsi Produk</label>
                    <textarea name="description" class="form-textarea" rows="4" required>${product.description}</textarea>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Foto Produk</label>
                    
                    <div class="current-img-box">
                        <p style="font-size: 12px; color: #666; margin-bottom: 5px;">Foto Saat Ini:</p>
                        <c:choose>
                            <c:when test="${not empty product.imageUrl && fn:startsWith(product.imageUrl, 'http')}">
                                <img src="${product.imageUrl}" class="current-img" alt="Foto Lama">
                            </c:when>
                            <c:when test="${not empty product.imageUrl}">
                                <img src="<%= request.getContextPath() %>/${product.imageUrl}" class="current-img" alt="Foto Lama">
                            </c:when>
                            <c:otherwise>
                                <span style="font-size: 30px;">🐟</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="img-type-group">
                        <label class="radio-label">
                            <input type="radio" name="imgMethod" value="file" checked onchange="toggleImageInput()"> 
                            Upload File Baru
                        </label>
                        <label class="radio-label">
                            <input type="radio" name="imgMethod" value="url" onchange="toggleImageInput()"> 
                            Gunakan URL Baru
                        </label>
                    </div>

                    <div id="fileInputSection">
                        <input type="file" name="image" class="form-input" accept="image/*" onchange="previewFile(this)">
                    </div>

                    <div id="urlInputSection" style="display: none;">
                        <c:set var="urlValue" value="" />
                        <c:if test="${not empty product.imageUrl && fn:startsWith(product.imageUrl, 'http')}">
                            <c:set var="urlValue" value="${product.imageUrl}" />
                        </c:if>
                        <input type="url" name="imageUrlInput" class="form-input" value="${urlValue}" placeholder="https://example.com/gambar-ikan.jpg" oninput="previewUrl(this.value)">
                    </div>
                    
                    <p style="font-size: 12px; color: #999; margin-top: 5px;">*Biarkan kosong jika tidak ingin mengubah foto.</p>

                    <img id="imagePreview" class="img-preview" alt="Preview Gambar Baru">
                </div>
                
                <button type="submit" class="btn-submit">Simpan Perubahan</button>
                <a href="<%= request.getContextPath() %>/product?action=myProducts" class="btn-cancel">Batal</a>
            </form>
        </div>
    </div>

    <script>
        function toggleImageInput() {
            const method = document.querySelector('input[name="imgMethod"]:checked').value;
            const fileSection = document.getElementById('fileInputSection');
            const urlSection = document.getElementById('urlInputSection');
            const preview = document.getElementById('imagePreview');

            if (method === 'file') {
                fileSection.style.display = 'block';
                urlSection.style.display = 'none';
                // Kosongkan URL agar tidak menimpa jika user berubah pikiran
                urlSection.querySelector('input').value = '';
            } else {
                fileSection.style.display = 'none';
                urlSection.style.display = 'block';
                // Kosongkan File
                fileSection.querySelector('input').value = '';
            }
            preview.style.display = 'none';
            preview.src = '#';
        }

        function previewUrl(url) {
            const preview = document.getElementById('imagePreview');
            if (url) {
                preview.src = url;
                preview.style.display = 'block';
                preview.onerror = function() { this.style.display = 'none'; }
            } else {
                preview.style.display = 'none';
            }
        }

        function previewFile(input) {
            const preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>

</body>
</html>