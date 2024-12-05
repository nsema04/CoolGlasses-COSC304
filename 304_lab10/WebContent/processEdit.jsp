<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
    String oldUsername = (String) session.getAttribute("authenticatedUser");
    session = request.getSession(true);
    String userType = (String) session.getAttribute("userType");
    String authenticatedUser = null;

    try {
        authenticatedUser = validateLogin(out, request, session, userType, oldUsername);
    } catch (IOException e) {
        System.err.println(e);
    }

    // Redirecting to appropriate pages based on the result
    if (authenticatedUser == null) {
        response.sendRedirect("failedChange.jsp?param=itsnull");
    } else if (authenticatedUser.equals("error")) {
        response.sendRedirect("failedChange.jsp?param=error");
    } else if (authenticatedUser.equals("blank")) {
        response.sendRedirect("failedChange.jsp?param=blank");
    } else if (authenticatedUser.equals("taken")) {
        response.sendRedirect("failedChange.jsp?param=taken");
    } else if (authenticatedUser.equals("diff")) {
        response.sendRedirect("failedChange.jsp?param=diff");
    } else {
        response.sendRedirect("customer.jsp");
    }
%>

<%!
    // Function to validate and update customer data
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session, String userType, String oldUsername) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
        String phonenum = request.getParameter("phonenum"); // Use phonenum instead of phone
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalcode = request.getParameter("postalcode");
        String country = request.getParameter("country");
        String retStr = null;

        try {
            // Load the JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String getQuery = "SELECT * FROM customer WHERE userId = ?";
            PreparedStatement pstmtGet = con.prepareStatement(getQuery);
            pstmtGet.setString(1, oldUsername);
            ResultSet rstGet = pstmtGet.executeQuery();

            if (rstGet.next()) {
                // Fetching old values
                String oldPass = rstGet.getString("password");
                String oldFirst = rstGet.getString("firstName");
                String oldLast = rstGet.getString("lastName");
                String oldEmail = rstGet.getString("email");
                String oldPhone = rstGet.getString("phonenum"); // Correct column name is phonenum
                String oldAddress = rstGet.getString("address");
                String oldCity = rstGet.getString("city");
                String oldState = rstGet.getString("state");
                String oldPostalCode = rstGet.getString("postalCode");
                String oldCountry = rstGet.getString("country");

                // Fallback to old values if no input provided
                if (username == null || username.isEmpty()) username = oldUsername;
                if (password == null || password.isEmpty()) password = oldPass;
                if (password2 == null || password2.isEmpty()) password2 = oldPass;
                if (firstname == null || firstname.isEmpty()) firstname = oldFirst;
                if (lastname == null || lastname.isEmpty()) lastname = oldLast;
                if (email == null || email.isEmpty()) email = oldEmail;
                else email += request.getParameter("domain");

                if (phonenum == null || phonenum.isEmpty()) phonenum = oldPhone; // Use phonenum here
                if (address == null || address.isEmpty()) address = oldAddress;
                if (city == null || city.isEmpty()) city = oldCity;
                if (state == null || state.isEmpty()) state = oldState;
                if (postalcode == null || postalcode.isEmpty()) postalcode = oldPostalCode;
                if (country == null || country.isEmpty()) country = oldCountry;

                // Check if new username is taken
                if (!username.equals(oldUsername)) {
                    String checkUserSQL = "SELECT customerId FROM customer WHERE userId = ?";
                    PreparedStatement checkUserStmt = con.prepareStatement(checkUserSQL);
                    checkUserStmt.setString(1, username);
                    ResultSet userResult = checkUserStmt.executeQuery();
                    if (userResult.next()) return "taken";
                }

                // Validate passwords
                if (!password.equals(password2)) return "diff";

                // Update customer information
                String updateSQL = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, userId = ?, password = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE userId = ?";
                PreparedStatement updateStmt = con.prepareStatement(updateSQL);
                updateStmt.setString(1, firstname);
                updateStmt.setString(2, lastname);
                updateStmt.setString(3, email);
                updateStmt.setString(4, username);
                updateStmt.setString(5, password);
                updateStmt.setString(6, phonenum); // Update phonenum here
                updateStmt.setString(7, address);
                updateStmt.setString(8, city);
                updateStmt.setString(9, state);
                updateStmt.setString(10, postalcode);
                updateStmt.setString(11, country);
                updateStmt.setString(12, oldUsername);
                updateStmt.executeUpdate();

                retStr = username;
            }
        } catch (Exception e) {
            out.println("Error: " + e);
            return "error";
        }

        // Update session attributes
        if (retStr != null) {
            session.removeAttribute("loginMessage");
            if (userType.equals("customer")) session.setAttribute("authenticatedUser", username);
        } else {
            session.setAttribute("loginMessage", "Try Again.");
        }

        return retStr;
    }
%>
