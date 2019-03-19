<%-- 
    Document   : cart
    Created on : 19-Mar-2019, 06:14:20
    Author     : Nathan
--%>

<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*;" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" import="shopserverpkg.Product" %>
<jsp:include page="partials/header.jsp" flush="true" />
    <% ArrayList items = (ArrayList)session.getAttribute("cartlist"); %>
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />

        <div class="cart-list container">
            <%
                if (items != null && !items.isEmpty()) {
                    float totalPriceValue = (Float)session.getAttribute("totalprice");
                    String totalPrice = String.format("%.2f", totalPriceValue);

                    for (int i = 0; i < items.size(); i++) {
                        Product item = (Product)items.get(i);
            %>
            <div class="row">
                <p><%= item.getName() %> <b>&times; <%= item.getQuantity() %></b> - <b>£<%= item.getPrice() %></b></p>
                <p>
                    <form method="post" action="ShopServlet">
                        <input type="hidden" name="id" value="<%= item.getID() %>">
                        <input class="btn btn-danger" type="submit" name="action" value="Remove">
                    </form>
                </p>
            </div>
            <% } %>
            <br>
            <div class="total" style="margin-bottom: 1em">
                Total: £<%= totalPrice %>
            </div>
            <div class="checkout">
                <form method="post" action="ShopServlet">
                    <input type="hidden" name="totalprice" value="<%= totalPriceValue %>">
                    <input class="btn btn-success" type="submit" name="action" value="Checkout">
                </form>
            </div>
            <% } else { %>
                <p>No items in cart.</p>
            <% } %>
        </div>

    </body>
</html>
