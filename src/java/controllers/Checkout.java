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
import shopserverpkg.Product;

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
        ArrayList cartlist = (ArrayList)session.getAttribute("cartlist");

        // Checkout page is unaccessible if attribute invalid
        // unless user pressed checkout button or cart not empty
        if (session.getAttribute("checkingout") == null && (cartlist == null || cartlist.isEmpty())) {
            session.setAttribute("error", "Invalid entry");
            response.sendRedirect("/");

        } else if (request.getParameter("purchase") != null) {
            int order_no = (int)Math.round(Math.random() * 1000000);
            int customer_no = (int)Math.round(Math.random() * 1000000);
            float total_price = Float.parseFloat(request.getParameter("totalprice"));
            String fullname = request.getParameter("fullname");
            String[] card_no = request.getParameterValues("card_no");
            String billing_address = request.getParameter("billing_address");
            String card_type = request.getParameter("card_type");
            String items_summary = "";

            // hiding card details
            card_no[0] = "****";
            card_no[1] = "****";
            card_no[2] = "****";
            String card_no_formatted = String.join("-", card_no);

            // saving summary of cart items as string for later parsing
            for (int i = 0; i < cartlist.size(); i++) {
                Product item = (Product)cartlist.get(i);
                String item_detail = item.getName() + " - £" + String.format("%.2f", item.getPrice()) + " x " + item.getQuantity();
                items_summary += (i == 0) ? item_detail : " === "+item_detail;
            }

            // Getting today's date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            java.util.Date dateNow = Calendar.getInstance().getTime();
            String order_date = dateFormat.format(dateNow);

            // Connecting to database
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
                System.out.println("No Conection: " + e);
                session.setAttribute("error", "No connection");
                response.sendRedirect(request.getContextPath());
            }

            try {
                // Insertion process - storing order
                String sql = "insert into orders values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                st = con.prepareStatement(sql);
                st.setInt(1, order_no);
                st.setInt(2, customer_no);
                st.setString(3, fullname);
                st.setString(4, billing_address);
                st.setString(5, card_no_formatted);
                st.setString(6, card_type);
                st.setFloat(7, total_price);
                st.setTimestamp(8, Timestamp.valueOf(order_date));
                st.setString(9, items_summary);
                st.setString(10, "Pending");
                st.executeUpdate();

                // updating stock quantity of products sold
                for (int i = 0; i < cartlist.size(); i++) {
                    Product item = (Product)cartlist.get(i);
                    int new_stock_qty = item.getStockQuantity() - item.getQuantity();

                    sql = "update products set product_stock_qty = ? where product_name = ?";
                    st = con.prepareStatement(sql);
                    st.setInt(1, new_stock_qty);
                    st.setString(2, item.getName());
                    st.executeUpdate();
                }

                st.close();

            } catch(Exception e) {
                System.out.println("Query Exception:");
                System.out.println(e.getMessage());
                session.setAttribute("error", "Error: Query Exception");
                response.sendRedirect(request.getContextPath());
            }
            
            String msg = "Your purchase is complete. Thank you for shopping with us! " +
                    "Your order number is " + order_no;
            session.removeAttribute("checkingout");
            session.setAttribute("checkedout_msg", msg); // for success message
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
