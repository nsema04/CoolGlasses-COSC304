<%@ page import="java.sql.*, java.text.NumberFormat, java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses Store Product List</title>
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

        form {
            text-align: center;
            margin-bottom: 20px;
        }

        input[type="text"] {
            padding: 10px;
            font-size: 16px;
            width: 70%;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        input[type="submit"],
        input[type="reset"] {
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #007bff; /* Blue button */
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 0 5px;
        }

        input[type="submit"]:hover,
        input[type="reset"]:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px auto;
            background-color: white;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        a {
            color: white;
            background-color: #28a745; /* Green button */
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 5px;
        }

        a:hover {
            background-color: #218838; /* Darker green on hover */
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
        <h1>Search for the Products You Want to Buy</h1>

        <form method="get" action="listprod.jsp">
            <input type="text" name="productName" placeholder="Enter product name">
            <br>
            <input type="submit" value="Search">
            <input type="reset" value="Reset">
        </form>
        <p class="note">(Leave blank to view all products)</p>

        <h2>Available Products</h2>
        <table>
            <tr>
                <th>Product Name</th>
                <th>Price</th>
                <th>Action</th>
            </tr>
            <%
                String name = request.getParameter("productName");
                if (name == null) {
                    name = ""; // Default to show all products
                }

                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                } catch (ClassNotFoundException e) {
                    out.println("<p>Error loading SQL Server driver: " + e.getMessage() + "</p>");
                }

                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String uid = "sa";
                String pw = "304#sa#pw";

                try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                    String query = "SELECT productId, productName, productPrice FROM product " +
                                   "WHERE productName LIKE ? ORDER BY productName ASC";
                    try (PreparedStatement stmt = con.prepareStatement(query)) {
                        stmt.setString(1, "%" + name + "%");

                        try (ResultSet rs = stmt.executeQuery()) {
                            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                            while (rs.next()) {
                                int productId = rs.getInt("productId");
                                String productName = rs.getString("productName");
                                double productPrice = rs.getDouble("productPrice");

                                out.println("<tr>");
                                out.println("<td>" + productName + "</td>");
                                out.println("<td>" + currFormat.format(productPrice) + "</td>");
                                out.println("<td><a href='addcart.jsp?id=" + productId +
                                            "&name=" + URLEncoder.encode(productName, "UTF-8") +
                                            "&price=" + productPrice + "'>Add to Cart</a></td>");
                                out.println("</tr>");
                            }
                        }
                    }
                } catch (SQLException e) {
                    out.println("<p>Error querying the database: " + e.getMessage() + "</p>");
                }
            %>
        </table>
    </div>
</body>
</html>
