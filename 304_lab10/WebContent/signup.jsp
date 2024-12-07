<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Creation</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h3 {
            color: #333333;
            margin-bottom: 20px;
        }

        form {
            width: 100%;
        }

        table {
            width: 100%;
            margin: 0 auto;
            border-spacing: 10px;
        }

        td {
            padding: 10px;
            text-align: left;
        }

        label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 5px;
            color: #555555;
        }

        input[type="text"], input[type="password"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }

        input[type="text"]:focus, input[type="password"]:focus, select:focus {
            border-color: #4CAF50;
            outline: none;
        }

        .submit {
            background-color: #4CAF50;
            color: #ffffff;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .submit:hover {
            background-color: #45a049;
        }

        .back-link {
            margin-top: 20px;
        }

        .back-link a {
            color: #4CAF50;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h3>Create Account</h3>
    <% session.setAttribute("userType", "customer"); %>
    <form name="MyForm" method="post" action="processSignup.jsp">
        <table>
            <tr>
                <td>
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" maxlength="14" required>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="firstname">First Name</label>
                    <input type="text" id="firstname" name="firstname" maxlength="14" required>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="lastname">Last Name</label>
                    <input type="text" id="lastname" name="lastname" maxlength="14" required>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="email">Email Address</label>
                    <div style="display: flex; gap: 10px;">
                        <input type="text" id="email" name="email" maxlength="14" style="flex: 1;" required>
                        <select name="domain" style="flex: 1;">
                            <option>@student.ubc.ca</option>
                            <option>@gmail.com</option>
                            <option>@outlook.com</option>
                            <option>@icloud.com</option>
                            <option>@hotmail.com</option>
                            <option>@yahoo.com</option>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" maxlength="14" required>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="password2">Confirm Password</label>
                    <input type="password" id="password2" name="password2" maxlength="14" required>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">
                    <input class="submit" type="submit" value="Create Account">
                </td>
            </tr>
        </table>
    </form>

    <div class="back-link">
        <p><a href="shop.jsp">Back to Homepage</a></p>
    </div>
</div>

</body>
</html>
