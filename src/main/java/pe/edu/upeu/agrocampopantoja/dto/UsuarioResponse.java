package pe.edu.upeu.agrocampopantoja.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioResponse {
    private String username;
    private String nombreCompleto;
    private String rol;
    private List<String> privilegios;
}