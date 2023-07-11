--
-- SCRIPT DE INTEGRAÇÃO VERSÃO 4.0.0 
--

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_DateToString') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_DateToString
GO
CREATE FUNCTION u_Kapps_DateToString
(
	@Data DATETIME
)
RETURNS VARCHAR(16)
AS
BEGIN
	DECLARE @resultCode VARCHAR(16)
	DECLARE @Ano CHAR(4)
	DECLARE @Mes CHAR(2)
	DECLARE @Dia CHAR(2)

	SET @Ano = CAST(DATEPART(yyyy, @Data) AS CHAR(4))
	SET @Mes = CAST(DATEPART(mm, @Data) AS CHAR(2))
	SET @Dia = CAST(DATEPART(dd, @Data) AS CHAR(2))

	IF LEN(@Mes) = 1 
		SET @Mes = '0' + @Mes
	IF LEN(@Dia) = 1 
		SET @Dia = '0' + @Dia
	SET @resultCode = @Ano + @Mes + @Dia
	RETURN @resultCode
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_TimeToString') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_TimeToString 
GO
CREATE FUNCTION u_Kapps_TimeToString
(
	@pHora DATETIME
)
RETURNS VARCHAR(11)
AS
BEGIN
	DECLARE @resultCode VARCHAR(11)

	DECLARE @Hora CHAR(4)
	DECLARE @Minuto CHAR(2)
	DECLARE @Segundo CHAR(2)
	DECLARE @MiliSeg CHAR(3)
	
	SET @Hora = CAST(DATEPART(hh, @pHora) AS CHAR(4))
	SET @Minuto = CAST(DATEPART(mi, @pHora) AS CHAR(2))
	SET @Segundo = CAST(DATEPART(ss, @pHora) AS CHAR(2))
	SET @MiliSeg = CAST(DATEPART(ms, @pHora) AS CHAR(3))
	
	IF LEN(@Hora) = 1 
		SET @Hora = '0' + @Hora
	IF LEN(@Minuto) = 1 
		SET @Minuto = '0' + @Minuto
	IF LEN(@Segundo) = 1 
		SET @Segundo = '0' + @Segundo
	IF LEN(@MiliSeg) = 1 
		SET @MiliSeg = '00' + @MiliSeg
	ELSE IF len(@MiliSeg) = 2
		SET @MiliSeg = '0' + @MiliSeg
	SET @resultCode = RTRIM(LTRIM(@Hora)) + RTRIM(LTRIM(@Minuto)) + RTRIM(LTRIM(@Segundo)) + RTRIM(LTRIM(@MiliSeg))
	RETURN @resultCode
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_EurToEsc') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_EurToEsc 
GO
CREATE FUNCTION u_Kapps_EurToEsc 
(
	@ValEuro NUMERIC(19,6)
)
RETURNS NUMERIC(19,6)
AS
BEGIN
	DECLARE @resultCode NUMERIC(19,6)

	SET @resultCode = @ValEuro * 200.482
	RETURN @resultCode

END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Login') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Login 	-- Foi Eliminada
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps__ReconstroiSP_USR') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE SP_u_Kapps__ReconstroiSP_USR;
END
GO
CREATE PROCEDURE SP_u_Kapps__ReconstroiSP_USR
	@SPname varchar(50),
	@newSQL varchar(MAX),
	@ReplaceOldString1 varchar(MAX),
	@ReplaceNewString1 varchar(MAX),
	@ReplaceOldString2 varchar(MAX),
	@ReplaceNewString2 varchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @oldSQL varchar(MAX);
	DECLARE @execSQL varchar(MAX);

	SET @oldSQL = '';
	SET @oldSQL = (select (substring(sm.definition, charindex('SET NOCOUNT ON;', RTRIM(sm.definition)) + 16, LEN(sm.definition) - (charindex('SET NOCOUNT ON;', sm.definition) + 15)))
		from sys.sql_modules as sm JOIN sys.objects AS o ON sm.object_id = o.object_id where o.type = 'P'
		and OBJECT_NAME(sm.object_id) = @SPname);

	IF (@oldSQL <> '')
	BEGIN
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@SPname) AND type in (N'P', N'PC'))
		BEGIN
			DECLARE @sql nvarchar(MAX) = N'DROP PROCEDURE ' + QUOTENAME(@SPname) + N';';
			EXEC(@sql);
		END
		IF @ReplaceOldString1<>''
		BEGIN
			SET @oldSQL = REPLACE(@oldSQL, @ReplaceOldString1, @ReplaceNewString1)
		END
		IF @ReplaceOldString2<>''
		BEGIN
			SET @oldSQL = REPLACE(@oldSQL, @ReplaceOldString2, @ReplaceNewString2)
		END
						
		SET @execSQL = @newSQL + @oldSQL;
							
		EXEC (@execSQL);
	END
END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductPriceUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_ProductPriceUSR
	@REFERENCIA CHAR(40),		--	REFERENCIA DO ARTIGO
	@Lot VARCHAR(50),			--	LOTE DO ARTIGO
	@ARMAZEM VARCHAR(50),		--	ARMAZÉM
	@NRSERIE VARCHAR(50),		--	NÚMERO DE SÉRIE
	@QTD DECIMAL(20,7),			--	QUANTIDADE
	@CLIENTE VARCHAR(50),		--	CLIENTE
	@EVENTO INT					--	1(PICKING) OU 2(RECEPCAO) OU 3(PACKING) OU 4(OUTROS) OU 5(CONTAGEM) OU 6(CONSULTA STOCKS)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PRECOAUSAR CHAR(1)
	DECLARE @PRECO DECIMAL(20,7)
	  
	SET @PRECOAUSAR = 'N'  -- NO CASO DE SE UTILIZAR ESTE SP PARA DEVOLVER O PREÇO ESTA VARIÁVEL DEVERÁ RETONAR S EM VEZ DE N*/
	SET @PRECO = 0
	
	-- Colocar o código a partir deste ponto
	  

	SELECT @PRECOAUSAR, @PRECO
END
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductsUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_ProductsUSR
	@REFERENCIA CHAR(40)    -- REFERENCIA DO ARTIGO
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Price1 DECIMAL(20,7)
	DECLARE @Price2 DECIMAL(20,7)
	DECLARE @Price3 DECIMAL(20,7)
	DECLARE @Price4 DECIMAL(20,7)
	DECLARE @Price5 DECIMAL(20,7)

	DECLARE @Par1 VARCHAR(255)
	DECLARE @Par2 VARCHAR(255)
	DECLARE @Par3 VARCHAR(255)
	DECLARE @Par4 VARCHAR(255)
	DECLARE @Par5 VARCHAR(255)
	DECLARE @Par6 VARCHAR(255)
	DECLARE @Par7 VARCHAR(255)
	DECLARE @Par8 VARCHAR(255)
	DECLARE @Par9 VARCHAR(255)
	DECLARE @Par10 VARCHAR(255)

	SET @Price1 = 0
	SET @Price2 = 0
	SET @Price3 = 0
	SET @Price4 = 0
	SET @Price5 = 0

	SET @Par1 = ''
	SET @Par2 = ''
	SET @Par3 = ''
	SET @Par4 = ''
	SET @Par5 = ''
	SET @Par6 = ''
	SET @Par7 = ''
	SET @Par8 = ''
	SET @Par9 = ''
	SET @Par10 = ''


	-- Colocar o código a partir deste ponto


	SELECT @Price1, @Price2, @Price3, @Price4, @Price5, @Par1, @Par2, @Par3, @Par4, @Par5, @Par6, @Par7, @Par8, @Par9, @Par10
END
GO
SET NOEXEC OFF
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_BarCode') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_BarCode
GO
CREATE PROCEDURE SP_u_Kapps_BarCode
    @REF VARCHAR(40),
	@BARCODE VARCHAR(40),
	@QUANTITY INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @resultCode INT
	DECLARE @resultMsg NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @ERP VARCHAR(25)
	DECLARE @Description NVARCHAR(100)
	DECLARE @ststamp CHAR(25)

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
 
	DECLARE @bcstamp VARCHAR(30)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	WAITFOR DELAY '00:00:00.200'
	SET @resultCode = 0
	SET @resultMsg = ''
	SET @ErrorSeverity = 0
	SET @ErrorState = 0
	SET @DateTimeTmp = GETDATE()
				
	SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
	SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)

	SET @ousrinis = 'Syslog_' + @DateStr
	SET @usrinis = 'Syslog_' + @DateStr
 
	SET @ousrdata = @DateStr
	SET @usrdata = @DateStr
 
	SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
	SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				
	SET @bcstamp = 'Syslog_' + @DateStr + @TimeStr

	SELECT @ERP=ParameterValue FROM u_Kapps_Parameters WITH(NOLOCK) WHERE ParameterGroup='MAIN' and ParameterID = 'ERP' 

	BEGIN TRY
	BEGIN TRANSACTION
	  
		IF (upper(@ERP) = 'PHC') 
		BEGIN
			SELECT @ststamp = ststamp, @Description = design from st WITH(NOLOCK) where st.ref = @REF
		  
			INSERT INTO bc(bcstamp,ref,design,codigo,ststamp,defeito,qtt,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,marcada)
			SELECT @bcstamp,@REF,@Description,@BARCODE,@ststamp,0,@QUANTITY,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0
			WHERE NOT EXISTS (SELECT ref FROM bc WHERE ref = @REF AND codigo = @BARCODE)
		END
		ELSE IF (LEFT(upper(@ERP),9) = 'ETICADATA') -- ETICADATA
		BEGIN
			INSERT INTO Tbl_Gce_ArtigosCodigoBarras(strCodArtigo,strCodBarras, fltQuantidade)
			SELECT @REF, @BARCODE, @QUANTITY
			WHERE NOT EXISTS (SELECT strCodArtigo FROM Tbl_Gce_ArtigosCodigoBarras WHERE strCodArtigo = @REF AND strCodBarras = @BARCODE)
		END
		ELSE IF (upper(@ERP) = 'PRIMAVERA') -- PRIMAVERA
		BEGIN
			INSERT INTO ArtigoCodBarras (CodBarras, Artigo)
			SELECT @BARCODE, @REF
			WHERE NOT EXISTS (SELECT Artigo FROM ArtigoCodBarras WHERE Artigo = @REF AND CodBarras = @BARCODE)
		END
		ELSE IF (upper(@ERP) = 'SAGE_100C') -- SAGE 100C
		BEGIN
			INSERT INTO CBARRAS(CODIGO, Artigo, QTD)
			SELECT @BARCODE, @REF, @QUANTITY
			WHERE NOT EXISTS (SELECT @BARCODE FROM CBARRAS WHERE CODIGO = @BARCODE AND Artigo = @REF)
		END
		ELSE IF (upper(@ERP) = 'SAGE_50C') -- SAGE 50C
		BEGIN
			INSERT INTO POSIdentity (ItemID, POSItemID, Quantity)
			SELECT @REF, @BARCODE, @QUANTITY
			WHERE NOT EXISTS (SELECT ItemID FROM POSIdentity WHERE ItemID = @REF AND POSItemID = @BARCODE)
		END
		ELSE IF (upper(@ERP) = 'SENDYS') -- SENDYS
		BEGIN
			SELECT @resultCode, @resultMsg
		END
		ELSE IF (upper(@ERP) = 'PERSONALIZADO') --PERSONALIZADO
		BEGIN
			SELECT @resultCode, @resultMsg
		END
		ELSE 
		BEGIN
			RAISERROR ('O ERP não está definido, alterar a configuração do driver', 16,1)
		END

		COMMIT TRANSACTION
 
	END TRY
	BEGIN CATCH
		SELECT @resultMsg = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		ROLLBACK TRANSACTION
		SET @resultCode = 1
 
		RAISERROR (@resultMsg, @ErrorSeverity, @ErrorState)
	END CATCH

	SELECT @resultCode, @resultMsg
