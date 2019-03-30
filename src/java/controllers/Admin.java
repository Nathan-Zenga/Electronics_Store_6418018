/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import javax.sql.*;
import java.sql.*;
import javax.servlet.RequestDispatcher;
import shopserverpkg.*;


/**
 *
 * @author Nathan
 */
@WebServlet(name = "Admin", urlPatterns = {"/admin"})
public class Admin extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        // Saving new product
        if (request.getParameter("save-product") != null) {

            long id = new RandomID().generate();
            String product_name = request.getParameter("product_name");
            double product_price = Double.parseDouble(request.getParameter("product_price"));
            String product_image = request.getParameter("product_image");
            String product_type = request.getParameter("product_type");

            if (product_image != null && !product_image.isEmpty()) {
                new ImageDownloader().save(request, product_image, product_name.replaceAll(" ", "_"));
            }

            if (request.getParameter("new_category") != null && !request.getParameter("new_category").isEmpty()) {
                product_type = request.getParameter("new_category");
            }

            // replacing any of the following chars before db insertion
            product_type = product_type.replaceAll("&| and |,", "_").replaceAll(" ", "");

            // insertion process
            try {
                String sql = "insert into products values (?, ?, ?, ?)";
                st = con.prepareStatement(sql);
                st.setLong(1, id);
                st.setString(2, product_name);
                st.setDouble(3, product_price);
                st.setString(4, product_type);

                st.executeUpdate();

                st.close();
                con.close();

            } catch(Exception e) {
                System.out.println("Query Exception:");
                System.out.println(e.getMessage());
            }

            // Refreshing page after insertion to display success message
            request.setAttribute("success-msg", "Product saved!");
            response.sendRedirect(request.getHeader("referer"));

        } else {

            try {
                /**
                 * Retrieving category names to display as options
                 */

                String sql = "select product_type from nat.products " +
                        "order by product_type asc";
                st = con.prepareStatement(sql);
                rs = st.executeQuery();

                // to apply within admin.jsp
                request.setAttribute("rs_product_type", rs);


                /**
                 * Getting all order details, sorted by date (most recent first)
                 */

                sql = "select * from nat.orders " +
                        "order by order_date desc";
                st = con.prepareStatement(sql);
                rs = st.executeQuery();

                // to apply within admin.jsp
                request.setAttribute("rs_orders", rs);
                
                // to close at client-side (admin.jsp) to avoid SQLExceptoion
                request.setAttribute("sql_statement", st);

            } catch(Exception e) {
                System.out.println("Query Exception:");
                System.out.println(e.getMessage());
            }

            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/admin.jsp");
            dispatcher.forward(request, response);
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
