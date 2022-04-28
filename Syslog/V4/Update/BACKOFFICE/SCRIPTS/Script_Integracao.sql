/*
SCRIPT DE INTEGRAÇÃO
VERSÃO 4.0.0 
SCRIPT VERSION 52
*/

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
	DECLARE @Result VARCHAR(16)
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
	SET @Result = @Ano + @Mes + @Dia
	RETURN @Result
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
	DECLARE @Result VARCHAR(11)

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
	SET @Result = RTRIM(LTRIM(@Hora)) + RTRIM(LTRIM(@Minuto)) + RTRIM(LTRIM(@Segundo)) + RTRIM(LTRIM(@MiliSeg))
	RETURN @Result
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
	DECLARE @Result NUMERIC(19,6)

	SET @Result = @ValEuro * 200.482
	RETURN @Result

END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Login') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Login
GO
CREATE PROCEDURE SP_u_Kapps_Login
      @user VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

		DECLARE @strlogin varchar(50)
		DECLARE @strNome varchar(50)
		DECLARE @ERP VARCHAR(25)
		DECLARE @TBLOGIN TABLE (strlogin varchar(50), strNome varchar(50))
		DECLARE @BDSistema VARCHAR(25)
		SET @strlogin = ''
		SET @strNome = ''
		SET @ERP = ''

		SELECT @ERP=ParameterValue FROM u_Kapps_Parameters WITH(NOLOCK) WHERE ParameterGroup='MAIN' and ParameterID = 'ERP' 

		IF (upper(@ERP) = 'ETICADATA_16/17/18/19')
		BEGIN
			SELECT @BDSistema = ParameterValue FROM u_Kapps_Parameters WITH(NOLOCK) WHERE ParameterGroup='MAIN' and Upper(ParameterID) = Upper('BD_Sistema')
			INSERT @TBLOGIN(strlogin,strNome) exec ('select strlogin, strnome from ' + @BDSistema + '..Tbl_Utilizadores WITH(NOLOCK) where strlogin = ''' + @user + '''')
		END

		ELSE IF (upper(@ERP) = 'PRIMAVERA')
		BEGIN
			SELECT @BDSistema = ParameterValue FROM u_Kapps_Parameters WITH(NOLOCK) WHERE ParameterGroup='MAIN' and Upper(ParameterID) = Upper('BD_Empresas')
			INSERT @TBLOGIN(strlogin,strNome) exec ('SELECT Codigo, CASE WHEN Nome = '''' THEN Codigo ELSE Nome END FROM ' + @BDSistema + '..Utilizadores WITH(NOLOCK) WHERE Codigo = ''' + @user + '''')
		END

		ELSE IF (upper(@ERP) = 'PHC')
		BEGIN
			INSERT @TBLOGIN(strlogin,strNome) exec ('SELECT usercode, CASE WHEN username = '''' THEN usercode ELSE username END FROM us WITH(NOLOCK) WHERE usercode = ''' + @user + '''')
		END

		ELSE IF (upper(@ERP) = 'SAGE_50C')
		BEGIN
			INSERT @TBLOGIN(strlogin,strNome) exec ('SELECT AppUserName, AppUserName FROM AppUsers WITH(NOLOCK) WHERE AppUserName = ''' + @user + '''')
		END

		ELSE IF (upper(@ERP) = 'SAGE_100C')
		BEGIN
			INSERT @TBLOGIN(strlogin,strNome) VALUES(@user,@user)
		END

		ELSE IF (upper(@ERP) = 'SENDYS')
		BEGIN
			--INSERT @TBLOGIN(strlogin,strNome) exec ('SELECT utilizador, nome FROM utilizadores WITH(NOLOCK) WHERE utilizador = ''' + @user + '''')
			INSERT @TBLOGIN(strlogin,strNome) VALUES(@user,@user)
		END

		ELSE IF (upper(@ERP) = 'PERSONALIZADO')
		BEGIN
			INSERT @TBLOGIN(strlogin,strNome) VALUES('','')
		END
		ELSE 
		BEGIN
			RAISERROR ('O ERP não está definido, alterar a configuração do driver', 16,1)
		END

		SELECT TOP 1 @strNome = strNome, @strlogin = strlogin from @TBLOGIN
		SELECT @strNome, @strlogin 

	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
 
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH
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
	  @QTD DECIMAL(20,7),		--	QUANTIDADE
	  @CLIENTE VARCHAR(50),		--	CLIENTE
	  @EVENTO INT				--	1(PICKING) OU 2(RECEPCAO) OU 3(PACKING) OU 4(OUTROS) OU 5(CONTAGEM) OU 6(CONSULTA STOCKS)
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


	DECLARE @STATE INT
	DECLARE @ErrorMessage NVARCHAR(4000)
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
	SET @STATE = 0
	SET @ErrorMessage = ''
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
			VALUES(@bcstamp,@REF,@Description,@BARCODE,@ststamp,0,@QUANTITY,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0)

		END
		ELSE IF (upper(@ERP) = 'ETICADATA_16/17/18/19') -- ETICADATA
		BEGIN
			INSERT INTO Tbl_Gce_ArtigosCodigoBarras(strCodArtigo,strCodBarras, fltQuantidade) VALUES(@REF, @BARCODE, @QUANTITY)
		END
		ELSE IF (upper(@ERP) = 'PRIMAVERA') -- PRIMAVERA
		BEGIN
			INSERT INTO ArtigoCodBarras(CodBarras, Artigo) VALUES (@BARCODE, @REF)
		END
		ELSE IF (upper(@ERP) = 'SAGE_100C') -- SAGE 100C
		BEGIN
			INSERT INTO CBARRAS(CODIGO, Artigo, QTD) VALUES (@BARCODE, @REF, @QUANTITY)
		END
		ELSE IF (upper(@ERP) = 'SAGE_50C') -- SAGE 50C
		BEGIN
			INSERT INTO POSIdentity (ItemID,POSItemID, Quantity) VALUES (@REF, @BARCODE, @QUANTITY)
		END
		ELSE IF (upper(@ERP) = 'SENDYS') -- SENSYS
		BEGIN
			SELECT @STATE, @ErrorMessage
		END
		ELSE IF (upper(@ERP) = 'PERSONALIZADO') --PERSONALIZADO
		BEGIN
			SELECT @STATE, @ErrorMessage
		END
		ELSE 
		BEGIN
			RAISERROR ('O ERP não está definido, alterar a configuração do driver', 16,1)
		END

		COMMIT TRANSACTION
 
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		ROLLBACK TRANSACTION
		SET @STATE = 1
 
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH

	SELECT @STATE, @ErrorMessage
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
	@DocTipo CHAR(5),			-- Tipo do documento da aplicação (DCO ou DSO)
	@InternalStampDoc NVARCHAR(50),		-- Stamp do documento
	@ndos VARCHAR(50),			-- Tipo de dossier de destino
	@fecha CHAR(5),				-- Se encerra o documento de origem
	@bostamp CHAR(25),			-- Stamp do documento criado
	@terminal CHAR(5),			-- Terminal que está a sincronizar	
	@ParameterGroup CHAR(100),		-- Processo que está a sincronizar
	@ExpeditionWarehouse NVARCHAR(50),	-- Armazem de expedição
	@ExpeditionLocation NVARCHAR(50),	-- Localização de expedição
	@estadoUSR varchar(3) OUTPUT,		-- Codigo erro
	@descerroUSR varchar(255) OUTPUT	-- Descrição erro								
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

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
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
 
	DECLARE @estado varchar(3)
	DECLARE @descerro varchar(255)
 
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
 
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
	DECLARE @QtyFinal DECIMAL(18,3)
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
	DECLARE @Qty DECIMAL(18,3)
	DECLARE @Qty2 DECIMAL(18,3)
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
	DECLARE	@UserIntegracao VARCHAR(50)
	DECLARE @UserIntegracaoLin NVARCHAR(50)
	DECLARE @Process NVARCHAR(50)
	DECLARE @Validade NVARCHAR(50)
	DECLARE @Location NVARCHAR(50)
	DECLARE @ExternalDocNum NVARCHAR(50)
	DECLARE @EntityType NVARCHAR(50)
	DECLARE @EntityNumber NVARCHAR(50)
	DECLARE @InternalStampDoc NVARCHAR(50)

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
	DECLARE @UnitPrice NUMERIC(18,6)
 
	DECLARE @totaldeb NUMERIC(19,6)
	DECLARE @etotaldeb NUMERIC(19,6)
	DECLARE @etotal NUMERIC(19,6)
	DECLARE @ebo_1tvall NUMERIC(19,6)
	DECLARE @ebo_totp1 NUMERIC(19,6)
	DECLARE @ebo_totp2 NUMERIC(19,6)
	DECLARE @edescc NUMERIC(19,6)
	DECLARE @taxa NUMERIC(19,6) 
	DECLARE @iva NUMERIC(5,2)
	DECLARE @tabiva INT
 
	DECLARE @ivaincl INT
	DECLARE @edebito NUMERIC(19,6)
	DECLARE @debito NUMERIC(19,6)
	DECLARE @edebitoori NUMERIC(19,6)
	DECLARE @debitoori NUMERIC(19,6)
	
	DECLARE @eslvu NUMERIC(19,6)
	DECLARE @slvu NUMERIC(19,6)
	DECLARE @ettdeb NUMERIC(19,6)
	DECLARE @ttdeb NUMERIC(19,6)
	DECLARE @esltt NUMERIC(19,6)
	DECLARE @sltt NUMERIC(19,6)
	DECLARE @custoind NUMERIC(19,6)
	DECLARE @ecustoind NUMERIC(19,6)
	 
	DECLARE @obs VARCHAR(67)
       
	DECLARE @ecusto NUMERIC(19,6)
	DECLARE @tpdesc VARCHAR(55)
 
	DECLARE @epu NUMERIC(19,6)
	DECLARE @pu NUMERIC(19,6)
	DECLARE @prorc NUMERIC(19,6)
	DECLARE @eprorc NUMERIC(19,6)
	DECLARE @pcusto  NUMERIC(19,6)
	DECLARE @epcusto  NUMERIC(19,6)
	DECLARE @armazem NUMERIC(5,0)
	DECLARE @lobs VARCHAR(45)
	DECLARE @desconto NUMERIC(6,2)
	DECLARE @desc2 NUMERIC(6,2)
	DECLARE @desc3 NUMERIC(6,2)
	DECLARE @desc4 NUMERIC(6,2)
	DECLARE @desc5 NUMERIC(6,2)
	DECLARE @desc6 NUMERIC(6,2)
	DECLARE @VALDESC NUMERIC(6,2)
	DECLARE @eVALDESC NUMERIC(6,2)
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


	-- ivas 
	DECLARE @iva1 NUMERIC(6,2)
	DECLARE @ebo12_bins NUMERIC(19,6)
	DECLARE @ebo12_iva NUMERIC(19,6)
	   
	DECLARE @iva2 NUMERIC(6,2)
	DECLARE @ebo22_bins NUMERIC(19,6)
	DECLARE @ebo22_iva NUMERIC(19,6)

	DECLARE @iva3 NUMERIC(6,2)
	DECLARE @ebo32_bins NUMERIC(19,6)
	DECLARE @ebo32_iva NUMERIC(19,6)

	DECLARE @iva4 NUMERIC(6,2)
	DECLARE @ebo42_bins NUMERIC(19,6)
	DECLARE @ebo42_iva NUMERIC(19,6)

	DECLARE @iva5 NUMERIC(6,2)
	DECLARE @ebo52_bins NUMERIC(19,6)
	DECLARE @ebo52_iva NUMERIC(19,6)

	DECLARE @iva6 NUMERIC(6,2)
	DECLARE @ebo62_bins NUMERIC(19,6)
	DECLARE @ebo62_iva NUMERIC(19,6)
	DECLARE @SemIva NUMERIC(19,6)

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
	DECLARE @Peso NUMERIC(18,3)
	DECLARE @PesoFinal NUMERIC(18,3)
	DECLARE @UseWeight BIT
	DECLARE @rescli BIT
	DECLARE @ocupacao INT
	DECLARE @TipoProcesso VARCHAR(50)

	SET @ArtigodeServicos = 0
	SET @estado = 'NOK'
	SET @descerro = 'Não foi gerado nenhum documento'
	SET @NewBoStamp = ''
	SET @lordem = 0
	SET @ivaincl = 0
	SET @rescli = 0

	SELECT @ERP = ISNULL(ParameterValue, '') from u_Kapps_Parameters WITH(NOLOCK) where ParameterGroup='MAIN' and ParameterId = 'ERP'
 
	IF (@integra = '0')
	BEGIN
		SET @estado = 'OK'
		SET @descerro = 'Documento não integrado conforme configuração no backoffice'
		IF (@DocTipo = 'DSO')
			UPDATE u_Kapps_DossierLin SET Integrada = 'S', Status = 'F' WHERE InternalStampDoc = @InStampDoc AND Integrada = 'N' AND Status <> 'X'
		ELSE IF (@DocTipo = 'DCO')
			UPDATE u_Kapps_DossierLin SET Integrada = 'S', Status = 'F' WHERE StampBO = @InStampDoc AND Integrada = 'N' AND Status <> 'X'
		ELSE
		BEGIN
			SET @estado = 'NOK'
			SET @descerro = 'Não foi gerado nenhum documento'
		END

		IF (upper(@ERP) = 'PHC')
		BEGIN
			EXECUTE SP_u_Kapps_DossiersUSR  @DocTipo, @InStampDoc, @ndos, @fecha, @NewBoStamp, @terminal, @ParameterGroup, @InUserIntegracao, @ExpeditionWarehouse, @ExpeditionLocation, @estado OUTPUT, @descerro OUTPUT
		END
	END
	ELSE
	BEGIN

		IF (upper(@ERP) = 'PERSONALIZADO')
		BEGIN
			EXECUTE SP_u_Kapps_DossiersUSR  @DocTipo, @InStampDoc, @ndos, @fecha, @NewBoStamp, @terminal, @ParameterGroup, @InUserIntegracao, @ExpeditionWarehouse, @ExpeditionLocation, @estado OUTPUT, @descerro OUTPUT
		END
		ELSE
		BEGIN
			BEGIN TRY
			BEGIN TRANSACTION

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

			DECLARE @ORDERBY VARCHAR(255)
			DECLARE @ORDERPARAMETER VARCHAR(5)
			SET @ORDERBY = ' StampLin'
			SET @ORDERPARAMETER = ''

			SELECT @ORDERPARAMETER = par.ParameterValue FROM u_Kapps_Parameters par  WITH(NOLOCK) WHERE par.APPCODE = @APPCODE AND par.ParameterGroup = @ParameterGroup and par.ParameterID = 'ORDER_INTEGRATION'
			-- '0' -- ORDEM DE PICAGEM DO DOCUMENTO
			-- '1' -- ORDEM DO DOCUMENTO DE ORIGEM
			-- '2' -- REFERENCIA
			-- '3' -- DESCRICAO

			DECLARE curKappsDossiers CURSOR LOCAL STATIC READ_ONLY FOR
			SELECT 
					ISNULL(StampLin, ''),
					ISNULL(StampBo, ''), 
					ISNULL(StampBi, ''), 
					ISNULL(Ref, ''), 
					ISNULL(Description, ''), 
					ISNULL(Qty, 0) as Qty, 
					ISNULL(Lot, ''), 
					ISNULL(Serial, ''), 
					ISNULL(UserID, ''), 
					ISNULL(MovDate, ''), 
					ISNULL(MovTime, ''),
					ISNULL(Status, ''), 
					ISNULL(DocType, '0'),
					ISNULL(DocNumber, ''), 
					ISNULL(Integrada, ''), 
					ISNULL(DataIntegracao, 0), 
					ISNULL(HoraIntegracao, 0), 
					ISNULL(UserIntegracao, ''), 
					ISNULL(Validade, ''),
					ISNULL(Warehouse, '0'),
					ISNULL(Location, ''),
					ISNULL(ExternalDocNum, ''),
					ISNULL(EntityType, ''),
					ISNULL(EntityNumber, ''),
					ISNULL(InternalStampDoc, ''),
					ISNULL(DestinationDocType, '0'),
					ISNULL(VatNumber, ''), 
					ISNULL(UnitPrice, 0),
					ISNULL(WarehouseOut, '0'),
					ISNULL(OriLineNumber, 0),
					ISNULL(QtyUM, '') as QtyUM, 
					ISNULL(Qty2, 0) as Qty2, 
					ISNULL(Qty2UM, '') as QtyUM2,
					ISNULL(DeliveryCode, ''),
					ISNULL(NetWeight, 0)

					FROM u_Kapps_DossierLin WITH(NOLOCK) 
					WHERE (((InternalStampDoc = @InStampDoc) AND (('DSO' = @DocTipo) OR ('DCP' = @DocTipo))) OR ((StampBo = @InStampDoc) AND ('DCO' = @DocTipo))) AND Integrada = 'N' AND status <> 'X' 
					--GROUP BY StampLin, StampBo, StampBi, Ref, Description,Lot,Serial,UserID,MovDate,MovTime,Status,DocType,DocNumber,Integrada,DataIntegracao,HoraIntegracao,UserIntegracao,Validade,Warehouse,Location,ExternalDocNum,EntityType,EntityNumber,InternalStampDoc,DestinationDocType,VatNumber,UnitPrice,WarehouseOut,OriLineNumber
					ORDER BY CASE @ORDERPARAMETER WHEN '1' THEN CAST(OriLineNumber as varchar(50)) WHEN '2' THEN Ref WHEN '3' THEN Description ELSE StampLin  END, MovDate, MovTime 
 
					OPEN curKappsDossiers
 
						FETCH NEXT FROM curKappsDossiers INTO @StampLin,@StampBo,@StampBi,@Ref,@Description,@Qty,@Lot,@Serial,@UserID,@MovDate,@MovTime,@Status,@DocType,@DocNumber,@Integrada,@DataIntegracao,@HoraIntegracao,@UserIntegracao,@Validade,@Warehouse,@Location,@ExternalDocNum,@EntityType,@EntityNumber,@InternalStampDoc,@DestinationDocType, @VatNumber, @UnitPrice, @WarehouseOut, @OriLineNumber, @QtyUM, @Qty2, @Qty2UM, @descarga, @Peso
             
					WHILE @@FETCH_STATUS = 0 BEGIN
                    
						IF (@oldStampBo = @StampBo AND @oldStampBi = @StampBi AND @oldRef = @Ref AND @oldLot = @Lot AND @oldWarehouse = @Warehouse AND @oldWarehouseOut = @WarehouseOut AND @oldSerial = @Serial)
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
						SELECT @UseWeight = UseWeight FROM v_Kapps_Articles WHERE code=@Ref
						IF (@UseWeight = 1)
						BEGIN
							SET @Qty = @Peso
						END
					

						SET @lordem = @lordem + 1
 
						SET @DateTimeTmp = GETDATE()
						SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
 
						IF (@UserID = '')
							SET @UserID = 'Syslog'

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
								SET @ndos = @DocType
							SELECT @nmdos = ISNULL(nmdos, ''), @rescli = rescli , @ocupacao = ocupacao from ts WITH(NOLOCK) where ndos = CAST(@ndos AS int)
 
							-- novo numero do dossier
							select @obrano = (ISNULL(MAX(obrano),0) + 1) from bo WHERE NDOS = CAST(@ndos AS int)
 
							IF ((@DocTipo = 'DSO') OR (@DocTipo = 'DCP')) -- vai buscar os dados do terceiro 
							BEGIN
								SET @EntSegmento = ''
								SET @EntLocTesoura = ''
								SET @EntContado = 0
								
								IF (@EntityType = 'C') OR (@EntityType = 'CL')
									SELECT @EntityNumber = no, @EntTipo = ISNULL(tipo, ''),@EntZona = ISNULL(zona, ''),@EntSegmento = ISNULL(segmento, ''),@EntTelef = ISNULL(telefone, ''),@EntNome = ISNULL(nome, ''),@EntMorada = ISNULL(morada, ''),@EntLocal = ISNULL(local, ''),@EntCPostal = ISNULL(codpost, ''),@EntNCont = ISNULL(ncont, ''),@EntPais = ISNULL(pais, 0),@EntMoeda = ISNULL(moeda, ''),@EntLocTesoura = ISNULL(ollocal, ''),@EntContado = ISNULL(contado, 0),@fref = ISNULL(fref, ''),@ccusto = ISNULL(ccusto, '') FROM cl WITH(NOLOCK) WHERE no = CAST(@EntityNumber as int) and estab = @estab
								ELSE IF (@EntityType = 'AG')
									SELECT @EntityNumber = no, @EntTipo = '',@EntZona = ISNULL(zona, ''),@EntSegmento = '',@EntTelef = ISNULL(telefone, ''),@EntNome = ISNULL(nome, ''),@EntMorada = ISNULL(morada, ''),@EntLocal = ISNULL(local, ''),@EntCPostal = ISNULL(codpost, ''),@EntNCont = ISNULL(ncont, ''),@EntPais = 0,@EntMoeda = 'EURO',@EntLocTesoura = '',@EntContado = 0,@fref = '',@ccusto = '' FROM ag WITH(NOLOCK) WHERE no = CAST(@EntityNumber as int)
								ELSE IF (@EntityType = 'F') OR (@EntityType = 'FL')						
									SELECT   @EntityNumber = no, @EntTipo = ISNULL(tipo, ''),@EntZona = ISNULL(zona, ''),@EntTelef = ISNULL(telefone, ''),@EntNome = ISNULL(nome, ''),@EntMorada = ISNULL(morada, ''),@EntLocal = ISNULL(local, ''),@EntCPostal = ISNULL(codpost, ''),@EntNCont = ISNULL(ncont, ''),@EntPais = ISNULL(pais, 0),@EntMoeda = ISNULL(moeda, ''),@fref = ISNULL(fref, ''),@ccusto = ISNULL(ccusto, '') FROM fl WITH(NOLOCK) WHERE no = @EntityNumber and estab = @estab
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
								END
								IF ((@VatNumber <> '') AND (@VatNumber <> @EntNCont))
									SET @EntNCont = @VatNumber
							END
							ELSE
							BEGIN
                              
								SELECT @EntNome = nome, @EntMorada = morada, @EntLocal = local, @EntCPostal = codpost, @EntityNumber = no, @EntMoeda = moeda, @EntNCont = ncont, @EntTipo = tipo, @EntZona = zona, @EntSegmento = segmento, @fref = fref, @ccusto = ccusto, @estab = estab FROM bo WITH(NOLOCK) WHERE bostamp = @StampBo
							END
 
							SELECT @TipoProcesso=TypeID FROM u_Kapps_Processes WHERE ProcessID=@ParameterGroup

							IF (@TipoProcesso<>'PICKTRANSF')
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
 
							INSERT INTO bo3(bo3stamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
							VALUES (@NewBoStamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora) 
 
							INSERT INTO BO(bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, moeda, ncont, tipo, zona, segmento, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fref, ccusto, OBS, etotaldeb, ebo_2tvall, edescc, ebo_1tvall, ebo_totp1, ebo_totp2, estab, ocupacao, dataopen, ultfact)
							VALUES(@NewBoStamp, @boano, @obrano, CAST(@ndos  AS int), @nmdos, @DateStr, @EntNome, @EntMorada, @EntLocal, @EntCPostal, CAST(@EntityNumber as int), @EntMoeda, @EntNCont, @EntTipo, @EntZona, @EntSegmento, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @fref, @ccusto, @ExternalDocNum, @etotaldeb, @etotaldeb, @edescc, @etotal, @etotal, @etotal, @estab, @ocupacao, @ousrdata, @ousrdata)

							SET @NEWnmdos = ''
							SET @NEWobrano = 0

							SELECT @NEWnmdos = nmdos, @NEWobrano = obrano from bo WITH(NOLOCK) WHERE bostamp = @NewBoStamp

							IF (@DocTipo = 'DCO')
								EXECUTE SP_u_Kapps_DossiersUSR  @DocTipo, @StampBo, @ndos, @fecha, @NewBoStamp, @terminal, @ParameterGroup, @UserIntegracao, @ExpeditionWarehouse, @ExpeditionLocation, @estado OUTPUT, @descerro OUTPUT
							ELSE
								EXECUTE SP_u_Kapps_DossiersUSR  @DocTipo, @InternalStampDoc, @ndos, @fecha, @NewBoStamp, @terminal, @ParameterGroup, @UserIntegracao, @ExpeditionWarehouse, @ExpeditionLocation, @estado OUTPUT, @descerro OUTPUT

						END
 
						-- se não existir o lote tem de se criar
						IF @Lot <> ''
						BEGIN
							IF (SELECT COUNT(*) FROM se  WITH(NOLOCK) WHERE ref = @Ref AND lote = @Lot) = 0
							BEGIN  
								WAITFOR DELAY '00:00:00.200'
								SET @DateTimeTmp = GETDATE()
								SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
								SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
 
								SET @sestamp = 'Syslog_' + @DateStr + @TimeStr
                                    
								INSERT INTO se (sestamp, ref, lote, design, data, validade, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
									VALUES (@sestamp, @ref, @Lot, @Description, @DateStr, @validade, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
							END
							SET @usalote = 1
						END
						ELSE
							SET @usalote = 0
 
						
						SELECT @predec = predec from ts  WITH(NOLOCK) where ndos = CAST(@ndos AS int)
						IF ((@DocTipo = 'DCO') AND (@StampBi <> '')) -- atualiza a quantidade de origem
						BEGIN				   
							-- VAI BUSCAR OS DADOS PARA AS LINHAS
							SELECT @sTipo = sTipo, @epu = epu, @pu = pu, @edebito = edebito, @debito = debito, @edebitoori = edebitoori, @debitoori = debitoori, @eprorc = eprorc, @prorc = prorc, @epcusto = epcusto, @pcusto = pcusto, @armazem = armazem, @lobs=lobs, @desconto = desconto, @desc2=desc2, @desc3=desc3, @desc4=desc4, @desc5=desc5, @desc6=desc6, @eVALDESC = eVALDESC, @tabiva = TABIVA, @iva = iva, @eslvu = eslvu, @slvu = slvu, @esltt = esltt, @sltt = sltt, @local = local, @morada = morada, @codpost = codpost, @familia = familia, @zona = zona, @UsaNumSerie = noserie, @ivaincl = ivaincl, @VALDESC = VALDESC, @ecustoind = ecustoind, @custoind = custoind, @segmento = segmento, @bofRef = bofref FROM BI WITH(NOLOCK) WHERE bistamp = @StampBi
							SELECT @bi2local = local, @bi2Morada = Morada, @bi2CodPost = CodPost FROM bi2 WITH(NOLOCK) WHERE bi2stamp = @StampBi
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
							SET @ettdeb=0 
							SET @ttdeb=0 
							SET @lobs= '' 
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
							SET @sTipo='4'
							SET @local = @EntLocal   
							SET @morada = @EntMorada
							SET @codpost = @EntCPostal
							SET @zona = @EntZona
							SET @nome = @EntNome
						END
						--Taxas de iva
						IF (@EntityType = 'C') OR (@EntityType = 'CL')
							SELECT @tabiva = CASE WHEN (SELECT cl.TabIVA FROM cl WITH(NOLOCK) WHERE cl.no = @EntityNumber and cl.estab = @estab) = 0 then st.TABIVA else (SELECT cl.TabIVA FROM cl WITH(NOLOCK) WHERE cl.no = @EntityNumber and cl.estab = @estab) END, @iva = CASE WHEN (SELECT cl.TabIVA FROM cl WITH(NOLOCK) WHERE cl.no = @EntityNumber and cl.estab = @estab) = 0 then taxasiva.taxa else (SELECT ti.taxa FROM cl WITH(NOLOCK) JOIN taxasiva ti WITH(NOLOCK) ON ti.codigo = cl.tabiva WHERE cl.no = @EntityNumber and cl.estab = @estab) END , @usalote = st.usalote, @usr1 = usr1, @usr2 = usr2, @usr3 = usr3, @usr4 = usr4, @usr5 = usr5, @usr6 = usr6, @unidade = unidade, @ArtigodeServicos = stns, @UsaNumSerie = noserie, @familia = familia FROM st WITH(NOLOCK) JOIN taxasiva WITH(NOLOCK) ON  st.TABIVA = taxasiva.codigo WHERE st.Ref = @Ref
						ELSE IF (@EntityType = 'F') OR (@EntityType = 'FL')
							SELECT @tabiva = CASE WHEN (SELECT fl.TabIVA FROM fl WITH(NOLOCK) WHERE fl.no = @EntityNumber and fl.estab = @estab) = 0 then st.TABIVA else (SELECT fl.TabIVA FROM fl WITH(NOLOCK) WHERE fl.no = @EntityNumber and fl.estab = @estab) END, @iva = CASE WHEN (SELECT fl.TabIVA FROM fl WITH(NOLOCK) WHERE fl.no = @EntityNumber and fl.estab = @estab) = 0 then taxasiva.taxa else (SELECT ti.taxa FROM fl WITH(NOLOCK) JOIN taxasiva ti WITH(NOLOCK) ON ti.codigo = fl.tabiva WHERE fl.no = @EntityNumber and fl.estab = @estab) END , @usalote = st.usalote, @usr1 = usr1, @usr2 = usr2, @usr3 = usr3, @usr4 = usr4, @usr5 = usr5, @usr6 = usr6, @unidade = unidade, @ArtigodeServicos = stns, @UsaNumSerie = noserie, @familia = familia FROM st WITH(NOLOCK) JOIN taxasiva WITH(NOLOCK) ON  st.TABIVA = taxasiva.codigo WHERE st.Ref = @Ref
						ELSE
							SELECT @tabiva = 0, @iva = 0, @usalote = st.usalote, @usr1 = usr1, @usr2 = usr2, @usr3 = usr3, @usr4 = usr4, @usr5 = usr5, @usr6 = usr6, @unidade = unidade, @ArtigodeServicos = stns, @UsaNumSerie = noserie, @familia = familia FROM st WITH(NOLOCK) JOIN taxasiva WITH(NOLOCK) ON  st.TABIVA = taxasiva.codigo WHERE st.Ref = @Ref


						-- Totais
						SET @sltt = @slvu * @Qty
						SET @esltt = @eslvu * @Qty
						--
						SET @ettdeb = ROUND((@Qty * (((((((@edebito) * ((100 - @desconto) / 100)) * ((100 - @desc2) / 100)) * ((100 - @desc3) / 100)) * ((100 - @desc4) / 100)) * ((100 - @desc5) / 100)) * ((100 - @desc6) / 100)) - @eVALDESC), @predec)
						--SET @ettdeb = (@Qty * (((((((@edebito) * ((100 - @desconto) / 100)) * ((100 - @desc2) / 100)) * ((100 - @desc3) / 100)) * ((100 - @desc4) / 100)) * ((100 - @desc5) / 100)) * ((100 - @desc6) / 100)) - @eVALDESC)

						IF (@ivaincl = 1)
						BEGIN
							SET @etotaldeb = @etotaldeb + @ettdeb - ROUND(@ettdeb - (@ettdeb / (1 + (@iva /100))),2)
							SET @SemIva = @edebito - ROUND(@edebito - (@edebito / (1 + (@iva /100))),2)
						END	
						ELSE
						BEGIN
							SET @etotaldeb = @etotaldeb + @ettdeb 
							SET @SemIva = @edebito
						END						
						
						--SET @etotal = @etotal + ROUND((@Qty * @SemIva),@predec)
						SET @etotal = @etotal + (@Qty * @SemIva)
						SET @edescc  = @etotal - @etotaldeb         
						--SET @ecusto = @ecusto + ROUND((@Qty * @epcusto), @predec)   
						SET @ecusto = @ecusto + (@Qty * @epcusto)

						--IF ((@DocTipo = 'DCO') AND (@StampBi <> '')) -- atualiza a quantidade de origem
						--BEGIN
							--IF (@eslvu = 0)
							--	SET @eslvu = @edebito
							--IF (@slvu = 0)
							--	SET @slvu = @debito
							--IF (@esltt = 0)
							--	SET @esltt = @ettdeb
							--IF (@sltt = 0)
							--	SET @sltt = @ttdeb
						--END

						IF (@tabiva = 1)
						BEGIN
							SET @iva1 = @iva
							SET @ebo12_bins = @ebo12_bins + @ettdeb
							SET @ebo12_iva = @ebo12_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva /100)),2))
						END   
						ELSE IF (@tabiva = 2)
						BEGIN
							SET @iva2 = @iva
							SET @ebo22_bins = @ebo22_bins + @ettdeb
							SET @ebo22_iva = @ebo22_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva /100)),2))
						END 
						ELSE IF (@tabiva = 3)
						BEGIN
							SET @iva3 = @iva
							SET @ebo32_bins = @ebo32_bins + @ettdeb
							SET @ebo32_iva = @ebo32_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva /100)),2))
						END
						ELSE IF (@tabiva = 4)
						BEGIN
							SET @iva4 = @iva
							SET @ebo42_bins = @ebo42_bins + @ettdeb
							SET @ebo42_iva = @ebo42_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva /100)),2))
						END
						ELSE IF (@tabiva = 5)
						BEGIN
							SET @iva5 = @iva
							SET @ebo52_bins = @ebo52_bins + @ettdeb
							SET @ebo52_iva = @ebo52_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva /100)),2))
						END
						ELSE IF (@tabiva = 6)
						BEGIN
							SET @iva6 = @iva
							SET @ebo62_bins = @ebo62_bins + @ettdeb
							SET @ebo62_iva = @ebo62_iva + (@ettdeb - ROUND(@ettdeb - (@ettdeb * (@iva /100)),2))
						END	
					
						SET @ttdeb = dbo.u_Kapps_EurToEsc(@ettdeb)
						IF (@Update = 0)
						BEGIN						
								-- Insere a linha no dossier
							INSERT INTO bi (bistamp, bostamp, nmdos, obrano, ref, design, lordem, ndos, no, armazem, qtt ,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora, lote, rescli, bofref, eprorc, prorc, epu, pu, edebito, debito, edebitoori, debitoori, eslvu, slvu, ettdeb, ttdeb, esltt, sltt, OBISTAMP, oobistamp, epcusto, pcusto, lobs, desconto, desc2, desc3, desc4, desc5, desc6, eVALDESC, tabiva, iva, usalote, sTipo, dataobra, dataopen, usr1, usr2, usr3, usr4, usr5, usr6, unidade, AR2MAZEM, rData, stns, unidad2, local, morada, codpost, familia, ccusto, zona, nome, noserie, ivaincl, ecustoind, custoind, segmento) 
							VALUES(@StampLin, @NewBoStamp, @nmdos, @obrano, @Ref, @Description, (@lordem * 10000), CAST(@ndos AS int), CAST(@EntityNumber as int), CAST(@Warehouse as int), @Qty, @ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora, @Lot, @rescli, @bofRef, @eprorc, @prorc, @epu, @pu, @edebito, @debito, @edebitoori, @debitoori, @eslvu, @slvu, @ettdeb, @ttdeb, @esltt, @sltt, @StampBi, @StampBi, @epcusto, @pcusto, @lobs, @desconto, @desc2, @desc3, @desc4, @desc5, @desc6, @eVALDESC,  @tabiva, @iva, @usalote, cast(@sTipo as int), @DateStr, @DateStr, @usr1, @usr2, @usr3, @usr4, @usr5, @usr6, @unidade, CAST(@WarehouseOut as int),@usrdata, @ArtigodeServicos, @Qty2UM, @local, @morada, @codpost, @familia, @ccusto, @zona, @EntNome, @UsaNumSerie, @ivaincl, @ecustoind, @custoind, @segmento)
                        
							INSERT INTO bi2(bi2stamp, bostamp, local,morada,codpost) VALUES (@StampLin, @NewBoStamp, @bi2local,@bi2morada,@bi2codpost)
                        
							IF ((@DocTipo = 'DCO') AND (@StampBi <> '')) -- atualiza a quantidade de origem
							BEGIN
								UPDATE bi set fechada = 0, datafecho = @DateTimeTmp, fdata = @DateStr, nmdoc = @nmdos, fno = @obrano, ndoc = CAST(@ndos AS int) WHERE bistamp = @StampBi
								UPDATE bi set fechada = (CASE WHEN qtt <= qtt2 THEN 1 ELSE 0 END) WHERE bistamp = @StampBi
							END
							-- coloca o documento como integrado
							UPDATE u_Kapps_DossierLin SET Integrada = 'S', Status = 'F', DataIntegracao = @DateStr, HoraIntegracao = SUBSTRING(@TimeStr,1,6), UserIntegracao=@InUserIntegracao, StampDocGer = RIGHT(@NEWnmdos + ' ' + CAST(@NEWobrano AS VARCHAR),50), KeyDocGerado=@NewBoStamp WHERE StampLin = @StampLin
                       
							IF (@DocTipo = 'DCO')
								EXECUTE SP_u_Kapps_DossiersLinUSR  @DocTipo, @StampBo, @ndos, @fecha, @NewBoStamp, @StampLin, @Ref, @lordem    
							ELSE
								EXECUTE SP_u_Kapps_DossiersLinUSR  @DocTipo, @InternalStampDoc, @ndos, @fecha, @NewBoStamp, @StampLin, @Ref, @lordem    
							
							SET @StampFinalLinha = @StampLin
							SET @lordemFinal = @lordem 						
						END
						ELSE
						BEGIN
							--SET @ettdeb = ROUND((@Qtyfinal * (((((((@edebito) * ((100 - @desconto) / 100)) * ((100 - @desc2) / 100)) * ((100 - @desc3) / 100)) * ((100 - @desc4) / 100)) * ((100 - @desc5) / 100)) * ((100 - @desc6) / 100)) - @eVALDESC), @predec)
							DECLARE @QtdTotal NUMERIC(18,3)
							
							SET @QtdTotal=@Qtyfinal
							IF (@UseWeight = 1)
							BEGIN							
								SET @QtdTotal=@Pesofinal
							END
							SET @ettdeb = (@QtdTotal * (((((((@edebito) * ((100 - @desconto) / 100)) * ((100 - @desc2) / 100)) * ((100 - @desc3) / 100)) * ((100 - @desc4) / 100)) * ((100 - @desc5) / 100)) * ((100 - @desc6) / 100)) - @eVALDESC)
							SET @ttdeb = dbo.u_Kapps_EurToEsc(@ettdeb)
							-- atualiza a quantidade de origem
							UPDATE bi SET qtt = @QtdTotal, eprorc = @eprorc, epu = @epu, pu = @pu, edebito = @edebito, debito = @debito, edebitoori = @edebitoori, debitoori = @debitoori, eslvu = @eslvu, slvu = @slvu, ettdeb = @ettdeb, ttdeb = @ttdeb, esltt = @esltt, sltt = @sltt, epcusto = @epcusto, desconto = @desconto, desc2=@desc2,desc3=@desc3, desc4=@desc4, desc5=@desc5, desc6=@desc6, eVALDESC=@eVALDESC WHERE bistamp = @StampFinalLinha
							IF ((@DocTipo = 'DCO') AND (@StampBi <> '')) 
							BEGIN
								UPDATE bi set fechada = 0, datafecho = @DateTimeTmp, fdata = @DateStr, nmdoc = @nmdos, fno = @obrano, ndoc = CAST(@ndos AS int) WHERE bistamp = @StampBi
								UPDATE bi set fechada = (CASE WHEN qtt <= qtt2 THEN 1 ELSE 0 END) WHERE bistamp = @StampBi
							END
							-- coloca o documento como integrado
							UPDATE u_Kapps_DossierLin SET Integrada = 'S', Status = 'F', DataIntegracao = @DateStr, HoraIntegracao = SUBSTRING(@TimeStr,1,6), UserIntegracao=@InUserIntegracao, StampDocGer = RIGHT(@NEWnmdos + '' + CAST(@NEWobrano AS VARCHAR),50), KeyDocGerado=@NewBoStamp WHERE StampLin = @StampLin
                        
							IF (@DocTipo = 'DCO')
								EXECUTE SP_u_Kapps_DossiersLinUSR  @DocTipo, @StampBo, @ndos, @fecha, @NewBoStamp, @StampFinalLinha, @Ref, @lordemFinal    
							ELSE
								EXECUTE SP_u_Kapps_DossiersLinUSR  @DocTipo, @InternalStampDoc, @ndos, @fecha, @NewBoStamp, @StampFinalLinha, @Ref, @lordemFinal    
					
						END
						SET @oldStampBo = @StampBo
						SET @oldStampBi = @StampBi
						SET @oldRef = @Ref
						SET @oldLot = @Lot
						SET @oldWarehouse = @Warehouse
						SET @oldWarehouseOut = @WarehouseOut
						SET @oldSerial = @Serial

						FETCH NEXT FROM curKappsDossiers INTO @StampLin,@StampBo,@StampBi,@Ref,@Description,@Qty,@Lot,@Serial,@UserID,@MovDate,@MovTime,@Status,@DocType,@DocNumber,@Integrada,@DataIntegracao,@HoraIntegracao,@UserIntegracao,@Validade,@Warehouse,@Location,@ExternalDocNum,@EntityType,@EntityNumber,@InternalStampDoc,@DestinationDocType,@VatNumber, @UnitPrice, @WarehouseOut, @OriLineNumber, @QtyUM, @Qty2, @Qty2UM, @descarga, @Peso						
					END
 						
					IF (@StampBo <>'')
					BEGIN
						IF (@DocTipo = 'DCO') -- VAI BUSCAR OS DADOS PARA O CABECALHO
							SELECT @obs = obs, @tpdesc = tpdesc FROM BO WITH(NOLOCK) WHERE bostamp = @StampBo
 
						IF ((@DocTipo = 'DCO') AND ((@fecha = 'F'))) -- fechar o dossier
						BEGIN
							UPDATE bo set fechada = 1, datafecho = @DateStr  WHERE bostamp = @StampBo
							UPDATE bi set fechada = 1, datafecho = @DateStr  WHERE bostamp = @StampBo
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

					EXECUTE SP_u_Kapps_DocDossInternIVAs  @NewBoStamp, @iva1, @ebo12_bins, @ebo12_iva, @iva2, @ebo22_bins, @ebo22_iva, @iva3, @ebo32_bins, @ebo32_iva, @iva4, @ebo42_bins, @ebo42_iva, @iva5, @ebo52_bins, @ebo52_iva, @iva6, @ebo62_bins, @ebo62_iva, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora
                    
					SET @estado = 'OK'
					SET @descerro = ''  
 
					COMMIT TRANSACTION
 
					END TRY
					BEGIN CATCH
						SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
						ROLLBACK TRANSACTION
						SET @estado = 'NOK'
						SET @descerro = @ErrorMessage
						SET @NewBoStamp = ''
						SET @obrano = ''
						
						RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

						INSERT INTO u_Kapps_Log(LogStamp,LogType,LogMessage,LogDetail,LogTerminal) 
						VALUES (CONVERT(VARCHAR, GETDATE(), 112) + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),10,''''+RTRIM(@DocTipo)+''', '''+RTRIM(@InStampDoc) +''', '''+ RTRIM(@ndos)+ ''', '''+RTRIM(@fecha)+''', '''+	RTRIM(@terminal)+''', '''+RTRIM(@integra)+''', '''+RTRIM(@ParameterGroup)+''', '''+RTRIM(@InUserIntegracao)+''', '''+RTRIM(@ExpeditionWarehouse)+''', '''+RTRIM(@ExpeditionLocation)+'''', RTRIM(@ErrorMessage), @Terminal)
						
						GOTO FIM
                    
					END CATCH
			FIM:
					CLOSE curKappsDossiers
					DEALLOCATE curKappsDossiers
		END
	END
--
-- Deve retornar apenas um result set com 
--
-- @estado 			OK ou NOK 
-- @descerro 		Descrição do erro
-- @NewBoStamp		Stamp do documento gerado
-- @obrano			Numero do documento gerado
--
SELECT @estado, @descerro, @NewBoStamp, @obrano
--
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
		SELECT lin.Ref, lin.Description, SUM(lin.Qty), lin.Warehouse, lin.location, lin.Lot, lin.OrigStampLin, art.BaseUnit
		FROM u_Kapps_StockLines lin WITH(NOLOCK)
		LEFT JOIN v_Kapps_Articles art ON art.Code=lin.Ref
		WHERE lin.OrigStampHeader=@StampHeader and lin.InternalStampDoc = @InternalStampDoc and lin.Syncr<>'S'
		GROUP BY lin.Ref, lin.Description, lin.Warehouse, lin.location, lin.Lot, lin.OrigStampLin, art.BaseUnit

		OPEN curLinhasContagem
		FETCH NEXT FROM curLinhasContagem INTO @Ref,@Description,@Qty,@Warehouse,@Localizacao,@Lot,@OrigStampLin,@unidade
		WHILE @@FETCH_STATUS = 0
		BEGIN
			WAITFOR DELAY '00:00:00.200' 
			SET @DateTimeTmp = GETDATE()
			SET @DateStr = dbo.u_Kapps_DateToString(@DateTimeTmp)
			SET @TimeStr = dbo.u_Kapps_TimeToString(@DateTimeTmp)
			SET @stilstamp = 'Syslog_' + @DateStr + @TimeStr

			IF @TipoContagem='C'
			BEGIN			
				INSERT INTO stil (stilstamp, ref, design, data, stock, sticstamp, armazem, lote, ousrinis, usrinis, ousrdata, usrdata, ousrhora, usrhora, unidade)
				VALUES(@stilstamp, @Ref, @Description, @Date, @Qty, @Sticstamp, @Warehouse, @Lot, @ousrinis, @usrinis, @ousrdata, @usrdata, @ousrhora, @usrhora, @unidade) 
			END	
			ELSE
			BEGIN
				UPDATE stil SET stock = stock + @Qty WHERE STICSTAMP = @StampHeader AND STILSTAMP = @OrigStampLin
			END
		  
			FETCH NEXT FROM curLinhasContagem INTO @Ref,@Description,@Qty,@Warehouse,@Localizacao,@Lot,@OrigStampLin,@unidade
		END

		UPDATE u_Kapps_StockLines SET Syncr = 'S', Status='C', SyncrDate=GETDATE(), SyncrUser=@UserIntegracao WHERE OrigStampHeader = @StampHeader and InternalStampDoc = @InternalStampDoc
	
 
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		INSERT INTO u_Kapps_Log(LogStamp,LogType,LogMessage,LogDetail,LogTerminal) 
		VALUES (CONVERT(VARCHAR, GETDATE(), 112) + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),10,''''+RTRIM(@StampHeader)+''', '''+RTRIM(@Sticstamp) +''', '''+ RTRIM(@UserIntegracao)+ '''', RTRIM(@ErrorMessage), @Terminal)
		
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

	DECLARE @STATE CHAR(3)
	DECLARE @ErrorMessage NVARCHAR(4000)
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
	SET @STATE = 'NOK'
	SET @ErrorMessage = 'Não foi gerado nenhum documento'
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

	SELECT @ERP = ISNULL(ParameterValue, '') from u_Kapps_Parameters WITH(NOLOCK) where ParameterGroup='MAIN' and ParameterId = 'ERP'

	IF (upper(@ERP) = 'PERSONALIZADO')
	BEGIN
		EXECUTE SP_u_Kapps_ContagemUSR @DocTipo, @StampHeader, @TipoDoc, @fecha, @Terminal, @UserIntegracao, @InternalStampDoc
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
			SET @STATE = 'OK'
			SET @ErrorMessage = ''
		END
		ELSE
		BEGIN
			SET @ErrorMessage = 'Documento de contagem não existe'	
			SET @ErrorSeverity = 16
			SET @ErrorState = 1
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)			
		END

		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
			IF @@TRANCOUNT >0
				ROLLBACK TRANSACTION
			SET @STATE = 'NOK'
 
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

			INSERT INTO u_Kapps_Log(LogStamp,LogType,LogMessage,LogDetail,LogTerminal) 
			VALUES (CONVERT(VARCHAR, GETDATE(), 112) + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),10,''''+RTRIM(@DocTipo)+''', '''+RTRIM(@StampHeader) +''', '''+ RTRIM(@TipoDoc) +''', '''+ RTRIM(@fecha) +''', '''+ RTRIM(@terminal) +''', '''+ RTRIM(@UserIntegracao)+ ''', '''+RTRIM(@InternalStampDoc)+ '''', RTRIM(@ErrorMessage), @Terminal)

			GOTO FIM
		END CATCH

		FIM:
			IF(@TipoContagem = 'C')
			BEGIN
				CLOSE curContagem
				DEALLOCATE curContagem
			END
	END
	SELECT @STATE, @ErrorMessage
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



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
	DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO
