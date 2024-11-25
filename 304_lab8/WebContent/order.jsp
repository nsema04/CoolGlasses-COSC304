<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.sql.*, java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses Order Processing</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        .navbar {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-align: center;
        }
        .navbar .logo a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
        }
        h1, h2 {
            color: #2c3e50;
        }
        .order-summary {
            margin: 30px 0;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .order-summary table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .order-summary table, .order-summary th, .order-summary td {
            border: 1px solid #ddd;
        }
        .order-summary th, .order-summary td {
            padding: 12px;
            text-align: left;
        }
        .order-summary th {
            background-color: #007bff;
            color: white;
        }
        .order-summary tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .order-summary tr:hover {
            background-color: #f1f1f1;
        }
        .total-amount {
            font-size: 18px;
            font-weight: bold;
            margin-top: 20px;
        }
        .back-to-cart {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
        }
        .back-to-cart:hover {
            background-color: #007bff;
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="container">
        <div class="logo"><a href="listprod.jsp">Back To Shopping</a></div>
    </div>
</nav>

<%
    // Get customer id
    String custId = request.getParameter("customerId");
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try {
        // Load driver class
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();) {

        if (productList == null || productList.isEmpty()) {
            out.println("<h1>Error: Your shopping cart is empty.</h1>");
            out.println("<h1><a class='back-to-cart' href='showcart.jsp'>Back to Cart</a></h1>");
            return;
        }

        String userToId = "SELECT customerId, firstName, lastName FROM customer WHERE customerId = ?";
        PreparedStatement pstUser = con.prepareStatement(userToId);
        pstUser.setString(1, custId);
        ResultSet rstUser = pstUser.executeQuery();
        if (!rstUser.next()) {
            out.println("<h1>Error: Customer ID does not exist.</h1>");
            out.println("<h1><a class='back-to-cart' href='showcart.jsp'>Back to Cart</a></h1>");
            return;
        } 
        String custName = rstUser.getString("firstName") + " " + rstUser.getString("lastName");

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String timeStamp = now.format(formatter);

        String addOrder = "INSERT INTO ordersummary (customerId, orderDate) VALUES (?, ?)";
        PreparedStatement pst2 = con.prepareStatement(addOrder, Statement.RETURN_GENERATED_KEYS);
        pst2.setString(1, custId);
        pst2.setString(2, timeStamp);
        pst2.executeUpdate();
        ResultSet keys = pst2.getGeneratedKeys();
        keys.next();
        int orderId = keys.getInt(1);

        double totalAmount = 0;
        String productId = "";
        int qty = 0;
        double pr = 0;
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
        while (iterator.hasNext()) { 
            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
            ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
            productId = (String) product.get(0);
            String priceStr = product.get(2).toString();
            qty = (Integer) product.get(3);
            pr = Double.parseDouble(priceStr);

            String addOrderProduct = "INSERT INTO orderproduct (orderID, productId, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement pst3 = con.prepareStatement(addOrderProduct);
            pst3.setInt(1, orderId);
            pst3.setInt(2, Integer.parseInt(productId));
            pst3.setInt(3, qty);
            pst3.setDouble(4, pr);
            pst3.executeUpdate();
            
            totalAmount += pr * qty;
        }

        String updateAmount = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
        PreparedStatement pst4 = con.prepareStatement(updateAmount);
        pst4.setDouble(1, totalAmount);
        pst4.setInt(2, orderId);
        pst4.executeUpdate();

        out.println("<div class='order-summary'>");
        out.println("<h1>Your Order Summary</h1>");
        out.println("<h2>Order Summary</h2>");
        out.println("<table><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Total</th></tr>");
        iterator = productList.entrySet().iterator();
        while (iterator.hasNext()) { 
            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
            ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
            productId = (String) product.get(0);
            String productName = (String) product.get(1);
            qty = (Integer) product.get(3);
            pr = Double.parseDouble(product.get(2).toString());
            double subtotal = qty * pr;
            out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td>" + qty + "</td><td>" + currFormat.format(pr) + "</td><td>" + currFormat.format(subtotal) + "</td></tr>");
        }
        out.println("</table>");
        out.println("<div class='total-amount'>Total Amount: " + currFormat.format(totalAmount) + "</div>");
        out.println("<h1>Order completed. Will be shipped soon...</h1>");
        out.println("<h1>Your order reference number: " + orderId + "</h1>");
        out.println("<h1>Shipping to customer: " + custId + "</h1>");
        out.println("<h1>Name: " + custName + "</h1>");
        out.println("</div>");

        session.removeAttribute("productList");

    } catch (IndexOutOfBoundsException e) {
        out.println("<h1>This customer ID does not exist</h1>");
    } catch (SQLException e) {
        out.println("<h1>Error: " + e.getMessage() + "</h1>");
    }
%>
</body>
</html>
