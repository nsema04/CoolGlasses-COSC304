<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Get the current list of products from the session
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList != null) {
        String id = request.getParameter("id");
        if (id != null) {
            productList.remove(id);  // Remove the item by its ID
            session.setAttribute("productList", productList);  // Update the session
        }
    }

    // Redirect back to the cart view
    response.sendRedirect("seeCart.jsp");
%>
