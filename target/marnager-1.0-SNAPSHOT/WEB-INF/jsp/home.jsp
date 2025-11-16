<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Financiero - Marnager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9fafb;
        }
        .sidebar {
            position: fixed;
            top: 0; left: 0;
            width: 220px;
            height: 100vh;
            background-color: #fff;
            border-right: 1px solid #ddd;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 20px;
            z-index: 100;
        }
        .sidebar h3 {
            color: #333;
            margin-bottom: 30px;
        }
        .sidebar a {
            text-decoration: none;
            color: #555;
            padding: 10px 0;
            width: 100%;
            text-align: center;
            display: block;
            transition: background 0.3s;
        }
        .sidebar a:hover {
            background-color: #eaeaea;
        }
        .main-content {
            margin-left: 220px;
            margin-top: 60px; /* Espacio para el topbar */
            padding: 20px;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .title {
            font-weight: 600;
            color: #444;
        }
        .value {
            font-size: 1.8rem;
            font-weight: bold;
        }
        .text-green { color: #20c997; }
        .text-red { color: #dc3545; }
        .text-blue { color: #007bff; }
        
        .welcome-banner {
            color: black;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
        }
        
        .welcome-banner h1 {
            font-size: 2.1rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .welcome-banner p {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 40px;
            color: #888;
        }
        
        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        .empty-state h4 {
            color: #555;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #999;
            margin-bottom: 20px;
        }
        
        .quick-action-card {
            text-align: center;
            padding: 30px 20px;
            cursor: pointer;
            transition: all 0.3s;
            height: 100%;
        }
        .quick-action-card img{
            width: 80px;
        }
        .quick-action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .quick-action-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        .quick-action-card h5 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .quick-action-card p {
            color: #777;
            font-size: 0.9rem;
        }
        
        .icon-income { color: #20c997; }
        .icon-expense { color: #dc3545; }
        .icon-savings { color: #007bff; }
        .icon-report { color: #ffc107; }
        
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .stats-icon {
            font-size: 2.5rem;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            background: #f0f0f0;
        }
        
        .tips-section {
            background: #53BDB3;
            border-left: 4px solid #244A93;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .tips-section h5 {
            color: #ffffff;
            margin-bottom: 10px;
        }
        
        .tips-section ul {
            margin: 0;
            padding-left: 20px;
            color: #ffffff;
        }
        
        .chart-container {
            position: relative;
            height: 320px;
        }
    </style>
</head>
<body>

<!-- Topbar -->
<jsp:include page="includes/topbar.jsp" />

<!-- Sidebar -->
<div class="sidebar">
    <h3>Marnager</h3>
    <a href="${pageContext.request.contextPath}/home">Inicio</a>
    <a href="${pageContext.request.contextPath}/ingresos">Ingresos</a>
    <a href="${pageContext.request.contextPath}/gastos">Gastos</a>
    <a href="${pageContext.request.contextPath}/ahorros">Ahorros</a>
    <a href="#">Reportes</a>
    <a href="#">Configuración</a>
</div>

<!-- Main -->
<div class="main-content">
    <div class="container-fluid">
        <!-- Banner de Bienvenida -->
        <div class="welcome-banner">
            <h1>¡Bienvenido, <c:out value="${sessionScope.usuario.email}" />! </h1>
            <p>Tu asistente personal para gestionar tus finanzas de manera inteligente</p>
        </div>

        <c:choose>
            <c:when test="${empty transacciones and (empty totalIngresos or totalIngresos == 0) and (empty totalGastos or totalGastos == 0)}">
                <!-- Vista para usuarios nuevos sin datos -->
                
                <!-- Tarjetas resumen vacías pero informativas -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="stats-card">
                            <div>
                                <span class="title d-block">Ingresos</span>
                                <span class="value text-green">$0.00</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stats-card">
                            <div>
                                <span class="title d-block">Gastos</span>
                                <span class="value text-red">$0.00</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stats-card">
                            <div>
                                <span class="title d-block">Ahorros</span>
                                <span class="value text-blue">$0.00</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Acciones rápidas -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h4 class="mb-3">Comienza a gestionar tus finanzas</h4>
                    </div>
                    <div class="col-md-3">
                        <div class="card quick-action-card">
                            <div class="quick-action-icon icon-income">
                                <img src="${pageContext.request.contextPath}/assets/billete22.png" alt="Ingreso" />
                            </div>
                            <h5>Registrar Ingreso</h5>
                            <p>Agrega tus ingresos mensuales o extraordinarios</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card quick-action-card">
                            <div class="quick-action-icon icon-expense">
                               <img src="${pageContext.request.contextPath}/assets/carrito22.png" alt="alt"/> 
                            </div>
                            <h5>Registrar Gasto</h5>
                            <p>Lleva el control de todos tus gastos</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card quick-action-card">
                            <div class="quick-action-icon icon-savings">
                                <img src="${pageContext.request.contextPath}/assets/meta22.png" alt="alt"/> 
                            </div>
                            <h5>Definir Meta</h5>
                            <p>Establece objetivos de ahorro</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card quick-action-card">
                            <div class="quick-action-icon icon-report">
                                <img src="${pageContext.request.contextPath}/assets/grafico22.png" alt="alt"/> 
                            </div>
                            <h5>Ver Reportes</h5>
                            <p>Analiza tus finanzas en detalle</p>
                        </div>
                    </div>
                </div>

                <!-- Consejos financieros -->
                <div class="tips-section">
                    <h5>💡 Consejos para empezar:</h5>
                    <ul>
                        <li>Registra todos tus ingresos y gastos para tener un panorama completo</li>
                        <li>Categoriza tus gastos para identificar en qué gastas más</li>
                        <li>Establece un presupuesto mensual y trata de cumplirlo</li>
                        <li>Revisa tus reportes semanalmente para ajustar tus hábitos</li>
                        <li>Comienza con metas de ahorro pequeñas y realistas</li>
                    </ul>
                </div>

            </c:when>
            <c:otherwise>
                <!-- Vista con datos existentes -->
                
                <!-- Tarjetas resumen -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card p-3">
                            <span class="title">Ingresos</span>
                            <span class="value text-green">
                                <fmt:formatNumber value="${totalIngresos}" type="currency" currencySymbol="$" />
                                <c:if test="${empty totalIngresos}">$0.00</c:if>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3">
                            <span class="title">Gastos</span>
                            <span class="value text-red">
                                <fmt:formatNumber value="${totalGastos}" type="currency" currencySymbol="$" />
                                <c:if test="${empty totalGastos}">$0.00</c:if>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3">
                            <span class="title">Ahorros</span>
                            <span class="value text-blue">
                                <fmt:formatNumber value="${totalAhorros}" type="currency" currencySymbol="$" />
                                <c:if test="${empty totalAhorros}">$0.00</c:if>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Gráficos -->
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="card p-3">
                            <h5>Evolución de los Gastos</h5>
                            <canvas id="gastosChart"></canvas>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card p-3">
                            <h5>Distribución de Gastos</h5>
                            <div class="chart-container">
                                <canvas id="pieChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Últimas transacciones -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card p-3">
                            <h5>Últimas Transacciones</h5>
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Descripción</th>
                                    <th>Monto</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="t" items="${transacciones}">
                                    <tr>
                                        <td><fmt:formatDate value="${t.fecha}" pattern="dd/MM/yyyy" /></td>
                                        <td><c:out value="${t.descripcion}" /></td>
                                        <td class="<c:out value='${t.monto > 0 ? "text-green" : "text-red"}' />">
                                            <fmt:formatNumber value="${t.monto}" type="currency" currencySymbol="$" />
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <script>
                    // Datos dinámicos desde el servlet
                    const labels = ${labelsJSON}; // Debes pasar esto desde el servlet
                    const gastosData = ${gastosDataJSON};
                    const categorias = ${categoriasJSON};
                    const distribucion = ${distribucionJSON};

                    // Gráfico de barras
                    new Chart(document.getElementById('gastosChart'), {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Gastos ($)',
                                data: gastosData,
                                backgroundColor: '#ff4d6d',
                                borderRadius: 6
                            }]
                        },
                        options: { scales: { y: { beginAtZero: true } } }
                    });

                    // Gráfico circular
                    new Chart(document.getElementById('pieChart'), {
                        type: 'doughnut',
                        data: {
                            labels: categorias,
                            datasets: [{
                                data: distribucion,
                                backgroundColor: ['#ff4d6d', '#6c63ff', '#20c997', '#f9c74f']
                            }]
                        },
                        options: { cutout: '70%' }
                    });
                </script>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
