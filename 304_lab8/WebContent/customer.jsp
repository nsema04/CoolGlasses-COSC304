<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #333;
            color: white;
            padding: 20px;
            text-align: center;
        }

        h3 {
            color: #333;
            font-size: 1.8em;
        }

        table {
            width: 80%;
            margin: 30px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        td {
            background-color: #f9f9f9;
        }

        tr:hover td {
            background-color: #e2f2ff;
        }

        .error {
            color: red;
            text-align: center;
            font-size: 1.2em;
        }

        .footer {
            text-align: center;
            padding: 20px;
            background-color: #333;
            color: white;
            margin-top: 30px;
        }

        .back-button {
            display: block;
            width: 200px;
            margin: 20px auto;
            padding: 10px;
            text-align: center;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1.1em;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        /* Mobile responsive */
        @media screen and (max-width: 768px) {
            body {
                font-size: 14px;
            }

            h3 {
                font-size: 1.5em;
            }

            table, th, td {
                font-size: 14px;
            }

            table {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<header>
    <h1>Customer Profile</h1>
</header>

<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
    // Database connection parameters
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // SQL to fetch customer details based on userName
    String sql = "SELECT * FROM customer WHERE userId = ?";
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement pstmt = con.prepareStatement(sql)) {

        pstmt.setString(1, userName); // Set userName in the query
        ResultSet rst = pstmt.executeQuery();

        if (rst.next()) {
            out.println("<h3>Customer Profile</h3>");
            out.println("<table>");
            out.println("<tr><th>Id</th><td>" + rst.getString("customerId") + "</td></tr>");
            out.println("<tr><th>First Name</th><td>" + rst.getString("firstName") + "</td></tr>");
            out.println("<tr><th>Last Name</th><td>" + rst.getString("lastName") + "</td></tr>");
            out.println("<tr><th>Email</th><td>" + rst.getString("email") + "</td></tr>");
            out.println("<tr><th>Phone Number</th><td>" + rst.getString("phonenum") + "</td></tr>");
            out.println("<tr><th>Address</th><td>" + rst.getString("address") + "</td></tr>");
            out.println("<tr><th>City</th><td>" + rst.getString("city") + "</td></tr>");
            out.println("<tr><th>State</th><td>" + rst.getString("state") + "</td></tr>");
            out.println("<tr><th>Postal Code</th><td>" + rst.getString("postalCode") + "</td></tr>");
            out.println("<tr><th>Country</th><td>" + rst.getString("country") + "</td></tr>");
            out.println("<tr><th>UserId</th><td>" + rst.getString("userId") + "</td></tr>");
            out.println("</table>");
        } else {
            out.println("<p class='error'>No customer data found.</p>");
        }

    } catch (Exception e) {
        out.println("<div class='error'><h1>Error: " + e.getMessage() + "</h1></div>");
    }
%>

<!-- Back to Home Button -->
<a href="index.jsp" class="back-button">Back to Home</a>

<div class="footer">
    <p>&copy; 2024 CoolGlasses Store. All Rights Reserved.</p>
</div>

</body>
</html>
