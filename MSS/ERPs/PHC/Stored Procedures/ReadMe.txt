ScriptTables.sql -> Contém os scripts para criar as tabelas temporárias na base de dados do PHC;

ScriptTables(DROP).sql -> Apagar todas as tabelas temporárias da base de dados do PHC;

ScriptTriggers.sql -> Criar triggers de apoio à integração dos dados via Stored Procedures;

ScriptDuplicates.sql -> Criar stored procedures que limpam das tabelas temporárias registos duplicados;

ScriptIndexes.sql -> Instalação de chaves únicas nas tabelas temporárias para que não hajam registos duplicados(o ScriptTables inicial do MSS não criava o índice principal como UNIQUE);

Script Anonimização.sql -> Anonimizar campos com dados pessoais de clientes das tabelas temporárias do MSS (requer a existência da função SetString)