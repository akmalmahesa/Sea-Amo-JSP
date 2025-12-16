package model;

public interface Payment {
    boolean processPayment(double amount);
    String getPaymentMethod();
    String getPaymentDetails();
    boolean validatePayment();
}