DELIMITER $$
CREATE PROCEDURE criaChaves (IN nomeBanco VARCHAR(70))
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE primaria VARCHAR(60);
DECLARE nomeTabela VARCHAR(60);
DECLARE tbEncontrada VARCHAR(60);
DECLARE nomeColuna VARCHAR(60);
DECLARE tabelas CURSOR FOR SELECT table_name FROM information_schema.tables
WHERE table_schema = nomeBanco AND table_name != 'campos';
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;

CREATE TABLE campos AS SELECT table_name, column_name, column_key FROM information_schema.columns
WHERE table_schema = nomeBanco;

OPEN tabelas;

varrerTabelas: LOOP

FETCH tabelas INTO nomeTabela;

IF done THEN
	CLOSE tabelas;
	LEAVE varrerTabelas;
END IF;

BLOCK2: BEGIN
DECLARE done2 INT DEFAULT FALSE;
DECLARE matchs CURSOR FOR SELECT table_name, column_name FROM campos WHERE
table_name != nomeTabela AND column_name IN (select column_name from campos where table_name = nomeTabela
                                                                              	AND column_key = 'PRI');
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2=TRUE;

OPEN matchs;

	encontros: LOOP

	FETCH matchs INTO tbEncontrada, nomeColuna;

	IF done2 THEN
    	CLOSE matchs;
    	LEAVE encontros;
	END IF;


	SET @s = CONCAT('ALTER TABLE ',tbEncontrada, ' ADD FOREIGN KEY (',nomeColuna,')
	REFERENCES ',nomeTabela,'(',nomeColuna,')');
	PREPARE stmt FROM @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    

	END LOOP encontros;
	END BLOCK2;
    
END LOOP varrerTabelas;

END $$
DELIMITER ;