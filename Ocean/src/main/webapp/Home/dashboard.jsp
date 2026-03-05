<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.sql.*" %>

<%
    // Fallback logic to fetch counts if accessed directly without Servlet
    Integer guestCount = (Integer) request.getAttribute("guestCount");
    Integer roomCount = (Integer) request.getAttribute("roomCount");

    if (guestCount == null || roomCount == null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ocean_view_db", "root", "Dulanga@2022");
            
            if (guestCount == null) {
                PreparedStatement pst = con.prepareStatement("SELECT COUNT(*) FROM guests");
                ResultSet rs = pst.executeQuery();
                if (rs.next()) guestCount = rs.getInt(1);
                else guestCount = 0;
                rs.close();
                pst.close();
            }
            
            if (roomCount == null) {
                PreparedStatement pst = con.prepareStatement("SELECT COUNT(*) FROM rooms");
                ResultSet rs = pst.executeQuery();
                if (rs.next()) roomCount = rs.getInt(1);
                else roomCount = 0;
                rs.close();
                pst.close();
            }
            con.close();
        } catch (Exception e) {
            if (guestCount == null) guestCount = 0;
            if (roomCount == null) roomCount = 0;
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resort Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="dashboard.css">
    <style>
        /* Temporary inline styles for testing image display */
        .slideshow-slide img {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <div class="header-content">
                <h1><i class="fas fa-tachometer-alt"></i> Resort Overview</h1>
                <p class="header-subtitle">Welcome to Ocean View Resort</p>
            </div>
            <div class="date-display">
                <i class="far fa-calendar-alt"></i>
                <span id="currentDate">
                    <% 
                        LocalDate currentDate = LocalDate.now();
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
                        out.print(currentDate.format(formatter));
                    %>
                </span>
            </div>
            <div class="ocean-scene">
                <div class="sun"></div>
                <div class="cloud cloud1"></div>
                <div class="cloud cloud2"></div>
                <div class="ocean-waves">
                    <div class="wave wave1"></div>
                    <div class="wave wave2"></div>
                </div>
            </div>
        </div>

        <!-- Stats Cards removed -->


        <!-- Main Grid Content -->
        <div class="content-grid">

            <!-- Quick Actions Panel -->
            <section class="panel quick-actions-panel">
                <div class="panel-header">
                    <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
                </div>
                <div class="panel-body">
                    <div class="action-grid">
                        <!-- Card 1: Reservations History -->
                        <a href="re_history.jsp" class="action-card green-action">
                            <div class="action-icon">
                                <i class="fas fa-history"></i>
                            </div>
                            <h4>Reservations History</h4>
                        </a>

                        <!-- Card 2: Billing History -->
                        <a href="bi_history.jsp" class="action-card orange-action">
                            <div class="action-icon">
                                <i class="fas fa-file-invoice-dollar"></i>
                            </div>
                            <h4>Billing History</h4>
                        </a>

                        <!-- Card 3: Total Guests -->
                        <a href="guests.jsp" class="action-card blue-action">
                            <div class="action-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-container">
                                <div class="stat-number"><%= guestCount %></div>
                                <div class="stat-label">Total Guests</div>
                            </div>
                        </a>

                        <!-- Card 4: Total Rooms -->
                        <a href="rooms.jsp" class="action-card purple-action">
                            <div class="action-icon">
                                <i class="fas fa-bed"></i>
                            </div>
                            <div class="stat-container">
                                <div class="stat-number"><%= roomCount %></div>
                                <div class="stat-label">Total Rooms</div>
                            </div>
                        </a>
                    </div>
                </div>
            </section>

            <!-- Gallery Section (Updated) -->
            <section class="panel gallery-panel">
                <div class="panel-header">
                    <h2><i class="fas fa-images"></i> Resort Gallery</h2>
                </div>
                <div class="panel-body">
                    <div class="slideshow-container">
                        <!-- Slide 1 -->
                        <div class="slideshow-slide fade">
                            <div class="slide-number">1 / 6</div>
                            <img src="Images/img_1.jpg" alt="Resort Beach View" onerror="this.src='https://images.unsplash.com/photo-1544551763-46a013bb70d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'">
                           
                        </div>
                        
                        <!-- Slide 2 -->
                        <div class="slideshow-slide fade">
                            <div class="slide-number">2 / 6</div>
                            <img src="Images/img_2.jpg" alt="Resort Pool" onerror="this.src='https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'">
                           
                        </div>
                        
                        <!-- Slide 3 -->
                        <div class="slideshow-slide fade">
                            <div class="slide-number">3 / 6</div>
                            <img src="Images/img_3.jpg" alt="Luxury Suite" onerror="this.src='https://images.unsplash.com/photo-1611892440504-42a792e24d32?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'">
                            
                        </div>
                        
                        <!-- Slide 4 -->
                        <div class="slideshow-slide fade">
                            <div class="slide-number">4 / 6</div>
                            <img src="Images/img_4.jpg" alt="Restaurant" onerror="this.src='https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'">
                            
                        </div>
                        
                        <!-- Slide 5 -->
                        <div class="slideshow-slide fade">
                            <div class="slide-number">5 / 6</div>
                            <img src="Images/img_5.jpg" alt="Spa" onerror="this.src='https://images.unsplash.com/photo-1544161515-4ab6ce6db874?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'">
                            
                        </div>
                        
                        <!-- Slide 6 -->
                        <div class="slideshow-slide fade">
                            <div class="slide-number">6 / 6</div>
                            <img src="Images/img_6.jpg" alt="Sunset View" onerror="this.src='https://images.unsplash.com/photo-1516496636080-14fb876e029d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'">
                            
                        </div>

                        <!-- Navigation arrows -->
                        <a class="prev" onclick="plusSlides(-1)">❮</a>
                        <a class="next" onclick="plusSlides(1)">❯</a>

                        <!-- Dots indicators -->
                        <div class="dots-container">
                            <span class="dot" onclick="currentSlide(1)"></span>
                            <span class="dot" onclick="currentSlide(2)"></span>
                            <span class="dot" onclick="currentSlide(3)"></span>
                            <span class="dot" onclick="currentSlide(4)"></span>
                            <span class="dot" onclick="currentSlide(5)"></span>
                            <span class="dot" onclick="currentSlide(6)"></span>
                        </div>
                    </div>
                    
                    <!-- Gallery thumbnail grid -->
                    <div class="gallery-thumbnails">
                        <div class="thumbnail" onclick="currentSlide(1)">
                            <img src="Images/img_1.jpg" alt="Thumb 1" onerror="this.src='https://images.unsplash.com/photo-1544551763-46a013bb70d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'">
                        </div>
                        <div class="thumbnail" onclick="currentSlide(2)">
                            <img src="Images/img_2.jpg" alt="Thumb 2" onerror="this.src='https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'">
                        </div>
                        <div class="thumbnail" onclick="currentSlide(3)">
                            <img src="Images/img_3.jpg" alt="Thumb 3" onerror="this.src='https://images.unsplash.com/photo-1611892440504-42a792e24d32?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'">
                        </div>
                        <div class="thumbnail" onclick="currentSlide(4)">
                            <img src="Images/img_4.jpg" alt="Thumb 4" onerror="this.src='https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'">
                        </div>
                        <div class="thumbnail" onclick="currentSlide(5)">
                            <img src="Images/img_5.jpg" alt="Thumb 5" onerror="this.src='https://images.unsplash.com/photo-1544161515-4ab6ce6db874?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'">
                        </div>
                        <div class="thumbnail" onclick="currentSlide(6)">
                            <img src="Images/img_6.jpg" alt="Thumb 6" onerror="this.src='https://images.unsplash.com/photo-1516496636080-14fb876e029d?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'">
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <!-- Room Status Section -->
        <section class="panel room-status-panel">
            <div class="panel-header">
                <h2><i class="fas fa-bed"></i> Room Status Overview</h2>
                <div class="legend">
                    <span class="legend-item"><span class="dot occupied"></span> Occupied</span>
                    <span class="legend-item"><span class="dot available"></span> Available</span>
                </div>
            </div>
            <div class="panel-body">
                <div class="room-status-grid">
                    <div class="room-category">
                        <div class="category-header">
                            <h3>Single Rooms</h3>
                            <span class="occupancy-badge">60% Occupied</span>
                        </div>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 60%"></div>
                            </div>
                            <span class="progress-text">12 / 20 Rooms</span>
                        </div>
                    </div>

                    <div class="room-category">
                        <div class="category-header">
                            <h3>Double Rooms</h3>
                            <span class="occupancy-badge">75% Occupied</span>
                        </div>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 75%"></div>
                            </div>
                            <span class="progress-text">15 / 20 Rooms</span>
                        </div>
                    </div>

                    <div class="room-category">
                        <div class="category-header">
                            <h3>Deluxe Suites</h3>
                            <span class="occupancy-badge high">80% Occupied</span>
                        </div>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 80%"></div>
                            </div>
                            <span class="progress-text">12 / 15 Rooms</span>
                        </div>
                    </div>

                    <div class="room-category">
                        <div class="category-header">
                            <h3>Family Rooms</h3>
                            <span class="occupancy-badge low">40% Occupied</span>
                        </div>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 40%"></div>
                            </div>
                            <span class="progress-text">2 / 5 Rooms</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <script>
        let slideIndex = 1;
        let slideTimer;
        
        // Initialize slideshow when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            showSlides(slideIndex);
        });

        function plusSlides(n) {
            clearTimeout(slideTimer);
            showSlides(slideIndex += n);
        }

        function currentSlide(n) {
            clearTimeout(slideTimer);
            showSlides(slideIndex = n);
        }

        function showSlides(n) {
            let i;
            let slides = document.getElementsByClassName("slideshow-slide");
            let dots = document.getElementsByClassName("dot");
            let thumbnails = document.querySelectorAll('.thumbnail');
            
            if (!slides.length) return;

            if (n > slides.length) {slideIndex = 1}
            if (n < 1) {slideIndex = slides.length}
            
            // Hide all slides
            for (i = 0; i < slides.length; i++) {
                slides[i].style.display = "none";
            }
            
            // Remove active class from all dots
            for (i = 0; i < dots.length; i++) {
                dots[i].className = dots[i].className.replace(" active", "");
            }
            
            // Remove active class from all thumbnails
            for (i = 0; i < thumbnails.length; i++) {
                thumbnails[i].classList.remove("active");
            }
            
            // Show current slide and activate corresponding dot/thumbnail
            if (slides[slideIndex-1]) {
                slides[slideIndex-1].style.display = "block";
            }
            if (dots[slideIndex-1]) {
                dots[slideIndex-1].className += " active";
            }
            if (thumbnails[slideIndex-1]) {
                thumbnails[slideIndex-1].classList.add("active");
            }
            
            // Reset timer for auto-advance
            slideTimer = setTimeout(function() { plusSlides(1) }, 5000);
        }
    </script>
</body>
</html>