CREATE PROCEDURE SPMSS_Reconstroi_APPSP_USR
	@name varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @spsql varchar(MAX)
	DECLARE @spsqlnovo varchar(MAX)

	SET @spsql = ''

	SET @spsql = (select (substring(sm.definition, charindex('SET NOCOUNT ON;', RTRIM(sm.definition)) + 16, LEN(sm.definition) - (charindex('SET NOCOUNT ON;', sm.definition) + 15)))
		from sys.sql_modules as sm JOIN sys.objects AS o ON sm.object_id = o.object_id where o.type = 'P'
		and OBJECT_NAME(sm.object_id) = @name)

	IF (@spsql <> '')
	BEGIN
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductPriceUSR') AND type in (N'P', N'PC'))
		DROP PROCEDURE SP_u_Kapps_ProductPriceUSR
						
		SET @spsqlnovo = 'CREATE PROCEDURE SP_u_Kapps_ProductPriceUSR
							@REFERENCIA VARCHAR(40),		--	REFERENCIA DO ARTIGO
							@Lot VARCHAR(50),			--	LOTE DO ARTIGO
							@ARMAZEM VARCHAR(50),	--	ARMAZÉM
							@NRSERIE VARCHAR(50),		--	NÚMERO DE SÉRIE
							@QTD DECIMAL(20,7),		--	QUANTIDADE
							@CLIENTE VARCHAR(50),		--	CLIENTE
							@FORNECEDOR VARCHAR(50),	--	FORNECEDOR
							@EVENTO INT,				--	1(PICKING) OU 2(RECEPCAO) OU 3(PACKING) OU 4(OUTROS) OU 5(CONTAGEM) OU 6(CONSULTA STOCKS) OU 7(PALETES) OU 8(PICKTRANSF) 
							@DOCORIGEM VARCHAR(50),	--	EM OUTROS É O DOCUMENTO QUE O UTILZIADOR CRIOU
							@CABKEY VARCHAR(50),		--	CHAVE DO CABECALHO DO DOCUMENTO DE ORIGEM
							@LINEKEY VARCHAR(50)		--	CHAVE DA LINHA DO DOCUMENTO DE ORIGEM
							AS
							BEGIN
								SET NOCOUNT ON; ' + @spsql
							
		EXEC (@spsqlnovo)
	END
