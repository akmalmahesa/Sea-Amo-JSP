package controller;

import dao.OrderDAO;
import model.Order;
import service.NotificationService;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/courier")
public class CourierServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private NotificationService notificationService;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "dashboard";
        }
        
        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "deliveries":
                viewDeliveries(request, response);
                break;
            case "assign":
                assignDelivery(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            updateDeliveryStatus(request, response);
        } else if ("assign".equals(action)) {
            assignDelivery(request, response);
        } else {
            showDashboard(request, response);
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null || !"courier".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get statistics
        List<Order> myDeliveries = orderDAO.getOrdersByCourier(userId);
        
        int activeDeliveries = 0;
        int completedDeliveries = 0;
        
        for (Order order : myDeliveries) {
            if ("shipped".equals(order.getStatus())) {
                activeDeliveries++;
            } else if ("delivered".equals(order.getStatus())) {
                completedDeliveries++;
            }
        }
        
        request.setAttribute("activeDeliveries", activeDeliveries);
        request.setAttribute("completedDeliveries", completedDeliveries);
        request.setAttribute("totalDeliveries", myDeliveries.size());
        request.setAttribute("recentDeliveries", myDeliveries.subList(0, Math.min(5, myDeliveries.size())));
        
        request.getRequestDispatcher("courier/dashboard.jsp").forward(request, response);
    }
    
    private void viewDeliveries(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null || !"courier".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<Order> deliveries = orderDAO.getOrdersByCourier(userId);
        request.setAttribute("deliveries", deliveries);
        
        request.getRequestDispatcher("courier/deliveries.jsp").forward(request, response);
    }
    
    private void assignDelivery(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null || !"courier".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            
            // Assign courier to order
            boolean success = orderDAO.assignCourier(orderId, userId);
            
            if (success) {
                // Update order status to shipped
                orderDAO.updateOrderStatus(orderId, "shipped");
                
                // Get order details
                Order order = orderDAO.getOrderById(orderId);
                
                // Send notification to customer
                notificationService.notifyShippingUpdate(
                    order.getCustomerId(), 
                    orderId, 
                    "Pesanan Anda sedang dalam pengiriman"
                );
                
                response.sendRedirect("courier?action=deliveries&success=assigned");
            } else {
                response.sendRedirect("courier?action=deliveries&error=assign");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("courier?action=deliveries&error=invalid");
        }
    }
    
    private void updateDeliveryStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null || !"courier".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            Order order = orderDAO.getOrderById(orderId);
            
            // Verify this order is assigned to this courier
            if (order == null || order.getCourierId() == null || order.getCourierId() != userId) {
                response.sendRedirect("courier?action=deliveries&error=unauthorized");
                return;
            }
            
            String oldStatus = order.getStatus();
            boolean success = orderDAO.updateOrderStatus(orderId, status);
            
            if (success) {
                // Send notification to customer
                String message;
                if ("delivered".equals(status)) {
                    message = "Pesanan Anda telah sampai. Terima kasih!";
                } else {
                    message = "Status pengiriman pesanan Anda diperbarui";
                }
                
                notificationService.notifyShippingUpdate(order.getCustomerId(), orderId, message);
                notificationService.notifyOrderStatusChanged(order, oldStatus, status);
                
                response.sendRedirect("courier?action=deliveries&success=updated");
            } else {
                response.sendRedirect("courier?action=deliveries&error=update");
            }
        } catch (Exception e) {
            response.sendRedirect("courier?action=deliveries&error=update");
        }
    }
}