<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SeaAmo</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: #FAFCFE; 
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            color: #1A1A1A; 
        }
        
        .login-container {
            width: 100%;
            max-width: 450px;
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo-section h1 {
            font-size: 3rem;
            color: #0A5F7F; 
            text-shadow: none;
            margin-bottom: 10px;
        }
        
        .logo-section p {
            color: #4A5568; 
            font-size: 1.1rem;
            text-shadow: none;
        }
        
        .login-card {
            background: white;
            border-radius: 16px; 
            border: 1px solid #E2E8F0; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.06); 
            padding: 40px;
            transition: all 0.3s;
        }
        
        .card-title {
            color: #1A1A1A; 
            font-size: 2rem;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 700;
        }
        
        
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
        
        .alert-success {
            background: #F0FFF4;
            color: #2F855A;
            border: 1px solid #C6F6D5;
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
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            color: #4A5568; 
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 18px;
            border: 2px solid #E2E8F0; 
            border-radius: 10px;
            background: #FFFFFF; 
            color: #1A1A1A;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-group input::placeholder {
            color: #A0AEC0; 
        }
        
        .form-group input:focus {
            outline: none;
            background: #FFFFFF;
            border-color: #0A5F7F; 
            box-shadow: 0 0 0 3px rgba(10, 95, 127, 0.1);
        }
        
        /* Button Login - Disesuaikan dengan gaya button dashboard */
        .btn-login {
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
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(10, 95, 127, 0.4);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 25px 0;
        }
        
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #E2E8F0; /* Warna divider lebih terang */
        }
        
        .divider span {
            padding: 0 15px;
            color: #718096; /* Warna teks divider */
            font-size: 0.9rem;
        }
        
        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .register-link a {
            color: #0A5F7F; /* Warna link dari dashboard */
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .register-link a:hover {
            color: #084d66;
            text-shadow: none;
        }
        
        .footer-text {
            text-align: center;
            color: #A0AEC0; /* Warna footer lebih kalem */
            margin-top: 20px;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="login-container">
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

            <p>Marketplace Produk Laut Terpercaya</p>
        </div>
        
        <div class="login-card">
            <h2 class="card-title">Masuk ke Akun Anda</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ${success}
                </div>
            </c:if>
            
            <form action="auth" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" 
                            placeholder="Masukkan username Anda"
                            value="${username}" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" 
                            placeholder="Masukkan password Anda" required>
                </div>
                
                <button type="submit" class="btn-login">Masuk</button>
            </form>
            
            <div class="divider">
                <span>Belum punya akun?</span>
            </div>
            
            <div class="register-link">
                <a href="register.jsp">Daftar Sekarang →</a>
            </div>
        </div>
        
        <div class="footer-text">
            © 2025 SeaAmo. All rights reserved.
        </div>
    </div>
</body>
</html>