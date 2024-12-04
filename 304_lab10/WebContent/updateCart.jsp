<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Get the current list of products from the session
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList != null && !productList.isEmpty()) {
        for (String id : productList.keySet()) {
            ArrayList<Object> product = productList.get(id);
            String action = request.getParameter("action_" + id);
            int quantity = (Integer) product.get(3);

            if ("increase".equals(action)) {
                quantity++; // Increase quantity by 1
            } else if ("decrease".equals(action) && quantity > 1) {
                quantity--; // Decrease quantity by 1, but ensure it doesn't go below 1
            }

            // Update the quantity in the product list
            product.set(3, quantity);
        }
        
        // Save updated product list in the session
        session.setAttribute("productList", productList);
    }

    // Redirect back to the cart page
    response.sendRedirect("seeCart.jsp");
%>
