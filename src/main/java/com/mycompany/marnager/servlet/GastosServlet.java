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
            response.sendRedirect(request.getContextPath() + "/gastos?status=error");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws Exception {
        String categoria = request.getParameter("categoria");
        String subcategoria = request.getParameter("subcategoria");
        String montoStr = request.getParameter("monto");
        String fechaStr = request.getParameter("fecha");

        java.math.BigDecimal monto = new java.math.BigDecimal(montoStr);
        java.util.Date fecha = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);

        Gasto nuevoGasto = new Gasto();
        nuevoGasto.setCategoria(categoria);
        nuevoGasto.setSubcategoria(subcategoria);
        nuevoGasto.setMonto(monto);
        nuevoGasto.setFecha(fecha);
        nuevoGasto.setUsuario(usuario);

        gastoFacade.create(nuevoGasto);

        response.sendRedirect(request.getContextPath() + "/gastos?status=created");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Gasto gasto = gastoFacade.find(id);

        if (gasto != null && gasto.getUsuario().equals(usuario)) {
            String categoria = request.getParameter("categoria");
            String subcategoria = request.getParameter("subcategoria");
            String montoStr = request.getParameter("monto");
            String fechaStr = request.getParameter("fecha");

            java.math.BigDecimal monto = new java.math.BigDecimal(montoStr);
            java.util.Date fecha = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);

            gasto.setCategoria(categoria);
            gasto.setSubcategoria(subcategoria);
            gasto.setMonto(monto);
            gasto.setFecha(fecha);

            gastoFacade.edit(gasto);
            response.sendRedirect(request.getContextPath() + "/gastos?status=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/gastos?status=error");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Usuario usuario) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Gasto gasto = gastoFacade.find(id);

            if (gasto != null && gasto.getUsuario().equals(usuario)) {
                gastoFacade.remove(gasto);
                response.sendRedirect(request.getContextPath() + "/gastos?status=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/gastos?status=error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/gastos?status=error");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar los gastos del usuario";
    }
}