END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductStockUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_ProductStockUSR
	@REFERENCIA CHAR(40),		--	REFERENCIA DO ARTIGO
	@Lot VARCHAR(50),			--	LOTE DO ARTIGO
	@ARMAZEM VARCHAR(50),		--	ARMAZÉM
	@NRSERIE VARCHAR(50),		--	NÚMERO DE SÉRIE
	@EVENTO INT,				--	1(PICKING) OU 2(RECEPCAO) OU 3(PACKING) OU 4(OUTROS) OU 5(CONTAGEM) OU 6(CONSULTA DE STOCKS) OU 7(PALETES)
	@LOCALIZACAO VARCHAR(50),	--	LOCALIZACAO
	@LISTA INT = 0				--  0(RETORNA APENAS UMA LINHA @STOCKAUSAR, @STOCK, @STOCKDISPONIVEL)
								--  1(RETORNA LINHAS com CodigoArmazem, NomeArmazem, Stock, StockDisponivel AGRUPADA por CodigoArmazem e ORDENADA POR NomeArmazem)
								--  2(RETORNA LINHAS com Localizacao, Lote, Stock, StockDisponivel AGRUPADA por Localizacao, Lote ORDENADA POR Localizacao)
								--  3(RETORNA LINHAS com Localizacao, Lote, Stock, StockDisponivel AGRUPADA por Localizacao, Lote ORDENADA POR Lote)								  
								--  4(RETORNA LINHAS com Localizacao, Lote, Stock, Validade
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @STOCKAUSAR CHAR(1)
	DECLARE @STOCK DECIMAL(20,7)
	DECLARE @STOCKDISPONIVEL DECIMAL(20,7)
	  
	SET @STOCKAUSAR = 'N'	-- NO CASO DE SE UTILIZAR ESTE SP PARA DEVOLVER O STOCK ESTA VARIÁVEL DEVERÁ RETONAR S EM VEZ DE N
	SET @STOCK = 0
	SET @STOCKDISPONIVEL = 0

	-- Colocar o código a partir deste ponto
	  

	SELECT @STOCKAUSAR, @STOCK, @STOCKDISPONIVEL
END
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_DossiersUSR
	@DocTipo CHAR(5),					-- Tipo do documento da aplicação (DCO ou DSO)
	@InternalStampDoc NVARCHAR(50),		-- Stamp do documento
	@ndos VARCHAR(50),					-- Tipo de dossier de destino
	@fecha CHAR(5),						-- Se encerra o documento de origem
	@bostamp CHAR(25),					-- Stamp do documento criado
	@terminal CHAR(5),					-- Terminal que está a sincronizar	
	@ParameterGroup CHAR(100),			-- Processo que está a sincronizar
	@ExpeditionWarehouse NVARCHAR(50),	-- Armazem de expedição
	@ExpeditionLocation NVARCHAR(50),	-- Localização de expedição
	@resultCodeUSR varchar(3) OUTPUT,	-- Codigo erro
	@resultMsgUSR varchar(255) OUTPUT	-- Descrição erro								
AS
BEGIN
	SET NOCOUNT ON;


END
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersLinUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_DossiersLinUSR
	@DocTipo CHAR(5),				-- Tipo do documento da aplicação (DCO ou DSO)
	@InternalStampDoc NVARCHAR(50),	-- Stamp do documento
	@ndos VARCHAR(50),				-- Tipo de dossier de destino
	@fecha CHAR(5),					-- Se encerra o documento de origem
	@bostamp CHAR(25),				-- Stamp do documento criado
	@bistamp CHAR(25),				-- Stamp da linha
	@ref VARCHAR(18),				-- Código do artigo
	@Linha INT						-- Linha do documento criado na Kapp
AS
BEGIN
	SET NOCOUNT ON;


END
GO
SET NOEXEC OFF
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DocDossInternIVAs') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DocDossInternIVAs
GO
CREATE PROCEDURE SP_u_Kapps_DocDossInternIVAs
	@bostamp CHAR(25),
	@taxa1 NUMERIC(19,6),
	@ebo12_bins NUMERIC(19,6),
	@ebo12_iva NUMERIC(19,6),
	@taxa2 NUMERIC(19,6),
	@ebo22_bins NUMERIC(19,6),
	@ebo22_iva NUMERIC(19,6),
	@taxa3 NUMERIC(19,6),
	@ebo32_bins NUMERIC(19,6),
	@ebo32_iva NUMERIC(19,6),
	@taxa4 NUMERIC(19,6),
	@ebo42_bins NUMERIC(19,6),
	@ebo42_iva NUMERIC(19,6),
	@taxa5 NUMERIC(19,6),
	@ebo52_bins NUMERIC(19,6),
	@ebo52_iva NUMERIC(19,6),
	@taxa6 NUMERIC(19,6),
	@ebo62_bins NUMERIC(19,6),
	@ebo62_iva NUMERIC(19,6),
	@ousrinis VARCHAR(30),
	@ousrdata DATETIME,
	@ousrhora VARCHAR(8),
	@usrinis VARCHAR(30),
	@usrdata DATETIME,
	@usrhora VARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @botstamp CHAR(25)

	IF @ebo12_bins > 0  
	BEGIN
		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'Syslog_' + @DateStr + @TimeStr

		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, baseinc, evalor, valor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, 1, @taxa1, @ebo12_bins, dbo.u_Kapps_EurToEsc(@ebo12_bins), @ebo12_iva, dbo.u_Kapps_EurToEsc(@ebo12_iva), @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF @ebo22_bins > 0  
	BEGIN
		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'Syslog_' + @DateStr + @TimeStr

		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, baseinc, evalor, valor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, 2, @taxa2, @ebo22_bins, dbo.u_Kapps_EurToEsc(@ebo22_bins), @ebo22_iva, dbo.u_Kapps_EurToEsc(@ebo22_iva), @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF @ebo32_bins > 0  
	BEGIN
		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'Syslog_' + @DateStr + @TimeStr

		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, baseinc, evalor, valor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, 3, @taxa3, @ebo32_bins, dbo.u_Kapps_EurToEsc(@ebo32_bins), @ebo32_iva, dbo.u_Kapps_EurToEsc(@ebo32_iva), @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF @ebo42_bins > 0  
	BEGIN
		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'Syslog_' + @DateStr + @TimeStr

		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, baseinc, evalor, valor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, 4, @taxa4, @ebo42_bins, dbo.u_Kapps_EurToEsc(@ebo42_bins), @ebo42_iva, dbo.u_Kapps_EurToEsc(@ebo42_iva), @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END
	
	IF @ebo52_bins > 0  
	BEGIN
		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'Syslog_' + @DateStr + @TimeStr

		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, baseinc, evalor, valor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, 5, @taxa5, @ebo52_bins, dbo.u_Kapps_EurToEsc(@ebo52_bins), @ebo52_iva, dbo.u_Kapps_EurToEsc(@ebo52_iva), @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF @ebo62_bins > 0  
	BEGIN
		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'Syslog_' + @DateStr + @TimeStr

		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, baseinc, evalor, valor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, 6, @taxa6, @ebo62_bins, dbo.u_Kapps_EurToEsc(@ebo62_bins), @ebo62_iva, dbo.u_Kapps_EurToEsc(@ebo62_iva), @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Dossiers_ParametersUCabULin') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Dossiers_ParametersUCabULin
GO
CREATE PROCEDURE SP_u_Kapps_Dossiers_ParametersUCabULin
	@TipoProcesso VARCHAR(50),
	@ParameterGroup CHAR(100),
	@CAB_USER_FIELD1_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD2_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD3_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD4_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD5_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD6_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD7_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD8_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD9_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD10_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD11_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD12_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD13_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD14_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD15_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD1_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD2_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD3_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD4_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD5_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD6_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD7_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD8_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD9_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD10_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD11_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD12_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD13_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD14_TYPE VARCHAR(50)='' OUTPUT,
	@CAB_USER_FIELD15_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD1_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD2_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD3_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD4_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD5_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD6_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD7_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD8_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD9_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD10_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD11_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD12_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD13_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD14_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD15_INTEGRATION_NAME VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD1_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD2_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD3_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD4_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD5_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD6_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD7_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD8_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD9_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD10_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD11_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD12_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD13_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD14_TYPE VARCHAR(50)='' OUTPUT,
	@LIN_USER_FIELD15_TYPE VARCHAR(50)='' OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @ParameterID NVARCHAR(50)=''
	DECLARE @ParameterValue NVARCHAR(4000)=''

	BEGIN TRY

	DECLARE curKapps_Parameters CURSOR FAST_FORWARD FOR
	SELECT ParameterID, ParameterValue FROM u_Kapps_Parameters 
		WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND right(ParameterID,16) IN ('INTEGRATION_NAME') AND ParameterValue>''
		ORDER BY LEFT(ParameterID,4), ParameterOrder

	OPEN curKapps_Parameters

	FETCH NEXT FROM curKapps_Parameters INTO @ParameterID, @ParameterValue
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF @ParameterID='CAB_USER_FIELD1_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD1_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD1_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD1_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD2_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD2_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD2_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD2_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD3_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD3_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD3_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD3_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD4_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD4_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD4_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD4_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD5_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD5_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD5_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD5_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD6_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD6_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD6_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD6_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD7_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD7_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD7_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD7_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD8_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD8_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD8_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD8_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD9_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD9_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD9_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD9_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD10_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD10_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD10_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD10_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD11_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD11_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD11_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD11_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD12_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD12_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD12_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD12_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD13_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD13_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD13_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD13_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD14_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD14_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD14_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD14_TYPE'
		END
		ELSE IF @ParameterID='CAB_USER_FIELD15_INTEGRATION_NAME'
		BEGIN
			SET @CAB_USER_FIELD15_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @CAB_USER_FIELD15_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='CAB_USER_FIELD15_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD1_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD1_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD1_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD1_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD2_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD2_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD2_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD2_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD3_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD3_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD3_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD3_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD4_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD4_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD4_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD4_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD5_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD5_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD5_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD5_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD6_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD6_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD6_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD6_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD7_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD7_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD7_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD7_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD8_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD8_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD8_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD8_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD9_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD9_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD9_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD9_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD10_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD10_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD10_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD10_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD11_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD11_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD11_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD11_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD12_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD12_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD12_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD12_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD13_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD13_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD13_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD13_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD14_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD14_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD14_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD14_TYPE'
		END
		ELSE IF @ParameterID='LIN_USER_FIELD15_INTEGRATION_NAME'
		BEGIN
			SET @LIN_USER_FIELD15_INTEGRATION_NAME = ', ['+ @ParameterValue + ']'
			SELECT @LIN_USER_FIELD15_TYPE=ParameterValue FROM u_Kapps_Parameters WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='LIN_USER_FIELD15_TYPE'
		END

		FETCH NEXT FROM curKapps_Parameters INTO @ParameterID, @ParameterValue
	END

	CLOSE curKapps_Parameters
	DEALLOCATE curKapps_Parameters


	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH

END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Dossiers') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Dossiers
GO
CREATE PROCEDURE SP_u_Kapps_Dossiers
	@DocTipo CHAR(5),
	@InStampDoc NVARCHAR(2000),
	@ndos VARCHAR(50),
	@fecha CHAR(5),
	@Terminal CHAR(5),
	@integra CHAR(1),
	@ParameterGroup CHAR(100),
	@InUserIntegracao VARCHAR(50),
	@ExpeditionWarehouse NVARCHAR(50),
	@ExpeditionLocation NVARCHAR(50)
AS
BEGIN
	--
	-- Esta SP é executada para integrar os documentos apenas para o ERP PHC ou ERP Personalizado
	--
	SET NOCOUNT ON;

	DECLARE @resultCode VARCHAR(3)
	DECLARE @resultMsg VARCHAR(255)
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
 
	DECLARE @DateTimeTmp_SN DATETIME
	DECLARE @DateStr_SN CHAR(8)
	DECLARE @TimeStr_SN CHAR(11)
	DECLARE @NewStamp_BOMA CHAR(25)
	DECLARE @recnum_boma INT
	DECLARE @DateTimeTmp_Ma DATETIME
	DECLARE @DateStr_Ma CHAR(8)
	DECLARE @TimeStr_Ma CHAR(11)
	DECLARE @NewStamp_Ma CHAR(25)
	DECLARE @StampMaCount AS INT
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @oldStampBo NVARCHAR(50)
	DECLARE @oldStampBi NVARCHAR(50)
	DECLARE @oldRef NVARCHAR(50)
	DECLARE @oldLot NVARCHAR(50)
	DECLARE @oldWarehouse NVARCHAR(50)
	DECLARE @oldWarehouseOut NVARCHAR(50)
	DECLARE @oldSerial NVARCHAR(50)
	DECLARE @QtyFinal DECIMAL(18, 3)
	DECLARE @StampFinalLinha NVARCHAR(50)
	DECLARE @lordemFinal INT
 
	DECLARE @StampLin NVARCHAR(50)
	DECLARE @StampBo NVARCHAR(50)
	DECLARE @StampBi NVARCHAR(50)
	DECLARE @Ref NVARCHAR(50)
	DECLARE @Lot NVARCHAR(50)
	DECLARE @Warehouse NVARCHAR(50)
	DECLARE @WarehouseOut NVARCHAR(50)
	DECLARE @Serial NVARCHAR(50)
	DECLARE @Description NVARCHAR(100)
	DECLARE @Qty DECIMAL(18, 3)
	DECLARE @Qty2 DECIMAL(18, 3)
	DECLARE @QtyUM NVARCHAR(25)
	DECLARE @Qty2UM NVARCHAR(25)

	DECLARE @UserID NVARCHAR(50)
	DECLARE @MovDate NVARCHAR(8)
	DECLARE @MovTime NVARCHAR(6)
	DECLARE @Status NVARCHAR(50)
	DECLARE @DocType NVARCHAR(50)
	DECLARE @DocNumber NVARCHAR(50)
	DECLARE @Integrada NVARCHAR(50)
	DECLARE @DataIntegracao NVARCHAR(8)
	DECLARE @HoraIntegracao NVARCHAR(6)
	DECLARE @UserIntegracao VARCHAR(50)
	DECLARE @UserIntegracaoLin NVARCHAR(50)
	DECLARE @Process NVARCHAR(50)
	DECLARE @Validade NVARCHAR(50)
	DECLARE @Location NVARCHAR(50)
	DECLARE @ExternalDocNum NVARCHAR(50)
	DECLARE @EntityType NVARCHAR(50)
	DECLARE @EntityNumber NVARCHAR(50)
	DECLARE @InternalStampDoc NVARCHAR(50)
	DECLARE @IsFinalProductBOM BIT

	DECLARE @NewBoStamp CHAR(25)
	DECLARE @sestamp CHAR(25)
	DECLARE @boano INT
 
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
 
	DECLARE @EntTipo VARCHAR(20)
	DECLARE @EntZona VARCHAR(13)
	DECLARE @EntSegmento VARCHAR(25)
	DECLARE @EntTelef VARCHAR(60)
	DECLARE @nome VARCHAR(55)
	DECLARE @EntNome VARCHAR(55)
	DECLARE @EntMorada VARCHAR(55)
	DECLARE @EntLocal VARCHAR(43)
	DECLARE @EntCPostal VARCHAR(45)
	DECLARE @EntNCont VARCHAR(18)
	DECLARE @EntPais INT
	DECLARE @EntMoeda VARCHAR(11)
	DECLARE @EntLocTesoura VARCHAR(50)
	DECLARE @EntContado INT
	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)
	DECLARE @nmdos VARCHAR(60)
	DECLARE @lordem INT
	DECLARE @obrano INT
	DECLARE @DestinationDocType VARCHAR(60)
	DECLARE @VatNumber NVARCHAR(50)
	DECLARE @UnitPrice NUMERIC(18, 6)

	DECLARE @EntContacto VARCHAR(30)
	DECLARE @EntEmail VARCHAR(100)

	DECLARE @totaldeb NUMERIC(19, 6)
	DECLARE @etotaldeb NUMERIC(19, 6)
	DECLARE @etotal NUMERIC(19, 6)
	DECLARE @ebo_1tvall NUMERIC(19, 6)
	DECLARE @ebo_totp1 NUMERIC(19, 6)
	DECLARE @ebo_totp2 NUMERIC(19, 6)
	DECLARE @edescc NUMERIC(19, 6)
	DECLARE @taxa NUMERIC(19, 6)
	DECLARE @iva NUMERIC(5, 2)
	DECLARE @tabiva INT
 
	DECLARE @ivaincl INT
	DECLARE @edebito NUMERIC(19, 6)
	DECLARE @debito NUMERIC(19, 6)
	DECLARE @edebitoori NUMERIC(19, 6)
	DECLARE @debitoori NUMERIC(19, 6)

	DECLARE @eslvu NUMERIC(19, 6)
	DECLARE @slvu NUMERIC(19, 6)
	DECLARE @ettdeb NUMERIC(19, 6)
	DECLARE @ttdeb NUMERIC(19, 6)
	DECLARE @esltt NUMERIC(19, 6)
	DECLARE @sltt NUMERIC(19, 6)

	DECLARE @custoind NUMERIC(19, 6)
	DECLARE @ecustoind NUMERIC(19, 6)
	DECLARE @obs VARCHAR(67)

	DECLARE @ecusto NUMERIC(19, 6)
	DECLARE @tpdesc VARCHAR(55)

	DECLARE @epu NUMERIC(19, 6)
	DECLARE @pu NUMERIC(19, 6)
	DECLARE @prorc NUMERIC(19, 6)
	DECLARE @eprorc NUMERIC(19, 6)
	DECLARE @pcusto NUMERIC(19, 6)
	DECLARE @epcusto NUMERIC(19, 6)
	DECLARE @armazem NUMERIC(5, 0)
	DECLARE @lobs VARCHAR(45)
	DECLARE @desconto NUMERIC(6, 2)
	DECLARE @desc2 NUMERIC(6, 2)
	DECLARE @desc3 NUMERIC(6, 2)
	DECLARE @desc4 NUMERIC(6, 2)
	DECLARE @desc5 NUMERIC(6, 2)
	DECLARE @desc6 NUMERIC(6, 2)
	DECLARE @VALDESC NUMERIC(6, 2)
	DECLARE @eVALDESC NUMERIC(6, 2)
	DECLARE @usalote INT
	DECLARE @UsaNumSerie INT
	DECLARE @estab INT
	DECLARE @OriLineNumber INT

	DECLARE @ERP VARCHAR(25)
	DECLARE @sTipo CHAR(1)
	DECLARE @usr1 VARCHAR(20)
	DECLARE @usr2 VARCHAR(20)
	DECLARE @usr3 VARCHAR(35)
	DECLARE @usr4 VARCHAR(20)
	DECLARE @usr5 VARCHAR(120)
	DECLARE @usr6 VARCHAR(30)
	DECLARE @unidade VARCHAR(4)
	DECLARE @bi2local VARCHAR(43)
	DECLARE @bi2Morada VARCHAR(55)
	DECLARE @bi2CodPost VARCHAR(45)
	DECLARE @seccao VARCHAR(15)

	DECLARE @NumSerie VARCHAR(50)
	DECLARE @bdemp VARCHAR(2)
	
	DECLARE @iva1 NUMERIC(6, 2)
	DECLARE @ebo12_bins NUMERIC(19, 6)
	DECLARE @ebo12_iva NUMERIC(19, 6)

	DECLARE @iva2 NUMERIC(6, 2)
	DECLARE @ebo22_bins NUMERIC(19, 6)
	DECLARE @ebo22_iva NUMERIC(19, 6)

	DECLARE @iva3 NUMERIC(6, 2)
	DECLARE @ebo32_bins NUMERIC(19, 6)
	DECLARE @ebo32_iva NUMERIC(19, 6)

	DECLARE @iva4 NUMERIC(6, 2)
	DECLARE @ebo42_bins NUMERIC(19, 6)
	DECLARE @ebo42_iva NUMERIC(19, 6)

	DECLARE @iva5 NUMERIC(6, 2)
	DECLARE @ebo52_bins NUMERIC(19, 6)
	DECLARE @ebo52_iva NUMERIC(19, 6)

	DECLARE @iva6 NUMERIC(6, 2)
	DECLARE @ebo62_bins NUMERIC(19, 6)
	DECLARE @ebo62_iva NUMERIC(19, 6)
	DECLARE @SemIva NUMERIC(19, 6)
	DECLARE @predec INT
	DECLARE @Update INT

	DECLARE @NEWnmdos VARCHAR(100)
	DECLARE @NEWobrano INT
	DECLARE @ArtigodeServicos BIT
	
	DECLARE @local VARCHAR(43)
	DECLARE @morada VARCHAR(55)
	DECLARE @codpost VARCHAR(45)
	DECLARE @familia VARCHAR(18)
	DECLARE @zona VARCHAR(20)
	DECLARE @carga VARCHAR(60)
	DECLARE @descarga VARCHAR(60)
	DECLARE @segmento VARCHAR(25)
	DECLARE @bofRef VARCHAR(20)
	DECLARE @APPCODE VARCHAR(6)
	DECLARE @Peso NUMERIC(18, 3)
	DECLARE @PesoFinal NUMERIC(18, 3)
	DECLARE @UseWeight BIT
	DECLARE @rescli BIT
	DECLARE @resfor BIT
	DECLARE @ocupacao INT
	DECLARE @TipoProcesso VARCHAR(50)
	DECLARE @ManterNumeracao BIT

	DECLARE @ParameterID NVARCHAR(50) = ''
	DECLARE @ParameterValue NVARCHAR(4000) = ''
	DECLARE @CAB_USER_FIELD1_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD2_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD3_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD4_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD5_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD6_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD7_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD8_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD9_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD10_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD11_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD12_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD13_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD14_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD15_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD1_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD2_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD3_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD4_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD5_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD6_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD7_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD8_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD9_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD10_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD11_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD12_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD13_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD14_TYPE VARCHAR(50) = ''
	DECLARE @CAB_USER_FIELD15_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD1_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD2_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD3_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD4_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD5_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD6_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD7_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD8_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD9_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD10_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD11_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD12_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD13_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD14_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD15_INTEGRATION_NAME VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD1_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD2_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD3_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD4_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD5_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD6_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD7_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD8_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD9_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD10_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD11_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD12_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD13_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD14_TYPE VARCHAR(50) = ''
	DECLARE @LIN_USER_FIELD15_TYPE VARCHAR(50) = ''
	DECLARE @CabUF1 VARCHAR(MAX) = ''
	DECLARE @CabUF2 VARCHAR(MAX) = ''
	DECLARE @CabUF3 VARCHAR(MAX) = ''
	DECLARE @CabUF4 VARCHAR(MAX) = ''
	DECLARE @CabUF5 VARCHAR(MAX) = ''
	DECLARE @CabUF6 VARCHAR(MAX) = ''
	DECLARE @CabUF7 VARCHAR(MAX) = ''
	DECLARE @CabUF8 VARCHAR(MAX) = ''
	DECLARE @CabUF9 VARCHAR(MAX) = ''
	DECLARE @CabUF10 VARCHAR(MAX) = ''
	DECLARE @CabUF11 VARCHAR(MAX) = ''
	DECLARE @CabUF12 VARCHAR(MAX) = ''
	DECLARE @CabUF13 VARCHAR(MAX) = ''
	DECLARE @CabUF14 VARCHAR(MAX) = ''
	DECLARE @CabUF15 VARCHAR(MAX) = ''
	DECLARE @LinUF1 VARCHAR(MAX) = ''
	DECLARE @LinUF2 VARCHAR(MAX) = ''
	DECLARE @LinUF3 VARCHAR(MAX) = ''
	DECLARE @LinUF4 VARCHAR(MAX) = ''
	DECLARE @LinUF5 VARCHAR(MAX) = ''
	DECLARE @LinUF6 VARCHAR(MAX) = ''
	DECLARE @LinUF7 VARCHAR(MAX) = ''
	DECLARE @LinUF8 VARCHAR(MAX) = ''
	DECLARE @LinUF9 VARCHAR(MAX) = ''
	DECLARE @LinUF10 VARCHAR(MAX) = ''
	DECLARE @LinUF11 VARCHAR(MAX) = ''
	DECLARE @LinUF12 VARCHAR(MAX) = ''
	DECLARE @LinUF13 VARCHAR(MAX) = ''
	DECLARE @LinUF14 VARCHAR(MAX) = ''
	DECLARE @LinUF15 VARCHAR(MAX) = ''

	DECLARE @InsertQry NVARCHAR(MAX)
	DECLARE @UpdateQry NVARCHAR(MAX)

	DECLARE @InsertNS_ma NVARCHAR(MAX)
	DECLARE @InsertNS_boma NVARCHAR(MAX)
	DECLARE @Serials_Join NVARCHAR(MAX)

	DECLARE @LocationOUT NVARCHAR(50)
	DECLARE @SSCC NVARCHAR(50)
	DECLARE @oldLocation NVARCHAR(50)
	DECLARE @oldLocationOut NVARCHAR(50)
	DECLARE @CustomerNumber NVARCHAR(50)
	DECLARE @IsCustomerInternal BIT
	DECLARE @tmpNDos NVARCHAR(MAX)
	DECLARE @tmpDTA_ORIGIN VARCHAR(50)
	DECLARE @resultLot BIT

	SET @InsertNS_ma = ''
	SET @InsertNS_boma = ''
	SET @Serials_Join = ''
	
	SET @tmpNDos = @ndos
	SET @tmpDTA_ORIGIN ='0'

	SET @InsertNS_ma = ''
	SET @InsertNS_boma = ''
	SET @Serials_Join = ''

	SET @ArtigodeServicos = 0
	SET @resultCode = 'NOK'
	SET @resultMsg = 'Não foi gerado nenhum documento'
	SET @NewBoStamp = ''
	SET @lordem = 0
	SET @ivaincl = 0
	SET @rescli = 0
	SET @resfor = 0
	SET @ManterNumeracao = 1
	SET @TipoProcesso = ''
	SET @WarehouseOUT = ''
	SET @LocationOUT = ''
	SET @oldLocation = ''
	SET @oldLocationOut = ''
	SET @CustomerNumber = ''
	SET @IsCustomerInternal = 0

	SET @ErrorSeverity = 16
	SET @ErrorState = 1

	BEGIN TRY
		BEGIN TRANSACTION

		SELECT @ERP = COALESCE(ParameterValue, '')
		FROM u_Kapps_Parameters WITH (NOLOCK)
		WHERE ParameterGroup = 'MAIN' AND ParameterId = 'ERP'

		SELECT @TipoProcesso = UPPER(TypeID)
		FROM u_Kapps_Processes 
		WHERE ProcessID = @ParameterGroup

		IF @TipoProcesso = 'PRODUCTION'
		BEGIN
			SELECT @tmpDTA_ORIGIN = ParameterValue
			FROM u_Kapps_Parameters
			WHERE ParameterType=@TipoProcesso AND ParameterGroup=@ParameterGroup AND ParameterID='DTA_ORIGIN'
		END

		EXECUTE SP_u_Kapps_Dossiers_ParametersUCabULin  @TipoProcesso, @ParameterGroup
			,@CAB_USER_FIELD1_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD2_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD3_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD4_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD5_INTEGRATION_NAME OUTPUT
			,@CAB_USER_FIELD6_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD7_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD8_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD9_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD10_INTEGRATION_NAME OUTPUT
			,@CAB_USER_FIELD11_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD12_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD13_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD14_INTEGRATION_NAME OUTPUT, @CAB_USER_FIELD15_INTEGRATION_NAME OUTPUT
			,@CAB_USER_FIELD1_TYPE OUTPUT, @CAB_USER_FIELD2_TYPE OUTPUT, @CAB_USER_FIELD3_TYPE OUTPUT, @CAB_USER_FIELD4_TYPE OUTPUT, @CAB_USER_FIELD5_TYPE OUTPUT
			,@CAB_USER_FIELD6_TYPE OUTPUT, @CAB_USER_FIELD7_TYPE OUTPUT, @CAB_USER_FIELD8_TYPE OUTPUT, @CAB_USER_FIELD9_TYPE OUTPUT, @CAB_USER_FIELD10_TYPE OUTPUT
			,@CAB_USER_FIELD11_TYPE OUTPUT, @CAB_USER_FIELD12_TYPE OUTPUT, @CAB_USER_FIELD13_TYPE OUTPUT, @CAB_USER_FIELD14_TYPE OUTPUT, @CAB_USER_FIELD15_TYPE OUTPUT
			,@LIN_USER_FIELD1_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD2_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD3_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD4_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD5_INTEGRATION_NAME OUTPUT
			,@LIN_USER_FIELD6_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD7_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD8_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD9_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD10_INTEGRATION_NAME OUTPUT
			,@LIN_USER_FIELD11_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD12_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD13_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD14_INTEGRATION_NAME OUTPUT, @LIN_USER_FIELD15_INTEGRATION_NAME OUTPUT
			,@LIN_USER_FIELD1_TYPE OUTPUT, @LIN_USER_FIELD2_TYPE OUTPUT, @LIN_USER_FIELD3_TYPE OUTPUT, @LIN_USER_FIELD4_TYPE OUTPUT, @LIN_USER_FIELD5_TYPE OUTPUT
			,@LIN_USER_FIELD6_TYPE OUTPUT, @LIN_USER_FIELD7_TYPE OUTPUT, @LIN_USER_FIELD8_TYPE OUTPUT, @LIN_USER_FIELD9_TYPE OUTPUT, @LIN_USER_FIELD10_TYPE OUTPUT
			,@LIN_USER_FIELD11_TYPE OUTPUT, @LIN_USER_FIELD12_TYPE OUTPUT, @LIN_USER_FIELD13_TYPE OUTPUT, @LIN_USER_FIELD14_TYPE OUTPUT, @LIN_USER_FIELD15_TYPE OUTPUT

		IF (@integra = '0') AND (UPPER(@DocTipo) <> 'DSO') AND (UPPER(@DocTipo) <> 'DCO')
		BEGIN
			SET @resultCode = 'NOK'
			SET @resultMsg = 'O tipo de documento não é valido'
		END
		ELSE IF (@integra = '0')
		BEGIN
			IF @TipoProcesso in ('PICKTRANSF', 'TRANSF')
			BEGIN
				SELECT TOP 1 @WarehouseOUT = WarehouseOut, @LocationOUT = LocationOut
				FROM u_Kapps_DossierLin
				WHERE StampBO = @InStampDoc AND Integrada = 'N' AND Status = 'A'

				UPDATE u_Kapps_PackingHeader
				SET CurrentWarehouse = @WarehouseOut, CurrentLocation = @LocationOut
				WHERE SSCC IN (
						SELECT SSCC
						FROM u_Kapps_DossierLin
						WHERE StampBO = @InStampDoc AND Integrada = 'N' AND Status = 'A' AND RTRIM(LTRIM(SSCC)) <> ''
						)
				
				IF @@ERROR <> 0
				BEGIN
					SET @ErrorMessage = 'Erro ao atualizar PackingHeader!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)		
				END
			END

			IF (@DocTipo = 'DSO')
			BEGIN
				SELECT TOP 1 @CustomerNumber = EntityNumber, @EntityType = EntityType
				FROM u_Kapps_DossierLin
				WHERE InternalStampDoc = @InStampDoc AND Integrada = 'N' AND Status = 'A'
			END
			ELSE IF (@DocTipo = 'DCO')
			BEGIN
				SELECT TOP 1 @CustomerNumber = EntityNumber, @EntityType = EntityType
				FROM u_Kapps_DossierLin
				WHERE StampBO = @InStampDoc AND Integrada = 'N' AND Status = 'A'
			END

			-- Atualizar estado das paletes 
			IF @TipoProcesso IN ('PICKING','PACKING') AND RTRIM(LTRIM(@CustomerNumber)) <> '' and ((@EntityType = 'C') OR (@EntityType = 'CL'))
			BEGIN
				SELECT @IsCustomerInternal = COALESCE(InternalCustomer, 0)
				FROM v_Kapps_Customers
				WHERE Code = @CustomerNumber

				IF @IsCustomerInternal = 0
				BEGIN
					IF (@DocTipo = 'DSO')
					BEGIN
						UPDATE u_Kapps_PackingHeader
						SET PackStatus = 3
						WHERE RTRIM(LTRIM(SSCC)) <> '' AND SSCC IN (
								SELECT SSCC
								FROM u_Kapps_DossierLin
								WHERE InternalStampDoc = @InStampDoc AND Integrada = 'N' AND Status = 'A' AND RTRIM(LTRIM(SSCC)) <> ''
								)
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = '[DSO] Erro ao atualizar PackingHeader!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)		
						END
					END
					ELSE IF (@DocTipo = 'DCO')
					BEGIN
						UPDATE u_Kapps_PackingHeader
						SET PackStatus = 3
						WHERE RTRIM(LTRIM(SSCC)) <> '' AND SSCC IN (
								SELECT SSCC
								FROM u_Kapps_DossierLin
								WHERE StampBO = @InStampDoc AND Integrada = 'N' AND Status = 'A' AND RTRIM(LTRIM(SSCC)) <> ''
								)
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = '[DCO] Erro ao atualizar PackingHeader!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)		
						END
					END
				END
			END

			IF (upper(@ERP) = 'PHC')
			BEGIN
				EXECUTE SP_u_Kapps_DossiersUSR @DocTipo, @InStampDoc, @ndos, @fecha, @NewBoStamp, @terminal, @ParameterGroup, @InUserIntegracao, @ExpeditionWarehouse, @ExpeditionLocation, @resultCode OUTPUT, @resultMsg OUTPUT
			END

			IF (@DocTipo = 'DSO')
			BEGIN
				UPDATE u_Kapps_DossierLin
				SET Integrada = 'S', Status = 'F'
				WHERE InternalStampDoc = @InStampDoc AND Integrada = 'N' AND Status = 'A'
				
				IF @@ERROR <> 0
				BEGIN
					SET @ErrorMessage = '[DSO]2 Erro ao atualizar DossierLin!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				END

				SET @resultCode = 'OK'
				SET @resultMsg = 'Documento não integrado conforme configuração no backoffice'
			END
			ELSE IF (@DocTipo = 'DCO')
			BEGIN
				UPDATE u_Kapps_DossierLin
				SET Integrada = 'S', Status = 'F'
				WHERE StampBO = @InStampDoc AND Integrada = 'N' AND Status = 'A'
				
				IF @@ERROR <> 0
				BEGIN
					SET @ErrorMessage = '[DCO]2 Erro ao atualizar DossierLin!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				END

				SET @resultCode = 'OK'
				SET @resultMsg = 'Documento não integrado conforme configuração no backoffice'
			END
		END
		ELSE
		BEGIN
			IF (upper(@ERP) = 'PERSONALIZADO')
			BEGIN
				EXECUTE SP_u_Kapps_DossiersUSR @DocTipo, @InStampDoc, @ndos, @fecha, @NewBoStamp, @terminal, @ParameterGroup, @InUserIntegracao, @ExpeditionWarehouse, @ExpeditionLocation, @resultCode OUTPUT, @resultMsg OUTPUT
			END
			ELSE
			BEGIN
				SET @totaldeb = 0
				SET @etotaldeb = 0
				SET @edescc = 0
				SET @etotal = 0

				SET @iva1 = 0
				SET @ebo12_bins = 0
				SET @ebo12_iva = 0

				SET @iva2 = 0
				SET @ebo22_bins = 0
				SET @ebo22_iva = 0

				SET @iva3 = 0
				SET @ebo32_bins = 0
				SET @ebo32_iva = 0

				SET @iva4 = 0
				SET @ebo42_bins = 0
				SET @ebo42_iva = 0

				SET @iva5 = 0
				SET @ebo52_bins = 0
				SET @ebo52_iva = 0

				SET @iva6 = 0
				SET @ebo62_bins = 0
				SET @ebo62_iva = 0

				SET @oldStampBo = ''
				SET @oldStampBi = ''
				SET @oldRef = ''
				SET @oldLot = ''
				SET @oldWarehouse = ''
				SET @oldWarehouseOut = ''
				SET @oldSerial = ''
				SET @QtyFinal = 0
				SET @Update = 0
				SET @APPCODE = 'SYT'
				SET @Peso = 0
				SET @PesoFinal = 0
				SET @UseWeight = 0

				DECLARE @ORDERPARAMETER VARCHAR(5)
				SET @ORDERPARAMETER = ''

				SELECT @ORDERPARAMETER = par.ParameterValue
				FROM u_Kapps_Parameters par WITH (NOLOCK)
				WHERE par.APPCODE = @APPCODE AND par.ParameterGroup = @ParameterGroup AND par.ParameterID = 'ORDER_INTEGRATION'

				-- '0' -- ORDEM DE PICAGEM DO DOCUMENTO
				-- '1' -- ORDEM DO DOCUMENTO DE ORIGEM
				-- '2' -- REFERENCIA
				-- '3' -- DESCRICAO

				DECLARE @GRIDFORSERIALNUMBERS VARCHAR(1)
				SET @GRIDFORSERIALNUMBERS = ''

				SELECT @GRIDFORSERIALNUMBERS = par.ParameterValue
				FROM u_Kapps_Parameters par WITH (NOLOCK)
				WHERE par.APPCODE = @APPCODE AND par.ParameterGroup = @ParameterGroup AND par.ParameterID = 'GRIDFORSERIALNUMBERS'

				DECLARE curKappsDossiers CURSOR LOCAL STATIC READ_ONLY
				FOR
				SELECT 
						COALESCE(StampLin, ''),
						COALESCE(StampBo, ''), 
						COALESCE(StampBi, ''), 
						COALESCE(Ref, ''), 
						COALESCE(Description, ''), 
						COALESCE(Qty, 0) as Qty, 
						COALESCE(Lot, ''), 
						COALESCE(Serial, ''), 
						COALESCE(UserID, ''), 
						COALESCE(MovDate, ''), 
						COALESCE(MovTime, ''),
						COALESCE(Status, ''), 
						COALESCE(DocType, '0'),
						COALESCE(DocNumber, ''), 
						COALESCE(Integrada, ''), 
						COALESCE(DataIntegracao, 0), 
						COALESCE(HoraIntegracao, 0), 
						COALESCE(UserIntegracao, ''), 
						COALESCE(Validade, ''),
						COALESCE(Warehouse, '0'),
						COALESCE(Location, ''),
						COALESCE(ExternalDocNum, ''),
						COALESCE(EntityType, ''),
						COALESCE(EntityNumber, ''),
						COALESCE(InternalStampDoc, ''),
						COALESCE(DestinationDocType, '0'),
						COALESCE(VatNumber, ''), 
						COALESCE(UnitPrice, 0),
						COALESCE(WarehouseOut, '0'),
						COALESCE(LocationOut, ''),
						COALESCE(OriLineNumber, 0),
						COALESCE(QtyUM, '') as QtyUM, 
						COALESCE(Qty2, 0) as Qty2, 
						COALESCE(Qty2UM, '') as QtyUM2,
						COALESCE(DeliveryCode, ''),
						COALESCE(NetWeight, 0),
						COALESCE(SSCC, ''),
						COALESCE(CabUserField1,''), COALESCE(CabUserField2,''), COALESCE(CabUserField3,''), COALESCE(CabUserField4,''), COALESCE(CabUserField5,''),
						COALESCE(CabUserField6,''), COALESCE(CabUserField7,''), COALESCE(CabUserField8,''), COALESCE(CabUserField9,''), COALESCE(CabUserField10,''),
						COALESCE(CabUserField11,''), COALESCE(CabUserField12,''), COALESCE(CabUserField13,''), COALESCE(CabUserField14,''), COALESCE(CabUserField15,''),
						COALESCE(LinUserField1,''), COALESCE(LinUserField2,''), COALESCE(LinUserField3,''), COALESCE(LinUserField4,''), COALESCE(LinUserField5,''),
						COALESCE(LinUserField6,''), COALESCE(LinUserField7,''), COALESCE(LinUserField8,''), COALESCE(LinUserField9,''), COALESCE(LinUserField10,''),
						COALESCE(LinUserField11,''), COALESCE(LinUserField12,''), COALESCE(LinUserField13,''), COALESCE(LinUserField14,''), COALESCE(LinUserField15,''),
						COALESCE(IsFinalProductBOM,0)

						FROM u_Kapps_DossierLin WITH(NOLOCK) 
						WHERE (((InternalStampDoc = @InStampDoc) AND (('DSO' = @DocTipo) OR ('DCP' = @DocTipo))) OR ((StampBo = @InStampDoc) AND ('DCO' = @DocTipo))) AND Integrada = 'N' AND Status = 'A' 
						--GROUP BY StampLin, StampBo, StampBi, Ref, Description,Lot,Serial,UserID,MovDate,MovTime,Status,DocType,DocNumber,Integrada,DataIntegracao,HoraIntegracao,UserIntegracao,Validade,Warehouse,Location,ExternalDocNum,EntityType,EntityNumber,InternalStampDoc,DestinationDocType,VatNumber,UnitPrice,WarehouseOut,OriLineNumber
						ORDER BY CASE @ORDERPARAMETER WHEN '1' THEN CAST(OriLineNumber as varchar(50)) WHEN '2' THEN Ref WHEN '3' THEN Description ELSE StampLin  END, MovDate, MovTime 
	 
						OPEN curKappsDossiers

				FETCH NEXT
				FROM curKappsDossiers
				INTO @StampLin,@StampBo,@StampBi,@Ref,@Description,@Qty,@Lot,@Serial,@UserID,@MovDate,@MovTime,@Status,@DocType,@DocNumber,@Integrada,@DataIntegracao,@HoraIntegracao,@UserIntegracao,@Validade,@Warehouse,@Location,@ExternalDocNum,@EntityType,@EntityNumber,@InternalStampDoc,@DestinationDocType, @VatNumber, @UnitPrice, @WarehouseOut, @LocationOut, @OriLineNumber, @QtyUM, @Qty2, @Qty2UM, @descarga, @Peso, @SSCC
					, @CabUF1, @CabUF2, @CabUF3, @CabUF4, @CabUF5, @CabUF6, @CabUF7, @CabUF8, @CabUF9, @CabUF10, @CabUF11, @CabUF12, @CabUF13, @CabUF14, @CabUF15
					, @LinUF1, @LinUF2, @LinUF3, @LinUF4, @LinUF5, @LinUF6, @LinUF7, @LinUF8, @LinUF9, @LinUF10, @LinUF11, @LinUF12, @LinUF13, @LinUF14, @LinUF15
					, @IsFinalProductBOM

				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF (@oldStampBo = @StampBo AND @oldStampBi = @StampBi AND @oldRef = @Ref AND @oldLot = @Lot AND @oldWarehouse = @Warehouse AND @oldWarehouseOut = @WarehouseOut AND @oldSerial = @Serial AND @oldLocation = @Location AND @oldLocationOut = @LocationOut)
					BEGIN
						SET @QtyFinal = @QtyFinal + @Qty
						SET @PesoFinal = @PesoFinal + @Peso
						SET @Update = 1
					END
					ELSE
					BEGIN
						SET @Update = 0
						SET @QtyFinal = @Qty
						SET @PesoFinal = @Peso
					END

					SELECT @UseWeight = UseWeight
					FROM v_Kapps_Articles
					WHERE code = @Ref

					IF (@UseWeight = 1)
					BEGIN
						SET @Qty = @Peso
					END

					SET @CustomerNumber = @EntityNumber
					SET @lordem = @lordem + 1
					SET @DateTimeTmp = GETDATE()
					SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
					SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)

					IF (@UserID = '')
					BEGIN
						SET @UserID = 'Syslog'
					END
					SET @ousrinis = @UserID + '-' + @DateStr
					SET @usrinis = @UserID + '-' + @DateStr

					SET @ousrdata = @DateStr
					SET @usrdata = @DateStr

					SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
					SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

					SET @edebito = 0
					SET @debito = 0
					SET @edebitoori = 0
					SET @debitoori = 0
					
					SET @eslvu = 0
					SET @slvu = 0
					SET @ttdeb = 0
					SET @ettdeb = 0
					SET @esltt = 0
					SET @sltt = 0

					SET @estab = 0
					SET @sTipo = ''
					SET @usr1 = '';
					SET @usr2 = '';
					SET @usr3 = '';
					SET @usr4 = '';
					SET @usr5 = '';
					SET @usr6 = '';
					SET @unidade = ''
					SET @bi2Local = ''
					SET @bi2Morada = ''
					SET @bi2CodPost = ''
					SET @segmento = ''
					SET @bofRef = ''

					IF CHARINDEX('.', @EntityNumber) > 0
					BEGIN
						SET @estab = CAST(RIGHT(@EntityNumber, LEN(@EntityNumber) - CHARINDEX('.', @EntityNumber)) AS INT)
						SET @EntityNumber = LEFT(@EntityNumber, CHARINDEX('.', @EntityNumber) - 1)
					END

					IF @NewBoStamp = ''
					BEGIN
						-- cria o dossier interno do documento caso ainda não exista
						WAITFOR DELAY '00:00:00.200'

						SET @DateTimeTmp = GETDATE()
						SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
						SET @NewBoStamp = 'Syslog_' + @DateStr + @TimeStr
						SET @boano = YEAR(@DateTimeTmp)

						-- nome do dossier de destino
						IF (@DocTipo = 'DSO') 
						BEGIN
							IF (@tmpDTA_ORIGIN <> '1')
							BEGIN
								SET @ndos = @DocType
							END
						END

						SELECT @nmdos = COALESCE(nmdos, ''), @bdemp = bdempresas, @rescli = rescli, @resfor = resfor, @ocupacao = ocupacao
						FROM ts WITH (NOLOCK)
						WHERE ndos = CAST(@ndos AS INT)

						-- novo numero do dossier
						SELECT @ManterNumeracao = COALESCE(manternumero, cast(0 AS BIT))
						FROM ts2(NOLOCK)
						INNER JOIN ts(NOLOCK) ON ts.tsstamp = ts2.ts2stamp
						WHERE ts.ndos = @ndos

						IF @ManterNumeracao = 1
						BEGIN
							SELECT @obrano = (COALESCE(MAX(obrano), 0) + 1)
							FROM bo
							WHERE ndos = CAST(@ndos AS INT)
						END
						ELSE
						BEGIN
							SELECT @obrano = (COALESCE(MAX(obrano), 0) + 1)
							FROM bo
							WHERE ndos = CAST(@ndos AS INT) AND YEAR(bo.dataobra) = YEAR(GETDATE())
						END

						IF ((@DocTipo = 'DSO') OR (@DocTipo = 'DCP')) -- vai buscar os dados do terceiro 
						BEGIN
							SET @EntSegmento = ''
							SET @EntLocTesoura = ''
							SET @EntContado = 0

							IF (@EntityType = 'C') OR (@EntityType = 'CL')
								SELECT @EntityNumber = no, @EntTipo = COALESCE(tipo, ''), @EntZona = COALESCE(zona, ''), @EntSegmento = COALESCE(segmento, ''), @EntTelef = COALESCE(telefone, ''), @EntNome = COALESCE(nome, ''), @EntMorada = COALESCE(morada, ''), @EntLocal = COALESCE(LOCAL, ''), @EntCPostal = COALESCE(codpost, ''), @EntNCont = COALESCE(ncont, ''), @EntPais = COALESCE(pais, 0), @EntMoeda = COALESCE(moeda, ''), @EntLocTesoura = COALESCE(ollocal, ''), @EntContado = COALESCE(contado, 0), @fref = COALESCE(fref, ''), @ccusto = COALESCE(ccusto, ''), @EntContacto = COALESCE(contacto, ''), @EntEmail = COALESCE(email, '')
								FROM cl WITH (NOLOCK)
								WHERE no = CAST(@EntityNumber AS INT) AND estab = @estab
							ELSE IF (@EntityType = 'AG')
								SELECT @EntityNumber = no, @EntTipo = '', @EntZona = COALESCE(zona, ''), @EntSegmento = '', @EntTelef = COALESCE(telefone, ''), @EntNome = COALESCE(nome, ''), @EntMorada = COALESCE(morada, ''), @EntLocal = COALESCE(LOCAL, ''), @EntCPostal = COALESCE(codpost, ''), @EntNCont = COALESCE(ncont, ''), @EntPais = 0, @EntMoeda = 'EURO', @EntLocTesoura = '', @EntContado = 0, @fref = '', @ccusto = '', @EntContacto = COALESCE(contacto, ''), @EntEmail = COALESCE(email, '')
								FROM ag WITH (NOLOCK)
								WHERE no = CAST(@EntityNumber AS INT)
							ELSE IF (@EntityType = 'F') OR (@EntityType = 'FL')
								SELECT @EntityNumber = no, @EntTipo = COALESCE(tipo, ''), @EntZona = COALESCE(zona, ''), @EntTelef = COALESCE(telefone, ''), @EntNome = COALESCE(nome, ''), @EntMorada = COALESCE(morada, ''), @EntLocal = COALESCE(LOCAL, ''), @EntCPostal = COALESCE(codpost, ''), @EntNCont = COALESCE(ncont, ''), @EntPais = COALESCE(pais, 0), @EntMoeda = COALESCE(moeda, ''), @fref = COALESCE(fref, ''), @ccusto = COALESCE(ccusto, ''), @EntContacto = COALESCE(contacto, ''), @EntEmail = COALESCE(email, '')
								FROM fl WITH (NOLOCK)
								WHERE no = @EntityNumber AND estab = @estab
							ELSE
							BEGIN
								SET @EntityNumber = ''
								SET @EntTipo = ''
								SET @EntZona = ''
								SET @EntTelef = ''
								SET @EntNome = ''
								SET @EntMorada = ''
								SET @EntLocal = ''
								SET @EntCPostal = ''
								SET @EntNCont = ''
								SET @EntPais = 0
								SET @EntMoeda = ''
								SET @fref = ''
								SET @ccusto = ''
								SET @EntContacto = ''
								SET @EntEmail = ''
							END

							IF ((@VatNumber <> '') AND (@VatNumber <> @EntNCont))
								SET @EntNCont = @VatNumber
						END
						ELSE
						BEGIN
							SELECT @EntNome = nome, @EntMorada = morada, @EntLocal = LOCAL, @EntCPostal = codpost, @EntityNumber = no, @EntMoeda = moeda, @EntNCont = ncont, @EntTipo = tipo, @EntZona = zona, @EntSegmento = segmento, @fref = fref, @ccusto = ccusto, @estab = estab
							FROM bo WITH (NOLOCK)
							WHERE bostamp = @StampBo
						END

						IF @TipoProcesso <> 'PICKTRANSF'
						BEGIN
							IF ((@DocTipo = 'DCO') AND (@WarehouseOut <> '') AND (@WarehouseOut <> @Warehouse))
							BEGIN
								DECLARE @WarehouseOutTemp NVARCHAR(50)

								SET @WarehouseOutTemp = @WarehouseOut
								SET @WarehouseOut = @Warehouse
								SET @Warehouse = @WarehouseOutTemp
							END
						END

						INSERT INTO bo2(bo2stamp, Armazem, ar2mazem, descar) 
						VALUES (@NewBoStamp, CAST(@Warehouse as int), CAST(@WarehouseOut as int), @descarga)
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = 'Erro ao adicionar BO2!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END

						INSERT INTO bo3(bo3stamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
						VALUES (@NewBoStamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = 'Erro ao adicionar BO3!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END

						-- syslog***
						DECLARE @values_Cab NVARCHAR(MAX) = ''

						IF @CAB_USER_FIELD1_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD1_TYPE = 'n' AND COALESCE(RTRIM(@CabUF1),'')=''
							BEGIN
								SET @CabUF1 = '0';
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF1, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD2_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD2_TYPE = 'n' AND COALESCE(RTRIM(@CabUF2),'')=''
							BEGIN
								SET @CabUF2 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF2, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD3_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD3_TYPE = 'n' AND COALESCE(RTRIM(@CabUF3),'')=''
							BEGIN
								SET @CabUF3 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF3, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD4_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD4_TYPE = 'n' AND COALESCE(RTRIM(@CabUF4),'')=''
							BEGIN
								SET @CabUF4 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF4, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD5_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD5_TYPE = 'n' AND COALESCE(RTRIM(@CabUF5),'')=''
							BEGIN
								SET @CabUF5 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF5, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD6_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD6_TYPE = 'n' AND COALESCE(RTRIM(@CabUF6),'')=''
							BEGIN
								SET @CabUF6 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF6, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD7_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD7_TYPE = 'n' AND COALESCE(RTRIM(@CabUF7),'')=''
							BEGIN
								SET @CabUF7 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF7, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD8_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD8_TYPE = 'n' AND COALESCE(RTRIM(@CabUF8),'')=''
							BEGIN
								SET @CabUF8 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF8, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD9_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD9_TYPE = 'n' AND COALESCE(RTRIM(@CabUF9),'')=''
							BEGIN
								SET @CabUF9 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF9, '''', '''''') + ''''
						END

						IF @CAB_USER_FIELD10_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD10_TYPE = 'n' AND COALESCE(RTRIM(@CabUF10),'')=''
							BEGIN
								SET @CabUF10 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF10, '''', '''''') + ''''
						END
						IF @CAB_USER_FIELD11_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD11_TYPE = 'n' AND COALESCE(RTRIM(@CabUF11),'')=''
							BEGIN
								SET @CabUF11 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF11, '''', '''''') + ''''
						END
						IF @CAB_USER_FIELD12_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD12_TYPE = 'n' AND COALESCE(RTRIM(@CabUF12),'')=''
							BEGIN
								SET @CabUF12 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF12, '''', '''''') + ''''
						END
						IF @CAB_USER_FIELD13_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD13_TYPE = 'n' AND COALESCE(RTRIM(@CabUF13),'')=''
							BEGIN
								SET @CabUF13 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF13, '''', '''''') + ''''
						END
						IF @CAB_USER_FIELD14_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD14_TYPE = 'n' AND COALESCE(RTRIM(@CabUF14),'')=''
							BEGIN
								SET @CabUF14 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF14, '''', '''''') + ''''
						END
						IF @CAB_USER_FIELD15_INTEGRATION_NAME > ''
						BEGIN
							IF @CAB_USER_FIELD15_TYPE = 'n' AND COALESCE(RTRIM(@CabUF15),'')=''
							BEGIN
								SET @CabUF15 = '0'
							END
							SET @values_Cab = @values_Cab + ', ''' + REPLACE(@CabUF15, '''', '''''') + ''''
						END

						-- Atualiza documento baseado na ficha técnica
						IF ((@TipoProcesso = 'PRODUCTION') AND (@tmpDTA_ORIGIN = '1'))
						BEGIN
							SET @InsertQry ='INSERT INTO BO (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, moeda, ncont'
							+ ', tipo, zona, segmento, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fref, ccusto, OBS, etotaldeb, ebo_2tvall, edescc, ebo_1tvall, ebo_totp1, ebo_totp2, estab, ocupacao, dataopen, ultfact' 
							+ @CAB_USER_FIELD1_INTEGRATION_NAME + @CAB_USER_FIELD2_INTEGRATION_NAME + @CAB_USER_FIELD3_INTEGRATION_NAME + @CAB_USER_FIELD4_INTEGRATION_NAME + @CAB_USER_FIELD5_INTEGRATION_NAME + @CAB_USER_FIELD6_INTEGRATION_NAME + @CAB_USER_FIELD7_INTEGRATION_NAME + @CAB_USER_FIELD8_INTEGRATION_NAME + @CAB_USER_FIELD9_INTEGRATION_NAME + @CAB_USER_FIELD10_INTEGRATION_NAME + @CAB_USER_FIELD11_INTEGRATION_NAME + @CAB_USER_FIELD12_INTEGRATION_NAME + @CAB_USER_FIELD13_INTEGRATION_NAME + @CAB_USER_FIELD14_INTEGRATION_NAME + @CAB_USER_FIELD15_INTEGRATION_NAME + ')'
							+ ' VALUES('''+ @NewBoStamp + ''', ' + CONVERT(VARCHAR(50),@boano) + ', ' + CONVERT(VARCHAR(50),@obrano) + ', ' +  CONVERT(VARCHAR(50),@ndos) + ', ''' + @nmdos + ''', ''' + @DateStr + ''', ''' + REPLACE(@EntNome, '''', '''''') + ''', ''' + REPLACE(@EntMorada, '''', '''''') + ''', ''' + REPLACE(@EntLocal, '''', '''''') + ''', ''' + REPLACE(@EntCPostal, '''', '''''') + ''', ' + CONVERT(VARCHAR(200),@EntityNumber) + ', ''' + @EntMoeda + ''', ''' + @EntNCont 
							+ ''', ''' + @EntTipo + ''', ''' + @EntZona + ''', ''' + @EntSegmento + ''', ''' + @ousrinis + ''', ''' + CONVERT(VARCHAR(200),@ousrdata) + ''', ''' + CONVERT(VARCHAR(200),@ousrhora) + ''', ''' + @usrinis + ''', ''' + CONVERT(VARCHAR(200),@usrdata) + ''', ''' + CONVERT(VARCHAR(200),@usrhora) + ''', ''' + @fref + ''', ''' + @ccusto + ''', ''' + @ExternalDocNum + ''', ''' + CONVERT(VARCHAR(200),@etotaldeb) + ''', ''' + CONVERT(VARCHAR(200),@etotaldeb) + ''', ''' + CONVERT(VARCHAR(200),@edescc) + ''', ''' + CONVERT(VARCHAR(200),@etotal) + ''', ''' + CONVERT(VARCHAR(200),@etotal) + ''', ''' + CONVERT(VARCHAR(200),@etotal) + ''', ''' + CONVERT(VARCHAR(200),@estab) + ''', ''' + CONVERT(VARCHAR(200),@ocupacao) + ''', ''' + CONVERT(VARCHAR(200),@ousrdata) + ''', ''' + CONVERT(VARCHAR(200),@ousrdata) + '''' 
							+ @values_Cab + ')'
						END
						ELSE
						BEGIN
							SET @InsertQry ='INSERT INTO BO (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, moeda, ncont'
							+ ', tipo, zona, segmento, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fref, ccusto, OBS, etotaldeb, ebo_2tvall, edescc, ebo_1tvall, ebo_totp1, ebo_totp2, estab, ocupacao, dataopen, ultfact' 
							+ @CAB_USER_FIELD1_INTEGRATION_NAME + @CAB_USER_FIELD2_INTEGRATION_NAME + @CAB_USER_FIELD3_INTEGRATION_NAME + @CAB_USER_FIELD4_INTEGRATION_NAME + @CAB_USER_FIELD5_INTEGRATION_NAME + @CAB_USER_FIELD6_INTEGRATION_NAME + @CAB_USER_FIELD7_INTEGRATION_NAME + @CAB_USER_FIELD8_INTEGRATION_NAME + @CAB_USER_FIELD9_INTEGRATION_NAME + @CAB_USER_FIELD10_INTEGRATION_NAME + @CAB_USER_FIELD11_INTEGRATION_NAME + @CAB_USER_FIELD12_INTEGRATION_NAME + @CAB_USER_FIELD13_INTEGRATION_NAME + @CAB_USER_FIELD14_INTEGRATION_NAME + @CAB_USER_FIELD15_INTEGRATION_NAME + ')'
							+ ' VALUES('''+ @NewBoStamp + ''', ' + CONVERT(VARCHAR(50),@boano) + ', ' + CONVERT(VARCHAR(50),@obrano) + ', ' +  CONVERT(VARCHAR(50),@ndos) + ', ''' + @nmdos + ''', ''' + @DateStr + ''', ''' + REPLACE(@EntNome, '''', '''''') + ''', ''' + REPLACE(@EntMorada, '''', '''''') + ''', ''' + REPLACE(@EntLocal, '''', '''''') + ''', ''' + REPLACE(@EntCPostal, '''', '''''') + ''', ' + CONVERT(VARCHAR(200),@EntityNumber) + ', ''' + @EntMoeda + ''', ''' + @EntNCont 
							+ ''', ''' + @EntTipo + ''', ''' + @EntZona + ''', ''' + @EntSegmento + ''', ''' + @ousrinis + ''', ''' + CONVERT(VARCHAR(200),@ousrdata) + ''', ''' + CONVERT(VARCHAR(200),@ousrhora) + ''', ''' + @usrinis + ''', ''' + CONVERT(VARCHAR(200),@usrdata) + ''', ''' + CONVERT(VARCHAR(200),@usrhora) + ''', ''' + @fref + ''', ''' + @ccusto + ''', ''' + @ExternalDocNum + ''', ''' + CONVERT(VARCHAR(200),@etotaldeb) + ''', ''' + CONVERT(VARCHAR(200),@etotaldeb) + ''', ''' + CONVERT(VARCHAR(200),@edescc) + ''', ''' + CONVERT(VARCHAR(200),@etotal) + ''', ''' + CONVERT(VARCHAR(200),@etotal) + ''', ''' + CONVERT(VARCHAR(200),@etotal) + ''', ''' + CONVERT(VARCHAR(200),@estab) + ''', ''' + CONVERT(VARCHAR(200),@ocupacao) + ''', ''' + CONVERT(VARCHAR(200),@ousrdata) + ''', ''' + CONVERT(VARCHAR(200),@ousrdata) + '''' 
							+ @values_Cab + ')'
						END

						EXEC sp_executesql @InsertQry
						
						IF @@ERROR <> 0 OR COALESCE(@InsertQry,'') = ''
						BEGIN
							SET @ErrorMessage = '[955] Erro ao adicionar BO!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END

						SET @NEWnmdos = ''
						SET @NEWobrano = 0

						SELECT @NEWnmdos = nmdos, @NEWobrano = obrano
						FROM bo WITH (NOLOCK)
						WHERE bostamp = @NewBoStamp

						IF (@DocTipo = 'DCO')
						BEGIN
							EXECUTE SP_u_Kapps_DossiersUSR @DocTipo, @StampBo, @ndos, @fecha, @NewBoStamp, @terminal, @ParameterGroup, @UserIntegracao, @ExpeditionWarehouse, @ExpeditionLocation, @resultCode OUTPUT, @resultMsg OUTPUT
						END
						ELSE
						BEGIN
							EXECUTE SP_u_Kapps_DossiersUSR @DocTipo, @InternalStampDoc, @ndos, @fecha, @NewBoStamp, @terminal, @ParameterGroup, @UserIntegracao, @ExpeditionWarehouse, @ExpeditionLocation, @resultCode OUTPUT, @resultMsg OUTPUT
						END
					END

					-- se não existir o lote tem de se criar
					IF @Lot <> ''
					BEGIN
						EXECUTE SP_u_Kapps_InsertLot @Lot, @ref, @Description, '', @validade, @UserID, 0, @resultLot OUTPUT, @ErrorMessage OUTPUT

						IF @resultLot=0
						BEGIN
							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END

						SET @usalote = 1
					END
					ELSE
						SET @usalote = 0

					SELECT @predec = predec
					FROM ts WITH (NOLOCK)
					WHERE ndos = CAST(@ndos AS INT)

					IF ((@DocTipo = 'DCO') AND (@StampBi <> '')) -- atualiza a quantidade de origem
					BEGIN
						-- Vai buscar os dados para as linhas
						SELECT @sTipo = sTipo, @epu = epu, @pu = pu, @edebito = edebito, @debito = debito, @edebitoori = edebitoori, @debitoori = debitoori, @eprorc = eprorc, @prorc = prorc, @epcusto = epcusto, @pcusto = pcusto, @armazem = armazem, @lobs = lobs, @desconto = desconto, @desc2 = desc2, @desc3 = desc3, @desc4 = desc4, @desc5 = desc5, @desc6 = desc6, @eVALDESC = eVALDESC, @tabiva = TABIVA, @iva = iva, @eslvu = eslvu, @slvu = slvu, @esltt = esltt, @sltt = sltt, @local = LOCAL, @morada = morada, @codpost = codpost, @familia = familia, @zona = zona, @UsaNumSerie = noserie, @NumSerie = serie, @ivaincl = ivaincl, @VALDESC = VALDESC, @ecustoind = ecustoind, @custoind = custoind, @segmento = segmento, @bofRef = bofref
						FROM BI WITH (NOLOCK)
						WHERE bistamp = @StampBi

						SELECT @bi2local = LOCAL, @bi2Morada = Morada, @bi2CodPost = CodPost
						FROM bi2 WITH (NOLOCK)
						WHERE bi2stamp = @StampBi
					END
					ELSE
					BEGIN
						SET @armazem = 0
						SET @pu = 0
						SET @epu = 0
						SET @edebito = @UnitPrice
						SET @edebitoori = @UnitPrice
						SET @debitoori = 0
						SET @debito = 0
						SET @prorc = 0
						SET @eprorc = 0
						SET @pcusto = 0
						SET @epcusto = 0
						SET @ettdeb = 0
						SET @ttdeb = 0
						SET @lobs = ''
						SET @desconto = 0
						SET @desc2 = 0
						SET @desc3 = 0
						SET @desc4 = 0
						SET @desc5 = 0
						SET @desc6 = 0
						SET @VALDESC = 0
						SET @eVALDESC = 0
						SET @custoind = 0
						SET @ecustoind = 0
						SET @sTipo = '4'
						SET @local = @EntLocal
						SET @morada = @EntMorada
						SET @codpost = @EntCPostal
						SET @zona = @EntZona
						SET @nome = @EntNome
					END

					-- Taxas de iva e outros dados do artigo
					IF (@EntityType = 'C') OR (@EntityType = 'CL')
						SELECT @tabiva = CASE WHEN (SELECT cl.TabIVA FROM cl WITH(NOLOCK) WHERE cl.no = @EntityNumber and cl.estab = @estab) = 0 then st.TABIVA else (SELECT cl.TabIVA FROM cl WITH(NOLOCK) WHERE cl.no = @EntityNumber and cl.estab = @estab) END, @iva = CASE WHEN (SELECT cl.TabIVA FROM cl WITH(NOLOCK) WHERE cl.no = @EntityNumber and cl.estab = @estab) = 0 then taxasiva.taxa else (SELECT ti.taxa FROM cl WITH(NOLOCK) JOIN taxasiva ti WITH(NOLOCK) ON ti.codigo = cl.tabiva WHERE cl.no = @EntityNumber and cl.estab = @estab) END , @usalote = st.usalote, @usr1 = usr1, @usr2 = usr2, @usr3 = usr3, @usr4 = usr4, @usr5 = usr5, @usr6 = usr6, @unidade = unidade, @ArtigodeServicos = stns, @UsaNumSerie = noserie, @familia = familia FROM st WITH(NOLOCK) JOIN taxasiva WITH(NOLOCK) ON  st.TABIVA = taxasiva.codigo WHERE st.Ref = @Ref
					ELSE IF (@EntityType = 'F') OR (@EntityType = 'FL')
						SELECT @tabiva = CASE WHEN (SELECT fl.TabIVA FROM fl WITH(NOLOCK) WHERE fl.no = @EntityNumber and fl.estab = @estab) = 0 then st.TABIVA else (SELECT fl.TabIVA FROM fl WITH(NOLOCK) WHERE fl.no = @EntityNumber and fl.estab = @estab) END, @iva = CASE WHEN (SELECT fl.TabIVA FROM fl WITH(NOLOCK) WHERE fl.no = @EntityNumber and fl.estab = @estab) = 0 then taxasiva.taxa else (SELECT ti.taxa FROM fl WITH(NOLOCK) JOIN taxasiva ti WITH(NOLOCK) ON ti.codigo = fl.tabiva WHERE fl.no = @EntityNumber and fl.estab = @estab) END , @usalote = st.usalote, @usr1 = usr1, @usr2 = usr2, @usr3 = usr3, @usr4 = usr4, @usr5 = usr5, @usr6 = usr6, @unidade = unidade, @ArtigodeServicos = stns, @UsaNumSerie = noserie, @familia = familia FROM st WITH(NOLOCK) JOIN taxasiva WITH(NOLOCK) ON  st.TABIVA = taxasiva.codigo WHERE st.Ref = @Ref
					ELSE
						SELECT @tabiva = 0, @iva = 0, @usalote = st.usalote, @usr1 = usr1, @usr2 = usr2, @usr3 = usr3, @usr4 = usr4, @usr5 = usr5, @usr6 = usr6, @unidade = unidade, @ArtigodeServicos = stns, @UsaNumSerie = noserie, @familia = familia FROM st WITH(NOLOCK) JOIN taxasiva WITH(NOLOCK) ON  st.TABIVA = taxasiva.codigo WHERE st.Ref = @Ref

					IF (@tabiva is null)
					BEGIN
						RAISERROR ('Erro ao verificar os dados do artigo', @ErrorSeverity, @ErrorState)		
					END
					
					-- Totais
					SET @sltt = @slvu * @Qty
					SET @esltt = @eslvu * @Qty
					--
					SET @ettdeb = ROUND((@Qty * (((((((@edebito) * ((100 - @desconto) / 100)) * ((100 - @desc2) / 100)) * ((100 - @desc3) / 100)) * ((100 - @desc4) / 100)) * ((100 - @desc5) / 100)) * ((100 - @desc6) / 100)) - @eVALDESC), @predec)
					--SET @ettdeb = (@Qty * (((((((@edebito) * ((100 - @desconto) / 100)) * ((100 - @desc2) / 100)) * ((100 - @desc3) / 100)) * ((100 - @desc4) / 100)) * ((100 - @desc5) / 100)) * ((100 - @desc6) / 100)) - @eVALDESC)

					IF (@ivaincl = 1)
					BEGIN
						SET @etotaldeb = @etotaldeb + @ettdeb - ROUND(@ettdeb - (@ettdeb / (1 + (@iva / 100))), 2)
						SET @SemIva = @edebito - ROUND(@edebito - (@edebito / (1 + (@iva / 100))), 2)
					END
					ELSE
					BEGIN
						SET @etotaldeb = @etotaldeb + @ettdeb
						SET @SemIva = @edebito
					END

					--SET @etotal = @etotal + ROUND((@Qty * @SemIva),@predec)
					SET @etotal = @etotal + (@Qty * @SemIva)
					SET @edescc = @etotal - @etotaldeb
					--SET @ecusto = @ecusto + ROUND((@Qty * @epcusto), @predec)   
					SET @ecusto = @ecusto + (@Qty * @epcusto)

					IF (@tabiva = 1)
					BEGIN
						SET @iva1 = @iva
						SET @ebo12_bins = @ebo12_bins + @ettdeb
						SET @ebo12_iva = @ebo12_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva / 100)), 2))
					END
					ELSE IF (@tabiva = 2)
					BEGIN
						SET @iva2 = @iva
						SET @ebo22_bins = @ebo22_bins + @ettdeb
						SET @ebo22_iva = @ebo22_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva / 100)), 2))
					END
					ELSE IF (@tabiva = 3)
					BEGIN
						SET @iva3 = @iva
						SET @ebo32_bins = @ebo32_bins + @ettdeb
						SET @ebo32_iva = @ebo32_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva / 100)), 2))
					END
					ELSE IF (@tabiva = 4)
					BEGIN
						SET @iva4 = @iva
						SET @ebo42_bins = @ebo42_bins + @ettdeb
						SET @ebo42_iva = @ebo42_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva / 100)), 2))
					END
					ELSE IF (@tabiva = 5)
					BEGIN
						SET @iva5 = @iva
						SET @ebo52_bins = @ebo52_bins + @ettdeb
						SET @ebo52_iva = @ebo52_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva / 100)), 2))
					END
					ELSE IF (@tabiva = 6)
					BEGIN
						SET @iva6 = @iva
						SET @ebo62_bins = @ebo62_bins + @ettdeb
						SET @ebo62_iva = @ebo62_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva / 100)), 2))
					END

					SET @ttdeb = dbo.u_Kapps_EurToEsc(@ettdeb)

					IF (@Update = 0)
					BEGIN
						-- syslog***
						DECLARE @values_Lin NVARCHAR(MAX) = ''

						IF @Lin_USER_FIELD1_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD1_TYPE = 'n' AND COALESCE(RTRIM(@LinUF1), '')=''
							BEGIN
								SET @LinUF1 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF1, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD2_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD2_TYPE = 'n' AND COALESCE(RTRIM(@LinUF2), '')=''
							BEGIN
								SET @LinUF2 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF2, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD3_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD3_TYPE = 'n' AND COALESCE(RTRIM(@LinUF3), '')=''
							BEGIN
								SET @LinUF3 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF3, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD4_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD4_TYPE = 'n' AND COALESCE(RTRIM(@LinUF4), '')=''
							BEGIN
								SET @LinUF4 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF4, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD5_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD5_TYPE = 'n' AND COALESCE(RTRIM(@LinUF5), '')=''
							BEGIN
								SET @LinUF5 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF5, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD6_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD6_TYPE = 'n' AND COALESCE(RTRIM(@LinUF6), '')=''
							BEGIN
								SET @LinUF6 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF6, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD7_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD7_TYPE = 'n' AND COALESCE(RTRIM(@LinUF7), '')=''
							BEGIN
								SET @LinUF7 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF7, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD8_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD8_TYPE = 'n' AND COALESCE(RTRIM(@LinUF8), '')=''
							BEGIN
								SET @LinUF8 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF8, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD9_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD9_TYPE = 'n' AND COALESCE(RTRIM(@LinUF9), '')=''
							BEGIN
								SET @LinUF9 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF9, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD10_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD10_TYPE = 'n' AND COALESCE(RTRIM(@LinUF10), '')=''
							BEGIN
								SET @LinUF10 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF10, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD11_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD11_TYPE = 'n' AND COALESCE(RTRIM(@LinUF11), '')=''
							BEGIN
								SET @LinUF11 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF11, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD12_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD12_TYPE = 'n' AND COALESCE(RTRIM(@LinUF12), '')=''
							BEGIN
								SET @LinUF12 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF12, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD13_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD13_TYPE = 'n' AND COALESCE(RTRIM(@LinUF13), '')=''
							BEGIN
								SET @LinUF13 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF13, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD14_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD14_TYPE = 'n' AND COALESCE(RTRIM(@LinUF14), '')=''
							BEGIN
								SET @LinUF14 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF14, '''', '''''') + ''''
						END

						IF @Lin_USER_FIELD15_INTEGRATION_NAME > ''
						BEGIN
							IF @Lin_USER_FIELD15_TYPE = 'n' AND COALESCE(RTRIM(@LinUF15), '')=''
							BEGIN
								SET @LinUF15 = '0'
							END
							SET @values_Lin = @values_Lin + ', ''' + REPLACE(@LinUF15, '''', '''''') + ''''
						END

						--
						-- o insert dos números de série tem de ser feito antes da linha porque precisamos
						-- dos ns concatenados para escrever num campo da linha
						-- como estamos em transação não conseguimos fazer dentro da mesma transação um UPDATE a linha que foi alvo de INSERT
						--
						-- Insere os números de série
						--
						IF @UsaNumSerie = '1' OR @UsaNumSerie = '2'
						BEGIN
							DECLARE @foserie INT
							DECLARE @ftserie INT

							SET @Serials_Join = ''
							SET @recnum_boma = 0

							IF @GRIDFORSERIALNUMBERS = '1'
							BEGIN
								DECLARE curNumsSerie CURSOR LOCAL STATIC READ_ONLY
								FOR
								SELECT Serial
								FROM u_Kapps_Serials WITH (NOLOCK)
								WHERE StampLin = @StampLin

								OPEN curNumsSerie

								FETCH NEXT
								FROM curNumsSerie
								INTO @NumSerie

								WHILE @@FETCH_STATUS = 0
								BEGIN
									IF LTRIM(@NumSerie) = ''
									BEGIN
										SET @ErrorMessage = 'O número de série do artigo ' + @Ref + ' não foi indicado.'

										RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)	
									END
									--
									-- Se for entrada e o numero de serie nao existir escreve na ma
									--
									SET @NewStamp_Ma = ''
									SET @StampMaCount = 0
									--
									-- Entrada do Serial Number
									--
									IF (@EntityType = 'F') OR (@EntityType = 'FL')
									BEGIN
										SET @foserie = 1
										SET @ftserie = 0
										--
										-- Se for receção e já existe o serial então é uma reentrada
										-- gera novo @NewStamp_Ma
										--
										SELECT @StampMaCount = COUNT(*)
										FROM ma WITH (NOLOCK)
										WHERE serie = @NumSerie

										IF @StampMaCount > 0
										BEGIN
											WAITFOR DELAY '00:00:00.200'

											SET @DateTimeTmp_Ma = GETDATE()
											SET @DateStr_Ma = dbo.u_Kapps_DateToString(@DateTimeTmp_Ma)
											SET @TimeStr_Ma = dbo.u_Kapps_TimeToString(@DateTimeTmp_Ma)
											SET @NewStamp_Ma = 'Syslog_' + @DateStr_Ma + @TimeStr_Ma
										END

										WAITFOR DELAY '00:00:00.200'

										SET @DateTimeTmp_SN = GETDATE()
										SET @DateStr_SN = dbo.u_Kapps_DateToString(@DateTimeTmp_SN)
										SET @TimeStr_SN = dbo.u_Kapps_TimeToString(@DateTimeTmp_SN)
										SET @NewStamp_BOMA = 'Syslog_' + @DateStr_SN + @TimeStr_SN
									END
									ELSE
									BEGIN
										IF (@EntityType = 'C') OR (@EntityType = 'CL')
										BEGIN
											SET @foserie = 0
											SET @ftserie = 1
											SET @ccusto = ''
											--
											-- há um triger que RE_cria o registo do ma se passarmos no boma o mastamp original (da entrada)
											--
											SELECT @NewStamp_Ma = mastamp
											FROM ma WITH (NOLOCK)
											WHERE serie = @NumSerie
										END
									END

									SET @recnum_boma = @recnum_boma + 1

									IF @Serials_Join = ''
									BEGIN
										SET @Serials_Join = @Serials_Join + @NumSerie
									END
									ELSE
									BEGIN
										SET @Serials_Join = @Serials_Join + ',' + @NumSerie
									END

									WAITFOR DELAY '00:00:00.200'

									SET @DateTimeTmp_SN = GETDATE()
									SET @DateStr_SN = dbo.u_Kapps_DateToString(@DateTimeTmp_SN)
									SET @TimeStr_SN = dbo.u_Kapps_TimeToString(@DateTimeTmp_SN)
									SET @NewStamp_BOMA = 'Syslog_' + @DateStr_SN + @TimeStr_SN

									SET @InsertNS_boma ='INSERT INTO boma (bomastamp, bostamp, bistamp '
									+ ', serie, serie2, ref, design'
									+ ', marca, maquina, tipo '
									+ ', fref, ccusto, ncusto, situacao '
									+ ', nome, no, estab, nmdos, obrano'
									+ ', dataobra, armazem, ar2mazem, bdemp '
									+ ', ctrmastamp, mastamp, ndos, foserie '
									+ ', ftserie, trfarm, retequi, producao '
									+ ', refprod, recnum, obs, user1, user2 '
									+ ', user3, user4, emconf '
									+ ', ousrinis, ousrdata '
									+ ', ousrhora, usrinis '
									+ ', usrdata, usrhora '
									+ ', marcada, trocaequi, ocliequi, maserierpl, serprvef) '
									+ 'VALUES('
									+ '''' + @NewStamp_BOMA + ''''
									+ ',' + '''' + @NewBoStamp + ''''
									+ ',' + ''''+ @StampLin + ''''
									+ ',' + '''' + CONVERT(VARCHAR(200),@NumSerie) + ''''
									+ ',' + '''' + '' + ''''
									+ ',' + '''' + @Ref + ''''
									+ ',' + '''' + REPLACE(@Description, '''', '''''') + ''''
									+ ',' + '''' + @usr1 + ''''
									+ ',' + '''' + @usr2 + ''''
									+ ',' + '''' + 'M' + ''''
									+ ',' + '''' + '' + ''''
									+ ',' + '''' + @ccusto + ''''
									+ ',' + '''' + '' + ''''
									+ ',' + '''' + 'em intervenção' + ''''
									+ ',' + '''' + REPLACE(@EntNome, '''', '''''') + ''''
									+ ',' + CONVERT(VARCHAR(200),CAST(@EntityNumber as int)) 
									+ ', 0'
									+ ', ' + '''' + @nmdos + '''' 
									+ ',' + '''' + CONVERT(VARCHAR(200),@obrano) + ''''
									+ ',' + '''' + CONVERT(VARCHAR(200),@DateStr) + ''''
									+ ',' + CONVERT(VARCHAR(200),CAST(@Warehouse as int))
									+ ',0'   --+ CONVERT(VARCHAR(200),CAST(@WarehouseOut as int))
									+ ', ' + '''' + @bdemp + '''' 
									+ ', ' + '''' + '' + '''' 
									+ ', ' + '''' + @NewStamp_Ma + '''' 
									+ ',' + CONVERT(VARCHAR(200),CAST(@ndos as int))
									+ ',' + CONVERT(VARCHAR(200),CAST(@foserie as int))
									+ ',' + CONVERT(VARCHAR(200),CAST(@ftserie as int))
									+ ', 0'
									+ ', 0'
									+ ', ' + CONVERT(VARCHAR(1),CAST(@IsFinalProductBOM as int)) 
									+ ', 0'
									+ ',' + CONVERT(VARCHAR(200),CAST(@recnum_boma as int)) 
									+ ', ' + '''' + '' + '''' 
									+ ', ' + '''' + '' + '''' 
									+ ', ' + '''' + '' + '''' 
									+ ', ' + '''' + '' + '''' 
									+ ', ' + '''' + '' + '''' 
									+ ', 0'
									+ ', ' + '''' + @ousrinis + '''' 
									+ ',' + '''' + CONVERT(VARCHAR(200),@DateStr) + ''''
									+ ',' + '''' + CONVERT(VARCHAR(200),@ousrhora) + ''''
									+ ', ' + '''' + @usrinis + '''' 
									+ ',' + '''' + CONVERT(VARCHAR(200),@DateStr) + ''''
									+ ',' + '''' + CONVERT(VARCHAR(200),@usrhora) + ''''
									+ ', 0'
									+ ', 0'
									+ ', 0'
									+ ', ' + '''' + '' + '''' 
									+ ', 0'
									+ ')'
				
									EXEC sp_executesql @InsertNS_boma
									
									IF @@ERROR <> 0 OR COALESCE(@InsertNS_boma,'') = ''
									BEGIN
										SET @ErrorMessage = 'Erro ao adicionar BOMA!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

										RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
									END

									FETCH NEXT
									FROM curNumsSerie
									INTO @NumSerie
								END

								CLOSE curNumsSerie

								DEALLOCATE curNumsSerie
							END
							ELSE
							BEGIN
								IF LTRIM(@Serial) = ''
								BEGIN
									SET @ErrorMessage = 'O número de série do Artigo ' + @Ref + ' não foi indicado.'

									RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)		
								END

								WAITFOR DELAY '00:00:00.200'

								SET @DateTimeTmp_SN = GETDATE()
								SET @DateStr_SN = dbo.u_Kapps_DateToString(@DateTimeTmp_SN)
								SET @TimeStr_SN = dbo.u_Kapps_TimeToString(@DateTimeTmp_SN)
								SET @NewStamp_BOMA = 'Syslog_' + @DateStr_SN + @TimeStr_SN
								SET @NewStamp_Ma = ''
								SET @StampMaCount = 0

								IF (@EntityType = 'F') OR (@EntityType = 'FL')
								BEGIN
									SET @foserie = 1
									SET @ftserie = 0
									--
									-- Se for receção e já existe o serial então é uma reentrada
									-- gera novo @NewStamp_Ma
									--
									SELECT @StampMaCount = COUNT(*)
									FROM ma WITH (NOLOCK)
									WHERE serie = @Serial

									IF @StampMaCount > 0
									BEGIN
										WAITFOR DELAY '00:00:00.200'

										SET @DateTimeTmp_Ma = GETDATE()
										SET @DateStr_Ma = dbo.u_Kapps_DateToString(@DateTimeTmp_Ma)
										SET @TimeStr_Ma = dbo.u_Kapps_TimeToString(@DateTimeTmp_Ma)
										SET @NewStamp_Ma = 'Syslog_' + @DateStr_Ma + @TimeStr_Ma
									END
								END
								ELSE
								BEGIN
									IF (@EntityType = 'C') OR (@EntityType = 'CL')
									BEGIN
										SET @foserie = 0
										SET @ftserie = 1
										SET @ccusto = ''
										--
										-- há um triger que RE_cria o registo do ma se passarmos no boma o mastamp original (da entrada)
										--
										SELECT @NewStamp_Ma = mastamp
										FROM ma WITH (NOLOCK)
										WHERE serie = @Serial
									END
								END

								SET @recnum_boma = 1
								--
								-- Insere os números de série
								--
								SET @InsertNS_boma ='INSERT INTO boma (bomastamp, bostamp, bistamp '
								+ ', serie, serie2, ref, design'
								+ ', marca, maquina, tipo '
								+ ', fref, ccusto, ncusto, situacao '
								+ ', nome, no, estab, nmdos, obrano'
								+ ', dataobra, armazem, ar2mazem, bdemp '
								+ ', ctrmastamp, mastamp, ndos, foserie '
								+ ', ftserie, trfarm, retequi, producao '
								+ ', refprod, recnum, obs, user1, user2 '
								+ ', user3, user4, emconf '
								+ ', ousrinis, ousrdata '
								+ ', ousrhora, usrinis '
								+ ', usrdata, usrhora '
								+ ', marcada, trocaequi, ocliequi, maserierpl, serprvef) '
								+ 'VALUES('
								+ '''' + @NewStamp_BOMA + ''''
								+ ',' + '''' + @NewBoStamp + ''''
								+ ',' + ''''+ @StampLin + ''''
								+ ',' + '''' + CONVERT(VARCHAR(200),@Serial) + ''''
								+ ',' + '''' + '' + ''''
								+ ',' + '''' + @Ref + ''''
								+ ',' + '''' + REPLACE(@Description, '''', '''''') + ''''
								+ ',' + '''' + @usr1 + ''''
								+ ',' + '''' + @usr2 + ''''
								+ ',' + '''' + 'M' + ''''
								+ ',' + '''' + '' + ''''
									+ ',' + '''' + @ccusto + ''''
								+ ',' + '''' + '' + ''''
								+ ',' + '''' + 'em intervenção' + ''''
								+ ',' + '''' + REPLACE(@EntNome, '''', '''''') + ''''
								+ ',' + CONVERT(VARCHAR(200),CAST(@EntityNumber as int)) 
								+ ', 0'
								+ ', ' + '''' + @nmdos + '''' 
								+ ',' + '''' + CONVERT(VARCHAR(200),@obrano) + ''''
								+ ',' + '''' + CONVERT(VARCHAR(200),@DateStr) + ''''
								+ ',' + CONVERT(VARCHAR(200),CAST(@Warehouse as int))
								+ ', 0'   --+ CONVERT(VARCHAR(200),CAST(@WarehouseOut as int))
								+ ', ' + '''' + @bdemp + '''' 
								+ ', ' + '''' + '' + '''' 
									+ ', ' + '''' + @NewStamp_Ma + '''' 
								+ ',' + CONVERT(VARCHAR(200),CAST(@ndos as int))
									+ ',' + CONVERT(VARCHAR(200),CAST(@foserie as int))
									+ ',' + CONVERT(VARCHAR(200),CAST(@ftserie as int))
								+ ', 0'
								+ ', 0'
								+ ', ' + CONVERT(VARCHAR(1),CAST(@IsFinalProductBOM as int))
								+ ', 0'
								+ ',' + CONVERT(VARCHAR(200),CAST(@recnum_boma as int)) 
								+ ', ' + '''' + '' + '''' 
								+ ', ' + '''' + '' + '''' 
								+ ', ' + '''' + '' + '''' 
								+ ', ' + '''' + '' + '''' 
								+ ', ' + '''' + '' + '''' 
								+ ', 0'
								+ ', ' + '''' + @ousrinis + '''' 
								+ ',' + '''' + CONVERT(VARCHAR(200),@DateStr) + ''''
								+ ',' + '''' + CONVERT(VARCHAR(200),@ousrhora) + ''''
								+ ', ' + '''' + @usrinis + '''' 
								+ ',' + '''' + CONVERT(VARCHAR(200),@DateStr) + ''''
								+ ',' + '''' + CONVERT(VARCHAR(200),@usrhora) + ''''
								+ ', 0'
								+ ', 0'
								+ ', 0'
								+ ', ' + '''' + '' + '''' 
								+ ', 0'
								+ ')'
				
								EXEC sp_executesql @InsertNS_boma
								
								IF @@ERROR <> 0 OR COALESCE(@InsertNS_boma,'') = ''
								BEGIN
									SET @ErrorMessage = '[1557] Erro ao adicionar BOMA!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

									RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
								END

								SET @Serials_Join = @Serial
							END
						END

						--
						-- Insere a linha no dossier
						--
						SET @InsertQry = 'INSERT INTO bi (bistamp, bostamp, nmdos, obrano, ref, design'
						+ ', lordem, ndos, no, armazem, qtt, ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora, lote, rescli, resfor, bofref'
						+ ', eprorc, prorc, epu, pu, edebito, debito, edebitoori, debitoori, eslvu, slvu, ettdeb, ttdeb, esltt, sltt'
						+ ', OBISTAMP, oobistamp, epcusto, pcusto, lobs, desconto, desc2, desc3, desc4, desc5, desc6'
						+ ', eVALDESC, tabiva, iva, usalote, sTipo, dataobra, dataopen, usr1, usr2, usr3, usr4, usr5, usr6, unidade, AR2MAZEM'
						+ ', rData, stns, unidad2, local, morada, codpost, familia, ccusto, zona, nome, noserie, series, ivaincl, ecustoind, custoind, segmento'
						+ @LIN_USER_FIELD1_INTEGRATION_NAME + @LIN_USER_FIELD2_INTEGRATION_NAME + @LIN_USER_FIELD3_INTEGRATION_NAME + @LIN_USER_FIELD4_INTEGRATION_NAME + @LIN_USER_FIELD5_INTEGRATION_NAME 
						+ @LIN_USER_FIELD6_INTEGRATION_NAME + @LIN_USER_FIELD7_INTEGRATION_NAME + @LIN_USER_FIELD8_INTEGRATION_NAME + @LIN_USER_FIELD9_INTEGRATION_NAME + @LIN_USER_FIELD10_INTEGRATION_NAME 
						+ @LIN_USER_FIELD11_INTEGRATION_NAME + @LIN_USER_FIELD12_INTEGRATION_NAME + @LIN_USER_FIELD13_INTEGRATION_NAME + @LIN_USER_FIELD14_INTEGRATION_NAME + @LIN_USER_FIELD15_INTEGRATION_NAME 
						+ ', producao)' 
						+ 'VALUES('''+ @StampLin + ''', ''' + @NewBoStamp + ''', ''' + @nmdos + ''', ' + CAST(@obrano as VARCHAR(200)) + ', ''' + @Ref + ''', ''' + REPLACE(@Description, '''', '''''')
						+ ''', ' + CAST(@lordem * 10000 as VARCHAR(200))
						+ ', ''' + @ndos + ''', ''' + @EntityNumber + ''', ''' + @Warehouse 
						+ ''', ' + CAST(@Qty as VARCHAR(200)) + ', ''' + CAST(@ousrinis as VARCHAR(100)) + ''', ''' + CAST(@ousrdata as VARCHAR(200))
						+ ''', ''' + CAST(@ousrhora as VARCHAR(200))+ ''', ''' + CAST(@usrinis as VARCHAR(200))+ ''', ''' + CAST(@usrdata as VARCHAR(200))+ ''', ''' + CAST(@usrhora as VARCHAR(200))+ ''', ''' + @Lot 
						+ ''', ''' + CAST(@rescli as VARCHAR(200))+ ''', ''' + CAST(@resfor as VARCHAR(200))+ ''', ''' + @bofRef 
						+ ''', ''' + CAST(@eprorc as VARCHAR(200))+ ''', ''' + CAST(@prorc as VARCHAR(200)) + ''', ''' + CAST(@epu as VARCHAR(200))+ ''', ''' + CAST(@pu as VARCHAR(200))
						+ ''', ''' + CAST(@edebito as VARCHAR(200))+ ''', ''' + CAST(@debito as VARCHAR(200))+ ''', ''' + CAST(@edebitoori as VARCHAR(200))
						+ ''', ''' + CAST(@debitoori as VARCHAR(200))+ ''', ''' + CAST(@eslvu as VARCHAR(200))+ ''', ''' + CAST(@slvu as VARCHAR(200))+ ''', ''' + CAST(@ettdeb as VARCHAR(200))
						+ ''', ''' + CAST(@ttdeb as VARCHAR(200))+ ''', ''' + CAST(@esltt as VARCHAR(200))+ ''', ''' + CAST(@sltt as VARCHAR(200))
						+ ''', ''' + @StampBi + ''', ''' + @StampBi + ''', ''' + CAST(@epcusto as VARCHAR(200)) + ''', ''' + CAST(@pcusto as VARCHAR(200)) + ''', ''' + @lobs 
						+ ''', ''' + CAST(@desconto as VARCHAR(200))+ ''', ''' + CAST(@desc2 as VARCHAR(200))+ ''', ''' + CAST(@desc3 as VARCHAR(200))+ ''', ''' + CAST(@desc4 as VARCHAR(200))
						+ ''', ''' + CAST(@desc5 as VARCHAR(200))+ ''', ''' + CAST(@desc6 as VARCHAR(200))+ ''', ''' + CAST(@eVALDESC as VARCHAR(200))
						+ ''', ''' + CAST(@tabiva as VARCHAR(200))+ ''', ''' + CAST(@iva as VARCHAR(200))+ ''', ''' + CAST(@usalote as VARCHAR(200))+ ''', ''' + CAST(CAST(@sTipo as int) as VARCHAR(200)) 
						+ ''', ''' + CAST(@DateStr as VARCHAR(200))+ ''', ''' + CAST(@DateStr as VARCHAR(200))+ ''', ''' + @usr1 + ''', ''' + @usr2 + ''', ''' + @usr3 + ''', ''' + @usr4 + ''', ''' + @usr5 + ''', ''' + @usr6 
						+ ''', ''' + CAST(@unidade as VARCHAR(200)) + ''', ''' + @WarehouseOut + ''', ''' + CAST(@usrdata as VARCHAR(200))+ ''', ''' + CAST(@ArtigodeServicos as VARCHAR(200))
						+ ''', ''' + CAST(@Qty2UM as VARCHAR(200))+ ''', ''' + @local + ''', ''' + @morada + ''', ''' + @codpost + ''', ''' + @familia + ''', ''' + @ccusto + ''', ''' + @zona 
						+ ''', ''' + REPLACE(@EntNome, '''', '''''') + ''', ''' + CAST(@UsaNumSerie as VARCHAR(200)) + ''', ''' + @Serials_Join + ''', ''' + CAST(@ivaincl as VARCHAR(200)) + ''', ''' + CAST(@ecustoind as VARCHAR(200)) 
						+ ''', ''' + CAST(@custoind as VARCHAR(200))+ ''', ''' + CAST(@segmento as VARCHAR(200))+ ''''
						+ CAST(@values_Lin as VARCHAR(200)) + ','''+ CAST(CAST(@IsFinalProductBOM as int) as VARCHAR(200)) +''')'
						
						EXEC sp_executesql @InsertQry

						IF @@ERROR <> 0 OR COALESCE(@InsertQry,'') = ''
						BEGIN
							SET @ErrorMessage = 'Erro ao adicionar BI!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END

						INSERT INTO bi2 (bi2stamp, bostamp, LOCAL, morada, codpost)
						VALUES (@StampLin, @NewBoStamp, @bi2local, @bi2morada, @bi2codpost)
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = 'Erro ao adicionar BI2!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END
						--
						-- atualiza a quantidade de origem
						--
						IF ((@DocTipo = 'DCO') AND (@StampBi <> ''))
						BEGIN
							UPDATE bi
							SET fechada = 0, datafecho = @DateTimeTmp, fdata = @DateStr, nmdoc = @nmdos, fno = @obrano, ndoc = CAST(@ndos AS INT)
							WHERE bistamp = @StampBi
							
							IF @@ERROR <> 0
							BEGIN
								SET @ErrorMessage = '[-1] Erro ao atualizar BI!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

								RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
							END

							UPDATE bi
							SET fechada = (CASE WHEN qtt <= qtt2 THEN 1 ELSE 0 END)
							WHERE bistamp = @StampBi
							
							IF @@ERROR <> 0
							BEGIN
								SET @ErrorMessage = '[-2] Erro ao atualizar BI!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

								RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
							END
						END
						--
						-- coloca o documento como integrado
						--
						UPDATE u_Kapps_DossierLin
						SET Integrada = 'S', Status = 'F', DataIntegracao = @DateStr, HoraIntegracao = SUBSTRING(@TimeStr, 1, 6), UserIntegracao = @InUserIntegracao, StampDocGer = RIGHT(@NEWnmdos + ' ' + CAST(@NEWobrano AS VARCHAR), 50), KeyDocGerado = @NewBoStamp
						WHERE StampLin = @StampLin
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = '[Integrar e fechar] Erro ao atualizar DossierLin!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END

						IF (@DocTipo = 'DCO')
						BEGIN
							EXECUTE SP_u_Kapps_DossiersLinUSR @DocTipo, @StampBo, @ndos, @fecha, @NewBoStamp, @StampLin, @Ref, @lordem, @StampBi
						END
						ELSE
						BEGIN
							EXECUTE SP_u_Kapps_DossiersLinUSR @DocTipo, @InternalStampDoc, @ndos, @fecha, @NewBoStamp, @StampLin, @Ref, @lordem, ''
						END

						SET @StampFinalLinha = @StampLin
						SET @lordemFinal = @lordem
					END
					ELSE
					BEGIN
						--SET @ettdeb = ROUND((@Qtyfinal * (((((((@edebito) * ((100 - @desconto) / 100)) * ((100 - @desc2) / 100)) * ((100 - @desc3) / 100)) * ((100 - @desc4) / 100)) * ((100 - @desc5) / 100)) * ((100 - @desc6) / 100)) - @eVALDESC), @predec)
						DECLARE @QtdTotal NUMERIC(18, 3)

						SET @QtdTotal = @Qtyfinal

						IF (@UseWeight = 1)
						BEGIN
							SET @QtdTotal = @Pesofinal
						END
						SET @ettdeb = (@QtdTotal * (((((((@edebito) * ((100 - @desconto) / 100)) * ((100 - @desc2) / 100)) * ((100 - @desc3) / 100)) * ((100 - @desc4) / 100)) * ((100 - @desc5) / 100)) * ((100 - @desc6) / 100)) - @eVALDESC)
						SET @ttdeb = dbo.u_Kapps_EurToEsc(@ettdeb)
						--
						-- atualiza a quantidade de origem
						--
						UPDATE bi
						SET qtt = @QtdTotal, eprorc = @eprorc, epu = @epu, pu = @pu, edebito = @edebito, debito = @debito, edebitoori = @edebitoori, debitoori = @debitoori, eslvu = @eslvu, slvu = @slvu, ettdeb = @ettdeb, ttdeb = @ttdeb, esltt = @esltt, sltt = @sltt, epcusto = @epcusto, desconto = @desconto, desc2 = @desc2, desc3 = @desc3, desc4 = @desc4, desc5 = @desc5, desc6 = @desc6, eVALDESC = @eVALDESC
						WHERE bistamp = @StampFinalLinha
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = '[#1] Erro ao atualizar BI!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END

						IF ((@DocTipo = 'DCO') AND (@StampBi <> ''))
						BEGIN
							UPDATE bi
							SET fechada = 0, datafecho = @DateTimeTmp, fdata = @DateStr, nmdoc = @nmdos, fno = @obrano, ndoc = CAST(@ndos AS INT)
							WHERE bistamp = @StampBi
							
							IF @@ERROR <> 0
							BEGIN
								SET @ErrorMessage = '[#2] Erro ao atualizar BI!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

								RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
							END

							UPDATE bi
							SET fechada = (CASE WHEN qtt <= qtt2 THEN 1 ELSE 0 END)
							WHERE bistamp = @StampBi
							
							IF @@ERROR <> 0
							BEGIN
								SET @ErrorMessage = '[#3] Erro ao atualizar BI!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

								RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
							END
						END
						--
						-- coloca o documento como integrado
						--
						UPDATE u_Kapps_DossierLin
						SET Integrada = 'S', Status = 'F', DataIntegracao = @DateStr, HoraIntegracao = SUBSTRING(@TimeStr, 1, 6), UserIntegracao = @InUserIntegracao, StampDocGer = RIGHT(@NEWnmdos + ' ' + CAST(@NEWobrano AS VARCHAR), 50), KeyDocGerado = @NewBoStamp
						WHERE StampLin = @StampLin
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = '[Integrar e fechar 2] Erro ao atualizar DossierLin!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END

						IF (@DocTipo = 'DCO')
						BEGIN
							EXECUTE SP_u_Kapps_DossiersLinUSR @DocTipo, @StampBo, @ndos, @fecha, @NewBoStamp, @StampFinalLinha, @Ref, @lordemFinal, @StampBi
						END
						ELSE
						BEGIN
							EXECUTE SP_u_Kapps_DossiersLinUSR @DocTipo, @InternalStampDoc, @ndos, @fecha, @NewBoStamp, @StampFinalLinha, @Ref, @lordemFinal, ''
						END
					END

					SET @oldStampBo = @StampBo
					SET @oldStampBi = @StampBi
					SET @oldRef = @Ref
					SET @oldLot = @Lot
					SET @oldWarehouse = @Warehouse
					SET @oldWarehouseOut = @WarehouseOut
					SET @oldLocation = @Location
					SET @oldLocationOut = @LocationOut
					SET @oldSerial = @Serial

					IF @TipoProcesso IN ('PICKTRANSF', 'TRANSF') AND RTRIM(LTRIM(@SSCC)) <> ''
					BEGIN
						UPDATE u_Kapps_PackingHeader
						SET CurrentWarehouse = @WarehouseOut, CurrentLocation = @LocationOut
						WHERE SSCC = @SSCC
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = '[1758] Erro ao atualizar PackingHeader!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END
					END
					--
					-- Atualizar estado das paletes
					--
					IF @TipoProcesso IN ('PICKING', 'PACKING') AND RTRIM(LTRIM(@SSCC)) <> '' AND RTRIM(LTRIM(@CustomerNumber)) <> '' AND ((@EntityType = 'C') OR (@EntityType = 'CL'))
					BEGIN
						SELECT @IsCustomerInternal = COALESCE(InternalCustomer, 0)
						FROM v_Kapps_Customers
						WHERE Code = @CustomerNumber

						IF @IsCustomerInternal = 0
						BEGIN
							UPDATE u_Kapps_PackingHeader
							SET PackStatus = 3
							WHERE SSCC = @SSCC
							
							IF @@ERROR <> 0
							BEGIN
								SET @ErrorMessage = '[1779] Erro ao atualizar PackingHeader!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

								RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
							END
						END
					END

					FETCH NEXT
					FROM curKappsDossiers INTO @StampLin,@StampBo,@StampBi,@Ref,@Description,@Qty,@Lot,@Serial,@UserID,@MovDate,@MovTime,@Status,@DocType,@DocNumber,@Integrada,@DataIntegracao,@HoraIntegracao,@UserIntegracao,@Validade,@Warehouse,@Location,@ExternalDocNum,@EntityType,@EntityNumber,@InternalStampDoc,@DestinationDocType, @VatNumber, @UnitPrice, @WarehouseOut, @LocationOut, @OriLineNumber, @QtyUM, @Qty2, @Qty2UM, @descarga, @Peso, @SSCC
						, @CabUF1, @CabUF2, @CabUF3, @CabUF4, @CabUF5, @CabUF6, @CabUF7, @CabUF8, @CabUF9, @CabUF10, @CabUF11, @CabUF12, @CabUF13, @CabUF14, @CabUF15
						, @LinUF1, @LinUF2, @LinUF3, @LinUF4, @LinUF5, @LinUF6, @LinUF7, @LinUF8, @LinUF9, @LinUF10, @LinUF11, @LinUF12, @LinUF13, @LinUF14, @LinUF15
						, @IsFinalProductBOM
				END

				IF @NewBoStamp <> ''
				BEGIN
					IF (@StampBo <> '')
					BEGIN
						--
						-- vai buscar os dados para o cabecalho
						--
						IF (@DocTipo = 'DCO')
						BEGIN
							SELECT @obs = obs, @tpdesc = tpdesc
							FROM BO WITH (NOLOCK)
							WHERE bostamp = @StampBo
						END
						--
						-- fechar o dossier
						--
						IF ((@DocTipo = 'DCO') AND ((@fecha = 'F')))
						BEGIN
							UPDATE bo
							SET fechada = 1, datafecho = @DateStr
							WHERE bostamp = @StampBo
							
							IF @@ERROR <> 0
							BEGIN
								SET @ErrorMessage = '[1810] Erro ao atualizar BO!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

								RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
							END

							UPDATE bi
							SET fechada = 1, datafecho = @DateStr
							WHERE bostamp = @StampBo
							
							IF @@ERROR <> 0
							BEGIN
								SET @ErrorMessage = '[1821] Erro ao atualizar BI!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

								RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
							END
						END
					END
					--
					-- Atualiza documento baseado na ficha técnica
					--
					IF ((@TipoProcesso = 'PRODUCTION') AND (@tmpDTA_ORIGIN = '1'))
					BEGIN
						UPDATE u_Kapps_tBOM_Header  SET [Status] = 1  WHERE BOMKey = @InStampDoc AND [Status] = 0
						
						IF @@ERROR <> 0
						BEGIN
							SET @ErrorMessage = 'Erro ao atualizar BillOfMaterial!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

							RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
						END
					END


					UPDATE bo SET sdeb4 = dbo.u_Kapps_EurToEsc(@etotaldeb), esdeb4 = @etotaldeb, etotaldeb = @etotaldeb, totaldeb = dbo.u_Kapps_EurToEsc(@etotaldeb), ebo_2tvall = @etotaldeb, 
					bo_2tvall = dbo.u_Kapps_EurToEsc(@etotaldeb), ebo_totp2 = @etotal, descc = dbo.u_Kapps_EurToEsc(@edescc), edescc = @edescc, memissao = 'EURO',
					ebo12_bins = @ebo12_bins, ebo12_iva= @ebo12_iva, bo12_bins = dbo.u_Kapps_EurToEsc(@ebo12_bins), bo12_iva= dbo.u_Kapps_EurToEsc(@ebo12_iva),
					ebo22_bins = @ebo22_bins, ebo22_iva= @ebo22_iva, bo22_bins = dbo.u_Kapps_EurToEsc(@ebo22_bins), bo22_iva= dbo.u_Kapps_EurToEsc(@ebo22_iva),
					ebo32_bins = @ebo32_bins, ebo32_iva= @ebo32_iva, bo32_bins = dbo.u_Kapps_EurToEsc(@ebo32_bins), bo32_iva= dbo.u_Kapps_EurToEsc(@ebo32_iva),
					ebo42_bins = @ebo42_bins, ebo42_iva= @ebo42_iva, bo42_bins = dbo.u_Kapps_EurToEsc(@ebo42_bins), bo42_iva= dbo.u_Kapps_EurToEsc(@ebo42_iva),
					ebo52_bins = @ebo52_bins, ebo52_iva= @ebo52_iva, bo52_bins = dbo.u_Kapps_EurToEsc(@ebo52_bins), bo52_iva= dbo.u_Kapps_EurToEsc(@ebo52_iva),
					ebo62_bins = @ebo62_bins, ebo62_iva= @ebo62_iva, bo62_bins = dbo.u_Kapps_EurToEsc(@ebo62_bins), bo62_iva= dbo.u_Kapps_EurToEsc(@ebo62_iva)
					WHERE bostamp = @NewBoStamp
					
					IF @@ERROR <> 0
					BEGIN
						SET @ErrorMessage = '[1854] Erro ao atualizar BO!' + ' ' + COALESCE(ERROR_MESSAGE(),'')

						RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
					END 

					EXECUTE SP_u_Kapps_DocDossInternIVAs  @NewBoStamp, @iva1, @ebo12_bins, @ebo12_iva, @iva2, @ebo22_bins, @ebo22_iva, @iva3, @ebo32_bins, @ebo32_iva, @iva4, @ebo42_bins, @ebo42_iva, @iva5, @ebo52_bins, @ebo52_iva, @iva6, @ebo62_bins, @ebo62_iva, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora

					SET @resultCode = 'OK'
					SET @resultMsg = ''
				END

				CLOSE curKappsDossiers

				DEALLOCATE curKappsDossiers
			END
		END

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

		SET @resultCode = 'NOK'
		SET @resultMsg = @ErrorMessage
		SET @NewBoStamp = ''
		SET @obrano = ''

		ROLLBACK TRANSACTION

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		INSERT INTO u_Kapps_Log (LogStamp, LogType, LogMessage, LogDetail, LogTerminal, LogIsError)
		VALUES (CONVERT(VARCHAR, GETDATE(), 112) + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''), 10, '''' + RTRIM(@DocTipo) + ''', ''' + RTRIM(@InStampDoc) + ''', ''' + RTRIM(@ndos) + ''', ''' + RTRIM(@fecha) + ''', ''' + RTRIM(@terminal) + ''', ''' + RTRIM(@integra) + ''', ''' + RTRIM(@ParameterGroup) + ''', ''' + RTRIM(@InUserIntegracao) + ''', ''' + RTRIM(@ExpeditionWarehouse) + ''', ''' + RTRIM(@ExpeditionLocation) + '''', RTRIM(@ErrorMessage), @Terminal, 1)

		IF @@ERROR <> 0
		BEGIN
			SET @resultMsg = @resultMsg + 'Erro ao adicionar Log!' + ' ' + COALESCE(ERROR_MESSAGE(),'')
		END
	END CATCH

	--
	-- Deve retornar apenas um result set com 
	--
	-- @resultCode 		OK ou NOK 
	-- @resultMsg 		Descrição do erro
	-- @NewBoStamp		Stamp do documento gerado
	-- @obrano			Numero do documento gerado
	--
	SELECT @resultCode, @resultMsg, @NewBoStamp, @obrano
END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasContagemUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_LinhasContagemUSR
  @StampHeader CHAR(25),
  @Sticstamp CHAR(25)
AS
BEGIN
	SET NOCOUNT ON;

END
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ContagemUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_ContagemUSR
  @DocTipo CHAR(5),
  @StampHeader CHAR(25),
  @TipoDoc VARCHAR(50),
  @fecha CHAR(5),
  @terminal CHAR(5)
AS
BEGIN
	SET NOCOUNT ON;

END
GO
SET NOEXEC OFF
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasContagem') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasContagem
GO
CREATE PROCEDURE SP_u_Kapps_LinhasContagem
	@StampHeader CHAR(25),
	@Sticstamp CHAR(25),
	@UserIntegracao VARCHAR(50),
	@Terminal CHAR(5),
	@InternalStampDoc CHAR(50),
	@TipoContagem CHAR(1)	  
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @Ref VARCHAR(50)
	DECLARE @Description VARCHAR(255)
	DECLARE @Date DATE
	DECLARE @Qty NUMERIC(18,5)
	DECLARE @Warehouse VARCHAR(50)
	DECLARE @Localizacao VARCHAR(50)
	DECLARE @Lot VARCHAR(100)

	DECLARE @stilstamp CHAR(25)

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @OrigStampLin VARCHAR(50)
	DECLARE @StampLin VARCHAR(50)
	DECLARE @unidade VARCHAR(50)
	DECLARE @usalote INT

	WAITFOR DELAY '00:00:00.200'
	SET @ErrorMessage = ''
	SET @ErrorSeverity = 0
	SET @ErrorState = 0
	SET @DateTimeTmp = GETDATE()
				
	SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
	SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)

	SET @ousrinis = 'Syslog-' + @DateStr
	SET @usrinis = 'Syslog-' + @DateStr 
	SET @ousrdata = @DateStr
	SET @usrdata = @DateStr
	SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
	SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

	BEGIN TRY
		SELECT @Date=Data FROM stic WHERE sticstamp=@Sticstamp
		
		DECLARE curLinhasContagem CURSOR LOCAL STATIC READ_ONLY FOR
		SELECT lin.Ref, lin.Description, SUM(lin.Qty), lin.Warehouse, lin.location, lin.Lot, lin.OrigStampLin, art.BaseUnit, art.UseLots
		FROM u_Kapps_StockLines lin WITH(NOLOCK)
		LEFT JOIN v_Kapps_Articles art ON art.Code=lin.Ref
		WHERE lin.OrigStampHeader=@StampHeader and lin.InternalStampDoc = @InternalStampDoc and lin.Syncr<>'S'
		GROUP BY lin.Ref, lin.Description, lin.Warehouse, lin.location, lin.Lot, lin.OrigStampLin, art.BaseUnit, art.UseLots

		OPEN curLinhasContagem
		FETCH NEXT FROM curLinhasContagem INTO @Ref,@Description,@Qty,@Warehouse,@Localizacao,@Lot,@OrigStampLin,@unidade,@usalote
		WHILE @@FETCH_STATUS = 0
		BEGIN
			WAITFOR DELAY '00:00:00.200' 
			SET @DateTimeTmp = GETDATE()
			SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
			SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
			SET @stilstamp = 'Syslog_' + @DateStr + @TimeStr

			IF @TipoContagem='C'
			BEGIN			
				INSERT INTO stil (stilstamp, ref, design, data, stock, sticstamp, armazem, lote, ousrinis, usrinis, ousrdata, usrdata, ousrhora, usrhora, unidade, usalote)
				VALUES(@stilstamp, @Ref, @Description, @Date, @Qty, @Sticstamp, @Warehouse, @Lot, @ousrinis, @usrinis, @ousrdata, @usrdata, @ousrhora, @usrhora, @unidade, @usalote) 
			END	
			ELSE
			BEGIN
				UPDATE stil SET stock = stock + @Qty WHERE STICSTAMP = @StampHeader AND STILSTAMP = @OrigStampLin
			END
		  
			FETCH NEXT FROM curLinhasContagem INTO @Ref,@Description,@Qty,@Warehouse,@Localizacao,@Lot,@OrigStampLin,@unidade,@usalote
		END

		UPDATE u_Kapps_StockLines SET Syncr = 'S', Status='C', SyncrDate=GETDATE(), SyncrUser=@UserIntegracao WHERE OrigStampHeader = @StampHeader and InternalStampDoc = @InternalStampDoc
	
 
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		INSERT INTO u_Kapps_Log(LogStamp,LogType,LogMessage,LogDetail,LogTerminal, LogIsError)
		VALUES (CONVERT(VARCHAR, GETDATE(), 112) + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),10,''''+RTRIM(@StampHeader)+''', '''+RTRIM(@Sticstamp) +''', '''+ RTRIM(@UserIntegracao)+ '''', RTRIM(@ErrorMessage), @Terminal, 1)
		
		GOTO FIM
	END CATCH

	FIM:
		CLOSE curLinhasContagem
		DEALLOCATE curLinhasContagem
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Contagem') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Contagem
GO
CREATE PROCEDURE SP_u_Kapps_Contagem
	@DocTipo CHAR(5),
	@StampHeader CHAR(25),
	@TipoDoc VARCHAR(50),
	@fecha CHAR(5),
	@Terminal CHAR(5),
	@UserIntegracao VARCHAR(50),
	@InternalStampDoc CHAR(50),
	@TipoContagem CHAR(1) -- C-Cega	A-Assistida
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @resultCode CHAR(3)
	DECLARE @resultMsg NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @DocDate DATE
	DECLARE @Name VARCHAR(50)

	DECLARE @sticstamp CHAR(25)

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

	DECLARE @ERP VARCHAR(25)
	DECLARE @seccao VARCHAR(15)
	DECLARE @DocFound bit
	DECLARE @DocStamp VARCHAR(50)

	DECLARE @Qty int
	DECLARE @OrigStampLin VARCHAR(50)
	DECLARE @StampLin VARCHAR(50)


	WAITFOR DELAY '00:00:00.200'
	SET @resultCode = 'NOK'
	SET @resultMsg = 'Não foi gerado nenhum documento'
	SET @ErrorSeverity = 0
	SET @ErrorState = 0
	SET @DateTimeTmp = GETDATE()
	SET @DocFound = 0
				
	SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
	SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)

	SET @ousrinis = 'Syslog_' + @DateStr
	SET @usrinis = 'Syslog_' + @DateStr 
	SET @ousrdata = @DateStr
	SET @usrdata = @DateStr
	SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
	SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
	IF @InternalStampDoc<>''
	BEGIN
		SET @DocStamp=@InternalStampDoc
	END
	ELSE
	BEGIN
		SET @DocStamp=@StampHeader
	END

	SELECT @ERP = COALESCE(ParameterValue, '') from u_Kapps_Parameters WITH(NOLOCK) where ParameterGroup='MAIN' and ParameterId = 'ERP'

	IF (upper(@ERP) = 'PERSONALIZADO')
	BEGIN
		EXECUTE SP_u_Kapps_ContagemUSR @DocTipo, @StampHeader, @TipoDoc, @fecha, @Terminal, @UserIntegracao, @InternalStampDoc, @resultCode OUTPUT, @resultMsg OUTPUT
	END
	ELSE
	BEGIN
	
		BEGIN TRY

		BEGIN TRANSACTION

		IF(@TipoContagem = 'C')
		BEGIN
			DECLARE curContagem CURSOR LOCAL STATIC READ_ONLY FOR
			SELECT DocDate,Name FROM u_Kapps_StockDocs  WITH(NOLOCK) WHERE Stamp = @DocStamp  and Syncr <> 'S'
			OPEN curContagem
			FETCH NEXT FROM curContagem INTO @DocDate,@Name
			WHILE @@FETCH_STATUS = 0 
			BEGIN
				WAITFOR DELAY '00:00:00.200' 
				SET @DocFound = 1
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
				SET @sticstamp = 'Syslog_' + @DateStr + @TimeStr

				INSERT INTO stic (sticstamp, data, descricao, ousrinis, usrinis, ousrdata, usrdata, ousrhora, usrhora)
				VALUES(@sticstamp, @DocDate, @Name, @ousrinis, @usrinis, @ousrdata, @usrdata, @ousrhora, @usrhora)  

				EXEC SP_u_Kapps_LinhasContagem @StampHeader, @sticstamp, @UserIntegracao, @Terminal, @InternalStampDoc, @TipoContagem

				IF @InternalStampDoc<>''
				BEGIN
					UPDATE u_Kapps_StockDocs SET Syncr = 'S', Status = 'C' WHERE Stamp = @DocStamp
				END
				FETCH NEXT FROM curContagem INTO @DocDate,@Name
			END
		END
		ELSE
		BEGIN
			SELECT TOP 1 @DocFound=1 FROM u_Kapps_StockLines sl INNER JOIN stic st on st.sticstamp=sl.OrigStampHeader WHERE sl.OrigStampHeader=@StampHeader
			EXEC SP_u_Kapps_LinhasContagem @StampHeader, @sticstamp, @UserIntegracao, @Terminal, @InternalStampDoc, @TipoContagem
		END

		COMMIT TRANSACTION

		IF @DocFound = 1
		BEGIN
			SET @resultCode = 'OK'
			SET @resultMsg = ''
		END
		ELSE
		BEGIN
			SET @resultMsg = 'Documento de contagem não existe'	
			SET @ErrorSeverity = 16
			SET @ErrorState = 1
			RAISERROR (@resultMsg, @ErrorSeverity, @ErrorState)			
		END

		END TRY
		BEGIN CATCH
			SELECT @resultMsg = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
			IF @@TRANCOUNT >0
				ROLLBACK TRANSACTION
			SET @resultCode = 'NOK'
 
			RAISERROR (@resultMsg, @ErrorSeverity, @ErrorState)

			INSERT INTO u_Kapps_Log(LogStamp,LogType,LogMessage,LogDetail,LogTerminal, LogIsError)
			VALUES (CONVERT(VARCHAR, GETDATE(), 112) + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),10,''''+RTRIM(@DocTipo)+''', '''+RTRIM(@StampHeader) +''', '''+ RTRIM(@TipoDoc) +''', '''+ RTRIM(@fecha) +''', '''+ RTRIM(@terminal) +''', '''+ RTRIM(@UserIntegracao)+ ''', '''+RTRIM(@InternalStampDoc)+ '''', RTRIM(@resultMsg), @Terminal, 1)

			GOTO FIM
		END CATCH

		FIM:
			IF(@TipoContagem = 'C')
			BEGIN
				CLOSE curContagem
				DEALLOCATE curContagem
			END
	END
	SELECT @resultCode, @resultMsg
