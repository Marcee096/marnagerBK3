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

        try {
            // 1. Obtener parámetros del request
            String categoria = request.getParameter("categoria");
            String subcategoria = request.getParameter("subcategoria");
            String montoStr = request.getParameter("monto");
            String fechaStr = request.getParameter("fecha");
            
            // 2. Obtener el usuario de la sesión
            Usuario usuario = (Usuario) session.getAttribute("usuario");

            // 3. Conversión y validación de datos
            java.math.BigDecimal monto = new java.math.BigDecimal(montoStr);
            java.util.Date fecha = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);

            // 4. Crear la nueva entidad Gasto
            Gasto nuevoGasto = new Gasto();
            nuevoGasto.setCategoria(categoria);
            nuevoGasto.setSubcategoria(subcategoria);
            nuevoGasto.setMonto(monto);
            nuevoGasto.setFecha(fecha);
            nuevoGasto.setUsuario(usuario);

            // 5. Persistir la entidad
            gastoFacade.create(nuevoGasto);

            // 6. Redirigir con mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/gastos?status=success");

        } catch (Exception e) {
            // Manejo básico de errores
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/gastos?status=error");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar los gastos del usuario";
    }
}
