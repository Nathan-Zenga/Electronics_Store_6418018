<%-- 
    Document   : index.jsp
    Created on : 18-Mar-2019, 16:16:38
    Author     : Nathan
--%>

<%@page import="java.util.*" %>
<%@page import="javax.sql.*;" %>
<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Electronics Store</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="./css/main.css">
    </head>
    <%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    String url = "jdbc:derby://localhost/electronic_store_DB";
    String user = "nat";
    String pass = "nat";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        con = DriverManager.getConnection(url, user, pass);

    } catch(Exception e){
        e.printStackTrace();
        System.out.println("No Conection: " + e);
    }

    try {
        String sql = "select * from nat.products";
        st = con.createStatement();
        rs = st.executeQuery(sql);
//        System.out.println("After SQL - " + st);
//        System.out.println("RS - " + rs);
    } catch(Exception e) {
        System.out.println("Query Exception:");
        System.out.println(e.getMessage());
        rs.close();
        st.close();
        con.close();
    }
    %>
    <body>
        <div class="header">
            <div class="container">
                <div class="row title">
                    <h1>Electronics Store</h1>
                </div>
                <div class="row header-content">
                    <% ArrayList cartlist = (ArrayList) session.getAttribute("cartlist"); %>
                    <% int cartcount = cartlist != null ? cartlist.size() : 0; %>
                    <i class="fas fa-shopping-cart"></i> <span class="count"><%= cartcount %></span>
                </div>
            </div>
        </div>

        <div class="product-list container">
            <% while(rs.next()){ %>
            <% String product_name = rs.getString("product_name"); %>
            <div class="product col-sm-4">
                <div class="product-image"
                     style="background-image: url('./img/<%= product_name %>.jpg')">
                </div>
                <div class="product-name"><%= product_name %></div>
                <div class="product-price">£<%= rs.getString("product_price") %></div>
                <div class="options">
                    <form method="get">
                        <input type="hidden" name="id" value="<%= rs.getFloat("id") %>">
                        <input class="form-control btn btn-default" type="submit" name="add" value="Add to cart">
                    </form>
                </div>
            </div>
            <% } %>
        </div>

    </body>
</html>
