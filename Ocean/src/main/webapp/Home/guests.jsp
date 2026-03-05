<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    // Ensure we go through the controller to get data
    if (request.getAttribute("guestList") == null) {
        response.sendRedirect(request.getContextPath() + "/guests");
        return;
    }
%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/Home/guests.css?v=1.5">

<!-- Guest Management Section -->
<section class="guest-management-section">
    <div class="guest-header">
        <div class="header-content">
            <h1><i class="fas fa-umbrella-beach"></i> Guest Management</h1>
            <p class="header-subtitle">Manage your resort guests with ease</p>
        </div>
        <button class="btn-add-guest" onclick="openAddGuestModal()">
            <i class="fas fa-plus"></i> Add New Guest
        </button>
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
            <input type="text" id="searchInput" placeholder="Search by name, NIC, or contact number..." onkeyup="searchGuests()">
        </div>
    </div>

    <!-- Guest Table -->
    <div class="table-container">
        <table class="guest-table">
            <thead>
                <tr>
                    <th>GUEST ID</th>
                    <th>NAME</th>
                    <th>ADDRESS</th>
                    <th>NIC</th>
                    <th>CONTACT NUMBER</th>
                    <th>ACTIONS</th>
                </tr>
            </thead>
            <tbody id="guestTableBody">
                <%
                    List<Map<String, String>> guestList = (List<Map<String, String>>) request.getAttribute("guestList");
                    if (guestList != null && !guestList.isEmpty()) {
                        for (Map<String, String> guest : guestList) {
                %>
                <tr>
                    <td><%= guest.get("formattedId") %></td>
                    <td><%= guest.get("name") %></td>
                    <td><%= guest.get("address") %></td>
                    <td><%= guest.get("nic") %></td>
                    <td><%= guest.get("contact") %></td>
                    <td class="action-buttons">
                        <button class="btn-edit" 
                            data-id="<%= guest.get("id") %>"
                            data-name="<%= guest.get("name") %>"
                            data-address="<%= guest.get("address") %>"
                            data-nic="<%= guest.get("nic") %>"
                            data-contact="<%= guest.get("contact") %>"
                            onclick="openEditGuestModal(this)" title="Edit">
                            <i class="fas fa-pen"></i>
                        </button>
                        <button class="btn-delete" data-id="<%= guest.get("id") %>" onclick="deleteGuest(this.getAttribute('data-id'))" title="Delete">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6" style="text-align:center;">No guests found.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</section>

<!-- Add Guest Modal -->
<div id="addGuestModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Add New Guest</h2>
            <span class="close" onclick="closeAddGuestModal()"><i class="fas fa-times"></i></span>
        </div>
        <form id="addGuestForm" onsubmit="addGuest(event)">
            <div class="form-group">
                <label for="addName">Name <span class="required">*</span></label>
                <input type="text" id="addName" name="name" required>
            </div>

            <div class="form-group">
                <label for="addAddress">Address <span class="required">*</span></label>
                <textarea id="addAddress" name="address" rows="3" required></textarea>
            </div>

            <div class="form-group">
                <label for="addNIC">NIC <span class="required">*</span></label>
                <input type="text" id="addNIC" name="nic" required>
            </div>

            <div class="form-group">
                <label for="addContact">Contact Number <span class="required">*</span></label>
                <input type="text" id="addContact" name="contact" required>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeAddGuestModal()">Cancel</button>
                <button type="submit" class="btn-submit">Add Guest</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Guest Modal -->
<div id="editGuestModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Edit Guest</h2>
            <span class="close" onclick="closeEditGuestModal()"><i class="fas fa-times"></i></span>
        </div>
        <form id="editGuestForm" onsubmit="updateGuest(event)">
            <input type="hidden" id="editGuestId">
            
            <div class="form-group">
                <label for="editName">Name <span class="required">*</span></label>
                <input type="text" id="editName" name="name" required>
            </div>

            <div class="form-group">
                <label for="editAddress">Address <span class="required">*</span></label>
                <textarea id="editAddress" name="address" rows="3" required></textarea>
            </div>

            <div class="form-group">
                <label for="editNIC">NIC <span class="required">*</span></label>
                <input type="text" id="editNIC" name="nic" required>
            </div>

            <div class="form-group">
                <label for="editContact">Contact Number <span class="required">*</span></label>
                <input type="text" id="editContact" name="contact" required>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-cancel" onclick="closeEditGuestModal()">Cancel</button>
                <button type="submit" class="btn-submit">Update Guest</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteGuestModal" class="modal">
    <div class="modal-content confirmation-modal">
        <div class="modal-icon">
            <i class="fas fa-trash-alt"></i>
        </div>
        <h3 class="modal-title">Delete Guest</h3>
        <p class="modal-message">Are you sure you want to delete this guest? This action cannot be undone.</p>
        <div class="modal-actions">
            <button class="btn-cancel" onclick="closeDeleteGuestModal()">Cancel</button>
            <button class="btn-submit btn-delete-confirm" onclick="confirmDeleteGuest()">Delete</button>
        </div>
    </div>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<script>
// Global variable to store guest ID for deletion
var guestToDelete = null;

// Toast Function
function showToast(message, type) {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            
            // Create message span safely
            const msgSpan = document.createElement('span');
            msgSpan.textContent = message || "No message provided";
            
            // Create close icon
            const closeSpan = document.createElement('span');
            closeSpan.className = "close-icon";
            closeSpan.innerHTML = '<i class="fas fa-times"></i>';
            closeSpan.onclick = function() { this.parentElement.remove(); };
            
            toast.appendChild(msgSpan);
            toast.appendChild(closeSpan);
            
            container.appendChild(toast);

            // Remove after 3 seconds (increased for visibility)
            setTimeout(() => {
                if (toast.parentElement) {
                    toast.classList.add('hiding');
                    toast.addEventListener('animationend', () => toast.remove());
                }
            }, 3000);
        }

// Open Add Guest Modal
function openAddGuestModal() {
    document.getElementById('addGuestModal').style.display = 'flex';
    document.getElementById('addGuestForm').reset();
}

// Close Add Guest Modal
function closeAddGuestModal() {
    document.getElementById('addGuestModal').style.display = 'none';
}

// Open Edit Guest Modal
function openEditGuestModal(button) {
    document.getElementById('editGuestModal').style.display = 'flex';
    document.getElementById('editGuestId').value = button.getAttribute('data-id');
    document.getElementById('editName').value = button.getAttribute('data-name');
    document.getElementById('editAddress').value = button.getAttribute('data-address');
    document.getElementById('editNIC').value = button.getAttribute('data-nic');
    document.getElementById('editContact').value = button.getAttribute('data-contact');
}

// Close Edit Guest Modal
function closeEditGuestModal() {
    document.getElementById('editGuestModal').style.display = 'none';
}

// Close modal when clicking outside
window.onclick = function(event) {
    const addModal = document.getElementById('addGuestModal');
    const editModal = document.getElementById('editGuestModal');
    if (event.target == addModal) {
        closeAddGuestModal();
    }
    if (event.target == editModal) {
        closeEditGuestModal();
    }
}

// Add Guest Function
function addGuest(event) {
    event.preventDefault();
    
    const form = document.getElementById('addGuestForm');
    const formData = new FormData(form);
    const data = new URLSearchParams(formData);
    data.append('action', 'add');

    fetch('<%=request.getContextPath()%>/guests', {
        method: 'POST',
        body: data
    })
    .then(response => response.json())
    .then(result => {
        if (result.status === 'success') {
            showToast(result.message, 'success');
            closeAddGuestModal();
            form.reset();
            setTimeout(() => location.reload(), 2000);
        } else {
            showToast(result.message, 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('An unexpected error occurred. Please try again.', 'error');
    });
}

// Update Guest Function
function updateGuest(event) {
    event.preventDefault();
    const guestId = document.getElementById('editGuestId').value;
    const form = document.getElementById('editGuestForm');
    const formData = new FormData(form);
    const data = new URLSearchParams(formData);
    data.append('action', 'update');
    data.append('id', guestId);

    fetch('<%=request.getContextPath()%>/guests', {
        method: 'POST',
        body: data
    })
    .then(response => response.json())
    .then(result => {
        if (result.status === 'success') {
            showToast(result.message, 'success');
            closeEditGuestModal();
            setTimeout(() => location.reload(), 2000);
        } else {
            showToast(result.message, 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('An unexpected error occurred.', 'error');
    });
}

// Delete Guest Function
function deleteGuest(guestId) {
    guestToDelete = guestId;
    document.getElementById('deleteGuestModal').style.display = 'flex';
}

// Close Delete Guest Modal
function closeDeleteGuestModal() {
    document.getElementById('deleteGuestModal').style.display = 'none';
    guestToDelete = null;
}

// Confirm Delete Guest Function
function confirmDeleteGuest() {
    if (guestToDelete) {
        const data = new URLSearchParams();
        data.append('action', 'delete');
        data.append('id', guestToDelete);

        fetch('<%=request.getContextPath()%>/guests', {
            method: 'POST',
            body: data
        })
        .then(response => response.json())
        .then(result => {
            if (result.status === 'success') {
                showToast(result.message, 'success');
                closeDeleteGuestModal();
                setTimeout(() => location.reload(), 2000);
            } else {
                showToast(result.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('An unexpected error occurred.', 'error');
        });
    }
}

// Search Guests Function
function searchGuests() {
    const input = document.getElementById('searchInput');
    const filter = input.value.toLowerCase();
    const table = document.getElementById('guestTableBody');
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
</script>