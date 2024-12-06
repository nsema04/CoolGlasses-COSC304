<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f9;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-top: 30px;
        }
        .filter-form {
            margin: 20px 0;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-form select, .filter-form input {
            margin: 5px;
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
        }
        .filter-form input[type="submit"], .filter-form input[type="reset"] {
            background-color: #007bff;
            color: white;
            border: none;
        }
        .filter-form input[type="submit"]:hover, .filter-form input[type="reset"]:hover {
            background-color: #0056b3;
        }
        .product-table {
            width: 100%;
            margin: 30px auto;
            border-collapse: collapse;
        }
        .product-table th, .product-table td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }
        .product-table th {
            background-color: #007bff;
            color: white;
        }
        .product-table td {
            background-color: #f9f9f9;
        }
        .product-table img {
            max-width: 100px;
            height: auto;
            border-radius: 5px;
        }
        .product-link {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
        }
        .product-link:hover {
            color: #0056b3;
        }
        .cta-button {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
        }
        .cta-button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<h2>Browse Products By Category and Search by Product Name</h2>

<!-- Search and filter form -->
<form method="get" action="listprod.jsp">
    <div class="container mt-4"> <!-- Center the content and add margin-top -->
        <div class="form-group">
            <label for="categoryName">Select Category</label>
            <select class="form-control" id="categoryName" name="categoryName">
                <option>All</option>
                <option>Sunglasses</option>
                <option>Prescription Glasses</option>
                <option>Reading Glasses</option>
                <option>Blue Light Glasses</option>
                <option>Sports Glasses</option>
                <option>Safety Glasses</option>
                <option>Fashion Glasses</option>
                <option>Kids Glasses</option>
            </select>
        </div>

        <div class="form-group">
            <label for="productName">Search Product</label>
            <input type="text" class="form-control" id="productName" name="productName" size="50" placeholder="Search by product name">
        </div>

        <div class="form-group">
            <button type="submit" class="btn btn-primary">Submit</button>
            <button type="reset" class="btn btn-secondary">Reset</button>
        </div>
    </div> <!-- End of container -->
</form>

<%
// Colors for different item categories
HashMap<String, String> colors = new HashMap<>();
colors.put("Sunglasses", "#0000FF");
colors.put("Prescription Glasses", "#FF0000");
colors.put("Reading Glasses", "#000000");
colors.put("Blue Light Glasses", "#6600CC");
colors.put("Sports Glasses", "#55A5B3");
colors.put("Safety Glasses", "#FF9900");
colors.put("Fashion Glasses", "#00CC00");
colors.put("Kids Glasses", "#FF66CC");
%>

<%
// Get product name to search for
String name = request.getParameter("productName");
String category = request.getParameter("categoryName");

boolean hasNameParam = name != null && !name.equals("");
boolean hasCategoryParam = category != null && !category.equals("") && !category.equals("All");
String filter = "", sql = "";

if (hasNameParam && hasCategoryParam) {
    filter = "<h3>Products containing '" + name + "' in category: '" + category + "'</h3>";
    name = '%' + name + '%';
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, SUM(OP.quantity) AS totalSales FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN OrderProduct OP ON P.productId = OP.productId WHERE P.productName LIKE ? AND C.categoryName = ? GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL ORDER BY totalSales DESC";
} else if (hasNameParam) {
    filter = "<h3>Products containing '" + name + "'</h3>";
    name = '%' + name + '%';
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, SUM(OP.quantity) AS totalSales FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN OrderProduct OP ON P.productId = OP.productId WHERE P.productName LIKE ? GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL ORDER BY totalSales DESC";
} else if (hasCategoryParam) {
    filter = "<h3>Products in category: '" + category + "'</h3>";
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, SUM(OP.quantity) AS totalSales FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN OrderProduct OP ON P.productId = OP.productId WHERE C.categoryName = ? GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL ORDER BY totalSales DESC";
} else {
    filter = "<h3>All Products</h3>";
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, SUM(OP.quantity) AS totalSales FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN OrderProduct OP ON P.productId = OP.productId GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL ORDER BY totalSales DESC";
}

out.println(filter);

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try {
    getConnection();
    Statement stmt = con.createStatement();
    stmt.execute("USE orders");

    PreparedStatement pstmt = con.prepareStatement(sql);
    if (hasNameParam) {
        pstmt.setString(1, name);
        if (hasCategoryParam) {
            pstmt.setString(2, category);
        }
    } else if (hasCategoryParam) {
        pstmt.setString(1, category);
    }

    ResultSet rst = pstmt.executeQuery();

    out.print("<table class=\"table product-table\"><tr><th></th><th>Product Name</th><th>Category</th><th>Price</th><th>Total Sales</th><th>Image</th></tr>");
    while (rst.next()) {
        int id = rst.getInt(1);
        String itemCategory = rst.getString(4);
        String color = colors.get(itemCategory);
        if (color == null)
            color = "#FFFFFF";

        out.println("<tr><td><a href=\"addcart.jsp?id=" + id + "&name=" + rst.getString(2)
                + "&price=" + rst.getDouble(3) + "\" class=\"btn btn-success btn-sm\">Add to Cart</a></td>"
                + "<td><a href=\"product.jsp?id=" + id + "\" class=\"product-link\" style=\"color:" + color + ";\">" + rst.getString(2) + "</a></td>"
                + "<td style=\"color:" + color + ";\">" + itemCategory + "</td>"
                + "<td style=\"color:" + color + ";\">" + currFormat.format(rst.getDouble(3)) + "</td>"
                + "<td style=\"color:" + color + ";\">" + rst.getInt(6) + "</td>"
                + "<td><img src=\"" + rst.getString(5) + "\" alt=\"" + rst.getString(2) + "\" class=\"img-fluid\"></td></tr>");
    }
    out.println("</table>");
    closeConnection();
} catch (SQLException ex) {
    out.println(ex);
}
%>

</body>
</html>