END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_PriceCheckingUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_PriceCheckingUSR
      @REFERENCIA CHAR(40),		--	REFERENCIA DO ARTIGO
      @ARMAZEM VARCHAR(50),		--	ARMAZÉM
      @UNIDADE VARCHAR(50)		--	UNIDADE
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @USESTOCK CHAR(1)
	DECLARE @PRICE DECIMAL(20,7)
	DECLARE @STOCK DECIMAL(20,7)
	DECLARE @LbUser1 VARCHAR(30)
	DECLARE @LbUser2 VARCHAR(30)

	SET @USESTOCK = 'N'	-- NO CASO DE SE UTILIZAR ESTE SP PARA DEVOLVER O STOCK DO ARMAZÉM ESTA VARIÁVEL DEVERÁ RETONAR S, CASO NÃO QUERIA VISUALIZAR O STOCK DEVE DEVOLVER N
	SET @PRICE = 0
	SET @STOCK = 0
	SET @LbUser1 = ''
	SET @LbUser2 = ''
	
	-- Colocar o código a partir deste ponto


	SELECT @PRICE, @USESTOCK, @STOCK, @LbUser1, @LbUser2
END
GO
SET NOEXEC OFF
GO



DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_ProductPriceUSR
	@REFERENCIA VARCHAR(40),	--	REFERENCIA DO ARTIGO
	@Lot VARCHAR(50),			--	LOTE DO ARTIGO
	@ARMAZEM VARCHAR(50),		--	ARMAZÉM
	@NRSERIE VARCHAR(50),		--	NÚMERO DE SÉRIE
	@QTD DECIMAL(20,7),			--	QUANTIDADE
	@CLIENTE VARCHAR(50),		--	CLIENTE
	@FORNECEDOR VARCHAR(50),	--	FORNECEDOR
	@EVENTO INT,				--	1(PICKING) OU 2(RECEPCAO) OU 3(PACKING) OU 4(OUTROS) OU 5(CONTAGEM) OU 6(CONSULTA STOCKS) OU 7(PALETES) OU 8(PICKTRANSF) 
	@DOCORIGEM VARCHAR(50),		--	EM OUTROS É O DOCUMENTO QUE O UTILZIADOR CRIOU
	@CABKEY VARCHAR(50),		--	CHAVE DO CABECALHO DO DOCUMENTO DE ORIGEM
	@LINEKEY VARCHAR(50),		--	CHAVE DA LINHA DO DOCUMENTO DE ORIGEM
	@BUSYUNIT VARCHAR(50)		--	UNIDADE MOVIMENTADA
