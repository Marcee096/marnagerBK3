# Historial de Conversaciones y Cambios

## Contexto Inicial

A continuación se detallan las herramientas y versiones que se utilizarán en el desarrollo del proyecto:

*   **JAVA:** 11
*   **NetBeans IDE:** 26
*   **Jakarta EE:** 10
*   **Maven**
*   **GlassFish**
*   **MySQL**

## Hitos del Proyecto

*   **2025-11-11:**
    *   Creación del archivo `GEMINI.md` para el seguimiento del proyecto.
    *   **Estructura y Organización de JSP:**
        *   Se creó la estructura de directorios `src/main/webapp/jsp/includes` para organizar los archivos JSP.
        *   Se crearon los componentes reutilizables `nav.jsp` (navegación) y `footer.jsp` (pie de página).
        *   Se desarrolló la página principal `secciones.jsp`, incluyendo los componentes de navegación y pie de página.
        *   Se actualizó `index.html` para redirigir automáticamente a `secciones.jsp`.
    *   **Corrección de Rutas de Imágenes:**
        *   Se diagnosticó que la carpeta `assets` estaba en una ubicación incorrecta (`WEB-INF`).
        *   Se movió la carpeta `assets` a `src/main/webapp/assets` para hacerla accesible.
        *   Se corrigieron todas las rutas de imágenes en `secciones.jsp` usando `${pageContext.request.contextPath}` para garantizar su correcta visualización.
    *   **Configuración de Conexión a Base de Datos (GlassFish y JPA):**
        *   Se corrigió el `persistence.xml` para usar el JNDI `jdbc/marnager` y se añadió la propiedad `jakarta.persistence.schema-generation.database.action` con valor `create`.
        *   Se proporcionaron instrucciones detalladas para la configuración del "Connection Pool" (`marnager_pool`) y el "JDBC Resource" (`jdbc/marnager`) en la consola de administración de GlassFish.
        *   **Solución de Errores Comunes durante la Configuración:**
            *   `NullPointerException` durante el despliegue: Se diagnosticó y solucionó la ausencia de clases `@Entity` en el proyecto.
            *   `SAXParseException` en `persistence.xml`: Se corrigió la estructura XML mal formada del archivo `persistence.xml`.
            *   `JNDI lookup failed`: Se diagnosticó un fallo en la configuración del recurso JDBC en GlassFish, requiriendo verificación manual por parte del usuario.
            *   `Class name is wrong`: Se corrigió el `Datasource Classname` en el "Connection Pool" de GlassFish a `com.mysql.cj.jdbc.MysqlDataSource` para el driver MySQL 8.x.
            *   `Keystore was tampered with`: Se solucionó el problema de conexión SSL/TLS añadiendo `?useSSL=false` a la URL de conexión JDBC en el "Connection Pool".
        *   Se corrigió el `pom.xml` para establecer el `scope` de la dependencia `mysql-connector-java` a `provided` para evitar conflictos de classloader.
    *   **Implementación de Funcionalidad de Registro de Usuarios:**
        *   **Capa de Persistencia/Negocio (EJB):**
            *   Creación de `com.mycompany.marnager.ejb.AbstractFacade.java` para operaciones CRUD genéricas.
            *   Creación de `com.mycompany.marnager.ejb.UsuarioFacade.java` como EJB específico para la entidad `Usuario`.
        *   **Capa de Entidad:**
            *   Creación de `com.mycompany.marnager.model.Usuario.java` para mapear la tabla `usuario` de la base de datos.
            *   Actualización de `persistence.xml` para incluir la clase `Usuario` en la unidad de persistencia.
        *   **Capa de Controlador (Servlet):**
            *   Creación de `com.mycompany.marnager.servlet.RegisterServlet.java` para manejar el envío del formulario de registro.
        *   **Capa de Vista (JSP):**
            *   Creación de `src/main/webapp/register.jsp` con el formulario de registro.
            *   Creación de `src/main/webapp/login.jsp` como página de inicio de sesión (placeholder) con manejo de mensaje de éxito de registro.
        *   **Navegación:**
            *   Actualización de `src/main/webapp/jsp/includes/nav.jsp` para corregir el enlace al formulario de registro (`register.jsp`).