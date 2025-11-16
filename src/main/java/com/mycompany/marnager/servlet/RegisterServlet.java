package com.mycompany.marnager.servlet;

import com.mycompany.marnager.ejb.UsuarioFacade;
import com.mycompany.marnager.model.Usuario;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @EJB
    private UsuarioFacade usuarioFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Aquí podrías añadir validaciones (ej. si el email ya existe, si el password es seguro, etc.)
        
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setEmail(email);
        nuevoUsuario.setPassword(password); // En un proyecto real, deberías encriptar la contraseña.
        
        usuarioFacade.create(nuevoUsuario);
        
        // Redirigir a la página de login (que crearemos después) con un mensaje de éxito.
        response.sendRedirect("login.jsp?reg=success");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para registrar nuevos usuarios";
    }
}
