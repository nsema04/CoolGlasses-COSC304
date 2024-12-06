<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>CoolGlasses - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
String productId = request.getParameter("id");

String sql = "SELECT productId, productName, productPrice, productImageURL, productImage FROM Product P  WHERE productId = ?";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{
    getConnection();
    Statement stmt = con.createStatement();             
    stmt.execute("USE orders");
    
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(productId));           
    
    ResultSet rst = pstmt.executeQuery();
            
    if (!rst.next())
    {
        out.println("Invalid product");
    }
    else
    {       
        out.println("<h2>"+rst.getString(2)+"</h2>");
        
        int prodId = rst.getInt(1);
        out.println("<table><tr>");
        out.println("<th>Id</th><td>" + prodId + "</td></tr>"               
                + "<tr><th>Price</th><td>" + currFormat.format(rst.getDouble(3)) + "</td></tr>");
        
        //  Retrieve any image with a URL
        String imageLoc = rst.getString(4);
        if (imageLoc != null)
            out.println("<img src=\""+imageLoc+"\">");
        
        // Retrieve any image stored directly in database
        String imageBinary = rst.getString(5);
        if (imageBinary != null)
            out.println("<img src=\"displayImage.jsp?id="+prodId+"\">");    
        out.println("</table>");
        

        out.println("<h3><a href=\"addcart.jsp?id="+prodId+ "&name=" + rst.getString(2)
                                + "&price=" + rst.getDouble(3)+"\">Add to Cart</a></h3>");      
        
        out.println("<h3><a href=\"listprod.jsp\">Continue Shopping</a></h3>");
        
        out.println("<h3><a href=\"enterReview.jsp?productId="+prodId+"\">Leave a Review</a></h3>");
        
        // Display reviews
        sql = "SELECT R.reviewRating, R.reviewDate, R.reviewComment, C.firstName, C.lastName FROM review R JOIN customer C ON R.customerId = C.customerId WHERE R.productId = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, prodId);
        ResultSet reviews = pstmt.executeQuery();
        
        out.println("<h3>Reviews:</h3>");
        if (!reviews.isBeforeFirst()) {
            out.println("<p>No reviews available for this product.</p>");
        } else {
            while (reviews.next())
            {
                out.println("<div class='review'>");
                out.println("<p><strong>Rating:</strong> " + reviews.getInt(1) + "/5</p>");
                out.println("<p><strong>Date:</strong> " + reviews.getDate(2) + "</p>");
                out.println("<p><strong>Comment:</strong> " + reviews.getString(3) + "</p>");
                out.println("<p><strong>By:</strong> " + reviews.getString(4) + " " + reviews.getString(5) + "</p>");
                out.println("</div><hr>");
            }
        }
    }
} 
catch (SQLException ex) {
    out.println(ex);
}
finally
{
    closeConnection();
}
%>

</body>
</html>
