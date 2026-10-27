package pe.edu.upeu.agrocampopantoja.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private String tipo;
    private Long expiraEnSegundos;
    private String username;
    private String nombreCompleto;
    private String rol;
    private List<String> privilegios;
}