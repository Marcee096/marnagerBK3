<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Marnager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 260px;
            height: 100vh;
            background-color: #3D38F5;
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
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            height: 100%;
        }
        .stats-card .title {
            font-size: 0.9rem;
            color: #7f8c8d;
            font-weight: 500;
            margin-bottom: 8px;
        }
        .stats-card .value {
            font-size: 1.8rem;
            font-weight: 700;
        }
        .stats-card.income .value { color: #2ecc71; }
        .stats-card.expense .value { color: #e74c3c; }
        .stats-card.savings .value { color: #3498db; }
        .chart-card {
            padding: 25px;
        }
        .chart-container {
            position: relative;
            height: 320px;
        }
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
        .sidebar img { width: 150px; }
        .nav-tabs .nav-link {
            font-weight: 600;
            color: #495057;
        }
        .nav-tabs .nav-link.active {
            color: #3D38F5;
            border-color: #dee2e6 #dee2e6 #fff;
        }
    </style>
</head>
<body>

<jsp:include page="includes/topbar.jsp" />
<div class="sidebar">
    <h3><img src="${pageContext.request.contextPath}/assets/marnagerBlanco.png" alt="logoMarnager" /></h3>
    <a href="${pageContext.request.contextPath}/home" class="active"><i class="fas fa-home"></i> Inicio</a>
    <a href="${pageContext.request.contextPath}/ingresos"><i class="fas fa-arrow-up"></i> Ingresos</a>
    <a href="${pageContext.request.contextPath}/gastos"><i class="fas fa-arrow-down"></i> Gastos</a>
    <a href="${pageContext.request.contextPath}/ahorros"><i class="fas fa-piggy-bank"></i> Ahorros</a>
    <a href="#"><i class="fas fa-chart-bar"></i> Reportes</a>
    <a href="#"><i class="fas fa-cog"></i> Configuración</a>
</div>

<div class="main-content">
    <div class="container-fluid">
        <div class="page-header">
            <div>
                <h1>Bienvenido</h1>
                <p class="text-muted">Resumen financiero de tus actividades.</p>
            </div>
            <div>
                <form id="monthFilterForm" action="${pageContext.request.contextPath}/home" method="get" class="d-flex align-items-center">
                    <label for="monthSelect" class="form-label me-2 mb-0">Ver Mes:</label>
                    <select id="monthSelect" class="form-select w-auto">
                        <c:forEach var="option" items="${monthOptions}">
                            <option value="${option.month}-${option.year}" 
                                    <c:if test="${option.month == selectedMonth && option.year == selectedYear}">selected</c:if>>
                                ${option.name}
                            </option>
                        </c:forEach>
                    </select>
                    <input type="hidden" id="selectedYear" name="year">
                    <input type="hidden" id="selectedMonth" name="month">
                </form>
            </div>
        </div>

        <!-- Tarjetas de Resumen Mensual -->
        <div class="row mb-4 g-4">
            <div class="col-md-4">
                <div class="stats-card income">
                    <div class="title">Ingresos del Mes</div>
                    <div class="value"><fmt:formatNumber value="${totalIngresos}" type="currency" currencySymbol="$" /></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card expense">
                    <div class="title">Gastos del Mes</div>
                    <div class="value"><fmt:formatNumber value="${totalGastos}" type="currency" currencySymbol="$" /></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card savings">
                    <div class="title">Ahorros del Mes</div>
                    <div class="value"><fmt:formatNumber value="${totalAhorros}" type="currency" currencySymbol="$" /></div>
                </div>
            </div>
        </div>

        <!-- Gráficos -->
        <div class="card chart-card">
            <h5 class="card-title">Análisis del Mes</h5>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="ingresos-tab" data-bs-toggle="tab" data-bs-target="#ingresos" type="button" role="tab" aria-controls="ingresos" aria-selected="true">
                        <i class="fas fa-arrow-up text-success"></i> Ingresos
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="gastos-tab" data-bs-toggle="tab" data-bs-target="#gastos" type="button" role="tab" aria-controls="gastos" aria-selected="false">
                        <i class="fas fa-arrow-down text-danger"></i> Gastos
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="ahorros-tab" data-bs-toggle="tab" data-bs-target="#ahorros" type="button" role="tab" aria-controls="ahorros" aria-selected="false">
                        <i class="fas fa-piggy-bank text-info"></i> Ahorros
                    </button>
                </li>
            </ul>
            <div class="tab-content" id="myTabContent">
                <div class="tab-pane fade show active" id="ingresos" role="tabpanel" aria-labelledby="ingresos-tab">
                    <div class="chart-container">
                        <c:choose>
                            <c:when test="${not empty ingresosDistribucionJSON and ingresosDistribucionJSON ne '[]'}">
                                <canvas id="ingresosChart"></canvas>
                            </c:when>
                            <c:otherwise><div class="empty-state"><i class="fas fa-chart-pie"></i><p>No hay datos de ingresos este mes.</p></div></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="tab-pane fade" id="gastos" role="tabpanel" aria-labelledby="gastos-tab">
                    <div class="chart-container">
                        <c:choose>
                            <c:when test="${not empty gastosDistribucionJSON and gastosDistribucionJSON ne '[]'}">
                                <canvas id="gastosChart"></canvas>
                            </c:when>
                            <c:otherwise><div class="empty-state"><i class="fas fa-chart-pie"></i><p>No hay datos de gastos este mes.</p></div></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="tab-pane fade" id="ahorros" role="tabpanel" aria-labelledby="ahorros-tab">
                    <div class="chart-container">
                        <c:choose>
                            <c:when test="${not empty ahorrosDistribucionJSON and ahorrosDistribucionJSON ne '[]'}">
                                <canvas id="ahorrosChart"></canvas>
                            </c:when>
                            <c:otherwise><div class="empty-state"><i class="fas fa-chart-pie"></i><p>No hay datos de ahorros este mes.</p></div></c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Últimas transacciones -->
        <div class="card mt-4">
            <div class="card-body chart-card">
                <h5><i class="fas fa-clock-rotate-left"></i> Últimas Transacciones (Global)</h5>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <!-- ... (código de la tabla de transacciones sin cambios) ... -->
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('monthSelect').addEventListener('change', function() {
        const selectedValue = this.value.split('-');
        document.getElementById('selectedMonth').value = selectedValue[0];
        document.getElementById('selectedYear').value = selectedValue[1];
        document.getElementById('monthFilterForm').submit();
    });

    function createDoughnutChart(canvasId, labels, data, colors) {
        const canvas = document.getElementById(canvasId);
        if (canvas) {
            new Chart(canvas, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{ data: data, backgroundColor: colors, borderWidth: 2 }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '65%',
                    plugins: {
                        legend: { position: 'bottom', labels: { padding: 15, usePointStyle: true, pointStyle: 'circle' } }
                    }
                }
            });
        }
    }

    // Gráfico de Ingresos
    <c:if test="${not empty ingresosDistribucionJSON and ingresosDistribucionJSON ne '[]'}">
        createDoughnutChart('ingresosChart', ${ingresosCategoriasJSON}, ${ingresosDistribucionJSON}, ['#2ecc71', '#28b463', '#1abc9c', '#16a085', '#27ae60']);
    </c:if>

    // Gráfico de Gastos
    <c:if test="${not empty gastosDistribucionJSON and gastosDistribucionJSON ne '[]'}">
        createDoughnutChart('gastosChart', ${gastosCategoriasJSON}, ${gastosDistribucionJSON}, ['#e74c3c', '#c0392b', '#f39c12', '#d35400', '#e67e22']);
    </c:if>

    // Gráfico de Ahorros
    <c:if test="${not empty ahorrosDistribucionJSON and ahorrosDistribucionJSON ne '[]'}">
        createDoughnutChart('ahorrosChart', ${ahorrosCategoriasJSON}, ${ahorrosDistribucionJSON}, ['#3498db', '#2980b9', '#9b59b6', '#8e44ad', '#5dade2']);
    </c:if>
</script>
</body>
</html>
