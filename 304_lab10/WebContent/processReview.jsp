<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Process Review</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<% 
    String productId = request.getParameter("productId");
    String userId = request.getParameter("userId");
    int rating = Integer.parseInt(request.getParameter("rating"));
    String comment = request.getParameter("comment");

    out.println("<p>Debug Info: productId = " + productId + ", userId = " + userId + ", rating = " + rating + ", comment = " + comment + "</p>");

    try {
        getConnection();
        Statement stmt = con.createStatement();
        stmt.execute("USE orders");

        // Retrieve customerId based on authenticated user
        String sql3 = "SELECT customerId FROM customer WHERE userId = ?";
        PreparedStatement pstmt3 = con.prepareStatement(sql3);
        pstmt3.setString(1, userId);
        ResultSet rst3 = pstmt3.executeQuery();
        rst3.next();
        int custId = rst3.getInt("customerId");

        out.println("<p>Debug Info: custId = " + custId + "</p>");

        // Insert review
        String sql = "INSERT INTO review (productId, customerId, reviewRating, reviewDate, reviewComment) VALUES (?, ?, ?, GETDATE(), ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(productId));
        pstmt.setInt(2, custId);
        pstmt.setInt(3, rating);
        pstmt.setString(4, comment);
        pstmt.executeUpdate();

        out.println("<h1>Review submitted successfully!</h1>");
        out.println("<h1><a href='product.jsp?id=" + productId + "'>Back to Product</a></h1>");
    } catch (SQLException ex) {
        out.println("<p>Error submitting review: " + ex.getMessage() + "</p>");
    } finally {
        closeConnection();
    }
%>

</body>
</html>
