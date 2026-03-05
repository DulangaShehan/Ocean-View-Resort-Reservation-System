<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation History</title>
    <link rel="stylesheet" href="re_history.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<section class="reservation-section">
    <!-- Header -->
    <div class="page-header">
        <div class="header-content">
            <h1><i class="fas fa-history"></i> Reservation History</h1>
            <p class="header-subtitle">View past bookings and stay records</p>
        </div>
        
        <!-- Ocean Animation -->
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

    <!-- Search Bar -->
    <div class="search-container">
        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" id="searchInput" placeholder="Search history by reservation ID, guest name, or room..." onkeyup="searchHistory()">
        </div>
    </div>

    <!-- Reservation History List -->
    <div class="reservation-list" id="historyList">
        
        <%
            String dbUrl = "jdbc:mysql://localhost:3306/ocean_view_db";
            String dbUser = "root";
            String dbPass = "Dulanga@2022";

            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                
                String sql = "SELECT * FROM re_history ORDER BY re_his_id DESC";
                pst = con.prepareStatement(sql);
                rs = pst.executeQuery();
                
                while(rs.next()) {
                    String resId = rs.getString("re_his_res_id");
                    String name = rs.getString("re_his_name");
                    String contact = rs.getString("re_his_contact");
                    String room = rs.getString("re_his_room");
                    String checkIn = rs.getString("re_his_check_in");
                    String checkOut = rs.getString("re_his_check_out");
                    double total = rs.getDouble("re_his_total");
                    String status = rs.getString("re_his_status");
                    
                    String statusClass = "completed"; // default
                    String iconClass = "fa-check-circle";
                    
                    if(status != null && status.equalsIgnoreCase("Cancelled")) {
                        statusClass = "cancelled";
                        iconClass = "fa-times-circle";
                    }
        %>
        
        <div class="reservation-card <%= statusClass %>">
            <div class="card-header">
                <div class="res-id"><i class="fas fa-bookmark"></i> <%= resId %></div>
                <span class="status-badge <%= statusClass %>"><i class="fas <%= iconClass %>"></i> <%= status %></span>
            </div>
            <div class="card-body">
                <div class="row-cell cell-guest">
                    <span class="label">Guest</span>
                    <span class="value"><%= name %></span>
                </div>
                <div class="row-cell cell-contact">
                    <span class="label">Contact</span>
                    <span class="value"><%= contact %></span>
                </div>
                <div class="row-cell cell-room">
                    <span class="label">Room</span>
                    <span class="value"><%= room %></span>
                </div>
                <div class="row-cell cell-checkin">
                    <span class="label">Check-In</span>
                    <span class="value"><%= checkIn %></span>
                </div>
                <div class="row-cell cell-checkout">
                    <span class="label">Check-Out</span>
                    <span class="value"><%= checkOut %></span>
                </div>
                <div class="row-cell cell-total">
                    <span class="label">Total Paid</span>
                    <span class="value highlight"><%= String.format("LKR %,.0f", total) %></span>
                </div>
            </div>
        </div>

        <%
                }
            } catch(Exception e) {
                e.printStackTrace();
        %>
            <div class="error-message">
                <p>Error loading history: <%= e.getMessage() %></p>
            </div>
        <%
            } finally {
                if(rs != null) try { rs.close(); } catch(SQLException e) {}
                if(pst != null) try { pst.close(); } catch(SQLException e) {}
                if(con != null) try { con.close(); } catch(SQLException e) {}
            }
        %>

    </div>
</section>

<script>
function searchHistory() {
    const input = document.getElementById('searchInput');
    const filter = input.value.toUpperCase();
    const list = document.getElementById('historyList');
    const cards = list.getElementsByClassName('reservation-card');

    for (let i = 0; i < cards.length; i++) {
        const text = cards[i].textContent || cards[i].innerText;
        if (text.toUpperCase().indexOf(filter) > -1) {
            cards[i].style.display = "";
        } else {
            cards[i].style.display = "none";
        }
    }
}
</script>

</body>
</html>