package com.mycompany.marnager.servlet;

import com.google.gson.Gson;
import com.mycompany.marnager.ejb.IngresoFacade;
import com.mycompany.marnager.model.Ingreso;
import com.mycompany.marnager.model.Usuario;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // --- Lógica de Visualización (GET) ---
        
        LocalDate now = LocalDate.now();
        int selectedYear;
        int selectedMonth;

        try {
            selectedYear = Integer.parseInt(request.getParameter("year"));
            selectedMonth = Integer.parseInt(request.getParameter("month"));
        } catch (NumberFormatException | NullPointerException e) {
            selectedYear = now.getYear();
            selectedMonth = now.getMonthValue();
        }

        List<Map<String, String>> monthOptions = new ArrayList<>();
        Locale spanishLocale = new Locale("es", "ES");
        for (int i = 0; i < 12; i++) {
            LocalDate date = now.minusMonths(i);
            String monthName = date.getMonth().getDisplayName(TextStyle.FULL, spanishLocale);
            monthName = monthName.substring(0, 1).toUpperCase() + monthName.substring(1);
            monthOptions.add(Map.of(
                "year", String.valueOf(date.getYear()),
                "month", String.valueOf(date.getMonthValue()),
                "name", monthName + " " + date.getYear()
            ));
        }

        List<Ingreso> listaIngresos = ingresoFacade.findByUserAndMonth(usuario, selectedYear, selectedMonth);

        Map<String, BigDecimal> distribucionMap = listaIngresos.stream()
                .collect(Collectors.groupingBy(Ingreso::getCategoria,
                        Collectors.reducing(BigDecimal.ZERO, Ingreso::getMonto, BigDecimal::add)));

        Gson gson = new Gson();
        List<String> labelsDistribucion = new ArrayList<>(distribucionMap.keySet());
        List<BigDecimal> dataDistribucion = new ArrayList<>(distribucionMap.values());

        request.setAttribute("ingresos", listaIngresos);
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("monthOptions", monthOptions);
        request.setAttribute("categoriasJSON", gson.toJson(labelsDistribucion));
        request.setAttribute("distribucionJSON", gson.toJson(dataDistribucion));
        
        String status = request.getParameter("status");
        if (status != null) {
            request.setAttribute("status", status);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/ingresos.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
            action = "create";
        }

        String status = "error";
        try {
            switch (action) {
                case "update":
                    if (handleUpdate(request, usuario)) status = "updated";
                    break;
                case "delete":
                    if (handleDelete(request, usuario)) status = "deleted";
                    break;
                case "create":
                default:
                    if (handleCreate(request, usuario)) status = "created";
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        String year = request.getParameter("year");
        String month = request.getParameter("month");
        String redirectUrl = request.getContextPath() + "/ingresos?status=" + status;
        if (year != null && month != null && !year.isEmpty() && !month.isEmpty()) {
            redirectUrl += "&year=" + year + "&month=" + month;
        }
        response.sendRedirect(redirectUrl);
    }

    private boolean handleCreate(HttpServletRequest request, Usuario usuario) throws Exception {
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
        return true;
    }

    private boolean handleUpdate(HttpServletRequest request, Usuario usuario) throws Exception {
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
            return true;
        }
        return false;
    }

    private boolean handleDelete(HttpServletRequest request, Usuario usuario) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Ingreso ingreso = ingresoFacade.find(id);

            if (ingreso != null && ingreso.getUsuario().equals(usuario)) {
                ingresoFacade.remove(ingreso);
                return true;
            }
        } catch (NumberFormatException e) {
            return false;
        }
        return false;
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar los ingresos del usuario";
    }
}
