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

/**
 *
 * @author Nathan
 */
@WebServlet(name = "Index", urlPatterns = {""})
public class Index extends HttpServlet {

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

        // Establishing connection to database
        Connection con = null;
        Statement st = null;
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


        /**
         * Selecting names of product types to display
         * as links to product categories.
         */
        try {
            String sql = "select product_type from nat.products " +
                    "order by product_type asc";
            st = con.createStatement(
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY
            );
            rs = st.executeQuery(sql);


            // formatting links as HTML anchor elements
            String lastCategoryName = "";
            String links = "";
            while(rs.next()) {
                String category = rs.getString("product_type").trim();
                if (!category.equals(lastCategoryName)) {
                    String ctg = "<a href='?category="+ category.toLowerCase() +"'>" +
                            category.split("")[0].toUpperCase() +
                            category.substring(1) +
                            "</a>";
                    links += rs.isLast() ? ctg : ctg + "&emsp;&bull;&emsp;";
                }
                lastCategoryName = category;
            }

            // to unescape/decode included special characters
            request.setAttribute("links_htmlString", links);


            /**
             * Selecting and displaying all products from DB.
             */
            sql = "select * from nat.products";

            /**
             * Selecting and displaying products under
             * given category based on given parameter.
             */
            String categoryParam = request.getParameter("category");
            if (categoryParam != null) {
                sql = "select * from nat.products where product_type = '"+ categoryParam +"'";
            }

            st = con.createStatement();
            rs = st.executeQuery(sql);

            request.setAttribute("products_rs", rs);

        } catch(Exception e) {
            System.out.println("Query Exception:");
            System.out.println(e.getMessage());
        }

        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/index.jsp");
        dispatcher.forward(request, response);
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
