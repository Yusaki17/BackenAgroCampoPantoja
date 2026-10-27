-- ============================================
-- TABLA: PRIVILEGIOS
-- ============================================
CREATE TABLE privilegio (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            nombre VARCHAR(50) NOT NULL UNIQUE
);

-- ============================================
-- TABLA: ROLES
-- ============================================
CREATE TABLE rol (
                     id BIGINT AUTO_INCREMENT PRIMARY KEY,
                     nombre VARCHAR(50) NOT NULL UNIQUE
);

-- ============================================
-- TABLA: USUARIOS
-- ============================================
CREATE TABLE usuario (
                         id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         username VARCHAR(50) NOT NULL UNIQUE,
                         password VARCHAR(255) NOT NULL,
                         nombre_completo VARCHAR(100) NOT NULL,
                         rol_id BIGINT NOT NULL,
                         estado BOOLEAN NOT NULL DEFAULT TRUE,
                         FOREIGN KEY (rol_id) REFERENCES rol(id)
);

-- ============================================
-- RELACIÓN: ROL <-> PRIVILEGIO
-- ============================================
CREATE TABLE rol_privilegio (
                                rol_id BIGINT NOT NULL,
                                privilegio_id BIGINT NOT NULL,
                                PRIMARY KEY (rol_id, privilegio_id),
                                FOREIGN KEY (rol_id) REFERENCES rol(id),
                                FOREIGN KEY (privilegio_id) REFERENCES privilegio(id)
);

-- ============================================
-- TABLA: LOTES
-- ============================================
CREATE TABLE lote (
                      id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      codigo VARCHAR(20) NOT NULL UNIQUE,
                      nombre VARCHAR(100) NOT NULL,
                      hectareas DOUBLE NOT NULL,
                      cultivo VARCHAR(50) NOT NULL,
                      valle VARCHAR(50) NOT NULL,
                      campania_cerrada BOOLEAN NOT NULL DEFAULT FALSE,
                      dosis_maxima_por_hectarea DOUBLE NOT NULL
);

-- ============================================
-- TABLA: LABORES
-- ============================================
CREATE TABLE labor (
                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       lote_id BIGINT NOT NULL,
                       tipo VARCHAR(20) NOT NULL,
                       fecha DATE NOT NULL,
                       responsable VARCHAR(100) NOT NULL,
                       cantidad DOUBLE NOT NULL,
                       observacion TEXT,
                       FOREIGN KEY (lote_id) REFERENCES lote(id)
);

-- ============================================
-- DATOS SEMILLA: PRIVILEGIOS
-- ============================================
INSERT INTO privilegio (nombre) VALUES
                                    ('LOTE_LEER'),
                                    ('LABOR_LEER'),
                                    ('LABOR_CREAR'),
                                    ('LABOR_EDITAR'),
                                    ('LABOR_ELIMINAR'),
                                    ('CAMPANIA_CERRAR'),
                                    ('USUARIO_GESTIONAR');

-- ============================================
-- DATOS SEMILLA: ROLES
-- ============================================
INSERT INTO rol (nombre) VALUES
                             ('TECNICO'),
                             ('JEFE_CAMPO'),
                             ('ADMINISTRADOR');

-- ============================================
-- ASIGNACIÓN DE PRIVILEGIOS A ROLES
-- ============================================

-- TECNICO: LOTE_LEER, LABOR_LEER, LABOR_CREAR, LABOR_EDITAR (solo las propias)
INSERT INTO rol_privilegio (rol_id, privilegio_id) VALUES
                                                       ((SELECT id FROM rol WHERE nombre='TECNICO'), (SELECT id FROM privilegio WHERE nombre='LOTE_LEER')),
                                                       ((SELECT id FROM rol WHERE nombre='TECNICO'), (SELECT id FROM privilegio WHERE nombre='LABOR_LEER')),
                                                       ((SELECT id FROM rol WHERE nombre='TECNICO'), (SELECT id FROM privilegio WHERE nombre='LABOR_CREAR')),
                                                       ((SELECT id FROM rol WHERE nombre='TECNICO'), (SELECT id FROM privilegio WHERE nombre='LABOR_EDITAR'));

-- JEFE_CAMPO: Todos excepto USUARIO_GESTIONAR
INSERT INTO rol_privilegio (rol_id, privilegio_id) VALUES
                                                       ((SELECT id FROM rol WHERE nombre='JEFE_CAMPO'), (SELECT id FROM privilegio WHERE nombre='LOTE_LEER')),
                                                       ((SELECT id FROM rol WHERE nombre='JEFE_CAMPO'), (SELECT id FROM privilegio WHERE nombre='LABOR_LEER')),
                                                       ((SELECT id FROM rol WHERE nombre='JEFE_CAMPO'), (SELECT id FROM privilegio WHERE nombre='LABOR_CREAR')),
                                                       ((SELECT id FROM rol WHERE nombre='JEFE_CAMPO'), (SELECT id FROM privilegio WHERE nombre='LABOR_EDITAR')),
                                                       ((SELECT id FROM rol WHERE nombre='JEFE_CAMPO'), (SELECT id FROM privilegio WHERE nombre='LABOR_ELIMINAR')),
                                                       ((SELECT id FROM rol WHERE nombre='JEFE_CAMPO'), (SELECT id FROM privilegio WHERE nombre='CAMPANIA_CERRAR'));

