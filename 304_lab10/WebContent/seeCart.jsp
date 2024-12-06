<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Cart - CoolGlasses</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-top: 30px;
        }

        table {
            width: 80%;
            margin: 30px auto;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            text-align: center;
            font-size: 16px;
        }

        th {
            background-color: #3498db;
            color: white;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ecf0f1;
        }

        button {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #2980b9;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .action-buttons button {
            width: 40px;
            height: 40px;
            font-size: 20px;
        }

        .total-section {
            text-align: center;
            margin-top: 20px;
        }

        .total-section strong {
            font-size: 18px;
            color: #2c3e50;
        }

        .nav-buttons {
            text-align: center;
            margin-top: 30px;
        }

        .nav-buttons button {
            width: 200px;
            padding: 12px;
            font-size: 16px;
        }

        a {
            text-decoration: none;
            color: #e74c3c;
            font-weight: bold;
            display: block;
            margin-top: 5px;
        }

        a:hover {
            color: #c0392b;
        }
    </style>
</head>
<body>

<h2>Your Cart</h2>

<%
    // Get the current list of products from the session
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null || productList.isEmpty()) {
%>
        <p style="text-align: center; font-size: 18px; color: #e74c3c;">Your cart is empty!</p>
<%
    } else {
%>
        <form action="updateCart.jsp" method="POST">
            <table>
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
                <td class="action-buttons">
                    <button type="submit" name="action_<%= id %>" value="decrease" <% if (quantity <= 1) out.print("disabled"); %>>-</button>
                    <span><%= quantity %></span>
                    <button type="submit" name="action_<%= id %>" value="increase">+</button>
                </td>
                <td><%= total %></td>
                <td><a href="removeItem.jsp?id=<%= id %>">Remove</a></td>
            </tr>
<%
        }
%>
            <tr>
                <td colspan="5" class="total-section"><strong>Grand Total</strong></td>
                <td class="total-section"><strong><%= grandTotal %></strong></td>
            </tr>
        </table>
        <br>
        <input type="submit" value="Update Cart" style="width: 200px; height: 40px; font-size: 16px;" />
        </form>

        <div class="nav-buttons">
            <button onclick="window.location.href='checkout.jsp';">Checkout</button>
        </div>
<%
    }
%>

<div class="nav-buttons">
    <button onclick="window.location.href='listprod.jsp';">Back to Products</button>
</div>

</body>
</html>
