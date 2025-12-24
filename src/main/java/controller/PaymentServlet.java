package controller;

import dao.OrderDAO;
import dao.PaymentDAO;
import model.*;
import service.NotificationService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO;
    private OrderDAO orderDAO;
    private NotificationService notificationService;
    
    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
        orderDAO = new OrderDAO();
        notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String orderIdParam = request.getParameter("orderId");
        
        if (orderIdParam == null) {
            response.sendRedirect("order?action=myOrders");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdParam);
            Order order = orderDAO.getOrderById(orderId);
            
            // Verify order belongs to user
            if (order == null || order.getCustomerId() != userId) {
                response.sendRedirect("order?action=myOrders");
                return;
            }
            
            // Check if already paid
            if ("paid".equals(order.getPaymentStatus())) {
                response.sendRedirect("order?action=myOrders&error=alreadyPaid");
                return;
            }
            
            request.setAttribute("order", order);
            request.getRequestDispatcher("payment.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("order?action=myOrders");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String paymentMethod = request.getParameter("paymentMethod");
            
            Order order = orderDAO.getOrderById(orderId);
            
            // Verify order belongs to user
            if (order == null || order.getCustomerId() != userId) {
                response.sendRedirect("order?action=myOrders");
                return;
            }
            
            // Create payment object based on method - Polymorphism
            Payment payment;
            String paymentDetails;
            
            if ("bank_transfer".equals(paymentMethod)) {
                String bankName = request.getParameter("bankName");
                String accountNumber = request.getParameter("accountNumber");
                String accountName = request.getParameter("accountName");
                
                payment = new BankTransfer(bankName, accountNumber, accountName);
                paymentDetails = payment.getPaymentDetails();
                
            } else if ("e_wallet".equals(paymentMethod)) {
                String walletProvider = request.getParameter("walletProvider");
                String phoneNumber = request.getParameter("phoneNumber");
                
                payment = new EWallet(walletProvider, phoneNumber);
                paymentDetails = payment.getPaymentDetails();
                
            } else {
                response.sendRedirect("payment?orderId=" + orderId + "&error=method");
                return;
            }
            
            // Validate payment
            if (!payment.validatePayment()) {
                response.sendRedirect("payment?orderId=" + orderId + "&error=validation");
                return;
            }
            
            // Process payment (simulation)
            boolean paymentSuccess = payment.processPayment(order.getTotalAmount());
            
            if (paymentSuccess) {
                // 1. Save payment record
                PaymentRecord paymentRecord = new PaymentRecord();
                paymentRecord.setOrderId(orderId);
                paymentRecord.setPaymentMethod(payment.getPaymentMethod());
                paymentRecord.setAmount(order.getTotalAmount());
                paymentRecord.setPaymentDetails(paymentDetails);
                paymentRecord.setStatus("completed");
                
                paymentDAO.insertPayment(paymentRecord);
                
                // 2. Update order status (Shipping Status)
                orderDAO.updateOrderStatus(orderId, "processing");
                
                // 3. Update order payment status (CRITICAL FIX)
                // We must call the DAO to update the database, not just set the java object
                orderDAO.updatePaymentStatus(orderId, "paid");
                
                // 4. Send notifications
                notificationService.notifyPaymentReceived(userId, orderId, order.getTotalAmount());
                
                // 5. Redirect to success page
                session.setAttribute("paymentSuccess", true);
                response.sendRedirect("paymentSuccess.jsp?orderId=" + orderId);
                
            } else {
                // Payment failed
                PaymentRecord paymentRecord = new PaymentRecord();
                paymentRecord.setOrderId(orderId);
                paymentRecord.setPaymentMethod(payment.getPaymentMethod());
                paymentRecord.setAmount(order.getTotalAmount());
                paymentRecord.setPaymentDetails(paymentDetails);
                paymentRecord.setStatus("failed");
                
                paymentDAO.insertPayment(paymentRecord);
                
                response.sendRedirect("payment?orderId=" + orderId + "&error=failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order?action=myOrders&error=payment");
        }
    }
}