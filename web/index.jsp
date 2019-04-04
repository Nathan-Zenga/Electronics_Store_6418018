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
<% request.setAttribute("title", ""); %>
<jsp:include page="partials/header.jsp" flush="true" />
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />

        <main class="container inner-body">
            <div class="row sub-nav categories">
                ${links_htmlString}
            </div>
            <div class="row product-list">
                <%
                // Displaying products from result set
                ResultSet rs = (ResultSet)request.getAttribute("products_rs");

                while(rs.next()) {
                    String id = rs.getString("id");
                    String product_name = rs.getString("product_name");
                    String product_price = rs.getString("product_price");
                    String product_type = rs.getString("product_type");
                    String product_sq = rs.getString("product_stock_qty");
                %>
                <div class="product col-md-4 float-md-left">
                    <div class="product-image"
                         style="background-image: url('./img/<%= product_name.replaceAll(" ", "_") %>.jpg')">
                    </div>
                    <div class="product-name"><%= product_name %></div>
                    <div class="product-info row">
                        <div class="product-price col-6 float-left">£<%= product_price %></div>
                        <div class="product-stock-qty col-6 float-left">In Stock: <b><%= product_sq %></b></div>
                    </div>
                    <div class="options">
                        <form method="post" action="ShopServlet">
                            <input type="hidden" name="id" value="<%= id %>" required>
                            <input type="hidden" name="product_name" value="<%= product_name %>" required>
                            <input type="hidden" name="product_price" value="<%= product_price %>" required>
                            <input type="hidden" name="product_type" value="<%= product_type %>" required>
                            <input type="hidden" name="product_stock_qty" value="<%= product_sq %>" required>
                            <div class="quantity input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Quantity</span>
                                </div>
                                <input class="form-control" type="number" name="product_quantity" value="1" min="1" max="<%= product_sq %>" required>
                            </div>
                                <% if (Integer.parseInt(product_sq) == 0) { %>
                                <input class="form-control btn btn-secondary" type="submit" name="action" value="Add to cart" disabled>
                            <% } else { %>
                                <input class="form-control btn btn-secondary" type="submit" name="action" value="Add to cart">
                            <% } %>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
        </main>

    </body>
</html>
