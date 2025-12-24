package controller;

import dao.UserDAO;
import dao.ProductDAO;
import dao.OrderDAO;
import model.User;
import model.Product;
import model.Order;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private UserDAO userDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
    }
    
    // Helper method untuk cek login admin
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // false = jangan buat session baru jika tidak ada
        if (session == null) return false;
        
        String role = (String) session.getAttribute("role");
        return "admin".equals(role);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // 1. Cek Admin Authorization
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "dashboard";
        
        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "users":
                manageUsers(request, response);
                break;
            case "products":
                manageProducts(request, response);
                break;
            case "orders":
                manageOrders(request, response);
                break;
            case "deleteUser":
                deleteUser(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek Admin Authorization
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            showDashboard(request, response);
            return;
        }
        
        switch (action) {
            case "updateUserStatus":
                updateUserStatus(request, response);
                break;
            case "updateProductStatus":
                updateProductStatus(request, response);
                break;
            case "updateOrderStatus":
                updateOrderStatus(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }
    
    // =========================================================================
    // LOGIC DELETE USER (PERBAIKAN UTAMA: REDIRECT PATH)
    // =========================================================================
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
        try {
            int userId = Integer.parseInt(request.getParameter("id"));

            // Cek agar tidak menghapus sesama admin
            User user = userDAO.getUserById(userId);
            if (user != null && "admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin?action=users&error=cannotDelete");
                return;
            }

            // Panggil Soft Delete di DAO
            boolean success = userDAO.deleteUser(userId);

            if (success) {
                // Redirect menggunakan getContextPath() agar TIDAK 404
                response.sendRedirect(request.getContextPath() + "/admin?action=users&success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?action=users&error=delete");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin?action=users&error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=users&error=system");
        }
    }

    // =========================================================================
    // METODE VIEW & UPDATE LAINNYA
    // =========================================================================
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> allUsers = userDAO.getAllUsers();
        List<Product> allProducts = productDAO.getAllProducts();
        List<Order> allOrders = orderDAO.getAllOrders();
        
        // Filter: Hitung total user aktif (tidak termasuk deleted)
        long activeUsers = allUsers.stream().filter(u -> !"deleted".equals(u.getStatus())).count();
        
        // Count by role
        int fishermanCount = 0;
        int customerCount = 0;
        int courierCount = 0;
        
        for (User user : allUsers) {
            if ("deleted".equals(user.getStatus())) continue; // Skip deleted users
            
            if ("fisherman".equals(user.getRole())) fishermanCount++;
            else if ("customer".equals(user.getRole())) customerCount++;
            else if ("courier".equals(user.getRole())) courierCount++;
        }
        
        // Count pending products
        int pendingProducts = 0;
        for (Product product : allProducts) {
            if ("pending".equals(product.getStatus())) pendingProducts++;
        }
        
        // Calculate revenue
        double totalRevenue = 0;
        for (Order order : allOrders) {
            if ("delivered".equals(order.getStatus())) totalRevenue += order.getTotalAmount();
        }
        
        request.setAttribute("totalUsers", activeUsers); // Update variabel ini
        request.setAttribute("totalProducts", allProducts.size());
        request.setAttribute("totalOrders", allOrders.size());
        request.setAttribute("fishermanCount", fishermanCount);
        request.setAttribute("customerCount", customerCount);
        request.setAttribute("courierCount", courierCount);
        request.setAttribute("pendingProducts", pendingProducts);
        request.setAttribute("totalRevenue", totalRevenue);
        
        // Safe sublist for recent orders
        int maxOrders = Math.min(10, allOrders.size());
        request.setAttribute("recentOrders", allOrders.subList(0, maxOrders));
        
        request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
    }
    
    private void manageUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roleFilter = request.getParameter("role");
        List<User> users;
        
        if (roleFilter != null && !roleFilter.isEmpty()) {
            users = userDAO.getUsersByRole(roleFilter);
        } else {
            users = userDAO.getAllUsers();
        }
        
        request.setAttribute("users", users);
        request.setAttribute("roleFilter", roleFilter);
        request.getRequestDispatcher("admin/users.jsp").forward(request, response);
    }
    
    private void manageProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        List<Product> products = productDAO.getAllProducts();
        
        if ("pending".equals(statusFilter)) {
            products.removeIf(p -> !"pending".equals(p.getStatus()));
        } else if (statusFilter != null && !statusFilter.isEmpty()) {
            products.removeIf(p -> !statusFilter.equals(p.getStatus()));
        }
        
        request.setAttribute("products", products);
        request.setAttribute("statusFilter", statusFilter);
        request.getRequestDispatcher("admin/products.jsp").forward(request, response);
    }
    
    private void manageOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
    }
    
    private void updateUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status");
            
            boolean success = userDAO.updateStatus(userId, status);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin?action=users&success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?action=users&error=update");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin?action=users&error=invalid");
        }
    }
    
    private void updateProductStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String status = request.getParameter("status");
            
            boolean success = productDAO.updateStatus(productId, status);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin?action=products&success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?action=products&error=update");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin?action=products&error=invalid");
        }
    }
    
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            boolean success = orderDAO.updateOrderStatus(orderId, status);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin?action=orders&success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?action=orders&error=update");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin?action=orders&error=invalid");
        }
    }
}