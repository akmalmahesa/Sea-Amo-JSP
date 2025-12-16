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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authorization
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "dashboard";
        }
        
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
        
        // Check admin authorization
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
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
    
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        return "admin".equals(role);
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get statistics
        List<User> allUsers = userDAO.getAllUsers();
        List<Product> allProducts = productDAO.getAllProducts();
        List<Order> allOrders = orderDAO.getAllOrders();
        
        int totalUsers = allUsers.size();
        int totalProducts = allProducts.size();
        int totalOrders = allOrders.size();
        
        // Count by role
        int fishermanCount = 0;
        int customerCount = 0;
        int courierCount = 0;
        
        for (User user : allUsers) {
            switch (user.getRole()) {
                case "fisherman":
                    fishermanCount++;
                    break;
                case "customer":
                    customerCount++;
                    break;
                case "courier":
                    courierCount++;
                    break;
            }
        }
        
        // Count pending products
        int pendingProducts = 0;
        for (Product product : allProducts) {
            if ("pending".equals(product.getStatus())) {
                pendingProducts++;
            }
        }
        
        // Calculate total revenue
        double totalRevenue = 0;
        for (Order order : allOrders) {
            if ("delivered".equals(order.getStatus())) {
                totalRevenue += order.getTotalAmount();
            }
        }
        
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("fishermanCount", fishermanCount);
        request.setAttribute("customerCount", customerCount);
        request.setAttribute("courierCount", courierCount);
        request.setAttribute("pendingProducts", pendingProducts);
        request.setAttribute("totalRevenue", totalRevenue);
        
        // Recent data
        request.setAttribute("recentOrders", allOrders.subList(0, Math.min(10, allOrders.size())));
        
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
        List<Product> products;
        
        if ("pending".equals(statusFilter)) {
            products = productDAO.getAllProducts();
            products.removeIf(p -> !"pending".equals(p.getStatus()));
        } else if (statusFilter != null && !statusFilter.isEmpty()) {
            products = productDAO.getAllProducts();
            products.removeIf(p -> !statusFilter.equals(p.getStatus()));
        } else {
            products = productDAO.getAllProducts();
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
                response.sendRedirect("admin?action=users&success=updated");
            } else {
                response.sendRedirect("admin?action=users&error=update");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("admin?action=users&error=invalid");
        }
    }
    
    private void updateProductStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String status = request.getParameter("status");
            
            boolean success = productDAO.updateStatus(productId, status);
            
            if (success) {
                response.sendRedirect("admin?action=products&success=updated");
            } else {
                response.sendRedirect("admin?action=products&error=update");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("admin?action=products&error=invalid");
        }
    }
    
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            boolean success = orderDAO.updateOrderStatus(orderId, status);
            
            if (success) {
                response.sendRedirect("admin?action=orders&success=updated");
            } else {
                response.sendRedirect("admin?action=orders&error=update");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("admin?action=orders&error=invalid");
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            
            // Don't allow deleting admin
            User user = userDAO.getUserById(userId);
            if (user != null && "admin".equals(user.getRole())) {
                response.sendRedirect("admin?action=users&error=cannotDelete");
                return;
            }
            
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                response.sendRedirect("admin?action=users&success=deleted");
            } else {
                response.sendRedirect("admin?action=users&error=delete");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("admin?action=users&error=invalid");
        }
    }
}