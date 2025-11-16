<%@page contentType="text/html" pageEncoding="UTF-8"%>
<footer>
  <div class="footer-container">
    <div class="footer-section">
      <h3>SIMPLIFICATE</h3>
      <ul>
        <li><a href="tuto.jsp">Cómo funciona</a></li>
        <li><a href="faq.jsp">Preguntas frecuentes</a></li>
        <li><a href="nosotros.jsp">Nosotros</a></li>
        <li><a href="edu.jsp">Educación financiera</a></li>
      </ul>
    </div>

    <div class="footer-section">
      <h3>LEGALES</h3>
      <ul>
        <li><a href="privacidad.jsp">Aviso de privacidad</a></li>
        <li><a href="terminos.jsp">Términos y condiciones</a></li>
      </ul>
    </div>
  </div>

  <div class="footer-bottom">
    <p>© 2025 Marnager. Todos los derechos reservados.</p>
  </div>
</footer>
<style>
footer {
  background-color: #0c0c33;
  color: white;
  padding: 4rem 10% 2rem;
  font-family: 'Poppins', sans-serif;
}

.footer-container {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 2rem;
  border-bottom: 1px solid rgba(255,255,255,0.2);
  padding-bottom: 2rem;
}

.footer-section h3 {
  font-size: 0.9rem;
  letter-spacing: 1px;
  margin-bottom: 1rem;
  color: #aeb3ff;
}

.footer-section ul {
  list-style: none;
  padding: 0;
}

.footer-section ul li {
  margin-bottom: 0.6rem;
}

.footer-section ul li a {
  text-decoration: none;
  color: #d6d8ff;
  font-size: 0.9rem;
  transition: color 0.3s ease;
}

.footer-section ul li a:hover {
  color: #ffffff;
}

.footer-bottom {
  text-align: center;
  margin-top: 2rem;
  font-size: 0.85rem;
  color: #b7b9ff;
}

/* --- RESPONSIVE --- */
@media (max-width: 900px) {
  .footer-container {
    flex-direction: column;
    text-align: center;
    align-items: center;
  }
  
}
</style>