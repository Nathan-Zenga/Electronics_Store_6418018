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
import java.text.SimpleDateFormat;
import java.util.*;
import javax.sql.*;
import java.sql.*;
import javax.servlet.RequestDispatcher;

/**
 *
 * @author Nathan
 */
@WebServlet(name = "Checkout", urlPatterns = {"/checkout"})
public class Checkout extends HttpServlet {

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

        // Checkout page is unaccessible if attribute invalid
        // unless user pressed Checkout button from cart page
        if (session.getAttribute("checkingout") == null) {
            response.sendRedirect(request.getHeader("referer"));

        } else if (request.getParameter("purchase") != null) {
            int order_no = (int)Math.round(Math.random() * 1000000);
            int customer_no = (int)Math.round(Math.random() * 1000000);
            float total_price = (Float)session.getAttribute("totalprice");
            String name = request.getParameter("fullname");
            String billing_address = request.getParameter("billing_address");
            String card_type = request.getParameter("card_type");

            // Getting today's date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            java.util.Date dateNow = Calendar.getInstance().getTime();
            String order_date = dateFormat.format(dateNow);

            // Connecting to database
            Connection con = null;
            PreparedStatement st = null;
            String url = "jdbc:derby://localhost/electronic_store_DB";
            String user = "nat";
            String pass = "nat";

            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                con = DriverManager.getConnection(url, user, pass);

            } catch(Exception e){
                System.out.println("No Conection: " + e);
                response.sendRedirect(request.getContextPath());
            }

            // Insertion process - storing order
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
                st.close();

            } catch(Exception e) {
                System.out.println("Query Exception:");
                System.out.println(e.getMessage());
            }
            session.removeAttribute("checkingout");
            session.setAttribute("checkedout", true);
            response.sendRedirect(request.getContextPath());
        } else {

            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/checkout.jsp");
            dispatcher.forward(request, response);
        }
    }

    // <editor-fold defaultstate collapsed" desc HttpServlet methods. Click on the + sign on the left to edit the code.">
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
