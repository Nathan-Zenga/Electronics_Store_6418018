<%-- 
    Document   : body-header
    Created on : 19-Mar-2019, 06:50:45
    Author     : Nathan
--%>

<%@ page session="true" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
        <header class="header">
            <div class="container">
                <div class="row title">
                    <h1><a href="<%= request.getContextPath() %>">Electronics Store</a></h1>
                </div>
                <div class="row header-content">
                    <% ArrayList cartlist = (ArrayList) session.getAttribute("cartlist"); %>
                    <% int cartcount = cartlist != null ? cartlist.size() : 0; %>
                    <a class="cart-icon" href='cart.jsp'>
                        <span>
                            <i class="fas fa-shopping-cart"></i> <%= cartcount %>
                        </span>
                    </a>
                </div>
            </div>
        </header>
        <% if (session.getAttribute("error") != null) { %>
        <div class="msg btn-danger">
            <%= session.getAttribute("error") %>
        </div>
        <% session.removeAttribute("error");
        } else if (session.getAttribute("success") != null) { %>
        <div class="msg btn-success">
            <%= session.getAttribute("success") %>
        </div>
        <% session.removeAttribute("success");
        } %>
