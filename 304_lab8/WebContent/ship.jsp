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
    <title>CoolGlasses Shipment Processing</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
        header {
            background-color: #007BFF;
            color: white;
            padding: 15px 20px;
            text-align: center;
        }
        main {
            max-width: 800px;
            margin: 20px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h2, h3 {
            color: #007BFF;
        }
        a {
            text-decoration: none;
            color: #007BFF;
        }
        a:hover {
            text-decoration: underline;
        }
        .success {
            color: green;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table th, table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        table th {
            background-color: #f4f4f4;
        }
        .footer {
            text-align: center;
            margin: 20px 0;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <header>
        <h1>CoolGlasses Shipment Processing</h1>
    </header>
    <main>
        <%@ include file="header.jsp" %>

        <%
            String order = request.getParameter("orderId");
            int orderId = Integer.parseInt(order);
            boolean valid = false;

            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                con.setAutoCommit(false);

                String orderValidity = "SELECT * FROM orderSummary WHERE orderId = ?;";
                PreparedStatement pstmt = con.prepareStatement(orderValidity);
                pstmt.setInt(1, orderId);
                ResultSet rst = pstmt.executeQuery();

                if (!rst.next()) {
                    out.println("<h3 class='error'>Invalid Order Id</h3>");
                } else {
                    valid = true;
                }

                if (valid) {
                    String sql = "SELECT OP.productId, OP.quantity, PI.quantity FROM orderproduct OP " +
                                 "INNER JOIN productinventory PI ON OP.productId = PI.productId WHERE orderId = ?";
                    PreparedStatement pstmt2 = con.prepareStatement(sql);
                    pstmt2.setInt(1, orderId);
                    ResultSet rst2 = pstmt2.executeQuery();
                    boolean successful = true;

                    while (rst2.next()) {
                        int pid = rst2.getInt(1);
                        int quantity = rst2.getInt(2);
                        int inventory = rst2.getInt(3);
                        if (inventory - quantity < 0) {
                            out.println("<h3 class='error'>Shipment not done. Insufficient inventory for product id: " + pid + "</h3>");
                            successful = false;
                            con.rollback();
                            break;
                        } else {
                            out.println("<h3 class='success'>Ordered product: " + pid + " Qty: " + quantity +
                                        " Previous Quantity: " + inventory + " New Inventory: " + (inventory - quantity) + "</h3>");
                            String updateInventory = "UPDATE productInventory SET quantity = ? WHERE productId = ?";
                            PreparedStatement pstmt3 = con.prepareStatement(updateInventory);
                            pstmt3.setInt(1, inventory - quantity);
                            pstmt3.setInt(2, pid);
                            pstmt3.executeUpdate();
                        }
                    }

                    if (successful) {
                        String orderDate = request.getParameter("orderDate");
                        String addShipment = "INSERT INTO shipment(shipmentDate, warehouseId) VALUES (?, 1)";
                        PreparedStatement pstmt4 = con.prepareStatement(addShipment);
                        pstmt4.setString(1, orderDate);
                        pstmt4.executeUpdate();
                        out.println("<h3 class='success'>Shipment processed successfully</h3>");
                    }
                }

                con.commit();
                con.setAutoCommit(true);

            } catch (Exception e) {
                out.println("<p class='error'>" + e.toString() + "</p>");
            }
        %>

        <h2><a href="index.jsp">Back to Main Page</a></h2>
    </main>
    <footer class="footer">
        &copy; 2024 CoolGlasses
    </footer>
</body>
</html>

