package Controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import Utils.DBCon;
import Models.User;
import Daos.UserDao;

@WebServlet("/login")
public class login extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public login() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For debugging - remove in production
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h3>Login Servlet GET Request Received</h3>");
        out.println("<p>Path: " + request.getContextPath() + "</p>");
        out.println("<p>Servlet Path: " + request.getServletPath() + "</p>");
        out.println("<a href='login.jsp'>Go to Login Page</a>");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Login Servlet POST method called");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        
        System.out.println("Username: " + username);
        System.out.println("Password: " + (password != null ? "[PROVIDED]" : "null"));
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        try {
            UserDao userDao = new UserDao();
            User user = userDao.validate(username, password);
            
            if (user != null) {
                // Login successful
                System.out.println("Login successful for user: " + username);
                
                HttpSession session = request.getSession();
                session.setAttribute("admin_id", user.getAdminId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role_id", user.getRoleId());
                session.setAttribute("loggedIn", true);
                
                // Set session timeout based on remember me checkbox
                if ("on".equals(remember)) {
                    session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 days
                } else {
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                }
                
                // Redirect to home servlet
                response.sendRedirect(request.getContextPath() + "/home");
                return;
                
            } else {
                // Login failed
                System.out.println("Login failed - invalid credentials");
                request.setAttribute("error", "Invalid username or password. Please try again.");
                request.setAttribute("username", username);
                if ("on".equals(remember)) {
                    request.setAttribute("remember", "on");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Database error: " + e.getMessage());
            request.setAttribute("error", "Database connection error in login.doPost: " + e.getMessage());
            request.setAttribute("username", username);
            if ("on".equals(remember)) {
                request.setAttribute("remember", "on");
            }
        }
        
        // Forward back to login page with error
        dispatcher = request.getRequestDispatcher("Login/login.jsp");
        dispatcher.forward(request, response);
    }
}
