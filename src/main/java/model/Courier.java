package model;

public class Courier extends User {
    
    public Courier() {
        super();
    }
    
    public Courier(int userId, String username, String email, String fullName, 
                   String phone, String address, String status) {
        super(userId, username, email, fullName, phone, address, "courier", status);
    }
    
    @Override
    public String getDisplayRole() {
        return "Kurir";
    }
    
    @Override
    public String getDashboardPath() {
        return "courier/dashboard.jsp";
    }
    
    public int getActiveDeliveries() {

        return 0;
    }
}