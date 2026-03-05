<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    // Redirect to the servlet if accessed directly (no data loaded)
    if (request.getAttribute("roomsList") == null) {
        response.sendRedirect(request.getContextPath() + "/rooms");
        return;
    }
    
    // Check for role-based visibility
    Integer roleId = (Integer) session.getAttribute("role_id");
    boolean canManageRooms = (roleId != null && roleId == 1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/Home/rooms.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- Room Management Section -->
<section class="room-management-section">
    <!-- Header -->
    <div class="room-header">
        <div class="header-content">
            <h1><i class="fas fa-bed"></i> Room Management</h1>
            <p class="header-subtitle">Manage hotel rooms, availability, and pricing</p>
        </div>
        <% if (canManageRooms) { %>
        <button class="btn-add-room" onclick="openAddRoomModal()">
            <i class="fas fa-plus"></i> Add Room
        </button>
        <% } %>
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

    <!-- Stats Cards section removed -->

    <!-- Filters -->
    <div class="filters-container">
        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" id="searchRoomInput" placeholder="Search by Room ID..." onkeyup="filterRooms()">
        </div>

    </div>

    <!-- Rooms Grid -->
    <div class="rooms-grid" id="roomsGrid">
        <%
            List<Map<String, Object>> roomsList = (List<Map<String, Object>>) request.getAttribute("roomsList");
            if (roomsList != null && !roomsList.isEmpty()) {
                for (Map<String, Object> room : roomsList) {
                    // Extract variables to avoid quoting issues in HTML attributes
                    int rId = (Integer) room.get("r_id");
                    String rRoomType = (String) room.get("r_room_type");
                    String rBedType = (String) room.get("r_bed_type");
                    String rAcType = (String) room.get("r_ac_type");
                    int rMaxMembers = (Integer) room.get("r_max_members");
                    String rView = (String) room.get("r_view");
                    String status = (String) room.get("r_status");
                    double rPrice = (Double) room.get("r_one_night_price");

                    String priceFormatted = String.format("LKR %,.0f", rPrice);
                    String rIdFormatted = String.format("R%03d", rId);
        %>
        <div class="room-card" data-status="<%= status.toLowerCase() %>" data-type="<%= rRoomType %>">
            <div class="room-header-row">
                <h3><%= rIdFormatted %></h3>
                <span class="status-badge available" onclick="openCalendar('<%= rId %>', '<%= rIdFormatted %>')" style="cursor: pointer;" title="View Availability"><i class="fas fa-calendar-alt"></i></span>
            </div>
            <p class="room-type"><%= rRoomType %> Room</p>
            <div class="room-details">
                <div class="detail-item">
                    <span>Bed Type:</span>
                    <span><%= rBedType %></span>
                </div>
                <div class="detail-item">
                    <span>AC:</span>
                    <span><%= rAcType %></span>
                </div>
                <div class="detail-item">
                    <span>Max Occupancy:</span>
                    <span><%= rMaxMembers %></span>
                </div>
                <div class="detail-item">
                    <span>View:</span>
                    <span><i class="fas fa-eye"></i> <%= rView %></span>
                </div>
            </div>
            <div class="room-footer">
                <span class="price-label">Price per night:</span>
                <span class="price-value"><%= priceFormatted %></span>
            </div>
            <% if (canManageRooms) { %>
            <div class="card-actions" style="display: flex; gap: 10px; margin-top: 15px; justify-content: flex-end; padding-top: 10px; border-top: 1px dashed #e2e8f0;">
                 <button 
                    onclick="handleEditClick(this)"
                    data-id="<%= rId %>"
                    data-type="<%= rRoomType %>"
                    data-bed="<%= rBedType %>"
                    data-ac="<%= rAcType %>"
                    data-max="<%= rMaxMembers %>"
                    data-view="<%= rView %>"
                    data-price="<%= rPrice %>"
                    class="btn-icon edit" style="background:none; border:none; color: #3b82f6; cursor: pointer; font-size: 1.1rem; padding: 5px; transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'" title="Edit Room"><i class="fas fa-pencil-alt"></i></button>
                 <button onclick="handleDeleteClick(this)" data-id="<%= rId %>" class="btn-icon delete" style="background:none; border:none; color: #ef4444; cursor: pointer; font-size: 1.1rem; padding: 5px; transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'" title="Delete Room"><i class="fas fa-trash"></i></button>
            </div>
            <% } %>
        </div>
        <%
                }
            } else {
        %>
            <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #64748B;">
                <i class="fas fa-bed" style="font-size: 48px; margin-bottom: 16px; opacity: 0.5;"></i>
                <p>No rooms found. <% if (canManageRooms) { %>Click "Add Room" to create one.<% } %></p>
            </div>
        <%
            }
        %>
    </div>

</section>

<!-- Add Room Modal -->
<div id="addRoomModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">Add New Room</h2>
            <span class="close" onclick="closeAddRoomModal()">&times;</span>
        </div>
        <form id="addRoomForm" onsubmit="addRoom(event)">
            <input type="hidden" id="roomId" name="r_id">
            <input type="hidden" id="formAction" name="action" value="add">
            <div class="form-grid">
                <div class="form-group">
                    <label>Room Type *</label>
                    <select id="roomType" required>
                        <option value="Single">Single</option>
                        <option value="Double">Double</option>
                        <option value="Deluxe">Deluxe</option>
                        <option value="Family">Family</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Bed Type *</label>
                    <select id="bedType" required>
                        <option value="Single">Single</option>
                        <option value="Double">Double</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>AC Type *</label>
                    <select id="acType" required>
                        <option value="AC">AC</option>
                        <option value="Non-AC">Non-AC</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Maximum Occupancy *</label>
                    <input type="number" id="maxOccupancy" min="1" value="1" required>
                </div>
                <div class="form-group">
                    <label>View *</label>
                    <select id="view" required>
                        <option value="Sea">Sea</option>
                        <option value="Garden">Garden</option>
                        <option value="City">City</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>One Night Price (LKR) *</label>
                    <input type="text" id="price" placeholder="e.g., 5000" required>
                </div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeAddRoomModal()">Cancel</button>
                <button type="submit" class="btn-submit" id="modalSubmitBtn">Add Room</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteRoomModal" class="modal">
    <div class="modal-content" style="max-width: 400px;">
        <div class="modal-header" style="background: linear-gradient(135deg, #EF4444 0%, #F87171 100%);">
            <h2>Confirm Delete</h2>
            <span class="close" onclick="closeDeleteModal()">&times;</span>
        </div>
        <div style="padding: 32px; text-align: center;">
            <i class="fas fa-exclamation-triangle" style="font-size: 48px; color: #EF4444; margin-bottom: 16px;"></i>
            <p style="color: #475569; margin-bottom: 24px; font-size: 16px;">Are you sure you want to delete this room? This action cannot be undone.</p>
            <input type="hidden" id="deleteRoomId">
            <div class="modal-actions" style="margin-top: 0;">
                <button type="button" class="btn-cancel" onclick="closeDeleteModal()">Cancel</button>
                <button type="button" class="btn-delete-confirm" onclick="confirmDeleteRoom()">Delete</button>
            </div>
        </div>
    </div>
</div>

<!-- Calendar Modal -->
<div id="calendarModal" class="modal">
    <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header">
            <h2 id="calendarTitle">Availability - Room</h2>
            <span class="close" onclick="closeCalendarModal()">&times;</span>
        </div>
        <div class="calendar-container">
            <div class="calendar-controls">
                <button onclick="changeMonth(-1)"><i class="fas fa-chevron-left"></i></button>
                <h3 id="currentMonthYear">October 2023</h3>
                <button onclick="changeMonth(1)"><i class="fas fa-chevron-right"></i></button>
            </div>
            <div class="calendar-grid-header">
                <div>Sun</div><div>Mon</div><div>Tue</div><div>Wed</div><div>Thu</div><div>Fri</div><div>Sat</div>
            </div>
            <div id="calendarDays" class="calendar-grid-days">
                <!-- Days will be generated here -->
            </div>
        </div>
    </div>
</div>

<!-- Toast Container -->
<div id="toastContainer" class="toast-container"></div>

<script>
    function filterRooms() {
        const searchText = document.getElementById('searchRoomInput').value.toLowerCase();
        const status = document.getElementById('statusFilter').value;
        const type = document.getElementById('typeFilter').value;
        
        const cards = document.querySelectorAll('.room-card');
        
        cards.forEach(card => {
            const roomNumber = card.querySelector('h3').textContent.toLowerCase();
            const cardStatus = card.getAttribute('data-status');
            const cardType = card.getAttribute('data-type');
            
            let matchesSearch = roomNumber.includes(searchText);
            let matchesStatus = status === 'all' || cardStatus === status;
            let matchesType = type === 'all' || cardType === type;
            
            if (matchesSearch && matchesStatus && matchesType) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function handleEditClick(btn) {
        const id = btn.getAttribute('data-id');
        const type = btn.getAttribute('data-type');
        const bed = btn.getAttribute('data-bed');
        const ac = btn.getAttribute('data-ac');
        const max = btn.getAttribute('data-max');
        const view = btn.getAttribute('data-view');
        const price = btn.getAttribute('data-price');
        
        openEditRoomModal(id, type, bed, ac, max, view, price);
    }

    function handleDeleteClick(btn) {
        const id = btn.getAttribute('data-id');
        document.getElementById('deleteRoomId').value = id;
        document.getElementById('deleteRoomModal').style.display = 'flex';
    }

    function closeDeleteModal() {
        document.getElementById('deleteRoomModal').style.display = 'none';
        document.getElementById('deleteRoomId').value = '';
    }

    function openAddRoomModal() {
        document.getElementById('addRoomModal').style.display = 'flex';
        document.getElementById('modalTitle').textContent = 'Add New Room';
        document.getElementById('modalSubmitBtn').textContent = 'Add Room';
        document.getElementById('formAction').value = 'add';
        document.getElementById('roomId').value = '';
        document.getElementById('addRoomForm').reset();
    }
    
    function openEditRoomModal(id, type, bed, ac, max, view, price) {
        document.getElementById('addRoomModal').style.display = 'flex';
        document.getElementById('modalTitle').textContent = 'Edit Room';
        document.getElementById('modalSubmitBtn').textContent = 'Update Room';
        document.getElementById('formAction').value = 'update';
        document.getElementById('roomId').value = id;
        
        document.getElementById('roomType').value = type;
        document.getElementById('bedType').value = bed;
        document.getElementById('acType').value = ac;
        document.getElementById('maxOccupancy').value = max;
        document.getElementById('view').value = view;
        document.getElementById('price').value = price;
    }
    
    function closeAddRoomModal() {
        document.getElementById('addRoomModal').style.display = 'none';
        document.getElementById('addRoomForm').reset();
        document.getElementById('formAction').value = 'add'; // Reset to default
    }
    
    function addRoom(e) {
        e.preventDefault();
        
        // Collect form data
        const action = document.getElementById('formAction').value;
        const roomId = document.getElementById('roomId').value;
        const roomType = document.getElementById('roomType').value;
        const bedType = document.getElementById('bedType').value;
        const acType = document.getElementById('acType').value;
        const maxOccupancy = document.getElementById('maxOccupancy').value;
        const view = document.getElementById('view').value;
        const price = document.getElementById('price').value;

        // Prepare data for sending
        const formData = new URLSearchParams();
        formData.append('action', action);
        if (roomId) formData.append('r_id', roomId);
        formData.append('roomType', roomType);
        formData.append('bedType', bedType);
        formData.append('acType', acType);
        formData.append('maxOccupancy', maxOccupancy);
        formData.append('view', view);
        formData.append('price', price);

        // Send AJAX request
        fetch('<%= request.getContextPath() %>/rooms', { 
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                showToast('success', data.message);
                closeAddRoomModal();
                setTimeout(() => location.reload(), 1500);
            } else {
                showToast('error', data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('error', 'An unexpected error occurred. Please try again.');
        });
    }
    
    function confirmDeleteRoom() {
        const id = document.getElementById('deleteRoomId').value;
        if (!id) return;

        const formData = new URLSearchParams();
        formData.append('action', 'delete');
        formData.append('r_id', id);
        
        fetch('<%= request.getContextPath() %>/rooms', { 
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                showToast('success', data.message);
                closeDeleteModal();
                setTimeout(() => location.reload(), 1500);
            } else {
                showToast('error', data.message);
                closeDeleteModal();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('error', 'An unexpected error occurred.');
            closeDeleteModal();
        });
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
        msgSpan.textContent = message || "No message provided"; // Safer text rendering
        
        // Assemble toast
        toast.appendChild(icon);
        toast.appendChild(msgSpan);
        
        // Add to container
        container.appendChild(toast);
        
        // Trigger reflow for animation
        void toast.offsetWidth;
        
        // Add animation class (though CSS handles animation via keyframes on .toast)
        toast.classList.add('show');
        
        // Remove after 3 seconds
        setTimeout(() => {
            toast.classList.add('hiding'); // Trigger fade out animation
            toast.addEventListener('animationend', () => {
                if (toast.parentNode === container) {
                    container.removeChild(toast);
                }
            });
        }, 3000);
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('addRoomModal');
        const deleteModal = document.getElementById('deleteRoomModal');
        const calendarModal = document.getElementById('calendarModal');
        if (event.target == modal) {
            closeAddRoomModal();
        }
        if (event.target == deleteModal) {
            closeDeleteModal();
        }
        if (event.target == calendarModal) {
            closeCalendarModal();
        }
    }

    // Calendar Variables
    let currentCalendarRoomId = null;
    let currentCalendarDate = new Date();

    function openCalendar(roomId, roomName) {
        currentCalendarRoomId = roomId;
        document.getElementById('calendarTitle').textContent = 'Availability - ' + roomName;
        document.getElementById('calendarModal').style.display = 'flex';
        
        // Reset to current month when opening
        currentCalendarDate = new Date();
        renderCalendar();
    }

    function closeCalendarModal() {
        document.getElementById('calendarModal').style.display = 'none';
    }

    function changeMonth(delta) {
        currentCalendarDate.setMonth(currentCalendarDate.getMonth() + delta);
        renderCalendar();
    }

    function renderCalendar() {
        const year = currentCalendarDate.getFullYear();
        const month = currentCalendarDate.getMonth(); // 0-11
        
        // Update header
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        document.getElementById('currentMonthYear').textContent = monthNames[month] + " " + year;
        
        const daysContainer = document.getElementById('calendarDays');
        daysContainer.innerHTML = '';
        
        const firstDay = new Date(year, month, 1).getDay();
        const daysInMonth = new Date(year, month + 1, 0).getDate();
        
        // Empty slots for previous month
        for (let i = 0; i < firstDay; i++) {
            const empty = document.createElement('div');
            empty.className = 'calendar-day empty';
            daysContainer.appendChild(empty);
        }
        
        // Days
        for (let day = 1; day <= daysInMonth; day++) {
            const dayEl = document.createElement('div');
            dayEl.className = 'calendar-day';
            dayEl.textContent = day;
            
            // Format date as yyyy-MM-dd for comparison
            const monthStr = String(month + 1).padStart(2, '0');
            const dayStr = String(day).padStart(2, '0');
            const dateStr = year + "-" + monthStr + "-" + dayStr;
            
            dayEl.setAttribute('data-date', dateStr);
            daysContainer.appendChild(dayEl);
        }
        
        // Fetch availability
        fetchAvailability(currentCalendarRoomId, year, month + 1);
    }

    function fetchAvailability(roomId, year, month) {
        // Call RoomAvailability servlet
        fetch('<%= request.getContextPath() %>/roomavailability?roomId=' + roomId + '&year=' + year + '&month=' + month)
            .then(response => response.json())
            .then(bookedDates => {
                // bookedDates is array of strings "yyyy-MM-dd"
                if (Array.isArray(bookedDates)) {
                    bookedDates.forEach(dateStr => {
                        const dayEl = document.querySelector('.calendar-day[data-date="' + dateStr + '"]');
                        if (dayEl) {
                            dayEl.classList.add('booked');
                        }
                    });
                }
            })
            .catch(error => console.error('Error fetching availability:', error));
    }
</script>
</body>
</html>
