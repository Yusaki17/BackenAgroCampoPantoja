package pe.edu.upeu.agrocampopantoja.web;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.agrocampopantoja.config.JwtService;
import pe.edu.upeu.agrocampopantoja.dominio.Usuario;
import pe.edu.upeu.agrocampopantoja.dto.ErrorResponse;
import pe.edu.upeu.agrocampopantoja.dto.LoginRequest;
import pe.edu.upeu.agrocampopantoja.dto.LoginResponse;
import pe.edu.upeu.agrocampopantoja.dto.UsuarioResponse;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    public AuthController(AuthenticationManager authenticationManager, JwtService jwtService) {
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getUsername(),
                            request.getPassword()
                    )
            );

            SecurityContextHolder.getContext().setAuthentication(authentication);
            Usuario usuario = (Usuario) authentication.getPrincipal();

            String token = jwtService.generarToken(usuario);

            List<String> privilegios = usuario.getRol().getPrivilegios().stream()
                    .map(p -> p.getNombre())
                    .collect(Collectors.toList());

            LoginResponse response = LoginResponse.builder()
                    .token(token)
                    .tipo("Bearer")
                    .expiraEnSegundos(3600L)
                    .username(usuario.getUsername())
                    .nombreCompleto(usuario.getNombreCompleto())
                    .rol(usuario.getRol().getNombre())
                    .privilegios(privilegios)
                    .build();

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.status(401).body(
                    new ErrorResponse("Credenciales incorrectas")
            );
        }
    }

    @GetMapping("/me")
    public ResponseEntity<?> obtenerUsuarioActual() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Usuario usuario = (Usuario) authentication.getPrincipal();

        List<String> privilegios = usuario.getRol().getPrivilegios().stream()
                .map(p -> p.getNombre())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new UsuarioResponse(i
                usuario.getUsername(),
                usuario.getNombreCompleto(),
                usuario.getRol().getNombre(),
                privilegios
        ));
    }
}