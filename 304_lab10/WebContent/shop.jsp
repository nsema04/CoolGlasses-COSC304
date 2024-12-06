<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp" %> <!-- Include header.jsp -->

<!DOCTYPE html>
<html>
<head>
    <title>CoolGlasses - Shop</title>
    <style>
        /* General body and layout styling */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #87cefa, #ffffff);
            color: #333;
            height: 100%;
        }

        /* Header style */
        header {
            background-color: #3498db;
            color: white;
            padding: 15px 0;
            text-align: center;
            font-size: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 10;
        }

        /* Main container */
        .container {
            max-width: 900px;
            margin: 80px auto 50px auto; /* Adjusted for space below fixed header */
            padding: 40px;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: all 0.3s ease;
        }

        .container:hover {
            transform: scale(1.02);
        }

        h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        p {
            font-size: 1.4rem;
            margin-bottom: 30px;
            color: #666;
        }

        /* Button styling */
        .button {
            display: inline-block;
            padding: 15px 40px;
            font-size: 1.4rem;
            color: white;
            background-color: #3498db;
            border: none;
            border-radius: 25px;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .button:hover {
            background-color: #2980b9;
            transform: translateY(-3px);
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.3);
        }

        /* About Us section */
        #about {
            background-color: #f9f9f9;
            padding: 40px;
            text-align: center;
            margin-top: 50px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        #about h2 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        #about p {
            font-size: 1.3rem;
            color: #666;
            line-height: 1.8;
        }

        /* Footer styling */
        footer {
            margin-top: 50px;
            text-align: center;
            font-size: 1rem;
            color: #777;
            padding: 20px 0;
            background-color: #f1f1f1;
            border-top: 2px solid #ddd;
        }

        footer a {
            text-decoration: none;
            color: #3498db;
            font-weight: bold;
        }

        footer a:hover {
            color: #2980b9;
        }

        /* Carousel styling */
        .carousel {
            position: relative;
            max-width: 800px;
            margin: auto;
            text-align: center;
        }

        .carousel-container {
            display: flex;
            overflow: hidden;
            border-radius: 10px;
        }

        .carousel-item {
            flex: 0 0 100%;
            display: none;
            justify-content: center;
            align-items: center;
        }

        .carousel-item img {
            width: 100%;
            height: auto;
            border-radius: 10px;
        }

        .carousel-btn {
            position: absolute;
            top: 50%;
            z-index: 10;
            background-color: rgba(0, 0, 0, 0.5);
            color: white;
            font-size: 2rem;
            padding: 10px;
            border: none;
            cursor: pointer;
            transform: translateY(-50%);
        }

        .prev {
            left: 10px;
        }

        .next {
            right: 10px;
        }

        /* Adjusted logo size in main content */
        .logo img {
            width: 100%; /* Set the width to match the "Shop For" header */
            max-width: 300px; /* Adjust the max-width as needed */
            height: auto;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <header>
        <h1>Welcome to CoolGlasses</h1>
    </header>

    <!-- Carousel Section -->
    <div class="carousel">
        <h2>Featured Glasses</h2>
        <div class="carousel-container">
            <div class="carousel-item">
                <img src="img/1.jpg" alt="Glasses 1">
            </div>
            <div class="carousel-item">
                <img src="img/2.jpg" alt="Glasses 2">
            </div>
            <div class="carousel-item">
                <img src="img/test.png" alt="Glasses 3">
            </div>
        </div>
        <button class="carousel-btn prev" onclick="moveCarousel(-1)">&#10094;</button>
        <button class="carousel-btn next" onclick="moveCarousel(1)">&#10095;</button>
    </div>

    <script>
        let currentIndex = 0;
        const items = document.querySelectorAll('.carousel-item');
        const totalItems = items.length;

        function moveCarousel(direction) {
            currentIndex += direction;
            if (currentIndex < 0) currentIndex = totalItems - 1;
            if (currentIndex >= totalItems) currentIndex = 0;
            updateCarousel();
        }

        function updateCarousel() {
            items.forEach((item, index) => {
                item.style.display = (index === currentIndex) ? 'block' : 'none';
            });
        }

        updateCarousel(); // Initialize the carousel
    </script>

    <!-- Main Content -->
    <div class="container">
        <h1>Shop For</h1>
        <div class="logo"> <img src="img/logoMain.png" alt="CoolGlasses Main Logo"> </div>
        <p>Find the perfect eyewear for you! Whether you're looking for a classic style or something trendy, we have it all. Explore our collection now.</p>
        <a href="listprod.jsp" class="button">Shop Now</a>
    </div>    

    <!-- About Us Section -->
    <div id="about">
        <h2>About Us</h2>
        <p>At CoolGlasses, we believe in offering eyewear that blends style, comfort, and affordability. Our mission is to provide you with glasses that not only improve your vision but also reflect your personality. With a diverse range of styles, we cater to every taste whether you prefer a bold statement or a timeless look. We pride ourselves on quality, customer satisfaction, and a seamless shopping experience.</p>
        <p>We are committed to bringing you the best eyewear options, and our team is always here to help you find the perfect pair. Thank you for choosing CoolGlasses!</p>
    </div>

    <!-- Footer -->
    <footer>
        &copy; 2024 CoolGlasses Inc. | Designed with a vision for the future | <a href="#about">About Us</a>
    </footer>

</body>
</html>
