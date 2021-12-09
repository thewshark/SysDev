-- Script para anonimizar dados das tabelas temporárias de ToPC

-- Tabela Cobranças
UPDATE MSCBC SET 
		CBCGP1 = '', 
		CBCGP2 = '', 
		CBCGP3 = '', 
		CBCNOM = 'Nome ' + CBCCLI + ISNULL(REPLICATE('.', LEN(CBCNOM) - LEN(CBCCLI) - 5), ''), 
		CBCMOR = 'Morada ' + CBCCLI + ISNULL(REPLICATE('.', LEN(CBCMOR) - LEN(CBCCLI) - 7), ''), 
		CBCLOC = 'Localidade ' + CBCCLI + ISNULL(REPLICATE('.', LEN(CBCLOC) - LEN(CBCCLI) - 11), ''), 
		CBCCPT = '0000-000', 
		CBCNCT = '999999990', 
		CBCACL = dbo.SetString(CBCACL, 1, '', 7)

-- Tabela Clientes
UPDATE MSCLI SET 
		CLINOM = 'Nome ' + CLICOD + ISNULL(REPLICATE('.', LEN(CLINOM) - LEN(CLICOD) - 5), ''), 
		CLIMOR = 'Morada ' + CLICOD + ISNULL(REPLICATE('.', LEN(CLIMOR) - LEN(CLICOD) - 7), ''), 
		CLILOC = 'Localidade ' + CLICOD + ISNULL(REPLICATE('.', LEN(CLILOC) - LEN(CLICOD) - 11), ''), 
		CLICPT = '0000-000', 
		CLINCT = '999999990', 
		CLITEL = '', 
		CLITLM = '', 
		CLIFAX = '', 
		CLIZON = '', 
		CLIEML = '', 
		CLINM2 = '', 
		CLIMO2 = '', 
		CLINIB = '', 
		CLIGP1 = '', 
		CLIGP2 = '', 
		CLIGP3 = '', 
		CLICTP = '', 
		CLICCT = '', 
		CLIOBD = REPLICATE('.', LEN(CLIOBD)), 
		CLITCT = ''

-- Tabela Contactos
UPDATE MSCNT SET 
		CNTNOM = 'Nome ' + CNTCID + ISNULL(REPLICATE('.', LEN(CNTNOM) - LEN(CNTCID) - 5), ''), 
		CNTCRG = '', 
		CNTTEL = '', 
		CNTTLM = '', 
		CNTFAX = '', 
		CNTEML = '', 
		CNTHOB = '', 
		CNTANI = '', 
		CNTOBS = REPLICATE('.', LEN(CNTOBS))

-- Tabela Documentos
UPDATE MSDCC SET 
		DCCGP1 = '', 
		DCCGP2 = '', 
		DCCGP3 = '', 
		DCCNOM = 'Nome ' + DCCCLI + ISNULL(REPLICATE('.', LEN(DCCNOM) - LEN(DCCCLI) - 5), ''), 
		DCCMOR = 'Morada ' + DCCCLI + ISNULL(REPLICATE('.', LEN(DCCMOR) - LEN(DCCCLI) - 7), ''), 
		DCCLOC = 'Localidade ' + DCCCLI + ISNULL(REPLICATE('.', LEN(DCCLOC) - LEN(DCCCLI) - 11), ''), 
		DCCCPT = '0000-000', 
		DCCNCT = '999999990', 
		DCCENO = 'Nome Ent ' + DCCLCE + ISNULL(REPLICATE('.', LEN(DCCENO) - LEN(DCCLCE) - 9), ''), 
		DCCEMO = 'Morada Ent ' + DCCLCE + ISNULL(REPLICATE('.', LEN(DCCEMO) - LEN(DCCLCE) - 11), ''), 
		DCCELO = 'Localidade Ent ' + DCCLCE + ISNULL(REPLICATE('.', LEN(DCCEMO) - LEN(DCCLCE) - 15), ''), 
		DCCECP = '0000-000', 
		DCCACL = dbo.SetString(DCCACL, 8, '', 7)


