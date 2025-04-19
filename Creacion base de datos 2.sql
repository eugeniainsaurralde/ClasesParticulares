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
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `edad` INT NOT NULL,
  `colegio` VARCHAR(45) NOT NULL,
  `celular` VARCHAR(20) DEFAULT NULL,
  `padre_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`padre_id`) REFERENCES `padres`(`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `servicios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `servicio` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `materia` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `materia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `temas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tema` VARCHAR(100) NOT NULL,
  `año` INT NOT NULL,
  `dificultad` VARCHAR(100) NOT NULL,
  `materia_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`materia_id`) REFERENCES `materia`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `horarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `horarios` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `turnos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `alumno_id` INT NOT NULL,
  `materia_id` INT NOT NULL,
  `tema_id` INT NOT NULL,
  `servicio_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`alumno_id`) REFERENCES `alumno`(`id`),
  FOREIGN KEY (`materia_id`) REFERENCES `materia`(`id`),
  FOREIGN KEY (`tema_id`) REFERENCES `temas`(`id`),
  FOREIGN KEY (`servicio_id`) REFERENCES `servicios`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `clases` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `horario_id` INT NOT NULL,
  `fecha` DATE NOT NULL,
  `turno1_id` INT NOT NULL,
  `turno2_id` INT,
  `estado` ENUM('pendiente', 'realizada', 'cancelada') NOT NULL,
  `cupo` VARCHAR(45),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`horario_id`) REFERENCES `horarios`(`id`),
  FOREIGN KEY (`turno1_id`) REFERENCES `turnos`(`id`),
  FOREIGN KEY (`turno2_id`) REFERENCES `turnos`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `notas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `alumno_id` INT NOT NULL,
  `materia_id` INT NOT NULL,
  `tema_id` INT NOT NULL,
  `nota` DECIMAL(4,2),
  `estado` VARCHAR(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`alumno_id`) REFERENCES `alumno`(`id`),
  FOREIGN KEY (`materia_id`) REFERENCES `materia`(`id`),
  FOREIGN KEY (`tema_id`) REFERENCES `temas`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ganancias` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mes` VARCHAR(45),
  `valor_clase` INT NOT NULL,
  `cantidad_clases` INT NOT NULL,
  `cantidad_turnos` INT NOT NULL,
  `ganancia_mensual` DECIMAL(10,2),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; 


