<%@ page import="java.sql.*, java.text.NumberFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Sales Report</title>
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

        h1, h2 {
            font-size: 2em;
            margin: 0;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: center;
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

        .currency {
            font-weight: bold;
            color: #2c3e50;
        }

        .footer {
            text-align: center;
            padding: 20px;
            background-color: #333;
            color: white;
            margin-top: 30px;
        }

        .error {
            color: red;
            text-align: center;
            font-size: 1.2em;
        }

        .back-button {
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #007bff; /* Blue button */
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
            display: block;
            text-align: center;
            width: 200px;
            margin: 20px auto;
        }

        .back-button:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }

        /* Mobile responsive */
        @media screen and (max-width: 768px) {
            body {
                font-size: 14px;
            }

            h1, h2 {
                font-size: 1.5em;
            }

            table, th, td {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<header>
    <h1>Administrator Sales Report</h1>
    <h2>View Sales by Day</h2>
</header>

<div class="container">

    <%-- Include authentication and JDBC connection files --%>
    <%@ include file="auth.jsp" %>
    <%@ include file="jdbc.jsp" %>

    <%
        String sql = "SELECT CAST(orderDate AS DATE) AS day, SUM(totalAmount) " +
                        "FROM orderSummary " +
                        "GROUP BY CAST(orderDate AS DATE);";
        
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            // Execute SQL query
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rst = pstmt.executeQuery();

            // Output total order amounts by day
            out.println("<table>");
            out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");
            
            while (rst.next()) {
                Date orderDate = rst.getDate(1);
                double totalAmount = rst.getDouble(2);
                out.println("<tr><td>" + orderDate + "</td><td class='currency'>" + currFormat.format(totalAmount) + "</td></tr>");
            }

            out.println("</table>");
        } catch (Exception e) {
            out.println("<div class='error'><strong>Error:</strong> " + e.toString() + "</div>");
        }
    %>

    <button class="back-button" onclick="window.location.href='index.jsp';">Back to Home</button>

</div>

<div class="footer">
    <p>&copy; 2024 CoolGlasses Store. All Rights Reserved.</p>
</div>

</body>
</html>
