<form method="post" action="order.jsp">
    <!-- Customer Information -->
    <label for="customerId">Customer ID:</label>
    <input type="text" name="customerId" size="50" required><br><br>

    <!-- Shipping Information -->
    <h3>Shipping Information</h3>
    <label for="shippingAddress">Shipping Address:</label>
    <input type="text" name="shippingAddress" size="50" required><br><br>

    <label for="shippingCity">City:</label>
    <input type="text" name="shippingCity" size="50" required><br><br>

    <label for="shippingState">State:</label>
    <input type="text" name="shippingState" size="50" required><br><br>

    <label for="shippingZip">Zip/Postal Code:</label>
    <input type="text" name="shippingZip" size="20" required><br><br>

    <label for="shippingCountry">Country:</label>
    <input type="text" name="shippingCountry" size="50" required><br><br>

    <!-- Payment Information -->
    <h3>Payment Information</h3>
    <label for="cardNumber">Credit Card Number:</label>
    <input type="text" name="cardNumber" size="20" required><br><br>

    <label for="cardExpiry">Expiration Date (MM/YY):</label>
    <input type="text" name="cardExpiry" size="5" required><br><br>

    <label for="cardCVC">CVC (Security Code):</label>
    <input type="text" name="cardCVC" size="3" required><br><br>

    <!-- Submit Button -->
    <input type="submit" value="Complete Order">
    <input type="reset" value="Reset">
</form>
