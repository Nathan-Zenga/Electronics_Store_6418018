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
    
    // Establishing Java DB connection
    Connection con = null;
    PreparedStatement st = null;
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

    if (request.getParameter("save-product") != null) {

        long id = new RandomID().generate();
        String product_name = request.getParameter("product_name");
        double product_price = Double.parseDouble(request.getParameter("product_price"));
        String product_image = request.getParameter("product_image");
        String product_type = request.getParameter("product_type");
        
        if (product_image != null && !product_image.isEmpty()) {
            new ImageDownloader().save(request, product_image, product_name.replaceAll(" ", "_"));
        }

        if (request.getParameter("new_category") != null || !request.getParameter("new_category").isEmpty()) {
            product_type = request.getParameter("new_category");
        }

        // insertion process - saving new product
        try {
            String sql = "insert into products values (?, ?, ?, ?)";
            st = con.prepareStatement(sql);
            st.setLong(1, id);
            st.setString(2, product_name);
            st.setDouble(3, product_price);
            st.setString(4, product_type);

            st.executeUpdate();

        } catch(Exception e) {
            System.out.println("Query Exception:");
            System.out.println(e.getMessage());
            st.close();
            con.close();
        }

        request.setAttribute("success-msg", "Product saved!");
        response.sendRedirect(request.getHeader("referer"));
    }

    // restricting page access to admin authentication
    if (session.getAttribute("isSignedIn") == null) /*{
        session.setAttribute("error", "Please sign in");
        response.sendRedirect("admin_sign_in.jsp");
    } else */{
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
                                // retrieving category names to display as options
                                try {
                                    String sql = "select product_type from nat.products " +
                                            "order by product_type asc";
                                    st = con.prepareStatement(sql);
                                    rs = st.executeQuery();

                                } catch(Exception e) {
                                    System.out.println("Query Exception:");
                                    System.out.println(e.getMessage());
                                    rs.close();
                                    st.close();
                                    con.close();
                                }

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
                        // getting all order details, sorted by date (most recent first)
                        try {
                            String sql = "select * from nat.orders " +
                                    "order by order_date desc";
                            st = con.prepareStatement(sql);
                            rs = st.executeQuery();

                        } catch(Exception e) {
                            System.out.println("Query Exception:");
                            System.out.println(e.getMessage());
                            rs.close();
                            st.close();
                            con.close();
                        }

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
<% } %>