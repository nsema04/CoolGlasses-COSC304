<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses Online Store</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff; /* Light blue background */
            margin: 0;
            padding: 0;
        }

        h1, h2 {
            color: #333; /* Darker text for contrast */
        }

        h1 {
            margin-top: 20px;
        }

        .center {
            text-align: center;
        }

        a {
            display: inline-block;
            margin: 10px 0;
            padding: 10px 20px;
            text-decoration: none;
            font-size: 18px;
            color: white;
            background-color: #007bff; /* Blue button */
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        a:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="center">Welcome to CoolGlasses Glasses Company</h1>

        <div class="center">
            <h2><a href="login.jsp">Login</a></h2>
            <h2><a href="listprod.jsp">Begin Shopping</a></h2>
            <h2><a href="listorder.jsp">List All Orders</a></h2>
            <h2><a href="customer.jsp">Customer Info</a></h2>
            <h2><a href="admin.jsp">Administrators</a></h2>
            <h2><a href="logout.jsp">Log out</a></h2>
        </div>

        <!-- JSP code to check if the user is authenticated -->
        <%
            String userName = (String) session.getAttribute("authenticatedUser");
            if (userName != null) {
        %>
            <h3 class="center">Signed in as: <%= userName %></h3>
        <%
            }
        %>

        <h4 class="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>
        <h4 class="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>
    </div>
</body>
</html>