END
GO
EXEC SPMSS_Reconstroi_APPSP_USR 'SP_u_Kapps_ProductPriceUSR'
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO
CREATE PROCEDURE SPMSS_Reconstroi_APPSP_USR
	@name varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @spsql varchar(MAX)
	DECLARE @spsqlnovo varchar(MAX)

	SET @spsql = ''

	SET @spsql = (select (substring(sm.definition, charindex('SET NOCOUNT ON;', RTRIM(sm.definition)) + 16, LEN(sm.definition) - (charindex('SET NOCOUNT ON;', sm.definition) + 15)))
		from sys.sql_modules as sm JOIN sys.objects AS o ON sm.object_id = o.object_id where o.type = 'P'
		and OBJECT_NAME(sm.object_id) = @name)

	IF (@spsql <> '')
	BEGIN
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductsUSR') AND type in (N'P', N'PC'))
			DROP PROCEDURE SP_u_Kapps_ProductsUSR
						
		SET @spsqlnovo = 'CREATE PROCEDURE SP_u_Kapps_ProductsUSR
	@REFERENCIA VARCHAR(40),	--	REFERENCIA DO ARTIGO
	@CHAVELINHA VARCHAR(50),	--	CHAVE DA LINHA 
	@STAMPLIN VARCHAR(50),		--	Stamp da linha u_Kapps_DossierLin
	@PACKID	VARCHAR(50),		--  Numero da caixa
	@LOTE	VARCHAR(50),		--  Lote
	@VALIDADE VARCHAR(50),		--  Validade
	@UNITWORK varchar(50)		--  Unidade selecionada
