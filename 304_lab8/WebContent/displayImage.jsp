<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %>
<%@ include file="jdbc.jsp" %>
<%

// Fetch product details
String sql = "SELECT productImageURL FROM Product WHERE productId = ?";
int idVal = Integer.parseInt(request.getParameter("id"));
String imageURL = null;

try {
    getConnection();
    PreparedStatement stmt = con.prepareStatement(sql);
    stmt.setInt(1, idVal);
    ResultSet rst = stmt.executeQuery();
    if (rst.next()) {
        imageURL = rst.getString("productImageURL");
    }
} catch (SQLException ex) {
    out.println(ex);
} finally {
    closeConnection();
}

%>

<!DOCTYPE html>
<html>
<head>
    <title>Product Image</title>
</head>
<body>
<% if (imageURL != null) { %>
    <img src="<%= imageURL %>" alt="Product Image"/>
<% } else { %>
    <p>Image not available</p>
<% } %>
</body>
</html>
