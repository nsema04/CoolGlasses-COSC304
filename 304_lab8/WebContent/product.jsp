<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.net.URLEncoder"%>
<%@ include file="jdbc.jsp"%>

<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp"%>

<%
    // Get the product ID from the request parameter
    String productId = request.getParameter("id");

    if (productId == null || productId.isEmpty()) {
        out.println("<p>No product selected.</p>");
        return;
    }

    // Initialize database connection
    try {
        // Get the connection from the jdbc.jsp
        getConnection();

        // SQL query to get the product details based on productId
        String sql = "SELECT p.productName, p.productPrice, p.productDesc, p.productImageURL, p.productImage, c.categoryName " +
                     "FROM product p " +
                     "INNER JOIN category c ON p.categoryId = c.categoryId " +
                     "WHERE p.productId = ?";

        // Prepare the SQL statement and execute
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(productId));
        ResultSet rs = stmt.executeQuery();

        // Check if a product was found
        if (rs.next()) {
            String productName = rs.getString("productName");
            double productPrice = rs.getDouble("productPrice");
            String productDesc = rs.getString("productDesc");
            String productImageURL = rs.getString("productImageURL");
            String productImage = rs.getString("productImage");
            String categoryName = rs.getString("categoryName");

            // Format price for display
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
%>
            <div class="container">
                <h1>Product: <%= productName %></h1>
                <p><strong>Category:</strong> <%= categoryName %></p>
                <p><strong>Price:</strong> <%= currencyFormat.format(productPrice) %></p>
                <p><strong>Description:</strong> <%= productDesc %></p>

                <%-- If product image URL exists, display the image --%>
                <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                    <img src="<%= productImageURL %>" alt="<%= productName %>" class="img-fluid" />
                <% } else if (productImage != null && !productImage.isEmpty()) { %>
                    <img src="data:image/jpeg;base64,<%= productImage %>" alt="<%= productName %>" class="img-fluid" />
                <% } %>

                <br /><br />

                <!-- Add to Cart and Continue Shopping links -->
                <a href="addcart.jsp?id=<%= productId %>&name=<%= URLEncoder.encode(productName, "UTF-8") %>&price=<%= productPrice %>" 
                   class="btn btn-primary">
                   Add to Cart
                </a>
                <a href="listprod.jsp" class="btn btn-secondary">Continue Shopping</a>

            </div>

<%
        } else {
            out.println("<p>Product not found.</p>");
        }

        // Close the result set and statement
        rs.close();
        stmt.close();

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>Error retrieving product details: " + e.getMessage() + "</p>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Unexpected error: " + e.getMessage() + "</p>");
    } finally {
        // Close the database connection
        closeConnection();
    }
%>

</body>
</html>