AS
BEGIN
	SET NOCOUNT ON; ' + @spsql
							
		EXEC (@spsqlnovo)
	END
END
GO
EXEC SPMSS_Reconstroi_APPSP_USR 'SP_u_Kapps_ProductsUSR'
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO
CREATE PROCEDURE SPMSS_Reconstroi_APPSP_USR
	@name varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @spsql varchar(MAX)
	DECLARE @spsqlnovo varchar(MAX)

	SET @spsql = ''

	SET @spsql = (select (substring(sm.definition, charindex('SET NOCOUNT ON;', RTRIM(sm.definition)) + 16, LEN(sm.definition) - (charindex('SET NOCOUNT ON;', sm.definition) + 15)))
		from sys.sql_modules as sm JOIN sys.objects AS o ON sm.object_id = o.object_id where o.type = 'P'
		and OBJECT_NAME(sm.object_id) = @name)

	IF (@spsql <> '')
	BEGIN
						
					
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersUSR') AND type in (N'P', N'PC'))
			DROP PROCEDURE SP_u_Kapps_DossiersUSR
						
		SET @spsqlnovo = 'CREATE PROCEDURE SP_u_Kapps_DossiersUSR
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
								@estadoUSR varchar(3) OUTPUT,		-- Codigo erro
								@descerroUSR varchar(255) OUTPUT	-- Descrição erro								
							AS
							BEGIN
								SET NOCOUNT ON; ' + @spsql
							
		EXEC (@spsqlnovo)

	END
