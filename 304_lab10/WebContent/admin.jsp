<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

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
                out.println("<table class=\"table\" border=\"1\">");
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
                out.println("</table>");
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
                out.println("<table class=\"table\" border=\"1\">");
                out.println("<tr>");
                out.println("<th>Order ID</th><th>Order Date</th><th>Customer Name</th><th>Email</th><th>Phone Number</th>");
                out.println("<th>Address</th><th>Total Amount</th>");
                out.println("</tr>");
                
                NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
                boolean hasOrders = false; // To track if orders exist
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
                out.println("</table>");

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
                if (dates.length() > 0) dates.setLength(dates.length() - 1); // Remove last comma
                if (sales.length() > 0) sales.setLength(sales.length() - 1);

                // Add a canvas for Chart.js
                out.println("<h3>Sales Over Time</h3>");
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
                out.println("</script>");

            } catch (SQLException ex) {
                out.println("Error: " + ex.getMessage());
            } finally {
                closeConnection();
            }
        }
    } else {
        // Display buttons to view the customer list or total sales
        out.println("<form method=\"get\">");
        out.println("<input type=\"hidden\" name=\"action\" value=\"view\">");
        out.println("<input type=\"submit\" value=\"View Customer List\" class=\"btn btn-primary\">");
        out.println("</form>");
        out.println("<form method=\"get\">");
        out.println("<input type=\"hidden\" name=\"action\" value=\"totalsales\">");
        out.println("<input type=\"submit\" value=\"View Total Sales\" class=\"btn btn-secondary\">");
        out.println("</form>");
		out.println("<form action=\"addProd.jsp\" method=\"get\">");
    	out.println("<input type=\"submit\" value=\"Add New Product\" class=\"btn btn-success\">");
    	out.println("</form>");
		out.println("<form action=\"viewProducts.jsp\" method=\"get\">");
		out.println("<input type=\"submit\" value=\"View Products\" class=\"btn btn-info\">");
		out.println("</form>");

    }
%>
