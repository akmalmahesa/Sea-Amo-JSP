package model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private int userId;
    private String message;
    private String type;
    private boolean isRead;
    private Timestamp createdAt;
    
    public Notification() {}
    
    public Notification(int userId, String message, String type) {
        this.userId = userId;
        this.message = message;
        this.type = type;
        this.isRead = false;
    }
    
    public String getTypeIcon() {
        switch (type) {
            case "order": return "📦";
            case "payment": return "💳";
            case "shipping": return "🚚";
            case "system": return "🔔";
            default: return "ℹ️";
        }
    }
    
    public String getTypeBadge() {
        switch (type) {
            case "order": return "primary";
            case "payment": return "success";
            case "shipping": return "info";
            case "system": return "secondary";
            default: return "secondary";
        }
    }
    
    public int getNotificationId() {
        return notificationId;
    }
    
    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}