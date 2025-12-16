<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SeaAmo - Fresh Seafood Delivered Straight from the Ocean</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: #FAFCFE;
            color: #1A1A1A;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 80px;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: #0A5F7F;
            font-size: 28px;
            font-weight: 700;
        }
        
        .logo-icon {
            font-size: 36px;
        }
        
        .nav-menu {
            display: flex;
            gap: 40px;
            list-style: none;
        }
        
        .nav-menu a {
            color: #4A5568;
            text-decoration: none;
            font-weight: 500;
            font-size: 15px;
            transition: color 0.3s;
        }
        
        .nav-menu a:hover {
            color: #0A5F7F;
        }
        
        .nav-actions {
            display: flex;
            gap: 24px;
            align-items: center;
        }
        
        .nav-icon {
            font-size: 22px;
            color: #4A5568;
            cursor: pointer;
            transition: color 0.3s;
        }
        
        .nav-icon:hover {
            color: #0A5F7F;
        }
        
        .btn-login {
            padding: 10px 24px;
            background: #0A5F7F;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-login:hover {
            background: #084d66;
            transform: translateY(-1px);
        }
        
        .hero {
            background: linear-gradient(135deg, #E3F4F9 0%, #D4EEF7 100%);
            padding: 80px 40px 100px;
            position: relative;
            overflow: hidden;
        }
        
        .hero::before {
            position: absolute;
            font-size: 400px;
            opacity: 0.05;
            right: -100px;
            top: -100px;
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        
        .hero-container {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }
        
        .hero-content h1 {
            font-size: 56px;
            color: #0A5F7F;
            line-height: 1.2;
            margin-bottom: 24px;
            font-weight: 800;
        }
        
        .hero-content p {
            font-size: 20px;
            color: #4A5568;
            line-height: 1.6;
            margin-bottom: 40px;
        }
        
        .hero-features {
            display: flex;
            gap: 32px;
            margin-bottom: 40px;
        }
        
        .hero-feature {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .hero-feature-icon {
            font-size: 28px;
        }
        
        .hero-feature-text {
            font-size: 14px;
            color: #4A5568;
            font-weight: 600;
        }
        
        .btn-primary {
            padding: 18px 48px;
            background: linear-gradient(135deg, #FF7A6B 0%, #FF5E4D 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            box-shadow: 0 8px 24px rgba(255, 94, 77, 0.3);
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(255, 94, 77, 0.4);
        }
        
        .hero-image {
            position: relative;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .hero-product {
            background: white;
            border-radius: 20px;
            padding: 20px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .hero-product:hover {
            transform: translateY(-8px);
        }
        
        .hero-product-icon {
            font-size: 80px;
            margin-bottom: 12px;
        }
        
        .hero-product-name {
            font-size: 16px;
            font-weight: 600;
            color: #1A1A1A;
        }
        
        /* Categories */
        .categories {
            padding: 80px 40px;
            background: white;
        }
        
        .section-header {
            text-align: center;
            max-width: 700px;
            margin: 0 auto 60px;
        }
        
        .section-header h2 {
            font-size: 40px;
            color: #0A5F7F;
            margin-bottom: 16px;
            font-weight: 700;
        }
        
        .section-header p {
            font-size: 18px;
            color: #718096;
        }
        
        .category-grid {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 24px;
        }
        
        .category-card {
            background: #F7FAFC;
            border-radius: 16px;
            padding: 32px 24px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        
        .category-card:hover {
            background: white;
            border-color: #0A5F7F;
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(10, 95, 127, 0.12);
        }
        
        .category-icon {
            font-size: 64px;
            margin-bottom: 16px;
        }
        
        .category-name {
            font-size: 16px;
            font-weight: 600;
            color: #2D3748;
        }
        
        /* Feature Banner */
        .feature-banner {
            padding: 0 40px 80px;
            background: white;
        }
        
        .banner-container {
            max-width: 1400px;
            margin: 0 auto;
            background: linear-gradient(135deg, #0A5F7F 0%, #0D7BA0 100%);
            border-radius: 24px;
            padding: 60px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .banner-container::before {
            content: '🦀';
            position: absolute;
            font-size: 300px;
            opacity: 0.1;
            right: -50px;
            top: -50px;
        }
        
        .banner-content h3 {
            font-size: 36px;
            color: white;
            margin-bottom: 20px;
            font-weight: 700;
        }
        
        .banner-content p {
            font-size: 18px;
            color: rgba(255,255,255,0.9);
            margin-bottom: 32px;
            line-height: 1.6;
        }
        
        .banner-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 32px;
        }
        
        .badge {
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            padding: 10px 20px;
            border-radius: 24px;
            color: white;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-secondary {
            padding: 14px 36px;
            background: white;
            color: #0A5F7F;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        
        .banner-image {
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 200px;
        }
        
        /* Stats */
        .stats {
            padding: 80px 40px;
            background: #F7FAFC;
        }
        
        .stats-container {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 40px;
        }
        
        .stat-card {
            text-align: center;
        }
        
        .stat-number {
            font-size: 48px;
            font-weight: 800;
            color: #0A5F7F;
            margin-bottom: 8px;
        }
        
        .stat-label {
            font-size: 16px;
            color: #718096;
            font-weight: 500;
        }
        
        /* CTA */
        .cta {
            padding: 100px 40px;
            background: linear-gradient(135deg, #E3F4F9 0%, #D4EEF7 100%);
            text-align: center;
        }
        
        .cta h2 {
            font-size: 48px;
            color: #0A5F7F;
            margin-bottom: 24px;
            font-weight: 700;
        }
        
        .cta p {
            font-size: 20px;
            color: #4A5568;
            margin-bottom: 40px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .cta-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
        }
        
        /* Footer */
        .footer {
            background: #1A202C;
            color: white;
            padding: 60px 40px 30px;
        }
        
        .footer-container {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 60px;
            margin-bottom: 40px;
        }
        
        .footer-section h4 {
            font-size: 18px;
            margin-bottom: 20px;
            font-weight: 700;
        }
        
        .footer-section ul {
            list-style: none;
        }
        
        .footer-section ul li {
            margin-bottom: 12px;
        }
        
        .footer-section a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .footer-section a:hover {
            color: white;
        }
        
        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.6);
        }
        
        @media (max-width: 768px) {
            .hero-container {
                grid-template-columns: 1fr;
            }
            
            .hero-content h1 {
                font-size: 36px;
            }
            
            .category-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .banner-container {
                grid-template-columns: 1fr;
            }
            
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .footer-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
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
            
            <ul class="nav-menu">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="product?action=list">Shop</a></li>
                <li><a href="#categories">Categories</a></li>
                <li><a href="#about">About Us</a></li>
                <li><a href="#contact">Contact</a></li>
            </ul>
            
            <div class="nav-actions">
                <span class="nav-icon">🔍</span>
                <span class="nav-icon">🛒</span>
                <a href="login.jsp" class="btn-login">Login</a>
            </div>
        </div>
    </nav>
    
    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-container">
            <div class="hero-content">
                <h1>Fresh Seafood Delivered Straight from the Ocean</h1>
                <p>Experience the finest selection of sustainable seafood, delivered fresh from local fishermen to your doorstep. Quality you can taste, freshness you can trust.</p>
                
                <div class="hero-features">
                    <div class="hero-feature">
                        <span class="hero-feature-icon">✨</span>
                        <span class="hero-feature-text">Daily Fresh</span>
                    </div>
                    <div class="hero-feature">
                        <span class="hero-feature-icon">🌱</span>
                        <span class="hero-feature-text">Sustainable</span>
                    </div>
                    <div class="hero-feature">
                        <span class="hero-feature-icon">🚚</span>
                        <span class="hero-feature-text">Fast Delivery</span>
                    </div>
                </div>
                
                <a href="product?action=list" class="btn-primary">Shop Fresh Seafood</a>
            </div>
            
            <div class="hero-image">
                <div class="hero-product">
                    <div class="hero-product-icon">🐟</div>
                    <div class="hero-product-name">Fresh Salmon</div>
                </div>
                <div class="hero-product">
                    <div class="hero-product-icon">🦐</div>
                    <div class="hero-product-name">Premium Shrimp</div>
                </div>
                <div class="hero-product">
                    <div class="hero-product-icon">🦀</div>
                    <div class="hero-product-name">King Crab</div>
                </div>
                <div class="hero-product">
                    <div class="hero-product-icon">🐠</div>
                    <div class="hero-product-name">Fresh Tuna</div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Categories -->
    <section class="categories" id="categories">
        <div class="section-header">
            <h2>Browse by Category</h2>
            <p>Explore our premium selection of fresh seafood from local fishermen</p>
        </div>
        
        <div class="category-grid">
            <div class="category-card" onclick="window.location='product?action=list&category=Ikan Laut'">
                <div class="category-icon">🐟</div>
                <div class="category-name">Fish</div>
            </div>
            <div class="category-card" onclick="window.location='product?action=list&category=Udang'">
                <div class="category-icon">🦐</div>
                <div class="category-name">Shrimp</div>
            </div>
            <div class="category-card" onclick="window.location='product?action=list&category=Kerang'">
                <div class="category-icon">🦀</div>
                <div class="category-name">Crab & Lobster</div>
            </div>
            <div class="category-card" onclick="window.location='product?action=list'">
                <div class="category-icon">🐚</div>
                <div class="category-name">Shellfish</div>
            </div>
            <div class="category-card" onclick="window.location='product?action=list'">
                <div class="category-icon">❄️</div>
                <div class="category-name">Frozen Seafood</div>
            </div>
            <div class="category-card" onclick="window.location='product?action=list'">
                <div class="category-icon">📦</div>
                <div class="category-name">Packages</div>
            </div>
        </div>
    </section>
    
    <!-- Feature Banner -->
    <section class="feature-banner">
        <div class="banner-container">
            <div class="banner-content">
                <h3>Enhance Your Seafood Experience</h3>
                <p>Discover premium quality seafood delivered with care. Our cold chain delivery ensures maximum freshness from ocean to table.</p>
                
                <div class="banner-badges">
                    <span class="badge">✨ Fresh Daily</span>
                    <span class="badge">❄️ Cold Chain Delivery</span>
                    <span class="badge">🌱 Sustainable Catch</span>
                </div>
                
                <a href="product?action=list" class="btn-secondary">Discover Now</a>
            </div>
            
            <div class="banner-image">
                🐠
            </div>
        </div>
    </section>
    
    <!-- Stats -->
    <section class="stats">
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-number">100+</div>
                <div class="stat-label">Local Fishermen</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">500+</div>
                <div class="stat-label">Fresh Products</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">5000+</div>
                <div class="stat-label">Happy Customers</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">24/7</div>
                <div class="stat-label">Customer Support</div>
            </div>
        </div>
    </section>
    
    <!-- CTA -->
    <section class="cta">
        <h2>Ready to Get Started?</h2>
        <p>Join thousands of satisfied customers enjoying the freshest seafood delivered straight to their door</p>
        
        <div class="cta-buttons">
            <a href="register.jsp?role=customer" class="btn-primary">Shop as Customer</a>
            <a href="register.jsp?role=fisherman" class="btn-secondary">Join as Fisherman</a>
        </div>
    </section>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-section">
                <h4>🌊 SeaAmo</h4>
                <p style="color: rgba(255,255,255,0.7); line-height: 1.6;">Fresh seafood marketplace connecting local fishermen with customers nationwide.</p>
            </div>
            
            <div class="footer-section">
                <h4>Shop</h4>
                <ul>
                    <li><a href="product?action=list">All Products</a></li>
                    <li><a href="#">Categories</a></li>
                    <li><a href="#">Special Offers</a></li>
                    <li><a href="#">New Arrivals</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Company</h4>
                <ul>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Our Fishermen</a></li>
                    <li><a href="#">Sustainability</a></li>
                    <li><a href="#">Careers</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Support</h4>
                <ul>
                    <li><a href="#">Help Center</a></li>
                    <li><a href="#">Shipping Info</a></li>
                    <li><a href="#">Returns</a></li>
                    <li><a href="#">Contact Us</a></li>
                </ul>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; 2024 SeaAmo. All rights reserved. | Fresh Seafood Marketplace Indonesia 🇮🇩</p>
        </div>
    </footer>
</body>
</html>