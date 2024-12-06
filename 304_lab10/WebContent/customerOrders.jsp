<!DOCTYPE html>
<html>
<head>
<title>Your Orders</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }

    h3 {
        text-align: center;
        color: #333;
        margin-top: 20px;
    }

    table {
        width: 90%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: white;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    th, td {
        padding: 12px;
        text-align: left;
        border: 1px solid #ddd;
    }

    th {
        background-color: #4CAF50;
        color: white;
    }

    td {
        background-color: #f9f9f9;
    }

    tr:hover td {
        background-color: #e0e0e0;
    }

    .product-table {
        width: 100%;
        margin-top: 10px;
        border: none;
        background-color: #f9f9f9;
        box-shadow: none;
    }

    .product-table th, .product-table td {
        border: 1px solid #ddd;
        padding: 8px;
    }

    .product-table th {
        background-color: #f2f2f2;
        color: #333;
    }

    .back-btn {
        display: block;
        width: 200px;
        margin: 30px auto;
        padding: 10px;
        background-color: #4CAF50;
        color: white;
        border: none;
        text-align: center;
        font-size: 16px;
        cursor: pointer;
        text-decoration: none;
    }

    .back-btn:hover {
        background-color: #45a049;
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

<%

// TODO: Print Customer information

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
     Statement stmt = con.createStatement();) {
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    out.println("<h3>All Your Orders</h3>");
    String sql3 = "SELECT customerId FROM customer WHERE userId = ?";
    PreparedStatement pstmtY = con.prepareStatement(sql3);
    pstmtY.setString(1, userName);
    ResultSet rstY = pstmtY.executeQuery();
    rstY.next();
    int custIdY = rstY.getInt("customerId");
    String orders = "SELECT orderId, orderDate, customerId, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry FROM ordersummary WHERE customerId = ?";
    PreparedStatement pstmtZ = con.prepareStatement(orders);
    pstmtZ.setInt(1, custIdY);
    out.println("<table><tr><th>Order Date</th><th>Customer Name</th><th>Total Amount</th><th>Shipping Address</th><th>Shipping City</th><th>Shipping State</th><th>Shipping Postal Code</th><th>Shipping Country</th></tr>");
    ResultSet rst = pstmtZ.executeQuery();
    String customerInfo = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
    String prods = "SELECT OP.productId, OP.quantity, OP.price, P.productName " +
                   "FROM orderproduct OP JOIN product P ON OP.productId = P.productId " +
                   "WHERE orderId = ?";
    while (rst.next()) {
        int ordId = rst.getInt("orderId");
        Date ordDate = rst.getDate("orderDate");
        int custId = rst.getInt("customerId");
        double totAmount = rst.getDouble("totalAmount");
        String shiptoAddress = rst.getString("shiptoAddress");
        String shiptoCity = rst.getString("shiptoCity");
        String shiptoState = rst.getString("shiptoState");
        String shiptoPostalCode = rst.getString("shiptoPostalCode");
        String shiptoCountry = rst.getString("shiptoCountry");

        PreparedStatement custInfo = con.prepareStatement(customerInfo);
        PreparedStatement prodInfo = con.prepareStatement(prods);
        custInfo.setInt(1, custId);
        prodInfo.setInt(1, ordId);
        ResultSet rst2 = custInfo.executeQuery();
        rst2.next();
        String custname = rst2.getString("firstName") + " " + rst2.getString("lastName");
        rst2.close();

        out.println("<tr><td>" + ordDate + "</td><td>" + custname + "</td><td>" + currFormat.format(totAmount) + "</td>");
        out.println("<td>" + shiptoAddress + "</td><td>" + shiptoCity + "</td><td>" + shiptoState + "</td><td>" + shiptoPostalCode + "</td><td>" + shiptoCountry + "</td></tr>");

        ResultSet rst3 = prodInfo.executeQuery();
        out.println("<tr><td colspan=\"8\"><table class=\"product-table\"><tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
        while (rst3.next()) {
            int prodId = rst3.getInt("productId");
            String prodName = rst3.getString("productName");
            int quant = rst3.getInt("quantity");
            double price = rst3.getDouble("price");
            out.println("<tr><td>" + prodName + "</td><td>" + quant + "</td><td>" + currFormat.format(price) + "</td></tr>");
        }
        out.println("</table></td></tr>");

        rst3.close();
    }
    rst.close();

    out.println("</table>");

} catch (Exception e) {
    out.println("<h1>" + e.toString() + "</h1>");
}

// Make sure to close connection
%>

<!-- Back to Customer Page Button -->
<button class="back-btn" onclick="window.location.href='customer.jsp'">Back to Customer Page</button>

</body>
</html>
