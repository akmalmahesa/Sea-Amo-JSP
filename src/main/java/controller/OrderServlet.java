package controller;

import dao.OrderDAO;
import dao.CartDAO;
import dao.ProductDAO;
import dao.PaymentDAO;
import model.Order;
import model.OrderItem;
import model.Cart;
import model.Product;
import model.PaymentRecord;
import service.NotificationService;
import java.io.IOException;
import java.util.List;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet({"/order", "/order/detail", "/order/cancel", "/order/track"})
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private ProductDAO productDAO;
    private PaymentDAO paymentDAO;
    private NotificationService notificationService;
    
    @Override
    public void init() throws ServletException {
        // Asumsi DAO dan Service sudah diinisialisasi
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
        paymentDAO = new PaymentDAO();
        notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Handle new routes
        if ("/order/detail".equals(path)) {
            showOrderDetail(request, response);
            return;
        } else if ("/order/track".equals(path)) {
            trackOrder(request, response);
            return;
        }
        
        // Handle old routes with action parameter
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "myOrders";
        }
        
        switch (action) {
            case "myOrders":
                viewMyOrders(request, response);
                break;
            case "view":
                // viewOrderDetail(request, response); // Deprecated, use /order/detail
                showOrderDetail(request, response);
                break;
            case "checkout":
                showCheckout(request, response);
                break;
            case "fishermanOrders":
                viewFishermanOrders(request, response);
                break;
            default:
                viewMyOrders(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Handle cancel order
        if ("/order/cancel".equals(path)) {
            cancelOrder(request, response);
            return;
        }
        
        // Handle old routes with action parameter
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "create";
        }
        
        switch (action) {
            case "create":
                createOrder(request, response);
                break;
            case "updateStatus":
                updateOrderStatus(request, response);
                break;
            default:
                viewMyOrders(request, response);
        }
    }
    
    // ===== NEW METHODS FOR ORDER DETAIL =====
    
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                request.setAttribute("error", "Pesanan tidak ditemukan");
                response.sendRedirect(request.getContextPath() + "/order?action=myOrders"); // Perbaikan: Redirect ke Servlet
                return;
            }
            
            // Check authorization based on role
            boolean hasAccess = false;
            
            if ("customer".equals(role) && order.getCustomerId() == userId) {
                hasAccess = true;
            } else if ("fisherman".equals(role)) {
                // Check if fisherman has products in this order
                List<OrderItem> items = orderDAO.getOrderItems(orderId);
                for (OrderItem item : items) {
                    // Asumsi OrderItem memiliki fishermanId
                    if (item.getFishermanId() == userId) { 
                        hasAccess = true;
                        break;
                    }
                }
            } else if ("admin".equals(role)) {
                hasAccess = true;
            }
            
            if (!hasAccess) {
                request.setAttribute("error", "Anda tidak memiliki akses ke pesanan ini");
                response.sendRedirect(request.getContextPath() + "/order?action=myOrders"); // Perbaikan: Redirect ke Servlet
                return;
            }
            
            // Get order items
            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);
            
            // Get payment info
            PaymentRecord payment = paymentDAO.getPaymentByOrderId(orderId);
            
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("payment", payment);
            
            request.getRequestDispatcher("/orderDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/order?action=myOrders"); // Perbaikan: Redirect ke Servlet
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Terjadi kesalahan: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/order?action=myOrders"); // Perbaikan: Redirect ke Servlet
        }
    }
    
    private void trackOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null || order.getCustomerId() != userId) {
                response.sendRedirect(request.getContextPath() + "/order?action=myOrders"); // Perbaikan: Redirect ke Servlet
                return;
            }
            
            request.setAttribute("order", order);
            request.getRequestDispatcher("/trackOrder.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/order?action=myOrders"); // Perbaikan: Redirect ke Servlet
        }
    }
    
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null || order.getCustomerId() != userId) {
                response.sendRedirect(request.getContextPath() + "/order?action=myOrders"); // Perbaikan: Redirect ke Servlet
                return;
            }
            
            // Only allow cancellation for certain statuses
            if ("pending".equals(order.getStatus()) || 
                ("processing".equals(order.getStatus()) && "unpaid".equals(order.getPaymentStatus()))) {
                
                orderDAO.updateOrderStatus(orderId, "cancelled");
                
                // Restore product stock
                List<OrderItem> items = orderDAO.getOrderItems(orderId);
                for (OrderItem item : items) {
                    productDAO.updateStock(item.getProductId(), item.getQuantity());
                }
                
                session.setAttribute("success", "Pesanan berhasil dibatalkan");
            } else {
                session.setAttribute("error", "Pesanan tidak dapat dibatalkan");
            }
            
            response.sendRedirect(request.getContextPath() + "/order/detail?orderId=" + orderId);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Terjadi kesalahan: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/order?action=myOrders"); // Perbaikan: Redirect ke Servlet
        }
    }
    
    // ===== EXISTING METHODS =====
    
    private void showCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Asumsi getCartByCustomer juga mengambil data Product untuk subtotal
        List<Cart> cartItems = cartDAO.getCartByCustomer(userId);
        
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }
        
        double totalAmount = 0;
        for (Cart item : cartItems) {
            totalAmount += item.calculateSubtotal();
        }
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }
    
    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String shippingAddress = request.getParameter("shippingAddress");
        
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order?action=checkout&error=address");
            return;
        }
        
        // Get cart items
        List<Cart> cartItems = cartDAO.getCartByCustomer(userId);
        
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }
        
        // Calculate total
        double totalAmount = 0;
        for (Cart item : cartItems) {
            totalAmount += item.calculateSubtotal();
        }
        
        // Create order
        Order order = new Order();
        order.setCustomerId(userId);
        order.setTotalAmount(totalAmount);
        order.setShippingAddress(shippingAddress);
        order.setStatus("pending");
        order.setPaymentStatus("unpaid");
        
        int orderId = orderDAO.createOrder(order);
        
        if (orderId > 0) {
            // Create order items
            Set<Integer> fishermanIds = new HashSet<>();
            
            for (Cart cartItem : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setProductId(cartItem.getProductId());
                // Asumsi getProduct().getFishermanId() tersedia di objek Cart
                orderItem.setFishermanId(cartItem.getProduct().getFishermanId()); 
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getProduct().getPrice());
                orderItem.setSubtotal(cartItem.calculateSubtotal());
                
                orderDAO.insertOrderItem(orderItem);
                
                // Update product stock
                productDAO.updateStock(cartItem.getProductId(), -cartItem.getQuantity());
                
                // Collect fisherman IDs
                fishermanIds.add(cartItem.getProduct().getFishermanId());
            }
            
            // Clear cart
            cartDAO.clearCart(userId);
            session.setAttribute("cartCount", 0);
            
            // Send notifications to fishermen
            for (Integer fishermanId : fishermanIds) {
                notificationService.notifyNewOrderToFisherman(fishermanId, orderId);
            }
            
            // Redirect to payment
            response.sendRedirect(request.getContextPath() + "/payment?orderId=" + orderId);
        } else {
            response.sendRedirect(request.getContextPath() + "/order?action=checkout&error=create");
        }
    }
    
    private void viewMyOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        List<Order> orders = orderDAO.getOrdersByCustomer(userId);
        request.setAttribute("orders", orders);
        
        // Karena myOrders.jsp ada di folder customer/
        request.getRequestDispatcher("/customer/myOrders.jsp").forward(request, response);
    }
    
    // viewOrderDetail yang lama (berdasarkan action=view)
    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Disarankan menggunakan showOrderDetail yang baru (/order/detail)
        showOrderDetail(request, response);
    }
    
    private void viewFishermanOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null || !"fisherman".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        List<Order> orders = orderDAO.getOrdersByFisherman(userId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/fisherman/orders.jsp").forward(request, response);
    }
    
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");
            
            Order order = orderDAO.getOrderById(orderId);
            String oldStatus = order.getStatus();
            
            boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
            
            if (success) {
                // Send notification
                notificationService.notifyOrderStatusChanged(order, oldStatus, newStatus);
                
                if ("fisherman".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/order?action=fishermanOrders&success=updated");
                } else if ("courier".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/courier?action=deliveries&success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/order?action=myOrders&success=updated");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/order?action=myOrders&error=update");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/order?action=myOrders&error=update");
        }
    }
}