-- FUNCIONES personalizadas
DELIMITER //

CREATE FUNCTION obtener_promedio_alumno(alumno_id_consulta INT)
RETURNS DECIMAL(4,2)
DETERMINISTIC
READS SQL DATA
BEGIN
   DECLARE promedio DECIMAL(4,2);

  SELECT AVG(nota)
  INTO promedio
  FROM notas
  WHERE alumno_id = alumno_id_consulta AND nota IS NOT NULL;

  RETURN promedio;
END;

//


DELIMITER //

CREATE FUNCTION contar_clases_por_fecha(fecha_consulta DATE)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE cantidad INT;

  SELECT COUNT(*) 
  INTO cantidad
  FROM clases
  WHERE fecha = fecha_consulta;

  RETURN cantidad;
END;

//


DELIMITER //

CREATE FUNCTION tema_mas_dado()
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE nombre_tema VARCHAR(100);

  SELECT tema
  INTO nombre_tema
  FROM temas t
  JOIN (
    SELECT tema_id, COUNT(*) AS cantidad
    FROM turnos
    GROUP BY tema_id
    ORDER BY cantidad DESC
    LIMIT 1
  ) AS tema_mas_dado
  ON t.id = tema_mas_dado.tema_id;

  RETURN nombre_tema;
END;

//

-- VISTAS

CREATE VIEW contacto_con_padres AS
SELECT 
  a.apellido AS Apellido_alumno,
  a.nombre AS Nombre_alumno,
  p.nombre AS Nombre_padre,
  p.celular AS Celular_padre
FROM alumno a
JOIN padres p ON a.padre_id = p.id
ORDER BY a.apellido asc;

CREATE OR REPLACE VIEW alumnos_por_colegio AS
SELECT 
colegio AS Colegio,
nombre AS Nombre,
apellido AS Apellido,
edad AS Edad
from alumno
ORDER BY colegio, edad;

CREATE VIEW temas_segun_dificultad AS
SELECT 
dificultad AS Dificultad, 
tema AS Tema
FROM temas
ORDER BY dificulta;

CREATE OR REPLACE VIEW temas_segun_materia_y_anio AS
SELECT 
m.materia AS Materia,
t.año AS Año,
t.tema AS Tema,
t.dificultad AS Dificultad
FROM temas t
JOIN materia m on m.id = t.materia_id
ORDER BY m.materia, t.año;

CREATE OR REPLACE VIEW clases_hoy_alumnos_y_temas AS
SELECT 
  c.fecha AS Fecha,
  h.horarios AS Hora,
  a1.nombre AS Alumno_1,
  a2.nombre AS Alumno_2,
  te1.tema AS Tema_alumno1,
  te2.tema AS Tema_alumno2
FROM clases c
JOIN horarios h ON c.horario_id = h.id
LEFT JOIN turnos t1 ON c.turno1_id = t1.id
LEFT JOIN turnos t2 ON c.turno2_id = t2.id
LEFT JOIN temas te1 ON t1.tema_id = te1.id
LEFT JOIN temas te2 ON t2.tema_id = te2.id
LEFT JOIN alumno a1 ON t1.alumno_id= a1.id
LEFT JOIN alumno a2 ON t2.alumno_id= a2.id
WHERE c.fecha = CURDATE()
-- WHERE c.fecha = "2025-01-27"
ORDER BY h.horarios;


