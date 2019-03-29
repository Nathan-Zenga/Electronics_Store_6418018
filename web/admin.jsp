<%-- 
    Document   : profile
    Created on : 23-Mar-2019, 14:20:10
    Author     : Nathan
--%>

<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*;" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" import="shopserverpkg.RandomID, shopserverpkg.ImageDownloader" %>
<%
    // preparing name to prepend to title element
    request.setAttribute("title", "Admin - ");
%>
<jsp:include page="partials/header.jsp" flush="true" />
    <body>
        <%
            if (request.getAttribute("success-msg") != null) {
        %>
        <div class="msg btn-success">
            <%= request.getAttribute("success-msg") %>
        </div>
        <%
            }
        %>
        <jsp:include page="partials/body-header.jsp" flush="true" />
        <main class="container inner-body">

            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="add-product-tab" data-toggle="tab" href="#add-product" role="tab" aria-controls="add-product" aria-selected="true">Add new product</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="orders-tab" data-toggle="tab" href="#orders-history" role="tab" aria-controls="orders-history" aria-selected="false">Order history</a>
                </li>
            </ul>


            <div class="tab-content">
                <div class="tab-pane fade show active" id="add-product" role="tabpanel" aria-labelledby="add-product-tab">
                    <h2>Add new Product</h2>
                    <form class="new-product-form" method="get">
                        <input class="form-control" type="text" name="product_name" placeholder="Product name" required>
                        <input class="form-control" type="text" name="product_price" placeholder="Price" required>
                        <input class="form-control" type="text" name="product_image" placeholder="Product image (enter URL)">
                        <div class="product_type input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Select category</span>
                            </div>
                            <select class="form-control" type="text" name="product_type" placeholder="Category" required>
                                    <option value=""></option>
                                <%
                                ResultSet rs = (ResultSet)request.getAttribute("rs_product_type");
                                String lastSelectedType = "";
                                while(rs.next()) {
                                    String option = rs.getString("product_type");
                                    if (!lastSelectedType.equals(option)) {
                                %>
                                <option value="<%= option %>">
                                    <%= option.split("")[0].toUpperCase() + option.substring(1) %>
                                </option>
                                <%
                                    }
                                    lastSelectedType = option;
                                }
                                %>
                                <option value="new">Add new category...</option>
                            </select>
                        </div>
                        <input class="form-control" type="text" name="new_category" placeholder="Enter new category" style="display: none">
                        <input class="form-control btn-secondary" type="submit" name="save-product" value="Save product">
                    </form>
                </div>

                <div class="tab-pane fade" id="orders-history" role="tabpanel" aria-labelledby="orders-tab">
                    <table>
                        <tr>
                            <th>Order number</th>
                            <th>Customer number</th>
                            <th>Customer name</th>
                            <th>Billing address</th>
                            <th>Card type</th>
                            <th>Total charged</th>
                        </tr>
                        <%
                        rs = (ResultSet)request.getAttribute("rs_orders");
                        while(rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("order_no") %></td>
                            <td><%= rs.getInt("customer_no") %></td>
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getString("billing_address") %></td>
                            <td><%= rs.getString("card_type") %></td>
                            <td>£<%= rs.getDouble("total_price") %></td>
                        </tr>
                        <% } %>
                    </table>
                </div>
            </div>
        </main>
                
        <script>
            $("select[name='product_type']").change(function(){
                if ($(this).val() === "new") {
                    $(this).removeAttr("required");
                    $("input[name='new_category']").show().attr("required", "true");
                } else {
                    $(this).attr("required", "true");
                    $("input[name='new_category']").val("").hide().removeAttr("required");
                }
            });
        </script>

    </body>
</html>