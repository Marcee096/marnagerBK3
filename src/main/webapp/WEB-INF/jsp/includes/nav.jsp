<%@page contentType="text/html" pageEncoding="UTF-8"%>
<nav>
    <img src="${pageContext.request.contextPath}/assets/logomarna.png" alt="Ilustración de logo" />
    <ul>
        <li><a href="${pageContext.request.contextPath}/tuto.jsp">Cómo funciona</a></li>
        <li><a href="${pageContext.request.contextPath}/WEB-INF/jsp/secciones.jsp">Secciones</a></li>
        <li><a href="${pageContext.request.contextPath}/nosotros.jsp">Nosotros</a></li>
        <li><a href="${pageContext.request.contextPath}/edu.jsp">Educación financiera</a></li>
    </ul>
    <div>
        <a class="buttonLogin" href="${pageContext.request.contextPath}/login.jsp">Iniciar sesión</a>
        <a class="buttonRegister" href="${pageContext.request.contextPath}/register.jsp">Regístrate</a>
    </div>
</nav>
<style>
/* --- el mismo CSS del nav de Svelte --- */
nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 3rem;
  background-color: white;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
  position: sticky;
  top: 0;
  z-index: 100;
}
nav img {
  height: 40px;
}
nav ul {
  display: flex;
  list-style: none;
  gap: 2rem;
}
nav ul li a {
  text-decoration: none;
  color: #2e2e2e;
  font-weight: 500;
  transition: color 0.3s ease;
}
nav ul li a:hover {
  color: #4c5fff;
}
nav ul li a:active {
  border-bottom: 2px solid #4c5fff;
}
.buttonLogin, .buttonRegister {
  text-decoration: none;
  padding: 0.6rem 1.2rem;
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s ease;
}
.buttonRegister {
  color: #4c5fff;
}
.buttonRegister:hover {
  background-color: #e7e9ff;
}
.buttonLogin {
  background-color: #4c5fff;
  color: white;
}
.buttonLogin:hover {
  background-color: #3749cc;
}
</style>
