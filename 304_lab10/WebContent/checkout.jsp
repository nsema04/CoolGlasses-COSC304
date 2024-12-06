<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <style>
        /* Global Styles */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            color: #333;
        }

        h1, h3 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        h1 {
            font-size: 2.5rem;
        }

        h3 {
            font-size: 1.5rem;
            color: #2980b9;
        }

        /* Form Container */
        .form-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            display: flex;
            flex-direction: column;
        }

        /* Input Fields */
        input[type="text"], input[type="submit"], input[type="reset"] {
            font-size: 1rem;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 100%;
        }

        input[type="submit"], input[type="reset"] {
            background-color: #3498db;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover, input[type="reset"]:hover {
            background-color: #2980b9;
        }

        /* Labels */
        label {
            font-size: 1rem;
            margin-bottom: 5px;
            color: #555;
        }

        /* Section Styles */
        .section {
            margin-bottom: 30px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .form-container {
                width: 90%;
                padding: 20px;
            }

            h1 {
                font-size: 2rem;
            }

            h3 {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>

    <div class="form-container">
        <h1>Checkout</h1>

        <form method="post" action="order.jsp">

            <!-- Customer Information -->
            <div class="section">
                <label for="customerId">Customer ID:</label>
                <input type="text" name="customerId" size="50" required>
            </div>

            <!-- Shipping Information -->
            <div class="section">
                <h3>Shipping Information</h3>
                <label for="shippingAddress">Shipping Address:</label>
                <input type="text" name="shippingAddress" size="50" required>

                <label for="shippingCity">City:</label>
                <input type="text" name="shippingCity" size="50" required>

                <label for="shippingState">State:</label>
                <input type="text" name="shippingState" size="50" required>

                <label for="shippingZip">Zip/Postal Code:</label>
                <input type="text" name="shippingZip" size="20" required>

                <label for="shippingCountry">Country:</label>
                <input type="text" name="shippingCountry" size="50" required>
            </div>

            <!-- Payment Information -->
            <div class="section">
                <h3>Payment Information</h3>
                <label for="cardNumber">Credit Card Number:</label>
                <input type="text" name="cardNumber" size="20" required>

                <label for="cardExpiry">Expiration Date (MM/YY):</label>
                <input type="text" name="cardExpiry" size="5" required>

                <label for="cardCVC">CVC (Security Code):</label>
                <input type="text" name="cardCVC" size="3" required>
            </div>

            <!-- Submit Buttons -->
            <div class="section">
                <input type="submit" value="Complete Order">
                <input type="reset" value="Reset">
            </div>
        </form>
    </div>

</body>
</html>
