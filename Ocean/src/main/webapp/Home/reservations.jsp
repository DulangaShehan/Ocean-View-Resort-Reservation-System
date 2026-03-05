<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*" %>
<%
    String action = request.getParameter("action");
    if (action != null && !action.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        String DB_URL = "jdbc:mysql://localhost:3306/ocean_view_db";
        String DB_USER = "root";
        String DB_PASSWORD = "Dulanga@2022";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            if ("getGuests".equals(action)) {
                response.setContentType("application/json");
                String sql = "SELECT g_id, g_name FROM guests ORDER BY g_name ASC";
                pst = con.prepareStatement(sql);
                rs = pst.executeQuery();
                
                StringBuilder json = new StringBuilder("[");
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    json.append("{\"id\":").append(rs.getInt("g_id"))
                        .append(",\"name\":\"").append(rs.getString("g_name").replace("\"", "\\\"")).append("\"}");
                    first = false;
                }
                json.append("]");
                out.print(json.toString());
                return;
            } else if ("getGuestDetails".equals(action)) {
                response.setContentType("application/json");
                String id = request.getParameter("id");
                String sql = "SELECT * FROM guests WHERE g_id = ?";
                pst = con.prepareStatement(sql);
                pst.setInt(1, Integer.parseInt(id));
                rs = pst.executeQuery();
                
                if (rs.next()) {
                    StringBuilder json = new StringBuilder("{");
                    json.append("\"status\":\"success\",");
                    json.append("\"name\":\"").append(rs.getString("g_name").replace("\"", "\\\"")).append("\",");
                    json.append("\"nic\":\"").append(rs.getString("g_nic").replace("\"", "\\\"")).append("\",");
                    json.append("\"address\":\"").append(rs.getString("g_address").replace("\"", "\\\"")).append("\",");
                    json.append("\"contact\":\"").append(rs.getString("g_contact").replace("\"", "\\\"")).append("\"");
                    json.append("}");
                    out.print(json.toString());
                } else {
                    out.print("{\"status\":\"error\",\"message\":\"Guest not found\"}");
                }
                return;
            } else if ("getAvailableRooms".equals(action)) {
                response.setContentType("application/json");
                String sql = "SELECT * FROM rooms WHERE r_status = 'Available' ORDER BY r_id ASC";
                pst = con.prepareStatement(sql);
                rs = pst.executeQuery();
                
                StringBuilder json = new StringBuilder("[");
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    json.append("{");
                    json.append("\"id\":").append(rs.getInt("r_id")).append(",");
                    json.append("\"room_no\":\"R").append(String.format("%03d", rs.getInt("r_id"))).append("\",");
                    json.append("\"type\":\"").append(rs.getString("r_room_type").replace("\"", "\\\"")).append("\",");
                    json.append("\"ac_type\":\"").append(rs.getString("r_ac_type").replace("\"", "\\\"")).append("\",");
                    json.append("\"bed_type\":\"").append(rs.getString("r_bed_type").replace("\"", "\\\"")).append("\",");
                    json.append("\"price\":").append(rs.getDouble("r_one_night_price"));
                    json.append("}");
                    first = false;
                }
                json.append("]");
                out.print(json.toString());
                return;
            }
        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
            return;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pst != null) try { pst.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Management</title>
    <link rel="stylesheet" href="reservations.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<section class="reservation-management-section">
    <!-- Header -->
    <div class="reservation-header">
        <div class="header-content">
            <h1><i class="fas fa-calendar-alt"></i> Reservation Management</h1>
            <p class="header-subtitle">Manage bookings and guest stays</p>
        </div>
        <button class="btn-new-reservation" onclick="openNewReservationModal()">
            <i class="fas fa-plus"></i> New Reservation
        </button>
        
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
            <input type="text" id="searchInput" placeholder="Search by reservation ID, customer name, or room ID..." onkeyup="searchReservations()">
        </div>
    </div>

    <!-- Reservation Table -->
    <div class="table-container">
        <table class="reservation-table">
            <thead>
                <tr>
                    <th>RESERVATION ID</th>
                    <th>GUEST NAME</th>
                    <th>CONTACT</th>
                    <th>ROOM</th>
                    <th>CHECK-IN</th>
                    <th>CHECK-OUT</th>
                    <th>TOTAL AMOUNT</th>
                    <th>ACTIONS</th>
                </tr>
            </thead>
            <tbody id="reservationTableBody">
        <%
            List<Map<String, String>> reservationList = (List<Map<String, String>>) request.getAttribute("reservationList");
            // Fallback: Fetch from DB directly if attribute is missing (direct JSP access)
            if (reservationList == null) {
                reservationList = new ArrayList<>();
                Connection con = null;
                PreparedStatement pst = null;
                ResultSet rs = null;
                try {
                    String DB_URL = "jdbc:mysql://localhost:3306/ocean_view_db";
                    String DB_USER = "root";
                    String DB_PASSWORD = "Dulanga@2022";
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    
                    String sqlRes = "SELECT res.*, r.r_room_type, r.r_id FROM reservations res LEFT JOIN rooms r ON res.res_room_id = r.r_id ORDER BY res.res_id DESC";
                    pst = con.prepareStatement(sqlRes);
                    rs = pst.executeQuery();
                    
                    while (rs.next()) {
                        Map<String, String> res = new HashMap<>();
                        int resId = rs.getInt("res_id");
                        res.put("id", String.valueOf(resId));
                        res.put("display_id", "RES" + String.format("%03d", resId));
                        res.put("name", rs.getString("res_name"));
                        res.put("contact", rs.getString("res_contact"));
                        
                        int roomId = rs.getInt("res_room_id");
                        String roomType = rs.getString("r_room_type");
                        if (roomType == null) roomType = "Unknown Room";
                        
                        String roomNo = "R" + String.format("%03d", roomId);
                        res.put("room_display", roomNo + " - " + roomType);
                        res.put("room_id", String.valueOf(roomId));
                        res.put("room_no", roomNo);
                        
                        res.put("check_in", rs.getString("res_check_in"));
                        res.put("check_out", rs.getString("res_check_out"));
                        res.put("night_price", String.valueOf(rs.getDouble("res_night_price")));
                        res.put("total_price", String.format("LKR %,.0f", rs.getDouble("res_total_price")));
                        
                        reservationList.add(res);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (pst != null) try { pst.close(); } catch (Exception e) {}
                    if (con != null) try { con.close(); } catch (Exception e) {}
                }
            }
            
            if (reservationList.isEmpty()) {
        %>
            <tr>
                <td colspan="8" style="text-align: center; padding: 40px; color: #64748b;">
                    <i class="far fa-folder-open" style="font-size: 24px; margin-right: 8px; vertical-align: middle;"></i>
                    No reservations found.
                </td>
            </tr>
        <%
            } else {
                for (Map<String, String> res : reservationList) {
                    String displayId = res.get("display_id");
                    String name = res.get("name");
                    String contact = res.get("contact");
                    String roomDisplay = res.get("room_display");
                    String checkIn = res.get("check_in");
                    String checkOut = res.get("check_out");
                    String nightPrice = res.get("night_price");
                    String total = res.get("total_price");
        %>
        <tr>
            <td style="font-weight: 600; color: #0EA5E9;"><%= displayId %></td>
            <td><%= name %></td>
            <td><%= contact %></td>
            <td><%= roomDisplay %></td>
            <td><%= checkIn %></td>
            <td><%= checkOut %></td>
            <td style="font-weight: 600; color: #059669;"><%= total %></td>
            <td class="action-buttons">
                <button class="btn-edit" 
                        title="Edit Reservation"
                        data-id="<%= displayId %>" 
                        data-guest="<%= name %>" 
                        data-contact="<%= contact %>" 
                        data-room="<%= roomDisplay %>" 
                        data-checkin="<%= checkIn %>" 
                        data-checkout="<%= checkOut %>" 
                        data-price="<%= nightPrice %>"
                        data-total="<%= total %>"
                        onclick="editReservation(this)">
                    <i class="fas fa-pen"></i>
                </button>
                <button class="btn-delete" title="Cancel Reservation" onclick="cancelReservation('<%= displayId %>')">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </td>
        </tr>
        <%
                }
            }
        %>
            </tbody>
        </table>
    </div>
</section>

<!-- New Reservation Modal (2-step) -->
<div id="newReservationModal" class="modal">
    <div class="modal-content large-modal">
        <div class="modal-header">
            <h2 id="modalTitle">New Reservation - Step 1 of 2</h2>
            <span class="close" onclick="closeNewReservationModal()">&times;</span>
        </div>
        
        <!-- Progress Bar -->
        <div class="modal-progress">
            <div class="progress-bar">
                <div class="progress-fill" id="progressFill"></div>
            </div>
            <div class="steps-indicator">
                <div class="step active" id="step1Indicator"></div>
                <div class="step" id="step2Indicator"></div>
            </div>
        </div>

        <div class="modal-body">
            <!-- Step 1: Guest Details -->
            <div id="step1" class="step-content">
                <form id="guestDetailsForm">
                    <div class="quick-fill-box">
                        <label class="quick-fill-label">Quick Fill from Existing Guest (Optional)</label>
                        <select class="quick-fill-select" id="quickFillGuest" onchange="fillGuestDetails(this)">
                            <option value="">Select a guest...</option>
                        </select>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Customer Name *</label>
                            <input type="text" id="customerName" required>
                        </div>
                        <div class="form-group">
                            <label>NIC *</label>
                            <input type="text" id="customerNIC" required>
                        </div>
                        <div class="form-group full-width">
                            <label>Address *</label>
                            <textarea id="customerAddress" rows="2" required></textarea>
                        </div>
                        <div class="form-group full-width">
                            <label>Contact Number *</label>
                            <input type="tel" id="customerContact" required>
                        </div>
                        <div class="form-group">
                            <label>Check-In Date *</label>
                            <input type="date" id="checkInDate" required>
                        </div>
                        <div class="form-group">
                            <label>Check-Out Date *</label>
                            <input type="date" id="checkOutDate" required>
                        </div>
                    </div>
                </form>
                <div class="modal-footer">
                    <button class="btn-secondary" onclick="closeNewReservationModal()">Cancel</button>
                    <button class="btn-primary" onclick="goToStep2()">Next: Select Room</button>
                </div>
            </div>

            <!-- Step 2: Room Selection -->
            <div id="step2" class="step-content" style="display: none;">
                <!-- Booking Summary -->
                <div class="booking-summary">
                    <h3>Booking Details</h3>
                    <div class="summary-grid">
                        <div class="summary-item">
                            <span class="s-label">Guest:</span>
                            <span class="s-value" id="summaryName"></span>
                        </div>
                        <div class="summary-item">
                            <span class="s-label">Contact:</span>
                            <span class="s-value" id="summaryContact"></span>
                        </div>
                        <div class="summary-item">
                            <span class="s-label">Check-In:</span>
                            <span class="s-value" id="summaryCheckIn"></span>
                        </div>
                        <div class="summary-item">
                            <span class="s-label">Check-Out:</span>
                            <span class="s-value" id="summaryCheckOut"></span>
                        </div>
                    </div>
                </div>

                <!-- Room Selection -->
                <div class="room-selection-section">
                    <h3>Available Rooms</h3>
                    <div class="room-grid-list" id="availableRoomsList">
                        <!-- Rooms will be loaded here dynamically -->
                        <div style="text-align: center; padding: 20px; width: 100%; color: #666;">
                            <i class="fas fa-spinner fa-spin"></i> Loading available rooms...
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn-secondary" onclick="goToStep1()">Back</button>
                    <button class="btn-primary" onclick="submitNewReservation()" id="confirmBtn" disabled>Confirm Reservation</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Reservation Modal (1-step) -->
<div id="editReservationModal" class="modal">
    <div class="modal-content edit-modal">
        <div class="modal-header">
            <h2 id="editModalTitle">Edit Reservation - Step 1 of 2</h2>
            <span class="close" onclick="closeEditReservationModal()">&times;</span>
        </div>

        <div class="modal-body">
            <!-- Edit Form -->
            <form id="editReservationForm">
                <div class="form-grid">
                    <div class="form-group">
                    <label>Customer Name</label>
                    <input type="text" id="editCustomerName" readonly style="background-color: #f3f4f6; cursor: not-allowed;">
                </div>
                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="tel" id="editCustomerContact" readonly style="background-color: #f3f4f6; cursor: not-allowed;">
                </div>
                    <div class="form-group">
                    <label>Check-In Date *</label>
                    <input type="date" id="editCheckInDate" required onchange="calculateEditTotal()">
                </div>
                    <div class="form-group">
                    <label>Check-Out Date *</label>
                    <input type="date" id="editCheckOutDate" required onchange="calculateEditTotal()">
                </div>
                <div class="form-group">
                    <label>Updated Total Price</label>
                    <input type="text" id="editTotalPrice" readonly style="background-color: #f3f4f6; font-weight: bold; color: #059669;">
                </div>
                </div>
            </form>
            
            <div class="modal-footer edit-footer">
                <button class="btn-secondary" onclick="closeEditReservationModal()">Cancel</button>
                <button class="btn-update" onclick="updateReservation()">Update Reservation</button>
            </div>
        </div>
    </div>
</div>

<!-- Toast Container -->
<div id="toastContainer" class="toast-container"></div>

<script>
let currentStep = 1;
let selectedRoomId = null;
let editingReservationId = null;
let currentReservationData = null;

// New Reservation Functions
function openNewReservationModal() {
    editingReservationId = null;
    document.getElementById('newReservationModal').style.display = 'flex';
    goToStep1();
    selectedRoomId = null;
    document.getElementById('confirmBtn').disabled = true;
    document.querySelectorAll('.room-select-card').forEach(c => c.classList.remove('selected'));
    // Clear form
    document.getElementById('guestDetailsForm').reset();
    
    // Load guests for quick fill
    loadGuests();
}

function loadGuests() {
    const select = document.getElementById('quickFillGuest');
    // Keep the first option
    select.innerHTML = '<option value="">Select a guest...</option>';
    
    fetch('<%=request.getContextPath()%>/reservations?action=getGuests')
        .then(response => response.json())
        .then(data => {
            if (Array.isArray(data)) {
                data.forEach(guest => {
                    const option = document.createElement('option');
                    option.value = guest.id;
                    option.textContent = guest.name;
                    select.appendChild(option);
                });
            } else {
                console.error('Expected array of guests, got:', data);
            }
        })
        .catch(error => console.error('Error loading guests:', error));
}

function closeNewReservationModal() {
    document.getElementById('newReservationModal').style.display = 'none';
}

function goToStep2() {
    const form = document.getElementById('guestDetailsForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    currentStep = 2;
    updateModalUI();
    
    document.getElementById('summaryName').textContent = document.getElementById('customerName').value;
    document.getElementById('summaryContact').textContent = document.getElementById('customerContact').value;
    const checkIn = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    document.getElementById('summaryCheckIn').textContent = checkIn;
    document.getElementById('summaryCheckOut').textContent = checkOut;
    
    // Calculate duration
    const start = new Date(checkIn);
    const end = new Date(checkOut);
    const diffTime = Math.abs(end - start);
    let nights = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
    if (isNaN(nights) || nights <= 0) nights = 1;

    // Fetch available rooms
    const roomsList = document.getElementById('availableRoomsList');
    roomsList.innerHTML = '<div style="text-align: center; padding: 20px;"><i class="fas fa-spinner fa-spin"></i> Loading available rooms...</div>';
    
    fetch('<%=request.getContextPath()%>/reservations?action=getAvailableRooms')
        .then(response => response.json())
        .then(rooms => {
            roomsList.innerHTML = '';
            if (rooms.length === 0) {
                roomsList.innerHTML = '<div style="text-align: center; padding: 20px;">No available rooms found.</div>';
                return;
            }
            
            rooms.forEach(room => {
                const totalPrice = room.price * nights;
                const card = document.createElement('div');
                card.className = 'room-select-card';
                card.onclick = function() { selectRoom(this, room.id); }; 
                
                // Helper to safely access properties even if they are missing in JSON (though backend ensures they are there)
                const roomNo = room.room_no || ('R' + room.id);
                const type = room.type || '';
                const bedType = room.bed_type || '';
                const acType = room.ac_type || '';
                const price = room.price || 0;
                
                const statusClass = (room.status && room.status.toLowerCase() === 'available') ? 'status-available' : 'status-booked';
                const statusText = room.status || 'Unknown';
                
                let dateInfo = '';
                if (room.status && room.status.toLowerCase() === 'booked' && room.booked_from && room.booked_to) {
                     dateInfo = `<div class="booked-dates" style="font-size: 0.85em; color: #dc2626; margin-top: 8px; font-weight: 500; background-color: #fee2e2; padding: 4px 8px; border-radius: 4px; display: inline-block;">
                                    <i class="far fa-calendar-times"></i> \${room.booked_from} to \${room.booked_to}
                                 </div>`;
                }
                
                card.innerHTML = `
                    <div class="room-status-badge \${statusClass}">\${statusText}</div>
                    <div class="room-info">
                        <h4>\${roomNo}</h4>
                        <p class="room-type">\${type} - \${bedType}</p>
                        <div class="room-features">
                            <span>\${acType}</span>
                        </div>
                        \${dateInfo}
                    </div>
                    <div class="room-price-info">
                        <p class="total-price">LKR \${totalPrice.toLocaleString()}</p>
                        <p class="per-night">LKR \${price.toLocaleString()} / night</p>
                        <p class="duration">\${nights} nights</p>
                    </div>
                `;
                roomsList.appendChild(card);
            });
        })
        .catch(error => {
            console.error('Error:', error);
            roomsList.innerHTML = '<div style="text-align: center; color: red;">Error loading rooms.</div>';
        });
}

function goToStep1() {
    currentStep = 1;
    updateModalUI();
}

function updateModalUI() {
    const step1 = document.getElementById('step1');
    const step2 = document.getElementById('step2');
    const title = document.getElementById('modalTitle');
    const progressFill = document.getElementById('progressFill');
    const step1Ind = document.getElementById('step1Indicator');
    const step2Ind = document.getElementById('step2Indicator');

    if (currentStep === 1) {
        step1.style.display = 'block';
        step2.style.display = 'none';
        title.textContent = 'New Reservation - Step 1 of 2';
        progressFill.style.width = '50%';
        step1Ind.classList.add('active');
        step2Ind.classList.remove('active');
    } else {
        step1.style.display = 'none';
        step2.style.display = 'block';
        title.textContent = 'New Reservation - Step 2 of 2';
        progressFill.style.width = '100%';
        step1Ind.classList.add('active');
        step2Ind.classList.add('active');
        document.getElementById('confirmBtn').textContent = 'Confirm Reservation';
    }
}

function selectRoom(card, roomId) {
    document.querySelectorAll('.room-select-card').forEach(c => c.classList.remove('selected'));
    card.classList.add('selected');
    selectedRoomId = roomId;
    document.getElementById('confirmBtn').disabled = false;
}

function fillGuestDetails(select) {
    const guestId = select.value;
    if (!guestId) return;

    fetch('<%=request.getContextPath()%>/reservations?action=getGuestDetails&id=' + guestId)
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                document.getElementById('customerName').value = data.name;
                document.getElementById('customerNIC').value = data.nic;
                document.getElementById('customerAddress').value = data.address;
                document.getElementById('customerContact').value = data.contact;
            } else {
                console.error('Error fetching guest details:', data.message);
                alert('Could not fetch guest details: ' + data.message);
            }
        })
        .catch(error => console.error('Error:', error));
}

