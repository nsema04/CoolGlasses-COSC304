<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoolGlasses Checkout</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 20px;
            text-align: center;
        }

        h1 {
            color: #007bff;
            margin-bottom: 20px;
        }

        form {
            display: inline-block;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        input[type="text"] {
            width: 80%;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"], input[type="reset"] {
            padding: 10px 20px;
            font-size: 1rem;
            border: none;
            border-radius: 4px;
            color: white;
            background-color: #007bff;
            cursor: pointer;
            margin: 0 10px;
        }

        input[type="reset"] {
            background-color: #dc3545;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        input[type="reset"]:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

    <h1>Enter Your Customer ID</h1>
    <p>Please provide your customer ID to complete the transaction.</p>

    <form method="get" action="order.jsp">
        <input type="text" name="customerId" placeholder="Enter your customer ID" required>
        <br>
        <input type="submit" value="Submit">
        <input type="reset" value="Reset">
    </form>

</body>
</html>
