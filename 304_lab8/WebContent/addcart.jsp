<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses - Add to Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff; /* Light blue background */
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h1 {
            color: #007bff;
        }

        p {
            font-size: 18px;
            margin-bottom: 20px;
        }

        a {
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
        }

        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <% 
        // Retrieve the current list of products from the session
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        if (productList == null) {
            // Initialize the product list if it doesn't exist
            productList = new HashMap<>();
        }

        // Get product details from request parameters
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        Integer quantity = 1; // Default quantity is 1

        // Store product information in an ArrayList
        ArrayList<Object> product = new ArrayList<>();
        product.add(id);
        product.add(name);
        product.add(price);
        product.add(quantity);

        // Update the quantity if the product already exists in the cart
        if (productList.containsKey(id)) {
            product = productList.get(id);
            int currentQuantity = (Integer) product.get(3);
            product.set(3, currentQuantity + 1);
        } else {
            productList.put(id, product);
        }

        // Save the updated product list back to the session
        session.setAttribute("productList", productList);
        %>

        <h1>Product Added to Cart</h1>
        <p>
            The product <strong><%= name %></strong> has been successfully added to your cart.
        </p>
        <p>
            <a href="showcart.jsp">View Cart</a>
            &nbsp;&nbsp;&nbsp;
            <a href="listprod.jsp">Continue Shopping</a>
        </p>
    </div>
</body>
</html>