END
GO
EXEC SPMSS_Reconstroi_APPSP_USR 'SP_u_Kapps_DossiersUSR'
GO



IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'UpdateLineNumber'))
	DROP TRIGGER UpdateLineNumber
GO
CREATE TRIGGER UpdateLineNumber
ON u_Kapps_PackingDetails
 AFTER INSERT
AS
BEGIN
	UPDATE det set LineID = (SELECT MAX(LineID) + 1 FROM u_Kapps_PackingDetails) FROM u_Kapps_PackingDetails det JOIN inserted ins on det.StampLin = ins.StampLin and det.PackID = ins.PackID
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



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO
CREATE PROCEDURE SPMSS_Reconstroi_APPSP_USR
	@name varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @spsql varchar(MAX)
	DECLARE @spsqlnovo varchar(MAX)

	SET @spsql = ''

	SET @spsql = (select (substring(sm.definition, charindex('SET NOCOUNT ON;', RTRIM(sm.definition)) + 16, LEN(sm.definition) - (charindex('SET NOCOUNT ON;', sm.definition) + 15)))
		from sys.sql_modules as sm JOIN sys.objects AS o ON sm.object_id = o.object_id where o.type = 'P'
		and OBJECT_NAME(sm.object_id) = @name)

	IF (@spsql <> '')
	BEGIN
						
					
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductStockUSR') AND type in (N'P', N'PC'))
			DROP PROCEDURE SP_u_Kapps_ProductStockUSR
						
		SET @spsqlnovo = 'CREATE PROCEDURE SP_u_Kapps_ProductStockUSR'+CHAR(13)+CHAR(10)+
			'	@REFERENCIA VARCHAR(40),		--	REFERENCIA DO ARTIGO'+CHAR(13)+CHAR(10)+
			'	@Lot VARCHAR(50),			--	LOTE DO ARTIGO'+CHAR(13)+CHAR(10)+
			'	@ARMAZEM VARCHAR(50),		--	ARMAZÉM'+CHAR(13)+CHAR(10)+
			'	@NRSERIE VARCHAR(50),		--	NÚMERO DE SÉRIE'+CHAR(13)+CHAR(10)+
			'	@EVENTO INT,				--	1(PICKING) OU 2(RECEPCAO) OU 3(PACKING) OU 4(OUTROS) OU 5(CONTAGEM) OU 6(CONSULTA DE STOCKS)	'+CHAR(13)+CHAR(10)+
			'	@LOCALIZACAO VARCHAR(50),	--	LOCALIZACAO'+CHAR(13)+CHAR(10)+
			'	@LISTA INT = 0				--  0(RETORNA APENAS UMA LINHA @STOCKAUSAR, @STOCK, @STOCKDISPONIVEL)'+CHAR(13)+CHAR(10)+
			'								--  1(RETORNA LINHAS com CodigoArmazem, NomeArmazem, Stock, StockDisponivel AGRUPADA por CodigoArmazem e ORDENADA POR NomeArmazem)'+CHAR(13)+CHAR(10)+
			'								--  2(RETORNA LINHAS com Localizacao, Lote, Stock, StockDisponivel AGRUPADA por Localizacao, Lote ORDENADA POR Localizacao)'+CHAR(13)+CHAR(10)+
			'								--  3(RETORNA LINHAS com Localizacao, Lote, Stock, StockDisponivel AGRUPADA por Localizacao, Lote ORDENADA POR Lote)'+CHAR(13)+CHAR(10)+
			'								--  4(RETORNA LINHAS com Lote, Stock, Validade, DataProducao, Armazem, Localizacao)'+CHAR(13)+CHAR(10)+
			'AS'+CHAR(13)+CHAR(10)+
			'BEGIN'+CHAR(13)+CHAR(10)+
			'	SET NOCOUNT ON; '+ @spsql
							
		EXEC (@spsqlnovo)

	END
