<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            margin-top: 50px;
        }
        .sidebar {
            height: 100%;
            width: 250px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #343a40;
            padding-top: 20px;
        }
        .sidebar a {
            padding: 10px 15px;
            text-decoration: none;
            font-size: 18px;
            color: white;
            display: block;
            margin-bottom: 15px;
        }
        .sidebar a:hover {
            background-color: #575d63;
        }
        .main-content {
            margin-left: 260px;
            padding: 20px;
        }
        .card {
            margin-bottom: 20px;
        }
        .table th, .table td {
            text-align: center;
        }
        .btn {
            width: 100%;
        }
        .btn-success, .btn-primary, .btn-secondary, .btn-info {
            margin-top: 10px;
        }
        .chart-container {
            margin-top: 30px;
        }
    </style>
</head>
<body>

<!-- Sidebar Navigation -->
<div class="sidebar">
    <h2 class="text-white text-center">Admin Dashboard</h2>
    <a href="?action=view">View Customer List</a>
    <a href="?action=totalsales">View Total Sales</a>
    <a href="addProd.jsp">Add New Product</a>
    <a href="viewProducts.jsp">View Products</a>
	<a href="shop.jsp">Back to Home</a>
</div>

<!-- Main Content Area -->
<div class="main-content">
    <h1 class="text-center">Welcome to the Admin Panel</h1>
    <hr>

    <%
        String action = request.getParameter("action");

        if (action != null) {
            if (action.equals("view")) {
                // Show customer list
                String sql = "SELECT * FROM customer";
                try {
                    getConnection();
                    Statement stmt = con.createStatement();
                    stmt.execute("USE orders");

                    ResultSet rst = stmt.executeQuery(sql);
                    out.println("<h3>Customer List</h3>");
                    out.println("<div class=\"card\"><div class=\"card-body\">");
                    out.println("<table class=\"table table-striped\">");
                    out.println("<tr><th>Customer ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone Number</th><th>Address</th></tr>");

                    while (rst.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rst.getInt("customerId") + "</td>");
                        out.println("<td>" + rst.getString("firstName") + "</td>");
                        out.println("<td>" + rst.getString("lastName") + "</td>");
                        out.println("<td>" + rst.getString("email") + "</td>");
                        out.println("<td>" + rst.getString("phonenum") + "</td>");
                        out.println("<td>" + rst.getString("address") + ", " + rst.getString("city") + ", " + rst.getString("state") + ", " + rst.getString("postalCode") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table></div></div>");
                } catch (SQLException ex) {
                    out.println("Error: " + ex.getMessage());
                } finally {
                    closeConnection();
                }
            } else if (action.equals("totalsales")) {
                // Show full report of orders and total sales
                String sqlOrders = "SELECT o.orderId, o.orderDate, o.totalAmount, c.customerId, " +
                                   "CONCAT(c.firstName, ' ', c.lastName) AS customerName, c.email, c.phonenum, " +
                                   "c.address, c.city, c.state, c.postalCode " +
                                   "FROM ordersummary o " +
                                   "JOIN customer c ON o.customerId = c.customerId " +
                                   "ORDER BY o.orderDate DESC";
                String sqlTotalSales = "SELECT SUM(totalAmount) AS totalSales FROM ordersummary";

                try {
                    getConnection();
                    Statement stmt = con.createStatement();
                    stmt.execute("USE orders");

                    // Fetch and display all orders
                    ResultSet rstOrders = stmt.executeQuery(sqlOrders);
                    out.println("<h3>Orders Report</h3>");
                    out.println("<div class=\"card\"><div class=\"card-body\">");
                    out.println("<table class=\"table table-striped\">");
                    out.println("<tr>");
                    out.println("<th>Order ID</th><th>Order Date</th><th>Customer Name</th><th>Email</th><th>Phone Number</th>");
                    out.println("<th>Address</th><th>Total Amount</th>");
                    out.println("</tr>");

                    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
                    boolean hasOrders = false;
                    while (rstOrders.next()) {
                        hasOrders = true;
                        out.println("<tr>");
                        out.println("<td>" + rstOrders.getInt("orderId") + "</td>");
                        out.println("<td>" + rstOrders.getDate("orderDate") + "</td>");
                        out.println("<td>" + rstOrders.getString("customerName") + "</td>");
                        out.println("<td>" + rstOrders.getString("email") + "</td>");
                        out.println("<td>" + rstOrders.getString("phonenum") + "</td>");
                        out.println("<td>" + rstOrders.getString("address") + ", " + rstOrders.getString("city") + ", " + rstOrders.getString("state") + ", " + rstOrders.getString("postalCode") + "</td>");
                        out.println("<td>" + currencyFormat.format(rstOrders.getDouble("totalAmount")) + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table></div></div>");

                    if (!hasOrders) {
                        out.println("<p>No orders found in the system.</p>");
                    }

                    // Fetch and display total sales
                    ResultSet rstTotalSales = stmt.executeQuery(sqlTotalSales);
                    if (rstTotalSales.next()) {
                        double totalSales = rstTotalSales.getDouble("totalSales");
                        out.println("<h4>Total Sales: " + currencyFormat.format(totalSales) + "</h4>");
                    } else {
                        out.println("<h4>Total Sales: $0.00</h4>");
                    }

                    // Generate data for the graph
                    ResultSet rstGraph = stmt.executeQuery("SELECT orderDate, SUM(totalAmount) AS dailySales FROM ordersummary GROUP BY orderDate ORDER BY orderDate");
                    StringBuilder dates = new StringBuilder();
                    StringBuilder sales = new StringBuilder();
                    while (rstGraph.next()) {
                        dates.append("'").append(rstGraph.getDate("orderDate")).append("',");
                        sales.append(rstGraph.getDouble("dailySales")).append(",");
                    }
                    if (dates.length() > 0) dates.setLength(dates.length() - 1); 
                    if (sales.length() > 0) sales.setLength(sales.length() - 1);

                    // Add a canvas for Chart.js
                    out.println("<div class=\"chart-container\"><h3>Sales Over Time</h3>");
                    out.println("<canvas id=\"salesChart\" width=\"600\" height=\"400\"></canvas>");
                    out.println("<script src=\"https://cdn.jsdelivr.net/npm/chart.js\"></script>");
                    out.println("<script>");
                    out.println("const ctx = document.getElementById('salesChart').getContext('2d');");
                    out.println("const salesChart = new Chart(ctx, {");
                    out.println("    type: 'line',");
                    out.println("    data: {");
                    out.println("        labels: [" + dates.toString() + "],");
                    out.println("        datasets: [{");
                    out.println("            label: 'Daily Sales',");
                    out.println("            data: [" + sales.toString() + "],");
                    out.println("            borderColor: 'rgba(75, 192, 192, 1)',");
                    out.println("            backgroundColor: 'rgba(75, 192, 192, 0.2)',");
                    out.println("            borderWidth: 1");
                    out.println("        }]");
                    out.println("    },");
                    out.println("    options: {");
                    out.println("        scales: {");
                    out.println("            x: {");
                    out.println("                title: { display: true, text: 'Date' }");
                    out.println("            },");
                    out.println("            y: {");
                    out.println("                title: { display: true, text: 'Sales ($)' }");
                    out.println("            }");
                    out.println("        }");
                    out.println("    }");
                    out.println("});");
                    out.println("</script></div>");
                } catch (SQLException ex) {
                    out.println("Error: " + ex.getMessage());
                } finally {
                    closeConnection();
                }
            }
        }
    %>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
