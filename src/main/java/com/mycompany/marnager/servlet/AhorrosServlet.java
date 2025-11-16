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
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String action = request.getParameter("action");
        if (action == null) {
            action = "create"; // Acción por defecto
        }

        try {
            switch (action) {
                case "update":
                    handleUpdate(request, response, usuario);
                    break;
                case "delete":
                    handleDelete(request, response, usuario);
                    break;
                case "create":
                default:
                    handleCreate(request, response, usuario);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ahorros?status=error");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws Exception {
        String categoria = request.getParameter("categoria");
        String subcategoria = request.getParameter("subcategoria");
        String montoStr = request.getParameter("monto");
        String fechaStr = request.getParameter("fecha");

        java.math.BigDecimal monto = new java.math.BigDecimal(montoStr);
        java.util.Date fecha = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);

        Ahorro nuevoAhorro = new Ahorro();
        nuevoAhorro.setCategoria(categoria);
        nuevoAhorro.setSubcategoria(subcategoria);
        nuevoAhorro.setMonto(monto);
        nuevoAhorro.setFecha(fecha);
        nuevoAhorro.setUsuario(usuario);

        ahorroFacade.create(nuevoAhorro);

        response.sendRedirect(request.getContextPath() + "/ahorros?status=created");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Ahorro ahorro = ahorroFacade.find(id);

        if (ahorro != null && ahorro.getUsuario().equals(usuario)) {
            String categoria = request.getParameter("categoria");
            String subcategoria = request.getParameter("subcategoria");
            String montoStr = request.getParameter("monto");
            String fechaStr = request.getParameter("fecha");

            java.math.BigDecimal monto = new java.math.BigDecimal(montoStr);
            java.util.Date fecha = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);

            ahorro.setCategoria(categoria);
            ahorro.setSubcategoria(subcategoria);
            ahorro.setMonto(monto);
            ahorro.setFecha(fecha);

            ahorroFacade.edit(ahorro);
            response.sendRedirect(request.getContextPath() + "/ahorros?status=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/ahorros?status=error");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Ahorro ahorro = ahorroFacade.find(id);

            if (ahorro != null && ahorro.getUsuario().equals(usuario)) {
                ahorroFacade.remove(ahorro);
                response.sendRedirect(request.getContextPath() + "/ahorros?status=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/ahorros?status=error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ahorros?status=error");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar los ahorros del usuario";
    }
}
