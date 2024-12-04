<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Cart - CoolGlasses</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<h2>Your Cart</h2>

<%
    // Get the current list of products from the session
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null || productList.isEmpty()) {
%>
        <p>Your cart is empty!</p>
<%
    } else {
%>
        <form action="updateCart.jsp" method="POST">
            <table border="1">
                <tr>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
<%
        double grandTotal = 0.0;

        for (String id : productList.keySet()) {
            ArrayList<Object> product = productList.get(id);
            String name = (String) product.get(1);
            double price = Double.parseDouble((String) product.get(2));
            int quantity = (Integer) product.get(3);
            double total = price * quantity;
            grandTotal += total;
%>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= price %></td>
                <td>
                    <!-- Quantity Controls -->
                    <button type="submit" name="action_<%= id %>" value="decrease" <% if (quantity <= 1) out.print("disabled"); %>>-</button>
                    <span><%= quantity %></span>
                    <button type="submit" name="action_<%= id %>" value="increase">+</button>
                </td>
                <td><%= total %></td>
                <td>
                    <!-- Remove Item Button -->
                    <a href="removeItem.jsp?id=<%= id %>">Remove</a>
                </td>
            </tr>
<%
        }
%>
            <tr>
                <td colspan="5"><strong>Grand Total</strong></td>
                <td><strong><%= grandTotal %></strong></td>
            </tr>
        </table>
        <br>
        <input type="submit" value="Update Cart" />
        </form>
<%
    }
%>

<!-- Add Back Button -->
<div>
    <button onclick="window.location.href='listprod.jsp';">Back to Products</button>
</div>

</body>
</html>
