-- -----------------------------------------------------
--
-- USER TASKS
--
-- -----------------------------------------------------

-- -----------------------------------------------------
-- SCENARIO
-- -----------------------------------------------------
-- The Edward Hopper House Art Center in Nyack, New York 
-- wants to mount a small retrospective of watercolors 
-- by the artist. They have asked the artist's estate to 
-- assist them in creating a proposed checklist and 
-- providing the exhibition history for the works where 
-- available.


-- -----------------------------------------------------
-- 1. Add new venue
-- -----------------------------------------------------
SET autocommit=0;
START TRANSACTION;
INSERT INTO address (`address_id`,`address_line_1`,`address_line_2`,`postal_code`,`city`,`province_or_state`,`alpha_2`) VALUES (NULL,'82 N Broadway',NULL,'10960','Nyack','NY','US');
INSERT INTO venue (`venue_id`,`name`,`type`,`address_id`,`notes`) VALUES (NULL,'Edward Hopper House Art Center','MUSEUM',LAST_INSERT_ID(),NULL);
COMMIT;

-- -----------------------------------------------------
-- 2. Add current director
-- -----------------------------------------------------
SET autocommit=0;
START TRANSACTION;
INSERT INTO person (`person_id`,`first_name`,`middle_name`,`last_name`,`suffix`,`display_name`,`birth_year`,`death_year`,`notes`) VALUES (NULL,'Jennifer',NULL,'Patton',NULL,'Jennifer Patton',NULL,NULL,NULL);
INSERT INTO director (`director_id`,`person_id`,`venue_id`,`start_date`,`end_date`,`notes`) VALUES (NULL,LAST_INSERT_ID(),2878,2016,NULL,NULL);
COMMIT;

-- -----------------------------------------------------
-- 3. Add minimal exhibition information
-- -----------------------------------------------------
INSERT INTO exhibition (`exhibition_id`,`venue_id`,`title`,`type`,`start_date`,`end_date`,`notes`) VALUES (NULL,2878,'TBD','SOLO',NULL,NULL,NULL);

-- -----------------------------------------------------
-- 4. Add exhibition curator
-- -----------------------------------------------------
SET autocommit=0;
START TRANSACTION;
INSERT INTO person (`person_id`,`first_name`,`middle_name`,`last_name`,`suffix`,`display_name`,`birth_year`,`death_year`,`notes`) VALUES (NULL,'Carole',NULL,'Perry',NULL,'Carole Perry',NULL,NULL,NULL);
INSERT INTO curator (`curator_id`,`person_id`,`exhibition_id`,`role`) VALUES (NULL,LAST_INSERT_ID(),62,'Artistic Director and Curator');
COMMIT;

-- -----------------------------------------------------
-- 5. Create working list of watercolors for exhibition 
-- planning
-- -----------------------------------------------------
CREATE VIEW watercolors (`ArtworkID`,`ArtworkTitle`,`DisplayYear`,`EarliestYear`,`LatestYear`,`ExhibitionCount`,`CollectionName`) AS SELECT ar.artwork_id, ar.title, ar.display_year, ar.earliest_year, ar.latest_year, COUNT(ch.artwork_id), COALESCE(ve.name,'Unknown') FROM artwork AS ar LEFT JOIN application AS ap ON ar.artwork_id = ap.artwork_id LEFT JOIN checklist AS ch ON ar.artwork_id=ch.artwork_id LEFT JOIN collection AS co ON ar.artwork_id=co.artwork_id LEFT JOIN venue AS ve ON co.venue_id=ve.venue_id WHERE ar.display_medium LIKE '%watercolor%' OR ap.material_id=61 GROUP BY ar.artwork_id, co.collection_id;

-- -----------------------------------------------------
-- 6. Delete duplicate artwork
-- -----------------------------------------------------
DELETE FROM artwork WHERE artwork_id=80;

-- -----------------------------------------------------
-- 7. View exhibition history for a given artwork
-- -----------------------------------------------------
SELECT ex.exhibition_id AS `ExhibitionId`, ex.title AS `ExhibitionTitle`, ex.start_date AS `ExhibitionStart`, ex.end_date AS `ExhibitionEnd`, COUNT(*) AS `ArtworkCount `FROM exhibition AS ex RIGHT JOIN checklist AS ch ON ex.exhibition_id=ch.exhibition_id WHERE ex.exhibition_id IN (SELECT ch.exhibition_id FROM checklist AS ch WHERE ch.artwork_id=28) GROUP BY ex.exhibition_id;

-- -----------------------------------------------------
-- 8. View artwork by subject
-- -----------------------------------------------------
SELECT `ArtworkID` FROM watercolors WHERE `ArtworkTitle` LIKE '%house%';

-- -----------------------------------------------------
-- 9. Update exhibition title and dates
-- -----------------------------------------------------
UPDATE exhibition SET title='Hopper\'s Houses',start_date='2018-06-08',end_date='2018-09-02' WHERE exhibition_id=62;

-- -----------------------------------------------------
-- 10. Grant research permissions to the curator
-- -----------------------------------------------------
CREATE USER 'carole_perry'@'localhost' IDENTIFIED BY 'hopper_research';
GRANT SELECT ON `studiolo`.* TO 'carole_perry'@'localhost';

-- -----------------------------------------------------
-- 11. Add timestamp to track checklist additions
-- -----------------------------------------------------
GRANT INSERT ON `studiolo`.`checklist` TO 'carole_perry'@'localhost';
ALTER TABLE checklist ADD COLUMN last_updated DATETIME;
CREATE TRIGGER updated_checklist BEFORE UPDATE ON checklist FOR EACH ROW SET NEW.last_updated=NOW();

-- -----------------------------------------------------
-- 12. Add artwork to checklist based on task 8
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
START TRANSACTION;
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,24,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,74,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,76,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,78,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,85,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,89,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,92,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,93,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,98,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,99,62,NULL,NOW());
INSERT INTO checklist (`checklist_id`,`artwork_id`,`exhibition_id`,`notes`,`last_updated`) VALUES (NULL,101,62,NULL,NOW());
COMMIT;