AS
BEGIN
	SET NOCOUNT ON; ';
	
EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_ProductPriceUSR', @SPnewSQL, '', '', '', '';
GO


DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_ProductsUSR
	@REFERENCIA VARCHAR(40),	--	Referência do artigo
	@CHAVELINHA VARCHAR(50),	--	Chave da linha no formato StampBo*StampBi
	@STAMPLIN VARCHAR(50),		--	Stamp da linha u_Kapps_DossierLin
	@PACKID	VARCHAR(50),		--  Numero da caixa
	@LOTE	VARCHAR(50),		--  Lote
	@VALIDADE VARCHAR(50),		--  Validade
	@UNITWORK varchar(50)		--  Unidade selecionada
AS
BEGIN
	SET NOCOUNT ON; ';

EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_ProductsUSR', @SPnewSQL, '', '', '', '';
GO



DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_DossiersUSR
	@DocTipo CHAR(5),					-- Tipo do documento da aplicação (DCO ou DSO)
	@InternalStampDoc NVARCHAR(50),		-- Stamp do documento
	@ndos VARCHAR(50),					-- Tipo de dossier de destino
	@fecha CHAR(5),						-- Se encerra o documento de origem
	@bostamp CHAR(25),					-- Stamp do documento criado
	@terminal CHAR(5),					-- Terminal que está a sincronizar	
	@ParameterGroup CHAR(100),			-- Processo que está a sincronizar
	@UserIntegracao VARCHAR(50),		-- Utilizador que executou a integração
	@ExpeditionWarehouse NVARCHAR(50),	-- Armazem de expedição
	@ExpeditionLocation NVARCHAR(50),	-- Localização de expedição
	@resultCodeUSR VARCHAR(3) OUTPUT,	-- Codigo erro
	@resultMsgUSR VARCHAR(255) OUTPUT	-- Descrição erro								
AS
BEGIN
	SET NOCOUNT ON; ';

EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_DossiersUSR', @SPnewSQL, '@estadoUSR ', '@resultCodeUSR', '@descerroUSR', '@resultMsgUSR';
GO



IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'UpdateLineNumber'))
	DROP TRIGGER UpdateLineNumber
GO
CREATE TRIGGER UpdateLineNumber ON u_Kapps_PackingDetails
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE det set LineID = (SELECT MAX(abs(LineID)) + 1 FROM u_Kapps_PackingDetails) FROM u_Kapps_PackingDetails det JOIN inserted ins on det.StampLin = ins.StampLin and det.PackID = ins.PackID;
END	
GO
ALTER TABLE u_Kapps_PackingDetails ENABLE TRIGGER UpdateLineNumber
GO



IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'u_Kapps_DossierLin') AND name = N'IX_u_Kapps_DossierLin_QtdFilter')
	DROP INDEX IX_u_Kapps_DossierLin_QtdFilter ON u_Kapps_DossierLin WITH ( ONLINE = OFF )
GO
CREATE CLUSTERED INDEX IX_u_Kapps_DossierLin_QtdFilter ON u_Kapps_DossierLin
(
	Status ASC,
	Integrada ASC,
	StampBo ASC,
	StampBi ASC
)
GO



DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_ProductStockUSR
	@REFERENCIA VARCHAR(40),	--	REFERENCIA DO ARTIGO
	@Lot VARCHAR(50),			--	LOTE DO ARTIGO
	@ARMAZEM VARCHAR(50),		--	ARMAZÉM
	@NRSERIE VARCHAR(50),		--	NÚMERO DE SÉRIE
	@EVENTO INT,				--	1(PICKING) OU 2(RECEPCAO) OU 3(PACKING) OU 4(OUTROS) OU 5(CONTAGEM) OU 6(CONSULTA DE STOCKS)
	@LOCALIZACAO VARCHAR(50),	--	LOCALIZACAO
	@LISTA INT = 0				--  0(RETORNA APENAS UMA LINHA @STOCKAUSAR, @STOCK, @STOCKDISPONIVEL)
								--  1(RETORNA LINHAS com CodigoArmazem, NomeArmazem, Stock, StockDisponivel AGRUPADA por CodigoArmazem e ORDENADA POR NomeArmazem)
								--  2(RETORNA LINHAS com Localizacao, Lote, Stock, StockDisponivel AGRUPADA por Localizacao, Lote ORDENADA POR Localizacao)
								--  3(RETORNA LINHAS com Localizacao, Lote, Stock, StockDisponivel AGRUPADA por Localizacao, Lote ORDENADA POR Lote)
								--  4(RETORNA LINHAS com Lote, Stock, Validade, DataProducao, Armazem, Localizacao)
