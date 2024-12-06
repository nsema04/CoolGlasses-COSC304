<%@ page language="java" import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ include file="jdbc.jsp" %>
<%
    String prodId = request.getParameter("prodId");
    if (prodId == null || prodId.isEmpty()) {
        response.sendRedirect("viewProducts.jsp?update=error&msg=MissingProductId");
        return;
    }

    String prodName = null, prodPrice = null, prodImageURL = null, prodDesc = null, categoryId = null;
    
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";
    
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String query = "SELECT productName, productPrice, productImageURL, productDesc, categoryId FROM product WHERE productId = ?";
        PreparedStatement stmt = con.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(prodId));  // Set the prodId in the query
        
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            prodName = rs.getString("productName");
            prodPrice = rs.getString("productPrice");
            prodImageURL = rs.getString("productImageURL");
            prodDesc = rs.getString("productDesc");
            categoryId = rs.getString("categoryId");
        } else {
            response.sendRedirect("viewProducts.jsp?update=error&msg=ProductNotFound");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("viewProducts.jsp?update=error&msg=DatabaseError");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Product</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f4f4f4;
        }

        h2 {
            text-align: center;
        }

        form {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            margin: 0 auto;
        }

        label {
            font-size: 14px;
            margin: 10px 0 5px;
            display: block;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }
    </style>
</head>
<body>
    <h2>Update Product</h2>
    <form action="updateProductAction.jsp" method="post">
        <!-- Hidden Product ID -->
        <input type="hidden" name="prodId" value="<%= prodId %>" />
        
        <label for="prodName">Product Name:</label>
        <input type="text" name="prodName" id="prodName" value="<%= prodName %>" required /><br>

        <label for="price">Price:</label>
        <input type="text" name="price" id="price" value="<%= prodPrice %>" required /><br>

        <label for="prodImageURL">Image URL:</label>
        <input type="text" name="prodImageURL" id="prodImageURL" value="<%= prodImageURL %>" /><br>

        <label for="prodDesc">Description:</label>
        <textarea name="prodDesc" id="prodDesc" required><%= prodDesc %></textarea><br>

        <label for="categoryId">Category ID:</label>
        <input type="number" name="categoryId" id="categoryId" value="<%= categoryId %>" required /><br>

        <input type="submit" value="Update Product" />
    </form>
</body>
</html>
