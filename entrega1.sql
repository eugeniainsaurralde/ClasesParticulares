create schema clases_particulares;
use clases_particulares;

CREATE TABLE `padres` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) NOT NULL,
  `Apellido` varchar(45) NOT NULL,
  `Celular` int NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `alumno` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `apellido` varchar(45) NOT NULL,
  `edad` int NOT NULL,
  `colegio` varchar(45) NOT NULL,
  `celular` int DEFAULT NULL,
  `padre_id` int NOT NULL,
  PRIMARY KEY (`id`,`padre_id`),
  KEY `fk_alumno_padre_idx` (`padre_id`),
  CONSTRAINT `fk_alumno_padre` FOREIGN KEY (`padre_id`) REFERENCES `padres` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `servicios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `servicio` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `materia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `materia` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `temas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tema` varchar(100) NOT NULL,
  `año` int NOT NULL,
  `dificultad` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `horarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `horarios` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `turnos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `horario_id` int NOT NULL,
  `materia_id` int NOT NULL,
  `tema_id` int NOT NULL,
  `servicio_id` int NOT NULL,
  PRIMARY KEY (`id`,`alumno_id`,`horario_id`,`materia_id`,`tema_id`,`servicio_id`),
  KEY `fk_turnos_alumno_idx` (`alumno_id`),
  KEY `fk_turnos_horario_idx` (`horario_id`),
  KEY `fk_turnos_materia_idx` (`materia_id`),
  KEY `fk_turnos_tema_idx` (`tema_id`),
  KEY `fk_turnos_servicio_idx` (`servicio_id`),
  CONSTRAINT `fk_turnos_alumno` FOREIGN KEY (`alumno_id`) REFERENCES `alumno` (`id`),
  CONSTRAINT `fk_turnos_horario` FOREIGN KEY (`horario_id`) REFERENCES `horarios` (`id`),
  CONSTRAINT `fk_turnos_materia` FOREIGN KEY (`materia_id`) REFERENCES `materia` (`id`),
  CONSTRAINT `fk_turnos_servicio` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`),
  CONSTRAINT `fk_turnos_tema` FOREIGN KEY (`tema_id`) REFERENCES `temas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `clases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `horario_id` int NOT NULL,
  `fecha` date NOT NULL,
  `turno1_id` int NOT NULL,
  `turno2_id` int NOT NULL,
  PRIMARY KEY (`id`,`horario_id`,`turno1_id`,`turno2_id`),
  KEY `fk_clases_turno1_idx` (`turno1_id`),
  KEY `fk_clases_turno2_idx` (`turno2_id`),
  CONSTRAINT `fk_clases_turno1` FOREIGN KEY (`turno1_id`) REFERENCES `turnos` (`id`),
  CONSTRAINT `fk_clases_turno2` FOREIGN KEY (`turno2_id`) REFERENCES `turnos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;