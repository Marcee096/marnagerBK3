<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Ahorros - Marnager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
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
    <a href="${pageContext.request.contextPath}/ahorros" style="background-color: #eaeaea;">Ahorros</a>
    <a href="#">Reportes</a>
    <a href="#">Configuración</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col">
                <h2>Metas de Ahorro</h2>
                <p>Define y sigue el progreso de tus metas de ahorro.</p>
            </div>
        </div>

        <div class="row">
            <!-- Formulario para añadir metas -->
            <div class="col-md-4">
                <div class="card p-4">
                    <h4>Crear Nueva Meta de Ahorro</h4>
                    <form action="${pageContext.request.contextPath}/ahorros" method="post">
                        <div class="mb-3">
                            <label for="monto_objetivo" class="form-label">Monto Objetivo</label>
                            <input type="number" class="form-control" id="monto_objetivo" name="monto_objetivo" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="nombre_meta" class="form-label">Nombre de la Meta</label>
                            <input type="text" class="form-control" id="nombre_meta" name="nombre_meta" required>
                        </div>
                        <div class="mb-3">
                            <label for="fecha_objetivo" class="form-label">Fecha Objetivo</label>
                            <input type="date" class="form-control" id="fecha_objetivo" name="fecha_objetivo" required>
                        </div>
                        <button type="submit" class="btn btn-info w-100 text-white">Crear Meta</button>
                    </form>
                </div>
            </div>

            <!-- Tabla de metas de ahorro -->
            <div class="col-md-8">
                <div class="card p-4">
                    <h4>Tus Metas</h4>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Meta</th>
                                <th>Progreso</th>
                                <th>Monto Objetivo</th>
                                <th>Fecha Límite</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ahorro" items="${ahorros}">
                                <tr>
                                    <td><c:out value="${ahorro.nombreMeta}" /></td>
                                    <td>
                                        <div class="progress">
                                            <div class="progress-bar" role="progressbar" style="width: <fmt:formatNumber value="${(ahorro.montoActual / ahorro.montoObjetivo) * 100}" maxFractionDigits="0" />%;" aria-valuenow="<fmt:formatNumber value="${(ahorro.montoActual / ahorro.montoObjetivo) * 100}" maxFractionDigits="0" />" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                        <small><fmt:formatNumber value="${ahorro.montoActual}" type="currency" currencySymbol="$" /> de <fmt:formatNumber value="${ahorro.montoObjetivo}" type="currency" currencySymbol="$" /></small>
                                    </td>
                                    <td><fmt:formatNumber value="${ahorro.montoObjetivo}" type="currency" currencySymbol="$" /></td>
                                    <td><fmt:formatDate value="${ahorro.fechaObjetivo}" pattern="dd/MM/yyyy" /></td>
                                    <td>
                                        <a href="#" class="btn btn-sm btn-outline-primary">Aportar</a>
                                        <a href="#" class="btn btn-sm btn-outline-danger">Eliminar</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty ahorros}">
                                <tr>
                                    <td colspan="5" class="text-center">No has definido metas de ahorro.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
