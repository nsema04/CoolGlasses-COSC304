<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>CoolGlasses - Product Information</title>
<style>
    /* General styles */
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #87cefa, #ffffff);
        color: #333;
    }

    /* Navbar styling */
    .navbar {
        background-color: #2c3e50;
        padding: 10px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .navbar a {
        color: white;
        text-decoration: none;
        padding: 10px 20px;
        font-size: 1rem;
    }

    .navbar a:hover {
        background-color: #34495e;
        border-radius: 5px;
    }

    .navbar .right {
        display: flex;
        gap: 10px;
    }

    /* Main container */
    .container {
        max-width: 900px;
        margin: 50px auto;
        padding: 20px;
        background-color: #f9f9f9;
        border-radius: 15px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        text-align: center;
    }

    h1, h2, h3 {
        color: #2c3e50;
    }

    p {
        font-size: 1.2rem;
        color: #666;
    }

    .product-table {
        margin: 0 auto;
    }

    .product-image {
        max-width: 100%;
        height: auto;
        border-radius: 10px;
    }

    .price-tag {
        font-size: 1.5rem;
        font-weight: bold;
        color: #e74c3c;
        margin-bottom: 15px;
    }

    .button {
        display: inline-block;
        padding: 15px 30px;
        margin: 20px;
        font-size: 1.2rem;
        color: white;
        background-color: #3498db;
        border: none;
        border-radius: 25px;
        text-decoration: none;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
        transition: all 0.3s ease;
    }

    .button:hover {
        background-color: #2980b9;
        transform: translateY(-3px);
        box-shadow: 0 6px 10px rgba(0, 0, 0, 0.3);
    }

    .reviews-section {
        margin-top: 30px;
    }

    .review {
        background-color: #ffffff;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        text-align: left;
        margin-bottom: 20px;
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
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
        out.println("<h2 class='product-title'>"+rst.getString(2)+"</h2>");
        
        int prodId = rst.getInt(1);
        out.println("<div class='product-details'>");
        out.println("<table class='product-table'>");
        out.println("<tr><td colspan='2' class='price-tag'>" + currFormat.format(rst.getDouble(3)) + "</td></tr>");
        
        //  Retrieve any image with a URL
        String imageLoc = rst.getString(4);
        if (imageLoc != null)
            out.println("<tr><td colspan='2'><img src=\""+imageLoc+"\" alt='Product Image' class='product-image'></td></tr>");
        
        // Retrieve any image stored directly in database
        String imageBinary = rst.getString(5);
        if (imageBinary != null)
            out.println("<tr><td colspan='2'><img src=\"displayImage.jsp?id="+prodId+"\" alt='Product Image' class='product-image'></td></tr>");    
        out.println("</table>");
        out.println("</div>");
        
        out.println("<div class='product-actions'>");
        out.println("<h3><a href=\"addcart.jsp?id="+prodId+ "&name=" + rst.getString(2)
                                + "&price=" + rst.getDouble(3)+"\" class='button'>Add to Cart</a></h3>");       
        
        out.println("<h3><a href=\"listprod.jsp\" class='button'>Continue Shopping</a></h3>");
        
        out.println("<h3><a href=\"enterReview.jsp?productId="+prodId+"\" class='button'>Leave a Review</a></h3>");
        out.println("</div>");
        
        // Display reviews
        sql = "SELECT R.reviewRating, R.reviewDate, R.reviewComment, C.firstName, C.lastName FROM review R JOIN customer C ON R.customerId = C.customerId WHERE R.productId = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, prodId);
        ResultSet reviews = pstmt.executeQuery();
        
        out.println("<div class='reviews-section'>");
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
        out.println("</div>");
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
</div>

</body>
</html>
