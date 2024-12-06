<%@ page language="java" import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // Retrieve the productId from the request
    String productIdStr = request.getParameter("productId");

    // Redirect if no product ID is provided
    if (productIdStr == null || productIdStr.isEmpty()) {
        response.sendRedirect("viewProducts.jsp?status=error&message=No+Product+ID+Provided");
        return;
    }

    int productId = Integer.parseInt(productIdStr);

    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    boolean success = false;
    String errorMessage = null;

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // Check if the product exists
        String checkQuery = "SELECT productId FROM product WHERE productId = ?";
        try (PreparedStatement checkStmt = con.prepareStatement(checkQuery)) {
            checkStmt.setInt(1, productId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Product exists, proceed to delete
                String deleteQuery = "DELETE FROM product WHERE productId = ?";
                try (PreparedStatement deleteStmt = con.prepareStatement(deleteQuery)) {
                    deleteStmt.setInt(1, productId);
                    int rowsAffected = deleteStmt.executeUpdate();
                    success = rowsAffected > 0;
                }
            } else {
                // Product does not exist
                errorMessage = "Product not found.";
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        errorMessage = "An error occurred while deleting the product.";
    }

    // Redirect back to viewProducts.jsp with a status message
    if (success) {
        response.sendRedirect("viewProducts.jsp?status=success&message=Product+Deleted+Successfully");
    } else if (errorMessage != null) {
        response.sendRedirect("viewProducts.jsp?status=error&message=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
    } else {
        response.sendRedirect("viewProducts.jsp?status=error&message=Unknown+Error");
    }
%>
