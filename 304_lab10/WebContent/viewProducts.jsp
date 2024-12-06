<%@ page language="java" import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Product to Update or Delete</title>
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
    <h1 class="text-center">Select Product to Update or Delete</h1>
    <hr>

    <form action="updateProduct.jsp" method="get" class="mb-4">
        <label for="prodId">Enter Product ID to Update:</label>
        <input type="number" name="prodId" id="prodId" class="form-control" required />
        <input type="submit" value="Select Product to Update" class="btn btn-primary mt-2" />
    </form>

    <h3>Or, choose from the list of products:</h3>
    <ul class="list-group">
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
                    <li class="list-group-item">
                        <!-- Link to update product by ID -->
                        <a href="updateProduct.jsp?prodId=<%= productId %>"><%= productName %></a>
                        
                        <!-- Delete product form -->
                        <!-- Delete product form -->
                        <!-- Delete product form -->
                        <form action="deleteProduct.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <input type="submit" value="Delete Product" 
                                   style="font-size: 11px; padding: 3px 6px; height: 20px; 
                                          background-color: red; color: white; text-align: center; border: none; cursor: pointer;" 
                                   onclick="return confirm('Are you sure you want to delete this product?');">
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
    <!-- Back to Admin Button -->
    <button onclick="window.location.href='admin.jsp'" class="btn btn-secondary mt-4">Back to Admin</button>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
