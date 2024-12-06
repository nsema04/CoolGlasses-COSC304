<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Account</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 0;
            color: #333;
        }

        .container {
            width: 80%;
            margin: 40px auto;
            background-color: white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            border-radius: 8px;
            text-align: center;
        }

        h3 {
            color: #2c3e50;
        }

        h2 {
            font-size: 18px;
            color: #7f8c8d;
        }

        form {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            text-align: left;
        }

        table {
            width: 100%;
            margin-top: 20px;
        }

        td {
            padding: 10px;
            text-align: left;
        }

        input[type="text"], input[type="password"], select {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        .submit {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .submit:hover {
            background-color: #2980b9;
        }

        .submit:active {
            background-color: #1c5980;
        }

        .back-link {
            margin-top: 20px;
            text-align: center;
        }

        .back-link a {
            color: #3498db;
            text-decoration: none;
            font-size: 16px;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

<div class="container">
    <h3>Edit Account</h3>
    <h2>Leave fields blank to leave them unchanged</h2>
    <% session.setAttribute("userType", "customer"); %>

    <form name="MyForm" method="post" action="processEdit.jsp">
        <table>
            <tr>
                <td><label for="username">Username:</label></td>
                <td><input type="text" id="username" name="username" maxlength="14"></td>
            </tr>
            <tr>
                <td><label for="firstname">First Name:</label></td>
                <td><input type="text" id="firstname" name="firstname" maxlength="14"></td>
            </tr>
            <tr>
                <td><label for="lastname">Last Name:</label></td>
                <td><input type="text" id="lastname" name="lastname" maxlength="14"></td>
            </tr>
            <tr>
                <td><label for="email">Email Address:</label></td>
                <td><input type="text" id="email" name="email" maxlength="14"></td>
                <td>
                    <select name="domain">
                        <option>@student.ubc.ca</option>
                        <option>@gmail.com</option>
                        <option>@outlook.com</option>
                        <option>@icloud.com</option>
                        <option>@hotmail.com</option>
                        <option>@yahoo.com</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td><label for="phonenum">Phone:</label></td>
                <td><input type="text" id="phonenum" name="phonenum" maxlength="14"></td>
            </tr>
            <tr>
                <td><label for="address">Address:</label></td>
                <td><input type="text" id="address" name="address" maxlength="50"></td>
            </tr>
            <tr>
                <td><label for="city">City:</label></td>
                <td><input type="text" id="city" name="city" maxlength="14"></td>
            </tr>
            <tr>
                <td><label for="state">State:</label></td>
                <td><input type="text" id="state" name="state" maxlength="14"></td>
            </tr>
            <tr>
                <td><label for="postalcode">Postal Code:</label></td>
                <td><input type="text" id="postalcode" name="postalcode" maxlength="10"></td>
            </tr>
            <tr>
                <td><label for="country">Country:</label></td>
                <td><input type="text" id="country" name="country" maxlength="14"></td>
            </tr>
            <tr>
                <td><label for="password">Password:</label></td>
                <td><input type="password" id="password" name="password" maxlength="14"></td>
            </tr>
            <tr>
                <td><label for="password2">Confirm Password:</label></td>
                <td><input type="password" id="password2" name="password2" maxlength="14"></td>
            </tr>
            <tr>
                <td></td>
                <td><input class="submit" type="submit" name="Submit2" value="Change Account Info"></td>
            </tr>
        </table>
    </form>

    <div class="back-link">
        <h2><a href="customer.jsp">Back</a></h2>
    </div>
</div>

</body>
</html>
