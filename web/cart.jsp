<%-- 
    Document   : cart
    Created on : 19-Mar-2019, 06:14:20
    Author     : Nathan
--%>

<%@ page import="java.util.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" import="shopserverpkg.Product" %>
<% request.setAttribute("title", "Cart - "); %>
<%
    if (request.getParameter("checkout") != null) {
        session.setAttribute("checkingout", true);
        response.sendRedirect(request.getContextPath() + "/checkout.jsp");
    }
%>
<jsp:include page="partials/header.jsp" flush="true" />
    <% ArrayList items = (ArrayList)session.getAttribute("cartlist"); %>
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />

        <main class="container inner-body">
            <div class="row cart-list">
                <%
                    if (items != null && !items.isEmpty()) {
                        float totalPrice = (Float)session.getAttribute("totalprice");
                        String totalPriceFormatted = String.format("%.2f", totalPrice);

                        for (int i = 0; i < items.size(); i++) {
                            Product item = (Product)items.get(i);
                %>
                <div class="row">
                    <form method="post" action="ShopServlet">
                        <%= item.getName() %>
                        <b>
                            &emsp; £<%= item.getPrice() %> &times;
                            <input class="updatedQuantityInput"
                                   style="width: 50px"
                                   type="number"
                                   name="updatedQuantity"
                                   min="1"
                                   value="<%= item.getQuantity() %>">
                        </b>
                        <div class="cart-item-options">
                            <input type="hidden" name="id" value="<%= item.getID() %>">
                            <input class="btn btn-success update-qty-btn" type="submit" name="action" value="Update Quantity" style="display: none">
                            <input class="btn btn-danger remove-btn" type="submit" name="action" value="Remove">
                        </div>
                    </form>
                </div>
                <% } %>

                <br>
                <div class="total" style="margin-bottom: 1em">Total: £<%= totalPriceFormatted %></div>
                <div class="checkout">
                    <form method="get">
                        <input class="btn btn-success" type="submit" name="checkout" value="Checkout">
                    </form>
                </div>
                <% } else { %>
                    <p style="font-weight: bold; text-align: center">No items in cart.</p>
                <% } %>
            </div>
        </main>
            
            <script>
                $(".updatedQuantityInput").on("change keypress", function(){
                   $(this).closest("form").find(".update-qty-btn").show();
                });
            </script>

    </body>
</html>
