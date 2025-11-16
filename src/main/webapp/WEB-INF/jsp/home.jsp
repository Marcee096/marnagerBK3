<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Financiero - Marnager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: white;
            min-height: 100vh;
        }
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 260px;
            height: 100vh;
            background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            padding-top: 20px;
            z-index: 100;
        }
        .sidebar h3 {
            color: #fff;
            margin: 0 0 40px 0;
            padding: 0 20px;
            font-weight: 600;
            font-size: 24px;
            letter-spacing: 1px;
        }
        .sidebar a {
            text-decoration: none;
            color: #ecf0f1;
            padding: 14px 20px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }
        .sidebar a i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }
        .sidebar a:hover {
            background-color: rgba(255,255,255,0.1);
            border-left-color: #3498db;
            padding-left: 25px;
        }
        .sidebar a.active {
            background-color: rgba(52, 152, 219, 0.2);
            border-left-color: #3498db;
            font-weight: 600;
        }
        .main-content {
            margin-left: 260px;
            margin-top: 60px;
            padding: 30px;
        }
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            background: white;
            margin-bottom: 25px;
        }
        
        .welcome-banner {
            color: black;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
        }
        
        .welcome-banner h1 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .welcome-banner p {
            font-size: 1rem;
            opacity: 0.95;
            margin: 0;
        }
        
        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }
        
        .stats-card .icon-wrapper {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 15px;
        }
        
        .stats-card.income .icon-wrapper {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .stats-card.expense .icon-wrapper {
            background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
            color: white;
        }
        
        .stats-card.savings .icon-wrapper {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .stats-card .title {
            font-size: 0.9rem;
            color: #7f8c8d;
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }
        
        .stats-card .value {
            font-size: 2rem;
            font-weight: 700;
            display: block;
        }
        
        .stats-card.income .value { color: #11998e; }
        .stats-card.expense .value { color: #ee0979; }
        .stats-card.savings .value { color: #667eea; }
        
        .quick-action-card {
            text-align: center;
            padding: 30px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            height: 100%;
            border: 2px solid transparent;
        }
        
        .quick-action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
            border-color: #3498db;
        }
        
        .quick-action-card .icon-wrapper {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #f5f7fa 0%, #e9ecef 100%);
        }
        
        .quick-action-card img {
            width: 50px;
            height: 50px;
            object-fit: contain;
        }
        
        .quick-action-card h5 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .quick-action-card p {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin: 0;
        }
        
        .section-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 20px;
            font-size: 1.5rem;
        }
        
        .tips-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            padding: 30px;
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .tips-section h5 {
            font-weight: 600;
            margin-bottom: 20px;
            font-size: 1.3rem;
        }
        
        .tips-section ul {
            margin: 0;
            padding-left: 20px;
            line-height: 1.8;
        }
        
        .tips-section li {
            margin-bottom: 10px;
        }
        
        .chart-card {
            padding: 25px;
        }
        
        .chart-card h5 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 20px;
            font-size: 1.2rem;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
        }
        
        .table {
            margin: 0;
        }
        
        .table thead th {
            background-color: #f8f9fa;
            color: #2c3e50;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
            padding: 15px;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            color: #495057;
        }
        
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(52, 152, 219, 0.02);
        }
        
        .table-hover tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.05);
        }
        
        .text-income { color: #11998e !important; font-weight: 600; }
        .text-expense { color: #ee0979 !important; font-weight: 600; }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
        
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.3;
        }
    </style>
</head>
<body>

<!-- Topbar -->
<jsp:include page="includes/topbar.jsp" />

<!-- Sidebar -->
<div class="sidebar">
    <h3><i class="fas fa-wallet"></i> Marnager</h3>
    <a href="${pageContext.request.contextPath}/home" class="active">
        <i class="fas fa-home"></i> Inicio
    </a>
    <a href="${pageContext.request.contextPath}/ingresos">
        <i class="fas fa-arrow-up"></i> Ingresos
    </a>
    <a href="${pageContext.request.contextPath}/gastos">
        <i class="fas fa-arrow-down"></i> Gastos
    </a>
    <a href="${pageContext.request.contextPath}/ahorros">
        <i class="fas fa-piggy-bank"></i> Ahorros
    </a>
    <a href="#">
        <i class="fas fa-chart-bar"></i> Reportes
    </a>
    <a href="#">
        <i class="fas fa-cog"></i> Configuración
    </a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="container-fluid">
        <!-- Banner de Bienvenida -->
        <div class="welcome-banner">
            <h1><i class="fas fa-hand-wave"></i> ¡Bienvenido, <c:out value="${sessionScope.usuario.email}" />!</h1>
            <p>Tu asistente personal para gestionar tus finanzas de manera inteligente</p>
        </div>

        <c:choose>
            <c:when test="${empty transacciones and (empty totalIngresos or totalIngresos == 0) and (empty totalGastos or totalGastos == 0)}">
                <!-- Vista para usuarios nuevos sin datos -->
                
                <!-- Tarjetas resumen vacías pero informativas -->
                <div class="row mb-4 g-4">
                    <div class="col-md-4">
                        <div class="stats-card income">
                            <div class="icon-wrapper">
                                <i class="fas fa-arrow-trend-up"></i>
                            </div>
                            <span class="title">Ingresos Totales</span>
                            <span class="value">$0.00</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stats-card expense">
                            <div class="icon-wrapper">
                                <i class="fas fa-arrow-trend-down"></i>
                            </div>
                            <span class="title">Gastos Totales</span>
                            <span class="value">$0.00</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stats-card savings">
                            <div class="icon-wrapper">
                                <i class="fas fa-piggy-bank"></i>
                            </div>
                            <span class="title">Ahorros</span>
                            <span class="value">$0.00</span>
                        </div>
                    </div>
                </div>

                <!-- Acciones rápidas -->
                <h4 class="section-title"><i class="fas fa-bolt"></i> Comienza a gestionar tus finanzas</h4>
                <div class="row mb-4 g-4">
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/ingresos" style="text-decoration: none;">
                            <div class="card quick-action-card">
                                <div class="icon-wrapper">
                                    <img src="${pageContext.request.contextPath}/assets/billete22.png" alt="Ingreso" />
                                </div>
                                <h5>Registrar Ingreso</h5>
                                <p>Agrega tus ingresos mensuales o extraordinarios</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/gastos" style="text-decoration: none;">
                            <div class="card quick-action-card">
                                <div class="icon-wrapper">
                                    <img src="${pageContext.request.contextPath}/assets/carrito22.png" alt="Gasto" />
                                </div>
                                <h5>Registrar Gasto</h5>
                                <p>Lleva el control de todos tus gastos</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/ahorros" style="text-decoration: none;">
                            <div class="card quick-action-card">
                                <div class="icon-wrapper">
                                    <img src="${pageContext.request.contextPath}/assets/meta22.png" alt="Ahorro" />
                                </div>
                                <h5>Definir Meta</h5>
                                <p>Establece objetivos de ahorro</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="#" style="text-decoration: none;">
                            <div class="card quick-action-card">
                                <div class="icon-wrapper">
                                    <img src="${pageContext.request.contextPath}/assets/grafico22.png" alt="Reportes" />
                                </div>
                                <h5>Ver Reportes</h5>
                                <p>Analiza tus finanzas en detalle</p>
                            </div>
                        </a>
                    </div>
                </div>

                <!-- Consejos financieros -->
                <div class="tips-section">
                    <h5><i class="fas fa-lightbulb"></i> Consejos para empezar</h5>
                    <ul>
                        <li>Registra todos tus ingresos y gastos para tener un panorama completo de tu situación financiera</li>
                        <li>Categoriza tus gastos para identificar en qué áreas gastas más dinero</li>
                        <li>Establece un presupuesto mensual realista y trata de cumplirlo consistentemente</li>
                        <li>Revisa tus reportes semanalmente para ajustar tus hábitos financieros</li>
                        <li>Comienza con metas de ahorro pequeñas y realistas que puedas cumplir</li>
                    </ul>
                </div>

            </c:when>
            <c:otherwise>
                <!-- Vista con datos existentes -->
                
                <!-- Tarjetas resumen -->
                <div class="row mb-4 g-4">
                    <div class="col-md-4">
                        <div class="stats-card income">
                            <div class="icon-wrapper">
                                <i class="fas fa-arrow-trend-up"></i>
                            </div>
                            <span class="title">Ingresos Totales</span>
                            <span class="value">
                                <fmt:formatNumber value="${totalIngresos}" type="currency" currencySymbol="$" />
                                <c:if test="${empty totalIngresos}">$0.00</c:if>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stats-card expense">
                            <div class="icon-wrapper">
                                <i class="fas fa-arrow-trend-down"></i>
                            </div>
                            <span class="title">Gastos Totales</span>
                            <span class="value">
                                <fmt:formatNumber value="${totalGastos}" type="currency" currencySymbol="$" />
                                <c:if test="${empty totalGastos}">$0.00</c:if>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stats-card savings">
                            <div class="icon-wrapper">
                                <i class="fas fa-piggy-bank"></i>
                            </div>
                            <span class="title">Ahorros</span>
                            <span class="value">
                                <fmt:formatNumber value="${totalAhorros}" type="currency" currencySymbol="$" />
                                <c:if test="${empty totalAhorros}">$0.00</c:if>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Gráficos -->
                <div class="row g-4 mb-4">
                    <div class="col-lg-6">
                        <div class="card chart-card">
                            <h5><i class="fas fa-chart-line"></i> Evolución de los Gastos</h5>
                            <div class="chart-container">
                                <canvas id="gastosChart"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="card chart-card">
                            <h5><i class="fas fa-chart-pie"></i> Distribución de Gastos</h5>
                            <div class="chart-container">
                                <canvas id="pieChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Últimas transacciones -->
                <div class="card">
                    <div class="chart-card">
                        <h5><i class="fas fa-clock-rotate-left"></i> Últimas Transacciones</h5>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-calendar"></i> Fecha</th>
                                        <th><i class="fas fa-file-lines"></i> Descripción</th>
                                        <th><i class="fas fa-dollar-sign"></i> Monto</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="t" items="${transacciones}">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${t.fecha}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td><c:out value="${t.descripcion}" /></td>
                                            <td class="<c:out value='${t.monto > 0 ? "text-income" : "text-expense"}' />">
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
                    const labels = ${labelsJSON};
                    const gastosData = ${gastosDataJSON};
                    const categorias = ${categoriasJSON};
                    const distribucion = ${distribucionJSON};

                    // Configuración común para los gráficos
                    Chart.defaults.font.family = "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif";
                    Chart.defaults.color = '#7f8c8d';

                    // Gráfico de líneas (mejorado)
                    new Chart(document.getElementById('gastosChart'), {
                        type: 'line',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Gastos ($)',
                                data: gastosData,
                                backgroundColor: 'rgba(238, 9, 121, 0.1)',
                                borderColor: '#ee0979',
                                borderWidth: 3,
                                fill: true,
                                tension: 0.4,
                                pointBackgroundColor: '#ee0979',
                                pointBorderColor: '#fff',
                                pointBorderWidth: 2,
                                pointRadius: 5,
                                pointHoverRadius: 7
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(0, 0, 0, 0.05)'
                                    }
                                },
                                x: {
                                    grid: {
                                        display: false
                                    }
                                }
                            }
                        }
                    });

                    // Gráfico circular (mejorado)
                    new Chart(document.getElementById('pieChart'), {
                        type: 'doughnut',
                        data: {
                            labels: categorias,
                            datasets: [{
                                data: distribucion,
                                backgroundColor: [
                                    '#ee0979',
                                    '#667eea',
                                    '#11998e',
                                    '#f9c74f',
                                    '#3498db',
                                    '#e74c3c'
                                ],
                                borderWidth: 0
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            cutout: '65%',
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        padding: 15,
                                        usePointStyle: true,
                                        pointStyle: 'circle'
                                    }
                                }
                            }
                        }
                    });
                </script>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