function submitNewReservation() {
    if (!selectedRoomId) {
        showToast('error', "Please select a room first.");
        return;
    }
    
    // Get form data
    const name = document.getElementById('customerName').value;
    const contact = document.getElementById('customerContact').value;
    const nic = document.getElementById('customerNIC').value;
    const address = document.getElementById('customerAddress').value;
    const checkIn = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    
    if (!name || !contact) {
        showToast('error', "Please fill in guest details.");
        return;
    }
    
    const confirmBtn = document.getElementById('confirmBtn');
    const originalText = confirmBtn.textContent;
    confirmBtn.disabled = true;
    confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
    
    const params = new URLSearchParams();
    params.append('action', 'saveReservation');
    params.append('name', name);
    params.append('contact', contact);
    params.append('nic', nic);
    params.append('address', address);
    params.append('room_id', selectedRoomId);
    params.append('check_in', checkIn);
    params.append('check_out', checkOut);
    
    fetch('<%=request.getContextPath()%>/reservations', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            showToast('success', 'Reservation created successfully!');
            setTimeout(() => location.reload(), 2000);
        } else {
            showToast('error', 'Error: ' + data.message);
            confirmBtn.disabled = false;
            confirmBtn.textContent = originalText;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('error', 'An error occurred while saving the reservation.');
        confirmBtn.disabled = false;
        confirmBtn.textContent = originalText;
    });
}

