<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kelola Users - SeaAmo</title>
    <style>
        :root {
            --primary: #0A5F7F;
            --bg-gray: #F0F3F7;
            --white: #FFFFFF;
            --text-dark: #212121;
            --text-gray: #6D7588;
            --shadow-sm: 0 1px 6px 0 rgba(49,53,59,0.12);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Open Sans', sans-serif; }
        body { background-color: var(--bg-gray); color: var(--text-dark); padding-top: 80px; }
        a { text-decoration: none; color: inherit; }

        .navbar { background: var(--white); height: 70px; display: flex; align-items: center; position: fixed; top: 0; width: 100%; z-index: 999; box-shadow: var(--shadow-sm); padding: 0 20px; }
        .nav-container { max-width: 1200px; margin: 0 auto; width: 100%; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: 800; color: var(--primary); display: flex; align-items: center; gap: 8px; }
        .nav-links { display: flex; gap: 32px; }
        .nav-link { color: var(--text-gray); font-weight: 600; font-size: 14px; transition: 0.2s; }
        .nav-link:hover, .nav-link.active { color: var(--primary); }
        .nav-link.logout { color: #FF5E4D; }

        .main-container { max-width: 1200px; margin: 24px auto; padding: 0 20px; }
        
        .header-card { background: var(--white); border-radius: 12px; padding: 24px; box-shadow: var(--shadow-sm); margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-size: 24px; font-weight: 700; }
        
        .filter-group { display: flex; gap: 10px; }
        .filter-btn { padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; border: 1px solid #E5E7E9; background: white; color: var(--text-gray); cursor: pointer; transition: 0.2s; }
        .filter-btn:hover { border-color: var(--primary); color: var(--primary); }
        .filter-btn.active { background: var(--primary); color: white; border-color: var(--primary); }

        .alert { padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; font-size: 14px; }
        .alert-success { background: #E6F4EA; color: #1E8E3E; border: 1px solid #CEEAD6; }
        .alert-error { background: #FCE8E6; color: #C5221F; border: 1px solid #FAD2CF; }

        .table-card { background: var(--white); border-radius: 12px; box-shadow: var(--shadow-sm); padding: 20px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 16px; border-bottom: 2px solid #F0F3F7; color: var(--text-gray); font-size: 13px; font-weight: 700; text-transform: uppercase; }
        td { padding: 16px; border-bottom: 1px solid #F0F3F7; font-size: 14px; color: var(--text-dark); vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #FAFAFA; }

        .role-badge { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; background: #EBF5F9; color: var(--primary); }
        .status-active { color: #1E8E3E; font-weight: 600; }
        .status-inactive { color: #D93025; font-weight: 600; }

        .btn-sm { padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; border: none; cursor: pointer; text-decoration: none; display: inline-block; transition: 0.2s; }
        .btn-toggle { background: #FEF7E0; color: #B25E09; }
        .btn-toggle:hover { background: #FEEFC3; }
        .btn-delete { background: #FCE8E6; color: #C5221F; }
        .btn-delete:hover { background: #FAD2CF; }
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
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
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
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/admin" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin?action=users" class="nav-link active">Users</a>
                <a href="${pageContext.request.contextPath}/admin?action=products" class="nav-link">Produk</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="nav-link logout">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="main-container">
        <div class="header-card">
            <h1 class="page-title">👥 Kelola Users</h1>
            <div class="filter-group">
                <a href="${pageContext.request.contextPath}/admin?action=users" 
                   class="filter-btn ${empty roleFilter ? 'active' : ''}">Semua</a>
                <a href="${pageContext.request.contextPath}/admin?action=users&role=customer" 
                   class="filter-btn ${roleFilter == 'customer' ? 'active' : ''}">Customer</a>
                <a href="${pageContext.request.contextPath}/admin?action=users&role=fisherman" 
                   class="filter-btn ${roleFilter == 'fisherman' ? 'active' : ''}">Nelayan</a>
                <a href="${pageContext.request.contextPath}/admin?action=users&role=courier" 
                   class="filter-btn ${roleFilter == 'courier' ? 'active' : ''}">Kurir</a>
            </div>
        </div>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">Berhasil: ${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">Error: ${param.error}</div>
        </c:if>
        
        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Nama Lengkap</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th style="text-align: center;">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <c:if test="${user.status != 'deleted'}">
                            <tr>
                                <td><strong>${user.username}</strong></td>
                                <td>${user.fullName}</td>
                                <td>${user.email}</td>
                                <td><span class="role-badge">${user.displayRole}</span></td>
                                <td>
                                    <span class="${user.status == 'active' ? 'status-active' : 'status-inactive'}">
                                        ● ${user.status}
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <c:if test="${user.role != 'admin'}">
                                        <form action="${pageContext.request.contextPath}/admin" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="updateUserStatus">
                                            <input type="hidden" name="userId" value="${user.userId}">
                                            <input type="hidden" name="status" value="${user.status == 'active' ? 'inactive' : 'active'}">
                                            <button type="submit" class="btn-sm btn-toggle">
                                                ${user.status == 'active' ? 'Nonaktifkan' : 'Aktifkan'}
                                            </button>
                                        </form>
                                        
                                        <a href="${pageContext.request.contextPath}/admin?action=deleteUser&id=${user.userId}" 
                                           onclick="return confirm('Yakin ingin menghapus user ini?')" 
                                           class="btn-sm btn-delete">
                                           Hapus
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>