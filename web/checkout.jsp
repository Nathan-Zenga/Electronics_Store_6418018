<%-- 
    Document   : checkout
    Created on : 22-Mar-2019, 15:53:44
    Author     : Nathan
--%>

<%@ page session="true" import="shopserverpkg.Product" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% request.setAttribute("title", "Checkout - "); %>
<jsp:include page="partials/header.jsp" flush="true" />
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />

        <main class="container inner-body">
            <form class="form-group checkout-form" method="get">
                <input class="form-control" type="text" name="fullname" placeholder="Name" required>
                <input class="form-control" type="text" name="billing_address" placeholder="Billing address" required>
                <select class="form-control" name="card_type" required>
                    <option>Card type</option>
                    <option value="credit">Credit</option>
                    <option value="debit">Debit</option>
                </select>
                <input class="form-control" type="submit" name="purchase" value="Purchase">
            </form>
        </main>

    </body>
</html>
