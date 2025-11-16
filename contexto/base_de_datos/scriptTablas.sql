-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema marnager
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `marnager` ;

-- -----------------------------------------------------
-- Schema marnager
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `marnager` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `marnager` ;

-- -----------------------------------------------------
-- Table `marnager`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marnager`.`usuario` ;

CREATE TABLE IF NOT EXISTS `marnager`.`usuario` (
  `idusuario` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(80) NOT NULL,
  `password` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`idusuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `marnager`.`gasto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marnager`.`gasto` ;

CREATE TABLE IF NOT EXISTS `marnager`.`gasto` (
  `idgasto` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NOT NULL,
  `subcategoria` VARCHAR(45) NULL,
  `fecha` DATE NOT NULL,
  `monto` DECIMAL NOT NULL,
  `usuario_idusuario` INT NOT NULL,
  PRIMARY KEY (`idgasto`),
  INDEX `fk_gasto_usuario_idx` (`usuario_idusuario` ASC) VISIBLE,
  CONSTRAINT `fk_gasto_usuario`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `marnager`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `marnager`.`ingreso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marnager`.`ingreso` ;

CREATE TABLE IF NOT EXISTS `marnager`.`ingreso` (
  `idingreso` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NOT NULL,
  `subcategoria` VARCHAR(45) NULL,
  `fecha` DATE NOT NULL,
  `monto` DECIMAL NOT NULL,
  `usuario_idusuario` INT NOT NULL,
  PRIMARY KEY (`idingreso`),
  INDEX `fk_ingreso_usuario1_idx` (`usuario_idusuario` ASC) VISIBLE,
  CONSTRAINT `fk_ingreso_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `marnager`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `marnager`.`ahorro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marnager`.`ahorro` ;

CREATE TABLE IF NOT EXISTS `marnager`.`ahorro` (
  `idahorro` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NOT NULL,
  `subcategoria` VARCHAR(45) NULL,
  `fecha` DATE NOT NULL,
  `monto` DECIMAL NOT NULL,
  `usuario_idusuario` INT NOT NULL,
  PRIMARY KEY (`idahorro`),
  INDEX `fk_ahorro_usuario1_idx` (`usuario_idusuario` ASC) VISIBLE,
  CONSTRAINT `fk_ahorro_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `marnager`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;