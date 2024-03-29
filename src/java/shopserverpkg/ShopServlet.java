/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package shopserverpkg;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Nathan
 */
@WebServlet(name = "ShopServlet", urlPatterns = {"/ShopServlet"})
public class ShopServlet extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        
        // retrieving current session or setting new session
        HttpSession session = request.getSession(true);
        
        // preparing session attributes
        ArrayList cartList = (ArrayList)session.getAttribute("cartlist");
        // gathering current action param
        String action = request.getParameter("action");
        // getting referring uri for redirection in POST requests
        String referrer = request.getHeader("referer");
        // preparing total price calculation for any requeust
        float total = 0;
        
        if (action.equals("Add to cart")) {

            float id = Float.parseFloat(request.getParameter("id"));
            String pName = request.getParameter("product_name");
            float pPrice = Float.parseFloat(request.getParameter("product_price"));
            int pQuantity = Integer.parseInt(request.getParameter("product_quantity"));
            int pStockQuantity = Integer.parseInt(request.getParameter("product_stock_qty"));
            String pType = request.getParameter("product_Type");

            Product product = new Product(id, pName, pPrice, pQuantity, pType, pStockQuantity);

            if (cartList == null || cartList.isEmpty()) {
                cartList = new ArrayList();
                cartList.add(product);
                total += product.getPrice() * product.getQuantity();

            } else {
                boolean exists = false;

                for (int i = 0; i < cartList.size(); i++) {
                    Product item = (Product)cartList.get(i);
                    if (item.getID() == product.getID()) {
                        exists = true;
                        int quantity = item.getQuantity();
                        ((Product)cartList.get(i)).setQuantity(quantity+pQuantity);
                    }
                    total += item.getPrice() * item.getQuantity();
                }
                if (exists == false) {
                    cartList.add(product);
                    total += product.getPrice() * product.getQuantity();
                }
            }
            session.setAttribute("cartlist", cartList);
            session.setAttribute("totalprice", total);
            response.sendRedirect(referrer);
        }

        else if (action.equals("Remove")) {
            float id = Float.parseFloat(request.getParameter("id"));
            float totalPrice = (float)session.getAttribute("totalprice");

            for (int i = 0; i < cartList.size(); i++) {
                Product item = (Product)cartList.get(i);
                if (item.getID() == id) {
                    cartList.remove(item);
                    totalPrice -= item.getPrice() * item.getQuantity();
                }
            }
            session.setAttribute("cartlist", cartList);
            session.setAttribute("totalprice", totalPrice);
            if (totalPrice == 0) session.removeAttribute("checkingout");
            response.sendRedirect(referrer);

        } else if (action.equals("Update Quantity")) {
            int updatedQuantity = Integer.parseInt(request.getParameter("updatedQuantity"));
            float id = Float.parseFloat(request.getParameter("id"));
            Product currentItem;

            for (int i = 0; i < cartList.size(); i++) {
                Product item = (Product)cartList.get(i);
                if (item.getID() == id) {
                    currentItem = item;
                    currentItem.setQuantity(updatedQuantity);
                    cartList.set(i, currentItem);
                }
                total += item.getPrice() * item.getQuantity();
            }
            session.setAttribute("cartlist", cartList);
            session.setAttribute("totalprice", total);
            response.sendRedirect(referrer);

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
