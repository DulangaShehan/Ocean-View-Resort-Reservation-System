<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Dashboard</title>
    <link rel="stylesheet" href="home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        // Store active page in sessionStorage to persist across page reloads
        // Logic moved to main DOMContentLoaded listener for better coordination
    </script>
</head>
<body>

    <!-- Sidebar Navigation -->
    <nav class="sidebar">
        <div class="logo-container">
            <div class="logo-icon">
                <i class="fas fa-umbrella-beach"></i>
            </div>
            <div class="logo-text">
                <h2>Ocean View</h2>
                <p>Resort Management</p>
            </div>
        </div>

        <div class="nav-divider"></div>

        <ul class="nav-menu">
            <li class="nav-item active" data-tooltip="Dashboard">
                <a href="#" class="nav-link" data-page="dashboard.jsp" data-title="Dashboard Overview" data-css="dashboard.css">
                    <div class="nav-icon"><i class="fas fa-chart-pie"></i></div>
                    <span class="nav-label">Dashboard</span>
                    <div class="active-indicator"></div>
                </a>
            </li>
            <li class="nav-item" data-tooltip="Guests">
                <a href="#" class="nav-link" data-page="guests.jsp" data-title="Guest Management" data-css="guests.css">
                    <div class="nav-icon"><i class="fas fa-users"></i></div>
                    <span class="nav-label">Guests</span>
                    <div class="active-indicator"></div>
                </a>
            </li>
            <li class="nav-item" data-tooltip="Reservations">
                <a href="#" class="nav-link" data-page="reservations.jsp" data-title="Reservation Management" data-css="reservations.css">
                    <div class="nav-icon"><i class="fas fa-calendar-check"></i></div>
                    <span class="nav-label">Reservations</span>
                    <div class="active-indicator"></div>
                </a>
            </li>
            <li class="nav-item" data-tooltip="Rooms">
                <a href="#" class="nav-link" data-page="rooms.jsp" data-title="Room Management" data-css="rooms.css">
                    <div class="nav-icon"><i class="fas fa-bed"></i></div>
                    <span class="nav-label">Rooms</span>
                    <div class="active-indicator"></div>
                </a>
            </li>
            <li class="nav-item" data-tooltip="Billing">
                <a href="#" class="nav-link" data-page="billing.jsp" data-title="Billing Management" data-css="billing.css">
                    <div class="nav-icon"><i class="fas fa-file-invoice-dollar"></i></div>
                    <span class="nav-label">Billing</span>
                    <div class="active-indicator"></div>
                </a>
            </li>
            
                        <li class="nav-item" data-tooltip="Help & Guide">
                <a href="#" class="nav-link" data-page="helps.jsp" data-title="Help & User Guide" data-css="helps.css">
                    <div class="nav-icon"><i class="fas fa-question-circle"></i></div>
                    <span class="nav-label">Helps</span>
                    <div class="active-indicator"></div>
                </a>
            </li>
            
            
        </ul>

        <div class="nav-divider"></div>

        <div class="nav-footer">

            <div class="nav-item" data-tooltip="Logout">
                <a href="#" onclick="showLogoutModal(); return false;" class="nav-link logout-link">
                    <div class="nav-icon"><i class="fas fa-sign-out-alt"></i></div>
                    <span class="nav-label">Logout</span>
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content Wrapper -->
    <main class="main-content">

        <!-- Top Header Bar -->
        <header class="top-header">
            <div class="header-left">
                <button class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </button>
                <div class="header-title">
                    <h1 id="pageTitle">Dashboard Overview</h1>
                    <p class="breadcrumb" id="breadcrumb">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                        <i class="fas fa-chevron-right"></i>
                        <span>Dashboard</span>
                    </p>
                </div>
            </div>

            <div class="header-right">
                <div class="header-actions">
                    <button class="header-btn notification-btn">
                        <i class="fas fa-bell"></i>
                        <span class="badge">3</span>
                    </button>
                    <div class="user-profile">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="user-details">
                            <span class="user-name"><%= session.getAttribute("username") %></span>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Dynamic content area -->
        <div id="contentContainer">
            <jsp:include page="dashboard.jsp" />
        </div>

    </main>

    <!-- Add a placeholder for dynamic CSS loading -->
    <div id="dynamicCss"></div>

    <!-- Logout Confirmation Modal -->
    <div class="modal-overlay" id="logoutModal">
        <div class="modal-content">
            <div class="modal-icon">
                <i class="fas fa-sign-out-alt"></i>
            </div>
            <h3 class="modal-title">Sign Out</h3>
            <p class="modal-message">Are you sure you want to sign out?</p>
            <div class="modal-actions">
                <button class="modal-btn btn-cancel" onclick="hideLogoutModal()">Cancel</button>
                <button class="modal-btn btn-confirm" onclick="confirmLogout()">Confirm</button>
            </div>
        </div>
    </div>

    <script>
        // Modal functions
        function showLogoutModal() {
            document.getElementById('logoutModal').classList.add('active');
        }
        
        function hideLogoutModal() {
            document.getElementById('logoutModal').classList.remove('active');
        }
        
        function confirmLogout() {
            window.location.href = '<%= request.getContextPath() %>/logout';
        }
        
        // Close modal when clicking outside
        document.getElementById('logoutModal').addEventListener('click', function(e) {
            if (e.target === this) {
                hideLogoutModal();
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menuToggle');
            const sidebar = document.querySelector('.sidebar');
            const mainContent = document.querySelector('.main-content');
            const navLinks = document.querySelectorAll('.nav-link:not(.logout-link)');
            const pageTitle = document.getElementById('pageTitle');
            const breadcrumb = document.getElementById('breadcrumb');
            const contentContainer = document.getElementById('contentContainer');
            const dynamicCss = document.getElementById('dynamicCss');

            // Toggle sidebar
            if (menuToggle && sidebar && mainContent) {
                menuToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('collapsed');
                    mainContent.classList.toggle('expanded');
                });
            }

            // Handle Initial Load State
            const activePage = sessionStorage.getItem('activePage');
            if (activePage) {
                const activeLink = document.querySelector(`.nav-link[data-page="${activePage}"]`);
                if (activeLink) {
                    // Update Active State
                    document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
                    activeLink.parentElement.classList.add('active');

                    // Get metadata
                    const title = activeLink.getAttribute('data-title');
                    const cssFile = activeLink.getAttribute('data-css');
                    const pageName = title.replace(' Management', '').replace(' Overview', '');

                    // Update UI Text
                    pageTitle.textContent = title;
                    breadcrumb.innerHTML = `
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                        <i class="fas fa-chevron-right"></i>
                        <span>${pageName}</span>
                    `;

                    // Load Content and CSS
                    // Note: Content might technically be double-loaded if it's dashboard, 
                    // but this ensures consistency if the user was on another page.
                    loadPageContent(activePage);
                    loadPageCss(cssFile);
                }
            } else {
                // Default Load (Dashboard)
                // Content is already there via jsp:include, so we just ensure CSS is loaded
                loadPageCss('dashboard.css');
            }

            // Navigation click handler
            navLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    // Get page information
                    const page = this.getAttribute('data-page');
                    const title = this.getAttribute('data-title');
                    const cssFile = this.getAttribute('data-css');
                    const pageName = title.replace(' Management', '').replace(' Overview', '');
                    
                    // Store active page in sessionStorage
                    sessionStorage.setItem('activePage', page);
                    
                    // Remove active class from all nav items
                    document.querySelectorAll('.nav-item').forEach(item => {
                        item.classList.remove('active');
                    });
                    
                    // Add active class to clicked nav item
                    this.parentElement.classList.add('active');
                    
                    // Update title and breadcrumb
                    pageTitle.textContent = title;
                    breadcrumb.innerHTML = `
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                        <i class="fas fa-chevron-right"></i>
                        <span>${pageName}</span>
                    `;
                    
                    // Load page content via AJAX
                    loadPageContent(page);
                    
                    // Load page-specific CSS
                    loadPageCss(cssFile);
                    
                    // Update URL without reloading
                    history.pushState({page: page, title: title, css: cssFile}, title, `?page=${page}`);
                });
            });

            // Function to load page content
            function loadPageContent(page) {
                fetch(page)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.text();
                    })
                    .then(html => {
                        contentContainer.innerHTML = html;
                        
                        // Execute scripts found in the content
                        const scripts = contentContainer.querySelectorAll('script');
                        scripts.forEach(script => {
                            const newScript = document.createElement('script');
                            if (script.src) {
                                newScript.src = script.src;
                            } else {
                                newScript.textContent = script.textContent;
                            }
                            document.body.appendChild(newScript);
                        });
                        
                        // Reinitialize any scripts if needed
                        initializePageScripts();
                        
                        // Optional: entrance animation for content
                        contentContainer.style.opacity = '0';
                        contentContainer.style.transform = 'translateY(20px)';
                        
                        setTimeout(() => {
                            contentContainer.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                            contentContainer.style.opacity = '1';
                            contentContainer.style.transform = 'none'; // Set to none to prevent fixed position issues
                        }, 100);
                    })
                    .catch(error => {
                        console.error('Error loading page:', error);
                        contentContainer.innerHTML = `
                            <div class="error-message">
                                <i class="fas fa-exclamation-triangle"></i>
                                <h3>Error Loading Content</h3>
                                <p>Unable to load the requested page. Please try again.</p>
                            </div>
                        `;
                    });
            }

            // Function to load page-specific CSS
            function loadPageCss(cssFile) {
                // Remove any existing dynamic CSS
                const existingCss = document.querySelector('link[data-dynamic="true"]');
                if (existingCss) {
                    existingCss.remove();
                }
                
                // Add new CSS
                if (cssFile) {
                    // Avoid re-adding home.css if passed, but allow others
                    if (cssFile === 'home.css') return;

                    const link = document.createElement('link');
                    link.rel = 'stylesheet';
                    // Add timestamp to force reload and bypass cache
                    link.href = cssFile + '?v=' + new Date().getTime();
                    link.setAttribute('data-dynamic', 'true');
                    document.head.appendChild(link);
                }
            }

            // Function to initialize page-specific scripts
            function initializePageScripts() {
                // Add entrance animation for stat cards if they exist
                const statCards = document.querySelectorAll('.stat-card');
                if (statCards.length > 0) {
                    statCards.forEach((card, index) => {
                        card.style.opacity = '0';
                        card.style.transform = 'translateY(20px)';
                        
                        setTimeout(() => {
                            card.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                            card.style.opacity = '1';
                            card.style.transform = 'translateY(0)';
                        }, index * 100);
                    });
                }
                
                // Initialize any interactive elements
                initializeInteractiveElements();
            }

            // Function to initialize interactive elements
            function initializeInteractiveElements() {
                // Add click handlers for buttons, tabs, etc.
                const interactiveButtons = document.querySelectorAll('.btn, .action-btn, .tab-btn');
                interactiveButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        this.style.transform = 'scale(0.95)';
                        setTimeout(() => {
                            this.style.transform = 'scale(1)';
                        }, 150);
                    });
                });
            }

            // Handle browser back/forward buttons
            window.addEventListener('popstate', function(event) {
                if (event.state) {
                    const { page, title, css } = event.state;
                    pageTitle.textContent = title;
                    loadPageContent(page);
                    loadPageCss(css);
                    
                    // Update active state
                    document.querySelectorAll('.nav-item').forEach(item => {
                        item.classList.remove('active');
                    });
                    
                    const activeLink = document.querySelector(`.nav-link[data-page="${page}"]`);
                    if (activeLink) {
                        activeLink.parentElement.classList.add('active');
                        sessionStorage.setItem('activePage', page);
                    }
                }
            });

            // Optional: entrance animation for initial stat cards
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>

</body>
</html>