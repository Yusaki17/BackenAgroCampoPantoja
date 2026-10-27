package pe.edu.upeu.agrocampopantoja.repositorio;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.agrocampopantoja.dominio.Lote;

public interface LoteRepository extends JpaRepository<Lote, Long> {
    Page<Lote> findAllByValleAndCampaniaCerrada(String valle, Boolean campaniaCerrada, Pageable pageable);
    Page<Lote> findAllByCampaniaCerrada(Boolean campaniaCerrada, Pageable pageable);
}