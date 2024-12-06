<%@ page language="java" import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select Product to Update or Delete</title>
</head>
<body>
    <h2>Select Product to Update or Delete</h2>

    <form action="updateProduct.jsp" method="get">
        <label for="prodId">Enter Product ID to Update:</label>
        <input type="number" name="prodId" id="prodId" required /><br>
        <input type="submit" value="Select Product to Update" />
    </form>

    <h3>Or, choose from the list of products:</h3>
    <ul>
        <% 
            // Set up database connection details
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                String query = "SELECT productId, productName FROM product";
                PreparedStatement stmt = con.prepareStatement(query);
                ResultSet rs = stmt.executeQuery();

                // Loop through the result set to display products
                while (rs.next()) {
                    int productId = rs.getInt("productId");
                    String productName = rs.getString("productName");
        %>
                    <li>
                        <!-- Link to update product by ID -->
                        <a href="updateProduct.jsp?prodId=<%= productId %>"><%= productName %></a>
                        
                        <!-- Delete product form -->
                        <form action="deleteProduct.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <input type="submit" value="Delete Product" onclick="return confirm('Are you sure you want to delete this product?');">
                        </form>
                    </li>
        <% 
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </ul>

    <%
    String status = request.getParameter("status");
    String message = request.getParameter("message");

    if (status != null && message != null) {
%>
    <p style="color:<%= "success".equals(status) ? "green" : "red" %>;"><%= message %></p>
<%
    }
%>
<button onclick="window.location.href='admin.jsp'">Back to Admin</button>
</body>
</html>
