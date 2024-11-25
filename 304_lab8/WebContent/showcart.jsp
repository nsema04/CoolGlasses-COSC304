<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }

        h1, h2 {
            text-align: center;
            color: #007bff;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: left;
        }

        table th, table td {
            padding: 10px;
            border: 1px solid #ccc;
        }

        table th {
            background-color: #007bff;
            color: white;
        }

        table td {
            text-align: right;
        }

        table td:nth-child(1), table td:nth-child(2) {
            text-align: left;
        }

        a {
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            text-align: center;
        }

        a:hover {
            background-color: #0056b3;
        }

        .actions {
            text-align: center;
            margin: 20px;
        }
    </style>
</head>
<body>

<%
// Retrieve the current list of products from the session
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null || productList.isEmpty()) {
    out.println("<h1>Your shopping cart is empty!</h1>");
} else {
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    out.println("<h1>Your Shopping Cart</h1>");
    out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
    out.println("<th>Price</th><th>Subtotal</th></tr>");

    double total = 0;
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();

    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();

        if (product.size() < 4) {
            out.println("<tr><td colspan='5' style='color:red;'>Invalid product entry: " + product + "</td></tr>");
            continue;
        }

        String productId = product.get(0).toString();
        String productName = product.get(1).toString();
        Object priceObj = product.get(2);
        Object quantityObj = product.get(3);

        double price = 0;
        int quantity = 0;

        try {
            price = Double.parseDouble(priceObj.toString());
        } catch (NumberFormatException e) {
            out.println("<tr><td colspan='5' style='color:red;'>Invalid price for product: " + productId + "</td></tr>");
        }

        try {
            quantity = Integer.parseInt(quantityObj.toString());
        } catch (NumberFormatException e) {
            out.println("<tr><td colspan='5' style='color:red;'>Invalid quantity for product: " + productId + "</td></tr>");
        }

        double subtotal = price * quantity;
        total += subtotal;

        out.println("<tr>");
        out.println("<td>" + productId + "</td>");
        out.println("<td>" + productName + "</td>");
        out.println("<td align='center'>" + quantity + "</td>");
        out.println("<td>" + currFormat.format(price) + "</td>");
        out.println("<td>" + currFormat.format(subtotal) + "</td>");
        out.println("</tr>");
    }

    out.println("<tr><td colspan='4' align='right'><b>Order Total</b></td>");
    out.println("<td>" + currFormat.format(total) + "</td></tr>");
    out.println("</table>");

    out.println("<div class='actions'>");
    out.println("<h2><a href='checkout.jsp'>Check Out</a></h2>");
    out.println("<h2><a href='listprod.jsp'>Continue Shopping</a></h2>");
    out.println("</div>");
}
%>

</body>
</html>

