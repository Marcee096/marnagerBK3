<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Gastos - Marnager</title>
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
    <a href="${pageContext.request.contextPath}/gastos" style="background-color: #eaeaea;">Gastos</a>
    <a href="${pageContext.request.contextPath}/ahorros">Ahorros</a>
    <a href="#">Reportes</a>
    <a href="#">Configuración</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col">
                <h2>Gestión de Gastos</h2>
                <p>Aquí puedes ver y registrar tus gastos.</p>
            </div>
        </div>

        <div class="row">
            <!-- Formulario para añadir gastos -->
            <div class="col-md-4">
                <div class="card p-4">
                    <h4>Registrar Nuevo Gasto</h4>
                    <form action="${pageContext.request.contextPath}/gastos" method="post">
                        <div class="mb-3">
                            <label for="monto" class="form-label">Monto</label>
                            <input type="number" class="form-control" id="monto" name="monto" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <input type="text" class="form-control" id="descripcion" name="descripcion" required>
                        </div>
                        <div class="mb-3">
                            <label for="categoria" class="form-label">Categoría</label>
                            <input type="text" class="form-control" id="categoria" name="categoria" required>
                        </div>
                        <div class="mb-3">
                            <label for="fecha" class="form-label">Fecha</label>
                            <input type="date" class="form-control" id="fecha" name="fecha" required>
                        </div>
                        <button type="submit" class="btn btn-danger w-100">Añadir Gasto</button>
                    </form>
                </div>
            </div>

            <!-- Tabla de gastos -->
            <div class="col-md-8">
                <div class="card p-4">
                    <h4>Historial de Gastos</h4>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Monto</th>
                                <th>Descripción</th>
                                <th>Categoría</th>
                                <th>Fecha</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="gasto" items="${gastos}">
                                <tr>
                                    <td><fmt:formatNumber value="${gasto.monto}" type="currency" currencySymbol="$" /></td>
                                    <td><c:out value="${gasto.descripcion}" /></td>
                                    <td><c:out value="${gasto.categoria}" /></td>
                                    <td><fmt:formatDate value="${gasto.fecha}" pattern="dd/MM/yyyy" /></td>
                                    <td>
                                        <a href="#" class="btn btn-sm btn-outline-primary">Editar</a>
                                        <a href="#" class="btn btn-sm btn-outline-danger">Eliminar</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty gastos}">
                                <tr>
                                    <td colspan="5" class="text-center">No hay gastos registrados.</td>
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
