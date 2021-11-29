# Stored Procedures para integração de documentos provenientes do MSS no ERP PHC

Compativel com o ERP PHC 25 / 26


Para efetuar a instalação terá de correr pela ordem abaixo (instalação nova):

ScriptTables.sql

ScriptTriggers.sql

ScriptIndexes.sql

SP_MSS50.sql


Para efetuar a instalação terá de correr pela ordem abaixo (atualização de uma instalação existente):

SP_MSS50(DROP).sql

ScriptTriggers.sql

ScriptIndexes.sql

SP_MSS50.sql
