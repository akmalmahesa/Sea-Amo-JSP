<!-- ============================================================================ -->
<!-- admin/users.jsp -->
<!-- ============================================================================ -->
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kelola Users - SeaAmo</title>
</head>
<body style="background: linear-gradient(135deg, #154D71 0%, #1C6EA4 100%); min-height: 100vh; font-family: 'Segoe UI';">
    <nav style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); padding: 15px 0;">
        <div style="max-width: 1400px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between;">
            <a href="../index.jsp" style="color: #FFF9AF; font-size: 1.8rem; text-decoration: none; font-weight: 700;">🌊 SeaAmo</a>
            <div style="display: flex; gap: 30px;">
                <a href="../admin" style="color: white; text-decoration: none;">Dashboard</a>
                <a href="../admin?action=users" style="color: #FFF9AF; text-decoration: none;">Users</a>
                <a href="../admin?action=products" style="color: white; text-decoration: none;">Produk</a>
                <a href="../admin?action=orders" style="color: white; text-decoration: none;">Pesanan</a>
                <a href="../auth?action=logout" style="color: white; text-decoration: none;">Logout</a>
            </div>
        </div>
    </nav>
    
    <div style="max-width: 1400px; margin: 30px auto; padding: 0 20px;">
        <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 30px; margin-bottom: 20px;">
            <h1 style="color: white; font-size: 2rem;">👥 Kelola Users</h1>
            <div style="margin-top: 15px; display: flex; gap: 10px;">
                <a href="../admin?action=users" style="padding: 8px 16px; background: ${empty roleFilter ? 'rgba(51,161,224,0.5)' : 'rgba(255,255,255,0.2)'}; color: white; text-decoration: none; border-radius: 8px;">Semua</a>
                <a href="../admin?action=users&role=customer" style="padding: 8px 16px; background: ${roleFilter == 'customer' ? 'rgba(51,161,224,0.5)' : 'rgba(255,255,255,0.2)'}; color: white; text-decoration: none; border-radius: 8px;">Customer</a>
                <a href="../admin?action=users&role=fisherman" style="padding: 8px 16px; background: ${roleFilter == 'fisherman' ? 'rgba(51,161,224,0.5)' : 'rgba(255,255,255,0.2)'}; color: white; text-decoration: none; border-radius: 8px;">Nelayan</a>
                <a href="../admin?action=users&role=courier" style="padding: 8px 16px; background: ${roleFilter == 'courier' ? 'rgba(51,161,224,0.5)' : 'rgba(255,255,255,0.2)'}; color: white; text-decoration: none; border-radius: 8px;">Kurir</a>
            </div>
        </div>
        
        <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(20px); border-radius: 15px; padding: 30px; overflow-x: auto;">
            <table style="width: 100%; color: white; border-collapse: collapse;">
                <thead>
                    <tr style="border-bottom: 2px solid rgba(255,255,255,0.3);">
                        <th style="padding: 15px; text-align: left;">Username</th>
                        <th style="padding: 15px; text-align: left;">Nama Lengkap</th>
                        <th style="padding: 15px; text-align: left;">Email</th>
                        <th style="padding: 15px; text-align: left;">Role</th>
                        <th style="padding: 15px; text-align: left;">Status</th>
                        <th style="padding: 15px; text-align: center;">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr style="border-bottom: 1px solid rgba(255,255,255,0.1);">
                            <td style="padding: 15px;">${user.username}</td>
                            <td style="padding: 15px;">${user.fullName}</td>
                            <td style="padding: 15px;">${user.email}</td>
                            <td style="padding: 15px;">
                                <span style="padding: 5px 10px; background: rgba(51,161,224,0.3); border-radius: 15px; font-size: 0.85rem;">
                                    ${user.displayRole}
                                </span>
                            </td>
                            <td style="padding: 15px;">
                                <span style="padding: 5px 10px; background: rgba(${user.status == 'active' ? '40,167,69' : '220,53,69'},0.3); border-radius: 15px; font-size: 0.85rem;">
                                    ${user.status}
                                </span>
                            </td>
                            <td style="padding: 15px; text-align: center;">
                                <c:if test="${user.role != 'admin'}">
                                    <form action="../admin" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="updateUserStatus">
                                        <input type="hidden" name="userId" value="${user.userId}">
                                        <input type="hidden" name="status" value="${user.status == 'active' ? 'inactive' : 'active'}">
                                        <button type="submit" style="padding: 6px 12px; border: none; background: rgba(255,193,7,0.5); color: white; border-radius: 6px; cursor: pointer; margin-right: 5px;">
                                            ${user.status == 'active' ? 'Nonaktifkan' : 'Aktifkan'}
                                        </button>
                                    </form>
                                    <a href="../admin?action=deleteUser&id=${user.userId}" onclick="return confirm('Hapus user ini?')" style="padding: 6px 12px; background: rgba(220,53,69,0.5); color: white; text-decoration: none; border-radius: 6px;">
                                        Hapus
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>