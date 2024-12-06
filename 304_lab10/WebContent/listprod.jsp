<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>CoolGlasses</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<h2>Browse Products By Category and Search by Product Name:</h2>

<form method="get" action="listprod.jsp">
  <p align="left">
  <select size="1" name="categoryName">
  <option>All</option>

<%
/*
// Could create category list dynamically - more adaptable, but a little more costly
try               
{
    getConnection();
    ResultSet rst = executeQuery("SELECT DISTINCT categoryName FROM Product");
        while (rst.next()) 
        out.println("<option>"+rst.getString(1)+"</option>");
}
catch (SQLException ex)
{       out.println(ex);
}
*/
%>

  <option>Sunglasses</option>
  <option>Prescription Glasses</option>
  <option>Reading Glasses</option>
  <option>Blue Light Glasses</option>
  <option>Sports Glasses</option>
  <option>Safety Glasses</option>
  <option>Fashion Glasses</option>
  <option>Kids Glasses</option>       
  </select>
  <input type="text" name="productName" size="50">
  <input type="submit" value="Submit"><input type="reset" value="Reset"></p>
</form>

<%
// Colors for different item categories
HashMap<String,String> colors = new HashMap<String,String>();       // This may be done dynamically as well, a little tricky...
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

if (hasNameParam && hasCategoryParam)
{
    filter = "<h3>Products containing '"+name+"' in category: '"+category+"'</h3>";
    name = '%'+name+'%';
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, SUM(OP.quantity) AS totalSales FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN OrderProduct OP ON P.productId = OP.productId WHERE P.productName LIKE ? AND C.categoryName = ? GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL ORDER BY totalSales DESC";
}
else if (hasNameParam)
{
    filter = "<h3>Products containing '"+name+"'</h3>";
    name = '%'+name+'%';
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, SUM(OP.quantity) AS totalSales FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN OrderProduct OP ON P.productId = OP.productId WHERE P.productName LIKE ? GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL ORDER BY totalSales DESC";
}
else if (hasCategoryParam)
{
    filter = "<h3>Products in category: '"+category+"'</h3>";
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, SUM(OP.quantity) AS totalSales FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN OrderProduct OP ON P.productId = OP.productId WHERE C.categoryName = ? GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL ORDER BY totalSales DESC";
}
else
{
    filter = "<h3>All Products</h3>";
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, SUM(OP.quantity) AS totalSales FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN OrderProduct OP ON P.productId = OP.productId GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL ORDER BY totalSales DESC";
}

out.println(filter);

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{
    getConnection();
    Statement stmt = con.createStatement();             
    stmt.execute("USE orders");
    
    PreparedStatement pstmt = con.prepareStatement(sql);
    if (hasNameParam)
    {
        pstmt.setString(1, name);   
        if (hasCategoryParam)
        {
            pstmt.setString(2, category);
        }
    }
    else if (hasCategoryParam)
    {
        pstmt.setString(1, category);
    }
    
    ResultSet rst = pstmt.executeQuery();
    
    out.print("<font face=\"Century Gothic\" size=\"2\"><table class=\"table\" border=\"1\"><tr><th class=\"col-md-1\"></th><th>Product Name</th>");
    out.println("<th>Category</th><th>Price</th><th>Total Sales</th><th>Image</th></tr>");
    while (rst.next()) 
    {
        int id = rst.getInt(1);
        out.print("<td class=\"col-md-1\"><a href=\"addcart.jsp?id=" + id + "&name=" + rst.getString(2)
                + "&price=" + rst.getDouble(3) + "\">Add to Cart</a></td>");

        String itemCategory = rst.getString(4);
        String color = colors.get(itemCategory);
        if (color == null)
            color = "#FFFFFF";

        out.println("<td><a href=\"product.jsp?id="+id+"\"<font color=\"" + color + "\">" + rst.getString(2) + "</font></td>"
                + "<td><font color=\"" + color + "\">" + itemCategory + "</font></td>"
                + "<td><font color=\"" + color + "\">" + currFormat.format(rst.getDouble(3))
                + "</font></td>"
                + "<td><font color=\"" + color + "\">" + rst.getInt(6) + "</font></td>"
                + "<td><img src=\"" + rst.getString(5) + "\" alt=\"" + rst.getString(2) + "\" style=\"width:100px;height:auto;\"></td></tr>");
    }
    out.println("</table></font>");
    closeConnection();
} catch (SQLException ex) {
    out.println(ex);
}
%>

</body>
</html>
