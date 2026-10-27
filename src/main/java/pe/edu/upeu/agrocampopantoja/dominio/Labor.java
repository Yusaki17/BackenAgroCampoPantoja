package pe.edu.upeu.agrocampopantoja.dominio;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDate;

@Entity
@Table(name = "labor")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Labor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lote_id", nullable = false)
    private Lote lote;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoLabor tipo;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false)
    private String responsable;

    @Column(nullable = false)
    private Double cantidad;

    @Column
    private String observacion;
}