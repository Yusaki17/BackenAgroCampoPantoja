package pe.edu.upeu.agrocampopantoja.repositorio;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.agrocampopantoja.dominio.Labor;
import pe.edu.upeu.agrocampopantoja.dominio.TipoLabor;

public interface LaborRepository extends JpaRepository<Labor, Long> {
    Page<Labor> findAllByLoteIdOrderByFechaDesc(Long loteId, Pageable pageable);
    boolean existsByLoteIdAndTipo(Long loteId, TipoLabor tipo);
}