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
                <div class="form-group">
                    <div class="row" style="margin: 0 -15px">
                        <div class="col-sm-3 float-sm-left"><input class="form-control" type="number" name="card_no" min="1000" max="5000" placeholder="Card number" required></div>
                        <div class="col-sm-3 float-sm-left"><input class="form-control" type="number" name="card_no" min="1000" max="5000" required></div>
                        <div class="col-sm-3 float-sm-left"><input class="form-control" type="number" name="card_no" min="1000" max="5000" required></div>
                        <div class="col-sm-3 float-sm-left"><input class="form-control" type="number" name="card_no" min="1000" max="5000" required></div>
                    </div>
                </div>
                <select class="form-control" name="card_type" required>
                    <option>Card type</option>
                    <option value="Credit">Credit</option>
                    <option value="Debit">Debit</option>
                </select>
                <input type="hidden" type="number" step="0.01" name="totalprice" value="<%= session.getAttribute("totalprice") %>">
                <input class="form-control btn-secondary" type="submit" name="purchase" value="Purchase">
            </form>
        </main>

    </body>
</html>
