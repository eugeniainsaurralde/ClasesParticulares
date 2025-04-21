-- FUNCIONES personalizadas
DELIMITER //

CREATE FUNCTION obtener_promedio_alumno(apellido_alumno VARCHAR(45))
RETURNS DECIMAL(4,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE promedio DECIMAL(4,2);

  SELECT AVG(n.nota)
  INTO promedio
  FROM notas n
  JOIN alumno a ON a.id = n.alumno_id
  WHERE a.apellido LIKE CONCAT(apellido_alumno) AND n.nota IS NOT NULL;

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
DELIMITER ;

CREATE OR REPLACE VIEW contacto_con_padres AS
SELECT 
  a.apellido AS Apellido_alumno,
  a.nombre AS Nombre_alumno,
  p.apellido AS Apellido_padre,
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
ORDER BY dificultad;

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

CREATE OR REPLACE VIEW alumnos_desaprobados AS
SELECT 
  a.nombre AS Alumno,
  a.apellido AS Apellido,
  m.materia AS Materia,
  t.tema AS Tema,
  n.nota
FROM notas n
JOIN alumno a ON n.alumno_id = a.id
JOIN materia m on n.materia_id = m.id
JOIN temas t ON n.tema_id = t.id
WHERE n.nota < 7;

-- STORED PROCEDURES
DELIMITER //

CREATE PROCEDURE listar_clases_de_alumno(IN nombre_alumno VARCHAR(45))
BEGIN
	DECLARE alumno_en_turno1 INT;
    
 -- Verifico si el nombre del alumno esta registrado en el turno 1
  SELECT COUNT(*) INTO alumno_en_turno1
  FROM clases c
  JOIN turnos t ON t.id = c.turno1_id
  JOIN alumno a ON a.id = t.alumno_id
  WHERE a.nombre LIKE CONCAT('%', nombre_alumno, '%');
    
-- Si esta ejecuto la consulta para turno 1
  IF alumno_en_turno1 > 0 THEN
	  SELECT 
		a.nombre AS Nombre,
		a.apellido AS Apellido,
		c.fecha AS Fecha,
		h.horarios AS Horario,
		m.materia AS Materia,
		tm.tema AS Tema
	  FROM clases c
      JOIN horarios h ON h.id = c.horario_id
	  JOIN turnos t ON t.id = c.turno1_id 
	  JOIN alumno a ON a.id = t.alumno_id
	  JOIN temas tm ON tm.id = t.tema_id
	  JOIN materia m ON m.id = t.materia_id
	  WHERE a.nombre LIKE CONCAT('%', nombre_alumno, '%')
	  ORDER BY c.fecha;
-- Si no esta, ejecuto consulta para turno2
   ELSE 
	SELECT 
		c.fecha AS Fecha,
		h.horarios AS Horario,
		m.materia AS Materia,
		tm.tema AS Tema
	  FROM clases c
      JOIN horarios h ON h.id = c.horario_id
	  JOIN turnos t ON t.id = c.turno2_id 
	  JOIN alumno a ON a.id = t.alumno_id
	  JOIN temas tm ON tm.id = t.tema_id
	  JOIN materia m ON m.id = t.materia_id
	  WHERE a.nombre LIKE CONCAT('%', nombre_alumno, '%')
	  ORDER BY c.fecha;
   END IF;
END;

//

DELIMITER //

CREATE PROCEDURE buscar_padre_de_alumno(IN nombre_alumno VARCHAR(45))
BEGIN
  SELECT 
	a.apellido AS Apellido_alumno,
	a.nombre AS Nombre_alumno,
	p.apellido AS Apellido_padre,
	p.nombre AS Nombre_padre,
	p.celular AS Celular_padre
  FROM alumno a
  JOIN padres p ON p.id = a.padre_id
  WHERE a.nombre LIKE CONCAT('%', nombre_alumno, '%')
  ORDER BY a.apellido;
END;

//

-- TRIGGERS
DELIMITER //

CREATE TRIGGER crear_estado_nota
BEFORE INSERT ON notas
FOR EACH ROW
BEGIN
	 IF NEW.nota IS NOT NULL THEN
		  IF NEW.nota >= 7.00 THEN
			SET NEW.estado = 'Aprobado';
		  ELSE
			SET NEW.estado = 'Desaprobado';
		  END IF;
	 ELSE 
		SET NEW.estado = 'Aun no informa';
	 END IF;
END;
//

DELIMITER //

CREATE TRIGGER actualizar_estado_nota
BEFORE UPDATE ON notas
FOR EACH ROW
BEGIN
  IF NEW.nota IS NOT NULL THEN
    IF NEW.nota >= 7.00 THEN
      SET NEW.estado = 'Aprobado';
    ELSE
      SET NEW.estado = 'Desaprobado';
    END IF;
  ELSE 
    SET NEW.estado = 'Aun no informa';
  END IF;
END;
//

DELIMITER //

CREATE TRIGGER crear_cupo_clase
BEFORE INSERT ON clases
FOR EACH ROW
BEGIN
  IF NEW.turno2_id IS NULL or NEW.turno1_id IS NULL THEN
    SET NEW.cupo = 'Incompleto';
  ELSE
    SET NEW.cupo = 'Completo';
  END IF;
END;
//

DELIMITER //

CREATE TRIGGER actualizar_cupo_clase
BEFORE UPDATE ON clases
FOR EACH ROW
BEGIN
  IF NEW.turno2_id IS NULL or NEW.turno1_id IS NULL THEN
    SET NEW.cupo = 'Incompleto';
  ELSE
    SET NEW.cupo = 'Completo';
  END IF;
END;
//

DELIMITER //

CREATE TRIGGER realizar_contabilidad_mensual
BEFORE INSERT ON ganancias
FOR EACH ROW
BEGIN
	-- Declaracion de variables
	DECLARE mes VARCHAR(20);
	DECLARE clases_mes INT DEFAULT 0;
    DECLARE turnos_mes INT DEFAULT 0;
    DECLARE ganancia_mensual DECIMAL(10,2) DEFAULT 0;
    
    -- Aca se calcula automaticamente el mes corriente.
    SET mes = DATE_FORMAT(CURRENT_DATE, '%Y-%m');
    -- Aca se cuentan cuantas clases hubieron en el mes.
    SELECT 
		COUNT(*) INTO clases_mes
    FROM clases
    WHERE DATE_FORMAT(fecha, '%Y-%m') = mes
    AND estado = 'realizada';
    -- Aca se suman la cantidad de turnos totales del mes, si la clase estuvo completa se suman 2, sino 1.
    SELECT 
		SUM(CASE WHEN cupo = 'completo' THEN 2 ELSE 1 END) INTO turnos_mes
    FROM clases
    WHERE DATE_FORMAT(fecha, '%Y-%m') = mes
    AND estado = 'realizada';
	-- Aca se multiplica el valor de la clase por la cantidad de turnos y eso devuelve las ganancias del mes.
	SET ganancia_mensual = NEW.valor_clase * turnos_mes;
    
	-- Se cargan todos los campos calculados.
	SET NEW.mes = mes;
    SET NEW.cantidad_clases = clases_mes;
    SET NEW.cantidad_turnos = turnos_mes;
    SET NEW.ganancia_mensual = ganancia_mensual;
END;
//


-- INFORMES
DELIMITER //

CREATE PROCEDURE calcular_ganancias_mensuales(IN fecha_inicio VARCHAR(7), IN fecha_fin VARCHAR(7), IN valor_clase INT)
BEGIN
    DECLARE fecha_registrada DATE;
	DECLARE fecha_final DATE;
    DECLARE fecha_a_comparar VARCHAR(7);
    DECLARE clases_mes INT;
    DECLARE turnos_mes INT;
    DECLARE ganancia_mensual DECIMAL(10,2);

    -- Convertimos los textos que pasamos por parametro a fechas reales 
    SET fecha_registrada = STR_TO_DATE(CONCAT(fecha_inicio, '-01'), '%Y-%m-%d');
    SET fecha_final = STR_TO_DATE(CONCAT(fecha_fin, '-01'), '%Y-%m-%d');

	-- Realizamos un bucle para que se siga ejecutando la consulta hasta llegar a la fceha final que se quiere calcular
    WHILE fecha_registrada <= fecha_final DO
    
			-- Convertimos a string nuevamente para poder comparar en el formato deseado "año-mes"
			SET fecha_a_comparar = DATE_FORMAT(fecha_registrada, '%Y-%m');
            
			-- Contar clases en el mes
			SELECT IFNULL(COUNT(*), 0) INTO clases_mes
            FROM clases
            WHERE estado = 'realizada' AND DATE_FORMAT(fecha, '%Y-%m') =  fecha_a_comparar;
            
            -- Contar turnos del mes
            SELECT IFNULL(SUM(CASE WHEN cupo = 'completo' THEN 2 ELSE 1 END), 0) INTO turnos_mes
            FROM clases
            WHERE estado = 'realizada' AND DATE_FORMAT(fecha, '%Y-%m') =  fecha_a_comparar;

            -- Calcular ganancias
            SET ganancia_mensual = valor_clase * turnos_mes;

            -- Insertar valores
            INSERT INTO ganancias (mes, valor_clase, cantidad_clases, cantidad_turnos, ganancia_mensual)
            VALUES (DATE_FORMAT(fecha_registrada, '%Y-%m'), valor_clase, clases_mes, turnos_mes, ganancia_mensual);

        -- Aumentamos un mes
        SET fecha_registrada = DATE_ADD(fecha_registrada, INTERVAL 1 MONTH);
    END WHILE;
END //

CREATE OR REPLACE VIEW contar_alumnos_por_edad AS
SELECT 
    edad,
    COUNT(*) AS cantidad
FROM alumno
GROUP BY edad
ORDER BY edad;




