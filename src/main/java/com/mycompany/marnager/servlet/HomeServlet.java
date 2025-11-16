package com.mycompany.marnager.servlet;

import com.google.gson.Gson;
import com.mycompany.marnager.ejb.AhorroFacade;
import com.mycompany.marnager.ejb.GastoFacade;
import com.mycompany.marnager.ejb.IngresoFacade;
import com.mycompany.marnager.model.Ahorro;
import com.mycompany.marnager.model.Gasto;
import com.mycompany.marnager.model.Ingreso;
import com.mycompany.marnager.model.Usuario;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Map;

/**
 *
 * @author marce
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @EJB
    private IngresoFacade ingresoFacade;
    @EJB
    private GastoFacade gastoFacade;
    @EJB
    private AhorroFacade ahorroFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        // Obtener listas de la base de datos
        List<Ingreso> ingresos = ingresoFacade.findByUser(usuario);
        List<Gasto> gastos = gastoFacade.findByUser(usuario);
        List<Ahorro> ahorros = ahorroFacade.findByUser(usuario);
        
        // --- Lógica para Últimas Transacciones ---
        List<com.mycompany.marnager.dto.TransaccionDTO> todasLasTransacciones = new ArrayList<>();
        ingresos.forEach(i -> todasLasTransacciones.add(new com.mycompany.marnager.dto.TransaccionDTO("Ingreso", i.getCategoria(), i.getMonto(), i.getFecha())));
        gastos.forEach(g -> todasLasTransacciones.add(new com.mycompany.marnager.dto.TransaccionDTO("Gasto", g.getCategoria(), g.getMonto(), g.getFecha())));
        ahorros.forEach(a -> todasLasTransacciones.add(new com.mycompany.marnager.dto.TransaccionDTO("Ahorro", a.getCategoria(), a.getMonto(), a.getFecha())));

        // Ordenar por fecha descendente
        todasLasTransacciones.sort(java.util.Comparator.comparing(com.mycompany.marnager.dto.TransaccionDTO::getFecha).reversed());

        // Tomar las últimas 10
        List<com.mycompany.marnager.dto.TransaccionDTO> ultimasTransacciones = todasLasTransacciones.stream().limit(10).collect(Collectors.toList());
        
        // Calcular totales
        BigDecimal totalIngresos = ingresos.stream().map(Ingreso::getMonto).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalGastos = gastos.stream().map(Gasto::getMonto).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalAhorros = ahorros.stream().map(Ahorro::getMonto).reduce(BigDecimal.ZERO, BigDecimal::add);

        // Preparar datos para gráficos
        Gson gson = new Gson();
        
        // Gráfico de evolución de gastos (últimos 7 gastos)
        List<String> labelsEvolucion = new ArrayList<>();
        List<BigDecimal> dataEvolucion = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM");
        gastos.stream().sorted(java.util.Comparator.comparing(Gasto::getFecha).reversed()).limit(7).forEach(g -> {
            labelsEvolucion.add(sdf.format(g.getFecha()));
            dataEvolucion.add(g.getMonto());
        });

        // Gráfico de distribución de gastos por categoría
        Map<String, BigDecimal> distribucionMap = gastos.stream()
                .collect(Collectors.groupingBy(Gasto::getCategoria, 
                                               Collectors.reducing(BigDecimal.ZERO, Gasto::getMonto, BigDecimal::add)));
        
        List<String> labelsDistribucion = new ArrayList<>(distribucionMap.keySet());
        List<BigDecimal> dataDistribucion = new ArrayList<>(distribucionMap.values());

        // Pasar datos a la vista
        request.setAttribute("totalIngresos", totalIngresos);
        request.setAttribute("totalGastos", totalGastos);
        request.setAttribute("totalAhorros", totalAhorros);
        request.setAttribute("ultimasTransacciones", ultimasTransacciones); // <-- Nueva lista
        
        // Pasar datos para gráficos como JSON
        request.setAttribute("labelsJSON", gson.toJson(labelsEvolucion));
        request.setAttribute("gastosDataJSON", gson.toJson(dataEvolucion));
        request.setAttribute("categoriasJSON", gson.toJson(labelsDistribucion));
        request.setAttribute("distribucionJSON", gson.toJson(dataDistribucion));
        
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
