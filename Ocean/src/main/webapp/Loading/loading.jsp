<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Your Paradise Awaits</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Loading/loading.css?v=<%= System.currentTimeMillis() %>">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <div class="landing-container" id="landingContainer">
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

        <!-- Main Content -->
        <div class="content">
            <div class="resort-icon">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 3L2 12h3v8h6v-6h2v6h6v-8h3L12 3z"/>
                </svg>
            </div>
            <h1>
                <span class="wave-text" style="animation-delay: 0s">O</span><span class="wave-text" style="animation-delay: 0.1s">c</span><span class="wave-text" style="animation-delay: 0.2s">e</span><span class="wave-text" style="animation-delay: 0.3s">a</span><span class="wave-text" style="animation-delay: 0.4s">n</span>
                <span style="display: inline-block; width: 20px;"></span>
                <span class="wave-text" style="animation-delay: 0.5s">V</span><span class="wave-text" style="animation-delay: 0.6s">i</span><span class="wave-text" style="animation-delay: 0.7s">e</span><span class="wave-text" style="animation-delay: 0.8s">w</span>
                <span style="display: inline-block; width: 20px;"></span>
                <span class="wave-text" style="animation-delay: 0.9s">R</span><span class="wave-text" style="animation-delay: 1.0s">e</span><span class="wave-text" style="animation-delay: 1.1s">s</span><span class="wave-text" style="animation-delay: 1.2s">o</span><span class="wave-text" style="animation-delay: 1.3s">r</span><span class="wave-text" style="animation-delay: 1.4s">t</span>
            </h1>
            <p class="subtitle">Your Paradise Awaits in Galle</p>
            <button class="start-button" onclick="navigateToLogin()">
                <span>Discover Paradise →</span>
            </button>
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
        function navigateToLogin() {
            const container = document.getElementById('landingContainer');
            container.classList.add('fade-out');

            setTimeout(() => {
                window.location.href = '<%= request.getContextPath() %>/Login/login.jsp';
            }, 1000);
        }

        // Add smooth entrance animation
        window.addEventListener('load', function() {
            document.body.style.opacity = '0';
            setTimeout(() => {
                document.body.style.transition = 'opacity 0.8s ease-in';
                document.body.style.opacity = '1';
            }, 100);
        });
    </script>
</body>
</html>