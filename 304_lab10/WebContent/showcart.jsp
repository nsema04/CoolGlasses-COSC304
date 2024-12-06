<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart</title>
    <style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f7f7f7;
			margin: 0;
			padding: 0;
			color: #333;
		}
	
		h1 {
			text-align: center;
			color: #2c3e50;
		}
	
		table {
			width: 80%;
			margin: 20px auto;
			border-collapse: collapse;
			background-color: #fff;
			box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		}
	
		th, td {
			padding: 10px 15px;
			text-align: center;
			border: 1px solid #ddd;
		}
	
		th {
			background-color: #3498db;
			color: white;
		}
	
		td {
			background-color: #ecf0f1;
		}
	
		td a {
			color: #e74c3c;
			text-decoration: none;
		}
	
		.total-row {
			background-color: #f4f4f4;
			font-weight: bold;
		}
	
		.footer {
			text-align: center;
			margin: 20px 0;
			display: flex;
			flex-direction: column;
			align-items: center;
			gap: 20px; /* Space between the buttons */
		}
	
		.footer a {
			text-decoration: none;
			background-color: #3498db;
			color: white;
			padding: 12px 30px;
			font-size: 18px;
			border-radius: 5px;
			width: 200px; /* Fixed width for uniform buttons */
			text-align: center;
		}
	
		.footer a:hover {
			background-color: #2980b9;
		}
	
		.footer p {
			margin: 0;
			font-size: 16px;
		}
	</style>
</head>
<body>

<%
    // Get the current list of products from the session
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null) {
        out.println("<h1>Your shopping cart is empty!</h1>");
    } else {
        // Currency formatter for US locale
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

        out.println("<h1>Your Shopping Cart</h1>");
        out.print("<table>");
        out.println("<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

        double total = 0.0;
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();

        while (iterator.hasNext()) {
            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
            ArrayList<Object> product = entry.getValue();

            // Validate product size
            if (product.size() < 4) {
                out.println("<tr><td colspan='5' style='color: red;'>Invalid product data for product: " + product + "</td></tr>");
                continue;
            }

            out.print("<tr>");
            out.print("<td>" + product.get(0) + "</td>");
            out.print("<td>" + product.get(1) + "</td>");

            // Handle quantity
            int qty = 0;
            try {
                qty = Integer.parseInt(product.get(3).toString());
            } catch (Exception e) {
                out.println("<td colspan='5' style='color: red;'>Invalid quantity for product: " + product.get(0) + "</td>");
                continue;
            }

            // Handle price
            double pr = 0.0;
            try {
                pr = Double.parseDouble(product.get(2).toString());
            } catch (Exception e) {
                out.println("<td colspan='5' style='color: red;'>Invalid price for product: " + product.get(0) + "</td>");
                continue;
            }

            out.print("<td>" + qty + "</td>");
            out.print("<td>" + currFormat.format(pr) + "</td>");
            out.print("<td>" + currFormat.format(pr * qty) + "</td>");
            out.println("</tr>");

            total += pr * qty;
        }

        // Display order total
        out.println("<tr class='total-row'><td colspan='4' align='right'>Order Total</td><td>" + currFormat.format(total) + "</td></tr>");
        out.println("</table>");
    }
%>

<div class="footer">
    <% if (productList != null && !productList.isEmpty()) { %>
        <a href="checkout.jsp">Proceed to Checkout</a>
    <% } else { %>
        <p>Your cart is empty. Add some products first!</p>
    <% } %>

    <a href="listprod.jsp">Continue Shopping</a>
</div>

</body>
</html>
