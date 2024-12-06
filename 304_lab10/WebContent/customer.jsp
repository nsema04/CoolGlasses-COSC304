<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(to bottom, #f7f7f7, #e2e2e2);
            margin: 0;
            padding: 0;
            color: #333;
        }

        .container {
            width: 80%;
            max-width: 1200px;
            margin: 40px auto;
            background-color: #ffffff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        h3 {
            color: #2c3e50;
            text-align: center;
            font-size: 32px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        table th, table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        table th {
            background-color: #3498db;
            color: white;
            font-size: 16px;
        }

        table tr:nth-child(odd) {
            background-color: #f9f9f9;
        }

        table tr:hover {
            background-color: #ecf0f1;
        }

        .buttons-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }

        .btn {
            padding: 14px 28px;
            font-size: 16px;
            border: none;
            border-radius: 50px;
            background-color: #3498db;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn:hover {
            background-color: #2980b9;
            transform: translateY(-3px);
        }

        .btn:active {
            background-color: #1c5980;
            transform: translateY(0);
        }

        .btn i {
            font-size: 18px;
        }

    </style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
%>

<div class="container">
    <h3>Customer Profile</h3>

    <%
    // Print Customer information
    String sql = "select customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password FROM Customer WHERE userid = ?";

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try 
    {   
        getConnection();
        Statement stmt = con.createStatement(); 
        stmt.execute("USE orders");

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userName);    
        ResultSet rst = pstmt.executeQuery();
        
        if (rst.next())
        {
            out.println("<table>");
            out.println("<tr><th>Customer ID</th><td>"+rst.getString(1)+"</td></tr>");
            out.println("<tr><th>First Name</th><td>"+rst.getString(2)+"</td></tr>");
            out.println("<tr><th>Last Name</th><td>"+rst.getString(3)+"</td></tr>");
            out.println("<tr><th>Email</th><td>"+rst.getString(4)+"</td></tr>");
            out.println("<tr><th>Phone</th><td>"+rst.getString(5)+"</td></tr>");
            out.println("<tr><th>Address</th><td>"+rst.getString(6)+"</td></tr>");
            out.println("<tr><th>City</th><td>"+rst.getString(7)+"</td></tr>");
            out.println("<tr><th>State</th><td>"+rst.getString(8)+"</td></tr>");
            out.println("<tr><th>Postal Code</th><td>"+rst.getString(9)+"</td></tr>");
            out.println("<tr><th>Country</th><td>"+rst.getString(10)+"</td></tr>");
            out.println("<tr><th>User ID</th><td>"+rst.getString(11)+"</td></tr>");       
            out.println("</table>");
        }
    }
    catch (SQLException ex) 
    {   
        out.println(ex); 
    }
    finally
    {   
        closeConnection();    
    }
    %>

    <div class="buttons-container">
        <!-- Back to Home Button -->
        <button class="btn" onclick="window.location.href='shop.jsp'"><i class="fas fa-home"></i> Back to Home</button>

        <!-- Edit Account Button -->
        <button class="btn" onclick="window.location.href='editAccount.jsp'"><i class="fas fa-edit"></i> Edit Account</button>

        <!-- View My Orders Button -->
        <button class="btn" onclick="window.location.href='customerOrders.jsp'"><i class="fas fa-box"></i> View My Orders</button>
    </div>
</div>

</body>
</html>
