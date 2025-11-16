package com.mycompany.marnager.servlet;

import com.mycompany.marnager.ejb.IngresoFacade;
import com.mycompany.marnager.model.Ingreso;
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

@WebServlet(name = "IngresosServlet", urlPatterns = {"/ingresos"})
public class IngresosServlet extends HttpServlet {

    @EJB
    private IngresoFacade ingresoFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        List<Ingreso> listaIngresos = ingresoFacade.findByUser(usuario);
        
        request.setAttribute("ingresos", listaIngresos);
        request.getRequestDispatcher("/WEB-INF/jsp/ingresos.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/ingresos?status=error");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws Exception {
        String categoria = request.getParameter("categoria");
        String subcategoria = request.getParameter("subcategoria");
        String montoStr = request.getParameter("monto");
        String fechaStr = request.getParameter("fecha");

        java.math.BigDecimal monto = new java.math.BigDecimal(montoStr);
        java.util.Date fecha = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);

        Ingreso nuevoIngreso = new Ingreso();
        nuevoIngreso.setCategoria(categoria);
        nuevoIngreso.setSubcategoria(subcategoria);
        nuevoIngreso.setMonto(monto);
        nuevoIngreso.setFecha(fecha);
        nuevoIngreso.setUsuario(usuario);

        ingresoFacade.create(nuevoIngreso);

        response.sendRedirect(request.getContextPath() + "/ingresos?status=created");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Ingreso ingreso = ingresoFacade.find(id);

        if (ingreso != null && ingreso.getUsuario().equals(usuario)) {
            String categoria = request.getParameter("categoria");
            String subcategoria = request.getParameter("subcategoria");
            String montoStr = request.getParameter("monto");
            String fechaStr = request.getParameter("fecha");

            java.math.BigDecimal monto = new java.math.BigDecimal(montoStr);
            java.util.Date fecha = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);

            ingreso.setCategoria(categoria);
            ingreso.setSubcategoria(subcategoria);
            ingreso.setMonto(monto);
            ingreso.setFecha(fecha);

            ingresoFacade.edit(ingreso);
            response.sendRedirect(request.getContextPath() + "/ingresos?status=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/ingresos?status=error");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Ingreso ingreso = ingresoFacade.find(id);

            if (ingreso != null && ingreso.getUsuario().equals(usuario)) {
                ingresoFacade.remove(ingreso);
                response.sendRedirect(request.getContextPath() + "/ingresos?status=deleted");
            } else {
                // El ingreso no existe o no pertenece al usuario
                response.sendRedirect(request.getContextPath() + "/ingresos?status=error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ingresos?status=error");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar los ingresos del usuario";
    }
}
