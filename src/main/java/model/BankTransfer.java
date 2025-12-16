package model;

public class BankTransfer implements Payment {
    private String bankName;
    private String accountNumber;
    private String accountName;
    private double amount;
    
    public BankTransfer(String bankName, String accountNumber, String accountName) {
        this.bankName = bankName;
        this.accountNumber = accountNumber;
        this.accountName = accountName;
    }
    
    @Override
    public boolean processPayment(double amount) {
        this.amount = amount;
        System.out.println("Processing Bank Transfer...");
        System.out.println("Bank: " + bankName);
        System.out.println("Account: " + accountNumber);
        System.out.println("Amount: Rp " + amount);
        
        return true;
    }
    
    @Override
    public String getPaymentMethod() {
        return "Bank Transfer";
    }
    
    @Override
    public String getPaymentDetails() {
        return String.format("Transfer ke %s - Rekening %s a.n. %s", 
                           bankName, accountNumber, accountName);
    }
    
    @Override
    public boolean validatePayment() {
        return bankName != null && !bankName.isEmpty() && 
               accountNumber != null && !accountNumber.isEmpty();
    }
    
    public String getBankName() {
        return bankName;
    }
    
    public void setBankName(String bankName) {
        this.bankName = bankName;
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
    
    public String getAccountName() {
        return accountName;
    }
    
    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }
    
    public double getAmount() {
        return amount;
    }
}