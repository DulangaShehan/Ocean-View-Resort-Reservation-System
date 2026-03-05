<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDateTime" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Login/login.css?v=<%= System.currentTimeMillis() %>">
    <style>
        .error-message {
            margin-top: 20px;
            padding: 14px;
            background: #fee;
            border: 1px solid #fcc;
            border-radius: 10px;
            color: #c33;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: shake 0.5s ease;
        }
    </style>
</head>
<body>
    <div class="landing-container">
        <!-- Twinkling Stars -->
        <div class="stars">
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
        </div>

        <!-- Glowing Sun -->
        <div class="sun"></div>

        <!-- Floating Clouds -->
        <div class="cloud cloud1"></div>
        <div class="cloud cloud2"></div>
        <div class="cloud cloud3"></div>

        <!-- Flying Seagulls -->
        <div class="seagull seagull1">🕊️</div>
        <div class="seagull seagull2">🕊️</div>
        <div class="seagull seagull3">🕊️</div>

        <div class="login-container">
        <div class="login-header">
            <div class="logo-container">
                <svg class="logo-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                </svg>
            </div>
            <h1>Ocean View Resort</h1>
            <p class="subtitle">Reservation Management System</p>
        </div>

        <div class="login-card">
            <h2>Welcome Back</h2>
            <p class="login-description">Please enter your credentials to access the system</p>

            <!-- Use context path for absolute URL -->
            <form action="<%= request.getContextPath() %>/login" method="post" class="login-form">
                <div class="form-group">
                    <label for="username">
                        <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        Username
                    </label>
                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your username"
                        required
                        autocomplete="username"
                        value="${username != null ? username : param.username}"
                    >
                </div>

                <div class="form-group">
                    <label for="password">
                        <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        Password
                    </label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        required
                        autocomplete="current-password"
                    >
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember" id="remember" 
                            ${remember != null ? 'checked' : param.remember == 'on' ? 'checked' : ''}>
                        <span>Remember me</span>
                    </label>
                </div>

                <button type="submit" class="login-button">
                    <span>Sign In</span>
                    <svg class="button-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </button>
            </form>

            <!-- Error Message Display -->
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null && !error.isEmpty()) {
            %>
                <div class="error-message" id="errorMessage">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <span><%= error %></span>
                </div>
            <% 
                } 
            %>
        </div>

        <div class="login-footer">
            <p>&copy; <%= LocalDateTime.now().getYear() %> Ocean View Resort, Galle. All rights reserved.</p>
        </div>
    </div>

    <!-- Beach Elements -->
    <div class="palm-tree palm-left">🌴</div>
    <div class="palm-tree palm-right">🌴</div>
    
    <div class="beach-umbrella umbrella-left">🏖️</div>
    <div class="beach-umbrella umbrella-right">🏖️</div>

    <!-- Sailboat -->
    <div class="sailboat">⛵</div>

    <!-- Ocean Waves -->
    <div class="waves">
        <div class="wave wave1"></div>
        <div class="wave wave2"></div>
        <div class="wave wave3"></div>
    </div>

    <!-- Swimming Fish -->
    <div class="fish fish-ltr fish1">🐠</div>
    <div class="fish fish-ltr fish2">🐟</div>
    <div class="fish fish-ltr fish3">🐡</div>
    <div class="fish fish-rtl fish4">🐠</div>
    <div class="fish fish-rtl fish5">🐡</div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log("Login page loaded");
            
            // Focus on username field
            var usernameField = document.getElementById('username');
            if (usernameField) {
                usernameField.focus();
            }
            
            // Log form submission
            var loginForm = document.querySelector('.login-form');
            if (loginForm) {
                loginForm.addEventListener('submit', function(e) {
                    console.log("Form submitted to:", this.action);
                });
            }
        });
    </script>
</body>
</html>