package pe.edu.upeu.agrocampopantoja.repositorio;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.agrocampopantoja.dominio.Usuario;
import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByUsername(String username);
}