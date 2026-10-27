package pe.edu.upeu.agrocampopantoja.dominio;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "lote")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Lote {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String codigo;

    @Column(nullable = false)
    private String nombre;

    @Column(nullable = false)
    private Double hectareas;

    @Column(nullable = false)
    private String cultivo;

    @Column(nullable = false)
    private String valle;

    @Column(name = "campania_cerrada", nullable = false)
    private Boolean campaniaCerrada = false;

    @Column(name = "dosis_maxima_por_hectarea", nullable = false)
    private Double dosisMaximaPorHectarea;
}