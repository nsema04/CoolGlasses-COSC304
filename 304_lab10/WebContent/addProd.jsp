<%@ include file="jdbc.jsp" %>
<%@ page language="java" import="java.io.*,java.sql.*,java.time.LocalDate,java.time.format.*"%>

<html>
<head>
    <title>Add Product</title>
</head>
<body>
    <h1>Add New Product</h1>
    <form action="addProd.jsp" method="post">
        <label for="productName">Product Name:</label><br>
        <input type="text" id="productName" name="productName" required><br><br>

        <label for="categoryId">Category:</label><br>
        <select id="categoryId" name="categoryId" required>
            <option value="1">Sunglasses</option>
            <option value="2">Prescription Glasses</option>
            <option value="3">Reading Glasses</option>
            <option value="4">Blue Light Glasses</option>
            <option value="5">Sports Glasses</option>
            <option value="6">Safety Glasses</option>
            <option value="7">Fashion Glasses</option>
            <option value="8">Kids Glasses</option>
        </select><br><br>

        <label for="productDesc">Description:</label><br>
        <textarea id="productDesc" name="productDesc" required></textarea><br><br>

        <label for="productPrice">Price:</label><br>
        <input type="number" id="productPrice" name="productPrice" step="0.01" required><br><br>

        <input type="submit" value="Add Product">
    </form>

    <%
        // Handle form submission for adding a product
        String outcome = null;
        String message = null;

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            try {
                outcome = addProduct(out, request, session);
                if ("success".equals(outcome)) {
                    message = "Product added successfully!";
                    // Set the message to the request scope
                    request.setAttribute("message", message);
                    // Forward to the admin page with the message
                    RequestDispatcher dispatcher = request.getRequestDispatcher("admin.jsp");
                    dispatcher.forward(request, response); 
                    return; // Stop further processing
                } else if ("blank".equals(outcome)) {
                    message = "Please fill in all required fields.";
                } else {
                    message = "Error: " + outcome;
                }
            } catch (IOException e) {
                message = "Error processing your request: " + e.getMessage();
            }
        }

        if (message != null) {
            out.println("<h2>" + message + "</h2>");
        }
    %>

<%!
    String addProduct(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String retStr = null;
        String prodName = request.getParameter("productName");
        String priceStr = request.getParameter("productPrice");
        String desc = request.getParameter("productDesc");

        String categoryIdStr = request.getParameter("categoryId");

        // Check if any field is blank
        if (prodName == null || priceStr == null || desc == null || categoryIdStr == null) {
            return "blank";
        }

        // Parse the input values
        double price = Double.parseDouble(priceStr);
        int categoryId = Integer.parseInt(categoryIdStr);

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String SQL = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(SQL);
            pstmt.setString(1, prodName);
            pstmt.setDouble(2, price);
            pstmt.setString(3, desc);
            pstmt.setInt(4, categoryId);

            pstmt.executeUpdate();
            retStr = "success";
        } catch (Exception e) {
            retStr = "error";
            return e.toString();
        }

        return retStr;
    }
%>
<button onclick="window.location.href='admin.jsp'">Back to Admin</button>
</body>
</html>
