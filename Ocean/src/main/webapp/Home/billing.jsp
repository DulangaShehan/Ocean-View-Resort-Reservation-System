<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Redirect to Servlet if accessed directly
    if (request.getAttribute("billingList") == null) {
        response.sendRedirect(request.getContextPath() + "/billing");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Billing & Invoices - Ocean View Resort</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/Home/billing.css">
</head>
<body>

    <!-- Billing Section -->
    <section class="billing-section">
        <!-- Header (Matching Guests/Reservations Style) -->
        <div class="page-header">
            <div class="header-content">
                <h1><i class="fas fa-file-invoice-dollar"></i> Billing & Invoices</h1>
                <p class="header-subtitle">Manage payments and financial records</p>
            </div>
            <!-- Make Bill button removed -->
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

        <!-- Content Wrapper -->
        <div class="content-wrapper">
            <!-- Revenue Summary Card removed -->

            <!-- Search Bar -->
            <div class="search-container">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Search by invoice number, customer name, or reservation ID..." onkeyup="searchInvoices()">
                </div>
            </div>

            <!-- Invoices Table -->
            <div class="table-container">
                <table class="billing-table">
                    <thead>
                        <tr>
                            <th>INVOICE NO</th>
                            <th>GUEST NAME</th>
                            <th>RESERVATION ID</th>
                            <th>NIGHTS</th>
                            <th>RATE/NIGHT</th>
                            <th>TOTAL AMOUNT</th>
                            <th>ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody id="invoiceTableBody">
                        <% 
                        List<Map<String, String>> billingList = (List<Map<String, String>>) request.getAttribute("billingList");
                        if (billingList != null && !billingList.isEmpty()) {
                            for (Map<String, String> bill : billingList) {
                        %>
                        <tr>
                            <td class="id-cell"><%= bill.get("b_id") %></td>
                            <td class="name-cell"><%= bill.get("b_name") %></td>
                            <td class="res-id-cell"><%= bill.get("b_res_id") %></td>
                            <td><%= bill.get("b_night") %></td>
                            <td><%= bill.get("b_night_price") %></td>
                            <td class="amount-cell"><%= bill.get("b_total_price") %></td>
                            <td class="action-cell">
                                <button class="btn-pending" 
                                    data-invoice-no="<%= bill.get("b_id") %>"
                                    data-raw-id="<%= bill.get("raw_id") %>"
                                    data-res-id="<%= bill.get("b_res_id") %>"
                                    data-customer="<%= bill.get("b_name") %>"
                                    data-contact="<%= bill.get("res_contact") %>"
                                    data-checkin="<%= bill.get("res_check_in") %>"
                                    data-checkout="<%= bill.get("res_check_out") %>"
                                    data-room="<%= bill.get("res_room_id") %>"
                                    data-nights="<%= bill.get("b_night") %>"
                                    data-rate="<%= bill.get("b_night_price") %>"
                                    data-total="<%= bill.get("b_total_price") %>"
                                    onclick="openInvoiceModal(this)">
                                    <%= bill.get("b_status") %>
                                </button>
                            </td>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align:center;">No billing records found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- Invoice Modal -->
    <div id="invoiceModal" class="modal">
        <div class="modal-content invoice-paper">
            <!-- Modal Body (The Invoice) -->
            <div class="invoice-body">
                <!-- Header -->
                <div class="invoice-header">
                    <h2 class="company-name">Ocean View Resort</h2>
                    <p class="company-details">Beachside Hotel, Galle, Sri Lanka</p>
                    <p class="company-details">Tel: +94 91 234 5678 | Email: info@oceanviewresort.lk</p>
                </div>
                
                <div class="invoice-divider"></div>

                <!-- Invoice Meta -->
                <div class="invoice-meta-row">
                    <div class="meta-left">
                        <h3 class="invoice-title">INVOICE</h3>
                        <p>Invoice No: <span class="fw-bold" id="modalInvoiceNo">INV001</span></p>
                        <p>Date: <span class="fw-bold" id="modalDate">1/28/2026</span></p>
                    </div>
                    <div class="meta-right">
                        <p>Reservation ID:</p>
                        <p class="res-id-large" id="modalResId">RES001</p>
                    </div>
                </div>

                <!-- Bill To -->
                <div class="bill-to-box">
                    <p class="box-label">Bill To:</p>
                    <p class="customer-name-large" id="modalCustomer">Nimal Perera</p>
                    <p id="modalAddress">Galle, Sri Lanka</p>
                    <p>Contact: <span id="modalContact">0771234567</span></p>
                </div>

                <!-- Stay Details -->
                <div class="stay-details">
                    <p class="section-title">Stay Details:</p>
                    <div class="stay-grid">
                        <div class="stay-item">
                            <span class="label">Check-In:</span>
                            <span class="value" id="modalCheckIn">2026-01-25</span>
                        </div>
                        <div class="stay-item">
                            <span class="label">Check-Out:</span>
                            <span class="value" id="modalCheckOut">2026-01-28</span>
                        </div>
                        <div class="stay-item">
                            <span class="label">Room:</span>
                            <span class="value" id="modalRoom">R002</span>
                        </div>
                        <div class="stay-item">
                            <span class="label">Number of Nights:</span>
                            <span class="value" id="modalNights">3</span>
                        </div>
                    </div>
                </div>

                <!-- Invoice Items Table -->
                <table class="invoice-items-table">
                    <thead>
                        <tr>
                            <th class="text-left">Description</th>
                            <th class="text-center">Quantity</th>
                            <th class="text-right">Rate</th>
                            <th class="text-right">Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Room Accommodation</td>
                            <td class="text-center"><span id="modalNightsTable">3</span> nights</td>
                            <td class="text-right" id="modalRate">LKR 12,000</td>
                            <td class="text-right" id="modalAmount">LKR 36,000</td>
                        </tr>
                    </tbody>
                </table>

                <!-- Total -->
                <div class="invoice-total-section">
                    <div class="total-row">
                        <span class="total-label">Total Amount:</span>
                        <span class="total-value" id="modalTotal">LKR 36,000</span>
                    </div>
                </div>

                <!-- Footer -->
                <div class="invoice-footer">
                    <p>Thank you for choosing Ocean View Resort!</p>
                    <p class="sub-text">For any queries, please contact us at +94 91 234 5678</p>
                </div>
            </div>

            <!-- Modal Actions (Outside the paper usually, or at bottom) -->
            <div class="modal-actions-bar">
                <button class="btn-close-modal" onclick="closeInvoiceModal()">Close</button>
                <button class="btn-print" id="printBtn" onclick="printAndCheckout()"><i class="fas fa-download"></i> Print Invoice</button>
            </div>
        </div>
    </div>

    <!-- Make Bill Modal removed -->
    
    <!-- Toast Container -->
    <div id="toastContainer" class="toast-container"></div>

    <script>
        let currentBillingId = null;

        function openInvoiceModal(btn) {
            // Get data from button attributes
            const invoiceNo = btn.getAttribute('data-invoice-no');
            currentBillingId = btn.getAttribute('data-raw-id');
            const resId = btn.getAttribute('data-res-id');
            const customer = btn.getAttribute('data-customer');
            const contact = btn.getAttribute('data-contact');
            const checkin = btn.getAttribute('data-checkin');
            const checkout = btn.getAttribute('data-checkout');
            const room = btn.getAttribute('data-room');
            const nights = btn.getAttribute('data-nights');
            const rate = btn.getAttribute('data-rate');
            const total = btn.getAttribute('data-total');

            // Populate Modal Fields
            document.getElementById('modalInvoiceNo').innerText = invoiceNo;
            document.getElementById('modalResId').innerText = resId;
            document.getElementById('modalCustomer').innerText = customer;
            document.getElementById('modalContact').innerText = contact;
            
            // Current Date for Invoice Date
            const today = new Date();
            const dateStr = today.toLocaleDateString('en-US');
            document.getElementById('modalDate').innerText = dateStr;

            document.getElementById('modalCheckIn').innerText = checkin;
            document.getElementById('modalCheckOut').innerText = checkout;
            document.getElementById('modalRoom').innerText = room;
            document.getElementById('modalNights').innerText = nights;
            document.getElementById('modalNightsTable').innerText = nights;
            document.getElementById('modalRate').innerText = rate;
            document.getElementById('modalAmount').innerText = total;
            document.getElementById('modalTotal').innerText = total;

            document.getElementById('invoiceModal').style.display = 'flex';
        }

        function closeInvoiceModal() {
            document.getElementById('invoiceModal').style.display = 'none';
            currentBillingId = null;
        }
        
        function printAndCheckout() {
            if (!currentBillingId) return;
            
            // 1. Trigger Print
            window.print();
            
            // 2. Ask user if they want to finalize/checkout
            if (!confirm("Do you want to finalize this invoice and move it to history? This will free the room.")) {
                return;
            }
            
            const btn = document.getElementById('printBtn');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            btn.disabled = true;
            
            // 3. Call Backend to Checkout
            fetch('<%=request.getContextPath()%>/billing', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=checkout&b_id=' + currentBillingId
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    showToast('success', 'Checkout completed successfully!');
                    setTimeout(() => location.reload(), 2000);
                } else {
                    showToast('error', 'Error: ' + data.message);
                    btn.disabled = false;
                    btn.innerHTML = originalText;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('error', 'An error occurred during checkout.');
                btn.disabled = false;
                btn.innerHTML = originalText;
            });
        }
        
        function showToast(type, message) {
            const container = document.getElementById('toastContainer');
            if (!container) return; // Guard clause
            
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            
            const icon = document.createElement('i');
            icon.className = type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle';
            
            const msgSpan = document.createElement('span');
            msgSpan.className = 'toast-message';
            msgSpan.textContent = message;
            
            toast.appendChild(icon);
            toast.appendChild(msgSpan);
            container.appendChild(toast);
            
            // Add styles dynamically if not present
            if (!document.getElementById('toastStyles')) {
                const style = document.createElement('style');
                style.id = 'toastStyles';
                style.innerHTML = `
                    .toast-container { position: fixed; top: 20px; right: 20px; z-index: 10000; }
                    .toast { background: white; padding: 15px 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); margin-bottom: 10px; display: flex; align-items: center; gap: 10px; animation: slideIn 0.3s ease-out forwards; border-left: 5px solid #ccc; }
                    .toast.success { border-left-color: #10B981; }
                    .toast.success i { color: #10B981; }
                    .toast.error { border-left-color: #EF4444; }
                    .toast.error i { color: #EF4444; }
                    .toast.hiding { animation: fadeOut 0.3s ease-out forwards; }
                    @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
                    @keyframes fadeOut { to { transform: translateX(100%); opacity: 0; } }
                `;
                document.head.appendChild(style);
            }
            
            setTimeout(() => {
                toast.classList.add('hiding');
                toast.addEventListener('animationend', () => toast.remove());
            }, 3000);
        }

        function searchInvoices() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toUpperCase();
            const table = document.querySelector('.billing-table');
            const tr = table.getElementsByTagName('tr');

            for (let i = 1; i < tr.length; i++) {
                const tds = tr[i].getElementsByTagName('td');
                let txtValue = "";
                for(let j=0; j < tds.length - 1; j++) {
                    txtValue += tds[j].textContent || tds[j].innerText;
                }
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }

        // Close modal on outside click
        window.onclick = function(event) {
            const modal = document.getElementById('invoiceModal');
            if (event.target == modal) {
                closeInvoiceModal();
            }
        }
    </script>
</body>
</html>