function generateReservationId() {
    const prefix = "RES";
    const min = 100;
    const max = 999;
    const randomNum = Math.floor(Math.random() * (max - min + 1)) + min;
    return prefix + randomNum;
}

// Edit Reservation Functions
function editReservation(btn) {
    if (!btn) return;
    
    const id = btn.dataset.id;
    editingReservationId = id;
    currentReservationData = {
        id: id,
        guest: btn.dataset.guest,
        contact: btn.dataset.contact,
        room: btn.dataset.room,
        checkin: btn.dataset.checkin,
        checkout: btn.dataset.checkout,
        price: parseFloat(btn.dataset.price || 0),
        total: btn.dataset.total
    };
            
    // Populate edit form
    document.getElementById('editCustomerName').value = currentReservationData.guest;
    document.getElementById('editCustomerContact').value = currentReservationData.contact;
    document.getElementById('editCheckInDate').value = currentReservationData.checkin;
    document.getElementById('editCheckOutDate').value = currentReservationData.checkout;
    document.getElementById('editTotalPrice').value = currentReservationData.total;
    
    // Update modal title with step
    document.getElementById('editModalTitle').textContent = `Edit Reservation`;
    
    document.getElementById('editReservationModal').style.display = 'flex';
}

function closeEditReservationModal() {
    document.getElementById('editReservationModal').style.display = 'none';
    editingReservationId = null;
    currentReservationData = null;
}

