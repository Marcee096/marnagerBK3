<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Iniciar Sesión - Marnager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        .main-content {
            flex: 1;
        }
        .form-container {
            max-width: 500px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: #ffffff;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/jsp/includes/nav.jsp" />

    <div class="main-content container">
        <div class="form-container">
            
            <%-- Mostrar mensaje de éxito si viene del registro --%>
            <% if ("success".equals(request.getParameter("reg"))) { %>
                <div class="alert alert-success" role="alert">
                    ¡Registro exitoso! Por favor, inicie sesión.
                </div>
            <% } %>

            <h2 class="text-center mb-4">Iniciar Sesión</h2>
            <form action="login" method="POST">
                <div class="mb-3">
                    <label for="email" class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Iniciar Sesión</button>
                </div>
            </form>
            <div class="text-center mt-3">
                <p>¿No tienes una cuenta? <a href="register.jsp">Regístrate aquí</a></p>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/jsp/includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
