<%-- 
    Document   : admin
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
    // passed as parameter to render page to include order summary section
    String order_summary_id = request.getParameter("order_summary_id");
%>
<jsp:include page="partials/header.jsp" flush="true" />
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />
        <main class="container inner-body">

            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item"><a class="nav-link <%= order_summary_id != null ? "" : "active" %>" id="add-product-tab" data-toggle="tab" href="#add-product" role="tab" aria-controls="add-product" aria-selected="true">Add new product</a></li>
                <li class="nav-item"><a class="nav-link" id="orders-tab" data-toggle="tab" href="#orders-history" role="tab" aria-controls="orders-history" aria-selected="false">Order history</a></li>
                <% if (order_summary_id != null) { %>
                <li class="nav-item"><a class="nav-link active" id="order-summary-tab" data-toggle="tab" href="#order-summary" role="tab" aria-controls="order-summary" aria-selected="false">Order summary</a></li>
                <% } %>
            </ul>


            <div class="tab-content">
                <div class="tab-pane fade <%= order_summary_id != null ? "" : "show active" %>" id="add-product" role="tabpanel" aria-labelledby="add-product-tab">
                    <h2>Add new Product</h2>
                    <form class="new-product-form" method="get">
                        <input class="form-control" type="text" name="product_name" placeholder="Product name" required>
                        <input class="form-control" type="text" name="product_image" placeholder="Product image (enter URL)">
                        <div class="product_price input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">£</span>
                            </div>
                            <input class="form-control" type="number" step="0.01" name="product_price" min="0" placeholder="Price" required>
                        </div>
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
                        <input class="form-control" type="number" name="stock_qty" min="0" placeholder="Set stock quantity" required>
                        <input class="form-control btn-secondary" type="submit" name="save-product" value="Save product">
                    </form>
                </div>

                <div class="tab-pane fade" id="orders-history" role="tabpanel" aria-labelledby="orders-tab">
                    <table>
                        <tr>
                            <th>Order number</th>
                            <th>Customer number</th>
                            <th>Total charged</th>
                            <th>Delivery status</th>
                            <th></th>
                        </tr>
                        <%
                        String[] status_opts = {"Pending", "Not Delivered", "Delivered"};
                        rs = (ResultSet)request.getAttribute("rs_orders");
                        while(rs.next()) {
                        %>
                        <tr id="<%= rs.getInt("order_no") %>">
                            <td><%= rs.getInt("order_no") %></td>
                            <td><%= rs.getInt("customer_no") %></td>
                            <td>£<%= rs.getDouble("total_price") %></td>
                            <td>
                                <form method="post">
                                    <select class="form-control" name="edit_del_stat" value="Edit Delivery Status">
                                    <% for (String status : status_opts) { 
                                    if (rs.getString("delivery_status").equals(status)) { %>
                                        <option selected><%= status %></option>
                                    <% } else { %>
                                        <option><%= status %></option>
                                    <% }} %>
                                    </select>
                                </form>
                            </td>
                            <td>
                                <a href="/admin?order_summary_id=<%= rs.getInt("order_no") %>"><button class="form-control btn-success">View summary</button></a>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                </div>

                <% if (order_summary_id != null) { %>
                <div class="tab-pane fade show active" id="order-summary" role="tabpanel" aria-labelledby="order-summary-tab">
                    <%
                    rs.beforeFirst(); // move cursor back to before first row
                    while(rs.next()) {
                        if (rs.getInt("order_no") == Integer.parseInt(order_summary_id)) {
                    %>
                    <div class="row">
                        <div class="col-6 float-left">
                            <p><b>Order number</b></p>
                            <p><%= rs.getInt("order_no") %></p>
                        </div>
                        <div class="col-6 float-left">
                            <p><b>Customer number</b></p>
                            <p><%= rs.getInt("customer_no") %></p>
                        </div>
                    </div>
                    <br>

                    <div class="row">
                        <div class="col-sm-6 float-sm-left">
                            <p><b>Customer fullname</b></p>
                            <p><%= rs.getString("customer_name") %></p>
                        </div>
                        <div class="col-sm-6 float-sm-left">
                            <p><b>Billing address</b></p>
                            <p><%= rs.getString("billing_address") %></p>
                        </div>
                    </div>
                    <br>

                    <div class="row">
                        <div class="col-6 float-left">
                            <p><b>Card number</b></p>
                            <p><%= rs.getString("card_no") %></p>
                        </div>
                        <div class="col-6 float-left">
                            <p><b>Card type</b></p>
                            <p><%= rs.getString("card_type") %></p>
                        </div>
                    </div>
                    <br>

                    <p><b>Items purchased</b></p>
                    <%
                    String[] itemsList = rs.getString("items_summary").split(" === ");
                    for (String item : itemsList) {
                    %>
                    <p><%= item %></p>
                    <% }}} %>
                </div>
                <% } %>

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
            
            $("select[name='edit_del_stat']").change(function(){
                var data = { new_delivery_status: this.value, order_no: $(this).closest("tr").attr("id") };
                $.post("/admin", data, function(referrer) {
                    location.href = referrer;
                });
            });
        </script>

        <%
            Statement st = (Statement)request.getAttribute("sql_statement");
            rs.close();
            st.close();
        %>

    </body>
</html>