function calculateEditTotal() {
    if (!currentReservationData) return;
    
    const checkInStr = document.getElementById('editCheckInDate').value;
    const checkOutStr = document.getElementById('editCheckOutDate').value;
    
    if (checkInStr && checkOutStr) {
        const checkIn = new Date(checkInStr);
        const checkOut = new Date(checkOutStr);
        
        // Calculate difference in days
        const diffTime = Math.abs(checkOut - checkIn);
        let nights = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        
        if (nights <= 0) nights = 1; // Minimum 1 night
        
        const total = nights * currentReservationData.price;
        
        // Format as currency LKR
        const formattedTotal = 'LKR ' + total.toLocaleString('en-US', {minimumFractionDigits: 0, maximumFractionDigits: 0});
        
        document.getElementById('editTotalPrice').value = formattedTotal;
    }
}

function updateReservation() {
    const form = document.getElementById('editReservationForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    if (!editingReservationId) return;
    
    const updateBtn = document.querySelector('#editReservationModal .btn-update');
    const originalText = updateBtn.textContent;
    updateBtn.disabled = true;
    updateBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';

    // Extract ID number from "RES001" -> "1"
    const dbId = editingReservationId.replace('RES', '');

    const params = new URLSearchParams();
    params.append('action', 'updateReservation');
    params.append('id', dbId);
    params.append('name', document.getElementById('editCustomerName').value);
    params.append('contact', document.getElementById('editCustomerContact').value);
    params.append('check_in', document.getElementById('editCheckInDate').value);
    params.append('check_out', document.getElementById('editCheckOutDate').value);
    
    fetch('<%=request.getContextPath()%>/reservations', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            showToast('success', 'Reservation updated successfully!');
            setTimeout(() => location.reload(), 2000);
        } else {
            showToast('error', 'Error: ' + data.message);
            updateBtn.disabled = false;
            updateBtn.textContent = originalText;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('error', 'An error occurred while updating.');
        updateBtn.disabled = false;
        updateBtn.textContent = originalText;
    });
}

