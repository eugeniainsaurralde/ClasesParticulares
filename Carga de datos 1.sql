INSERT INTO materia (materia) VALUES
('Matemática'),
('Física'),
('Química'),
('Inglés');

INSERT INTO servicios (servicio) VALUES
('Clase individual'),
('Clase grupal'),
('Evaluación'),
('Consulta');

INSERT INTO horarios (horarios) VALUES
('08:00 - 09:00'),
('09:00 - 10:00'),
('10:00 - 11:00'),
('11:00 - 12:00'),
('13:00 - 14:00'),
('14:00 - 15:00'),
('15:00 - 16:00'),
('16:00 - 17:00'),
('17:00 - 18:00'),
('18:00 - 19:00');

INSERT INTO temas (tema, año, dificultad, materia_id) VALUES
('Números enteros y fracciones', 1, 'baja', 1),
('Operaciones con polinomios', 1, 'media', 1),
('Ecuaciones de primer grado', 2, 'media', 1),
('Sistema de ecuaciones', 2, 'media', 1),
('Funciones lineales', 3, 'media', 1),
('Funciones cuadráticas', 3, 'alta', 1),
('Trigonometría', 4, 'alta', 1),
('Logaritmos', 5, 'alta', 1),
('Estadística y probabilidad', 5, 'media', 1),
('Derivadas básicas', 6, 'alta', 1),
('Cálculo de áreas bajo curvas', 6, 'alta', 1);

INSERT INTO temas (tema, año, dificultad, materia_id) VALUES
('Magnitudes físicas y unidades', 1, 'baja', 2),
('Movimiento rectilíneo uniforme', 2, 'media', 2),
('Movimiento uniformemente acelerado', 2, 'alta', 2),
('Leyes de Newton', 3, 'alta', 2),
('Trabajo y energía', 3, 'media', 2),
('Electricidad básica', 4, 'media', 2),
('Óptica: reflexión y refracción', 4, 'media', 2),
('Circuitos eléctricos', 5, 'alta', 2),
('Ondas y sonido', 5, 'media', 2),
('Electromagnetismo', 6, 'alta', 2),
('Física moderna: relatividad, átomos', 6, 'alta', 2);

INSERT INTO temas (tema, año, dificultad, materia_id) VALUES
('Estados de la materia', 1, 'baja', 3),
('Mezclas y soluciones', 1, 'media', 3),
('Estructura atómica', 2, 'media', 3),
('Tabla periódica', 2, 'media', 3),
('Enlaces químicos', 3, 'media', 3),
('Nomenclatura química inorgánica', 3, 'alta', 3),
('Reacciones químicas', 4, 'media', 3),
('Cálculos estequiométricos', 5, 'alta', 3),
('Equilibrio químico', 5, 'alta', 3),
('Ácidos y bases', 6, 'alta', 3),
('Redox y electroquímica', 6, 'alta', 3);

INSERT INTO temas (tema, año, dificultad, materia_id) VALUES
('Present simple & vocabulary', 1, 'baja', 4),
('Present continuous', 1, 'media', 4),
('Past simple', 2, 'media', 4),
('Past continuous', 2, 'media', 4),
('Future tenses', 3, 'media', 4),
('Modals (can, must, should)', 3, 'media', 4),
('Conditional sentences', 4, 'alta', 4),
('Passive voice', 4, 'alta', 4),
('Reported speech', 5, 'alta', 4),
('Reading comprehension', 5, 'media', 4),
('Writing formal emails', 6, 'alta', 4),
('Oral presentations', 6, 'alta', 4);