AS
BEGIN
	SET NOCOUNT ON; ';

EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_ProductStockUSR', @SPnewSQL, '', '', '', '';
GO



DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_PriceCheckingUSR
	@REFERENCIA VARCHAR(40),	--	REFERENCIA DO ARTIGO
	@ARMAZEM VARCHAR(50),		--	ARMAZÉM
	@UNIDADE VARCHAR(50)		--	UNIDADE
AS
BEGIN
	SET NOCOUNT ON; ';

EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_PriceCheckingUSR', @SPnewSQL, '', '', '', '';
GO
						


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_EliminaTabelaTemporaria') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_EliminaTabelaTemporaria
GO
CREATE PROCEDURE SP_u_Kapps_EliminaTabelaTemporaria
	@NomeTabela SYSNAME
AS
BEGIN
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb.dbo.'+@NomeTabela, 'U') IS NOT NULL
	BEGIN
		DECLARE @SQL NVARCHAR(100)
		SELECT @SQL = 'DROP TABLE ' + QUOTENAME(@NomeTabela) + '';
		EXEC sp_executesql @SQL;
	END
END
GO


DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_ContagemUSR
	@DocTipo CHAR(5),
	@StampHeader CHAR(25),
	@TipoDoc VARCHAR(50),
	@fecha CHAR(5),
	@terminal CHAR(5),
	@UserIntegracao VARCHAR(50),
	@InternalStampDoc VARCHAR(50),
	@resultCodeUSR VARCHAR(50) OUTPUT,
	@resultMsgUSR VARCHAR(1000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON; ';
							
EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_ContagemUSR', @SPnewSQL, '', '', '', '';
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_RefreshUsers') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_RefreshUsers 		-- Foi Eliminada
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_CriaTabelaTemporaria') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_CriaTabelaTemporaria
GO
CREATE PROCEDURE SP_u_Kapps_CriaTabelaTemporaria
	@NomeTabela nvarchar(50),
	@SQL nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;

	--SQL Server
	
	SET @SQL = 'SELECT * INTO '+@NomeTabela +' FROM (' + @SQL +')t WHERE 1=0';
	
	-- DB2
	/*
	SET @SQL = 'DECLARE GLOBAL TEMPORARY TABLE SESSION.' + @NomeTabela + ' AS (' + @SQL +') WITH NO DATA NOT LOGGED WITH REPLACE';
	SET @NomeTabela='QTEMP.'+@NomeTabela;
	*/
		
	SELECT @NomeTabela, @SQL
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_SSCCCheckDigit') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_SSCCCheckDigit
GO
CREATE FUNCTION u_Kapps_SSCCCheckDigit (@Barcode nvarchar(17)) 
RETURNS nvarchar(18) 
AS 
BEGIN 
    DECLARE @SUM int , @COUNTER int, @RETURN varchar(18), @Val1 int, @Val2 int 
    SET @COUNTER = 1 SET @SUM = 0 

    WHILE @Counter <= LEN(@Barcode) 
    BEGIN 
        IF (@COUNTER % 2) = 0
          SET @VAL1 = SUBSTRING(@Barcode,@counter,1) * 1 
        ELSE
          SET @VAL1 = SUBSTRING(@Barcode,@counter,1) * 3

        SET @SUM = @VAL1 + @SUM 
        SET @Counter = @Counter + 1; 
    END 
    SET @SUM=(10-(@SUM%10))%10

    SET @Return = @BARCODE + CONVERT(varchar,((@SUM))) 
    RETURN @Return 
END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DocumentUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_DocumentUSR
	  @KeyDocGerado NVARCHAR(50)    -- Key do documento gerado   
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Par1 VARCHAR(255)
	DECLARE @Par2 VARCHAR(255)
	DECLARE @Par3 VARCHAR(255)
	DECLARE @Par4 VARCHAR(255)
	DECLARE @Par5 VARCHAR(255)
	DECLARE @Par6 VARCHAR(255)
	DECLARE @Par7 VARCHAR(255)
	DECLARE @Par8 VARCHAR(255)
	DECLARE @Par9 VARCHAR(255)
	DECLARE @Par10 VARCHAR(255)

	SET @Par1 = ''
	SET @Par2 = ''
	SET @Par3 = ''
	SET @Par4 = ''
	SET @Par5 = ''
	SET @Par6 = ''
	SET @Par7 = ''
	SET @Par8 = ''
	SET @Par9 = ''
	SET @Par10 = ''

	-- Colocar o código a partir deste ponto
	

	SELECT @Par1, @Par2, @Par3, @Par4, @Par5, @Par6, @Par7, @Par8, @Par9, @Par10
END
GO
SET NOEXEC OFF
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_SSCC_NextNumberUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_SSCC_NextNumberUSR
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @NextNumber INT

	SET @NextNumber = -1

	-- Colocar o código a partir deste ponto


	SELECT @NextNumber
END
GO
SET NOEXEC OFF
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LoadingInsertSSCC') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LoadingInsertSSCC
GO
CREATE PROCEDURE SP_u_Kapps_LoadingInsertSSCC
	@LocationID nvarchar(50),
	@SSCC1 nvarchar(20),
	@SSCC2 nvarchar(20)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ActiveLoadNr int
	DECLARE @LocationActif int
	DECLARE @LoadStatus int
	DECLARE @Armazem nvarchar(50)

	DECLARE @resultCode int
	DECLARE @resultMsg nvarchar(250)

	DECLARE @stamp nvarchar(50)
	DECLARE @DocID nvarchar(50)
	DECLARE @NextDocID nvarchar(50)
	DECLARE @DocStatus int
	DECLARE @DocSequence int
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

	DECLARE @sql nvarchar(3000)
	DECLARE @inTransaction bit
	DECLARE @Recordcount int


	DECLARE @Article nvarchar(50)
	DECLARE @Description nvarchar(100)
	DECLARE @Quantity decimal(18,3)
	DECLARE @Unit nvarchar(50)
	DECLARE @Lot nvarchar(50)
	DECLARE @ExpirationDate nvarchar(8)
	DECLARE @SerialNumber nvarchar(50)
	DECLARE @NetWeight decimal(18,3)
	--DECLARE @Location nvarchar(50)
	DECLARE @CurrentWarehouse nvarchar(50)
	DECLARE @CurrentLocation nvarchar(50)
	DECLARE @Qtd decimal(18,3)
	DECLARE @QtdSatisfeita decimal(18,3)

	DECLARE @ID bigint
	DECLARE @LineID nvarchar(50)
	DECLARE @LineProductID nvarchar(50)
	DECLARE @LineLot nvarchar(50)
	DECLARE @LineQuantity decimal(18,3)
	DECLARE @LineQuantityUnit nvarchar(50)
	DECLARE @LineLoadedQuantity decimal(18,3)

	DECLARE @ActivoCurSSCC bit
	DECLARE @ActivoCurLINES bit
	DECLARE @AlreadyReadedSSCC1 nvarchar(18)
	DECLARE @AlreadyReadedSSCC2 nvarchar(18)
	DECLARE @Stock decimal(18,3)
	DECLARE @tempTable Table (TempStock decimal(18,3))
	DECLARE @CurrentSSCC nvarchar(18)
	DECLARE @ErrorID int
	DECLARE @TPD nvarchar(50)
	DECLARE @SEC nvarchar(50)
	DECLARE @NDC nvarchar(50)

	DECLARE @ProcessType varchar(25)

	SET @resultMsg = ''
	SET @resultCode = 0
	SET @DocID = ''
	SET @sql = ''
	SET @inTransaction = 0
	SET @ErrorID = 0
	SET @ActiveLoadNr = 0
	SET @TPD=''
	SET @SEC=''
	SET @NDC=''
	SET @ProcessType=''

	IF LEN(@SSCC1)=20
	BEGIN
		SET @SSCC1=RIGHT(@SSCC1,18)
	END
	IF LEN(@SSCC2)=20
	BEGIN
		SET @SSCC2=RIGHT(@SSCC2,18)
	END

	BEGIN TRY

		SELECT @LocationActif=l.Actif, @Armazem=l.WarehouseID, @LoadStatus=h.LoadStatus, @ActiveLoadNr=l.ActiveLoadNr, @DocID=d.DocID, @DocStatus=d.DocStatus, @DocSequence=d.LoadingSequence, @TPD=d.DocTPD, @SEC=d.DocSEC, @NDC=d.DocNDC
		,@AlreadyReadedSSCC1=(SELECT count(*) FROM u_Kapps_LoadingPallets lp LEFT JOIN u_Kapps_LoadingHeader h1 on h1.LoadNr=lp.LoadNr WHERE (lp.LoadNr=l.ActiveLoadNr OR (h1.LoadStatus<>1 and lp.LoadNr<>l.ActiveLoadNr)) and SSCC=@SSCC1)
		,@AlreadyReadedSSCC2=(SELECT count(*) FROM u_Kapps_LoadingPallets lp LEFT JOIN u_Kapps_LoadingHeader h1 on h1.LoadNr=lp.LoadNr WHERE (lp.LoadNr=l.ActiveLoadNr OR (h1.LoadStatus<>1 and lp.LoadNr<>l.ActiveLoadNr)) and SSCC=@SSCC2)
		,@ProcessType=h.ProcessType
		FROM u_Kapps_LoadingLocations l
		LEFT JOIN u_Kapps_LoadingDeliveryPoints d on d.LoadNr=l.ActiveLoadNr and d.Actif=1
		LEFT JOIN u_Kapps_LoadingHeader h on h.LoadNr=l.ActiveLoadNr

		WHERE l.LocationID=@LocationID;
		SET @Recordcount=@@ROWCOUNT

		IF @Recordcount=0
		BEGIN
			SET @ErrorID=1
			SET @resultMsg='Não existe o cais '+@LocationID
		END
		ELSE IF @Recordcount>1
		BEGIN
			SET @ErrorID=2
			SET @resultMsg='Mais do que um documento ativo' -- na tabela DeliveryPoints
		END
		ELSE IF @LocationActif is null or @LocationActif=0
		BEGIN
			SET @ErrorID=3
			SET @resultMsg='O cais não está ativo'
		END
		ELSE IF @LoadStatus is null or @LoadStatus=0
		BEGIN
			SET @ErrorID=4
			SET @resultMsg='Carga não está ativa'
		END
		ELSE IF ((@DocID is null or @DocID='') and @ProcessType<>'TRANSF')
		BEGIN
			SET @ErrorID=5
			SET @resultMsg='Nenhum documento ativo'
		END
		ELSE IF @SSCC1='' and @SSCC2=''
		BEGIN
			SET @ErrorID=6
			SET @resultMsg='Não foi enviado nenhum SSCC'
		END
		ELSE IF @SSCC1<>'' and LEN(@SSCC1)<>18
		BEGIN
			SET @ErrorID=7
			SET @resultMsg='Tamanho invalido do SSCC1'
		END
		ELSE IF @SSCC2<>'' and LEN(@SSCC2)<>18
		BEGIN
			SET @ErrorID=8
			SET @resultMsg='Tamanho invalido do SSCC2'
		END
		ELSE IF @AlreadyReadedSSCC1>0
		BEGIN
			SET @ErrorID=9
			SET @resultMsg='Palete '+@SSCC1+CHAR(13)+CHAR(10)+'já foi carregada'
		END
		ELSE IF @AlreadyReadedSSCC2>0
		BEGIN
			SET @ErrorID=9
			SET @resultMsg='Palete '+@SSCC2+CHAR(13)+CHAR(10)+'já foi carregada'
		END
		/*
		ELSE IF 
			SET @ErrorID=14
			SET @resultMsg='Palete 560121212121212122121 está bloqueada ou em quarentena'+CHAR(13)+CHAR(10)+Nota : A palete está bloqueada ou em quarentena, fale com o departamento de qualidade'
		ELSE IF 
			SET @ErrorID=15
			SET @resultMsg='Lote LD62123 é diferente do lote LD62124 indicado na encomenda'+CHAR(13)+CHAR(10)+'Nota : O lote indicado na encomenda e diferente do da palete que esta a carregar, fale com o departamento administrativa para limpar o lote da encomenda'
		ELSE IF 
			SET @ErrorID=16
			SET @resultMsg='Palete 560121212121212122121 não está disponível para este cliente, a palete está assignada ao cliente Pingo Doce Almada (121212212)'+CHAR(13)+CHAR(10)+'Nota : Esta palete está assignada a um cliente específicos, só pode ser enviada para o cliente indicado na palete, fale com o departamento administrativo caso deseje mudar o cliente assignado á palete'
		ELSE IF 
			SET @ErrorID=17
			SET @resultMsg='Palete 560121212121212122121 já foi expedida na carga xxxxxxxxxxxx, no cais xx'+CHAR(13)+CHAR(10)+'Nota : Esta palete já foi expedida noutra carga, fale com o departamento administrativo'
		ELSE IF 
			SET @ErrorID=18
			SET @resultMsg='Palete 560121212121212122121 já foi carregada na carga xxxxxxxxxxxx, no cais xx'+CHAR(13)+CHAR(10)+'Nota : Esta palete foi carregada na carga xx'
		ELSE IF 
			SET @ErrorID=19
			SET @resultMsg='Lote LD121212 está bloqueado'+CHAR(13)+CHAR(10)+'Nota : Este lote está bloqueado para expedição'
		ELSE IF 
			SET @ErrorID=20
			SET @resultMsg='Palete foi eliminada'+CHAR(13)+CHAR(10)+'Nota : esta palete foi eliminada , não é possível carregá-la'
		*/
		ELSE
		BEGIN
			BEGIN TRANSACTION
			SET @inTransaction=1
			SELECT @Recordcount=count(*) FROM u_Kapps__DummyLock (TABLOCKX)

			DECLARE curSSCC CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
			SELECT RTRIM(Article), Quantity, Unit, Lot, ExpirationDate, SerialNumber, NetWeight, CurrentWarehouse, CurrentLocation, HeaderSSCC
			FROM v_Kapps_SSCC_Lines WITH(NOLOCK) 
			WHERE (HeaderSSCC<>'') and ((HeaderSSCC=@SSCC1) or (HeaderSSCC=@SSCC2));
			OPEN curSSCC 
 			FETCH NEXT FROM curSSCC INTO @Article, @Quantity, @Unit, @Lot, @ExpirationDate, @SerialNumber, @NetWeight, @CurrentWarehouse, @CurrentLocation, @CurrentSSCC;
			SET @ActivoCurSSCC=1

			IF @@FETCH_STATUS <> 0
			BEGIN
				SET @ErrorSeverity = 16
				SET @ErrorState = 1
				SET @ErrorID=10
				SET @ErrorMessage = 'Palete '+@SSCC1+' não existe'+CHAR(13)+CHAR(10)+'Nota: Esta palete não existe no Syslog, verifique junto da sua área administrativa se a palete foi criada no SYSLOG'

				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)			
			END

			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- Verificar Stock
				/*
				IF (1=0) -- Forçar a verificação de stock com o armazem associado ao cais
				BEGIN
					SET @CurrentWarehouse=@Armazem
					SET @CurrentLocation=@Armazem
				END
				*/

				SET @sql= 'SELECT @TempStock=SUM(Total) FROM
				(
				SELECT COALESCE(SUM(Stock),0) as Total 
				FROM v_Kapps_Stock WITH(NOLOCK) 
				where Article = '''+RTRIM(@Article)+''' AND Warehouse='''+@CurrentWarehouse+''''
				IF @CurrentLocation<>''
					SET @sql=@sql+' and Location='''+@CurrentLocation+''''
				IF @Lot<>''
					SET @sql=@sql+' and Lote='''+@Lot+''''

				SET @sql=@sql+' UNION ALL 
				select COALESCE(sum(  CASE WHEN va.UseWeight=1 THEN -lin.NetWeight ELSE -(lin.qty-lin.InternalQty) END    ),0 ) AS Total 
				from u_Kapps_DossierLin lin WITH(NOLOCK) 
				left join v_Kapps_Articles va WITH(NOLOCK) ON va.Code=lin.Ref
				where lin.Ref = '''+RTRIM(@Article)+''' AND Warehouse='''+@CurrentWarehouse+''''
				IF @CurrentLocation<>''
					SET @sql=@sql+' and Location='''+@CurrentLocation+''''
				IF @Lot<>''
					SET @sql=@sql+' and Lot='''+@Lot+''''

				SET @sql=@sql+' AND lin.Integrada = ''N'' and lin.Status = ''A'' and (lin.EntityType = ''C'' OR lin.EntityType = '''')'

				/*
				UNION ALL
				select COALESCE(sum(CASE WHEN va.UseWeight=1 THEN lin.NetWeight ELSE lin.qty END),0 ) AS Total 
				from u_Kapps_DossierLin lin WITH(NOLOCK) 
				left join v_Kapps_Articles va WITH(NOLOCK) ON va.Code=lin.Ref
				where lin.Ref = '''+RTRIM(@Article)+''' AND WarehouseOUT='''+@CurrentWarehouse+''''
				IF @CurrentLocation<>''
					SET @sql=@sql+' and LocationOUT='''+@CurrentLocation+''''
				IF @Lot<>''
					SET @sql=@sql+' and Lot='''+@Lot+''''
				
				SET @sql=@sql+' AND lin.Integrada = ''N'' and lin.Status = ''A'' and lin.EntityType = ''''
				*/
				
				SET @sql=@sql+' 
				UNION ALL 

				select COALESCE(SUM(-lp.Qty),0)  
				from u_Kapps_LoadingHeader h WITH(NOLOCK) 
				LEFT JOIN u_Kapps_LoadingPallets lp WITH(NOLOCK) on lp.LoadNr=h.LoadNr 
				LEFT JOIN u_Kapps_LoadingLocations ll WITH(NOLOCK) on ll.LocationID=h.LoadLocation 
				where h.LoadStatus<>1 and ll.WarehouseID='''+ @CurrentWarehouse+''' 
				and lp.ProductID='''+RTRIM(@Article)+''''
				IF @Lot<>''
					SET @sql=@sql+' and lp.Lot='''+@Lot+''''

				SET @sql=@sql+' )temp'


				IF @ProcessType='LOADING'
				BEGIN
					SET @Qtd = @Quantity
					SET @QtdSatisfeita = 0
				
					DECLARE curLINES CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT id, LineID, ProductID, Lot, Quantity, Unit, LoadedQuantity /*, ExpirationDate, SerialNumber, NetWeight, Location*/
					FROM u_Kapps_LoadingLines WITH(NOLOCK)
					WHERE (LoadNr=@ActiveLoadNr) and (DocID=@DocID) and (ProductID=@Article) and (Lot=@Lot) and (Unit=@Unit);
					OPEN curLINES
 					FETCH NEXT FROM curLINES INTO @ID, @LineID, @LineProductID, @LineLot, @LineQuantity, @LineQuantityUnit, @LineLoadedQuantity;

					SET @ActivoCurLINES=1

					WHILE @@FETCH_STATUS = 0 and (@QtdSatisfeita<@Qtd)
					BEGIN
						IF @Qtd<=(@LineQuantity-@LineLoadedQuantity)
						BEGIN
							SET @QtdSatisfeita = @QtdSatisfeita + @Qtd
							UPDATE u_Kapps_LoadingLines 
							SET LoadedQuantity = @LineLoadedQuantity + @Qtd, PalletLoadedQuantity=/*CASE WHEN PalletUnit<>'' THEN */PalletLoadedQuantity+1 /*ELSE 0 END*/,
							LineStatus=CASE WHEN @LineQuantity= @LineLoadedQuantity + @Qtd THEN 1 ELSE LineStatus END
							WHERE id=@ID;

							INSERT INTO u_Kapps_LoadingPallets(LoadNr, DocID, LineID, SSCC, ProductID, Qty, Unit, Lot, ExpirationDate)
							VALUES (@ActiveLoadNr, @DocID, @LineID, @CurrentSSCC, @Article, @Qtd, @Unit, @Lot, @ExpirationDate)

							--
							-- Verificar Stock 
							--
							EXEC sp_executesql @sql, N'@tempStock decimal(18,3) OUTPUT' , @TempStock=@Stock OUTPUT; 

							IF (@Stock<0)
							BEGIN
								SET @ErrorID=11
								select @Description=REPLACE(RTRIM(Description),'%',' ') from v_Kapps_Articles WHERE Code=@Article
								SET @ErrorMessage = 'Não existe stock suficiente para o artigo '+@Description+' ('+@Article +')'
								IF @Lot<>''
								BEGIN
									SET @ErrorMessage = @ErrorMessage +' do lote '+@Lot
								END
								SET @ErrorMessage = @ErrorMessage + ' no armazém '+@CurrentWarehouse

								IF @CurrentLocation<>'' and @CurrentLocation<>@CurrentWarehouse
								BEGIN
									SET @ErrorMessage=@ErrorMessage+' localização '+@CurrentLocation
								END
								SET @ErrorMessage = @ErrorMessage +' (necessário '+CAST(@Quantity as varchar(20))+', stock de '+ CAST(@Stock as varchar(20))+')'

								SET @ErrorSeverity = 16
								SET @ErrorState = 1

								RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)			
							END
							--
							--
							--
						END

	 					FETCH NEXT FROM curLINES INTO @ID, @LineID, @LineProductID, @LineLot, @LineQuantity, @LineQuantityUnit, @LineLoadedQuantity;
					END

					/* abater noutro lote */

					IF (@Qtd<>@QtdSatisfeita) and (@Lot<>'')
					BEGIN
						CLOSE curLINES
						DEALLOCATE curLINES

						DECLARE curLINES CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
						SELECT [id], [LineID], [ProductID], [Lot], [Quantity], [Unit], [LoadedQuantity] /*, [ExpirationDate], [SerialNumber], [NetWeight], [Location]*/
						FROM u_Kapps_LoadingLines WITH(NOLOCK)
						WHERE (LoadNr=@ActiveLoadNr) and (DocID=@DocID) and (ProductID=@Article) and (Lot='') and (Unit=@Unit);
						OPEN curLINES
 						FETCH NEXT FROM curLINES INTO @ID, @LineID, @LineProductID, @LineLot, @LineQuantity, @LineQuantityUnit, @LineLoadedQuantity;

						SET @ActivoCurLINES=1
						WHILE @@FETCH_STATUS = 0 and (@QtdSatisfeita<@Qtd)
						BEGIN
							IF @Qtd<=(@LineQuantity-@LineLoadedQuantity)
							BEGIN
								SET @QtdSatisfeita = @QtdSatisfeita + @Qtd
								UPDATE u_Kapps_LoadingLines 
								SET LoadedQuantity = @LineLoadedQuantity + @Qtd, PalletLoadedQuantity=PalletLoadedQuantity+1,
								LineStatus=CASE WHEN @LineQuantity= @LineLoadedQuantity + @Qtd THEN 1 ELSE LineStatus END
								WHERE id=@ID;

								INSERT INTO u_Kapps_LoadingPallets(LoadNr, DocID, LineID, SSCC, ProductID, Qty, Unit, Lot, ExpirationDate)
								VALUES (@ActiveLoadNr, @DocID, @LineID, @CurrentSSCC, @Article, @Qtd, @Unit, @Lot, @ExpirationDate)

								--
								-- Verificar Stock 
								--
								EXEC sp_executesql @sql, N'@tempStock decimal(18,3) OUTPUT' , @TempStock=@Stock OUTPUT; 

								IF (@Stock<0)
								BEGIN
									SET @ErrorID=11
									select @Description=REPLACE(RTRIM(Description),'%',' ') from v_Kapps_Articles WHERE Code=@Article
									SET @ErrorMessage = 'Não existe stock suficiente para o artigo '+@Description+' ('+@Article +')'
									IF @Lot<>''
									BEGIN
										SET @ErrorMessage = @ErrorMessage +' do lote '+@Lot
									END
									SET @ErrorMessage = @ErrorMessage + ' no armazém '+@CurrentWarehouse

									IF @CurrentLocation<>'' and @CurrentLocation<>@CurrentWarehouse
									BEGIN
										SET @ErrorMessage=@ErrorMessage+' localização '+@CurrentLocation
									END
									SET @ErrorMessage = @ErrorMessage +' (necessário '+CAST(@Quantity as varchar(20))+', stock de '+ CAST(@Stock as varchar(20))+')'

									SET @ErrorSeverity = 16
									SET @ErrorState = 1

									RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)			
								END
							END

	 						FETCH NEXT FROM curLINES INTO @ID, @LineID, @LineProductID, @LineLot, @LineQuantity, @LineQuantityUnit, @LineLoadedQuantity;
						END
					END
				
					IF (@Qtd=@QtdSatisfeita)
					BEGIN
						IF NOT EXISTS (SELECT TOP 1 1 FROM u_Kapps_LoadingLines WHERE LoadNr=@ActiveLoadNr and DocID=@DocID and LineStatus=0 and LoadedQuantity<>Quantity)
						BEGIN
							UPDATE u_Kapps_LoadingDeliveryPoints SET Actif=0, DocStatus=1 WHERE LoadNr=@ActiveLoadNr and DocID=@DocID;
							UPDATE u_Kapps_LoadingDeliveryPoints SET Actif=1 WHERE LoadNr=@ActiveLoadNr and LoadingSequence=@DocSequence+1;
							IF (@@ROWCOUNT=0)
							BEGIN
								SET @NextDocID = '';
								SELECT TOP 1 @NextDocID=h.DocID
								FROM u_Kapps_LoadingDeliveryPoints h
								LEFT JOIN u_Kapps_LoadingLines l on l.LoadNr=h.LoadNr
								WHERE h.LoadNr=@ActiveLoadNr and l.LoadedQuantity<>l.Quantity and l.LineStatus<>2 
								ORDER BY h.LoadingSequence;

								IF @NextDocID<>''
								BEGIN
									UPDATE u_Kapps_LoadingDeliveryPoints SET Actif=1 WHERE LoadNr=@ActiveLoadNr and DocID=@NextDocID
								END
							END
						END
					END
					ELSE
					BEGIN
						select @Description=REPLACE(RTRIM(Description),'%',' ') from v_Kapps_Articles WHERE Code=@Article
						IF @QtdSatisfeita>0
						BEGIN
							SET @ErrorID=12
							SET @ErrorMessage = 'Não foi possível satisfazer a quantidade total do artigo '+@Description+' ('+RTRIM(@Article)+')';
						END
						ELSE
						BEGIN
							SET @ErrorID=13
							SET @ErrorMessage = 'Artigo '+@Description+' ('+@Article+') não faz parte do documento de carga ('+@TPD+' '+@SEC+'/'+@NDC+')' +CHAR(13)+CHAR(10)+'Nota : O(s) artigo(s) do SSCC não fazem parte da encomenda(s) selecionada(s) para a carga)'
						END

						IF @Lot<>''
						BEGIN
							SET @ErrorMessage=@ErrorMessage+CHAR(13)+CHAR(10)+'Lote '+@Lot
						END
					
						SET @ErrorSeverity = 16
						SET @ErrorState = 1

						SET @resultCode=0
						SET @resultMsg=@ErrorMessage
						IF @inTransaction=1
						BEGIN
							ROLLBACK TRANSACTION
							SET @inTransaction=0
						END

						GOTO FIM
						--RAISERROR (@ErrorMessage, @ErrorSev0erity, @ErrorState)
					END
					CLOSE curLINES
					DEALLOCATE curLINES
					SET @ActivoCurLINES=0
				END
				ELSE
				BEGIN
					--
					-- Transferência
					--
					SET @DocID = ''
					SET @LineID = ''
					SET @Qtd = @Quantity

					INSERT INTO u_Kapps_LoadingPallets(LoadNr, DocID, LineID, SSCC, ProductID, Qty, Unit, Lot, ExpirationDate)
					VALUES (@ActiveLoadNr, @DocID, @LineID, @CurrentSSCC, @Article, @Qtd, @Unit, @Lot, @ExpirationDate)

					--
					-- Verificar Stock 
					--
					EXEC sp_executesql @sql, N'@tempStock decimal(18,3) OUTPUT' , @TempStock=@Stock OUTPUT; 

					IF (@Stock<0)
					BEGIN
						SET @ErrorID=11
						select @Description=REPLACE(RTRIM(Description),'%',' ') from v_Kapps_Articles WHERE Code=@Article
						SET @ErrorMessage = 'Não existe stock suficiente para o artigo '+@Description+' ('+@Article +')'
						IF @Lot<>''
						BEGIN
							SET @ErrorMessage = @ErrorMessage +' do lote '+@Lot
						END
						SET @ErrorMessage = @ErrorMessage + ' no armazém '+@CurrentWarehouse

						IF @CurrentLocation<>'' and @CurrentLocation<>@CurrentWarehouse
						BEGIN
							SET @ErrorMessage=@ErrorMessage+' localização '+@CurrentLocation
						END
						SET @ErrorMessage = @ErrorMessage +' (necessário '+CAST(@Quantity as varchar(20))+', stock de '+ CAST(@Stock as varchar(20))+')'

						SET @ErrorSeverity = 16
						SET @ErrorState = 1

						RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)			
					END
					
				END



	 			FETCH NEXT FROM curSSCC INTO @Article, @Quantity, @Unit, @Lot, @ExpirationDate, @SerialNumber, @NetWeight, @CurrentWarehouse, @CurrentLocation, @CurrentSSCC;
			END
	
			SET @resultCode = 1
			SET @resultMsg = 'OK,'+ @LocationID+','+ @SSCC1 + ','+ @SSCC2

			INSERT INTO u_Kapps_LoadingLog(LoadNr, ErrorDate, ErrorTime, ErrorID, ErrorDescription)
			VALUES (@ActiveLoadNr, CONVERT(VARCHAR, GETDATE(), 112), LEFT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),6), @ErrorID, @resultMsg);

			COMMIT TRANSACTION
		END
		IF @resultCode=0
		BEGIN
			SET @resultMsg = '('+CAST(@ErrorID as varchar(3))+') ' + @resultMsg
		END
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		IF @inTransaction=1
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @resultCode = 0
		SET @resultMsg = '('+CAST(@ErrorID as varchar(3))+') ' + @ErrorMessage 
					
		INSERT INTO u_Kapps_LoadingLog(LoadNr, ErrorDate, ErrorTime, ErrorID, ErrorDescription)
		VALUES (@ActiveLoadNr, CONVERT(VARCHAR, GETDATE(), 112), LEFT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),6), @ErrorID, @resultMsg+ ''''+@LocationID+''', '''+@SSCC1 +''', '''+ @SSCC2+ '''');

		IF @ErrorID=0
		BEGIN
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		END
		SET @ErrorID=0

	END CATCH


	FIM:


	IF @ErrorID>0
	BEGIN
		SET @resultMsg=@resultMsg+' ('+@LocationID+','''+@SSCC1+''','''+@SSCC2+''')'
		INSERT INTO u_Kapps_LoadingLog(LoadNr, ErrorDate, ErrorTime, ErrorID, ErrorDescription)
		VALUES (@ActiveLoadNr, CONVERT(VARCHAR, GETDATE(), 112), LEFT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),6), @ErrorID, @resultMsg);
	END

	IF @ActivoCurSSCC=1
	BEGIN
		CLOSE curSSCC
		DEALLOCATE curSSCC
	END
	IF @ActivoCurLINES=1
	BEGIN
		CLOSE curLINES
		DEALLOCATE curLINES
	END

	SELECT @resultCode, @resultMsg
END
GO



IF EXISTS (SELECT object_id FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_UpdateStatus') AND type IN (N'P', N'PC'))
	DROP PROCEDURE SP_u_Kapps_UpdateStatus
GO

CREATE PROCEDURE SP_u_Kapps_UpdateStatus
	@inStampLinList NVARCHAR(4000), 
	@inTerminal CHAR(5), 
	@inParameterGroup CHAR(100), 
	@inUserIntegracao VARCHAR(50), 
	@inSQL VARCHAR(max), 
	@inDelete AS BIT
AS
BEGIN
	--
	-- Esta SP é executada para atualizar as quantidades alternativas
	--
	SET NOCOUNT ON;

	DECLARE @tempSQL VARCHAR(max)
	
	DECLARE @resultCode VARCHAR(3)
	DECLARE @resultMsg VARCHAR(255)
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @StampLin NVARCHAR(50)
	DECLARE @StampBo NVARCHAR(50)
	DECLARE @StampBi NVARCHAR(50)
	DECLARE @Qty DECIMAL(18, 3)
	DECLARE @Qty2 DECIMAL(18, 3)
	DECLARE @QtyUM NVARCHAR(25)
	DECLARE @Qty2UM NVARCHAR(25)
	DECLARE @Peso NUMERIC(18, 3)
	DECLARE @UseWeight BIT
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	DECLARE @ERP VARCHAR(25)
	DECLARE @TempTable table (StampLin nvarchar(50));
	DECLARE @qttPallet varchar(25)
	DECLARE @HeaderID varchar(50)
	DECLARE @LineID varchar(50)
	DECLARE @UpdateTable varchar(25)

	SET @resultCode = 'NOK'
	SET @resultMsg = 'Erro a integrar'
	SET @qttPallet = ''
	SET @HeaderID= ''
	SET @LineID = ''
	SET @UpdateTable = ''

	BEGIN TRY
		BEGIN TRANSACTION

		SELECT @ERP = COALESCE(ParameterValue, '')
		FROM u_Kapps_Parameters WITH(NOLOCK)
		WHERE ParameterGroup = 'MAIN' AND ParameterId = 'ERP'

		set @tempSQL = 'SELECT StampLin FROM u_Kapps_DossierLin WHERE StampLin in ('+@inStampLinList+')';
		INSERT INTO @TempTable(StampLin) exec (@tempSQL)

		DECLARE curKappsDossiers CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
		FOR
		SELECT COALESCE(StampLin, ''), COALESCE(StampBo, ''), COALESCE(StampBi, ''), COALESCE(Qty, 0) AS Qty, COALESCE(QtyUM, '') AS QtyUM, COALESCE(Qty2, 0) AS Qty2, COALESCE(Qty2UM, '') AS QtyUM2, COALESCE(NetWeight, 0), COALESCE(UseWeight, 0)
		FROM u_Kapps_DossierLin WITH(NOLOCK)
		LEFT JOIN v_Kapps_Articles art ON art.Code = Ref
		WHERE (StampLin IN (SELECT StampLin FROM @TempTable))

		OPEN curKappsDossiers

		FETCH NEXT
		FROM curKappsDossiers
		INTO @StampLin, @StampBo, @StampBi, @Qty, @QtyUM, @Qty2, @Qty2UM, @Peso, @UseWeight

		IF @@FETCH_STATUS<0
		BEGIN
			RAISERROR ('Linha não encontrada', 16,1)
		END

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @DateTimeTmp = GETDATE()
			SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
			SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)

			IF (@UseWeight = 1)
			BEGIN
				SET @Qty = @Peso
			END

			IF @inDelete = 1
			BEGIN
				SET @Qty2 = - @Qty2
			END

			IF UPPER(@erp) = 'PHC'
			BEGIN
				SET @qttPallet = 'u_qttPallet'
				SET @HeaderID = 'StampBo'
				SET @LineID = 'StampLin'
				SET @UpdateTable = 'bi'

			END
			ELSE IF UPPER(@erp) = 'PRIMAVERA'
			BEGIN
				SET @qttPallet = 'CDU_qttPallet'
				SET @HeaderID = 'IdCabecDoc'
				SET @LineID = 'id'
				SET @UpdateTable = 'LinhasDoc'
			END

			-- atualiza a quantidade na linha de origem
			EXEC ('UPDATE ' + @UpdateTable +' SET '+ @qttPallet + ' = ' + @qttPallet + ' + ' + @Qty2 + ' WHERE ' + @HeaderID + ' = ''' + @StampBo + ''' and ' + @LineID + ' = ''' + @StampBi + '''')

			-- atualiza data, hora e utilizador na linha 
			UPDATE u_Kapps_DossierLin
			SET DataIntegracao = @DateStr, HoraIntegracao = SUBSTRING(@TimeStr, 1, 6), UserIntegracao = @InUserIntegracao
			WHERE StampBo = @StampBo AND StampLin = @StampLin AND Status = 'I'

			FETCH NEXT
			FROM curKappsDossiers
			INTO @StampLin, @StampBo, @StampBi, @Qty, @QtyUM, @Qty2, @Qty2UM, @Peso, @UseWeight
		END

		IF (@inSQL <> '')
		BEGIN
			EXEC (@inSQL)
		END

		SET @resultCode = 'OK'
		SET @resultMsg = ''

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

		ROLLBACK TRANSACTION

		SET @resultCode = 'NOK'
		SET @resultMsg = @ErrorMessage

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		INSERT INTO u_Kapps_Log (LogStamp, LogType, LogMessage, LogDetail, LogTerminal, LogIsError)
		VALUES (CONVERT(VARCHAR, GETDATE(), 112) + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''), 10, '''' + RTRIM(@inStampLinList) + ''',  ''' + RTRIM(@inTerminal) + ''', ''' + RTRIM(@inParameterGroup) + ''', ''' + RTRIM(@InUserIntegracao) + '''', RTRIM(@ErrorMessage), @inTerminal, 1)

		GOTO FIM
	END CATCH

	FIM:

	CLOSE curKappsDossiers

	DEALLOCATE curKappsDossiers

	--
	-- Deve retornar apenas um result set com 
	--
	-- @resultCode 		OK ou NOK 
	-- @resultMsg 		Descrição do erro
	--
	SELECT @resultCode, @resultMsg
END
GO



DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_DossiersLinUSR
	@DocTipo CHAR(5),				-- Tipo do documento da aplicação (DCO ou DSO)
	@InternalStampDoc NVARCHAR(50),	-- Stamp do documento origem se DCO ou InternalStampDoc se DSO
	@ndos VARCHAR(50),				-- Numero do dossier de destino
	@fecha CHAR(5),					-- Se encerra o documento de origem
	@bostamp VARCHAR(25),			-- StampBo do documento criado
	@bistamp VARCHAR(25),			-- StampLin da linha u_Kapps_DossierLin
	@ref VARCHAR(18),				-- Código do artigo
	@Linha INT,						-- Numero da linha criada na BI
	@bistampOrigem CHAR(25)			-- StampBi da linha de origem
AS
BEGIN
	SET NOCOUNT ON; ';

EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_DossiersLinUSR', @SPnewSQL, '', '', '', '';
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_CheckUserPermission') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_CheckUserPermission
GO
CREATE PROCEDURE SP_u_Kapps_CheckUserPermission
	@UserId VARCHAR(50), 
	@FunctionId VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @resultCode BIT
	DECLARE @resultMsg VARCHAR(255)
	DECLARE @UserType VARCHAR(1)
	DECLARE @UserActif BIT

	-- Catch all
	SET @resultCode = 0
	SET @resultMsg = 'Sem acesso'
	SET @UserType = ''

	-- Check parameters
	IF @UserId = ''
	BEGIN
		SET @resultCode = 0
		SET @resultMsg = 'Utilizador não especificado'

		GOTO SendResult
	END

	IF @FunctionId = ''
	BEGIN
		SET @resultCode = 0
		SET @resultMsg = 'Função desconhecida'

		GOTO SendResult
	END

	-- Check if user exists
	SELECT @UserType = IsAdmin, @UserActif = Actif FROM u_Kapps_Users WHERE Username = @UserId

	IF @UserType = '' OR @UserType = NULL
	BEGIN
		SET @resultCode = 0
		SET @resultMsg = 'O utilizador não existe ou não foi encontrado'

		GOTO SendResult
	END
	ELSE
	BEGIN
		IF @UserActif = 0
		BEGIN
			SET @resultCode = 0
			SET @resultMsg = 'O utilizador não se encontra ativo'

			GOTO SendResult
		END

		IF @UserType = '1'
		BEGIN
			SET @resultCode = 1
			SET @resultMsg = ''

			GOTO SendResult
		END
	END

	-- Check permission
	IF EXISTS (
			SELECT *
			FROM u_Kapps_UsersPermissions
			WHERE UserID = @UserId AND FunctionId = @FunctionId
			)
	BEGIN
		SET @resultCode = 1
		SET @resultMsg = ''

		GOTO SendResult
	END
	ELSE
	BEGIN
		SET @resultCode = 0
		SET @resultMsg = 'O utilizador não tem acesso'

		GOTO SendResult
	END

	SendResult:

	--
	-- Deve retornar apenas um result set com: 
	--
	-- @resultCode 		OK=1 ou NOK=0 
	-- @resultMsg 		Descrição do erro
	--
	SELECT @resultCode, @resultMsg

	RETURN
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_InsertLot') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_InsertLot
GO
CREATE PROCEDURE SP_u_Kapps_InsertLot
	@Lot VARCHAR(30),					-- Lot
	@Ref VARCHAR(18),					-- Article
	@Description VARCHAR(60),			-- Description
	@ProductionDate VARCHAR(8),			-- Production date
	@ExpirationDate VARCHAR(8),			-- Expiration date
	@UserID VARCHAR(30),				-- Username
	@ShowResultSet BIT,					-- Devolver resultados com result set
	@resultCode BIT OUTPUT,				-- Codigo a devolver
	@resultMsg VARCHAR(1000) OUTPUT		-- Mensagem a devolver

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateTimeTmp DATETIME
	DECLARE @sestamp CHAR(25) 
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @tempTime VARCHAR(8)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @reccount int
	
	SET @resultCode = 0;

	-- se não existir o lote tem de se criar
	
	BEGIN TRY
		IF @Lot <> ''
		BEGIN
			SELECT @reccount=COUNT(*) FROM se WITH(NOLOCK) WHERE ref = @Ref AND lote = @Lot
			IF @reccount = 0
			BEGIN  
				WAITFOR DELAY '00:00:00.200'

				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)		

				IF @ProductionDate=''
				BEGIN
					SET @ProductionDate = @DateStr
				END

				SET @sestamp = 'Syslog_' + @DateStr + @TimeStr
				SET @ousrinis = @UserID + '-' + @DateStr
			
				SET @tempTime = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				INSERT INTO se (sestamp, ref, lote, design, data, validade, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
					VALUES (@sestamp, @Ref, UPPER(@Lot), @Description, @ProductionDate, @ExpirationDate, @ousrinis, @DateStr, @tempTime, @ousrinis, @DateStr, @tempTime)

				SET @resultCode=1
			END
			ELSE
			BEGIN
				SET @resultCode=1
			END
		END
		ELSE
		BEGIN
			SET @resultCode=1
		END
	END TRY
	BEGIN CATCH
		SET @resultCode=0

		SELECT @resultMsg = ERROR_MESSAGE()

	END CATCH

	IF @ShowResultSet=1
	BEGIN
		SELECT @resultCode, @resultMsg
	END

END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_tBOM_New') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_tBOM_New
GO
CREATE PROCEDURE SP_u_Kapps_tBOM_New
	@inRef VARCHAR(100),
	@inQuantity NUMERIC(18,6),
	@inTerminalId VARCHAR(200),
	@inCustomerId VARCHAR(100),
	@inCustomerName VARCHAR(200),
	@inUserId VARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Begin

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

	DECLARE @tempFirst BIT
	DECLARE @tempLineNumber INT
	DECLARE @tempStampCab VARCHAR(200)
	DECLARE @tempStampLin VARCHAR(200)
	DECLARE @tempNextNumber varchar(50)

	DECLARE @errMessage VARCHAR(200)

	DECLARE @fProductId VARCHAR(100)
	DECLARE @fProductDescription VARCHAR(200)
	DECLARE @fComponentId VARCHAR(100)
	DECLARE @fComponentDescription VARCHAR(200)
	DECLARE @fQuantity NUMERIC(18,6)
	DECLARE @fMeasureUnit VARCHAR(25)
	DECLARE @fSequence INT
	DECLARE @fReplaceable BIT
	DECLARE @fTolerance INT


	BEGIN TRANSACTION

	SET @tempFirst = 1
	SET @tempLineNumber = 0
	
	SET @errMessage = 'Documento adicionado com sucesso!'

	SET @DateTimeTmp = GETDATE()
	SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
	SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
	SET @tempStampCab = @inTerminalId+'-'+'DSO'+'-'+@DateStr+'-'+@TimeStr

	--get document number
	SET @tempNextNumber = (SELECT LastNumber FROM u_Kapps_NumeratorsSet WHERE NumeratorId = 'tempBOM' and NumeratorSeries = '1') + 1
	IF @tempNextNumber is null
	BEGIN
		SET @tempNextNumber='1'
		
		INSERT INTO u_Kapps_NumeratorsSet 
		 ([NumeratorId], [Description], [NumeratorSeries], [LastNumber]
		 , [CreationNetIPAddress], [CreationNetMachineName], [CreationProcess], [CreationUser], [CreationDate], [CreationTime])
		VALUES ('tempBOM', 'Produção por ficha técnica', '1', @tempNextNumber
		 , '', '', 'SP_u_Kapps_tBOM_New', @inUserId, @DateStr, SUBSTRING(@TimeStr,1,6))
	END
	ELSE
	BEGIN
		UPDATE u_Kapps_NumeratorsSet 
			SET LastNumber = ABS(@tempNextNumber)
			, ModificationProcess = 'SP_u_Kapps_tBOM_New', ModificationUser = @inUserId, ModificationDate = @DateStr, ModificationTime = SUBSTRING(@TimeStr,1,6) 
			WHERE NumeratorId = 'tempBOM' and NumeratorSeries = '1'
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 0 as errCode, 'Erro ao atualizar numeradores!' as errMessage
			RETURN 0
		END
	END

	-- insert product line
	SET @tempLineNumber=@tempLineNumber+1

	SET @DateTimeTmp = GETDATE()
	SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
	SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
	SET @tempStampLin = @inTerminalId+'-'+'DSO'+'-'+@DateStr+'-'+@TimeStr

	SELECT @fMeasureUnit=art.BaseUnit, @fProductDescription=art.[Description] FROM v_Kapps_Articles AS art WITH(NOLOCK) WHERE art.Code = @inRef
	INSERT INTO u_Kapps_tBOM_Items
		(BOMItemsKey, Article, [Description], Quantity, QuantitySatisfied, QuantityPending, QuantityPicked
		, BaseUnit, BusyUnit, ConversionFator, Warehouse, BOMKey, OriginalLineNumber
		, UserCol1, UserCol2, UserCol3, UserCol4, UserCol5, UserCol6, UserCol7, UserCol8, UserCol9, UserCol10
		, EXR, SEC, TPD, NDC, Filter1, Filter2, Filter3, Filter4, Filter5
		, [Location], Lot, PalletType, PalletMaxUnits, IsComponent, [Sequence], Replaceable, Tolerance
		, CreationNetIPAddress, CreationNetMachineName, CreationProcess, CreationUser, CreationDate, CreationTime
		, ModificationProcess, ModificationUser, ModificationDate, ModificationTime, ModificationNetIPAddress, ModificationNetMachineName, [Status])
	VALUES (@tempStampLin, @inRef, @fProductDescription, @inQuantity, @inQuantity, 0, 0
		, @fMeasureUnit, @fMeasureUnit, 1, '', @tempStampCab, @tempLineNumber
		, '', '', '', '', '', '', '', '', '', ''
		, '', 'tempBOM', '970', ABS(@tempNextNumber), '', '', '', '', ''
		, '', '', '', 0, 0, 0, 0, 0
		, '', '', 'SP_u_Kapps_tBOM_New', @inUserId, @DateStr, SUBSTRING(@TimeStr,1,6)
		, '', '', '', '', '', '', 0)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		CLOSE cur_ProductsStruture
		DEALLOCATE cur_ProductsStruture
		SELECT -1 as errCode, 'Erro ao adicionar linha de produto final!' as errMessage
		RETURN -1
	END

	WAITFOR DELAY '00:00:00.200';


	-- insert component lines
	DECLARE cur_ProductsStruture CURSOR
	FAST_FORWARD 
	FOR SELECT ProductId, ProductDescription, ComponentId, ComponentDescription, Quantity, MeasureUnit, [Sequence], Replaceable, Tolerance
	 FROM v_Kapps_ProductsStruture AS lin WITH(NOLOCK)
		LEFT JOIN v_Kapps_Articles AS art WITH(NOLOCK) ON art.Code = lin.ComponentId
	 WHERE lin.ProductID = @inRef
	 ORDER BY lin.[Sequence]

	OPEN cur_ProductsStruture

	FETCH NEXT FROM cur_ProductsStruture
		INTO @fProductId, @fProductDescription, @fComponentId, @fComponentDescription, @fQuantity, @fMeasureUnit, @fSequence, @fReplaceable, @fTolerance

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		-- Destination product
		IF @tempFirst = 1
		BEGIN
			SET @tempFirst = 0
		END

		-- Components
		SET @tempLineNumber=@tempLineNumber+1

		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
		SET @tempStampLin = @inTerminalId+'-'+'DSO'+'-'+@DateStr+'-'+@TimeStr

		INSERT INTO u_Kapps_tBOM_Items
			(BOMItemsKey, Article, [Description], Quantity, QuantitySatisfied, QuantityPending, QuantityPicked
			, BaseUnit, BusyUnit, ConversionFator, Warehouse, BOMKey, OriginalLineNumber
			, UserCol1, UserCol2, UserCol3, UserCol4, UserCol5, UserCol6, UserCol7, UserCol8, UserCol9, UserCol10
			, EXR, SEC, TPD, NDC, Filter1, Filter2, Filter3, Filter4, Filter5
			, [Location], Lot, PalletType, PalletMaxUnits, IsComponent, [Sequence], Replaceable, Tolerance
			, CreationNetIPAddress, CreationNetMachineName, CreationProcess, CreationUser, CreationDate, CreationTime
			, ModificationProcess, ModificationUser, ModificationDate, ModificationTime, ModificationNetIPAddress, ModificationNetMachineName, [Status])
		VALUES (@tempStampLin, @fComponentId, @fComponentDescription, (@fQuantity*@inQuantity), 0, (@fQuantity*@inQuantity), 0
			, @fMeasureUnit, @fMeasureUnit, 1, '', @tempStampCab, @tempLineNumber
			, '', '', '', '', '', '', '', '', '', ''
			, '', 'tempBOM', '970', ABS(@tempNextNumber), '', '', '', '', ''
			, '', '', '', 0, 1, @fSequence, @fReplaceable, @fTolerance
			, '', '', 'SP_u_Kapps_tBOM_New', @inUserId, @DateStr, SUBSTRING(@TimeStr,1,6)
			, '', '', '', '', '', '', 0)
	
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			CLOSE cur_ProductsStruture
			DEALLOCATE cur_ProductsStruture
			SELECT -2 as errCode, 'Erro ao adicionar linha de componentes!' as errMessage
			RETURN -2
		END

		WAITFOR DELAY '00:00:00.200';

		FETCH NEXT FROM cur_ProductsStruture
			INTO @fProductId, @fProductDescription, @fComponentId, @fComponentDescription, @fQuantity, @fMeasureUnit, @fSequence, @fReplaceable, @fTolerance

	END

	CLOSE cur_ProductsStruture
	DEALLOCATE cur_ProductsStruture

	-- Not
	IF @tempFirst = 1
	BEGIN
		SET @errMessage = 'Não adicionou componentes!'
	END


	-- Header
	INSERT INTO u_Kapps_tBOM_Header
			(BOMKey, Number, CustomerName, [Date], Customer, Document, DocumentName
			, UserCol1, UserCol2, UserCol3, UserCol4, UserCol5, UserCol6, UserCol7, UserCol8, UserCol9, UserCol10
			, EXR, SEC, TPD, NDC, Filter1, Filter2, Filter3, Filter4, Filter5
			, DeliveryCustomer, DeliveryCode, barcode
			, CreationNetIPAddress, CreationNetMachineName, CreationProcess, CreationUser, CreationDate, CreationTime
			, ModificationProcess, ModificationUser, ModificationDate, ModificationTime, ModificationNetIPAddress, ModificationNetMachineName, [Status])
	VALUES (@tempStampCab, ABS(@tempNextNumber), @inCustomerName, @DateStr, @inCustomerId, 970, 'Production by struture'
			, '', '', '', '', '', '', '', '', '', ''
			, '', 'tempBOM', '970', ABS(@tempNextNumber), '', '', '', '', ''
			, '', '', ''
			, '', '', 'SP_u_Kapps_tBOM_New', @inUserId, @DateStr, SUBSTRING(@TimeStr,1,6)
			, '', '', '', '', '', '', 0)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		SELECT -4 as errCode, 'Erro ao adicionar cabeçalho!' as errMessage
		RETURN -4
	END


	-- Success
	COMMIT TRANSACTION
	SELECT 1 as errCode, @errMessage as errMessage
	RETURN 1

END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_SerialNumber_Insert') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_SerialNumber_Insert
GO
CREATE PROCEDURE SP_u_Kapps_SerialNumber_Insert
	@inStampLin VARCHAR(200),
	@inListaNumeroSerie VARCHAR(MAX),
	@inQtd INT,
	@inSep_ACL VARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Separador VARCHAR(1) = ''
	DECLARE @SeparadorACL VARCHAR(1) = ''
	
	DECLARE @ListaNova VARCHAR(MAX) = ''
	DECLARE @outListaNumeroSerie VARCHAR(MAX) = ''
	
	
	DECLARE @locDTValue VARCHAR(MAX) = ''
	DECLARE @locDTSequence INT = 0

	DECLARE @tbListaNumeroSerie TABLE(elSNField VARCHAR(MAX), elOrdinal int)

	-- Lista número de série - - - - - - - - - - - - start
	SET @locDTSequence = 0
	DECLARE DTListaNumeroSerie CURSOR
	FAST_FORWARD
	FOR SELECT value
		FROM STRING_SPLIT(@inListaNumeroSerie,@inSep_ACL)
	OPEN DTListaNumeroSerie

	FETCH NEXT FROM DTListaNumeroSerie
	INTO @locDTValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @locDTSequence = @locDTSequence + 1
		--INSERT INTO @tbListaNumeroSerie (elSNField, elOrdinal) VALUES (@locDTValue, @locDTSequence)

		FETCH NEXT FROM DTListaNumeroSerie
		INTO @locDTValue
	END
	CLOSE DTListaNumeroSerie
	DEALLOCATE DTListaNumeroSerie
	-- Lista número de série - - - - - - - - - - - - end

	IF @locDTSequence = 0
	BEGIN
		IF  @inListaNumeroSerie <> ''
		BEGIN
			SET @ListaNova = '('''+@inListaNumeroSerie+''')'
		END
	END 
	ELSE
	BEGIN
		-- Lista número de série - - - - - - - - - - - - start
		SET @locDTSequence = 0
		DECLARE DTListaNumeroSerie CURSOR
		FAST_FORWARD
		FOR SELECT value
			FROM STRING_SPLIT(@inListaNumeroSerie,@inSep_ACL)
		OPEN DTListaNumeroSerie

		FETCH NEXT FROM DTListaNumeroSerie
		INTO @locDTValue
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @locDTSequence = @locDTSequence + 1

	 		IF @locDTSequence > @inQtd
			BEGIN
	 	 		SET @outListaNumeroSerie = @outListaNumeroSerie + @SeparadorACL + @locDTValue
	 	 		SET @SeparadorACL = @inSep_ACL
			END
	 		ELSE
			BEGIN
	 	 		SET @ListaNova = @ListaNova + @Separador + '(''' + @locDTValue + ''')'
	 	 		SET @Separador = ','
			END

			FETCH NEXT FROM DTListaNumeroSerie
			INTO @locDTValue
		END
		CLOSE DTListaNumeroSerie
		DEALLOCATE DTListaNumeroSerie
	END
 
	IF @ListaNova <> '' AND @inQtd > 0
	BEGIN
		DECLARE @SELECT NVARCHAR(MAX) = 
		'INSERT INTO u_Kapps_Serials(StampLin, Serial) '+
		'SELECT * FROM (VALUES (''' +@inStampLin+ '''))tempA (Stamp) '+
		'CROSS JOIN '+
		'(SELECT * FROM (VALUES ' +@ListaNova+ ' )tempB (NumSerie))tempC'

		EXEC sp_executesql @SELECT
	END

	SELECT '0'

END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Location_InsertLogModify') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Location_InsertLogModify
GO
CREATE PROCEDURE SP_u_Kapps_Location_InsertLogModify
	@inLocalizacaoOrigem VARCHAR(100), 
	@inLocalizacao VARCHAR(100),
	@inTipoDocOrigem VARCHAR(50),
	@inSelectedNumDoc VARCHAR(100),
	@inNomeDoc VARCHAR(200),
	@inRef VARCHAR(100),
	@inTerminalId VARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

	DECLARE @tempVar VARCHAR(MAX)
	SET @tempVar = ''

	IF @inLocalizacaoOrigem <>'' AND @inLocalizacaoOrigem <> @inLocalizacao
	BEGIN
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
		
		SET @tempVar = @inTipoDocOrigem +' '+ @inSelectedNumDoc +' '+ @inNomeDoc +' '+ @inTipoDocOrigem +' '+ @inTerminalId+'-'+'DCO'+'-'+@DateStr+'-'+@TimeStr
		
		INSERT INTO u_Kapps_Log (LogStamp, LogType, LogMessage, LogDetail, LogTerminal, LogIsError)
		VALUES(@DateStr+@TimeStr, 99, 'Alteração da localização de origem'
		, 'Referência ' + @inRef + '; Localização de origem ' + @inLocalizacaoOrigem + '; Localização destino ' + @inLocalizacao + ' ' + Replace(@tempVar, '''', '´'), @inTerminalId, 1)

	END


	SELECT 0 AS errCode, '' AS errMessage
	RETURN 0
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_GetRestrictions') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_GetRestrictions
GO
CREATE PROCEDURE SP_u_Kapps_GetRestrictions
	@inArmazem VARCHAR(50),
	@inLocalizacao VARCHAR(50),
	@inRef VARCHAR(50),
	@WITHNOLOCK VARCHAR(50),
	@TOP1 VARCHAR(50),
	@LIMIT1 VARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Family NVARCHAR(MAX) = ''
	DECLARE @Select NVARCHAR(MAX) = 'SELECT @Family=Family FROM v_Kapps_Articles ' + @WITHNOLOCK + ' WHERE Code=''' + @inRef + ''''
	EXEC sp_executesql @Select, N'@Family NVARCHAR(MAX) OUTPUT', @Family=@Family OUTPUT

	DECLARE @Zona NVARCHAR(MAX) = ''
	SET @Select = 'SELECT @Zona=' + @TOP1 + ' ZoneLocation FROM v_Kapps_WarehousesLocations ' + @WITHNOLOCK + ' WHERE Warehouse=''' + @inArmazem + ''' AND Location=''' + @inLocalizacao + ''' ' + @LIMIT1
	EXEC sp_executesql @Select, N'@Zona NVARCHAR(MAX) OUTPUT', @Zona=@Zona OUTPUT

	DECLARE @RULE NVARCHAR(1)=''

	DECLARE @subSELECT NVARCHAR(MAX) = 'SELECT ''#RULE'' AS Regra, CASE WHEN ra.Article<>'''' THEN 5 WHEN Family<>'''' THEN 4 WHEN Location<>'''' THEN 3 WHEN ZoneLocation<>'''' THEN 2 ELSE 1 END AS Nivel '+
	' FROM v_Kapps_RestrictedArticles AS ra ' + @WITHNOLOCK +
	' where ra.RuleType=''#RULE'' AND (ra.Warehouse='''+@inArmazem+''') AND (ra.ZoneLocation='''' OR ra.ZoneLocation='''+@Zona+''') AND (ra.Location='''' OR ra.Location='''+@inLocalizacao+''') AND (ra.Family='''' OR ra.Family='''+@family+''') AND (ra.Article='''' OR ra.Article='''+@inRef+''')'+
	' UNION ' +
	' SELECT ''#RULE'' AS Regra, CASE WHEN ra.Article<>'''' THEN 5 WHEN Family<>'''' THEN 4 WHEN Location<>'''' THEN 3 WHEN ZoneLocation<>'''' THEN 2 ELSE 1 END AS Nivel '+
	' FROM v_Kapps_RestrictedArticles ra ' + @WITHNOLOCK +  
	' WHERE ra.RuleType=''#RULE'' AND (ra.Warehouse='''' OR ra.Warehouse='''+@inArmazem+''') AND (ra.ZoneLocation='''+@Zona+''') AND (ra.Location='''' OR ra.Location='''+@inLocalizacao+''') AND (ra.Family='''' OR ra.Family='''+@family+''') AND (ra.Article='''' OR ra.Article='''+@inRef+''') '+
	' UNION '+
	' SELECT ''#RULE'' AS Regra, CASE WHEN ra.Article<>'''' THEN 5 WHEN Family<>'''' THEN 4 WHEN Location<>'''' THEN 3 WHEN ZoneLocation<>'''' THEN 2 ELSE 1 END AS Nivel ' +
	' FROM v_Kapps_RestrictedArticles ra ' + @WITHNOLOCK +  
	' WHERE ra.RuleType=''#RULE'' AND (ra.Warehouse='''' OR ra.Warehouse='''+@inArmazem+''') AND (ra.ZoneLocation='''' OR ra.ZoneLocation='''+@Zona+''') AND (ra.Location='''+@inLocalizacao+''') AND (ra.Family='''' OR ra.Family='''+@family+''') AND (ra.Article='''' OR ra.Article='''+@inRef+''') '+
	' UNION '+
	' SELECT ''#RULE'' AS Regra, CASE WHEN ra.Article<>'''' THEN 5 WHEN Family<>'''' THEN 4 WHEN Location<>'''' THEN 3 WHEN ZoneLocation<>'''' THEN 2 ELSE 1 END AS Nivel ' +
	' FROM v_Kapps_RestrictedArticles ra ' + @WITHNOLOCK +
	' WHERE ra.RuleType=''#RULE'' AND (ra.Warehouse='''' OR ra.Warehouse='''+@inArmazem+''') AND (ra.ZoneLocation='''' OR ra.ZoneLocation='''+@Zona+''') AND (ra.Location='''' OR ra.Location='''+@inLocalizacao+''') AND (ra.Family='''+@family+''') AND (ra.Article='''' OR ra.Article='''+@inRef+''') '+
	' UNION ' +
	' SELECT ''#RULE'' AS Regra, CASE WHEN ra.Article<>'''' THEN 5 WHEN Family<>'''' THEN 4 WHEN Location<>'''' THEN 3 WHEN ZoneLocation<>'''' THEN 2 ELSE 1 END AS Nivel ' +
	' FROM v_Kapps_RestrictedArticles ra ' + @WITHNOLOCK +
	' WHERE ra.RuleType=''#RULE'' AND (ra.Warehouse='''' OR ra.Warehouse='''+@inArmazem+''') AND (ra.ZoneLocation='''' OR ra.ZoneLocation='''+@Zona+''') AND (ra.Location='''' OR ra.Location='''+@inLocalizacao+''') AND (ra.Family='''' OR ra.Family='''+@family+''') AND (ra.Article='''+@inRef+''') '

	SET @SELECT = 'SELECT ' + @TOP1 + ' @RULE = Regra FROM ' + ' ( ' + REPLACE(@subSELECT,'#RULE','R') +
	' UNION ' +
	' SELECT ' + @TOP1 + ' ''A'' AS Regra, CAST(0 AS int) AS Nivel FROM u_Kapps_Users ' +
	' UNION ';

	SET @SELECT = @SELECT + REPLACE(@subSELECT,'#RULE','A') + ')t ' + 'ORDER BY Nivel DESC, Regra ' + @LIMIT1

	EXEC sp_executesql @SELECT, N'@RULE NVARCHAR(MAX) OUTPUT', @RULE=@RULE OUTPUT

	SELECT 0 AS errCode, '' AS errMessage, @RULE AS outRule
	RETURN 0
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Products_AddToDossierLin') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Products_AddToDossierLin
GO
CREATE PROCEDURE SP_u_Kapps_Products_AddToDossierLin
	@inRef VARCHAR(100),
	@inDescricao VARCHAR(200),
	@inQuantity NUMERIC(18,6),
	@inUnidade VARCHAR(50),
	@inLote VARCHAR(50),
	@inValidade VARCHAR(20),
	@inNumeroSerie VARCHAR(MAX),
	@inPeso NUMERIC(18,6),
	@inLocalizacao VARCHAR(100),
	@inQtdPedida NUMERIC(18,6),
	@inQtdIntegrada NUMERIC(18,6),
	@inQtdPicada NUMERIC(18,6),
	@inQtdEmStock NUMERIC(18,6),
	@inListaCabUserFields NVARCHAR(MAX),
	@inListaLinUserFields NVARCHAR(MAX),
	@inStatus VARCHAR(1),
	@inExternalDoc VARCHAR(200),
	@inArtigoAlternativo VARCHAR(100),
	@inFechaLinha INT,
	@inMovStock VARCHAR(1),
	@inArmazem VARCHAR(100),
	@inSelectedCodigoCliente VARCHAR(100),
	@inTipoDocOrigem VARCHAR(50),
	@inBoStampDocToWork VARCHAR(100),
	@inLocalizacaoOrigem VARCHAR(100),
	@inSelectedNumDoc VARCHAR(100),
	@inNomeDoc VARCHAR(200),
	@inUnidadeMovimentada VARCHAR(50),
	@inFatorConversao VARCHAR(50),
	@inLoteDataProducao VARCHAR(50),
	@inSelectedOriginalLineNumber VARCHAR(50),
	@inLoteOrigem VARCHAR(50),
	@inSelectedNomeCli VARCHAR(200),
	@inDocumentoDestinoSelecionado VARCHAR(100),
	@inSelectedLinStamp NVARCHAR(MAX),
	@inSelectedCabStamp NVARCHAR(MAX),
	@inUsaPesoVariavel INT,
	@inArtigoGereNumeroSerie VARCHAR(1),
	@inbiQtdDifLin VARCHAR(50),
	@inFilterCabDoc NVARCHAR(MAX),
	@inSSCC VARCHAR(50),
	@inQTY_CTRL INT,
	@inGRIDFORSERIALNUMBERS VARCHAR(1),
	@inMULTI_DOCUMENT VARCHAR(50),
	@inPackid VARCHAR(100),
	@inAllowedLocations VARCHAR(MAX),
	@inSelecionouDaGrelha VARCHAR(50),
	@inVerificarRestricoes INT,
	@inEvento VARCHAR(1),
	@inWarehouseOut VARCHAR(100),
	@inLocationOut VARCHAR(100),
	@inGTIN VARCHAR(50),
	@inMoreLinesSameProduct VARCHAR(50),
	@inMoreLinesSameProductLinktoFirst VARCHAR(50),
	@inGENERAL_STOCK_CTRL INT,
	@inSTORE_IN_RECEORDERBYLIN VARCHAR(200),
	@inPICKTRANSF_PICKORDERBYLIN VARCHAR(200),
	@inTerminalId VARCHAR(200),
	@inSEP_ACL NVARCHAR(1),
	@inUSERNAME VARCHAR(200),
	@inGENERAL_LOCATIONS_CTRL INT,
	@WITHNOLOCK VARCHAR(50),
	@TOP1 VARCHAR(50),
	@LIMIT1 VARCHAR(200),
	@inIsFinalProduct NVARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Begin

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

	DECLARE @resultCode INT
	DECLARE @resultMsg VARCHAR(255)
	DECLARE @Aviso1 VARCHAR(255)
	DECLARE @Aviso2 VARCHAR(255)

	DECLARE @RemExecSelectError INT
	DECLARE @RemExecTransaction INT
	DECLARE @RemExecResult INT

	DECLARE @tempNumeroSerie VARCHAR(200)
	DECLARE @tempListaNumeroSerie VARCHAR(MAX)
	DECLARE @tempQtdExcedente NUMERIC(18,6)
	DECLARE @tempQuantidadeAVerificar NUMERIC(18,6)
	DECLARE @tempTipoRestricao VARCHAR(1)
	DECLARE @tempUsePrice VARCHAR(1)
	DECLARE @tempPrice NUMERIC(18,6)
	DECLARE @tempQtdEmFalta NUMERIC(18,6)
	DECLARE @tempQtdPend NUMERIC(18,6)
	DECLARE @tempStampLin VARCHAR(200)
	DECLARE @tempQty NUMERIC(18,6)
	DECLARE @tempQty2 NUMERIC(18,6)
	DECLARE @tempPeso NUMERIC(18,6)
	DECLARE @tempIDCabecalho VARCHAR(200)
	DECLARE @tempIDLinha VARCHAR(200)
	DECLARE @tempTFilterCabDoc VARCHAR(MAX)
	DECLARE @tempNomeDoc VARCHAR(200)
	DECLARE @tempTPD VARCHAR(200)
	DECLARE @tempNumDoc VARCHAR(200)


	DECLARE @tempProcess VARCHAR(50)
	DECLARE @tempInternalStampDoc VARCHAR(MAX)

	SET @RemExecSelectError = 0
	SET @RemExecTransaction = 0
	SET @tempNumeroSerie = ''
	SET @tempListaNumeroSerie = ''
	SET @tempQtdExcedente = 0
	SET @tempQuantidadeAVerificar = 0
	SET @tempTipoRestricao = ''
	SET @tempUsePrice = 'N'
	SET @tempPrice = 0
	SET @tempQtdEmFalta = 0
	SET @tempQtdPend = 0
	SET @tempStampLin = ''
	SET @tempQty = 0
	SET @tempQty2 = 0
	SET @tempPeso = 0
	SET @tempIDCabecalho = ''
	SET @tempIDLinha = ''
	SET @tempTFilterCabDoc = ''
	SET @tempNomeDoc = ''
	SET @tempTPD = ''
	SET @tempNumDoc = ''
	
	
	IF @inEvento = '5'
    BEGIN
		SET @tempProcess = 'DSO'
	END
	ELSE
	BEGIN
		SET @tempProcess = 'DCO'
	END
	SET @tempInternalStampDoc = ''
	

	DECLARE @locEntityType VARCHAR(1)
	DECLARE @locTransactionDescription VARCHAR(200)
	DECLARE @locCabView VARCHAR(200)
	DECLARE @locLinView VARCHAR(200)
	DECLARE @locCabKey VARCHAR(200)
	DECLARE @locLineKey VARCHAR(200)
	DECLARE @locOrdenacaoProcurar VARCHAR(MAX)
	DECLARE @locStatus VARCHAR(1)
	DECLARE @PesoEmFalta NUMERIC(18,6)
	DECLARE @FiltroLoteLocalizacao VARCHAR(MAX)
	DECLARE @locQtd NUMERIC(18,6)

	SET @locEntityType = ''
	SET @locTransactionDescription = ''
	SET @locCabView = ''
	SET @locLinView = ''
	SET @locCabKey = ''
	SET @locLineKey = ''
	SET @locOrdenacaoProcurar = ''
	SET @locStatus = ''
	SET @PesoEmFalta = 0
	SET @FiltroLoteLocalizacao = ''
	SET @locQtd = 0

	
	DECLARE @locDTValue VARCHAR(MAX)
	DECLARE @locDTSequence INT

	SET @locDTValue = ''
	SET @locDTSequence = 0

	DECLARE @tbListaCabUserField TABLE(elCabUserField VARCHAR(MAX), elOrdinal int)
	DECLARE @tbListaLinUserField TABLE(elLinUserField VARCHAR(MAX), elOrdinal int)

	DECLARE @StrString INT
	DECLARE @EndString INT


	-- Catch all
	SET @resultCode = -99
	SET @resultMsg = 'O procedimento não concluiu com êxito.'
	SET @Aviso1 = ''
	SET @Aviso2 = ''
	

	BEGIN TRAN
	
	SET @inFilterCabDoc = Replace(@inFilterCabDoc, '|', '''')

	IF @inWarehouseOut = ''
	BEGIN
		SET @inWarehouseOut = @inArmazem
	END
	
	IF ((@inQuantity > ((@inQtdPedida - @inQtdIntegrada) - @inQtdPicada)) AND @inArtigoAlternativo = '') AND @inIsFinalProduct <> '1'
	BEGIN
		SET @resultCode = -1
		SET @Aviso1 = 'Quantidade superior à quantidade no documento origem.'
		IF @inQTY_CTRL = 0
		BEGIN
			SET @resultMsg = 'O artigo não foi adicionado!'
			GOTO SendResult
		END
		IF @inQTY_CTRL = 1
		BEGIN
			SET @Aviso1 = 'Aviso:'+' '+@Aviso1+' | '
		END
		IF @inQTY_CTRL = 2
		BEGIN
			SET @Aviso1 = ''
		END

		SET @tempQtdExcedente = (@inQuantity - ((@inQtdPedida - @inQtdIntegrada) - @inQtdPicada))
	END
	
	IF @inUsaPesoVariavel = 1
	BEGIN
		SET @tempQuantidadeAVerificar = @inPeso
	END
	ELSE
	BEGIN
		SET @tempQuantidadeAVerificar = @inQuantity
	END
	IF @inMovStock = '1' AND (@tempQuantidadeAVerificar > @inQtdEmStock AND @inFechaLinha = 0) AND @inIsFinalProduct <> '1'
	BEGIN
		SET @Aviso2 = 'Quantidade superior ao stock disponível.'
		IF @inGENERAL_STOCK_CTRL = 0
		BEGIN
			SET @resultCode = -2
			SET @resultMsg = 'O artigo não foi adicionado!'
			GOTO SendResult
		END
		IF @inGENERAL_STOCK_CTRL = 1
		BEGIN
			SET @Aviso2 = 'Aviso:'+' '+@Aviso2+' | '
		END
		IF @inGENERAL_STOCK_CTRL = 2
		BEGIN
			SET @Aviso2 = ''
		END
	END
	
	-- restrições
	IF @inVerificarRestricoes <> 0
	BEGIN
		SET @RemExecResult=1
		EXEC @RemExecResult=SP_u_Kapps_GetRestrictions  @inArmazem, @inLocalizacao, @inRef, @WITHNOLOCK, @TOP1, @LIMIT1
		IF @RemExecResult<>0
		BEGIN
			SET @resultCode = -3
			SET @resultMsg = 'Erro ao efetuar a procura de restrições.'
			GOTO SendResult
		END
		
		IF @tempTipoRestricao <> 'A'
		BEGIN
			SET @resultCode = -4
			SET @resultMsg = 'Não é possível movimentar este artigo. Ver restrições.'
			GOTO SendResult
		END
	END
	
	-- Obter preço, se for um documento sem origem
	IF @inArtigoAlternativo <> '' OR @inSelectedOriginalLineNumber = 9999
	BEGIN
		DECLARE @CAPTProductPriceUSR TABLE(tempUsePrice VARCHAR(1), tempPrice NUMERIC(18,6));
		INSERT INTO @CAPTProductPriceUSR (tempUsePrice, tempPrice) 
			EXEC SP_u_Kapps_ProductPriceUSR @inRef, @inLote, @inArmazem, @inNumeroSerie, @inQuantity, @inSelectedCodigoCliente, '0', @inEvento, @inTipoDocOrigem, @inBoStampDocToWork, '', @inUnidadeMovimentada;
		SELECT @tempUsePrice = tempUsePrice, @tempPrice = tempPrice FROM @CAPTProductPriceUSR;
		IF @tempUsePrice <> 'S'
		BEGIN
			SET @tempPrice = 0
		END
	END
	
	-- controla tipo de evento
	SET @locEntityType = 'C'
	IF @inEvento = '1'
	BEGIN
		SET @locTransactionDescription = 'Picking com origem'
		SET @locCabView = 'v_Kapps_Picking_Documents'
		SET @locLinView = 'v_Kapps_Picking_Lines'
		SET @locCabKey = 'PickingKey'
		SET @locLineKey = 'PickingLineKey'
		SET @locOrdenacaoProcurar = 'ORDER BY doc.Date, lin.'+@locCabKey
	END
	ELSE IF @inEvento = '3'
	BEGIN
		SET @locTransactionDescription = 'Packing com origem'
		SET @locCabView = 'v_Kapps_Packing_Documents'
		SET @locLinView = 'v_Kapps_Packing_Lines'
		SET @locCabKey = 'PackingKey'
		SET @locLineKey = 'PackingLineKey'
		SET @locOrdenacaoProcurar = 'ORDER BY doc.Date, lin.'+@locCabKey
	END
	ELSE IF @inEvento = '4'
	BEGIN
		SET @locTransactionDescription = 'Produção com origem'
		SET @locCabView = 'v_Kapps_BOM_Header'
		SET @locLinView = 'v_Kapps_BOM_Items'
		SET @locCabKey = 'BOMKey'
		SET @locLineKey = 'BOMItemsKey'
		SET @locOrdenacaoProcurar = 'ORDER BY doc.Date, lin.'+@locCabKey
	END
	ELSE IF @inEvento = '5'
	BEGIN
		SET @locTransactionDescription = 'Produção sem origem'
		SET @locCabView = 'u_Kapps_tBOM_Header'
		SET @locLinView = 'u_Kapps_tBOM_Items'
		SET @locCabKey = 'BOMKey'
		SET @locLineKey = 'BOMItemsKey'
		SET @locOrdenacaoProcurar = 'ORDER BY doc.Date, lin.'+@locCabKey
	END
	ELSE IF @inEvento = '8'
	BEGIN
		SET @locTransactionDescription = 'Picking Transferencia com origem'
		SET @locCabView = 'v_Kapps_PickTransf_Documents'
		SET @locLinView = 'v_Kapps_PickTransf_Lines'
		SET @locCabKey = 'PickingKey'
		SET @locLineKey = 'PickingLineKey'
		SET @locOrdenacaoProcurar = @inPICKTRANSF_PICKORDERBYLIN
	END
	ELSE IF @inEvento = '2'
	BEGIN 
		SET @locTransactionDescription = 'Receção com origem'
		SET @locCabView = 'v_Kapps_Reception_Documents'
		SET @locLinView = 'v_Kapps_Reception_Lines'
		SET @locCabKey = 'ReceptionKey'
		SET @locLineKey = 'ReceptionLineKey'
		SET @locOrdenacaoProcurar = @inSTORE_IN_RECEORDERBYLIN
		SET @locEntityType = 'F'
	END
	
	SET @tempQtdEmFalta = @inQuantity
	SET @DateTimeTmp = GETDATE()
	SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
	SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
	SET @tempStampLin = @inTerminalId+'-'+@tempProcess+'-'+@DateStr+'-'+@TimeStr
	
	IF @inGRIDFORSERIALNUMBERS = '1'
	BEGIN
		SET @tempNumeroSerie = ''
		SET @tempListaNumeroSerie = @inNumeroSerie
	END
	ELSE
	BEGIN
		SET @tempNumeroSerie = @inNumeroSerie
		SET @tempListaNumeroSerie = ''
	END

	IF @inStatus = ''
	BEGIN
		SET @locStatus = 'A'
	END
	ELSE
	BEGIN
		SET @locStatus = @inStatus
	END

	
	-- Cab user fields - - - - - - - - - - - - start
	IF @inSep_ACL > '' AND @inListaCabUserFields > '' --AND (LEFT(@inListaCabUserFields,1) <> @inSep_ACL AND RIGHT(@inListaCabUserFields,1) <> @inSep_ACL )
	BEGIN
		SET @locDTSequence = 0
		--DECLARE DTListaCabUserField CURSOR
		--FAST_FORWARD
		--FOR SELECT value
		--	FROM STRING_SPLIT(@inListaCabUserFields,@inSep_ACL)
		--OPEN DTListaCabUserField

		--FETCH NEXT FROM DTListaCabUserField
		--INTO @locDTValue
		--WHILE @@FETCH_STATUS = 0
		--BEGIN
		--	SET @locDTSequence = @locDTSequence + 1
		--	INSERT INTO @tbListaCabUserField (elCabUserField, elOrdinal) VALUES (@locDTValue, @locDTSequence)

		--	FETCH NEXT FROM DTListaCabUserField
		--	INTO @locDTValue
		--END
		--CLOSE DTListaCabUserField
		--DEALLOCATE DTListaCabUserField

		SET @StrString=0
		SET @EndString=0

		WHILE(@StrString<=LEN(@inListaCabUserFields))
		BEGIN

			SET @EndString = COALESCE((CHARINDEX(@inSep_ACL, @inListaCabUserFields, @StrString)-1), 0)
			IF @EndString<=0
			BEGIN
				SET @EndString=LEN(@inListaCabUserFields)
			END
			SELECT @locDTValue=(SUBSTRING(@inListaCabUserFields, (@StrString), (@EndString-@StrString)+1))
			SET @StrString = @EndString+2
			
			IF @EndString<=0 AND @locDTSequence=0
			BEGIN
			SET @locDTSequence = @locDTSequence + 1
				INSERT INTO @tbListaCabUserField (elCabUserField, elOrdinal) VALUES (@locDTValue, @locDTSequence)
			END

		END
	END
	-- Cab user fields - - - - - - - - - - - - end
	
	-- Lin user fields - - - - - - - - - - - - start
	IF @inSep_ACL > '' AND @inListaLinUserFields > '' --AND (LEFT(@inListaLinUserFields,1) <> @inSep_ACL AND RIGHT(@inListaLinUserFields,1) <> @inSep_ACL)
	BEGIN
		--SET @locDTSequence = 0
		--DECLARE DTListaLinUserField CURSOR
		--FAST_FORWARD
		--FOR SELECT value
		--	FROM STRING_SPLIT(@inListaLinUserFields,@inSep_ACL)
		--OPEN DTListaLinUserField

		--FETCH NEXT FROM DTListaLinUserField
		--INTO @locDTValue
		--WHILE @@FETCH_STATUS = 0
		--BEGIN
		--	SET @locDTSequence = @locDTSequence + 1
		--	INSERT INTO @tbListaLinUserField (elLinUserField, elOrdinal) VALUES (@locDTValue, @locDTSequence)

		--	FETCH NEXT FROM DTListaLinUserField
		--	INTO @locDTValue
		--END
		--CLOSE DTListaLinUserField
		--DEALLOCATE DTListaLinUserField
		
		SET @StrString=0
		SET @EndString=0

		WHILE(@StrString<=LEN(@inListaLinUserFields))
		BEGIN

			SET @EndString = COALESCE((CHARINDEX(@inSep_ACL, @inListaLinUserFields, @StrString)-1), 0)
			IF @EndString<=0
			BEGIN
				SET @EndString=LEN(@inListaLinUserFields)
			END
			SELECT @locDTValue=(SUBSTRING(@inListaLinUserFields, (@StrString), (@EndString-@StrString)+1))
			SET @StrString = @EndString+2

			IF @EndString<=0 AND @locDTSequence=0
			BEGIN
			SET @locDTSequence = @locDTSequence + 1
				INSERT INTO @tbListaLinUserField (elLinUserField, elOrdinal) VALUES (@locDTValue, @locDTSequence)
			END

		END
	END
	-- Lin user fields - - - - - - - - - - - - end
	
	IF @inIsFinalProduct = '1'
	BEGIN
		
		SET @tempQty = @tempQtdEmFalta
		SET @tempQty2 = @tempQtdEmFalta / @inFatorConversao
		SET @tempIDCabecalho = @inSelectedCabStamp
		SET @tempIDLinha = @inSelectedLinStamp
		
		IF @tempProcess = 'DSO'
		BEGIN
			SET @tempInternalStampDoc = @tempIDCabecalho
		END
		ELSE
		BEGIN
			SET @tempInternalStampDoc = ''
		END
		INSERT INTO u_Kapps_DossierLin 
		([StampLin], [StampBo], [StampBi], [Ref], [Description], [Qty], [Lot], [Serial], [UserID], [MovDate], [MovTime], [Status]
		, [DocType], [DocNumber], [Integrada], [DataIntegracao], [HoraIntegracao], [UserIntegracao], [Process], [Validade]
		, [Warehouse], [Location], [ExternalDocNum], [EntityType], [EntityNumber], [InternalStampDoc], [DestinationDocType]
		, [TransactionDescription], [EntityName], [DocName], [UnitPrice], [QtyUM], [Qty2], [Qty2UM]
		, [WarehouseOut], [TerminalID], [OriLineNumber], [LineClose]
		, [CabUserField1], [CabUserField2]
		, [CabUserField3], [CabUserField4]
		, [CabUserField5], [CabUserField6]
		, [CabUserField7], [CabUserField8]
		, [CabUserField9], [CabUserField10]
		, [CabUserField11], [CabUserField12]
		, [CabUserField13], [CabUserField14]
		, [CabUserField15]
		, [LinUserField1], [LinUserField2]
		, [LinUserField3], [LinUserField4]
		, [LinUserField5], [LinUserField6]
		, [LinUserField7], [LinUserField8]
		, [LinUserField9], [LinUserField10]
		, [LinUserField11], [LinUserField12]
		, [LinUserField13], [LinUserField14]
		, [LinUserField15]
		, [GTIN], [OriginalLot], [OriginalLocation], [LocationOUT]
		, [ProductionDate], [NetWeight], [SSCC], VatNumber, DefaultWarehouse, DefaultLocation, DefaultWarehouseOut, DefaultLocationOut
		,ExpeditionWarehouse, ExpeditionLocation, IsFinalProductBOM)
		VALUES
		(@tempStampLin, @tempIDCabecalho, @tempIDLinha, @inRef, @inDescricao, @tempQty, @inLote, @tempNumeroSerie, @inUSERNAME, @DateStr, SUBSTRING(@TimeStr,1,6), @inStatus
		, @inTipoDocOrigem, @inSelectedNumDoc, 'N', '', '', '', @tempProcess, @inValidade
		, @inArmazem, @inLocalizacao, @inExternalDoc, @locEntityType, @inSelectedCodigoCliente, @tempInternalStampDoc, @inDocumentoDestinoSelecionado
		, @locTransactionDescription, @inSelectedNomeCli, @inNomeDoc, @tempPrice, @inUnidade, @tempQty2, @inUnidadeMovimentada
		, @inWarehouseOut, @inTerminalId, @inSelectedOriginalLineNumber, @inFechaLinha
		, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 2), ''))
		, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 4), ''))
		, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 6), ''))
		, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 8), ''))
		, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 10), ''))
		, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 12), ''))
		, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 14), ''))
		, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 15), ''))
		, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 2), ''))
		, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 4), ''))
		, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 6), ''))
		, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 8), ''))
		, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 10), ''))
		, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 12), ''))
		, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 14), ''))
		, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 15), ''))
		, @inGTIN, @inLoteOrigem, @inLocalizacaoOrigem, @inLocationOut
		, @inLoteDataProducao, @inPeso, @inSSCC,'','','','','','','',@inIsFinalProduct)

		If @@ERROR <> 0
		BEGIN
			SET @resultCode = -6
			SET @resultMsg = 'Erro ao inserir linha de produto final no dossier!'
			GOTO SendResult
		END
		SET @resultCode = 1
		SET @resultMsg = 'StampLin'+' '+@tempStampLin
	END
	ELSE  -- #Component --
	BEGIN
		IF @inSelectedLinStamp = ''
		BEGIN
	 		IF @inArtigoGereNumeroSerie = '1' AND @inGRIDFORSERIALNUMBERS = '1'
			BEGIN
				--SET @locQtd= string count @tempListaNumSerie + 1
				SET @RemExecResult=1
				EXEC @RemExecResult=SP_u_Kapps_SerialNumber_Insert  @tempStampLin, @tempListaNumeroSerie, @locQtd, @inSEP_ACL
				IF @RemExecResult<>0
				BEGIN
					SET @resultCode = -5
					SET @resultMsg = 'Erro ao inserir números de série.'
					GOTO SendResult
				END
				-- get @tempListaNumeroSerie
			END

			SET @tempQty = @tempQtdEmFalta
			SET @tempQty2 = @tempQtdEmFalta / @inFatorConversao
			SET @tempIDCabecalho = Replace(@inBoStampDocToWork, '''', '')
			SET @tempIDLinha = ''
		
			IF @tempProcess = 'DSO'
			BEGIN
				SET @tempInternalStampDoc = @tempIDCabecalho
			END
			ELSE
			BEGIN
				SET @tempInternalStampDoc = ''
			END

			-- a adição no u_Kapps_DossierLin não inclui:	
			-- [VatNumber] [StampDocGer] [DeliveryCustomer] [DeliveryCode] [DefaultWarehouse] [DefaultLocation] [DefaultWarehouseOut] [DefaultLocationOut] 
			-- [InternalDocType] [InternalQty] [ExpeditionWarehouse] [ExpeditionLocation] [StockBreakReason] [KeyDocGerado] [LoadNr]
			INSERT INTO u_Kapps_DossierLin 
			([StampLin], [StampBo], [StampBi], [Ref], [Description], [Qty], [Lot], [Serial], [UserID], [MovDate], [MovTime], [Status]
			, [DocType], [DocNumber], [Integrada], [DataIntegracao], [HoraIntegracao], [UserIntegracao], [Process], [Validade]
			, [Warehouse], [Location], [ExternalDocNum], [EntityType], [EntityNumber], [InternalStampDoc], [DestinationDocType]
			, [TransactionDescription], [EntityName], [DocName], [UnitPrice], [QtyUM], [Qty2], [Qty2UM]
			, [WarehouseOut], [TerminalID], [OriLineNumber], [LineClose]
			, [CabUserField1], [CabUserField2]
			, [CabUserField3], [CabUserField4]
			, [CabUserField5], [CabUserField6]
			, [CabUserField7], [CabUserField8]
			, [CabUserField9], [CabUserField10]
			, [CabUserField11], [CabUserField12]
			, [CabUserField13], [CabUserField14]
			, [CabUserField15]
			, [LinUserField1], [LinUserField2]
			, [LinUserField3], [LinUserField4]
			, [LinUserField5], [LinUserField6]
			, [LinUserField7], [LinUserField8]
			, [LinUserField9], [LinUserField10]
			, [LinUserField11], [LinUserField12]
			, [LinUserField13], [LinUserField14]
			, [LinUserField15]
			, [GTIN], [OriginalLot], [OriginalLocation], [LocationOUT]
			, [ProductionDate], [NetWeight], [SSCC], VatNumber, DefaultWarehouse, DefaultLocation, DefaultWarehouseOut, DefaultLocationOut
			,ExpeditionWarehouse, ExpeditionLocation, IsFinalProductBOM)
			VALUES
			(@tempStampLin, @tempIDCabecalho, @tempIDLinha, @inRef, @inDescricao, @tempQty, @inLote, @tempNumeroSerie, @inUSERNAME, @DateStr, SUBSTRING(@TimeStr,1,6), @inStatus
			, @inTipoDocOrigem, @inSelectedNumDoc, 'N', '', '', '', @tempProcess, @inValidade
			, @inArmazem, @inLocalizacao, @inExternalDoc, @locEntityType, @inSelectedCodigoCliente, @tempInternalStampDoc, @inDocumentoDestinoSelecionado
			, @locTransactionDescription, @inSelectedNomeCli, @inNomeDoc, @tempPrice, @inUnidade, @tempQty2, @inUnidadeMovimentada
			, @inWarehouseOut, @inTerminalId, @inSelectedOriginalLineNumber, @inFechaLinha
			, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 2), ''))
			, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 4), ''))
			, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 6), ''))
			, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 8), ''))
			, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 10), ''))
			, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 12), ''))
			, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 14), ''))
			, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 15), ''))
			, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 2), ''))
			, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 4), ''))
			, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 6), ''))
			, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 8), ''))
			, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 10), ''))
			, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 12), ''))
			, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 14), ''))
			, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 15), ''))
			, @inGTIN, @inLoteOrigem, @inLocalizacaoOrigem, @inLocationOut
			, @inLoteDataProducao, @inPeso, @inSSCC,'','','','','','','',@inIsFinalProduct)

			If @@ERROR <> 0
			BEGIN
				SET @resultCode = -6
				SET @resultMsg = 'Erro ao inserir linhas do dossier!'
				GOTO SendResult
			END


			IF @inPackid <> ''
			BEGIN
				-- a adição no u_Kapps_PackingDetails não inclui:	
				-- [SSCC] [ProductionDate] [BestBeforeDate]
		 		INSERT INTO u_Kapps_PackingDetails  
				([PackID], [LineID], [StampLin], [Ref], [Description], [Lot], [Serial], [Quantity], [ExpirationDate]
				, [Status], [Location], [NetWeight], [QuantityUM], [Quantity2], [Quantity2UM])
				VALUES
				(@inPackID, '0', @tempStampLin, @inRef, @inDescricao, @inLote, @tempNumeroSerie, @tempQty, @inValidade
				, '1', @inLocalizacao, @inPeso, @inUnidade, @tempQty2, @inUnidadeMovimentada)

				IF @@ERROR <> 0
				BEGIN
					SET @resultCode = -7
					SET @resultMsg = 'Erro ao inserir detalhes do Packing!'
					GOTO SendResult
				END 
			END

			SET @resultCode = 1
			SET @resultMsg = 'StampLin'+' '+@tempStampLin
			--GOTO SendResult
		END
		ELSE -- se @inSelectedLinStamp <> ''
		BEGIN
			IF @inbiQtdDifLin >= @tempQtdEmFalta OR @inMULTI_DOCUMENT = '0' OR @inSelecionouDaGrelha = 1 OR (@inMoreLinesSameProductLinkToFirst = '1' AND @inMoreLinesSameProduct = '1' AND @inbiQtdDifLin <= 0)
			BEGIN
	 			SET @tempQtdExcedente = 0
	 			IF @inArtigoGereNumeroSerie = '1' AND @inGRIDFORSERIALNUMBERS = '1'
				BEGIN
					--SET @locQtd= string count @tempListaNumSerie + 1
					SET @RemExecResult=1
					EXEC @RemExecResult=SP_u_Kapps_SerialNumber_Insert  @tempStampLin, @tempListaNumeroSerie, @locQtd, @inSEP_ACL
					IF @RemExecResult<>0
					BEGIN
						SET @resultCode = -8
						SET @resultMsg = 'Erro ao inserir números de série.'
						GOTO SendResult
					END
					-- get @tempListaNumeroSerie
	 			END 
	 			SET @tempQty = @tempQtdEmFalta + @tempQtdExcedente
	 			SET @tempQty2 = (@tempQtdEmFalta + @tempQtdExcedente) / @inFatorConversao
	 			SET @tempIDCabecalho = @inSelectedCabStamp
	 			SET @tempIDLinha = @inSelectedLinStamp
			
				IF @tempProcess = 'DSO'
				BEGIN
					SET @tempInternalStampDoc = @tempIDCabecalho
				END
				ELSE
				BEGIN
					SET @tempInternalStampDoc = ''
				END

	 			-- a adição no u_Kapps_DossierLin não inclui:	
				-- [VatNumber] [StampDocGer] [DeliveryCustomer] [DeliveryCode] [DefaultWarehouse] [DefaultLocation] [DefaultWarehouseOut] [DefaultLocationOut] 
				-- [InternalDocType] [InternalQty] [ExpeditionWarehouse] [ExpeditionLocation] [StockBreakReason] [KeyDocGerado] [LoadNr]
				INSERT INTO u_Kapps_DossierLin 
				([StampLin], [StampBo], [StampBi], [Ref], [Description], [Qty], [Lot], [Serial], [UserID], [MovDate], [MovTime], [Status]
				, [DocType], [DocNumber], [Integrada], [DataIntegracao], [HoraIntegracao], [UserIntegracao], [Process], [Validade]
				, [Warehouse], [Location], [ExternalDocNum], [EntityType], [EntityNumber], [InternalStampDoc], [DestinationDocType]
				, [TransactionDescription], [EntityName], [DocName], [UnitPrice], [QtyUM], [Qty2], [Qty2UM]
				, [WarehouseOut], [TerminalID], [OriLineNumber], [LineClose]
				, [CabUserField1], [CabUserField2]
				, [CabUserField3], [CabUserField4]
				, [CabUserField5], [CabUserField6]
				, [CabUserField7], [CabUserField8]
				, [CabUserField9], [CabUserField10]
				, [CabUserField11], [CabUserField12]
				, [CabUserField13], [CabUserField14]
				, [CabUserField15]
				, [LinUserField1], [LinUserField2]
				, [LinUserField3], [LinUserField4]
				, [LinUserField5], [LinUserField6]
				, [LinUserField7], [LinUserField8]
				, [LinUserField9], [LinUserField10]
				, [LinUserField11], [LinUserField12]
				, [LinUserField13], [LinUserField14]
				, [LinUserField15]
				, [GTIN], [OriginalLot], [OriginalLocation], [LocationOUT]
				, [ProductionDate], [NetWeight], [SSCC], VatNumber, DefaultWarehouse, DefaultLocation, DefaultWarehouseOut, DefaultLocationOut
				,ExpeditionWarehouse, ExpeditionLocation, IsFinalProductBOM)
				VALUES
				(@tempStampLin, @tempIDCabecalho, @tempIDLinha, @inRef, @inDescricao, @tempQty, @inLote, @tempNumeroSerie, @inUSERNAME, @DateStr, SUBSTRING(@TimeStr,1,6), @inStatus
				, @inTipoDocOrigem, @inSelectedNumDoc, 'N', '', '', '', @tempProcess, @inValidade
				, @inArmazem, @inLocalizacao, @inExternalDoc, @locEntityType, @inSelectedCodigoCliente, @tempInternalStampDoc, @inDocumentoDestinoSelecionado
				, @locTransactionDescription, @inSelectedNomeCli, @inNomeDoc, @tempPrice, @inUnidade, @tempQty2, @inUnidadeMovimentada
				, @inWarehouseOut, @inTerminalId, @inSelectedOriginalLineNumber, @inFechaLinha
				, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 2), ''))
				, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 4), ''))
				, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 6), ''))
				, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 8), ''))
				, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 10), ''))
				, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 12), ''))
				, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 14), ''))
				, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 15), ''))
				, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 2), ''))
				, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 4), ''))
				, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 6), ''))
				, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 8), ''))
				, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 10), ''))
				, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 12), ''))
				, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 14), ''))
				, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 15), ''))
				, @inGTIN, @inLoteOrigem, @inLocalizacaoOrigem, @inLocationOut
				, @inLoteDataProducao, @inPeso, @inSSCC,'','','','','','','',@inIsFinalProduct)

				If @@ERROR <> 0
				BEGIN
					SET @resultCode = -9
					SET @resultMsg = 'Erro ao inserir linhas do dossier!'
					GOTO SendResult
				END

	 	
				IF @inPackid <> ''
				BEGIN
					-- a adição no u_Kapps_PackingDetails não inclui:	
					-- [SSCC] [ProductionDate] [BestBeforeDate]
		 			INSERT INTO u_Kapps_PackingDetails  
					([PackID], [LineID], [StampLin], [Ref], [Description], [Lot], [Serial], [Quantity], [ExpirationDate]
					, [Status], [Location], [NetWeight], [QuantityUM], [Quantity2], [Quantity2UM])
					VALUES
					(@inPackID, '0', @tempStampLin, @inRef, @inDescricao, @inLote, @tempNumeroSerie, @tempQty, @inValidade
					, '1', @inLocalizacao, @inPeso, @inUnidade, @tempQty2, @inUnidadeMovimentada)

					IF @@ERROR <> 0
					BEGIN
						SET @resultCode = -10
						SET @resultMsg = 'Erro ao inserir detalhes do Packing!'
						GOTO SendResult
					END 
				END

				SET @resultCode = 1
				SET @resultMsg = 'StampLin'+' '+@tempStampLin
				--GOTO SendResult
			END
			ELSE
			BEGIN
	 			SET @tempTFilterCabDoc = Replace(@inFilterCabDoc, @inSEP_ACL, ',')
	 			SET @PesoEmFalta = @inPeso
				-- Set Value  (TVAR(row); Numeric; 1)
	 			-- Procurar especificamente o lote e a localização
	 			SET @FiltroLoteLocalizacao = ' AND lin.Lot=''' + @inLote + ''' '

	 			IF @inGENERAL_LOCATIONS_CTRL = 1
				BEGIN
	 	 			SET @FiltroLoteLocalizacao = @FiltroLoteLocalizacao + ' AND lin.Location=''' + @inLocalizacao + ''''
	 			END
			
				-- Para executar duas vezes o código --- Error executing dynamic cursor
				DECLARE @Ciclo INT = 1
				WHILE @Ciclo <= 2
				BEGIN
					DECLARE @Select NVARCHAR(MAX) = 'DECLARE DTListaDocLin CURSOR FAST_FORWARD GLOBAL
					FOR SELECT lin.QuantityPending*lin.ConversionFator, lin.' + @locLineKey + ', lin.' + @locCabKey + ', doc.DocumentName, lin.TPD, lin.NDC '+
						'FROM ' + @locLinView + ' lin '+
						'LEFT JOIN ' + @locCabView + ' doc ON doc.EXR = lin.EXR AND doc.SEC = lin.SEC and doc.TPD = lin.TPD and doc.NDC = lin.NDC '+
						'WHERE lin.' + @locCabKey + ' IN (' + @tempTFilterCabDoc + ') AND lin.Article = ''' + @inRef + ''' ' +
						@inAllowedLocations + ' AND lin.QuantityPending > 0 ' + @FiltroLoteLocalizacao + ' ' + @locOrdenacaoProcurar
					EXEC sp_executesql @select
					OPEN DTListaDocLin

					FETCH NEXT FROM DTListaDocLin
					INTO @tempQtdPend, @tempIDLinha, @tempIDCabecalho, @tempNomeDoc, @tempTPD, @tempNumDoc
					WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @DateTimeTmp = GETDATE()
						SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
						SET @tempStampLin = @inTerminalId + '-' + @tempProcess + '-' + @DateStr + '-' + @TimeStr

		 	 			-- Retirar condição MultiDocument  ???
	 	 	 			IF  @inMULTI_DOCUMENT = '0' OR (@inMULTI_DOCUMENT = '1' AND (@tempQtdPend >= @tempQtdEmFalta))
						BEGIN
	 	 	 	 			IF  (@inArtigoGereNumeroSerie = '1' AND @inGRIDFORSERIALNUMBERS = '1')
							BEGIN
								--SET @locQtd= string count @tempListaNumSerie + 1
								SET @RemExecResult=1
								EXEC @RemExecResult=SP_u_Kapps_SerialNumber_Insert  @tempStampLin, @tempListaNumeroSerie, @locQtd, @inSEP_ACL
								IF @RemExecResult<>0
								BEGIN
									SET @resultCode = -11
									SET @resultMsg = 'Erro ao inserir números de série.'
									GOTO SendResult
								END
								--get @tempListaNumeroSerie
	 	 	 	 			END

							SET @tempQty = @tempQtdEmFalta + @tempQtdExcedente
	 						SET @tempQty2 = (@tempQtdEmFalta + @tempQtdExcedente) / @inFatorConversao
	 						--SET @tempIDCabecalho = @inSelectedCabStamp
	 						SET @tempIDLinha = @inSelectedLinStamp
						
							IF @tempProcess = 'DSO'
							BEGIN
								SET @tempInternalStampDoc = @tempIDCabecalho
							END
							ELSE
							BEGIN
								SET @tempInternalStampDoc = ''
							END

	 						-- a adição no u_Kapps_DossierLin não inclui:	
							-- [VatNumber] [StampDocGer] [DeliveryCustomer] [DeliveryCode] [DefaultWarehouse] [DefaultLocation] [DefaultWarehouseOut] [DefaultLocationOut] 
							-- [InternalDocType] [InternalQty] [ExpeditionWarehouse] [ExpeditionLocation] [StockBreakReason] [KeyDocGerado] [LoadNr]
							INSERT INTO u_Kapps_DossierLin 
							([StampLin], [StampBo], [StampBi], [Ref], [Description], [Qty], [Lot], [Serial], [UserID], [MovDate], [MovTime], [Status]
							, [DocType], [DocNumber], [Integrada], [DataIntegracao], [HoraIntegracao], [UserIntegracao], [Process], [Validade]
							, [Warehouse], [Location], [ExternalDocNum], [EntityType], [EntityNumber], [InternalStampDoc], [DestinationDocType]
							, [TransactionDescription], [EntityName], [DocName], [UnitPrice], [QtyUM], [Qty2], [Qty2UM]
							, [WarehouseOut], [TerminalID], [OriLineNumber], [LineClose]
							, [CabUserField1], [CabUserField2]
							, [CabUserField3], [CabUserField4]
							, [CabUserField5], [CabUserField6]
							, [CabUserField7], [CabUserField8]
							, [CabUserField9], [CabUserField10]
							, [CabUserField11], [CabUserField12]
							, [CabUserField13], [CabUserField14]
							, [CabUserField15]
							, [LinUserField1], [LinUserField2]
							, [LinUserField3], [LinUserField4]
							, [LinUserField5], [LinUserField6]
							, [LinUserField7], [LinUserField8]
							, [LinUserField9], [LinUserField10]
							, [LinUserField11], [LinUserField12]
							, [LinUserField13], [LinUserField14]
							, [LinUserField15]
							, [GTIN], [OriginalLot], [OriginalLocation], [LocationOUT]
							, [ProductionDate], [NetWeight], [SSCC], VatNumber, DefaultWarehouse, DefaultLocation, DefaultWarehouseOut, DefaultLocationOut
							,ExpeditionWarehouse, ExpeditionLocation, IsFinalProductBOM)
							VALUES
							(@tempStampLin, @tempIDCabecalho, @tempIDLinha, @inRef, @inDescricao, @tempQty, @inLote, @tempNumeroSerie, @inUSERNAME, @DateStr, SUBSTRING(@TimeStr,1,6), @inStatus
							, @tempTPD, @tempNumDoc, 'N', '', '', '', @tempProcess, @inValidade
							, @inArmazem, @inLocalizacao, @inExternalDoc, @locEntityType, @inSelectedCodigoCliente, @tempInternalStampDoc, @inDocumentoDestinoSelecionado
							, @locTransactionDescription, @inSelectedNomeCli, @tempNomeDoc, @tempPrice, @inUnidade, @tempQty2, @inUnidadeMovimentada
							, @inWarehouseOut, @inTerminalId, @inSelectedOriginalLineNumber, @inFechaLinha
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 2), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 4), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 6), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 8), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 10), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 12), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 14), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 15), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 2), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 4), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 6), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 8), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 10), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 12), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 14), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 15), ''))
							, @inGTIN, @inLoteOrigem, @inLocalizacaoOrigem, @inLocationOut
							, @inLoteDataProducao, @PesoEmFalta, @inSSCC,'','','','','','','',@inIsFinalProduct)

							If @@ERROR <> 0
							BEGIN
								SET @resultCode = -12
								SET @resultMsg = 'Erro ao inserir linhas do dossier!'
								GOTO SendResult
							END

	 	
							IF @inPackid <> ''
							BEGIN
								-- a adição no u_Kapps_PackingDetails não inclui:	
								-- [SSCC] [ProductionDate] [BestBeforeDate]
		 						INSERT INTO u_Kapps_PackingDetails  
								([PackID], [LineID], [StampLin], [Ref], [Description], [Lot], [Serial], [Quantity], [ExpirationDate]
								, [Status], [Location], [NetWeight], [QuantityUM], [Quantity2], [Quantity2UM])
								VALUES
								(@inPackID, '0', @tempStampLin, @inRef, @inDescricao, @inLote, @tempNumeroSerie, @tempQty, @inValidade
								, '1', @inLocalizacao, @PesoEmFalta, @inUnidade, @tempQty2, @inUnidadeMovimentada)

								IF @@ERROR <> 0
								BEGIN
									SET @resultCode = -13
									SET @resultMsg = 'Erro ao inserir detalhes do Packing!'
									GOTO SendResult
								END 
							END

							SET @resultCode = 1
							SET @resultMsg = 'StampLin'+' '+@tempStampLin
							--GOTO SendResult
	 	 	 	 			--BREAK
	 	 	 			END
						ELSE
						BEGIN
							IF  (@inArtigoGereNumeroSerie = '1' AND @inGRIDFORSERIALNUMBERS = '1')
							BEGIN
							SET @locQtd = (@tempQtdPend + @tempQtdExcedente)
								SET @RemExecResult=1
								EXEC @RemExecResult=SP_u_Kapps_SerialNumber_Insert  @tempStampLin, @tempListaNumeroSerie, @locQtd, @inSEP_ACL
								IF @RemExecResult<>0
								BEGIN
									SET @resultCode = -14
									SET @resultMsg = 'Erro ao inserir números de série.'
									GOTO SendResult
								END
								--get @tempListaNumeroSerie
	 	 	 	 			END

	 	 	 				-- Verificar condição abaixo
	 	 	 	 			IF  (@tempQtdPend + @tempQtdExcedente) > @inQuantity
							BEGIN
	 	 	 	 	 			SET @tempQtdExcedente = @tempQtdExcedente - @tempQtdPend
	 	 	 	 			END 
						
							SET @DateTimeTmp = GETDATE()
							SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
							SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)

							SET @tempQty = @tempQtdPend + @tempQtdExcedente
	 						SET @tempQty2 = (@tempQtdPend + @tempQtdExcedente) / @inFatorConversao
							SET @tempPeso = (@PesoEmFalta / @tempQtdPend)
	 						--SET @tempIDCabecalho = @inSelectedCabStamp
	 						SET @tempIDLinha = @inSelectedLinStamp
						
							IF @tempProcess = 'DSO'
							BEGIN
								SET @tempInternalStampDoc = @tempIDCabecalho
							END
							ELSE
							BEGIN
								SET @tempInternalStampDoc = ''
							END

							-- a adição no u_Kapps_DossierLin não inclui:	
							-- [VatNumber] [StampDocGer] [DeliveryCustomer] [DeliveryCode] [DefaultWarehouse] [DefaultLocation] [DefaultWarehouseOut] [DefaultLocationOut] 
							-- [InternalDocType] [InternalQty] [ExpeditionWarehouse] [ExpeditionLocation] [StockBreakReason] [KeyDocGerado] [LoadNr]
							INSERT INTO u_Kapps_DossierLin 
							([StampLin], [StampBo], [StampBi], [Ref], [Description], [Qty], [Lot], [Serial], [UserID], [MovDate], [MovTime], [Status]
							, [DocType], [DocNumber], [Integrada], [DataIntegracao], [HoraIntegracao], [UserIntegracao], [Process], [Validade]
							, [Warehouse], [Location], [ExternalDocNum], [EntityType], [EntityNumber], [InternalStampDoc], [DestinationDocType]
							, [TransactionDescription], [EntityName], [DocName], [UnitPrice], [QtyUM], [Qty2], [Qty2UM]
							, [WarehouseOut], [TerminalID], [OriLineNumber], [LineClose]
							, [CabUserField1], [CabUserField2]
							, [CabUserField3], [CabUserField4]
							, [CabUserField5], [CabUserField6]
							, [CabUserField7], [CabUserField8]
							, [CabUserField9], [CabUserField10]
							, [CabUserField11], [CabUserField12]
							, [CabUserField13], [CabUserField14]
							, [CabUserField15]
							, [LinUserField1], [LinUserField2]
							, [LinUserField3], [LinUserField4]
							, [LinUserField5], [LinUserField6]
							, [LinUserField7], [LinUserField8]
							, [LinUserField9], [LinUserField10]
							, [LinUserField11], [LinUserField12]
							, [LinUserField13], [LinUserField14]
							, [LinUserField15]
							, [GTIN], [OriginalLot], [OriginalLocation], [LocationOUT]
							, [ProductionDate], [NetWeight], [SSCC], VatNumber, DefaultWarehouse, DefaultLocation, DefaultWarehouseOut, DefaultLocationOut
							,ExpeditionWarehouse, ExpeditionLocation, IsFinalProductBOM)
							VALUES
							(@tempStampLin, @tempIDCabecalho, @tempIDLinha, @inRef, @inDescricao, @tempQty, @inLote, @tempNumeroSerie, @inUSERNAME, @DateStr, SUBSTRING(@TimeStr,1,6), @inStatus
							, @tempTPD, @tempNumDoc, 'N', '', '', '', @tempProcess, @inValidade
							, @inArmazem, @inLocalizacao, @inExternalDoc, @locEntityType, @inSelectedCodigoCliente, @tempInternalStampDoc, @inDocumentoDestinoSelecionado
							, @locTransactionDescription, @inSelectedNomeCli, @tempNomeDoc, @tempPrice, @inUnidade, @tempQty2, @inUnidadeMovimentada
							, @inWarehouseOut, @inTerminalId, @inSelectedOriginalLineNumber, @inFechaLinha
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 2), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 4), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 6), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 8), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 10), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 12), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 14), ''))
							, (SELECT COALESCE((SELECT elCabUserField FROM @tbListaCabUserField WHERE elOrdinal = 15), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 1), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 2), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 3), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 4), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 5), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 6), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 7), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 8), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 9), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 10), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 11), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 12), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 13), '')), (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 14), ''))
							, (SELECT COALESCE((SELECT elLinUserField FROM @tbListaLinUserField WHERE elOrdinal = 15), ''))
							, @inGTIN, @inLoteOrigem, @inLocalizacaoOrigem, @inLocationOut
							, @inLoteDataProducao, @inPeso, @inSSCC,'','','','','','','',@inIsFinalProduct)

							If @@ERROR <> 0
							BEGIN
								SET @resultCode = -15
								SET @resultMsg = 'Erro ao inserir linhas do dossier!'
								GOTO SendResult
							END
							 	
							IF @inPackid <> ''
							BEGIN
								-- a adição no u_Kapps_PackingDetails não inclui:	
								-- [SSCC] [ProductionDate] [BestBeforeDate]
		 						INSERT INTO u_Kapps_PackingDetails  
								([PackID], [LineID], [StampLin], [Ref], [Description], [Lot], [Serial], [Quantity], [ExpirationDate]
								, [Status], [Location], [NetWeight], [QuantityUM], [Quantity2], [Quantity2UM])
								VALUES
								(@inPackID, '0', @tempStampLin, @inRef, @inDescricao, @inLote, @tempNumeroSerie, @tempQty, @inValidade
								, '1', @inLocalizacao, @tempPeso, @inUnidade, @tempQty2, @inUnidadeMovimentada)

								IF @@ERROR <> 0
								BEGIN
									SET @resultCode = -16
									SET @resultMsg = 'Erro ao inserir detalhes do Packing!'
									GOTO SendResult
								END 
							END
						
	 	 	 	 			-- verificar calculo PesoEmFalta / tempQtdPend
	 	 	 	 			SET @tempQtdEmFalta = @tempQtdEmFalta - @tempQty
	 	 	 	 			SET @PesoEmFalta = @PesoEmFalta - @tempPeso
						
							IF @tempQtdEmFalta <= 0
							BEGIN
								SET @resultCode = 1
								SET @resultMsg = 'StampLin'+' '+@tempStampLin
								--GOTO SendResult
							END
	 	 	 			END 
	 	 	 			SET @tempQtdExcedente = 0

						FETCH NEXT FROM DTListaDocLin
						INTO @tempQtdPend, @tempIDLinha, @tempIDCabecalho, @tempNomeDoc, @tempTPD, @tempNumDoc
				
					END
					CLOSE DTListaDocLin
					DEALLOCATE DTListaDocLin
				
					--Abater noutros lotes / localizacoes
	 	 			SET @FiltroLoteLocalizacao = ''

					IF @tempQtdEmFalta >= 1
					BEGIN
						SET @Ciclo = 3
					END
					ELSE
					BEGIN
	 	 				SET @Ciclo = @Ciclo + 1
					END
	 			END

			END
		
			IF @resultCode <= 0
			BEGIN
				GOTO SendResult
			END

		END

	END
	--
	-- Insere no log se localização introduzida diferente da localização do documento de origem
	--
	IF @inGENERAL_LOCATIONS_CTRL = 1  AND @inIsFinalProduct <> '1'
	BEGIN
		SET @RemExecResult=1
		EXEC @RemExecResult=SP_u_Kapps_Location_InsertLogModify   @inLocalizacaoOrigem, @inLocalizacao, @inTipoDocOrigem, @inSelectedNumDoc, @inNomeDoc, @inRef, @inTerminalId
		IF @RemExecResult<>0
		BEGIN
			SET @resultCode = -17
			SET @resultMsg = 'Erro ao inserir registo de alterações.'
			GOTO SendResult
		END
	END 
	--
	-- atualiza tabela com doc.temporário, criado a partir da ficha técnica, se evento for criação de "kit cego"
	--
	IF @inEvento = '5' AND @inIsFinalProduct <> '1'
	BEGIN
		UPDATE u_Kapps_tBOM_Items SET QuantityPending = (QuantityPending - @inQuantity), QuantityPicked = (QuantityPicked + @inQuantity) WHERE BOMKey=@inSelectedCabStamp AND BOMItemsKey=@inSelectedLinStamp

		If @@ERROR <> 0
		BEGIN
			SET @resultCode = -18
			SET @resultMsg = 'Erro ao atualizar linhas do documento «Ficha Técnica».'
			GOTO SendResult
		END
	END


	SendResult:

	IF @resultCode = 1
	BEGIN
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
	END

	-- @resultCode 		OK=1 ou NOK<=0
	-- @resultMsg 		Descrição do erro
	IF @resultCode = 1 AND (@Aviso1 > '' OR @Aviso2 > '')
	BEGIN
		SET @resultCode = 2
	END
	SELECT @resultCode, @Aviso1 + @Aviso2 + @resultMsg

	RETURN

END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_BOM_CheckQuantity') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_BOM_CheckQuantity
GO
CREATE PROCEDURE SP_u_Kapps_BOM_CheckQuantity
	
	@inBOMKey CHAR(25),
	@inDta_Origin VARCHAR(10)

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iArticle char(100)
	DECLARE @iDescription varchar(200)
	DECLARE @iQuantity numeric(14,4)
	DECLARE @iQuantityPending numeric(14,4)
	DECLARE @iSequence int
	DECLARE @iReplaceable bit
	DECLARE @iTolerance int
	DECLARE @iBOMItemsKey char(25)

	DECLARE @dQuantity numeric(14,4)
	DECLARE @cMax float
	DECLARE @cMin float
	DECLARE @cPct float

	Set @cMax = 0
	Set @cMin = 0
	Set @cPct = 100

	DECLARE @tmpException VARCHAR(250)

	Set @tmpException = ''

	IF @inDta_Origin = '1'
	BEGIN
		DECLARE cur_Items CURSOR
		FAST_FORWARD 
		FOR SELECT Article, [Description], Quantity, QuantityPending, [Sequence], Replaceable, Tolerance, BOMItemsKey
			FROM u_Kapps_tBOM_Items AS Items WITH(NOLOCK)
			WHERE Items.IsComponent = 1 AND Items.BOMKey = @inBOMKey AND QuantityPending > 0
			ORDER BY Items.[Sequence], Items.BOMItemsKey
	END
	ELSE
	BEGIN
		DECLARE cur_Items CURSOR
		FAST_FORWARD 
		FOR SELECT Article, [Description], Quantity, QuantityPending, [Sequence], Replaceable, Tolerance, BOMItemsKey
			FROM v_Kapps_BOM_Items AS Items WITH(NOLOCK)
			WHERE Items.IsComponent = 1 AND Items.BOMKey = @inBOMKey AND QuantityPending > 0
			ORDER BY Items.[Sequence], Items.BOMItemsKey
	END

	OPEN cur_Items

	FETCH NEXT FROM cur_Items
		INTO @iArticle, @iDescription, @iQuantity, @iQuantityPending, @iSequence, @iReplaceable, @iTolerance, @iBOMItemsKey

	WHILE @@FETCH_STATUS = 0 AND @tmpException = ''
	BEGIN
	
		SET @dQuantity = (select sum(Qty) from u_Kapps_DossierLin as Dossier Where StampBi = @iBOMItemsKey and StampBo = @inBOMKey)

		IF @iQuantity<>COALESCE(@dQuantity,0)
		BEGIN
			IF @iTolerance = 0
			BEGIN
				SET @tmpException = 'Quantidade por satisfazer no componente [' + RTRIM(@iArticle) + ']' + ' ' + RTRIM(@iDescription)
			END
			ELSE
			BEGIN
				Set @cMax = (@iQuantity + (@iQuantity * (@iTolerance / @cPct)))
				Set @cMin = (@iQuantity - (@iQuantity * (@iTolerance / @cPct)))
				IF ((@dQuantity < @iQuantity) AND (@dQuantity < @cMin)) OR ((@dQuantity > @iQuantity) AND (@dQuantity > @cMax))
				BEGIN
					SET @tmpException = 'Quantidade fora dos limites de tolerância para o componente [' + RTRIM(@iArticle) + ']' + ' ' + RTRIM(@iDescription)
					----purpose of debug
					--SET @tmpException = 'Quantidade fora dos limites de tolerância para o componente [' + RTRIM(@iArticle) + ']' + ' ' + RTRIM(@iDescription +' '
					--+ concat (' Qtd dossier ' , @dQuantity , ' Qtd pedida ' , @iQuantity , ' Max ' , @cMax , ' Min ' , @cMin, ' tolerância ', @iTolerance))
				END
			END
		END

		--Select '7', 'Qtd pedido: '+CONVERT(VARCHAR(50),@iQuantity) + ' Qtd lida: '+CONVERT(VARCHAR(50),COALESCE(@dQuantity,0)) + ' Tolerância: ' + CONVERT(VARCHAR(50),@iTolerance)

		FETCH NEXT FROM cur_Items
			INTO @iArticle, @iDescription, @iQuantity, @iQuantityPending, @iSequence, @iReplaceable, @iTolerance, @iBOMItemsKey
	END

	CLOSE cur_Items
	DEALLOCATE cur_Items

	IF @tmpException <> ''
	BEGIN
		Select '-1', @tmpException
	END
	ELSE
	BEGIN
		Select '0', 'It´s OK'
	END

END
GO



DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_SSCC_NextNumberUSR
	@EntityNumber VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON; ';

EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_SSCC_NextNumberUSR', @SPnewSQL, 'DECLARE @NextNumber INT', 'DECLARE @NextNumber CHAR(17)', 'SET @NextNumber = -1', '';
EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_SSCC_NextNumberUSR', @SPnewSQL, 'DECLARE @NextNumber CHAR(17)', 'DECLARE @NextNumber CHAR(18)', '', '';
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_UpdatePalletLocation') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_UpdatePalletLocation
GO
CREATE PROCEDURE SP_u_Kapps_UpdatePalletLocation
	@DocID nvarchar(50),
	@Warehouse nvarchar(50),
	@Location nvarchar(50),
	@WarehouseOut nvarchar(50),
	@LocationOut nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @resultCode int
	DECLARE @resultMsg nvarchar(250)
	DECLARE @Parametros nvarchar(250)

	DECLARE @inTransaction bit
	DECLARE @Recordcount int

	DECLARE @ErrorID int

	SET @Parametros = ''''+@DocID + ''', '''+ @Warehouse + ''','''+ @Location+ ''','''+ @WarehouseOut + ''','''+ @LocationOut+'''';

	SET @resultMsg = ''
	SET @resultCode = 0
	SET @inTransaction = 0
	SET @ErrorID = 0

	BEGIN TRY

		IF LTRIM(@DocID)=''
		BEGIN
			SET @ErrorID=1
			SET @resultMsg='Documento não pode ser vazio'
		END
		ELSE IF LTRIM(@WarehouseOut)=''
		BEGIN
			SET @ErrorID=2
			SET @resultMsg='Armazém de destino não pode ser vazio'
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION
			SET @inTransaction=1
			SELECT @Recordcount=count(*) FROM u_Kapps__DummyLock (TABLOCKX)


			UPDATE u_Kapps_PackingHeader
			SET CurrentWarehouse=@WarehouseOut, CurrentLocation=@LocationOut
			WHERE LTRIM(SSCC)<>'' and SSCC in
				(
				select SSCC 
				from u_Kapps_LoadingPallets 
				where LoadNr in (SELECT LoadNr FROM u_Kapps_DossierLin WHERE KeyDocGerado=@DocID and LoadNr>0)
				);

			IF @@ROWCOUNT=0
			BEGIN
				SET @ErrorID=3
				SET @resultMsg='Não foi encontrada nenhuma palete'
			END
			ELSE
			BEGIN
				SET @resultCode = 1

				INSERT INTO u_Kapps_LogSP(LogDate, LogTime, LogErrorID, LogDescription, LogSP, LogParameters)
				VALUES (CONVERT(VARCHAR, GETDATE(), 112), LEFT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),6), 0, 'OK', 'SP_u_Kapps_UpdatePalletLocation', @Parametros);
			END

			COMMIT TRANSACTION
		END
		IF @resultCode=0
		BEGIN
			SET @resultMsg = '('+CAST(@ErrorID as varchar(3))+') ' + @resultMsg
		END
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		IF @inTransaction=1
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @resultCode = 0
		SET @resultMsg = '('+CAST(@ErrorID as varchar(3))+') ' + @ErrorMessage 
					
		INSERT INTO u_Kapps_LogSP(LogDate, LogTime, LogErrorID, LogDescription, LogSP, LogParameters)
		VALUES (CONVERT(VARCHAR, GETDATE(), 112), LEFT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),6), @ErrorID, @resultMsg, 'SP_u_Kapps_UpdatePalletLocation', @Parametros);

		IF @ErrorID=0
		BEGIN
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		END
		SET @ErrorID=0

	END CATCH


	IF @ErrorID>0
	BEGIN
		INSERT INTO u_Kapps_LogSP(LogDate, LogTime, LogErrorID, LogDescription, LogSP, LogParameters)
		VALUES (CONVERT(VARCHAR, GETDATE(), 112), LEFT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),6), @ErrorID, @resultMsg, 'SP_u_Kapps_UpdatePalletLocation', @Parametros);
	END

	SELECT @resultCode, @resultMsg
