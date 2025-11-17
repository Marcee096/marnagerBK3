package com.mycompany.marnager.servlet;

import com.google.gson.Gson;
import com.mycompany.marnager.dto.TransaccionDTO;
import com.mycompany.marnager.ejb.AhorroFacade;
import com.mycompany.marnager.ejb.GastoFacade;
import com.mycompany.marnager.ejb.IngresoFacade;
import com.mycompany.marnager.model.Ahorro;
import com.mycompany.marnager.model.Gasto;
import com.mycompany.marnager.model.Ingreso;
import com.mycompany.marnager.model.Usuario;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
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

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @EJB private IngresoFacade ingresoFacade;
    @EJB private GastoFacade gastoFacade;
    @EJB private AhorroFacade ahorroFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        // --- Lógica de Filtro de Mes/Año ---
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
        
        // --- Obtener datos para el mes seleccionado ---
        List<Ingreso> ingresosMes = ingresoFacade.findByUserAndMonth(usuario, selectedYear, selectedMonth);
        List<Gasto> gastosMes = gastoFacade.findByUserAndMonth(usuario, selectedYear, selectedMonth);
        List<Ahorro> ahorrosMes = ahorroFacade.findByUserAndMonth(usuario, selectedYear, selectedMonth);
        
        // --- Calcular totales para el mes seleccionado ---
        BigDecimal totalIngresos = ingresosMes.stream().map(Ingreso::getMonto).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalGastos = gastosMes.stream().map(Gasto::getMonto).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalAhorros = ahorrosMes.stream().map(Ahorro::getMonto).reduce(BigDecimal.ZERO, BigDecimal::add);

        // --- Preparar datos para los 3 gráficos de distribución ---
        Gson gson = new Gson();
        
        // Gráfico de Ingresos
        Map<String, BigDecimal> ingresosMap = ingresosMes.stream().collect(Collectors.groupingBy(Ingreso::getCategoria, Collectors.reducing(BigDecimal.ZERO, Ingreso::getMonto, BigDecimal::add)));
        request.setAttribute("ingresosCategoriasJSON", gson.toJson(new ArrayList<>(ingresosMap.keySet())));
        request.setAttribute("ingresosDistribucionJSON", gson.toJson(new ArrayList<>(ingresosMap.values())));

        // Gráfico de Gastos
        Map<String, BigDecimal> gastosMap = gastosMes.stream().collect(Collectors.groupingBy(Gasto::getCategoria, Collectors.reducing(BigDecimal.ZERO, Gasto::getMonto, BigDecimal::add)));
        request.setAttribute("gastosCategoriasJSON", gson.toJson(new ArrayList<>(gastosMap.keySet())));
        request.setAttribute("gastosDistribucionJSON", gson.toJson(new ArrayList<>(gastosMap.values())));

        // Gráfico de Ahorros
        Map<String, BigDecimal> ahorrosMap = ahorrosMes.stream().collect(Collectors.groupingBy(Ahorro::getCategoria, Collectors.reducing(BigDecimal.ZERO, Ahorro::getMonto, BigDecimal::add)));
        request.setAttribute("ahorrosCategoriasJSON", gson.toJson(new ArrayList<>(ahorrosMap.keySet())));
        request.setAttribute("ahorrosDistribucionJSON", gson.toJson(new ArrayList<>(ahorrosMap.values())));
        
        // --- Preparar datos para el gráfico de promedios ---
        int daysInMonth = now.withYear(selectedYear).withMonth(selectedMonth).lengthOfMonth();
        if (daysInMonth > 0) {
            BigDecimal days = new BigDecimal(daysInMonth);
            MathContext mc = new MathContext(2, RoundingMode.HALF_UP);
            BigDecimal avgIngresos = totalIngresos.divide(days, mc);
            BigDecimal avgGastos = totalGastos.divide(days, mc);
            BigDecimal avgAhorros = totalAhorros.divide(days, mc);

            List<String> promedioLabels = List.of("Prom. Ingresos", "Prom. Gastos", "Prom. Ahorros");
            List<BigDecimal> promedioData = List.of(avgIngresos, avgGastos, avgAhorros);

            request.setAttribute("promedioLabelsJSON", gson.toJson(promedioLabels));
            request.setAttribute("promedioDataJSON", gson.toJson(promedioData));
        }
        
        // --- Lógica para Últimas Transacciones (del mes seleccionado) ---
        List<TransaccionDTO> transaccionesDelMes = new ArrayList<>();
        ingresosMes.forEach(i -> transaccionesDelMes.add(new TransaccionDTO("Ingreso", i.getCategoria(), i.getMonto(), i.getFecha())));
        gastosMes.forEach(g -> transaccionesDelMes.add(new TransaccionDTO("Gasto", g.getCategoria(), g.getMonto(), g.getFecha())));
        ahorrosMes.forEach(a -> transaccionesDelMes.add(new TransaccionDTO("Ahorro", a.getCategoria(), a.getMonto(), a.getFecha())));
        transaccionesDelMes.sort(java.util.Comparator.comparing(TransaccionDTO::getFecha).reversed());
        List<TransaccionDTO> ultimasTransacciones = transaccionesDelMes.stream().limit(10).collect(Collectors.toList());

        // --- Pasar todos los datos a la vista ---
        request.setAttribute("totalIngresos", totalIngresos);
        request.setAttribute("totalGastos", totalGastos);
        request.setAttribute("totalAhorros", totalAhorros);
        request.setAttribute("ultimasTransacciones", ultimasTransacciones);
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("monthOptions", monthOptions);
        
        request.getRequestDispatcher("/WEB-INF/jsp/home.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to display user's home screen with financial data.";
    }
}
