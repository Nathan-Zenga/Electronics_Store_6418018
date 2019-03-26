<%-- 
    Document   : admin_login
    Created on : 26-Mar-2019, 16:59:19
    Author     : Nathan
--%>

<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*;" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" import="shopserverpkg.Encrypt_Decrypt" %>
<% request.setAttribute("title", "Admin Login - "); %>
<%
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

    if (request.getParameter("login") != null) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            String sql = "select * from nat.store_admin where " +
                    "username='" + username + "'";

            st = (PreparedStatement)con.createStatement(
                ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_READ_ONLY
            );
            rs = st.executeQuery(sql);

        } catch(Exception e) {
            System.out.println("Query Exception:");
            System.out.println(e.getMessage());
            st.close();
            con.close();
        }

        boolean isMatch = false;

        // password match process
        if (rs.first()) {
            isMatch = new Encrypt_Decrypt().matchPassword(password, rs.getString("password"));
        }

        // indicates error if password is invalid
        if (!isMatch) {
            session.setAttribute("error", "Log in credentials are invalid");
            response.sendRedirect(request.getHeader("referer"));
        }
        response.sendRedirect(request.getContextPath() + "/admin.jsp");
    }

    if (request.getParameter("signup") != null) {
        String username = request.getParameter("username");
        String new_password = request.getParameter("new_password");
        String confirm_password = request.getParameter("confirm_password");

        try {
            String sql = "insert into nat.store_admin values " +
                    "username='" + username + "'";

            st = con.prepareStatement(sql);
            rs = st.executeQuery();

        } catch(Exception e) {
            System.out.println("Query Exception:");
            System.out.println(e.getMessage());
            st.close();
            con.close();
        }

    }

%>
<jsp:include page="partials/header.jsp" flush="true" />
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />
        <main class="container inner-body">
            <h2 style="margin-bottom: .5em">Admin Login</h2>
            <form class="log_in form" method="get">
                <input class="form-control" type="text" name="username" placeholder="Username" required>
                <input class="form-control" type="password" name="password" placeholder="Password" required>
                <input class="form-control btn-secondary" type="submit" name="login" value="Log in">
            </form>
        </main>
    </body>
</html>