-- Tabela Entregas
UPDATE MSDEC SET 
		DECNOM = 'Nome ' + DECCLI + ISNULL(REPLICATE('.', LEN(DECNOM) - LEN(DECCLI) - 5), ''), 
		DECMOR = 'Morada ' + DECCLI + ISNULL(REPLICATE('.', LEN(DECMOR) - LEN(DECCLI) - 7), ''), 
		DECLOC = 'Localidade ' + DECCLI + ISNULL(REPLICATE('.', LEN(DECLOC) - LEN(DECCLI) - 11), ''), 
		DECCPT = '0000-000', 
		DECNCT = '999999990', 
		DECENO = 'Nome Ent ' + DECLCE + ISNULL(REPLICATE('.', LEN(DECENO) - LEN(DECLCE) - 9), ''), 
		DECEMO = 'Morada Ent ' + DECLCE + ISNULL(REPLICATE('.', LEN(DECEMO) - LEN(DECLCE) - 11), ''), 
		DECELO = 'Localidade Ent ' + DECLCE + ISNULL(REPLICATE('.', LEN(DECELO) - LEN(DECLCE) - 15), ''), 
		DECECP = '0000-000'


-- Tabela Registo Levantamento/Entrega Equipamentos
UPDATE MSEQR SET 
		EQRGP1 = '', 
		EQRGP2 = '', 
		EQRGP3 = ''


-- Tabela Locais de Entrega
UPDATE MSLCE SET 
		LCENOM = 'Nome ' + LCELCE + ISNULL(REPLICATE('.', LEN(LCENOM) - LEN(LCELCE) - 5), ''), 
		LCEMOR = 'Morada ' + LCELCE + ISNULL(REPLICATE('.', LEN(LCEMOR) - LEN(LCELCE) - 7), ''), 
		LCELOC = 'Localidade ' + LCELCE + ISNULL(REPLICATE('.', LEN(LCELOC) - LEN(LCELCE) - 11), ''), 
		LCECPT = '0000-000', 
		LCECTC = '', 
		LCETEL = '', 
		LCEDSC = 'Descrição ' + LCELCE + ISNULL(REPLICATE('.', LEN(LCEDSC) - LEN(LCELCE) - 10), ''), 
		LCEGP1 = '', 
		LCEGP2 = '', 
		LCEGP3 = ''


-- Tabela de Logs de Coordenadas GPS
UPDATE MSLGG SET 
		LGGGP1 = '', 
		LGGGP2 = '', 
		LGGGP3 = ''


-- Tabela Mensagens
UPDATE MSMSG SET 
		MSGMSG = '', 
		MSGFRM = '', 
		MSGASS = '', 
		MSGTOE = ''


-- Tabela Recibos
UPDATE MSRCC SET 
		RCCGP1 = '', 
		RCCGP2 = '', 
		RCCGP3 = '', 
		RCCNOM = 'Nome ' + RCCCLI + ISNULL(REPLICATE('.', LEN(RCCNOM) - LEN(RCCCLI) - 5), ''), 
		RCCMOR = 'Morada ' + RCCCLI + ISNULL(REPLICATE('.', LEN(RCCMOR) - LEN(RCCCLI) - 7), ''), 
		RCCLOC = 'Localidade ' + RCCCLI + ISNULL(REPLICATE('.', LEN(RCCLOC) - LEN(RCCCLI) - 11), ''), 
		RCCCPT = '0000-000', 
		RCCNCT = '999999990', 
		RCCACL = dbo.SetString(RCCACL, 1, '', 7)


-- Tabela Dados de Concorrência
UPDATE MSRGC SET 
		RGCGP1 = '', 
		RGCGP2 = '', 
		RGCGP3 = ''


-- Tabela Serviços
UPDATE MSSRV SET 
		SRVGP1 = '', 
		SRVGP2 = '', 
		SRVGP3 = '', 
		SRVNOM = 'Nome ' + SRVCLI + ISNULL(REPLICATE('.', LEN(SRVNOM) - LEN(SRVCLI) - 5), ''), 
		SRVMOR = 'Morada ' + SRVCLI + ISNULL(REPLICATE('.', LEN(SRVMOR) - LEN(SRVCLI) - 7), ''), 
		SRVMO2 = 'Morada ' + SRVCLI + ISNULL(REPLICATE('.', LEN(SRVMO2) - LEN(SRVCLI) - 7), ''), 
		SRVLOC = 'Localidade ' + SRVCLI + ISNULL(REPLICATE('.', LEN(SRVLOC) - LEN(SRVCLI) - 11), ''), 
		SRVCPT = '0000-000', 
		SRVNCT = '999999990', 
		SRVDIA = '', 
		SRVCNM = '', 
		SRVCTL = '', 
		SRVCTM = '', 
		SRVCEM = '', 
		SRVRPT = REPLICATE('.', LEN(SRVRPT)), 
		SRVACL = dbo.SetString(SRVACL, 1, '', 7)


