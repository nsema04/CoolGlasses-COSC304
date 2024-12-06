<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Enter Review</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<h2>Enter Your Review</h2>

<% 
    String productId = request.getParameter("productId");
    String userId = (String) session.getAttribute("authenticatedUser");

    if (userId == null) {
        out.println("<p>You need to be logged in to write a review. <a href='login.jsp'>Login</a></p>");
    } else {
%>
        <form method="post" action="processReview.jsp">
            <input type="hidden" name="productId" value="<%= productId %>">
            <input type="hidden" name="userId" value="<%= userId %>">
            <div>
                <label for="rating">Rating (1-5):</label>
                <input type="number" name="rating" min="1" max="5" required>
            </div>
            <div>
                <label for="comment">Comment:</label>
                <textarea name="comment" rows="4" cols="50" required></textarea>
            </div>
            <div>
                <input type="submit" value="Submit Review">
            </div>
        </form>
<% 
    }
%>

</body>
</html>