function cancelReservation(displayId) {
    if(confirm(`Are you sure you want to delete reservation ${displayId}? This action cannot be undone.`)) {
        // Extract ID number from "RES001" -> "1"
        const dbId = displayId.replace('RES', '');
        
        const params = new URLSearchParams();
        params.append('action', 'deleteReservation');
        params.append('id', dbId);
        
        fetch('<%=request.getContextPath()%>/reservations', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                showToast('success', 'Reservation deleted successfully!');
                setTimeout(() => location.reload(), 2000);
            } else {
                showToast('error', 'Error: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('error', 'An error occurred while deleting.');
        });
    }
}

function searchReservations() {
    const input = document.getElementById('searchInput');
    const filter = input.value.toLowerCase();
    const table = document.getElementById('reservationTableBody');
    const rows = table.getElementsByTagName('tr');

    for (let i = 0; i < rows.length; i++) {
        const cells = rows[i].getElementsByTagName('td');
        let found = false;
        
        for (let j = 0; j < cells.length - 1; j++) {
            const cellText = cells[j].textContent || cells[j].innerText;
            if (cellText.toLowerCase().indexOf(filter) > -1) {
                found = true;
                break;
            }
        }
        
        rows[i].style.display = found ? '' : 'none';
    }
}

// Close modals on outside click
window.onclick = function(event) {
    const newModal = document.getElementById('newReservationModal');
    const editModal = document.getElementById('editReservationModal');
    
    if (event.target == newModal) {
        closeNewReservationModal();
    }
    if (event.target == editModal) {
        closeEditReservationModal();
    }
}

