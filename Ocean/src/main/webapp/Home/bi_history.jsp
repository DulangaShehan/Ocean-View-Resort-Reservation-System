<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing History</title>
    <link rel="stylesheet" href="bi_history.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<section class="billing-section">
    <!-- Header -->
    <div class="page-header">
        <div class="header-content">
            <h1><i class="fas fa-file-invoice-dollar"></i> Billing History</h1>
            <p class="header-subtitle">View invoices and payment records</p>
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
            <input type="text" id="searchInput" placeholder="Search by invoice ID, guest name, or amount..." onkeyup="searchBilling()">
        </div>
    </div>

    <!-- Billing History List -->
    <div class="billing-list" id="billingList">
        
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
                
                String sql = "SELECT * FROM bi_history ORDER BY bi_his_id DESC";
                pst = con.prepareStatement(sql);
                rs = pst.executeQuery();
                
                while(rs.next()) {
                    String invId = rs.getString("bi_his_inv_id");
                    String name = rs.getString("bi_his_name");
                    String resId = rs.getString("bi_his_res_id");
                    String nights = rs.getString("bi_his_nights");
                    double rate = rs.getDouble("bi_his_night_price");
                    double total = rs.getDouble("bi_his_total");
                    String status = rs.getString("bi_his_status");
                    
                    String statusClass = "paid"; // default
                    String iconClass = "fa-check-circle";
                    // If there are other statuses, handle them here
        %>
        
        <div class="billing-card <%= statusClass %>">
            <div class="card-header">
                <div class="invoice-id"><i class="fas fa-receipt"></i> <%= invId %></div>
                <span class="status-badge <%= statusClass %>"><i class="fas <%= iconClass %>"></i> <%= status %></span>
            </div>
            <div class="card-body">
                <div class="row-cell cell-guest">
                    <span class="label">Guest Name</span>
                    <span class="value"><%= name %></span>
                </div>
                <div class="row-cell cell-ref">
                    <span class="label">Reservation ID</span>
                    <span class="value"><%= resId %></span>
                </div>
                <div class="row-cell cell-nights">
                    <span class="label">Nights</span>
                    <span class="value"><%= nights %></span>
                </div>
                <div class="row-cell cell-rate">
                    <span class="label">Rate/Night</span>
                    <span class="value"><%= String.format("LKR %,.0f", rate) %></span>
                </div>
                <div class="row-cell cell-amount">
                    <span class="label">Total Amount</span>
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
function searchBilling() {
    const input = document.getElementById('searchInput');
    const filter = input.value.toUpperCase();
    const list = document.getElementById('billingList');
    const cards = list.getElementsByClassName('billing-card');

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