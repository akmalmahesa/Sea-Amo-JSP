package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import model.Order;
import service.NotificationService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/fisherman")
public class FishermanServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private NotificationService notificationService;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        // Cek Login & Role
        if (userId == null || !"fisherman".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "dashboard";
        
        switch (action) {
            case "dashboard":
                showDashboard(request, response, userId);
                break;
            default:
                showDashboard(request, response, userId);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null || !"fisherman".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "dashboard";
        
        switch (action) {
            case "confirmOrder":
                confirmOrder(request, response, userId);
                break;
            case "updateStatus":
                updateOrderStatus(request, response, userId);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/fisherman");
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response, int userId) 
        throws ServletException, IOException {
    
    // 1. Total Pendapatan SELESAI (delivered)
    double completedSales = orderDAO.getTotalSalesByFisherman(userId);
    
    // 2. Pendapatan DALAM PROSES (processing + shipped)
    double pendingSales = orderDAO.getPendingSalesByFisherman(userId);
    
    // 3. Total Keseluruhan
    double totalRevenue = completedSales + pendingSales;
    
    // 4. Jumlah Pesanan Pending
    int pendingOrders = orderDAO.getPendingOrdersCount(userId);
    
    // 5. Total Produk Aktif
    int totalProducts = productDAO.countProductsByFisherman(userId);
    
    // 6. Kirim ke JSP
    request.setAttribute("completedSales", completedSales);
    request.setAttribute("pendingSales", pendingSales);
    request.setAttribute("totalRevenue", totalRevenue);
    request.setAttribute("pendingOrders", pendingOrders);
    request.setAttribute("totalProducts", totalProducts);
    
    request.getRequestDispatcher("/fisherman/dashboard.jsp").forward(request, response);
}
    
    /**
     * Konfirmasi pesanan yang sudah dibayar (paid -> processing)
     */
    private void confirmOrder(HttpServletRequest request, HttpServletResponse response, int fishermanId)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            
            // Validasi: Cek apakah order ini milik fisherman ini
            if (!orderDAO.isOrderBelongsToFisherman(orderId, fishermanId)) {
                session.setAttribute("error", "Anda tidak memiliki akses ke pesanan ini!");
                response.sendRedirect(request.getContextPath() + "/order?action=fishermanOrders");
                return;
            }
            
            Order order = orderDAO.getOrderById(orderId);
            
            // Validasi: Hanya bisa konfirmasi jika status = paid
            if (!"paid".equals(order.getStatus())) {
                session.setAttribute("error", "Pesanan ini tidak bisa dikonfirmasi (status: " + order.getStatusLabel() + ")");
                response.sendRedirect(request.getContextPath() + "/order?action=fishermanOrders");
                return;
            }
            
            // Update status ke processing
            boolean success = orderDAO.updateOrderStatusByFisherman(orderId, fishermanId, "processing");
            
            if (success) {
                // Kirim notifikasi ke customer
                notificationService.notifyOrderStatusChanged(order, "paid", "processing");
                
                session.setAttribute("success", "Pesanan #" + orderId + " berhasil dikonfirmasi!");
            } else {
                session.setAttribute("error", "Gagal mengkonfirmasi pesanan");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID Pesanan tidak valid");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Terjadi kesalahan: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/order?action=fishermanOrders");
    }
    
    /**
     * Update status pesanan (processing -> shipped)
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response, int fishermanId)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");
            
            // Validasi: Cek apakah order ini milik fisherman ini
            if (!orderDAO.isOrderBelongsToFisherman(orderId, fishermanId)) {
                session.setAttribute("error", "Anda tidak memiliki akses ke pesanan ini!");
                response.sendRedirect(request.getContextPath() + "/order?action=fishermanOrders");
                return;
            }
            
            Order order = orderDAO.getOrderById(orderId);
            String oldStatus = order.getStatus();
            
            // Validasi: Fisherman hanya bisa update dari processing -> shipped
            if ("processing".equals(oldStatus) && "shipped".equals(newStatus)) {
                
                boolean success = orderDAO.updateOrderStatusByFisherman(orderId, fishermanId, newStatus);
                
                if (success) {
                    // Kirim notifikasi ke customer
                    notificationService.notifyOrderStatusChanged(order, oldStatus, newStatus);
                    
                    session.setAttribute("success", "Pesanan #" + orderId + " berhasil ditandai sedang dikirim!");
                } else {
                    session.setAttribute("error", "Gagal mengubah status pesanan");
                }
                
            } else {
                session.setAttribute("error", "Perubahan status tidak diizinkan (dari " + 
                                             order.getStatusLabel() + " ke " + newStatus + ")");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID Pesanan tidak valid");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Terjadi kesalahan: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/order?action=fishermanOrders");
    }
}