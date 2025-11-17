<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Ahorros - Marnager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
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
            border-left-color: #8e44ad;
            padding-left: 25px;
        }
        .sidebar a.active {
            background-color: rgba(142, 68, 173, 0.2);
            border-left-color: #8e44ad;
            font-weight: 600;
        }
        .main-content {
            margin-left: 260px;
            margin-top: 60px;
            padding: 30px;
        }
        .page-header {
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-header h2 {
            color: #2c3e50;
            margin: 0;
            font-weight: 600;
        }
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            background: white;
            margin-bottom: 25px;
        }
        .card-header-custom {
            background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
            color: white;
            padding: 20px 25px;
            border-radius: 12px 12px 0 0;
            font-weight: 600;
            font-size: 18px;
        }
        .card-body-custom {
            padding: 25px;
        }
        .form-label {
            font-weight: 500;
            color: #2c3e50;
        }
        .form-control, .form-select {
            border-radius: 8px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
            border: none;
            font-weight: 600;
        }
        .table thead th {
            background-color: #f8f9fa;
            font-weight: 600;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        .sidebar img{
            width: 150px;
        }
        .chart-container {
            position: relative;
            height: 300px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<jsp:include page="includes/topbar.jsp" />
<div class="sidebar">
    <h3><img src="${pageContext.request.contextPath}/assets/marnagerBlanco.png" alt="logoMarnager" /></h3>
    <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Inicio</a>
    <a href="${pageContext.request.contextPath}/ingresos"><i class="fas fa-arrow-up"></i> Ingresos</a>
    <a href="${pageContext.request.contextPath}/gastos"><i class="fas fa-arrow-down"></i> Gastos</a>
    <a href="${pageContext.request.contextPath}/ahorros" class="active"><i class="fas fa-piggy-bank"></i> Ahorros</a>
    <a href="#"><i class="fas fa-chart-bar"></i> Reportes</a>
    <a href="#"><i class="fas fa-cog"></i> Configuración</a>
</div>

<div class="main-content">
    <div class="container-fluid">
        <div class="page-header">
            <div>
                <h2><i class="fas fa-piggy-bank text-info"></i> Gestión de Ahorros</h2>
            </div>
            <div>
                <form id="monthFilterForm" action="${pageContext.request.contextPath}/ahorros" method="get" class="d-flex align-items-center">
                    <label for="monthSelect" class="form-label me-2 mb-0">Mes:</label>
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

        <c:if test="${not empty status}">
            <div class="alert alert-${status == 'created' || status == 'updated' ? 'success' : (status == 'deleted' ? 'info' : 'danger')} alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i>
                <strong>
                    <c:choose>
                        <c:when test="${status == 'created'}">¡Éxito! El ahorro ha sido guardado.</c:when>
                        <c:when test="${status == 'updated'}">¡Éxito! El ahorro ha sido actualizado.</c:when>
                        <c:when test="${status == 'deleted'}">¡Éxito! El ahorro ha sido eliminado.</c:when>
                        <c:otherwise>¡Error! Hubo un problema.</c:otherwise>
                    </c:choose>
                </strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-4">
                    <div class="card-header-custom">
                        <i class="fas fa-chart-pie"></i> Distribución de Ahorros
                    </div>
                    <div class="card-body-custom">
                        <c:choose>
                            <c:when test="${not empty distribucionJSON and distribucionJSON ne '[]'}">
                                <div class="chart-container">
                                    <canvas id="distribucionAhorrosChart"></canvas>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-chart-pie"></i>
                                    <p>No hay datos de ahorros para mostrar en el gráfico para el mes seleccionado.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header-custom">
                        <i class="fas fa-plus-circle"></i> Registrar Nuevo Ahorro
                    </div>
                    <div class="card-body-custom">
                        <form action="${pageContext.request.contextPath}/ahorros" method="post">
                            <input type="hidden" name="year" value="${selectedYear}">
                            <input type="hidden" name="month" value="${selectedMonth}">
                            <div class="mb-3">
                                <label for="categoria" class="form-label"><i class="fas fa-folder"></i> Categoría</label>
                                <select class="form-select" id="categoria" name="categoria" required>
                                    <option value="">Seleccione una categoría</option>
                                    <option value="Meta Vacaciones">Meta Vacaciones</option>
                                    <option value="Fondo Emergencia">Fondo de Emergencia</option>
                                    <option value="Compra Grande">Compra Grande (Auto, Casa)</option>
                                    <option value="Educación">Educación</option>
                                    <option value="Jubilación">Jubilación</option>
                                    <option value="Otros">Otros</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="subcategoria" class="form-label"><i class="fas fa-folder-open"></i> Subcategoría/Descripción</label>
                                <input type="text" class="form-control" id="subcategoria" name="subcategoria" placeholder="Ej: Aporte mensual, Viaje a la playa, etc." required>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="monto" class="form-label"><i class="fas fa-dollar-sign"></i> Monto</label>
                                    <input type="number" class="form-control" id="monto" name="monto" step="0.01" placeholder="0.00" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="fecha" class="form-label"><i class="fas fa-calendar"></i> Fecha</label>
                                    <input type="date" class="form-control" id="fecha" name="fecha" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100"><i class="fas fa-plus"></i> Añadir Ahorro</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card">
                    <div class="card-header-custom">
                        <i class="fas fa-history"></i> Historial de Ahorros
                    </div>
                    <div class="card-body-custom p-0">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Fecha</th>
                                        <th>Categoría</th>
                                        <th>Descripción</th>
                                        <th class="text-end">Monto</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ahorro" items="${ahorros}">
                                        <tr>
                                            <td><fmt:formatDate value="${ahorro.fecha}" pattern="dd/MM/yyyy" /></td>
                                            <td><span class="badge bg-info-subtle text-info-emphasis rounded-pill"><c:out value="${ahorro.categoria}" /></span></td>
                                            <td><c:out value="${ahorro.subcategoria}" /></td>
                                            <td class="fw-bold text-info text-end"><fmt:formatNumber value="${ahorro.monto}" type="currency" currencySymbol="+$" /></td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-sm btn-outline-primary" title="Editar"
                                                        data-bs-toggle="modal" data-bs-target="#editAhorroModal"
                                                        data-id="${ahorro.idahorro}"
                                                        data-categoria="${ahorro.categoria}"
                                                        data-subcategoria="${ahorro.subcategoria}"
                                                        data-monto="<fmt:formatNumber value='${ahorro.monto}' type='number' pattern='0.00' groupingUsed='false' />"
                                                        data-fecha="<fmt:formatDate value='${ahorro.fecha}' pattern='yyyy-MM-dd' />">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <form action="${pageContext.request.contextPath}/ahorros" method="post" onsubmit="return confirm('¿Seguro que quieres eliminar este ahorro?');" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${ahorro.idahorro}">
                                                    <input type="hidden" name="year" value="${selectedYear}">
                                                    <input type="hidden" name="month" value="${selectedMonth}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Eliminar"><i class="fas fa-trash"></i></button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty ahorros}">
                                        <tr>
                                            <td colspan="5">
                                                <div class="empty-state">
                                                    <i class="fas fa-inbox"></i>
                                                    <p>No hay ahorros registrados para este mes.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal de Edición -->
<div class="modal fade" id="editAhorroModal" tabindex="-1" aria-labelledby="editAhorroModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header card-header-custom">
                <h5 class="modal-title" id="editAhorroModalLabel"><i class="fas fa-edit"></i> Editar Ahorro</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/ahorros" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="edit-id">
                    <input type="hidden" name="year" value="${selectedYear}">
                    <input type="hidden" name="month" value="${selectedMonth}">
                    <div class="mb-3">
                        <label for="edit-categoria" class="form-label">Categoría</label>
                        <select class="form-select" id="edit-categoria" name="categoria" required>
                            <option value="Meta Vacaciones">Meta Vacaciones</option>
                            <option value="Fondo Emergencia">Fondo de Emergencia</option>
                            <option value="Compra Grande">Compra Grande (Auto, Casa)</option>
                            <option value="Educación">Educación</option>
                            <option value="Jubilación">Jubilación</option>
                            <option value="Otros">Otros</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="edit-subcategoria" class="form-label">Subcategoría/Descripción</label>
                        <input type="text" class="form-control" id="edit-subcategoria" name="subcategoria" required>
                    </div>
                    <div class="mb-3">
                        <label for="edit-monto" class="form-label">Monto</label>
                        <input type="number" class="form-control" id="edit-monto" name="monto" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label for="edit-fecha" class="form-label">Fecha</label>
                        <input type="date" class="form-control" id="edit-fecha" name="fecha" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                </div>
            </form>
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

    var editModal = document.getElementById('editAhorroModal');
    editModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var id = button.getAttribute('data-id');
        var categoria = button.getAttribute('data-categoria');
        var subcategoria = button.getAttribute('data-subcategoria');
        var monto = button.getAttribute('data-monto');
        var fecha = button.getAttribute('data-fecha');

        var modal = this;
        modal.querySelector('#edit-id').value = id;
        modal.querySelector('#edit-categoria').value = categoria;
        modal.querySelector('#edit-subcategoria').value = subcategoria;
        modal.querySelector('#edit-monto').value = monto;
        modal.querySelector('#edit-fecha').value = fecha;
    });

    <c:if test="${not empty distribucionJSON and distribucionJSON ne '[]'}">
        const categorias = ${categoriasJSON};
        const distribucion = ${distribucionJSON};

        new Chart(document.getElementById('distribucionAhorrosChart'), {
            type: 'doughnut',
            data: {
                labels: categorias,
                datasets: [{
                    data: distribucion,
                    backgroundColor: [
                        '#9b59b6', '#8e44ad', '#3498db', '#2980b9',
                        '#1abc9c', '#16a085', '#f1c40f', '#f39c12'
                    ],
                    borderWidth: 2
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
    </c:if>
</script>
</body>
</html>