END
GO
EXEC SPMSS_Reconstroi_APPSP_USR 'SP_u_Kapps_ProductStockUSR'
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO
CREATE PROCEDURE SPMSS_Reconstroi_APPSP_USR
	@name varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @spsql varchar(MAX)
	DECLARE @spsqlnovo varchar(MAX)

	SET @spsql = ''

	SET @spsql = (select (substring(sm.definition, charindex('SET NOCOUNT ON;', RTRIM(sm.definition)) + 16, LEN(sm.definition) - (charindex('SET NOCOUNT ON;', sm.definition) + 15)))
		from sys.sql_modules as sm JOIN sys.objects AS o ON sm.object_id = o.object_id where o.type = 'P'
		and OBJECT_NAME(sm.object_id) = @name)

	IF (@spsql <> '')
	BEGIN
						
					
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_PriceCheckingUSR') AND type in (N'P', N'PC'))
			DROP PROCEDURE SP_u_Kapps_PriceCheckingUSR
						
		SET @spsqlnovo = 'CREATE PROCEDURE SP_u_Kapps_PriceCheckingUSR
								@REFERENCIA VARCHAR(40),		--	REFERENCIA DO ARTIGO
								@ARMAZEM VARCHAR(50),		--	ARMAZÉM
								@UNIDADE VARCHAR(50)		--	UNIDADE
							AS
							BEGIN
								SET NOCOUNT ON; ' + @spsql
							
		EXEC (@spsqlnovo)

	END
