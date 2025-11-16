<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Página de Secciones</title>
    </head>
    <body>
        <jsp:include page="/WEB-INF/jsp/includes/nav.jsp" />
        <div class="presentacion">
        <div class="textoPresentacion">
            <h1>Con Marnager, administra tus finanzas de manera fácil y rápida</h1>
            <p>Nos decís cuánto dinero necesitás para cumplir con
            tus objetivos, tus ingresos y el tiempo mínimo en 
            el que lo necesitás, y nosotros te armamos tu mejor
            método de ahorro.</p>
            <a class="buttonRegister" href="signup.jsp">Comenzar</a>
        </div>
        <div class="imagenPresentacion">
            <img class="imagenchica" src="${pageContext.request.contextPath}/assets/chicasofia.png" alt="Ilustración de finanzas" />
        </div>
    </div>

    <div class="servicios">
        <h2>Conocé nuestras secciones</h2>
        <div class="cardIngresos">
            <h4>01</h4>
            <img src="${pageContext.request.contextPath}/assets/ingresos.png" alt="Ilustración de ingresos" />
            <h3>Ingresos</h3>
        </div>
        <div class="cardAhorros">
            <h4>02</h4>
            <img src="${pageContext.request.contextPath}/assets/ahorros.png" alt="Ilustración de ahorros" />
            <h3>Ahorros</h3>
        </div>
        <div class="cardGastos">
            <h4>03</h4>
            <img src="${pageContext.request.contextPath}/assets/gastos.png" alt="Ilustración de gastos" />
            <h3>Gastos</h3>
        </div>
    </div>

    <div class="beneficios">
        <h2>Beneficios de administrar tus finanzas con nosotros</h2>
        <div class="beneficioItems">
            <div class="beneficioItem1">
                <img src="${pageContext.request.contextPath}/assets/chanchito.png" alt="Ilustración de alcancía" />
                <h2>Ahorrar no es imposible</h2>
                <p>Con Marnager, te ayudamos a encontrar la mejor manera de ahorrar para tus metas.</p>
            </div>
            <div class="beneficioItem2">
                <img src="${pageContext.request.contextPath}/assets/grafico.png" alt="Ilustración de gráfico circular" />
                <h2>Visualización clara y sencilla</h2>
                <p>Ofrecemos gráficos y resúmenes automáticos que te ayudan a entender tus hábitos financieros.</p>
            </div>
            <div class="beneficioItem3">
                <img src="${pageContext.request.contextPath}/assets/notificaciones.png" alt="Ilustración de notificaciones" />
                <h2>Alertas y recordatorios</h2>
                <p>Te mantenemos informado sobre tus metas y gastos con notificaciones personalizadas.</p>
            </div>
        </div>
    </div>

    <div class="mensajeFinal">
        <h2>¡Empezá a dominar tu dinero, antes de que él te domine a vos!</h2>
    </div>
        <jsp:include page="/WEB-INF/jsp/includes/footer.jsp" />
    </body>
    
    <style>
        body{
            margin:0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        .presentacion {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 5rem 10%;
  background-image: url('${pageContext.request.contextPath}/assets/fondosisecc.png');
  background-size:cover;
  margin:0;
  height: 65vh;
}

.textoPresentacion {
  max-width: 50%;
}

.textoPresentacion .buttonRegister {
  display: inline-block;
  margin-top: 1.5rem;
  background-color: #4c5fff;
  color: white;
  padding: 0.8rem 1.5rem;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 600;
  transition: background-color 0.3s ease;
}

.presentacion h1 {
  font-size: 2.2rem;
  color: #ffffff;
  margin-bottom: 1.5rem;
}

.presentacion p {
  font-size: 1rem;
  color: #ffffff;
  line-height: 1.6;
  margin-bottom: 1.5rem;
  width: 500px;
}

.presentacion img {
  width: 450px;
  max-width: 100%;
}

.imagenPresentacion .imagenchica {
  width: 650px;
  height: auto;
}
/* ----------- SERVICIOS ----------- */
.servicios {
  display: flex;
  justify-content: center;
  align-items: start;
  gap: 2rem;
  padding: 3rem 8%;
  flex-wrap: wrap;
  text-align: center;
}

.servicios h2:first-of-type {
  width: 100%;
  text-align: center;
  margin-bottom: 1rem;
  color: #2F13AB;
  font-size: 1.8rem;
}

h3{
    font-size: 23px;
}
.servicios div {
  background-color: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  padding: 2rem;
  width: 280px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.servicios div:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

.servicios img {
  width: 100%;
  max-width: 280px;
  margin-bottom: 1rem;
}

h4 {
  color: #ffffff;
  margin-top: 0.5rem;
  font-size: 1.2rem;
  background-color: #4c5fff;
  width: 40px;
  padding: 10px;
  border-radius: 30px;
}

/* ----------- BENEFICIOS ----------- */
.beneficios {
  background-color: #b0b2c5;
  padding: 5rem 10%;
  text-align: center;
  display: flex;
  flex-direction: column;
}

.beneficios h2 {
  color: #1a1a1a;
  margin-bottom: 3rem;
}

.beneficios .beneficioItems {
  display: flex;
  justify-content: space-around;
  gap: 2rem;
  flex-wrap: wrap;
  padding-top:50px;
}

.beneficios div img {
  width: 90px;
  margin-bottom: 1rem;
}

.beneficios div h2 {
  font-size: 1.3rem;
  color: #333;
  margin-bottom: 0.5rem;
}

.beneficios div p {
  font-size: 0.95rem;
  color: #555;
  max-width: 280px;
  margin: 0 auto;
}

/* ----------- MENSAJE FINAL ----------- */
.mensajeFinal {

  text-align: center;
  padding: 1rem;
  color: rgb(36, 35, 35);
  font-weight: 600;
  font-size: 1.2rem;
  border-radius: 8px;
  margin: 3rem 10%;

}

/* ----------- RESPONSIVE ----------- */
@media (max-width: 900px) {
  .presentacion {
    flex-direction: column-reverse;
    text-align: center;
  }

  .servicios {
    flex-direction: column;
    align-items: center;
  }

  .beneficios > div {
    flex-direction: column;
  }
}
    </style>
</html>
