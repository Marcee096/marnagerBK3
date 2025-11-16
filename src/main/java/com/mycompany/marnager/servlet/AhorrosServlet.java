package com.mycompany.marnager.servlet;

import com.mycompany.marnager.ejb.AhorroFacade;
import com.mycompany.marnager.model.Ahorro;
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

@WebServlet(name = "AhorrosServlet", urlPatterns = {"/ahorros"})
public class AhorrosServlet extends HttpServlet {

    @EJB
    private AhorroFacade ahorroFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        List<Ahorro> listaAhorros = ahorroFacade.findByUser(usuario);
        
        request.setAttribute("ahorros", listaAhorros);
        request.getRequestDispatcher("/WEB-INF/jsp/ahorros.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lógica para añadir un nuevo ahorro/meta
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar los ahorros del usuario";
    }
}