END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_CalculateUserFieldsUSR') AND type in (N'P', N'PC'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE PROCEDURE SP_u_Kapps_CalculateUserFieldsUSR
	@TerminalID INT,					--	ID do terminal
	@UserID VARCHAR(50),				--	Código do utilizador
	@ProcessID VARCHAR(25),				--	ID do Processo
	@CurrentWarehouse NVARCHAR(50),		--	Armazém atual
	@ProcessType VARCHAR(5),			--	Processo usa documento com origem (DCO) ou sem origem (DSO)
	@DocType NVARCHAR(25),				--	Tipo de documento a criar (apenas quando é DSO)
	@StampDoc NVARCHAR(2000),			--	Lista de stamps selecionados (DCO) ou InternalStampDoc (DSO)
	@EntityType VARCHAR(50),			--	Tipo de entidade
	@EntityNumber VARCHAR(50),			--	Codigo da entidade
	@DisplayAT VARCHAR(50),				--	Mostra inicio (B), fim (E) ou ambos (BE)
	@UserFieldType VARCHAR(50),			--	Tipo de campo (LIN ou CAB)
	@UserField1 VARCHAR(MAX),			--	Conteudo do campo de utilizador 1
	@UserField2 VARCHAR(MAX),			--	Conteudo do campo de utilizador 2
	@UserField3 VARCHAR(MAX),			--	Conteudo do campo de utilizador 3
	@UserField4 VARCHAR(MAX),			--	Conteudo do campo de utilizador 4
	@UserField5 VARCHAR(MAX),			--	Conteudo do campo de utilizador 5
	@UserField6 VARCHAR(MAX),			--	Conteudo do campo de utilizador 6
	@UserField7 VARCHAR(MAX),			--	Conteudo do campo de utilizador 7
	@UserField8 VARCHAR(MAX),			--	Conteudo do campo de utilizador 8
	@UserField9 VARCHAR(MAX),			--	Conteudo do campo de utilizador 9
	@UserField10 VARCHAR(MAX),			--	Conteudo do campo de utilizador 10
	@UserField11 VARCHAR(MAX),			--	Conteudo do campo de utilizador 11
	@UserField12 VARCHAR(MAX),			--	Conteudo do campo de utilizador 12
	@UserField13 VARCHAR(MAX),			--	Conteudo do campo de utilizador 13
	@UserField14 VARCHAR(MAX),			--	Conteudo do campo de utilizador 14
	@UserField15 VARCHAR(MAX)			--	Conteudo do campo de utilizador 15
