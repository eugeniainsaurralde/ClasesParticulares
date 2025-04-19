-- TESTER DE FUNCIONES

-- Test funcion obtener_promedio_alumno
select * from notas order by alumno_id;
select apellido from alumno where id=1;
select obtener_promedio_alumno('angulo');

-- Test contar_clases_por_fecha
select fecha from clases order by fecha desc;
select contar_clases_por_fecha("2025-03-18");
select contar_clases_por_fecha("2025-02-09");
select contar_clases_por_fecha("2024-04-10");

-- Test tema_mas_dado
SELECT tema_id, COUNT(*) AS cantidad
    FROM turnos
    GROUP BY tema_id
    ORDER BY cantidad DESC
    LIMIT 1;    
select tema from temas where id = 38;
select tema_mas_dado();

-- TESTER VISTAS
select * from CONTACTO_CON_PADRES;
select * from alumnos_por_colegio;
select * from temas_segun_dificultad;
select * from temas_segun_materia_y_anio;
select * from alumnos_desaprobados;

/* Debido a la utilidad de esta vista (ver las clases del dia actual) recomiendo modificar el codigo para visualizar los datos de la fecha "2025-01-27". 
En el script principal se encuentra detallada la linea que se debe cambiar, esto es solo a fin de testear la funcion ya que yo no se que dia se va a corregir el tp.*/
-- Vista
select * from clases_hoy_alumnos_y_temas;
-- Verificacion de datos de forma "manual" de una de las clases
select turno1_id, turno2_id, horario_id from clases where fecha = "2025-01-27";
select horarios from horarios where id= 6;
select alumno_id, tema_id from turnos where id = 51;
select nombre from alumno where id = 112;
select tema from temas where id= 31;
select alumno_id, tema_id from turnos where id = 117;
select nombre from alumno where id = 61;
select tema from temas where id= 26;

-- TESTER STORED PROCEDURES
SELECT * FROM alumno; 
CALL listar_clases_de_alumno('li');
CALL listar_clases_de_alumno('felicia');

CALL buscar_padre_de_alumno('feli');

-- TESTER TRIGGERS
select * from notas;
-- Me genera el estado "aprobado/desaprobado/no informa" automaticamente.
INSERT INTO notas (alumno_id, materia_id, tema_id, nota) VALUES (109, 1, 2, 8.5);
-- Me actualiza el estado "aprobado/desaprobado/no informa" automaticamente.
UPDATE notas SET nota = 5.0 WHERE id = 11;

select * from clases;
-- Me genera la descripcion del cupo "completo/incompleto" automaticamente.
INSERT INTO clases (horario_id, fecha, turno1_id, turno2_id, estado) VALUES (2, '2025-04-15', 5, 6, 'pendiente');
-- Me actualiza la descripcion del cupo "completo/incompleto" automaticamente.
UPDATE clases SET estado = 'realizada', turno2_id = NULL WHERE id = 185;

select * from ganancias;
INSERT INTO ganancias (valor_clase) VALUES (6500);


