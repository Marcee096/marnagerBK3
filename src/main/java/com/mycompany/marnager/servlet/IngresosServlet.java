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

            // 4. Crear la nueva entidad Ingreso
            Ingreso nuevoIngreso = new Ingreso();
            nuevoIngreso.setCategoria(categoria);
            nuevoIngreso.setSubcategoria(subcategoria);
            nuevoIngreso.setMonto(monto);
            nuevoIngreso.setFecha(fecha);
            nuevoIngreso.setUsuario(usuario);

            // 5. Persistir la entidad
            ingresoFacade.create(nuevoIngreso);

            // 6. Redirigir con mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/ingresos?status=success");

        } catch (Exception e) {
            // Manejo básico de errores (en un caso real, sería más robusto)
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ingresos?status=error");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar los ingresos del usuario";
    }
}