AS
BEGIN
	DECLARE @Out1 VARCHAR(MAX)
	DECLARE @Out2 VARCHAR(MAX)
	DECLARE @Out3 VARCHAR(MAX)
	DECLARE @Out4 VARCHAR(MAX)
	DECLARE @Out5 VARCHAR(MAX)
	DECLARE @Out6 VARCHAR(MAX)
	DECLARE @Out7 VARCHAR(MAX)
	DECLARE @Out8 VARCHAR(MAX)
	DECLARE @Out9 VARCHAR(MAX)
	DECLARE @Out10 VARCHAR(MAX)
	DECLARE @Out11 VARCHAR(MAX)
	DECLARE @Out12 VARCHAR(MAX)
	DECLARE @Out13 VARCHAR(MAX)
	DECLARE @Out14 VARCHAR(MAX)
	DECLARE @Out15 VARCHAR(MAX)
	  
	SET @Out1 = @UserField1
	SET @Out2 = @UserField2
	SET @Out3 = @UserField3
	SET @Out4 = @UserField4
	SET @Out5 = @UserField5
	SET @Out6 = @UserField6
	SET @Out7 = @UserField7
	SET @Out8 = @UserField8
	SET @Out9 = @UserField9
	SET @Out10 = @UserField10
	SET @Out11 = @UserField11
	SET @Out12 = @UserField12
	SET @Out13 = @UserField13
	SET @Out14 = @UserField14
	SET @Out15 = @UserField15

	SET NOCOUNT ON;

	-- Colocar o código a partir deste ponto


	SELECT @Out1 as OUT1, @Out2 as OUT2, @Out3 as OUT3, @Out4 as OUT4, @Out5 as OUT5, @Out6 as OUT6, @Out7 as OUT7, @Out8 as OUT8, @Out9 as OUT9, @Out10 as OUT10, @Out11 as OUT11, @Out12 as OUT12, @Out13 as OUT13, @Out14 as OUT14, @Out15 as OUT15