END
GO
EXEC SPMSS_Reconstroi_APPSP_USR 'SP_u_Kapps_PriceCheckingUSR'
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
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


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO
CREATE PROCEDURE SPMSS_Reconstroi_APPSP_USR
	@name varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @spsql varchar(MAX)
	DECLARE @spsqlnovo varchar(MAX)

	SET @spsql = ''

	SET @spsql = (select (substring(sm.definition, charindex('SET NOCOUNT ON;', RTRIM(sm.definition)) + 16, LEN(sm.definition) - (charindex('SET NOCOUNT ON;', sm.definition) + 15)))
		from sys.sql_modules as sm JOIN sys.objects AS o ON sm.object_id = o.object_id where o.type = 'P'
		and OBJECT_NAME(sm.object_id) = @name)

	IF (@spsql <> '')
	BEGIN
						
					
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ContagemUSR') AND type in (N'P', N'PC'))
			DROP PROCEDURE SP_u_Kapps_ContagemUSR
						
		SET @spsqlnovo = 'CREATE PROCEDURE SP_u_Kapps_ContagemUSR
			  @DocTipo CHAR(5),
			  @StampHeader CHAR(25),
			  @TipoDoc VARCHAR(50),
			  @fecha CHAR(5),
			  @terminal CHAR(5),
			  @UserIntegracao VARCHAR(50),
			  @InternalStampDoc VARCHAR(50)
			AS
			BEGIN
				SET NOCOUNT ON; ' + @spsql
							
		EXEC (@spsqlnovo)

	END
END
GO
EXEC SPMSS_Reconstroi_APPSP_USR 'SP_u_Kapps_ContagemUSR'
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_RefreshUsers') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_RefreshUsers
GO
CREATE PROCEDURE SP_u_Kapps_RefreshUsers 
AS
BEGIN
      SET NOCOUNT ON;

      DECLARE @strlogin varchar(50)
      DECLARE @strNome varchar(50)
	  DECLARE @strActif bit
 	  
	  DECLARE @ERP VARCHAR(25)
	  DECLARE @BDSistema VARCHAR(25)

      SET @strlogin = ''
      SET @strNome = ''
	  SET @strActif = 0
	  SET @ERP = ''

	  SELECT @ERP=UPPER(ParameterValue) FROM u_Kapps_Parameters WITH(NOLOCK) WHERE ParameterGroup='MAIN' and ParameterID = 'ERP' 

	  IF  (@ERP = 'ETICADATA_16/17/18/19')
	  BEGIN
		SELECT @BDSistema = ParameterValue FROM u_Kapps_Parameters WITH(NOLOCK) WHERE ParameterGroup='MAIN' and Upper(ParameterID) = Upper('BD_Sistema')

		exec ('INSERT INTO u_Kapps_Users(Username, Name, Actif) select strlogin, CASE WHEN ISNULL(strNome,'''') = '''' THEN strlogin ELSE strNome END, CAST(0 as bit) from ' + @BDSistema + '..Tbl_Utilizadores WITH(NOLOCK) WHERE strlogin not in (SELECT Username FROM u_kapps_users WITH(NOLOCK))')
		exec ('DELETE FROM u_Kapps_Users WHERE Username not in (select strlogin from ' + @BDSistema + '..Tbl_Utilizadores WITH(NOLOCK))')
		exec ('DELETE FROM u_Kapps_Parameters WHERE ParameterType=''USR'' and ParameterGroup<>''DEFAULT'' and ParameterGroup not in (SELECT Username FROM u_Kapps_Users WITH(NOLOCK) WHERE Actif=1)')
	  END
	  ELSE IF (@ERP = 'PRIMAVERA')
	  BEGIN
		SELECT @BDSistema = ParameterValue FROM u_Kapps_Parameters WITH(NOLOCK) WHERE ParameterGroup='MAIN' and Upper(ParameterID) = Upper('BD_Empresas')
		exec ('INSERT INTO u_Kapps_Users(Username, Name, Actif) SELECT Codigo, CASE WHEN ISNULL(Nome,'''') = '''' THEN Codigo ELSE Nome END, CAST(0 as bit) FROM ' + @BDSistema + '..Utilizadores WITH(NOLOCK) WHERE Codigo not in (SELECT Username FROM u_kapps_users WITH(NOLOCK))')
		exec ('DELETE FROM u_Kapps_Users WHERE Username not in (select Codigo from ' + @BDSistema + '..Utilizadores WITH(NOLOCK))')
		exec ('DELETE FROM u_Kapps_Parameters WHERE ParameterType=''USR'' and ParameterGroup<>''DEFAULT'' and ParameterGroup not in (SELECT Username FROM u_Kapps_Users WITH(NOLOCK) WHERE Actif=1)')
	  END
	  ELSE IF (@ERP = 'PHC')
	  BEGIN
		exec ('INSERT INTO u_Kapps_Users(Username, Name, Actif) SELECT usercode,CASE WHEN ISNULL(username,'''') = '''' THEN usercode ELSE username END, CAST(0 as bit) FROM us WITH(NOLOCK) WHERE usercode not in (SELECT Username FROM u_kapps_users WITH(NOLOCK))')	
		exec ('DELETE FROM u_Kapps_Users WHERE Username not in (select usercode from us WITH(NOLOCK))')
		exec ('DELETE FROM u_Kapps_Parameters WHERE ParameterType=''USR'' and ParameterGroup<>''DEFAULT'' and ParameterGroup not in (SELECT Username FROM u_Kapps_Users WITH(NOLOCK) WHERE Actif=1)')
	  END
	  ELSE IF (@ERP = 'SAGE_50C')
	  BEGIN
		exec ('INSERT INTO u_Kapps_Users(Username, Name, Actif) SELECT AppUserName,AppUserName, CAST(0 as bit) FROM AppUsers WITH(NOLOCK) WHERE AppUserName not in (SELECT Username FROM u_kapps_users WITH(NOLOCK))')	
		exec ('DELETE FROM u_Kapps_Users WHERE Username not in (select AppUserName from AppUsers WITH(NOLOCK))')
		exec ('DELETE FROM u_Kapps_Parameters WHERE ParameterType=''USR'' and ParameterGroup<>''DEFAULT'' and ParameterGroup not in (SELECT Username FROM u_Kapps_Users WITH(NOLOCK) WHERE Actif=1)')
  
	  END
	  ELSE IF (@ERP = 'SAGE_100C')
	  BEGIN
		exec ('INSERT INTO u_Kapps_Users(Username, Name, Actif) SELECT ''admin'',''admin'', CAST(0 as bit) WHERE ''admin'' not in (SELECT Username FROM u_kapps_users WITH(NOLOCK))')	
	  END
	  ELSE IF (@ERP = 'PERSONALIZADO')
	  BEGIN
		exec ('INSERT INTO u_Kapps_Users(Username, Name, Actif) SELECT ''admin'',''admin'', CAST(0 as bit) WHERE ''admin'' not in (SELECT Username FROM u_kapps_users WITH(NOLOCK))')	
	  END
