package service;

import dao.NotificationDAO;
import model.Notification;
import model.Order;

public class NotificationService {
    private NotificationDAO notificationDAO;
    
    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }
    
    public void notifyOrderCreated(Order order) {
        // Notifikasi ke customer
        String customerMessage = String.format(
            "Pesanan #%d berhasil dibuat. Total: Rp %.0f", 
            order.getOrderId(), order.getTotalAmount()
        );
        Notification customerNotif = new Notification(
            order.getCustomerId(), customerMessage, "order"
        );
        notificationDAO.insert(customerNotif);
        
        // Notifikasi ke fisherman (dari order items)
        // This would be called with fisherman IDs from order items
        System.out.println("Order notification sent to customer #" + order.getCustomerId());
    }
    
    public void notifyOrderStatusChanged(Order order, String oldStatus, String newStatus) {
        String message = String.format(
            "Status pesanan #%d berubah dari '%s' menjadi '%s'",
            order.getOrderId(), oldStatus, newStatus
        );
        
        Notification notification = new Notification(
            order.getCustomerId(), message, "order"
        );
        notificationDAO.insert(notification);
        
        System.out.println("Order status notification sent to customer #" + order.getCustomerId());
    }
    
    public void notifyPaymentReceived(int userId, int orderId, double amount) {
        String message = String.format(
            "Pembayaran untuk pesanan #%d sebesar Rp %.0f telah diterima",
            orderId, amount
        );
        
        Notification notification = new Notification(userId, message, "payment");
        notificationDAO.insert(notification);
        
        System.out.println("Payment notification sent to user #" + userId);
    }
    
    public void notifyNewOrderToFisherman(int fishermanId, int orderId) {
        String message = String.format(
            "Anda mendapat pesanan baru #%d! Silakan proses pesanan.",
            orderId
        );
        
        Notification notification = new Notification(fishermanId, message, "order");
        notificationDAO.insert(notification);
        
        System.out.println("New order notification sent to fisherman #" + fishermanId);
    }
    
    public void notifyShippingUpdate(int userId, int orderId, String status) {
        String message = String.format(
            "Pesanan #%d: %s",
            orderId, status
        );
        
        Notification notification = new Notification(userId, message, "shipping");
        notificationDAO.insert(notification);
        
        System.out.println("Shipping notification sent to user #" + userId);
    }
}