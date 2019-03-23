<%-- 
    Document   : checkout
    Created on : 22-Mar-2019, 15:53:44
    Author     : Nathan
--%>

<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*;" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" import="shopserverpkg.Product" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% request.setAttribute("title", "Checkout - "); %>
<%
    if (session.getAttribute("checkingout") == null) {
        response.sendRedirect(request.getHeader("referer"));

    } else if (request.getParameter("purchase") != null) {
        int order_no = (int)Math.round(Math.random() * 1000000);
        int customer_no = (int)Math.round(Math.random() * 1000000);
        float total_price = (Float)session.getAttribute("totalprice");
        String name = request.getParameter("fullname");
        String billing_address = request.getParameter("billing_address");
        String card_type = request.getParameter("card_type");

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
            response.sendRedirect(request.getContextPath());
        }

        // insertion process - storing order
        try {
            String sql = "insert into orders values (?, ?, ?, ?, ?, ?, ?)";
            st = con.prepareStatement(sql);
            st.setInt(1, order_no);
            st.setInt(2, customer_no);
            st.setString(3, name);
            st.setString(4, billing_address);
            st.setString(5, card_type);
            st.setFloat(6, total_price);
            st.setTimestamp(7, Timestamp.valueOf(order_date));

            st.executeUpdate();

        } catch(Exception e) {
            System.out.println("Query Exception:");
            System.out.println(e.getMessage());
            st.close();
            con.close();
        }
        session.removeAttribute("checkingout");
        session.setAttribute("checkedout", true);
        response.sendRedirect(request.getContextPath());
    }
%>
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
