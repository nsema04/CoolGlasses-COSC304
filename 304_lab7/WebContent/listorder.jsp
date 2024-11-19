<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses Order List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff; /* Light blue background */
            margin: 0;
            padding: 0;
        }

        h1 {
            color: #333;
            text-align: center;
            padding: 20px 0;
        }

        .container {
            max-width: 1000px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th {
            background-color: #007bff;
            color: white;
            padding: 10px;
        }

        td {
            padding: 10px;
            text-align: center;
        }

        .inner-table {
            width: 100%;
            margin-top: 10px;
        }

        .inner-table th {
            background-color: #007bff; /* Same blue as outer table */
            color: white;
        }

        .inner-table td {
            padding: 8px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Order List</h1>

        <%
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            } catch (ClassNotFoundException e) {
                out.println("<p>ClassNotFoundException: " + e + "</p>");
            }

            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            try (Connection con = DriverManager.getConnection(url, uid, pw);
                 Statement stmt = con.createStatement()) {

                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                String orders = "SELECT orderId, orderDate, customerId, totalAmount FROM ordersummary";
                out.println("<table>");
                out.println("<tr><th>Order ID</th><th>Order Date</th><th>Customer ID</th><th>Customer Name</th><th>Total Amount</th></tr>");
                ResultSet rst = stmt.executeQuery(orders);

                String customerInfo = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
                String prods = "SELECT * FROM orderproduct WHERE orderId = ?";

                while (rst.next()) {
                    int ordId = rst.getInt("orderId");
                    Date ordDate = rst.getDate("orderDate");
                    int custId = rst.getInt("customerId");
                    double totAmount = rst.getDouble("totalAmount");

                    try (PreparedStatement custInfo = con.prepareStatement(customerInfo);
                         PreparedStatement prodInfo = con.prepareStatement(prods)) {

                        custInfo.setInt(1, custId);
                        ResultSet rst2 = custInfo.executeQuery();
                        rst2.next();
                        String custName = rst2.getString("firstName") + " " + rst2.getString("lastName");

                        out.println("<tr>");
                        out.println("<td>" + ordId + "</td>");
                        out.println("<td>" + ordDate + "</td>");
                        out.println("<td>" + custId + "</td>");
                        out.println("<td>" + custName + "</td>");
                        out.println("<td>" + currFormat.format(totAmount) + "</td>");
                        out.println("</tr>");

                        prodInfo.setInt(1, ordId);
                        ResultSet rst3 = prodInfo.executeQuery();

                        out.println("<tr><td colspan='5'><table class='inner-table'>");
                        out.println("<tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");
                        while (rst3.next()) {
                            int prodId = rst3.getInt("productId");
                            int quant = rst3.getInt("quantity");
                            double price = rst3.getDouble("price");
                            out.println("<tr>");
                            out.println("<td>" + prodId + "</td>");
                            out.println("<td>" + quant + "</td>");
                            out.println("<td>" + currFormat.format(price) + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table></td></tr>");
                    }
                }

                out.println("</table>");
            } catch (SQLException e) {
                out.println("<p>Error querying the database: " + e + "</p>");
            }
        %>
    </div>
</body>
</html>
