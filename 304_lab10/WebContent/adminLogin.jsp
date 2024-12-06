<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f4f4;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }
        .form-control {
            border-radius: 25px;
            margin-bottom: 15px;
        }
        .btn {
            border-radius: 25px;
        }
        .form-group label {
            font-size: 1.1em;
        }
        .text-center {
            text-align: center;
        }
        .error-message {
            color: red;
            font-size: 1em;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h3 class="text-center">Admin Login</h3>

    <% 
        // Check if user is already logged in as admin
        if (session.getAttribute("adminLoggedIn") == null) {
    %>
        <p class="error-message text-center">You have not been authorized to access the admin dashboard.</p>
    <% 
        }
    %>

    <form name="MyForm" method="post" action="validateLogin.jsp">
        <!-- Hidden field to indicate admin login -->
        <input type="hidden" name="fromAdminLogin" value="true">

        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" class="form-control" size="10" maxlength="10" required>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" class="form-control" size="10" maxlength="10" required>
        </div>

        <div class="text-center">
            <input class="btn btn-primary" type="submit" name="Submit2" value="Log In">
        </div>
    </form>

    <p class="text-center mt-3">No account? <a href="signup.jsp">Sign Up Here</a></p>
    <p class="text-center mt-3">Not an admin? <a href="login.jsp">Go to User Login</a></p>
</div>

<!-- Bootstrap JS and Popper.js (required for Bootstrap components) -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
