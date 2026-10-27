package pe.edu.upeu.agrocampopantoja.repositorio;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.agrocampopantoja.dominio.Rol;

public interface RolRepository extends JpaRepository<Rol, Long> {
}