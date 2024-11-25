<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Screen</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f8ff; /* Light blue background */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background: #ffffff;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 300px;
        }

        h3 {
            margin-bottom: 20px;
            color: #333;
        }

        .error-message {
            color: #ff0000;
            margin-bottom: 10px;
        }

        table {
            margin: 0 auto;
            width: 100%;
        }

        td {
            padding: 10px 5px;
            text-align: left;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 10px;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h3>Please Login to System</h3>
        <% 
        // Print prior error login message if present
        if (session.getAttribute("loginMessage") != null) {
        %>
            <p class="error-message">
                <%= session.getAttribute("loginMessage").toString() %>
            </p>
        <% } %>
        <form name="MyForm" method="post" action="validateLogin.jsp">
            <table>
                <tr>
                    <td><label for="username">Username:</label></td>
                    <td><input type="text" name="username" id="username" maxlength="10" required></td>
                </tr>
                <tr>
                    <td><label for="password">Password:</label></td>
                    <td><input type="password" name="password" id="password" maxlength="10" required></td>
                </tr>
            </table>
            <input type="submit" name="Submit2" value="Log In">
        </form>
    </div>
</body>
</html>

