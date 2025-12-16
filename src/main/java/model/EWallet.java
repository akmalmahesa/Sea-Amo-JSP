package model;

public class EWallet implements Payment {
    private String walletProvider;
    private String phoneNumber;
    private double amount;
    
    public EWallet(String walletProvider, String phoneNumber) {
        this.walletProvider = walletProvider;
        this.phoneNumber = phoneNumber;
    }
    
    @Override
    public boolean processPayment(double amount) {
        this.amount = amount;
        System.out.println("Processing E-Wallet Payment...");
        System.out.println("Provider: " + walletProvider);
        System.out.println("Phone: " + phoneNumber);
        System.out.println("Amount: Rp " + amount);

        return true;
    }
    
    @Override
    public String getPaymentMethod() {
        return "E-Wallet";
    }
    
    @Override
    public String getPaymentDetails() {
        return String.format("Pembayaran via %s - Nomor %s", 
                           walletProvider, phoneNumber);
    }
    
    @Override
    public boolean validatePayment() {
        return walletProvider != null && !walletProvider.isEmpty() && 
               phoneNumber != null && !phoneNumber.isEmpty();
    }
    
    public String getWalletProvider() {
        return walletProvider;
    }
    
    public void setWalletProvider(String walletProvider) {
        this.walletProvider = walletProvider;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public double getAmount() {
        return amount;
    }
}