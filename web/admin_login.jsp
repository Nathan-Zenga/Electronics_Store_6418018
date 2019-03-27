<%-- 
    Document   : admin_login
    Created on : 26-Mar-2019, 16:59:19
    Author     : Nathan
--%>

<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*;" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="javax.crypto.*" %>
<%@ page import="javax.crypto.spec.*" %>
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

    // ===== LOG IN PROCESS =====
    if (request.getParameter("login") != null && !request.getParameter("login").isEmpty()) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            String sql = "select * from nat.store_admin where " +
                    "username='" + username + "'";

            st = con.prepareStatement(
                sql,
                ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_READ_ONLY
            );
            rs = st.executeQuery();

        } catch(Exception e) {
            System.out.println("Query Exception:");
            System.out.println(e.getMessage());
            st.close();
            con.close();
        }
        
        // move to first row of resultset as one result is expected
        rs.first();
        
        // decyphering saved secret key
        byte[] sk = rs.getString("sk").getBytes();
        SecretKey originalKey = new SecretKeySpec(sk, 0, sk.length, "AES");

        // password match process
        Encrypt_Decrypt decrypt = new Encrypt_Decrypt();
        boolean isMatch = decrypt.matchPassword(password, rs.getString("password"), originalKey);

        if (!isMatch) {
            session.setAttribute("error", "Log in credentials are invalid");
            response.sendRedirect(request.getHeader("referer"));
        }

        session.setAttribute("user", true);
        response.sendRedirect(request.getContextPath() + "/admin.jsp");
    }

    // ===== SIGN UP PROCESS =====
    if (request.getParameter("signup") != null && !request.getParameter("signup").isEmpty()) {
        String new_username = request.getParameter("new_username");
        String new_password = request.getParameter("new_password");
        String confirm_password = request.getParameter("confirm_password");

        /* 
         create key 
         If we need to generate a new key use a KeyGenerator
         If we have existing plaintext key use a SecretKeyFactory
        */ 
        KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
        keyGenerator.init(128); // block size is 128bits
        SecretKey secretKey = keyGenerator.generateKey();
        String sk = new String(secretKey.getEncoded());

        String encryptedPassword = new Encrypt_Decrypt().encrypt(new_password, secretKey);

        try {
            String sql = "insert into nat.store_admin values (?, ?, ?, ?)";

            st = con.prepareStatement(sql);
            st.setLong(1, Math.round(Math.random()*10000));
            st.setString(2, new_username);
            st.setString(3, encryptedPassword);
            st.setString(4, sk);
            st.executeUpdate();

        } catch(Exception e) {
            System.out.println("Query Exception:");
            System.out.println(e.getMessage());
            st.close();
            con.close();
        }
        
        session.setAttribute("success", "Successfully registered!");
        response.sendRedirect(request.getHeader("referer"));

    }

%>
<jsp:include page="partials/header.jsp" flush="true" />
    <body>
        <jsp:include page="partials/body-header.jsp" flush="true" />
        <main class="container inner-body">

            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="log-in-tab" data-toggle="tab" href="#log-in" role="tab" aria-controls="log-in" aria-selected="true">Log in</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="sign-up-tab" data-toggle="tab" href="#sign-up" role="tab" aria-controls="sign-up" aria-selected="false">Sign up</a>
                </li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane fade show active" id="log-in" role="tabpanel" aria-labelledby="log-in-tab">
                    <h2 style="margin-bottom: .5em">Login as Admin</h2>
                    <form class="log_in form" method="get">
                        <input class="form-control" type="text" name="username" placeholder="Username" required>
                        <input class="form-control" type="password" name="password" placeholder="Password" required>
                        <input class="form-control btn-secondary" type="submit" name="login" value="Log in">
                    </form>
                </div>
                <div class="tab-pane fade" id="sign-up" role="tabpanel" aria-labelledby="sign-up-tab">
                    <h2 style="margin-bottom: .5em">Sign up as Admin</h2>
                    <form class="log_in form" method="get">
                        <input class="form-control" type="text" name="new_username" placeholder="Username" required>
                        <input class="form-control" type="password" name="new_password" placeholder="New Password" required>
                        <div id="password-error btn danger" style="display: none">Confirm password does not match!</div>
                        <input class="form-control" type="password" name="confirm_password" placeholder="Confirm Password" required>
                        <input class="form-control btn-secondary" id="signup-btn" type="submit" name="signup" value="Sign up">
                    </form>
                </div>
            </div>
        </main>
        <script>
            $("#sign-up input[type='password']").change(function(){
                var newPass = $("input[name='new_password']").val();
                var confirmPass = $("input[name='confirm_password']").val();
                if (newPass !== confirmPass) {
                    $("#password-error").show();
                    $("#signup-btn").attr("disabled", true);
                } else {
                    $("#password-error").hide();
                    $("#signup-btn").removeAttr("disabled");
                }
            });
        </script>
    </body>
</html>
