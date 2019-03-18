<%-- 
    Document   : index.jsp
    Created on : 18-Mar-2019, 16:16:38
    Author     : Nathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="javax.sql.*;" %>
<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Electronics Store</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    </head>
    <%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    String url = "jdbc:derby://localhost/JSP_DB";
    String user = "nat";
    String pass = "nat";
    String IDvalue = request.getParameter("id");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        con = DriverManager.getConnection(url, user, pass);

    } catch(Exception e){
        e.printStackTrace();
        System.out.println("No Conection: " + e);
    }

    try {
        String sql = "select * from NAT.EMPLOYEE";
        st = con.createStatement();
        rs = st.executeQuery(sql);
        System.out.println("After SQL - " + st);
        System.out.println("RS - " + rs);

    } catch(Exception e) {
        System.out.println("Query Exception:");
        System.out.println(e.getMessage());
        rs.close();
        st.close();
        con.close();
    }
    %>
    <body>
        <h1>Hello World!</h1>

        <% while(rs.next()){ %>
        <tr>
            <% for(int i = 1; i <= 5; i++){
               if (i == 1) id = rs.getString(i); %>
            <td><%= rs.getString(i) %></td>
            <% } %>
            <td>
                <form method="get">
                    <input type="text" name="id" value="<%= id %>" style="display: none">
                    <input class="form-control btn btn-danger" type="submit" name="delete" value="Delete">
            </form>
            </td>
            </tr>
        <% } %>


    </body>
</html>
