<%@ page import="java.sql.*, java.text.NumberFormat, java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses Glasses Co - Product Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff; /* Light blue background */
            margin: 0;
            padding: 0;
        }

        h1, h2 {
            color: #333; /* Darker text for contrast */
            text-align: center;
        }

        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
        }

        p {
            font-size: 16px;
            line-height: 1.5;
            color: #333;
        }

        .img-fluid {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 10px auto;
            border-radius: 10px;
        }

        a.btn {
            display: inline-block;
            text-decoration: none;
            padding: 10px 20px;
            margin: 10px 5px;
            font-size: 16px;
            font-weight: bold;
            color: white;
            background-color: #007bff; /* Blue button */
            border: none;
            border-radius: 5px;
            text-align: center;
            transition: background-color 0.3s ease;
        }

        a.btn:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }

        .btn-secondary {
            background-color: #6c757d; /* Gray button */
        }

        .btn-secondary:hover {
            background-color: #5a6268; /* Darker gray on hover */
        }

        .note {
            text-align: center;
            font-size: 14px;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>CoolGlasses Glasses Co - Product Information</h1>

        <%
            // Get the product ID from the request parameter
            String productId = request.getParameter("id");

            if (productId == null || productId.isEmpty()) {
                out.println("<p>No product selected.</p>");
                return;
            }

            // Initialize database connection
            try {
                // Get the connection
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String uid = "sa";
                String pw = "304#sa#pw";

                try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                    String sql = "SELECT p.productName, p.productPrice, p.productDesc, p.productImageURL, p.productImage, c.categoryName " +
                                 "FROM product p " +
                                 "INNER JOIN category c ON p.categoryId = c.categoryId " +
                                 "WHERE p.productId = ?";
                    
                    PreparedStatement stmt = con.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(productId));
                    ResultSet rs = stmt.executeQuery();

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
                        <h2><%= productName %></h2>
                        <p><strong>Category:</strong> <%= categoryName %></p>
                        <p><strong>Price:</strong> <%= currencyFormat.format(productPrice) %></p>
                        <p><strong>Description:</strong> <%= productDesc %></p>

                        <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                            <img src="<%= productImageURL %>" alt="<%= productName %>" class="img-fluid" />
                        <% } else if (productImage != null && !productImage.isEmpty()) { %>
                            <img src="data:image/jpeg;base64,<%= productImage %>" alt="<%= productName %>" class="img-fluid" />
                        <% } %>

                        <br />
                        <a href="addcart.jsp?id=<%= productId %>&name=<%= URLEncoder.encode(productName, "UTF-8") %>&price=<%= productPrice %>" 
                           class="btn">
                           Add to Cart
                        </a>
                        <a href="listprod.jsp" class="btn btn-secondary">Continue Shopping</a>
        <%
                    } else {
                        out.println("<p>Product not found.</p>");
                    }

                    rs.close();
                    stmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error retrieving product details: " + e.getMessage() + "</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Unexpected error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
