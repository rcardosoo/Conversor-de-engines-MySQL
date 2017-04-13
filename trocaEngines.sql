DELIMITER $$
CREATE PROCEDURE trocaEngines (IN nomeBanco VARCHAR(70), IN nomeEngine VARCHAR(50))
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE nomeTabela VARCHAR(60);
DECLARE tabelas CURSOR FOR SELECT table_name FROM information_schema.tables
WHERE table_schema LIKE nomeBanco;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;

OPEN tabelas;

varrerTabelas: LOOP

FETCH tabelas INTO nomeTabela;
    
IF done THEN
	LEAVE varrerTabelas;
END IF;

    SET @s = CONCAT('ALTER TABLE ',nomeTabela, ' ENGINE = ', nomeEngine);
	PREPARE stmt FROM @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END LOOP varrerTabelas;

CLOSE tabelas;
END $$
DELIMITER ;
