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

                // Fallback to old values if no input provided
                if (username == null || username.isEmpty()) username = oldUsername;
                if (password == null || password.isEmpty()) password = oldPass;
                if (password2 == null || password2.isEmpty()) password2 = oldPass;
                if (firstname == null || firstname.isEmpty()) firstname = oldFirst;
                if (lastname == null || lastname.isEmpty()) lastname = oldLast;
                if (email == null || email.isEmpty()) email = oldEmail;
                else email += request.getParameter("domain");

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
                String updateSQL = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, userId = ?, password = ? WHERE userId = ?";
                PreparedStatement updateStmt = con.prepareStatement(updateSQL);
                updateStmt.setString(1, firstname);
                updateStmt.setString(2, lastname);
                updateStmt.setString(3, email);
                updateStmt.setString(4, username);
                updateStmt.setString(5, password);
                updateStmt.setString(6, oldUsername);
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