END
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

	DECLARE @result int
	DECLARE @resultDescription nvarchar(200)

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


	SET @resultDescription = ''
	SET @result = 0
	SET @DocID = ''
	SET @sql = ''
	SET @inTransaction = 0

	IF LEN(@SSCC1)=20
	BEGIN
		SET @SSCC1=RIGHT(@SSCC1,18)
	END
	IF LEN(@SSCC2)=20
	BEGIN
		SET @SSCC2=RIGHT(@SSCC2,18)
	END

	BEGIN TRY

		SELECT @LocationActif=l.Actif, @Armazem=l.WarehouseID, @LoadStatus=h.LoadStatus, @ActiveLoadNr=l.ActiveLoadNr, @DocID=d.DocID, @DocStatus=d.DocStatus, @DocSequence=d.LoadingSequence, @AlreadyReadedSSCC1=p1.SSCC, @AlreadyReadedSSCC2=p2.SSCC
		FROM u_Kapps_LoadingLocations l
		LEFT JOIN u_Kapps_LoadingDeliveryPoints d on d.LoadNr=l.ActiveLoadNr and d.Actif=1
		LEFT JOIN u_Kapps_LoadingHeader h on h.LoadNr=l.ActiveLoadNr
		LEFT JOIN u_Kapps_LoadingPallets p1 on p1.LoadNr=l.ActiveLoadNr and (p1.SSCC=@SSCC1)
		LEFT JOIN u_Kapps_LoadingPallets p2 on p2.LoadNr=l.ActiveLoadNr and (p2.SSCC=@SSCC2)
		WHERE l.LocationID=@LocationID;
		SET @Recordcount=@@ROWCOUNT

		IF @Recordcount=0
		BEGIN
			SET @resultDescription='Não existe o cais de carga indicado'
		END
		ELSE IF @Recordcount>1
		BEGIN
			SET @resultDescription='Existe mais do que um documento ativo' --na tabela DeliveryPoints
		END
		ELSE IF @LocationActif is null or @LocationActif=0
		BEGIN
			SET @resultDescription='O cais não está ativo'
		END
		ELSE IF @LoadStatus is null or @LoadStatus=0
		BEGIN
			SET @resultDescription='Carga não está ativa'
		END
		ELSE IF @DocID is null or @DocID=''
		BEGIN
			SET @resultDescription='Não existe nenhum documento ativo'
		END
		ELSE IF @SSCC1='' and @SSCC2=''
		BEGIN
			SET @resultDescription='Não foi enviado nenhum SSCC'
		END
		ELSE IF @SSCC1<>'' and LEN(@SSCC1)<>18
		BEGIN
			SET @resultDescription='Tamanho invalido do SSCC1'
		END
		ELSE IF @SSCC2<>'' and LEN(@SSCC2)<>18
		BEGIN
			SET @resultDescription='Tamanho invalido do SSCC2'
		END
		ELSE IF @AlreadyReadedSSCC1 is not null
		BEGIN
			SET @resultDescription='O (SSCC1) '+@SSCC1+CHAR(13)+CHAR(10)+'já foi lido'
		END
		ELSE IF @AlreadyReadedSSCC2 is not null
		BEGIN
			SET @resultDescription='O (SSCC2) '+@SSCC2+CHAR(13)+CHAR(10)+'já foi lido'
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION
			SET @inTransaction=1
			/*
			WAITFOR DELAY '00:00:00.200' 
			SET @DateTimeTmp = GETDATE()
			SET @stamp = @LocationID+'-' + dbo.u_Kapps_DateToString(@DateTimeTmp) + dbo.u_Kapps_TimeToString(@DateTimeTmp)
			*/

			DECLARE curSSCC CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
			SELECT [Article], [Quantity], [Unit], [Lot], [ExpirationDate], [SerialNumber], [NetWeight], [CurrentWarehouse], [CurrentLocation], [HeaderSSCC]
			FROM v_Kapps_SSCC_Lines WITH(NOLOCK) 
			WHERE (HeaderSSCC<>'') and ((HeaderSSCC=@SSCC1) or (HeaderSSCC=@SSCC2));
			OPEN curSSCC 
 			FETCH NEXT FROM curSSCC INTO @Article, @Quantity, @Unit, @Lot, @ExpirationDate, @SerialNumber, @NetWeight, @CurrentWarehouse, @CurrentLocation, @CurrentSSCC;
			SET @ActivoCurSSCC=1

			IF @@FETCH_STATUS <> 0
			BEGIN
				SET @ErrorMessage = 'SSCC não encontrado'
				SET @ErrorSeverity = 16
				SET @ErrorState = 1
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)			
			END


			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- Verificar Stock
				SET @sql= 'SELECT SUM(Total) as TempStock FROM 
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
				from u_KApps_DossierLin lin WITH(NOLOCK) 
				left join v_Kapps_Articles va WITH(NOLOCK) ON va.Code=lin.Ref
				where lin.Ref = '''+RTRIM(@Article)+''' AND Warehouse='''+@CurrentWarehouse+''''
				IF @CurrentLocation<>''
					SET @sql=@sql+' and Location='''+@CurrentLocation+''''
				IF @Lot<>''
					SET @sql=@sql+' and Lot='''+@Lot+''''

				SET @sql=@sql+' AND lin.Integrada = ''N'' and lin.Status = ''A'' and (lin.EntityType = ''C'' OR lin.EntityType = '''')
				UNION ALL
				select COALESCE(sum(CASE WHEN va.UseWeight=1 THEN lin.NetWeight ELSE lin.qty END),0 ) AS Total 
				from u_KApps_DossierLin lin WITH(NOLOCK) 
				left join v_Kapps_Articles va WITH(NOLOCK) ON va.Code=lin.Ref
				where lin.Ref = '''+RTRIM(@Article)+''' AND WarehouseOUT='''+@CurrentWarehouse+''''
				IF @CurrentLocation<>''
					SET @sql=@sql+' and LocationOUT='''+@CurrentLocation+''''
				IF @Lot<>''
					SET @sql=@sql+' and Lot='''+@Lot+''''
				

				SET @sql=@sql+' AND lin.Integrada = ''N'' and lin.Status = ''A'' and lin.EntityType = '''''
				SET @sql=@sql+' )temp'

				INSERT INTO @tempTable exec (@sql)

				SELECT @Stock=(Select TempStock from @tempTable)
				DELETE FROM @tempTable

				IF (@Stock<=0)
				BEGIN
					SET @ErrorMessage = 'Não existe stock do artigo ' + RTRIM(@Article)+' armazém '+@CurrentWarehouse
					IF @CurrentLocation<>''
						SET @ErrorMessage=@ErrorMessage+' localização '+@CurrentLocation
					IF @Lot<>''
						SET @ErrorMessage=@ErrorMessage+' lote '+@Lot
					SET @ErrorSeverity = 16
					SET @ErrorState = 1
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)			
				END



				SET @Qtd = @Quantity
				SET @QtdSatisfeita = 0
				
				DECLARE curLINES CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT [id], [LineID], [ProductID], [Lot], [Quantity], [Unit], [LoadedQuantity] /*, [ExpirationDate], [SerialNumber], [NetWeight], [Location]*/
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

						INSERT INTO u_Kapps_LoadingPallets(LoadNr, DocID, LineID, SSCC, Qty, Unit)
						VALUES (CAST(@ActiveLoadNr as nvarchar(3)),@DocID,@LineID,@CurrentSSCC,@Qtd,@Unit)

						/*
						SET @sql='INSERT INTO u_Kapps_LoadingPallets(LoadNr, DocID, LineID, SSCC, Qty, Unit)';
						SET @sql=@sql+ ' SELECT '+CAST(@ActiveLoadNr as nvarchar(3))+','''+ @DocID+''','''+ @LineID+''','''+@CurrentSSCC+''','+@Qtd+','''+@Unit+''''
						EXEC (@sql)
						*/

					END
					--ELSE
					--BEGIN
						-- Parcial???
						--UPDATE u_Kapps_LoadingLines SET LoadedQuantity = LoadedQuantity + (@LineQuantity-@LineLoadedQuantity) WHERE id=@ID
						--SET @QtdSatisfeita = @QtdSatisfeita + (@LineQuantity-@LineLoadedQuantity)					
					--END

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

							INSERT INTO u_Kapps_LoadingPallets(LoadNr, DocID, LineID, SSCC, Qty, Unit)
							VALUES (CAST(@ActiveLoadNr as nvarchar(3)),@DocID,@LineID,@CurrentSSCC,@Qtd,@Unit)

							/*
							SET @sql='INSERT INTO u_Kapps_LoadingPallets(LoadNr, DocID, LineID, SSCC, Qty, Unit)';
							SET @sql=@sql+ ' SELECT '+CAST(@ActiveLoadNr as nvarchar(3))+','''+ @DocID+''','''+ @LineID+''','''+@CurrentSSCC+''','+@Qtd+','''+@Unit+''''
							EXEC (@sql)
							*/

						END
						--ELSE
						--BEGIN
							-- Parcial???
							--UPDATE u_Kapps_LoadingLines SET LoadedQuantity = LoadedQuantity + (@LineQuantity-@LineLoadedQuantity) WHERE id=@ID
							--SET @QtdSatisfeita = @QtdSatisfeita + (@LineQuantity-@LineLoadedQuantity)					
						--END

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
							ELSE
							BEGIN
								UPDATE u_Kapps_LoadingHeader 
								SET LoadStatus=CASE WHEN EXISTS(SELECT TOP 1 1 FROM u_Kapps_LoadingLines WHERE LoadNr=@ActiveLoadNr and LineStatus=2) THEN 2 ELSE 1 END 
								WHERE LoadNr=@ActiveLoadNr;
							END
						END
					END
				END
				ELSE
				BEGIN
					select @Description=Description from v_Kapps_Articles WHERE Code=@Article
					IF @QtdSatisfeita>0
						SET @ErrorMessage = 'Não foi possivel satisfazer a quantidade total do artigo ' +CHAR(13)+CHAR(10)+ RTRIM(@Article)+ CHAR(13)+CHAR(10) +@Description;
					ELSE
						SET @ErrorMessage = 'O artigo não existe por satisfazer no documento ativo ' +CHAR(13)+CHAR(10)+ RTRIM(@Article) +CHAR(13)+CHAR(10)+ @Description

					IF @Lot<>''
						SET @ErrorMessage=@ErrorMessage+CHAR(13)+CHAR(10)+'Lote '+@Lot
					SET @ErrorSeverity = 16
					SET @ErrorState = 1

					SET @result=0
					SET @resultDescription=@ErrorMessage
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

	 			FETCH NEXT FROM curSSCC INTO @Article, @Quantity, @Unit, @Lot, @ExpirationDate, @SerialNumber, @NetWeight, @CurrentWarehouse, @CurrentLocation, @CurrentSSCC;
			END

			/*
			SET @sql='INSERT INTO u_Kapps_LoadingPallets(LoadNr, DocID, SSCC)';
			SET @sql=@sql+ ' SELECT '+CAST(@ActiveLoadNr as nvarchar(3))+','''+ @DocID+''','''+@SSCC1+''''
			IF (@SSCC2<>'')
			BEGIN
				SET @sql= @sql+ ' UNION ALL SELECT '+CAST(@ActiveLoadNr as nvarchar(3))+','''+ @DocID+''','''+@SSCC2+''''
			END
			EXEC (@sql)
			*/
			
			SET @result = 1
			SET @resultDescription = 'OK'

			COMMIT TRANSACTION
		END
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		IF @inTransaction=1
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @result = 0
		SET @resultDescription = @ErrorMessage
					
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		INSERT INTO u_Kapps_Log(LogStamp,LogType,LogMessage,LogDetail,LogTerminal) 
		VALUES (CONVERT(VARCHAR, GETDATE(), 112) + REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''),1,''''+@LocationID+''', '''+@SSCC1 +''', '''+ @SSCC2+ '''', RTRIM(@ErrorMessage), @LocationID)

	END CATCH


	FIM:


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

	SELECT @result, @resultDescription
END
GO

	
UPDATE u_Kapps_Parameters SET ParameterValue = '52'  WHERE ParameterGroup='MAIN' and ParameterID = 'SCRIPTSVERSION'
GO
