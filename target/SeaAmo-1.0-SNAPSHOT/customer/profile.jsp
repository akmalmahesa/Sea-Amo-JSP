<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String contextPath = request.getContextPath();
    if (session.getAttribute("user") == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Saya - SeaAmo</title>
    <style>
        :root { --primary: #0A5F7F; --bg-gray: #F0F3F7; --white: #FFFFFF; --text-dark: #212121; }
        body { margin: 0; font-family: 'Open Sans', sans-serif; background: var(--bg-gray); padding-top: 80px; }
        
        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: 0 1px 6px 0 rgba(49,53,59,0.12); padding: 0 20px; }
        .nav-container { max-width: 1000px; margin: 0 auto; width: 100%; display: flex; align-items: center; gap: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); text-decoration: none; }
        
        .container { max-width: 1000px; margin: 24px auto; padding: 0 16px; display: flex; gap: 24px; }
     
        .profile-sidebar { width: 300px; flex-shrink: 0; }
        .profile-card { background: white; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); padding: 24px; text-align: center; }
        .avatar-lg { width: 100px; height: 100px; background: var(--primary); color: white; font-size: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; }
        .user-fullname { font-size: 18px; font-weight: 700; margin-bottom: 4px; }
        .user-email { color: #6D7588; font-size: 14px; margin-bottom: 20px; }
        
        .profile-content { flex: 1; display: flex; flex-direction: column; gap: 20px; }
        .content-card { background: white; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.1); padding: 24px; }
        .card-title { font-size: 18px; font-weight: 700; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 1px solid #F0F0F0; }
        
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; font-weight: 700; margin-bottom: 8px; color: #6D7588; }
        .form-input { width: 100%; padding: 10px 12px; border: 1px solid #E5E7E9; border-radius: 8px; font-size: 14px; transition: 0.2s; }
        .form-input:focus { border-color: var(--primary); outline: none; }
        textarea.form-input { resize: vertical; min-height: 80px; }
        
        .btn { padding: 12px 24px; border-radius: 8px; font-weight: 700; font-size: 14px; cursor: pointer; border: none; width: 100%; }
        .btn-save { background: var(--primary); color: white; }
        .btn-save:hover { background: #084d66; }
        
        .alert { padding: 12px; border-radius: 6px; margin-bottom: 16px; font-size: 14px; }
        .alert-success { background: #E5F9F6; color: #00A79D; }

        @media (max-width: 768px) {
            .container { flex-direction: column; }
            .profile-sidebar { width: 100%; }
            .form-row { grid-template-columns: 1fr; }
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
            <a href="<%= contextPath %>/customer/dashboard.jsp" style="text-decoration: none; font-weight: 600; color: #212121;">Kembali</a>
        </div>
    </nav>

    <div class="container">
        <div class="profile-sidebar">
            <div class="profile-card">
                <div class="avatar-lg">${sessionScope.user.fullName.substring(0,1).toUpperCase()}</div>
                <div class="user-fullname">${sessionScope.user.fullName}</div>
                <div class="user-email">${sessionScope.user.email}</div>
                <a href="<%= contextPath %>/auth?action=logout" style="display: block; margin-top: 16px; padding: 8px; border: 1px solid #E5E7E9; border-radius: 8px; text-decoration: none; color: #FF5E4D; font-weight: 600;">Keluar</a>
            </div>
        </div>

        <div class="profile-content">
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <div class="content-card">
                <h3 class="card-title">Ubah Biodata Diri</h3>
                <form action="<%= contextPath %>/profile" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    
                    <div class="form-group">
                        <label>Nama Lengkap</label>
                        <input type="text" name="fullName" class="form-input" value="${user.fullName}" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-input" value="${user.email}" required>
                        </div>
                        <div class="form-group">
                            <label>Nomor HP</label>
                            <input type="tel" name="phone" class="form-input" value="${user.phone}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Alamat Pengiriman</label>
                        <textarea name="address" class="form-input">${user.address}</textarea>
                    </div>

                    <button type="submit" class="btn btn-save">Simpan Biodata</button>
                </form>
            </div>

            <div class="content-card">
                <h3 class="card-title">Ganti Kata Sandi</h3>
                <form action="<%= contextPath %>/profile" method="post">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="form-group">
                        <label>Kata Sandi Lama</label>
                        <input type="password" name="currentPassword" class="form-input" required>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Kata Sandi Baru</label>
                            <input type="password" name="newPassword" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label>Konfirmasi Kata Sandi</label>
                            <input type="password" name="confirmPassword" class="form-input" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-save" style="background-color: #6D7588;">Ubah Password</button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>