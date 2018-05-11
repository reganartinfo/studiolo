-- -----------------------------------------------------
--
-- SCHEMA
--
-- -----------------------------------------------------
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Schema studiolo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `studiolo` DEFAULT CHARACTER SET utf8 ;
USE `studiolo` ;


-- -----------------------------------------------------
-- Table `studiolo`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`country` (
  `alpha_2` CHAR(2) NOT NULL,
  `country_name` VARCHAR(100) NULL DEFAULT NULL,
  `country_code` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`alpha_2`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`address` (
  `address_id` INT(11) NOT NULL AUTO_INCREMENT,
  `address_line_1` VARCHAR(255) NOT NULL,
  `address_line_2` VARCHAR(50) NULL DEFAULT NULL,
  `postal_code` VARCHAR(25) NULL DEFAULT NULL,
  `city` VARCHAR(50) NOT NULL,
  `province_or_state` VARCHAR(50) NULL DEFAULT NULL,
  `alpha_2` CHAR(2) NOT NULL,
  PRIMARY KEY (`address_id`),
  INDEX `address_ibfk_1` (`alpha_2` ASC),
  CONSTRAINT `address_ibfk_1`
    FOREIGN KEY (`alpha_2`)
    REFERENCES `studiolo`.`country` (`alpha_2`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`discipline`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`discipline` (
  `discipline_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `notes` VARCHAR(510) NULL DEFAULT NULL,
  PRIMARY KEY (`discipline_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`artwork`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`artwork` (
  `artwork_id` INT(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NULL DEFAULT 'Untitled',
  `display_year` VARCHAR(50) NULL DEFAULT NULL,
  `earliest_year` YEAR(4) NULL DEFAULT NULL,
  `latest_year` YEAR(4) NULL DEFAULT NULL,
  `display_medium` VARCHAR(255) NULL DEFAULT NULL,
  `display_dimension` VARCHAR(255) NULL DEFAULT NULL,
  `discipline_id` INT(11) NULL DEFAULT NULL,
  `copyright` VARCHAR(255) NULL DEFAULT NULL,
  `link_resource` VARCHAR(255) NULL DEFAULT NULL,
  `notes` VARCHAR(510) NULL DEFAULT NULL,
  PRIMARY KEY (`artwork_id`),
  INDEX `artwork_ibfk_1` (`discipline_id` ASC),
  CONSTRAINT `artwork_ibfk_1`
    FOREIGN KEY (`discipline_id`)
    REFERENCES `studiolo`.`discipline` (`discipline_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`material`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`material` (
  `material_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `notes` VARCHAR(510) NULL DEFAULT NULL,
  PRIMARY KEY (`material_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`application`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`application` (
  `application_id` INT(11) NOT NULL AUTO_INCREMENT,
  `artwork_id` INT(11) NOT NULL,
  `material_id` INT(11) NOT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`application_id`),
  INDEX `application_ibfk_1` (`artwork_id` ASC),
  INDEX `application_ibfk_2` (`material_id` ASC),
  CONSTRAINT `application_ibfk_1`
    FOREIGN KEY (`artwork_id`)
    REFERENCES `studiolo`.`artwork` (`artwork_id`),
  CONSTRAINT `application_ibfk_2`
    FOREIGN KEY (`material_id`)
    REFERENCES `studiolo`.`material` (`material_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`person` (
  `person_id` INT(11) NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NULL DEFAULT NULL,
  `middle_name` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `suffix` VARCHAR(50) NULL DEFAULT NULL,
  `display_name` VARCHAR(255) NULL DEFAULT NULL,
  `birth_year` INT(4) NULL DEFAULT NULL,
  `death_year` INT(4) NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`person_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`artist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`artist` (
  `artist_id` INT(11) NOT NULL AUTO_INCREMENT,
  `person_id` INT(11) NOT NULL,
  `artwork_id` INT(11) NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`artist_id`),
  INDEX `artist_ibfk_1` (`person_id` ASC),
  INDEX `artist_ibfk_2` (`artwork_id` ASC),
  CONSTRAINT `artist_ibfk_1`
    FOREIGN KEY (`person_id`)
    REFERENCES `studiolo`.`person` (`person_id`),
  CONSTRAINT `artist_ibfk_2`
    FOREIGN KEY (`artwork_id`)
    REFERENCES `studiolo`.`artwork` (`artwork_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`venue`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`venue` (
  `venue_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `type` VARCHAR(25) NOT NULL,
  `address_id` INT(11) NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`venue_id`),
  INDEX `venue_ibfk_1` (`address_id` ASC),
  CONSTRAINT `venue_ibfk_1`
    FOREIGN KEY (`address_id`)
    REFERENCES `studiolo`.`address` (`address_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`exhibition`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`exhibition` (
  `exhibition_id` INT(11) NOT NULL AUTO_INCREMENT,
  `venue_id` INT(11) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `type` VARCHAR(25) NOT NULL,
  `start_date` DATE NULL DEFAULT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`exhibition_id`),
  INDEX `exhibition_ibfk_1` (`venue_id` ASC),
  CONSTRAINT `exhibition_ibfk_1`
    FOREIGN KEY (`venue_id`)
    REFERENCES `studiolo`.`venue` (`venue_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`checklist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`checklist` (
  `checklist_id` INT(11) NOT NULL AUTO_INCREMENT,
  `artwork_id` INT(11) NOT NULL,
  `exhibition_id` INT(11) NOT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`checklist_id`),
  INDEX `checklist_ibfk_1` (`artwork_id` ASC),
  INDEX `checklist_ibfk_2` (`exhibition_id` ASC),
  CONSTRAINT `checklist_ibfk_1`
    FOREIGN KEY (`artwork_id`)
    REFERENCES `studiolo`.`artwork` (`artwork_id`),
  CONSTRAINT `checklist_ibfk_2`
    FOREIGN KEY (`exhibition_id`)
    REFERENCES `studiolo`.`exhibition` (`exhibition_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`curator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`curator` (
  `curator_id` INT(11) NOT NULL AUTO_INCREMENT,
  `person_id` INT(11) NOT NULL,
  `exhibition_id` INT(11) NOT NULL,
  `role` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`curator_id`),
  INDEX `curator_ibfk_1` (`person_id` ASC),
  INDEX `curator_ibfk_2` (`exhibition_id` ASC),
  CONSTRAINT `curator_ibfk_1`
    FOREIGN KEY (`person_id`)
    REFERENCES `studiolo`.`person` (`person_id`),
  CONSTRAINT `curator_ibfk_2`
    FOREIGN KEY (`exhibition_id`)
    REFERENCES `studiolo`.`exhibition` (`exhibition_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`director`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`director` (
  `director_id` INT(11) NOT NULL AUTO_INCREMENT,
  `person_id` INT(11) NOT NULL,
  `venue_id` INT(11) NOT NULL,
  `start_date` INT(4) NULL DEFAULT NULL,
  `end_date` INT(4) NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`director_id`),
  INDEX `director_ibfk_1` (`person_id` ASC),
  INDEX `director_ibfk_2` (`venue_id` ASC),
  CONSTRAINT `director_ibfk_1`
    FOREIGN KEY (`person_id`)
    REFERENCES `studiolo`.`person` (`person_id`),
  CONSTRAINT `director_ibfk_2`
    FOREIGN KEY (`venue_id`)
    REFERENCES `studiolo`.`venue` (`venue_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `studiolo`.`owner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `studiolo`.`collection` (
  `collection_id` INT(11) NOT NULL AUTO_INCREMENT,
  `venue_id` INT(11) NOT NULL,
  `artwork_id` INT(11) NOT NULL,
  `accession_num` VARCHAR(50) NULL DEFAULT NULL,
  `credit_line` VARCHAR(255) NULL DEFAULT NULL,
  `start_date` YEAR(4) NULL DEFAULT NULL,
  `end_date` YEAR(4) NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`collection_id`),
  INDEX `collection_ibfk_1` (`venue_id` ASC),
  INDEX `collection_ibfk_2` (`artwork_id` ASC),
  CONSTRAINT `collection_ibfk_1`
    FOREIGN KEY (`venue_id`)
    REFERENCES `studiolo`.`venue` (`venue_id`),
  CONSTRAINT `collection_ibfk_2`
    FOREIGN KEY (`artwork_id`)
    REFERENCES `studiolo`.`artwork` (`artwork_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;