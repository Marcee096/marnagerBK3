<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="topbar">
    <div class="profile-container">
        <div class="profile-circle" onclick="toggleDropdown()">
            <c:if test="${not empty sessionScope.usuario.email}">
                ${sessionScope.usuario.email.substring(0, 1)}
            </c:if>
            <c:if test="${empty sessionScope.usuario.email}">
                U
            </c:if>
        </div>
        <div id="profile-dropdown" class="dropdown-content">
            <div class="dropdown-header">
                <p class="username">
                    <c:out value="${sessionScope.usuario.email}" />
                </p>
            </div>
            <a href="#">Mi Perfil</a>
            <a href="#">Configuración</a>
            <div class="dropdown-divider"></div>
            <a href="${pageContext.request.contextPath}/logout">Cerrar Sesión</a>
        </div>
    </div>
</div>

<style>
    .topbar {
        position: fixed;
        top: 0;
        left: 220px; /* Ancho del sidebar */
        right: 0;
        height: 60px;
        background-color: #fff;
        border-bottom: 1px solid #ddd;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        padding: 0 30px;
        z-index: 99;
    }

    .profile-container {
        position: relative;
        display: inline-block;
    }

    .profile-circle {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #53BDB3;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.2rem;
        font-weight: bold;
        cursor: pointer;
        text-transform: uppercase;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        right: 0;
        top: 50px;
        background-color: #fff;
        min-width: 220px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 100;
        border-radius: 8px;
        overflow: hidden;
    }
    
    .dropdown-header {
        padding: 15px;
        border-bottom: 1px solid #f0f0f0;
    }
    
    .dropdown-header .username {
        font-weight: bold;
        margin: 0;
        color: #333;
    }
    
    .dropdown-header .email {
        font-size: 0.9em;
        color: #777;
        margin: 0;
    }

    .dropdown-content a {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
        font-size: 0.95em;
    }

    .dropdown-content a:hover {
        background-color: #f1f1f1;
    }
    
    .dropdown-divider {
        height: 1px;
        margin: 8px 0;
        overflow: hidden;
        background-color: #e5e5e5;
    }

</style>

<script>
    function toggleDropdown() {
        document.getElementById("profile-dropdown").style.display = 
            document.getElementById("profile-dropdown").style.display === "block" ? "none" : "block";
    }

    // Cierra el dropdown si se hace clic fuera de él
    window.onclick = function(event) {
        if (!event.target.matches('.profile-circle')) {
            var dropdowns = document.getElementsByClassName("dropdown-content");
            for (var i = 0; i < dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.style.display === "block") {
                    openDropdown.style.display = "none";
                }
            }
        }
    }
</script>