-- ADMINISTRADOR: USUARIO_GESTIONAR
INSERT INTO rol_privilegio (rol_id, privilegio_id) VALUES
    ((SELECT id FROM rol WHERE nombre='ADMINISTRADOR'), (SELECT id FROM privilegio WHERE nombre='USUARIO_GESTIONAR'));

-- ============================================
-- DATOS SEMILLA: USUARIOS
-- Contraseña: Agro2026* (hash BCrypt)
-- ============================================
INSERT INTO usuario (username, password, nombre_completo, rol_id, estado) VALUES
                                                                              ('tecnico1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Técnico Uno', (SELECT id FROM rol WHERE nombre='TECNICO'), TRUE),
                                                                              ('jefe1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Jefe de Campo', (SELECT id FROM rol WHERE nombre='JEFE_CAMPO'), TRUE),
                                                                              ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Administrador', (SELECT id FROM rol WHERE nombre='ADMINISTRADOR'), TRUE);

-- ============================================
-- DATOS SEMILLA: LOTES (8 lotes en 3 valles)
-- 2 con campaña cerrada (L003 y L007)
-- ============================================
INSERT INTO lote (codigo, nombre, hectareas, cultivo, valle, campania_cerrada, dosis_maxima_por_hectarea) VALUES
                                                                                                              ('L001', 'Lote Norte', 5.0, 'Maíz', 'Valle A', FALSE, 2.5),
                                                                                                              ('L002', 'Lote Sur', 3.5, 'Papa', 'Valle A', FALSE, 3.0),
                                                                                                              ('L003', 'Lote Este', 4.0, 'Trigo', 'Valle B', TRUE, 2.0),
                                                                                                              ('L004', 'Lote Oeste', 6.0, 'Arroz', 'Valle B', FALSE, 4.0),
                                                                                                              ('L005', 'Lote Central', 2.5, 'Cebada', 'Valle C', FALSE, 2.2),
                                                                                                              ('L006', 'Lote Alto', 7.0, 'Quinua', 'Valle C', FALSE, 1.5),
                                                                                                              ('L007', 'Lote Bajo', 3.0, 'Maíz', 'Valle A', TRUE, 2.5),
                                                                                                              ('L008', 'Lote Medio', 4.5, 'Papa', 'Valle B', FALSE, 3.0);

-- ============================================
-- DATOS SEMILLA: LABORES (20 labores)
-- Cada lote abierto con 2+ labores
-- L003 (cerrado) tiene COSECHA
-- L006 (abierto) NO tiene COSECHA (para probar RN-03)
-- ============================================
INSERT INTO labor (lote_id, tipo, fecha, responsable, cantidad, observacion) VALUES
                                                                                 (1, 'RIEGO', '2026-10-20', 'tecnico1', 10.0, 'Riego matutino'),
                                                                                 (1, 'FUMIGACION', '2026-10-21', 'tecnico1', 5.0, 'Fumigación preventiva'),
                                                                                 (1, 'COSECHA', '2026-10-25', 'tecnico1', 100.0, 'Cosecha completa'),
                                                                                 (2, 'RIEGO', '2026-10-20', 'tecnico1', 8.0, 'Riego normal'),
                                                                                 (2, 'FUMIGACION', '2026-10-22', 'tecnico1', 6.0, 'Control de plagas'),
                                                                                 (3, 'RIEGO', '2026-10-15', 'tecnico1', 7.0, 'Último riego antes de cierre'),
                                                                                 (3, 'COSECHA', '2026-10-18', 'tecnico1', 80.0, 'Cosecha final'),
                                                                                 (4, 'RIEGO', '2026-10-23', 'tecnico1', 12.0, 'Riego intensivo'),
                                                                                 (4, 'FUMIGACION', '2026-10-24', 'tecnico1', 8.0, 'Fumigación completa'),
                                                                                 (5, 'RIEGO', '2026-10-25', 'tecnico1', 6.0, 'Riego ligero'),
                                                                                 (6, 'FUMIGACION', '2026-10-26', 'tecnico1', 4.0, 'Fumigación preventiva'),
                                                                                 (6, 'RIEGO', '2026-10-27', 'tecnico1', 9.0, 'Riego normal'),
                                                                                 (7, 'RIEGO', '2026-10-10', 'tecnico1', 7.0, 'Riego antes de cierre'),
                                                                                 (7, 'COSECHA', '2026-10-12', 'tecnico1', 60.0, 'Cosecha completa'),
                                                                                 (8, 'RIEGO', '2026-10-26', 'tecnico1', 10.0, 'Riego matutino'),
                                                                                 (8, 'FUMIGACION', '2026-10-27', 'tecnico1', 7.0, 'Fumigación completa'),
                                                                                 (1, 'RIEGO', '2026-10-26', 'jefe1', 11.0, 'Riego supervisado'),
                                                                                 (2, 'RIEGO', '2026-10-25', 'jefe1', 9.0, 'Riego de supervisión'),
                                                                                 (4, 'RIEGO', '2026-10-25', 'jefe1', 13.0, 'Riego intensivo supervisado'),
                                                                                 (6, 'COSECHA', '2026-10-28', 'jefe1', 120.0, 'Cosecha supervisada');