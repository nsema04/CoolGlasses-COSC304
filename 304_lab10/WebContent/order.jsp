<%@ page import="java.sql.*,java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map,java.math.BigDecimal" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>CoolGlasses Order Processing</title>
</head>
<body>

<% 
// Get customer id and shipping/payment info from form
String custId = request.getParameter("customerId");
String shippingAddress = request.getParameter("shippingAddress");
String shippingCity = request.getParameter("shippingCity");
String shippingState = request.getParameter("shippingState");
String shippingZip = request.getParameter("shippingZip");
String shippingCountry = request.getParameter("shippingCountry");
String cardNumber = request.getParameter("cardNumber");
String cardExpiry = request.getParameter("cardExpiry");
String cardCVC = request.getParameter("cardCVC");

// Get product list from session
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (custId == null || custId.equals(""))
    out.println("<h1>Invalid customer id.  Go back to the previous page and try again.</h1>");
else if (productList == null)
    out.println("<h1>Your shopping cart is empty!</h1>");
else
{
    // Check if customer id is a number
    int num = -1;
    try
    {
        num = Integer.parseInt(custId);
    } 
    catch(Exception e)
    {
        out.println("<h1>Invalid customer id.  Go back to the previous page and try again.</h1>");
        return;
    }

    String sql = "SELECT customerId, firstName+' '+lastName FROM Customer WHERE customerId = ?";        
    NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);    

    try
    {
        getConnection();
        Statement stmt = con.createStatement();             
        stmt.execute("USE orders");

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, num);
        ResultSet rst = pstmt.executeQuery();
        int orderId = 0;
        String custName = "";

        if (!rst.next())
            out.println("<h1>Invalid customer id.  Go back to the previous page and try again.</h1>");
        else
        {   
            custName = rst.getString(2);

            // Insert order information into OrderSummary table
            sql = "INSERT INTO ordersummary (customerId, totalAmount, orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) VALUES(?, 0, ?, ?, ?, ?, ?, ?);";

            // Retrieve auto-generated key for orderId
            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, num);
            pstmt.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
            pstmt.setString(3, shippingAddress);
            pstmt.setString(4, shippingCity);
            pstmt.setString(5, shippingState);
            pstmt.setString(6, shippingZip);
            pstmt.setString(7, shippingCountry);
            pstmt.executeUpdate();
            ResultSet keys = pstmt.getGeneratedKeys();
            keys.next();
            orderId = keys.getInt(1);

            out.println("<h1>Your Order Summary</h1>");
            out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

            double total = 0;
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext())
            { 
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                String productId = (String) product.get(0);
                out.print("<tr><td>"+productId+"</td>");
                out.print("<td>"+product.get(1)+"</td>");
                out.print("<td align=\"center\">"+product.get(3)+"</td>");
                String price = (String) product.get(2);
                double pr = Double.parseDouble(price);
                int qty = ((Integer) product.get(3)).intValue();
                out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
                out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
                out.println("</tr>");
                total = total + pr * qty;

                sql = "INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES(?, ?, ?, ?)";
                pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, orderId);
                pstmt.setInt(2, Integer.parseInt(productId));
                pstmt.setInt(3, qty);
                pstmt.setString(4, price);
                pstmt.executeUpdate();                
            }
            out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
                    +"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
            out.println("</table>");

            // Update order total
            sql = "UPDATE ordersummary SET totalAmount=? WHERE orderId=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setDouble(1, total);
            pstmt.setInt(2, orderId);            
            pstmt.executeUpdate();                        

            out.println("<h1>Order completed.  Will be shipped soon...</h1>");
            out.println("<h1>Your order reference number is: "+orderId+"</h1>");
            out.println("<h1>Shipping to customer: "+custId+" Name: "+custName+"</h1>");

            // Insert payment method into paymentmethod table
            sql = "INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES(?, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, "Credit Card");
            pstmt.setString(2, cardNumber);
            pstmt.setDate(3, java.sql.Date.valueOf("20" + cardExpiry.substring(3) + "-" + cardExpiry.substring(0, 2) + "-01"));
            pstmt.setInt(4, num);
            pstmt.executeUpdate();

            out.println("<h2><a href=\"shop.jsp\">Return to shopping</a></h2>");
            
            // Clear session variables (cart)
            session.setAttribute("productList", null);
        }
    }
    catch (SQLException ex)
    {  
        out.println(ex);
    }    
    finally
    {
        closeConnection();
    }
}
%>
</body>
</html>