END
GO
SET NOEXEC OFF
GO



DECLARE @SPnewSQL varchar(max) = 'CREATE PROCEDURE SP_u_Kapps_CalculateUserFieldsUSR
	@inTerminalID INT,					-- ID do terminal
	@inUserID VARCHAR(50),				-- Código do utilizador
	@inProcessID VARCHAR(25),			-- ID do Processo
	@inCurrentWarehouse NVARCHAR(50),	-- Armazém atual
	@inProcessType NVARCHAR(5),			-- Tipo de processo com origem (DCO) ou sem origem (DSO)
	@inDocType NVARCHAR(25),			-- Tipo de documento a criar (apenas quando é DSO)
	@inStampDoc NVARCHAR(2000),			-- Lista de stamps selecionados (DCO) ou InternalStampDoc (DSO)
	@inEntityType NVARCHAR(50),			-- Tipo de entidade
	@inEntityNumber NVARCHAR(50),		-- Codigo da entidade
	@inRef NVARCHAR(50),				-- Referência do artigo
	@inStampBo NVARCHAR(50),			-- Chave única do documento de origem
	@inStampBi NVARCHAR(50),			-- Chave única da linha do documento de origem
	@inDisplayAT VARCHAR(50),			-- Mostra inicio (B), fim (E) ou ambos (BE)
	@inFieldType VARCHAR(50),			-- Tipo de campo (LIN ou CAB)
	@inCurrentField INT,				-- Numero do campo atual
	@inUser1 VARCHAR(MAX),				-- Conteudo do campo de utilizador 1
	@inUser2 VARCHAR(MAX),				-- Conteudo do campo de utilizador 2
	@inUser3 VARCHAR(MAX),				-- Conteudo do campo de utilizador 3
	@inUser4 VARCHAR(MAX),				-- Conteudo do campo de utilizador 4
	@inUser5 VARCHAR(MAX),				-- Conteudo do campo de utilizador 5
	@inUser6 VARCHAR(MAX),				-- Conteudo do campo de utilizador 6
	@inUser7 VARCHAR(MAX),				-- Conteudo do campo de utilizador 7
	@inUser8 VARCHAR(MAX),				-- Conteudo do campo de utilizador 8
	@inUser9 VARCHAR(MAX),				-- Conteudo do campo de utilizador 9
	@inUser10 VARCHAR(MAX),				-- Conteudo do campo de utilizador 10
	@inUser11 VARCHAR(MAX),				-- Conteudo do campo de utilizador 11
	@inUser12 VARCHAR(MAX),				-- Conteudo do campo de utilizador 12
	@inUser13 VARCHAR(MAX),				-- Conteudo do campo de utilizador 13
	@inUser14 VARCHAR(MAX),				-- Conteudo do campo de utilizador 14
	@inUser15 VARCHAR(MAX),				-- Conteudo do campo de utilizador 15
	@inDesc1 VARCHAR(MAX),				-- Descricao do campo de utilizador 1 quando é do tipo lista
	@inDesc2 VARCHAR(MAX),				-- Descricao do campo de utilizador 2 quando é do tipo lista
	@inDesc3 VARCHAR(MAX),				-- Descricao do campo de utilizador 3 quando é do tipo lista
	@inDesc4 VARCHAR(MAX),				-- Descricao do campo de utilizador 4 quando é do tipo lista
	@inDesc5 VARCHAR(MAX),				-- Descricao do campo de utilizador 5 quando é do tipo lista
	@inDesc6 VARCHAR(MAX),				-- Descricao do campo de utilizador 6 quando é do tipo lista
	@inDesc7 VARCHAR(MAX),				-- Descricao do campo de utilizador 7 quando é do tipo lista
	@inDesc8 VARCHAR(MAX),				-- Descricao do campo de utilizador 8 quando é do tipo lista
	@inDesc9 VARCHAR(MAX),				-- Descricao do campo de utilizador 9 quando é do tipo lista
	@inDesc10 VARCHAR(MAX),				-- Descricao do campo de utilizador 10 quando é do tipo lista
	@inDesc11 VARCHAR(MAX),				-- Descricao do campo de utilizador 11 quando é do tipo lista
	@inDesc12 VARCHAR(MAX),				-- Descricao do campo de utilizador 12 quando é do tipo lista
	@inDesc13 VARCHAR(MAX),				-- Descricao do campo de utilizador 13 quando é do tipo lista
	@inDesc14 VARCHAR(MAX),				-- Descricao do campo de utilizador 14 quando é do tipo lista
	@inDesc15 VARCHAR(MAX)				-- Descricao do campo de utilizador 15 quando é do tipo lista
AS
BEGIN
	DECLARE @outCode1 VARCHAR(MAX)
	DECLARE @outCode2 VARCHAR(MAX)
	DECLARE @outCode3 VARCHAR(MAX)
	DECLARE @outCode4 VARCHAR(MAX)
	DECLARE @outCode5 VARCHAR(MAX)
	DECLARE @outCode6 VARCHAR(MAX)
	DECLARE @outCode7 VARCHAR(MAX)
	DECLARE @outCode8 VARCHAR(MAX)
	DECLARE @outCode9 VARCHAR(MAX)
	DECLARE @outCode10 VARCHAR(MAX)
	DECLARE @outCode11 VARCHAR(MAX)
	DECLARE @outCode12 VARCHAR(MAX)
	DECLARE @outCode13 VARCHAR(MAX)
	DECLARE @outCode14 VARCHAR(MAX)
	DECLARE @outCode15 VARCHAR(MAX)

	DECLARE @outDesc1 VARCHAR(MAX)
	DECLARE @outDesc2 VARCHAR(MAX)
	DECLARE @outDesc3 VARCHAR(MAX)
	DECLARE @outDesc4 VARCHAR(MAX)
	DECLARE @outDesc5 VARCHAR(MAX)
	DECLARE @outDesc6 VARCHAR(MAX)
	DECLARE @outDesc7 VARCHAR(MAX)
	DECLARE @outDesc8 VARCHAR(MAX)
	DECLARE @outDesc9 VARCHAR(MAX)
	DECLARE @outDesc10 VARCHAR(MAX)
	DECLARE @outDesc11 VARCHAR(MAX)
	DECLARE @outDesc12 VARCHAR(MAX)
	DECLARE @outDesc13 VARCHAR(MAX)
	DECLARE @outDesc14 VARCHAR(MAX)
	DECLARE @outDesc15 VARCHAR(MAX)
	  
	SET @outCode1 = @inUser1
	SET @outCode2 = @inUser2
	SET @outCode3 = @inUser3
	SET @outCode4 = @inUser4
	SET @outCode5 = @inUser5
	SET @outCode6 = @inUser6
	SET @outCode7 = @inUser7
	SET @outCode8 = @inUser8
	SET @outCode9 = @inUser9
	SET @outCode10 = @inUser10
	SET @outCode11 = @inUser11
	SET @outCode12 = @inUser12
	SET @outCode13 = @inUser13
	SET @outCode14 = @inUser14
	SET @outCode15 = @inUser15

	SET @outDesc1 = @inDesc1
	SET @outDesc2 = @inDesc2
	SET @outDesc3 = @inDesc3
	SET @outDesc4 = @inDesc4
	SET @outDesc5 = @inDesc5
	SET @outDesc6 = @inDesc6
	SET @outDesc7 = @inDesc7
	SET @outDesc8 = @inDesc8
	SET @outDesc9 = @inDesc9
	SET @outDesc10 = @inDesc10
	SET @outDesc11 = @inDesc11
	SET @outDesc12 = @inDesc12
	SET @outDesc13 = @inDesc13
	SET @outDesc14 = @inDesc14
	SET @outDesc15 = @inDesc15

	SET NOCOUNT ON; ';

EXEC SP_u_Kapps__ReconstroiSP_USR 'SP_u_Kapps_CalculateUserFieldsUSR', @SPnewSQL, 'SELECT @Out1 as OUT1, @Out2 as OUT2, @Out3 as OUT3, @Out4 as OUT4, @Out5 as OUT5, @Out6 as OUT6, @Out7 as OUT7, @Out8 as OUT8, @Out9 as OUT9, @Out10 as OUT10, @Out11 as OUT11, @Out12 as OUT12, @Out13 as OUT13, @Out14 as OUT14, @Out15 as OUT15',
 'SELECT 	@outCode1 as User1, @outCode2 as User2, @outCode3 as User3, @outCode4 as User4, @outCode5 as User5, @outCode6 as User6, @outCode7 as User7, @outCode8 as User8, @outCode9 as User9, @outCode10 as User10, @outCode11 as User11, @outCode12 as User12, @outCode13 as User13, @outCode14 as User14, @outCode15 as User15, 
			@outDesc1 as Desc1, @outDesc2 as Desc2, @outDesc3 as Desc3, @outDesc4 as Desc4, @outDesc5 as Desc5, @outDesc6 as Desc6, @outDesc7 as Desc7, @outDesc8 as Desc8, @outDesc9 as Desc9, @outDesc10 as Desc10, @outDesc11 as Desc11, @outDesc12 as Desc12, @outDesc13 as Desc13, @outDesc14 as Desc14, @outDesc15 as Desc15', '', '';
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps__ReconstroiSP_USR') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE SP_u_Kapps__ReconstroiSP_USR;
END
GO

--
-- Atualizar versão dos scripts
--
DECLARE @ThisScriptVersion INT

SET @ThisScriptVersion = 68

UPDATE u_Kapps_Parameters SET ParameterValue = @ThisScriptVersion  WHERE ParameterGroup='MAIN' and ParameterID = 'SCRIPTSVERSION'
GO

