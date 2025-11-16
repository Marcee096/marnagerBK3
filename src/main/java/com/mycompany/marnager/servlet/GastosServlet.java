package com.mycompany.marnager.servlet;

import com.mycompany.marnager.ejb.GastoFacade;
import com.mycompany.marnager.model.Gasto;
import com.mycompany.marnager.model.Usuario;
import java.io.IOException;
import java.util.List;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "GastosServlet", urlPatterns = {"/gastos"})
public class GastosServlet extends HttpServlet {

    @EJB
    private GastoFacade gastoFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        List<Gasto> listaGastos = gastoFacade.findByUser(usuario);
        
        request.setAttribute("gastos", listaGastos);
        request.getRequestDispatcher("/WEB-INF/jsp/gastos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lógica para añadir un nuevo gasto
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar los gastos del usuario";
    }
}
