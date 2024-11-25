<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
    // Get the order ID from the request parameters
    String order = request.getParameter("orderId");
    int orderId = Integer.parseInt(order);
    boolean valid = false;

    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // Start transaction (turn off auto-commit)
        con.setAutoCommit(false);

        // Check if the orderId exists in the orderSummary table
        String orderValidity = "SELECT * FROM orderSummary WHERE orderId = ?;";
        PreparedStatement pstmt = con.prepareStatement(orderValidity);
        pstmt.setInt(1, orderId);
        ResultSet rst = pstmt.executeQuery();

        if (!rst.next()) {
            out.println("<h3>Invalid Order Id</h3>");
        } else {
            valid = true;
        }

        if (valid) {
            // Retrieve all items in the order
            String sql = "SELECT OP.productId, OP.quantity, PI.quantity FROM orderproduct OP " +
                         "INNER JOIN productinventory PI ON OP.productId = PI.productId WHERE orderId = ?";
            PreparedStatement pstmt2 = con.prepareStatement(sql);
            pstmt2.setInt(1, orderId);
            ResultSet rst2 = pstmt2.executeQuery();
            boolean successful = true;

            // Check inventory for each product in the order
            while (rst2.next()) {
                int pid = rst2.getInt(1);
                int quantity = rst2.getInt(2);
                int inventory = rst2.getInt(3);
                if (inventory - quantity < 0) {
                    out.println("<h2>Shipment not done. Insufficient inventory for product id: " + pid + "</h2>");
                    successful = false;
                    con.rollback();  // Rollback transaction if inventory is insufficient
                    break;
                } else {
                    // Update inventory after successful verification
                    out.println("<h3>Ordered product: " + pid + " Qty: " + quantity + 
                                " Previous Quantity: " + inventory + " New Inventory: " + (inventory - quantity) + "</h3>");
                    String updateInventory = "UPDATE productInventory SET quantity = ? WHERE productId = ?";
                    PreparedStatement pstmt3 = con.prepareStatement(updateInventory);
                    pstmt3.setInt(1, inventory - quantity);
                    pstmt3.setInt(2, pid);
                    pstmt3.executeUpdate();
                }
            }

            if (successful) {
                // Create a new shipment record
                String orderDate = request.getParameter("orderDate");
                String addShipment = "INSERT INTO shipment(shipmentDate, warehouseId) VALUES (?, 1)";
                PreparedStatement pstmt4 = con.prepareStatement(addShipment);
                pstmt4.setString(1, orderDate);
                pstmt4.executeUpdate();
                out.println("<h2>Shipment processed successfully</h2>");
            }
        }

        // Commit the transaction if everything is successful
        con.commit();
        con.setAutoCommit(true);

    } catch (Exception e) {
        out.println("<p>" + e.toString() + "</p>");
    }
%>

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>

