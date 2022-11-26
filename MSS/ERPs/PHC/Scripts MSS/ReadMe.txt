ScriptTables.sql -> Cont�m os scripts para criar as tabelas tempor�rias na base de dados do PHC;

ScriptTables(DROP).sql -> Apagar todas as tabelas tempor�rias da base de dados do PHC;

ScriptTriggers.sql -> Criar triggers de apoio � integra��o dos dados via Stored Procedures;

ScriptDuplicates.sql -> Criar stored procedures que limpam das tabelas tempor�rias registos duplicados;

ScriptIndexes.sql -> Instala��o de chaves �nicas nas tabelas tempor�rias para que n�o hajam registos duplicados(o ScriptTables inicial do MSS n�o criava o �ndice principal como UNIQUE);

Script Anonimiza��o.sql -> Anonimizar campos com dados pessoais de clientes das tabelas tempor�rias do MSS (requer a exist�ncia da fun��o SetString)