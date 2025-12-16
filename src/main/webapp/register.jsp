<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrasi - SeaAmo</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Mengadopsi background dan font dari dashboard.jsp */
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: #FAFCFE; /* Background terang */
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            color: #1A1A1A; /* Warna teks utama gelap */
        }
        
        .register-container {
            width: 100%;
            max-width: 600px;
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo-section h1 {
            font-size: 3rem;
            color: #0A5F7F; /* Warna logo dari dashboard */
            text-shadow: none;
            margin-bottom: 10px;
        }
        
        .logo-section p {
            color: #4A5568; /* Warna teks pendukung */
            font-size: 1.1rem;
            text-shadow: none;
        }
        
        /* Register Card - Disesuaikan dengan gaya card dashboard */
        .register-card {
            background: white;
            border-radius: 16px; /* Sudut lebih lembut */
            border: 1px solid #E2E8F0; /* Border ringan */
            box-shadow: 0 4px 12px rgba(0,0,0,0.06); /* Shadow lembut */
            padding: 40px;
        }
        
        .card-title {
            color: #1A1A1A; /* Warna teks gelap */
            font-size: 2rem;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 700;
        }
        
        /* Alerts - Disesuaikan agar lebih menyatu dengan tema terang */
        .alert {
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            animation: slideDown 0.3s ease;
            font-weight: 600;
        }
        
        .alert-error {
            background: #FFF5F5;
            color: #C53030;
            border: 1px solid #FED7D7;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .form-group label {
            display: block;
            color: #4A5568; /* Warna label */
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .form-group label .required {
            color: #FF5E4D; /* Warna required agar lebih kontras */
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 18px;
            border: 2px solid #E2E8F0; /* Border dari dashboard */
            border-radius: 10px;
            background: #FFFFFF; /* Background input putih */
            color: #1A1A1A;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #A0AEC0;
        }
        
        .form-group select {
            cursor: pointer;
            /* Styling untuk panah select pada tema terang */
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background: #FFFFFF url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="%234A5568" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>') no-repeat right 12px center;
            background-size: 18px;
        }
        
        .form-group select option {
            background: white; /* Opsional: pastikan latar belakang option terang */
            color: #1A1A1A;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            background: #FFFFFF;
            border-color: #0A5F7F; /* Fokus dari dashboard */
            box-shadow: 0 0 0 3px rgba(10, 95, 127, 0.1);
        }
        
        /* Button Register - Disesuaikan dengan gaya button dashboard */
        .btn-register {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg, #0A5F7F, #0D7BA0); /* Gradient biru tua */
            color: white;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(10, 95, 127, 0.3);
            margin-top: 10px; /* Tambahkan sedikit margin atas */
        }
        
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(10, 95, 127, 0.4);
        }
        
        .btn-register:active {
            transform: translateY(0);
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #4A5568;
        }
        
        .login-link a {
            color: #0A5F7F; /* Warna link dari dashboard */
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .login-link a:hover {
            color: #084d66;
            text-shadow: none;
        }
        
        @media (max-width: 600px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="logo-section">
            <div style="
                text-align: center;
                margin-bottom: 8px;
            ">
                <img src="uploads/seaamo.svg" alt="SeaAmo Logo" style="
                    width: 80px;
                    margin-bottom: 2px;
                ">

                <h2 style="
                    margin: 0;
                    font-weight: 600;
                ">
                    SeaAmo
                </h2>
            </div>
            <p>Bergabunglah dengan Komunitas Kami</p>
        </div>
        
        <div class="register-card">
            <h2 class="card-title">Buat Akun Baru</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ${error}
                </div>
            </c:if>
            
            <form action="auth" method="post">
                <input type="hidden" name="action" value="register">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="username">Username <span class="required">*</span></label>
                        <input type="text" id="username" name="username" 
                                placeholder="Username"
                                value="${username}" required autofocus>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email <span class="required">*</span></label>
                        <input type="email" id="email" name="email" 
                                placeholder="email@example.com"
                                value="${email}" required>
                    </div>
                </div>
                
                <div class="form-group full-width">
                    <label for="fullName">Nama Lengkap <span class="required">*</span></label>
                    <input type="text" id="fullName" name="fullName" 
                            placeholder="Nama lengkap Anda"
                            value="${fullName}" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password <span class="required">*</span></label>
                        <input type="password" id="password" name="password" 
                                placeholder="Min. 6 karakter" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Konfirmasi Password <span class="required">*</span></label>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                                placeholder="Ulangi password" required>
                    </div>
                </div>
                
                <div class="form-group full-width">
                    <label for="phone">No. Telepon</label>
                    <input type="tel" id="phone" name="phone" 
                            placeholder="08xxxxxxxxxx"
                            value="${phone}">
                </div>
                
                <div class="form-group full-width">
                    <label for="address">Alamat</label>
                    <textarea id="address" name="address" 
                                placeholder="Alamat lengkap Anda">${address}</textarea>
                </div>
                
                <div class="form-group full-width">
                    <label for="role">Daftar sebagai <span class="required">*</span></label>
                    <select id="role" name="role" required>
                        <option value="">-- Pilih Role --</option>
                        <option value="customer" ${role == 'customer' ? 'selected' : ''}>Pembeli</option>
                        <option value="fisherman" ${role == 'fisherman' ? 'selected' : ''}>Nelayan/Penjual</option>
                    </select>
                </div>
                
                <button type="submit" class="btn-register">Daftar Sekarang</button>
            </form>
            
            <div class="login-link">
                Sudah punya akun? <a href="login.jsp">Login di sini</a>
            </div>
        </div>
    </div>
</body>
</html>