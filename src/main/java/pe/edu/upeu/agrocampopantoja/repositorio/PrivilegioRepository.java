package pe.edu.upeu.agrocampopantoja.repositorio;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.agrocampopantoja.dominio.Privilegio;

public interface PrivilegioRepository extends JpaRepository<Privilegio, Long> {
}