function showToast(type, message) {
    const container = document.getElementById('toastContainer');
    
    // Create toast element
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    
    // Create icon
    const icon = document.createElement('i');
    if (type === 'success') {
        icon.className = 'fas fa-check-circle';
    } else {
        icon.className = 'fas fa-exclamation-circle';
    }
    
    // Create message span
    const msgSpan = document.createElement('span');
    msgSpan.className = 'toast-message';
    msgSpan.textContent = message || "No message provided"; 
    
    // Assemble toast
    toast.appendChild(icon);
    toast.appendChild(msgSpan);
    
    // Add to container
    container.appendChild(toast);
    
    // Trigger reflow for animation
    void toast.offsetWidth;
    
    // Add animation class
    toast.classList.add('show');
    
    // Remove after 3 seconds
    setTimeout(() => {
        toast.classList.add('hiding'); 
        toast.addEventListener('animationend', () => {
            if (toast.parentNode === container) {
                container.removeChild(toast);
            }
        });
    }, 3000);
}

function loadGuests() {
    const select = document.getElementById('quickFillGuest');
    if (!select) {
        console.error('Guest select element not found');
        return;
    }
    
    // Clear existing options except default
    select.innerHTML = '<option value="">Select a guest...</option>';
    
    console.log('Fetching guests from: <%=request.getContextPath()%>/reservations?action=getGuests');
    
    fetch('<%=request.getContextPath()%>/reservations?action=getGuests')
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok: ' + response.statusText);
            const contentType = response.headers.get("content-type");
            if (contentType && contentType.indexOf("application/json") === -1) {
                return response.text().then(text => {
                    console.error('Expected JSON but got:', contentType);
                    // Check if it looks like the JSP page (HTML)
                    if (text.includes("<!DOCTYPE html") || text.includes("<html")) {
                        throw new Error('Server returned HTML instead of JSON. The JSP might not be handling the action parameter correctly.');
                    }
                    throw new Error('Expected JSON but got ' + contentType);
                });
            }
            return response.json();
        })
        .then(guests => {
            console.log('Guests loaded:', guests);
            if (guests.length === 0) {
                const option = document.createElement('option');
                option.text = "No guests found in database";
                option.disabled = true;
                select.appendChild(option);
                return;
            }
            guests.forEach(guest => {
                const option = document.createElement('option');
                option.value = guest.id;
                option.textContent = guest.id + ' - ' + guest.name;
                select.appendChild(option);
            });
        })
        .catch(error => {
            console.error('Error loading guests:', error);
            const option = document.createElement('option');
            option.text = "Error: " + error.message;
            option.title = error.message; // Show full error on hover
            option.disabled = true;
            select.appendChild(option);
        });
}

// Initialize guests loading
loadGuests();
</script>
</body>
</html>