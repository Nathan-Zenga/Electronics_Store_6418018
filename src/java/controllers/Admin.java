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
import javax.servlet.http.HttpSession;
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
        
        HttpSession session = request.getSession(true);

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

        // updating delievery status of specified product (POST req)
        if (request.getParameter("new_delivery_status") != null) {
            String new_delivery_status = request.getParameter("new_delivery_status");
            int order_no = Integer.parseInt(request.getParameter("order_no"));

            try {
                String sql = "update orders set delivery_status = ? where order_no = ?";
                st = con.prepareStatement(sql);
                st.setString(1, new_delivery_status);
                st.setInt(2, order_no);
                st.executeUpdate();
                st.close();
                con.close();

                session.setAttribute("success", "Updated delivery status for order no: " + order_no);
                response.getWriter().println(request.getHeader("referer"));

            } catch(Exception e) {
                System.out.println("Query Exception:");
                System.out.println(e.getMessage());
                session.setAttribute("error", "Error occured whilst updating delivery status");
                response.sendRedirect(request.getContextPath());
            }

        // Saving new product
        } else if (request.getParameter("save-product") != null) {

            long id = new RandomID().generate();
            String product_name = request.getParameter("product_name");
            double product_price = Double.parseDouble(request.getParameter("product_price"));
            String product_image = request.getParameter("product_image");
            String product_type = request.getParameter("product_type");
            int product_stock_qty = Integer.parseInt(request.getParameter("stock_qty"));

            if (product_image != null && !product_image.isEmpty()) {
                new ImageDownloader().save(request, product_image, product_name.replaceAll(" ", "_"));
            }

            if (request.getParameter("new_category") != null && !request.getParameter("new_category").isEmpty()) {
                product_type = request.getParameter("new_category");
            }

            // formatting product type field before db insertion
            product_type = product_type.replaceAll("&| and |,", "_").replaceAll(" ", "").toLowerCase();

            // insertion process
            try {
                String sql = "insert into products values (?, ?, ?, ?, ?)";
                st = con.prepareStatement(sql);
                st.setLong(1, id);
                st.setString(2, product_name);
                st.setDouble(3, product_price);
                st.setString(4, product_type);
                st.setInt(5, product_stock_qty);

                st.executeUpdate();

                st.close();
                con.close();

            } catch(Exception e) {
                System.out.println("Query Exception:");
                System.out.println(e.getMessage());
                session.setAttribute("error", "Error occured whilst saving product");
                response.sendRedirect(request.getContextPath());
            }

            // Refreshing page after insertion to display success message
            session.setAttribute("success", "Product saved!");
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
                st = con.prepareStatement(
                        sql,
                        ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_READ_ONLY
                );
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
