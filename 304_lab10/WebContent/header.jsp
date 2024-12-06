<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        /* Header styling */
        .header {
            background-color: #3399FF;
            color: white;
            padding: 10px 20px;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
        }

        .header a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            margin: 0 15px;
        }

        .header a:hover {
            text-decoration: underline;
        }

        .header .logo {
            font-size: 24px;
            font-weight: bold;
            font-family: cursive;
        }

        .header .nav-links {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header .user-info {
            font-size: 16px;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <!-- Header Section -->
    <div class="header">
        <!-- Left Section: Admin Link + Logo -->
        <div style="display: flex; align-items: center;">
            <!-- Admin Link -->
            <a href="admin.jsp">Admin</a>

            <!-- Logo -->
            <div class="logo">
                <a href="shop.jsp">CoolGlasses</a>
            </div>
        </div>

        <!-- Right Section: Navigation Links and User Info -->
        <div class="nav-links">
            <a href="shop.jsp">Home</a>
            <a href="listprod.jsp">Shop</a>
            <a href="seeCart.jsp">Cart</a>
            <% 
                // Dynamic user info and login/logout button
                String userName = (String) session.getAttribute("authenticatedUser");
                if (userName != null) { 
            %>
                <span class="user-info">
                    Welcome, <a href="customer.jsp" style="color: white; text-decoration: underline;"><%= userName %></a>!
                </span>
                <a href="logout.jsp" class="button" style="color: white; text-decoration: underline;">Log Out</a>
            <% 
                } else { 
            %>
                <a href="login.jsp" class="button" style="color: white; text-decoration: underline;">Log In</a>
            <% 
                } 
            %>
        </div>
    </div>
</body>
</html>
