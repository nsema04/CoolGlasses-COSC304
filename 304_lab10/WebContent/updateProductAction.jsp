<%@ page language="java" import="java.io.*, java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // Retrieve the prodId from the form submission
    String prodId = request.getParameter("prodId");
    if (prodId == null || prodId.isEmpty()) {
        response.sendRedirect("viewProducts.jsp?update=error&msg=MissingProductId");
        return;
    }

    // Retrieve the other product details from the form submission
    String prodName = request.getParameter("prodName");
    String price = request.getParameter("price");
    String prodImageURL = request.getParameter("prodImageURL");
    String prodDesc = request.getParameter("prodDesc");
    String categoryId = request.getParameter("categoryId");

    // Basic validation for the inputs (can add more validation if needed)
    if (prodName == null || price == null || prodDesc == null || categoryId == null) {
        response.sendRedirect("viewProducts.jsp?update=error&msg=MissingFields");
        return;
    }

    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // SQL query to update the product
        String query = "UPDATE product SET productName = ?, productPrice = ?, productImageURL = ?, productDesc = ?, categoryId = ? WHERE productId = ?";
        PreparedStatement stmt = con.prepareStatement(query);

        // Set the parameters for the query
        stmt.setString(1, prodName);
        stmt.setBigDecimal(2, new java.math.BigDecimal(price));  // Assuming price is a decimal
        stmt.setString(3, prodImageURL);
        stmt.setString(4, prodDesc);
        stmt.setInt(5, Integer.parseInt(categoryId));
        stmt.setInt(6, Integer.parseInt(prodId));  // Use the product ID to identify which product to update

        // Execute the update
        int rowsUpdated = stmt.executeUpdate();

        if (rowsUpdated > 0) {
            // Successfully updated the product
            response.sendRedirect("viewProducts.jsp?update=success&msg=ProductUpdated");
        } else {
            // No rows updated (could be an issue with the productId)
            response.sendRedirect("viewProducts.jsp?update=error&msg=UpdateFailed");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("viewProducts.jsp?update=error&msg=DatabaseError");
    }
%>
