package controller;

import dao.CartDAO;
import dao.ProductDAO;
import model.Cart;
import model.Product;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private ProductDAO productDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            viewCart(request, response);
        } else if ("remove".equals(action)) {
            removeFromCart(request, response);
        } else if ("clear".equals(action)) {
            clearCart(request, response);
        } else {
            viewCart(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "add";
        }
        
        switch (action) {
            case "add":
                addToCart(request, response);
                break;
            case "update":
                updateQuantity(request, response);
                break;
            default:
                viewCart(request, response);
        }
    }
    
    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<Cart> cartItems = cartDAO.getCartByCustomer(userId);
        double totalAmount = 0;
        
        for (Cart item : cartItems) {
            totalAmount += item.calculateSubtotal();
        }
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("cartCount", cartItems.size());
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
    
    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = 1;
            
            if (request.getParameter("quantity") != null) {
                quantity = Integer.parseInt(request.getParameter("quantity"));
            }
            
            // Validate product availability
            Product product = productDAO.getProductById(productId);
            
            if (product == null || !product.isAvailable()) {
                response.sendRedirect("product?action=list&error=unavailable");
                return;
            }
            
            if (quantity > product.getStock()) {
                response.sendRedirect("product?action=view&id=" + productId + "&error=stock");
                return;
            }
            
            Cart cart = new Cart();
            cart.setCustomerId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            
            boolean success = cartDAO.addToCart(cart);
            
            if (success) {
                // Update cart count in session
                int cartCount = cartDAO.getCartCount(userId);
                session.setAttribute("cartCount", cartCount);
                
                response.sendRedirect("cart?success=added");
            } else {
                response.sendRedirect("product?action=list&error=cart");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("product?action=list");
        }
    }
    
    private void updateQuantity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                cartDAO.removeFromCart(cartId);
            } else {
                cartDAO.updateQuantity(cartId, quantity);
            }
            
            // Update cart count
            int cartCount = cartDAO.getCartCount(userId);
            session.setAttribute("cartCount", cartCount);
            
            response.sendRedirect("cart?success=updated");
        } catch (NumberFormatException e) {
            response.sendRedirect("cart?error=update");
        }
    }
    
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int cartId = Integer.parseInt(request.getParameter("id"));
            cartDAO.removeFromCart(cartId);
            
            // Update cart count
            int cartCount = cartDAO.getCartCount(userId);
            session.setAttribute("cartCount", cartCount);
            
            response.sendRedirect("cart?success=removed");
        } catch (NumberFormatException e) {
            response.sendRedirect("cart");
        }
    }
    
    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        cartDAO.clearCart(userId);
        session.setAttribute("cartCount", 0);
        
        response.sendRedirect("cart?success=cleared");
    }
}