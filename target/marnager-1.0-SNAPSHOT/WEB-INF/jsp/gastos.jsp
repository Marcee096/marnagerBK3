<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Gastos - Marnager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e9ecef 100%);
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
            border-left-color: #e74c3c;
            padding-left: 25px;
        }
        .sidebar a.active {
            background-color: rgba(231, 76, 60, 0.2);
            border-left-color: #e74c3c;
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
        }
        .page-header h2 {
            color: #2c3e50;
            margin: 0 0 8px 0;
            font-weight: 600;
        }
        .page-header p {
            color: #7f8c8d;
            margin: 0;
        }
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            background: white;
            margin-bottom: 25px;
        }
        .card-header-custom {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
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
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            border: 2px solid #e0e6ed;
            border-radius: 8px;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #e74c3c;
            box-shadow: 0 0 0 0.2rem rgba(231, 76, 60, 0.15);
        }
        .btn-primary {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
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
            background-color: rgba(231, 76, 60, 0.02);
        }
        .table-hover tbody tr:hover {
            background-color: rgba(231, 76, 60, 0.05);
        }
        .badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 12px;
        }
        .btn-sm {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
        }
        .btn-outline-primary {
            border: 2px solid #3498db;
            color: #3498db;
        }
        .btn-outline-primary:hover {
            background-color: #3498db;
            color: white;
        }
        .btn-outline-danger {
            border: 2px solid #e74c3c;
            color: #e74c3c;
        }
        .btn-outline-danger:hover {
            background-color: #e74c3c;
            color: white;
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
    </style>
</head>
<body>

<!-- Topbar -->
<jsp:include page="includes/topbar.jsp" />

<!-- Sidebar -->
<div class="sidebar">
    <h3><i class="fas fa-wallet"></i> Marnager</h3>
    <a href="${pageContext.request.contextPath}/home">
        <i class="fas fa-home"></i> Inicio
    </a>
    <a href="${pageContext.request.contextPath}/ingresos">
        <i class="fas fa-arrow-up"></i> Ingresos
    </a>
    <a href="${pageContext.request.contextPath}/gastos" class="active">
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
        <!-- Page Header -->
        <div class="page-header">
            <h2><i class="fas fa-arrow-down text-danger"></i> Gestión de Gastos</h2>
            <p>Registra y categoriza todos tus gastos para un mejor control</p>
        </div>

                <!-- Mensajes de estado -->

                <c:if test="${param.status == 'created'}">

                    <div class="alert alert-success alert-dismissible fade show" role="alert">

                        <i class="fas fa-check-circle"></i>

                        <strong>¡Éxito!</strong> El gasto ha sido guardado correctamente.

                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>

                    </div>

                </c:if>

                <c:if test="${param.status == 'updated'}">

                    <div class="alert alert-success alert-dismissible fade show" role="alert">

                        <i class="fas fa-check-circle"></i>

                        <strong>¡Éxito!</strong> El gasto ha sido actualizado correctamente.

                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>

                    </div>

                </c:if>

                <c:if test="${param.status == 'deleted'}">

                    <div class="alert alert-info alert-dismissible fade show" role="alert">

                        <i class="fas fa-info-circle"></i>

                        <strong>¡Éxito!</strong> El gasto ha sido eliminado correctamente.

                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>

                    </div>

                </c:if>

                <c:if test="${param.status == 'error'}">

                    <div class="alert alert-danger alert-dismissible fade show" role="alert">

                        <i class="fas fa-exclamation-triangle"></i>

                        <strong>¡Error!</strong> Ocurrió un problema al procesar la solicitud.

                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>

                    </div>

                </c:if>

        

                <div class="row">

                    <!-- Formulario para añadir gastos -->

                    <div class="col-lg-5 col-md-12">

                        <div class="card">

                            <div class="card-header-custom">

                                <i class="fas fa-plus-circle"></i> Registrar Nuevo Gasto

                            </div>

                            <div class="card-body-custom">

                                <form action="${pageContext.request.contextPath}/gastos" method="post">

                                    <div class="mb-3">

                                        <label for="categoria" class="form-label">

                                            <i class="fas fa-folder"></i> Categoría

                                        </label>

                                        <select class="form-select" id="categoria" name="categoria" required>

                                            <option value="">Seleccione una categoría</option>

                                            <option value="Vivienda">Vivienda</option>

                                            <option value="Alimentación">Alimentacion</option>

                                            <option value="Transporte">Transporte</option>

                                            <option value="Ocio">Ocio</option>

                                            <option value="Salud">Salud</option>

                                            <option value="Educación">Educación</option>

                                            <option value="Ropa">Ropa</option>

                                            <option value="Otros">Otros</option>

                                        </select>

                                    </div>

        

                                    <div class="mb-3">

                                        <label for="subcategoria" class="form-label">

                                            <i class="fas fa-folder-open"></i> Subcategoría/Descripción

                                        </label>

                                        <input type="text" class="form-control" id="subcategoria" name="subcategoria" 

                                               placeholder="Ej: Supermercado, Factura de luz, etc." required>

                                    </div>

        

                                    <div class="mb-3">

                                        <label for="monto" class="form-label">

                                            <i class="fas fa-dollar-sign"></i> Monto

                                        </label>

                                        <input type="number" class="form-control" id="monto" name="monto" 

                                               step="0.01" placeholder="0.00" required>

                                    </div>

        

                                    <div class="mb-3">

                                        <label for="fecha" class="form-label">

                                            <i class="fas fa-calendar"></i> Fecha

                                        </label>

                                        <input type="date" class="form-control" id="fecha" name="fecha" required>

                                    </div>

        

                                    <button type="submit" class="btn btn-primary w-100">

                                        <i class="fas fa-plus"></i> Añadir Gasto

                                    </button>

                                </form>

                            </div>

                        </div>

                    </div>

        

                    <!-- Tabla de gastos -->

                    <div class="col-lg-7 col-md-12">

                        <div class="card">

                            <div class="card-header-custom">

                                <i class="fas fa-history"></i> Historial de Gastos

                            </div>

                            <div class="card-body-custom">

                                <div class="table-responsive">

                                    <table class="table table-striped table-hover">

                                        <thead>

                                            <tr>

                                                <th>Fecha</th>

                                                <th>Categoría</th>

                                                <th>Subcategoría</th>

                                                <th>Monto</th>

                                                <th>Acciones</th>

                                            </tr>

                                        </thead>

                                        <tbody>

                                            <c:forEach var="gasto" items="${gastos}">

                                                <tr>

                                                    <td>

                                                        <i class="fas fa-calendar-day text-muted"></i> 

                                                        <fmt:formatDate value="${gasto.fecha}" pattern="dd/MM/yyyy" />

                                                    </td>

                                                    <td>

                                                        <span class="badge bg-danger">

                                                            <c:out value="${gasto.categoria}" />

                                                        </span>

                                                    </td>

                                                    <td><c:out value="${gasto.subcategoria}" /></td>

                                                    <td class="fw-bold text-danger">

                                                        <fmt:formatNumber value="${gasto.monto}" type="currency" currencySymbol="$" />

                                                    </td>

                                                    

                                                    <td class="d-flex">

                                                        <button type="button" class="btn btn-sm btn-outline-primary me-2" title="Editar"

                                                                data-bs-toggle="modal" data-bs-target="#editGastoModal"

                                                                data-id="${gasto.idgasto}"

                                                                data-categoria="${gasto.categoria}"

                                                                data-subcategoria="${gasto.subcategoria}"

                                                                data-monto="<fmt:formatNumber value='${gasto.monto}' type='number' pattern='0.00' groupingUsed='false' />"

                                                                data-fecha="<fmt:formatDate value='${gasto.fecha}' pattern='yyyy-MM-dd' />">

                                                            <i class="fas fa-edit"></i>

                                                        </button>

                                                        <form action="${pageContext.request.contextPath}/gastos" method="post" onsubmit="return confirm('¿Estás seguro de que deseas eliminar este registro?');" style="display:inline;">

                                                            <input type="hidden" name="action" value="delete">

                                                            <input type="hidden" name="id" value="${gasto.idgasto}">

                                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Eliminar">

                                                                <i class="fas fa-trash"></i>

                                                            </button>

                                                        </form>

                                                    </td>

                                                </tr>

                                            </c:forEach>

                                            <c:if test="${empty gastos}">

                                                <tr>

                                                    <td colspan="5">

                                                        <div class="empty-state">

                                                            <i class="fas fa-inbox"></i>

                                                            <p>No hay gastos registrados todavía</p>

                                                            <small>Comienza añadiendo tu primer gasto</small>

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

        <div class="modal fade" id="editGastoModal" tabindex="-1" aria-labelledby="editGastoModalLabel" aria-hidden="true">

            <div class="modal-dialog modal-dialog-centered">

                <div class="modal-content">

                    <div class="modal-header card-header-custom">

                        <h5 class="modal-title" id="editGastoModalLabel"><i class="fas fa-edit"></i> Editar Gasto</h5>

                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>

                    </div>

                    <form action="${pageContext.request.contextPath}/gastos" method="post">

                        <div class="modal-body">

                            <input type="hidden" name="action" value="update">

                            <input type="hidden" name="id" id="edit-id">

        

                            <div class="mb-3">

                                <label for="edit-categoria" class="form-label"><i class="fas fa-folder"></i> Categoría</label>

                                <select class="form-select" id="edit-categoria" name="categoria" required>

                                    <option value="Vivienda">Vivienda</option>

                                    <option value="Alimentación">Alimentación</option>

                                    <option value="Transporte">Transporte</option>

                                    <option value="Ocio">Ocio</option>

                                    <option value="Salud">Salud</option>

                                    <option value="Educación">Educación</option>

                                    <option value="Ropa">Ropa</option>

                                    <option value="Otros">Otros</option>

                                </select>

                            </div>

        

                            <div class="mb-3">

                                <label for="edit-subcategoria" class="form-label"><i class="fas fa-folder-open"></i> Subcategoría/Descripción</label>

                                <input type="text" class="form-control" id="edit-subcategoria" name="subcategoria" required>

                            </div>

        

                            <div class="mb-3">

                                <label for="edit-monto" class="form-label"><i class="fas fa-dollar-sign"></i> Monto</label>

                                <input type="number" class="form-control" id="edit-monto" name="monto" step="0.01" required>

                            </div>

        

                            <div class="mb-3">

                                <label for="edit-fecha" class="form-label"><i class="fas fa-calendar"></i> Fecha</label>

                                <input type="date" class="form-control" id="edit-fecha" name="fecha" required>

                            </div>

                        </div>

                        <div class="modal-footer">

                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times"></i> Cancelar</button>

                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Guardar Cambios</button>

                        </div>

                    </form>

                </div>

            </div>

        </div>

        

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>

            var editModal = document.getElementById('editGastoModal');

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

        </script>

        </body>

        </html>

        