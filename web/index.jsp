<%-- 
    Document   : index.jsp
    Created on : 18-Mar-2019, 16:16:38
    Author     : Nathan
--%>

<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*;" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" import="shopserverpkg.Product" %>
<jsp:include page="partials/header.jsp" flush="true" />
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

    } catch(Exception e) {
        System.out.println("Query Exception:");
        System.out.println(e.getMessage());
        rs.close();
        st.close();
        con.close();
    }
    %>
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />

        <div class="product-list container">
            <% while(rs.next()){
               String id = rs.getString("id");
               String product_name = rs.getString("product_name");
               String product_price = rs.getString("product_price");
               String product_type = rs.getString("product_type"); %>
            <div class="product col-sm-4 float-sm-left">
                <div class="product-image"
                     style="background-image: url('./img/<%= product_name %>.jpg')">
                </div>
                <div class="product-name"><%= product_name %></div>
                <div class="product-price">£<%= product_price %></div>
                <div class="options">
                    <form method="post" action="ShopServlet">
                        <input type="hidden" name="id" value="<%= id %>">
                        <input type="hidden" name="product_name" value="<%= product_name %>">
                        <input type="hidden" name="product_price" value="<%= product_price %>">
                        <input type="hidden" name="product_type" value="<%= product_type %>">
                        <div class="quantity input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Quantity</span>
                            </div>
                            <input class="form-control" type="number" name="product_quantity" value="1" min="1">
                        </div>
                        <input class="form-control btn btn-secondary" type="submit" name="action" value="Add to cart">
                    </form>
                </div>
            </div>
            <% } %>
        </div>

    </body>
</html>
