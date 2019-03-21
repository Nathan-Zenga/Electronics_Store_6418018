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
    %>
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />

        <% if (session.getAttribute("checkedout") != null) { %>
        <div class="checkout-msg btn-success" style="padding: 10px 0; text-align: center; font-weight: bold; margin-bottom: 1em">
            <div class="container">
                Your purchase is complete. Thank you for shopping with us!
            </div>
        </div>
        <% session.invalidate();
        } %>
        
        <main class="container inner-body">
            <div class="row sub-nav categories">
                <%
                    /**
                     * Selecting names of product types to display
                     * as links to product categories.
                     */
                    try {
                        String sql = "select product_type from nat.products " +
                                "order by product_type asc";
                        st = con.createStatement(
                                ResultSet.TYPE_SCROLL_INSENSITIVE,
                                ResultSet.CONCUR_READ_ONLY
                        );
                        rs = st.executeQuery(sql);

                    } catch(Exception e) {
                        System.out.println("Query Exception:");
                        System.out.println(e.getMessage());
                        rs.close();
                        st.close();
                        con.close();
                    }

                    String lastCategoryName = "";
                    String links = "";
                    while(rs.next()) {
                        String category = rs.getString("product_type").trim();
                        if (!category.equals(lastCategoryName)) {
                            String ctg = "<a href='?category="+ category.toLowerCase() +"'>" +
                                    category.split("")[0].toUpperCase() +
                                    category.substring(1) +
                                    "</a>";
                            links += rs.isLast() ? ctg : ctg + "&emsp;&bull;&emsp;";
                        }
                        lastCategoryName = category;
                    }
                    // to unescape/decode included special characters - '&emsp;'
                    request.setAttribute("linksString", links);
                %>
                ${linksString}
            </div>
            <div class="row product-list">
                <%
                    String categoryParam = request.getParameter("category");
                    String sql;

                    try {
                        if (categoryParam != null) {
                            /**
                             * Selecting and displaying products under
                             * given category.
                             */
                            sql = "select * from nat.products where product_type = '"+ categoryParam +"'";
                        } else {
                            /**
                             * Selecting and displaying all products from DB.
                             */
                            sql = "select * from nat.products";
                        }
                        st = con.createStatement();
                        rs = st.executeQuery(sql);

                    } catch(Exception e) {
                        System.out.println("Query Exception:");
                        System.out.println(e.getMessage());
                        rs.close();
                        st.close();
                        con.close();
                    }

                    while(rs.next()){
                    String id = rs.getString("id");
                    String product_name = rs.getString("product_name");
                    String product_price = rs.getString("product_price");
                    String product_type = rs.getString("product_type");
                %>
                <div class="product col-md-4 float-md-left">
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
        </main>

    </body>
</html>
