<%-- 
    Document   : cart
    Created on : 19-Mar-2019, 06:14:20
    Author     : Nathan
--%>

<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*;" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" import="shopserverpkg.Product" %>
<%
    if (request.getParameter("checkout") != null) {
        int order_no = (int)Math.round(Math.random() * 1000000);
        int customer_no = (int)Math.round(Math.random() * 1000000);
        float total_price = Float.parseFloat(request.getParameter("totalprice"));
        String billing_address = "24 Garden Rose Green";
        String card_type = "Credit";

        // today's date
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date dateNow = Calendar.getInstance().getTime();
        String order_date = dateFormat.format(dateNow);

        // connecting to database
        Connection con = null;
        PreparedStatement st = null;
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

        // insertion process - storing order
        try {
            String sql = "insert into orders values (?, ?, ?, ?, ?, ?)";
            st = con.prepareStatement(sql);
            st.setInt(1, order_no);
            st.setInt(2, customer_no);
            st.setString(3, billing_address);
            st.setString(4, card_type);
            st.setFloat(5, total_price);
            st.setTimestamp(6, Timestamp.valueOf(order_date));

            st.executeUpdate();

        } catch(Exception e) {
            System.out.println("Query Exception:");
            System.out.println(e.getMessage());
            st.close();
            con.close();
        }

//        session.invalidate();
        response.sendRedirect(request.getContextPath());
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
                        <input type="hidden" name="totalprice" value="<%= totalPrice %>">
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
