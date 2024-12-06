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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses Order Summary</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding-top: 20px;
        }
        h1, h2 {
            color: #2c3e50;
            text-align: center;
        }
        .order-summary, .order-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .order-summary th, .order-summary td, .order-table th, .order-table td {
            padding: 12px 20px;
            border: 1px solid #ddd;
        }
        .order-summary th, .order-table th {
            background-color: #3498db;
            color: #fff;
            text-align: left;
        }
        .order-summary td, .order-table td {
            background-color: #ecf0f1;
        }
        .order-summary tr:nth-child(even), .order-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .order-summary td, .order-table td {
            text-align: center;
        }
        .total {
            font-size: 20px;
            font-weight: bold;
            color: #27ae60;
        }
        .cta-button {
            display: block;
            margin: 30px auto;
            background-color: #3498db;
            color: #fff;
            text-align: center;
            padding: 15px;
            border-radius: 5px;
            text-decoration: none;
            width: 200px;
            font-size: 18px;
        }
        .cta-button:hover {
            background-color: #2980b9;
        }
        .footer {
            text-align: center;
            font-size: 14px;
            color: #7f8c8d;
            margin-top: 40px;
        }
        .footer a {
            color: #3498db;
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>CoolGlasses Order Summary</h1>

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
        out.println("<h1>Invalid customer id. Please go back and try again.</h1>");
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
            out.println("<h1>Invalid customer id. Please go back and try again.</h1>");
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
                out.println("<h1>Invalid customer id. Please go back and try again.</h1>");
            else
            {   
                custName = rst.getString(2);

                // Insert order information into OrderSummary table
                sql = "INSERT INTO ordersummary (customerId, totalAmount, orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) VALUES(?, 0, ?, ?, ?, ?, ?, ?);";

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

                out.println("<h2>Your Order Summary</h2>");
                out.println("<table class='order-table'><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

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
                        +"<td align=\"right\" class='total'>"+currFormat.format(total)+"</td></tr>");
                out.println("</table>");

                // Update order total
                sql = "UPDATE ordersummary SET totalAmount=? WHERE orderId=?";
                pstmt = con.prepareStatement(sql);
                pstmt.setDouble(1, total);
                pstmt.setInt(2, orderId);            
                pstmt.executeUpdate();                        

                out.println("<h2>Order completed! Your glasses will be shipped soon...</h2>");
                out.println("<h3>Your order reference number is: <strong>"+orderId+"</strong></h3>");
                out.println("<h3>Shipping to: "+custName+"</h3>");

                // Insert payment method into paymentmethod table
                sql = "INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES(?, ?, ?, ?)";
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, "Credit Card");
                pstmt.setString(2, cardNumber);
                pstmt.setString(3, cardExpiry);
                pstmt.setInt(4, num);
                pstmt.executeUpdate();
            } 
        }
        catch (SQLException e)
        {
            out.println("<h1>Error processing your order. Please try again.</h1>");
        }
    }
    %>
    <a href="shop.jsp" class="cta-button">Go back to homepage</a>
</div>

<div class="footer">
    <p>&copy; 2024 CoolGlasses, Inc. | <a href="#">Privacy Policy</a></p>
</div>

</body>
</html>
