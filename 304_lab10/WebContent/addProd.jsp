<%@ include file="jdbc.jsp" %>
<%@ page language="java" import="java.io.*,java.sql.*,java.time.LocalDate,java.time.format.*"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f7fa;
        }
        .container {
            max-width: 800px;
            margin-top: 20px;
        }
        .sidebar {
            background-color: #343a40;
            color: white;
            padding: 20px;
            height: 100%;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            margin: 10px 0;
            display: block;
        }
        .sidebar a:hover {
            background-color: #575d63;
            padding-left: 10px;
        }
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .form-control {
            margin-bottom: 15px;
        }
        .btn-primary {
            width: 100%;
        }
    </style>
</head>
<body>

<div class="d-flex">
    <!-- Sidebar -->
    <div class="sidebar">
        <h3>Admin Panel</h3>
        <a href="admin.jsp">Back To Dashboard</a>
    </div>

    <!-- Main Content -->
    <div class="container">
        <h1 class="text-center mb-4">Add New Product</h1>

        <div class="form-container">
            <form action="addProd.jsp" method="post">
                <div class="form-group">
                    <label for="productName">Product Name:</label>
                    <input type="text" class="form-control" id="productName" name="productName" required>
                </div>

                <div class="form-group">
                    <label for="categoryId">Category:</label>
                    <select id="categoryId" name="categoryId" class="form-control" required>
                        <option value="1">Sunglasses</option>
                        <option value="2">Prescription Glasses</option>
                        <option value="3">Reading Glasses</option>
                        <option value="4">Blue Light Glasses</option>
                        <option value="5">Sports Glasses</option>
                        <option value="6">Safety Glasses</option>
                        <option value="7">Fashion Glasses</option>
                        <option value="8">Kids Glasses</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="productDesc">Description:</label>
                    <textarea id="productDesc" name="productDesc" class="form-control" required></textarea>
                </div>

                <div class="form-group">
                    <label for="productPrice">Price:</label>
                    <input type="number" id="productPrice" name="productPrice" class="form-control" step="0.01" required>
                </div>

                <button type="submit" class="btn btn-primary">Add Product</button>
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
                    out.println("<div class='alert alert-info'>" + message + "</div>");
                }
            %>
        </div>

        <button onclick="window.location.href='admin.jsp'" class="btn btn-secondary mt-4">Back to Admin</button>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

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
