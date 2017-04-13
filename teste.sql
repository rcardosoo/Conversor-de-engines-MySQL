SAVEPOINT backupBD;

call trocaEngines('nomeBanco', 'InnoDB');
call criarChaves('nomeBanco');

ROLLBACK TO backupBD;
