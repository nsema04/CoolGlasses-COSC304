<!DOCTYPE html>
<html>
<head>
    <title>CoolGlasses - Login</title>
</head>
<body>

<!-- Header Section -->
<H1 align="center">
    <font face="cursive" color="#3399FF">
        <a href="index.jsp">CoolGlasses</a>
    </font>
</H1>
<hr>

<%
    // Check if the user is authenticated and retrieve their username
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName != null) {
%>
    <h3 align="center">Signed in as: <%= userName %></h3>
    <!-- Navigation Menu for logged-in users -->
    <div style="text-align: center; margin-top: 10px;">
        <button onclick="window.location.href='index.jsp'" style="padding: 10px 20px; font-size: 16px; cursor: pointer;">
            Back to Home
        </button>
        <button onclick="window.location.href='seeCart.jsp'" style="padding: 10px 20px; font-size: 16px; cursor: pointer; margin-left: 10px;">
            See Cart
        </button>
        <button onclick="window.location.href='logout.jsp'" style="padding: 10px 20px; font-size: 16px; cursor: pointer; margin-left: 10px;">
            Log Out
        </button>
    </div>
<%
    } else {
%>
    <!-- Login Form for users not logged in -->
    <div style="margin:0 auto;text-align:center;display:inline">
        <h3>Please Login to System</h3>

        <%-- Print prior error login message if present --%>
        <%
            if (session.getAttribute("loginMessage") != null)
                out.println("<p>" + session.getAttribute("loginMessage").toString() + "</p>");
        %>

        <br>
        <form name="MyForm" method="post" action="validateLogin.jsp">
            <table style="display:inline">
                <tr>
                    <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
                    <td><input type="text" name="username" size="10" maxlength="10"></td>
                </tr>
                <tr>
                    <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
                    <td><input type="password" name="password" size="10" maxlength="10"></td>
                </tr>
            </table>
            <br/>
            <input class="submit" type="submit" name="Submit2" value="Log In">
        </form>

        <br/>
        <!-- Sign Up Link -->
        <p><a href="signup.jsp" style="font-size: 14px;">No account? Sign Up Here</a></p>
    </div>
<%
    }
%>

<hr>

</body>
</html>
