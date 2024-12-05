<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="header.jsp" %> <!-- Include header.jsp -->

<!DOCTYPE html>
<html>
<head>
    <title>CoolGlasses - Shop</title>
    <style>
        /* Add your custom styles for the shop page here */
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #87cefa, #ffffff);
            color: #333;
        }

        /* Main container */
        .container {
            max-width: 900px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        h1 {
            font-size: 3rem;
            margin: 20px 0;
            color: #2c3e50;
        }

        p {
            font-size: 1.2rem;
            margin: 20px 0;
            color: #666;
        }

        .button {
            display: inline-block;
            padding: 15px 30px;
            margin: 20px;
            font-size: 1.2rem;
            color: white;
            background-color: #3498db;
            border: none;
            border-radius: 25px;
            text-decoration: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        .button:hover {
            background-color: #2980b9;
            transform: translateY(-3px);
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.3);
        }

        footer {
            margin-top: 50px;
            text-align: center;
            font-size: 0.9rem;
            color: #666;
        }
    </style>
</head>
<body>

    <!-- Main Content -->
    <div class="container">
        <h1>Shop for CoolGlasses</h1>
        <p>Find the perfect eyewear for you!</p>
        <!-- Add your products or shopping-related content here -->
    </div>

    <!-- Footer -->
    <footer>
        &copy; 2024 CoolGlasses Inc. | Designed with a vision for the future
    </footer>

</body>
</html>
