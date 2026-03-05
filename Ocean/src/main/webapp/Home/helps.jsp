<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="help-container">
    <!-- Header Section with Ocean Scene -->
    <div class="help-header">
        <div class="header-content">
            <h1><i class="fas fa-question-circle"></i> Help & User Guide</h1>
            <p class="header-subtitle">Complete guide for Ocean View Resort Management System</p>
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

    <!-- Quick Navigation Cards -->
    <div class="quick-nav">
        <div class="help-nav-grid">
            <div class="help-nav-card" onclick="scrollToSection('system-overview')">
                <div class="help-nav-icon"><i class="fas fa-desktop"></i></div>
                <h3>System Overview</h3>
            </div>
            <div class="help-nav-card" onclick="scrollToSection('guest-management')">
                <div class="help-nav-icon"><i class="fas fa-users"></i></div>
                <h3>Guest Management</h3>
            </div>
            <div class="help-nav-card" onclick="scrollToSection('room-management')">
                <div class="help-nav-icon"><i class="fas fa-bed"></i></div>
                <h3>Room Management</h3>
            </div>
            <div class="help-nav-card" onclick="scrollToSection('reservation-management')">
                <div class="help-nav-icon"><i class="fas fa-calendar-check"></i></div>
                <h3>Reservation Management</h3>
            </div>
            <div class="help-nav-card" onclick="scrollToSection('billing-management')">
                <div class="help-nav-icon"><i class="fas fa-file-invoice-dollar"></i></div>
                <h3>Billing Management</h3>
            </div>
        </div>
    </div>

    <!-- Help Sections -->
    <div class="help-sections">
        
        <!-- System Overview -->
        <div class="section-accordion" id="system-overview">
            <div class="accordion-header" onclick="toggleAccordion(this)">
                <div class="accordion-title">
                    <i class="fas fa-desktop"></i>
                    <h3>System Overview</h3>
                </div>
                <i class="fas fa-chevron-down accordion-icon"></i>
            </div>
            <div class="accordion-content">
                <div class="content-inner">
                    <div class="welcome-box">
                        <h4>Welcome to Ocean View Resort Management System</h4>
                        <p>This system helps you manage hotel reservations, guest information, room inventory, and billing efficiently. The system prevents booking conflicts and automates bill generation.</p>
                    </div>
                    
                    <div class="getting-started">
                        <h4><i class="fas fa-rocket"></i> Getting Started</h4>
                        <p>After logging in with your admin credentials, you will see the dashboard with four main sections:</p>
                        <div class="feature-grid">
                            <div class="feature-item">
                                <i class="fas fa-users"></i>
                                <strong>Guest Management</strong>
                                <span>Register and manage guest information</span>
                            </div>
                            <div class="feature-item">
                                <i class="fas fa-bed"></i>
                                <strong>Room Management</strong>
                                <span>View and manage room inventory</span>
                            </div>
                            <div class="feature-item">
                                <i class="fas fa-calendar-alt"></i>
                                <strong>Reservation Management</strong>
                                <span>Create and track bookings</span>
                            </div>
                            <div class="feature-item">
                                <i class="fas fa-file-invoice"></i>
                                <strong>Billing Management</strong>
                                <span>Generate and view invoices</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Guest Management -->
        <div class="section-accordion" id="guest-management">
            <div class="accordion-header" onclick="toggleAccordion(this)">
                <div class="accordion-title">
                    <i class="fas fa-users"></i>
                    <h3>Guest Management</h3>
                </div>
                <i class="fas fa-chevron-down accordion-icon"></i>
            </div>
            <div class="accordion-content">
                <div class="content-inner">
                    <div class="subsection">
                        <h4><i class="fas fa-user-plus"></i> Adding a New Guest</h4>
                        <p>To register a new guest in the system, follow these steps:</p>
                        <ol class="step-list">
                            <li>Click on <strong>"Guest Management"</strong> in the navigation menu</li>
                            <li>Click the <strong>"Add Guest"</strong> button in the top right corner</li>
                            <li>Fill in all required fields marked with an asterisk (*):
                                <ul class="nested-list">
                                    <li><strong>Guest ID:</strong> Enter a unique identifier (e.g., G001)</li>
                                    <li><strong>Name:</strong> Enter the guest's full name</li>
                                    <li><strong>Address:</strong> Enter the guest's complete address</li>
                                    <li><strong>NIC:</strong> Enter the National Identity Card number</li>
                                    <li><strong>Contact Number:</strong> Enter a valid phone number</li>
                                </ul>
                            </li>
                            <li>Click <strong>"Add Guest"</strong> to save the information</li>
                        </ol>
                    </div>

                    <div class="subsection">
                        <h4><i class="fas fa-search"></i> Searching for Guests</h4>
                        <p>Use the search bar at the top of the Guest Management page to quickly find guests by:</p>
                        <ul class="bullet-list">
                            <li>Guest ID</li>
                            <li>Guest Name</li>
                            <li>NIC Number</li>
                            <li>Contact Number</li>
                        </ul>
                    </div>

                    <div class="subsection">
                        <h4><i class="fas fa-eye"></i> Viewing Guest Details</h4>
                        <p>All registered guests are displayed in a table format showing their ID, name, address, NIC, and contact number. The total number of registered guests is displayed at the top.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Room Management -->
        <div class="section-accordion" id="room-management">
            <div class="accordion-header" onclick="toggleAccordion(this)">
                <div class="accordion-title">
                    <i class="fas fa-bed"></i>
                    <h3>Room Management</h3>
                </div>
                <i class="fas fa-chevron-down accordion-icon"></i>
            </div>
            <div class="accordion-content">
                <div class="content-inner">
                    <div class="subsection">
                        <h4><i class="fas fa-info-circle"></i> Understanding Room Information</h4>
                        <p>Each room in the system contains the following information:</p>
                        <ul class="detail-list">
                            <li><span class="label">Room ID:</span> Unique identifier for the room (e.g., R101)</li>
                            <li><span class="label">Room Type:</span> Single, Double, Deluxe, or Family</li>
                            <li><span class="label">Bed Type:</span> Single or Double bed</li>
                            <li><span class="label">AC Type:</span> AC or Non-AC</li>
                            <li><span class="label">Room Status:</span> Available or Booked</li>
                            <li><span class="label">Maximum Occupancy:</span> Number of guests the room can accommodate</li>
                            <li><span class="label">View:</span> Sea, Garden, or City view</li>
                            <li><span class="label">One Night Price:</span> Price per night in LKR</li>
                        </ul>
                    </div>

                    <div class="subsection">
                        <h4><i class="fas fa-plus-circle"></i> Adding a New Room</h4>
                        <p>To add a new room to the inventory:</p>
                        <ol class="step-list">
                            <li>Navigate to <strong>"Room Management"</strong></li>
                            <li>Click the <strong>"Add Room"</strong> button</li>
                            <li>Enter the Room ID (must be unique)</li>
                            <li>Select the Room Type, Bed Type, and AC Type</li>
                            <li>Set the Room Status (usually Available for new rooms)</li>
                            <li>Enter Maximum Occupancy and Select the View type</li>
                            <li>Enter the One Night Price in LKR</li>
                            <li>Click <strong>"Add Room"</strong> to save</li>
                        </ol>
                    </div>

                    <div class="subsection">
                        <h4><i class="fas fa-filter"></i> Searching and Filtering Rooms</h4>
                        <p>The Room Management page provides multiple ways to find rooms:</p>
                        <ul class="bullet-list">
                            <li><strong>Search Bar:</strong> Type a Room ID to search directly</li>
                            <li><strong>Status Filter:</strong> Show All, Available, or Booked rooms</li>
                            <li><strong>Room Type Filter:</strong> Filter by Single, Double, Deluxe, or Family rooms</li>
                        </ul>
                    </div>

                    <div class="subsection">
                        <h4><i class="fas fa-chart-pie"></i> Room Statistics</h4>
                        <div class="stats-preview">
                            <div class="stat-card">Total Rooms</div>
                            <div class="stat-card available">Available Rooms</div>
                            <div class="stat-card booked">Booked Rooms</div>
                        </div>
                    </div>

                    <div class="faq-section">
                        <h4>Frequently Asked Questions</h4>
                        <div class="faq-item">
                            <div class="question">How do I know which rooms are available?</div>
                            <div class="answer">Available rooms are displayed with a green background and "Available" badge. You can also use the status filter to show only available rooms.</div>
                        </div>
                        <div class="faq-item">
                            <div class="question">Can I change the room status manually?</div>
                            <div class="answer">Room status is automatically updated when a reservation is made. The system changes status from "Available" to "Booked" and back to "Available" when the guest checks out.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reservation Management -->
        <div class="section-accordion" id="reservation-management">
            <div class="accordion-header" onclick="toggleAccordion(this)">
                <div class="accordion-title">
                    <i class="fas fa-calendar-check"></i>
                    <h3>Reservation Management</h3>
                </div>
                <i class="fas fa-chevron-down accordion-icon"></i>
            </div>
            <div class="accordion-content">
                <div class="content-inner">
                    <div class="subsection">
                        <h4><i class="fas fa-calendar-plus"></i> Creating a New Reservation</h4>
                        <p>To book a room for a guest:</p>
                        <ol class="step-list">
                            <li>Go to <strong>"Reservation Management"</strong></li>
                            <li>Click <strong>"New Reservation"</strong> button (System generates a unique ID)</li>
                            <li>Select a Room ID from available rooms</li>
                            <li>Enter Customer Name, Address, and Contact Number</li>
                            <li>Select Check-In and Check-Out Dates (Check-out must be after check-in)</li>
                            <li>Review the automatically calculated number of nights</li>
                            <li>Click <strong>"Create Reservation"</strong> to confirm</li>
                        </ol>
                    </div>

                    <div class="info-box warning">
                        <h4><i class="fas fa-shield-alt"></i> Conflict Detection</h4>
                        <p>The system automatically prevents double bookings:</p>
                        <ul>
                            <li>When selecting dates, only rooms available for those dates are shown</li>
                            <li>If a room is already booked for overlapping dates, it won't appear in the room selection</li>
                            <li>The system checks both check-in and check-out dates to ensure no conflicts</li>
                        </ul>
                    </div>

                    <div class="subsection">
                        <h4><i class="fas fa-tasks"></i> Managing Reservations</h4>
                        <ul class="bullet-list">
                            <li>View all reservations in a table format</li>
                            <li>See reservation details including dates, room, and guest information</li>
                            <li>Filter by Active or Completed reservations</li>
                            <li>Search by Reservation ID or Customer Name</li>
                            <li>Check out guests when they leave</li>
                        </ul>
                    </div>

                    <div class="subsection">
                        <h4><i class="fas fa-sign-out-alt"></i> Check-Out Process</h4>
                        <p>When a guest leaves:</p>
                        <ol class="step-list">
                            <li>Find the reservation in the active reservations list</li>
                            <li>Click the <strong>"Check Out"</strong> button</li>
                            <li>The room status automatically changes to "Available"</li>
                            <li>The reservation status changes to "Completed"</li>
                            <li>A bill is automatically generated and can be viewed in Billing Management</li>
                        </ol>
                    </div>

                    <div class="faq-section">
                        <h4>Frequently Asked Questions</h4>
                        <div class="faq-item">
                            <div class="question">What happens if I try to book a room that's already reserved?</div>
                            <div class="answer">The system will not show that room in the available rooms list for overlapping dates. You can only select from rooms that are truly available for your specified check-in and check-out dates.</div>
                        </div>
                        <div class="faq-item">
                            <div class="question">Can I create a reservation for the same day check-in and check-out?</div>
                            <div class="answer">No, the check-out date must be at least one day after the check-in date. The system requires a minimum of one night stay.</div>
                        </div>
                        <div class="faq-item">
                            <div class="question">How do I cancel a reservation?</div>
                            <div class="answer">Currently, you can check out a guest early using the "Check Out" button. For cancellations, please contact your system administrator.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Billing Management -->
        <div class="section-accordion" id="billing-management">
            <div class="accordion-header" onclick="toggleAccordion(this)">
                <div class="accordion-title">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <h3>Billing Management</h3>
                </div>
                <i class="fas fa-chevron-down accordion-icon"></i>
            </div>
            <div class="accordion-content">
                <div class="content-inner">
                    <div class="welcome-box">
                        <p>Manage and view invoices generated from completed reservations.</p>
                    </div>
                    
                    <div class="faq-section">
                        <h4>Frequently Asked Questions</h4>
                        <div class="faq-item">
                            <div class="question">When are bills created?</div>
                            <div class="answer">Bills are automatically generated when you click "Check Out" for a reservation. You don't need to create them manually.</div>
                        </div>
                        <div class="faq-item">
                            <div class="question">Can I edit a bill after it's generated?</div>
                            <div class="answer">Bills are automatically calculated based on reservation data. For any corrections, please ensure the reservation information is accurate before checking out.</div>
                        </div>
                        <div class="faq-item">
                            <div class="question">How is the total price calculated?</div>
                            <div class="answer">Total Price = Number of Nights × One Night Price. The system calculates this automatically based on check-in/check-out dates and the room's nightly rate.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    (function() {
        // Scroll function
        window.scrollToSection = function(id) {
            const element = document.getElementById(id);
            if (element) {
                // Open the accordion if it's closed
                if (!element.classList.contains('active')) {
                    element.classList.add('active');
                }
                element.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        };

        // Accordion Toggle function
        window.toggleAccordion = function(header) {
            const item = header.parentElement;
            
            // Close other accordions
            document.querySelectorAll('.section-accordion').forEach(acc => {
                if (acc !== item) {
                    acc.classList.remove('active');
                }
            });

            // Toggle current
            item.classList.toggle('active');
        };
    })();
</script>