-- *******************************************************************************************************************
-- Função DateToString
-- Converter DateTime para String no formato do MSS (AAAAMMDD)
-- *******************************************************************************************************************
CREATE FUNCTION [dbo].[DateToString] 
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

-- *******************************************************************************************************************
-- Função EurToEsc
-- Converter valores de euros em escudos
-- *******************************************************************************************************************
CREATE FUNCTION [dbo].[EurToEsc] 
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

-- *******************************************************************************************************************
-- Função ExtractFromACL
-- Extrair dos campos ACL o valor de uma determinada posição
-- *******************************************************************************************************************
CREATE FUNCTION [dbo].[ExtractFromACL] 
(
	@Source VARCHAR(2000),
	@Rank INT
)
RETURNS VARCHAR(1000)
AS
BEGIN
	DECLARE @Pos INT
	DECLARE @SepCount INT
	DECLARE @PosStart INT
	DECLARE @PosEnd INT
	declare @result VARCHAR(1000)
	SET @Pos = 1
	SET @SepCount = 0
	SET @PosStart = 1
	SET @PosEnd = 0
	
	WHILE @Pos <= LEN(@Source)
	BEGIN
		IF SUBSTRING(@Source, @Pos, 1) = CHAR(7)
		BEGIN
			SET @SepCount = @SepCount + 1
			IF @Rank > @SepCount
				SET @PosStart = @Pos + 1
		END

		IF @SepCount = @Rank
		BEGIN
			SET @PosEnd = @Pos
			BREAK
		END
		
		SET @Pos = @Pos + 1
	END

	IF @posend = 0
		SET @posend = LEN(@Source)+1

		
	IF (@Rank > @SepCount +1)
        SET @result = ''
	ELSE 
        SET @result = SUBSTRING(@Source, @PosStart, @PosEnd-@PosStart)

	RETURN @result

END
GO

-- *******************************************************************************************************************
-- Função SetString
-- Tendo em conta um determinado separador inserir uma string numa determinada posição
-- *******************************************************************************************************************
CREATE FUNCTION [dbo].[SetString]
(
@Source VARCHAR(2000), 
@Rank INT, 
@Value VARCHAR(1000), 
@Separator INT 
) 
RETURNS VARCHAR(2000) 
AS 
BEGIN 
	DECLARE @Result VARCHAR(1000)
	IF @Source = '' OR @Rank = 0
	BEGIN
		SET @Result = @Source
		GOTO FIM
	END
	DECLARE @NSeparators INT
	DECLARE @SepCount INT 
	DECLARE @PosStart INT 
	DECLARE @PosEnd INT 
	SET @NSeparators = Len(@Source) - Len(Replace(@Source, Char(@Separator), '')) / Len(Char(@Separator))
	IF @NSeparators < @Rank - 1
	BEGIN
		SET @Result = @Source
		WHILE @NSeparators < @Rank - 1
		BEGIN
			SET @Result = @Result + Char(@Separator)
			SET @NSeparators = @NSeparators + 1
		END
		SET @Result = @Result + @Value
	END
	ELSE
	BEGIN
		SET @SepCount = 0 
		SET @PosStart = 0
		SET @PosEnd = 0
		WHILE @SepCount <  @Rank - 1
		BEGIN 
			SET @PosStart = CHARINDEX(CHAR(@Separator), @Source, @PosStart) + 1
			SET @SepCount = @SepCount + 1 
		END 
		SET @PosEnd = CHARINDEX(CHAR(@Separator), @Source, @PosStart) 
		IF @PosStart < 1
			SET @PosStart = 1
		IF LEN(@Source) >= @PosStart and @PosEnd = 0 
			SET @PosEnd = LEN(@Source) + 1 
		SET @Result =  STUFF(@Source, @PosStart, @PosEnd-@PosStart, @Value) 
	END
FIM:
RETURN @Result
END 
GO

-- *******************************************************************************************************************
-- Função StringToDate
-- Converter data no MSS para DateTime
-- *******************************************************************************************************************
CREATE FUNCTION [dbo].[StringToDate] 
(
	@Data VARCHAR(8)
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Result DATETIME

	SET @Result = CAST(@Data AS DATETIME)
	RETURN @Result
END
GO

-- *******************************************************************************************************************
-- Função StringToNum
-- Converter de número em formato string
-- *******************************************************************************************************************
CREATE FUNCTION [dbo].[StringToNum] 
(
	@NumStr VARCHAR(50)
)
RETURNS NUMERIC(19,6)
AS
BEGIN
	DECLARE @Result NUMERIC(19,6)
	
	IF @NumStr <> ''
		SELECT @RESULT = REPLACE(@NumStr, ',', '.')
	ELSE
		SET @Result = 0
	RETURN @Result
END
GO

-- *******************************************************************************************************************
-- Função TimeToString
-- Converter de Hora para formato MSS (HHMMSS)
-- *******************************************************************************************************************
CREATE FUNCTION [dbo].[TimeToString] 
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

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_CalcDescontos
-- Calcular o valor do desconto a integrar no PHC
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_CalcDescontos]
	@ValDesc NUMERIC(18,5),
	@TaxDesc1 NUMERIC(18,5),
	@TaxDesc2 NUMERIC(18,5),
	@TaxDesc3 NUMERIC(18,5),
	@TaxDesc4 NUMERIC(18,5),
	@PrUnit NUMERIC(19,6),
	@Qtt NUMERIC(16,3),
	@DescCab NUMERIC(18,5),
	@Desconto1 NUMERIC(18,5) OUTPUT,
	@Desconto2 NUMERIC(18,5) OUTPUT,
	@Desconto3 NUMERIC(18,5) OUTPUT,
	@Desconto4 NUMERIC(18,5) OUTPUT,
	@Desconto5 NUMERIC(18,5) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @Desconto1 = @TaxDesc1
	SET @Desconto2 = @TaxDesc2
	SET @Desconto3 = @TaxDesc3
	SET @Desconto4 = @TaxDesc4
	SET @Desconto5 = 0
	
	IF @DescCab > 0
	BEGIN
		IF @TaxDesc4 <> 0
			SET @Desconto5 = @DescCab
		ELSE IF @TaxDesc3 <> 0
			SET @Desconto4 = @DescCab
		ELSE IF @TaxDesc2 <> 0
			SET @Desconto3 = @DescCab
		ELSE IF @TaxDesc1 <> 0 
			SET @Desconto2 = @DescCab
		ELSE SET @Desconto1 = @DescCab
	END
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_CheckCliente
-- Verificar se o cliente já existe
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_CheckCliente]
	@CliNum INT,
	@EstabNum INT,
	@clstamp CHAR(25) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CliCount INT
	SELECT @clstamp=clstamp FROM cl(nolock) WHERE "no" = @CliNum AND estab = @EstabNum

END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_CheckLote
-- Verificar se o lote do documento existe caso contrário inserir
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_CheckLote]
	@ref VARCHAR(30),
	@design VARCHAR(60),
	@lote VARCHAR(30),
	@data VARCHAR(8),
	@validade VARCHAR(8),
	@DocTerminal VARCHAR(5),
	@dataDoc VARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr VARCHAR(8)
	DECLARE @TimeStr VARCHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @sestamp CHAR(25)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	
	IF (SELECT COUNT(*) FROM se WHERE ref = @ref AND lote = @lote) = 0
	BEGIN	
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
		
		SET @sestamp = 'MSS_' + @DateStr + @TimeStr
		SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
		SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

		SET @ousrdata = @DateStr
		SET @usrdata = @DateStr

		SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
		SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

		IF (@data = '')
			SET @data = @dataDoc

		INSERT INTO se (sestamp, ref, lote, design, data, validade, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES (@sestamp, @ref, @lote, @design, @data, @validade, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetArtInfo
-- Ler dados da ficha do artigo
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetArtInfo]
	@ArtRef VARCHAR(18),
	@ArtUsr1 VARCHAR(20) OUTPUT,
	@ArtUsr2 VARCHAR(20) OUTPUT,
	@ArtUsr3 VARCHAR(35) OUTPUT,
	@ArtUsr4 VARCHAR(25) OUTPUT,
	@ArtUsr5 VARCHAR(120) OUTPUT,
	@ArtUsr6 VARCHAR(30) OUTPUT,
	@ArtFam VARCHAR(18) OUTPUT,
	@ArtPCusto NUMERIC(19,6) OUTPUT,
	@ArtCodigo VARCHAR(18) OUTPUT,
	@ArtForref VARCHAR(20) OUTPUT,
	@ArtIva1Incl INT OUTPUT,
	@ArtComissao INT OUTPUT,
	@ArtCPoc INT OUTPUT,
	@ArtStns INT OUTPUT,
	@ArtLote INT OUTPUT,
	@ArtPPond NUMERIC(19,6) OUTPUT,
	@ArtUni2 VARCHAR(4) OUTPUT, 
	@ArtConv NUMERIC(19,6) OUTPUT,
	@ArtStock NUMERIC(11,3) OUTPUT,
	@ArtQttFor NUMERIC(11,3) OUTPUT,
	@ArtQttCli NUMERIC(11,3) OUTPUT,
	@ArtQttRec NUMERIC(11,3) OUTPUT,
	@ArtUsrQtt NUMERIC(11,3) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		@ArtUsr1 = ISNULL(usr1, ''),
		@ArtUsr2 = ISNULL(usr2, ''),
		@ArtUsr3 = ISNULL(usr3, ''),
		@ArtUsr4 = ISNULL(usr4, ''),
		@ArtUsr5 = ISNULL(usr5, ''),
		@ArtUsr6 = ISNULL(usr6, ''),
		@ArtFam = ISNULL(familia, ''),
		@ArtPCusto = ISNULL(epcusto, 0),
		@ArtCodigo = ISNULL(codigo, ''),
		@ArtForref = ISNULL(forref, ''),
		@ArtIva1Incl = ISNULL(iva1incl, 0),
		@ArtComissao = ISNULL(ecomissao, 0),
		@ArtCPoc = ISNULL(cpoc, 0),
		@ArtStns = ISNULL(stns, 0),
		@ArtLote = ISNULL(usalote, 0),
		@ArtPPond = ISNULL(epcpond, 0),
		@ArtUni2 = ISNULL(uni2, ''),
		@ArtConv = ISNULL(conversao, 0),
		@ArtStock = ISNULL(stock, ''),
		@ArtQttFor = ISNULL(qttfor, 0),
		@ArtQttCli = ISNULL(qttcli, 0),
		@ArtQttRec = ISNULL(qttrec, 0),
		@ArtUsrQtt = ISNULL(usrqtt, 0) 
	FROM st(nolock) WHERE ref = @ArtRef
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetArtPCusto
-- Ler preço de custo do artigo com base na configuração que está no documento
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetArtPCusto]
	@ArtRef VARCHAR(18),
	@DocPCusto INT,
	@ArtPCusto NUMERIC(19,6) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @epcusto NUMERIC(19,6)
	DECLARE @epcpond NUMERIC(19,6)
	DECLARE @epcult NUMERIC(19,6)

	SET @ArtPCusto = (SELECT CASE @DocPCusto WHEN 2 THEN ISNULL(epcult, 0) WHEN 3 THEN ISNULL(epcusto, 0) ELSE ISNULL(epcpond, 0) END FROM st(nolock) WHERE ref = @ArtRef)
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetCCInfo
-- Ler dados do documento na tabela de contas correntes (CC)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetCCInfo]
	@DocTipo VARCHAR(10),
	@DocNum BIGINT,
	@DocAno INT,
	@CCDesc VARCHAR(20) OUTPUT,
	@CCNrDoc BIGINT OUTPUT,
	@CCDataLc DATETIME OUTPUT,
	@CCDataVen DATETIME OUTPUT,
	@CCStamp CHAR(25) OUTPUT,
	@CCCM INT OUTPUT,
	@CCEIvaV1 NUMERIC(19,6) OUTPUT,
	@CCIvaV1 NUMERIC(18,5) OUTPUT,
	@CCEIvaV2 NUMERIC(19,6) OUTPUT,
	@CCIvaV2 NUMERIC(18,5) OUTPUT,
	@CCEIvaV3 NUMERIC(19,6) OUTPUT,
	@CCIvaV3 NUMERIC(18,5) OUTPUT,
	@CCEIvaV4 NUMERIC(19,6) OUTPUT,
	@CCIvaV4 NUMERIC(18,5) OUTPUT,
	@CCEIvaV5 NUMERIC(19,6) OUTPUT,
	@CCIvaV5 NUMERIC(18,5) OUTPUT,
	@CCEIvaV6 NUMERIC(19,6) OUTPUT,
	@CCIvaV6 NUMERIC(18,5) OUTPUT,
	@CCEIvaV7 NUMERIC(19,6) OUTPUT,
	@CCIvaV7 NUMERIC(18,5) OUTPUT,
	@CCEIvaV8 NUMERIC(19,6) OUTPUT,
	@CCIvaV8 NUMERIC(18,5) OUTPUT,
	@CCEIvaV9 NUMERIC(19,6) OUTPUT,
	@CCIvaV9 NUMERIC(18,5) OUTPUT,
	@CCIvaTx1 NUMERIC(5,2) OUTPUT,
	@CCIvaTx2 NUMERIC(5,2) OUTPUT,
	@CCIvaTx3 NUMERIC(5,2) OUTPUT,
	@CCIvaTx4 NUMERIC(5,2) OUTPUT,
	@CCIvaTx5 NUMERIC(5,2) OUTPUT,
	@CCIvaTx6 NUMERIC(5,2) OUTPUT,
	@CCIvaTx7 NUMERIC(5,2) OUTPUT,
	@CCIvaTx8 NUMERIC(5,2) OUTPUT,
	@CCIvaTx9 NUMERIC(5,2) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF ((@CCSTAMP <> '') AND (@CCSTAMP <> '0'))
	BEGIN
	SELECT 
		@CCDesc = ISNULL(cc.cmdesc, ''),
		@CCNrDoc = ISNULL(cc.nrdoc, 0),
		@CCDataLc = ISNULL(cc.datalc, 0),
		@CCDataVen = ISNULL(cc.dataven, 0),
		@CCStamp = ISNULL(cc.ccstamp, ''),
		@CCCM = ISNULL(cc.cm, 0),
		@CCEIvaV1 = ISNULL(cc.eivav1, 0),
		@CCIvaV1 = ISNULL(cc.ivav1, 0),
		@CCEIvaV2 = ISNULL(cc.eivav2, 0),
		@CCIvaV2 = ISNULL(cc.ivav2, 0),
		@CCEIvaV3 = ISNULL(cc.eivav3, 0),
		@CCIvaV3 = ISNULL(cc.ivav3, 0),
		@CCEIvaV4 = ISNULL(cc.eivav4, 0),
		@CCIvaV4 = ISNULL(cc.ivav4, 0),
		@CCEIvaV5 = ISNULL(cc.eivav5, 0),
		@CCIvaV5 = ISNULL(cc.ivav5, 0),
		@CCEIvaV6 = ISNULL(cc.eivav6, 0),
		@CCIvaV6 = ISNULL(cc.ivav6, 0),
		@CCEIvaV7 = ISNULL(cc.eivav7, 0),
		@CCIvaV7 = ISNULL(cc.ivav7, 0),
		@CCEIvaV8 = ISNULL(cc.eivav8, 0),
		@CCIvaV8 = ISNULL(cc.ivav8, 0),
		@CCEIvaV9 = ISNULL(cc.eivav9, 0),
		@CCIvaV9 = ISNULL(cc.ivav9,  0),
		@CCIvaTx1 = ISNULL(cc.ivatx1,  0),
		@CCIvaTx2 = ISNULL(cc.ivatx2,  0),
		@CCIvaTx3 = ISNULL(cc.ivatx3,  0),
		@CCIvaTx4 = ISNULL(cc.ivatx4,  0),
		@CCIvaTx5 = ISNULL(cc.ivatx5,  0),
		@CCIvaTx6 = ISNULL(cc.ivatx6,  0),
		@CCIvaTx7 = ISNULL(cc.ivatx7,  0),
		@CCIvaTx8 = ISNULL(cc.ivatx8,  0),
		@CCIvaTx9 = ISNULL(cc.ivatx9,  0)
		FROM CC(nolock)
		WHERE cc.ccstamp = @CCSTAMP
	END
	ELSE
	BEGIN
	SELECT 
		@CCDesc = ISNULL(cc.cmdesc, ''),
		@CCNrDoc = ISNULL(cc.nrdoc, 0),
		@CCDataLc = ISNULL(cc.datalc, 0),
		@CCDataVen = ISNULL(cc.dataven, 0),
		@CCStamp = ISNULL(cc.ccstamp, ''),
		@CCCM = ISNULL(cc.cm, 0),
		@CCEIvaV1 = ISNULL(cc.eivav1, 0),
		@CCIvaV1 = ISNULL(cc.ivav1, 0),
		@CCEIvaV2 = ISNULL(cc.eivav2, 0),
		@CCIvaV2 = ISNULL(cc.ivav2, 0),
		@CCEIvaV3 = ISNULL(cc.eivav3, 0),
		@CCIvaV3 = ISNULL(cc.ivav3, 0),
		@CCEIvaV4 = ISNULL(cc.eivav4, 0),
		@CCIvaV4 = ISNULL(cc.ivav4, 0),
		@CCEIvaV5 = ISNULL(cc.eivav5, 0),
		@CCIvaV5 = ISNULL(cc.ivav5, 0),
		@CCEIvaV6 = ISNULL(cc.eivav6, 0),
		@CCIvaV6 = ISNULL(cc.ivav6, 0),
		@CCEIvaV7 = ISNULL(cc.eivav7, 0),
		@CCIvaV7 = ISNULL(cc.ivav7, 0),
		@CCEIvaV8 = ISNULL(cc.eivav8, 0),
		@CCIvaV8 = ISNULL(cc.ivav8, 0),
		@CCEIvaV9 = ISNULL(cc.eivav9, 0),
		@CCIvaV9 = ISNULL(cc.ivav9,  0),
		@CCIvaTx1 = ISNULL(cc.ivatx1,  0),
		@CCIvaTx2 = ISNULL(cc.ivatx2,  0),
		@CCIvaTx3 = ISNULL(cc.ivatx3,  0),
		@CCIvaTx4 = ISNULL(cc.ivatx4,  0),
		@CCIvaTx5 = ISNULL(cc.ivatx5,  0),
		@CCIvaTx6 = ISNULL(cc.ivatx6,  0),
		@CCIvaTx7 = ISNULL(cc.ivatx7,  0),
		@CCIvaTx8 = ISNULL(cc.ivatx8,  0),
		@CCIvaTx9 = ISNULL(cc.ivatx9,  0)
		FROM CC(nolock), FT(nolock)
		WHERE cc.ftstamp = ft.ftstamp and ft.ndoc = @DocTipo AND nrdoc = @DocNum AND ftano = @DocAno
	END
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetCCInfo2
-- Ler dados do documento na tabela de contas correntes (CC)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetCCInfo2]
	@DocTipo VARCHAR(10),
	@DocNum BIGINT,
	@DocAno INT,
	@CCDesc VARCHAR(20) OUTPUT,
	@CCNrDoc BIGINT OUTPUT,
	@CCDataLc DATETIME OUTPUT,
	@CCDataVen DATETIME OUTPUT,
	@CCStamp CHAR(25) OUTPUT,
	@CCCM INT OUTPUT,
	@CCEIvaV1 NUMERIC(19,6) OUTPUT,
	@CCIvaV1 NUMERIC(18,5) OUTPUT,
	@CCEIvaV2 NUMERIC(19,6) OUTPUT,
	@CCIvaV2 NUMERIC(18,5) OUTPUT,
	@CCEIvaV3 NUMERIC(19,6) OUTPUT,
	@CCIvaV3 NUMERIC(18,5) OUTPUT,
	@CCEIvaV4 NUMERIC(19,6) OUTPUT,
	@CCIvaV4 NUMERIC(18,5) OUTPUT,
	@CCEIvaV5 NUMERIC(19,6) OUTPUT,
	@CCIvaV5 NUMERIC(18,5) OUTPUT,
	@CCEIvaV6 NUMERIC(19,6) OUTPUT,
	@CCIvaV6 NUMERIC(18,5) OUTPUT,
	@CCEIvaV7 NUMERIC(19,6) OUTPUT,
	@CCIvaV7 NUMERIC(18,5) OUTPUT,
	@CCEIvaV8 NUMERIC(19,6) OUTPUT,
	@CCIvaV8 NUMERIC(18,5) OUTPUT,
	@CCEIvaV9 NUMERIC(19,6) OUTPUT,
	@CCIvaV9 NUMERIC(18,5) OUTPUT,
	@CCIvaTx1 NUMERIC(5,2) OUTPUT,
	@CCIvaTx2 NUMERIC(5,2) OUTPUT,
	@CCIvaTx3 NUMERIC(5,2) OUTPUT,
	@CCIvaTx4 NUMERIC(5,2) OUTPUT,
	@CCIvaTx5 NUMERIC(5,2) OUTPUT,
	@CCIvaTx6 NUMERIC(5,2) OUTPUT,
	@CCIvaTx7 NUMERIC(5,2) OUTPUT,
	@CCIvaTx8 NUMERIC(5,2) OUTPUT,
	@CCIvaTx9 NUMERIC(5,2) OUTPUT,
	@fref VARCHAR(20) OUTPUT,
	@cred NUMERIC(18,5) OUTPUT,
	@datalc VARCHAR(8) OUTPUT,
	@ecred NUMERIC(19,6) OUTPUT,
	@moeda VARCHAR(11) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF ((@CCSTAMP <> '') AND (@CCSTAMP <> '0'))
	BEGIN
	SELECT 
		@CCDesc = ISNULL(cc.cmdesc, ''),
		@CCNrDoc = ISNULL(cc.nrdoc, 0),
		@CCDataLc = ISNULL(cc.datalc, 0),
		@CCDataVen = ISNULL(cc.dataven, 0),
		@CCStamp = ISNULL(cc.ccstamp, ''),
		@CCCM = ISNULL(cc.cm, 0),
		@CCEIvaV1 = ISNULL(cc.eivav1, 0),
		@CCIvaV1 = ISNULL(cc.ivav1, 0),
		@CCEIvaV2 = ISNULL(cc.eivav2, 0),
		@CCIvaV2 = ISNULL(cc.ivav2, 0),
		@CCEIvaV3 = ISNULL(cc.eivav3, 0),
		@CCIvaV3 = ISNULL(cc.ivav3, 0),
		@CCEIvaV4 = ISNULL(cc.eivav4, 0),
		@CCIvaV4 = ISNULL(cc.ivav4, 0),
		@CCEIvaV5 = ISNULL(cc.eivav5, 0),
		@CCIvaV5 = ISNULL(cc.ivav5, 0),
		@CCEIvaV6 = ISNULL(cc.eivav6, 0),
		@CCIvaV6 = ISNULL(cc.ivav6, 0),
		@CCEIvaV7 = ISNULL(cc.eivav7, 0),
		@CCIvaV7 = ISNULL(cc.ivav7, 0),
		@CCEIvaV8 = ISNULL(cc.eivav8, 0),
		@CCIvaV8 = ISNULL(cc.ivav8, 0),
		@CCEIvaV9 = ISNULL(cc.eivav9, 0),
		@CCIvaV9 = ISNULL(cc.ivav9,  0),
		@CCIvaTx1 = ISNULL(cc.ivatx1,  0),
		@CCIvaTx2 = ISNULL(cc.ivatx2,  0),
		@CCIvaTx3 = ISNULL(cc.ivatx3,  0),
		@CCIvaTx4 = ISNULL(cc.ivatx4,  0),
		@CCIvaTx5 = ISNULL(cc.ivatx5,  0),
		@CCIvaTx6 = ISNULL(cc.ivatx6,  0),
		@CCIvaTx7 = ISNULL(cc.ivatx7,  0),
		@CCIvaTx8 = ISNULL(cc.ivatx8,  0),
		@CCIvaTx9 = ISNULL(cc.ivatx9,  0),
		@fref = ISNULL(cc.fref, ''),
		@cred = ISNULL(cc.cred,  0),
		@datalc = ISNULL(cc.datalc, ''),
		@ecred = ISNULL(cc.ecred,  0),
		@moeda = ISNULL(cc.moeda, '')
		FROM CC(nolock)
		WHERE cc.ccstamp = @CCSTAMP
	END
	ELSE
	BEGIN
	SELECT 
		@CCDesc = ISNULL(cc.cmdesc, ''),
		@CCNrDoc = ISNULL(cc.nrdoc, 0),
		@CCDataLc = ISNULL(cc.datalc, 0),
		@CCDataVen = ISNULL(cc.dataven, 0),
		@CCStamp = ISNULL(cc.ccstamp, ''),
		@CCCM = ISNULL(cc.cm, 0),
		@CCEIvaV1 = ISNULL(cc.eivav1, 0),
		@CCIvaV1 = ISNULL(cc.ivav1, 0),
		@CCEIvaV2 = ISNULL(cc.eivav2, 0),
		@CCIvaV2 = ISNULL(cc.ivav2, 0),
		@CCEIvaV3 = ISNULL(cc.eivav3, 0),
		@CCIvaV3 = ISNULL(cc.ivav3, 0),
		@CCEIvaV4 = ISNULL(cc.eivav4, 0),
		@CCIvaV4 = ISNULL(cc.ivav4, 0),
		@CCEIvaV5 = ISNULL(cc.eivav5, 0),
		@CCIvaV5 = ISNULL(cc.ivav5, 0),
		@CCEIvaV6 = ISNULL(cc.eivav6, 0),
		@CCIvaV6 = ISNULL(cc.ivav6, 0),
		@CCEIvaV7 = ISNULL(cc.eivav7, 0),
		@CCIvaV7 = ISNULL(cc.ivav7, 0),
		@CCEIvaV8 = ISNULL(cc.eivav8, 0),
		@CCIvaV8 = ISNULL(cc.ivav8, 0),
		@CCEIvaV9 = ISNULL(cc.eivav9, 0),
		@CCIvaV9 = ISNULL(cc.ivav9,  0),
		@CCIvaTx1 = ISNULL(cc.ivatx1,  0),
		@CCIvaTx2 = ISNULL(cc.ivatx2,  0),
		@CCIvaTx3 = ISNULL(cc.ivatx3,  0),
		@CCIvaTx4 = ISNULL(cc.ivatx4,  0),
		@CCIvaTx5 = ISNULL(cc.ivatx5,  0),
		@CCIvaTx6 = ISNULL(cc.ivatx6,  0),
		@CCIvaTx7 = ISNULL(cc.ivatx7,  0),
		@CCIvaTx8 = ISNULL(cc.ivatx8,  0),
		@CCIvaTx9 = ISNULL(cc.ivatx9,  0),
		@fref = ISNULL(cc.fref, ''),
		@cred = ISNULL(cc.cred,  0),
		@datalc = ISNULL(cc.datalc, ''),
		@ecred = ISNULL(cc.ecred,  0),
		@moeda = ISNULL(cc.moeda, '')
		FROM CC(nolock), FT(nolock)
		WHERE cc.ftstamp = ft.ftstamp and ft.ndoc = @DocTipo AND nrdoc = @DocNum AND ftano = @DocAno
	END
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetCliInfo
-- Ler dados da ficha do cliente
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetCliInfo]
	@CliNum INT,
	@EstabNum INT,
	@CliTipo VARCHAR(20) OUTPUT,
	@CliZona VARCHAR(20) OUTPUT,
	@CliSegmento VARCHAR(25) OUTPUT,
	@CliTelef VARCHAR(60) OUTPUT,
	@CliNome VARCHAR(55) OUTPUT,
	@CliMorada VARCHAR(55) OUTPUT,
	@CliLocal VARCHAR(43) OUTPUT,
	@CliCPostal VARCHAR(45) OUTPUT,
	@CliNCont VARCHAR(18) OUTPUT,
	@CliPais INT OUTPUT,
	@CliMoeda VARCHAR(11) OUTPUT,
	@CliLocTesoura VARCHAR(50) OUTPUT,
	@CliContado INT OUTPUT,
	@fref VARCHAR(20) OUTPUT,
	@ccusto VARCHAR(20) OUTPUT,
	@TabIva INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Cont_EST INT

	if (@EstabNum > 0)
	BEGIN
		SELECT 
			@Cont_EST = count(1)
		FROM cl(nolock) WHERE no = @CliNum and estab = @EstabNum

		if @Cont_EST = 0
		BEGIN
		  SELECT 
				@CliTipo = ISNULL(tipo, ''),
				@CliZona = ISNULL(zona, ''),
				@CliSegmento = ISNULL(segmento, ''),
				@CliTelef = ISNULL(telefone, ''),
				@CliNome = ISNULL(nome, ''),
				@CliMorada = ISNULL(morada, ''),
				@CliLocal = ISNULL(local, ''),
				@CliCPostal = ISNULL(codpost, ''),
				@CliNCont = ISNULL(ncont, ''),
				@CliPais = ISNULL(pais, 0),
				@CliMoeda = ISNULL(moeda, ''),
				@CliLocTesoura = ISNULL(ollocal, ''),
				@CliContado = ISNULL(contado, 0),
				@fref = ISNULL(fref, ''),
				@ccusto = ISNULL(ccusto, ''),
				@TabIva = ISNULL(TabIva, 0)
			FROM cl(nolock) WHERE no = @CliNum and estab = 0
		END
		ELSE
		BEGIN
			SELECT 
				@CliTipo = ISNULL(tipo, ''),
				@CliZona = ISNULL(zona, ''),
				@CliSegmento = ISNULL(segmento, ''),
				@CliTelef = ISNULL(telefone, ''),
				@CliNome = ISNULL(nome, ''),
				@CliMorada = ISNULL(morada, ''),
				@CliLocal = ISNULL(local, ''),
				@CliCPostal = ISNULL(codpost, ''),
				@CliNCont = ISNULL(ncont, ''),
				@CliPais = ISNULL(pais, 0),
				@CliMoeda = ISNULL(moeda, ''),
				@CliLocTesoura = ISNULL(ollocal, ''),
				@CliContado = ISNULL(contado, 0),
				@fref = ISNULL(fref, ''),
				@ccusto = ISNULL(ccusto, ''),
				@TabIva = ISNULL(TabIva, 0)
			FROM cl(nolock) WHERE no = @CliNum and estab = @EstabNum
		END
	END
	ELSE
	BEGIN
		SELECT 
		@CliTipo = ISNULL(tipo, ''),
		@CliZona = ISNULL(zona, ''),
		@CliSegmento = ISNULL(segmento, ''),
		@CliTelef = ISNULL(telefone, ''),
		@CliNome = ISNULL(nome, ''),
		@CliMorada = ISNULL(morada, ''),
		@CliLocal = ISNULL(local, ''),
		@CliCPostal = ISNULL(codpost, ''),
		@CliNCont = ISNULL(ncont, ''),
		@CliPais = ISNULL(pais, 0),
		@CliMoeda = ISNULL(moeda, ''),
		@CliLocTesoura = ISNULL(ollocal, ''),
		@CliContado = ISNULL(contado, 0),
		@fref = ISNULL(fref, ''),
		@ccusto = ISNULL(ccusto, ''),
		@TabIva = ISNULL(TabIva, 0)
		FROM cl(nolock) WHERE no = @CliNum and estab = @EstabNum
	END
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetCliInfo2
-- Ler dados da ficha do cliente (versão MSS43 - A versão anterior devolvia os dados do cliente)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetCliInfo2]
	@CliNum INT,
	@EstabNum INT,
	@CliTipo VARCHAR(20) OUTPUT,
	@CliZona VARCHAR(20) OUTPUT,
	@CliSegmento VARCHAR(25) OUTPUT,
	@CliTelef VARCHAR(60) OUTPUT,
	@CliPais INT OUTPUT,
	@CliMoeda VARCHAR(11) OUTPUT,
	@CliLocTesoura VARCHAR(50) OUTPUT,
	@CliContado INT OUTPUT,
	@fref VARCHAR(20) OUTPUT,
	@ccusto VARCHAR(20) OUTPUT,
	@TabIva INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Cont_EST INT

	if (@EstabNum > 0)
	BEGIN
		SELECT 
			@Cont_EST = count(1)
		FROM cl(nolock) WHERE no = @CliNum and estab = @EstabNum

		if @Cont_EST = 0
		BEGIN
			SELECT 
				@CliTipo = ISNULL(tipo, ''),
				@CliZona = ISNULL(zona, ''),
				@CliSegmento = ISNULL(segmento, ''),
				@CliTelef = ISNULL(telefone, ''),
				@CliPais = ISNULL(pais, 0),
				@CliMoeda = ISNULL(moeda, ''),
				@CliLocTesoura = ISNULL(ollocal, ''),
				@CliContado = ISNULL(contado, 0),
				@fref = ISNULL(fref, ''),
				@ccusto = ISNULL(ccusto, ''),
				@TabIva = ISNULL(TabIva, 0)
			FROM cl(nolock) WHERE no = @CliNum and estab = 0
		END
		ELSE
		BEGIN
			SELECT 
				@CliTipo = ISNULL(tipo, ''),
				@CliZona = ISNULL(zona, ''),
				@CliSegmento = ISNULL(segmento, ''),
				@CliTelef = ISNULL(telefone, ''),
				@CliPais = ISNULL(pais, 0),
				@CliMoeda = ISNULL(moeda, ''),
				@CliLocTesoura = ISNULL(ollocal, ''),
				@CliContado = ISNULL(contado, 0),
				@fref = ISNULL(fref, ''),
				@ccusto = ISNULL(ccusto, ''),
				@TabIva = ISNULL(TabIva, 0)
			FROM cl(nolock) WHERE no = @CliNum and estab = @EstabNum
		END
	END
	ELSE
	BEGIN
		SELECT 
			@CliTipo = ISNULL(tipo, ''),
			@CliZona = ISNULL(zona, ''),
			@CliSegmento = ISNULL(segmento, ''),
			@CliTelef = ISNULL(telefone, ''),
			@CliPais = ISNULL(pais, 0),
			@CliMoeda = ISNULL(moeda, ''),
			@CliLocTesoura = ISNULL(ollocal, ''),
			@CliContado = ISNULL(contado, 0),
			@fref = ISNULL(fref, ''),
			@ccusto = ISNULL(ccusto, ''),
			@TabIva = ISNULL(TabIva, 0)
		FROM cl(nolock) WHERE no = @CliNum and estab = @EstabNum
	END
END

GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetCondVend
-- Ler descrição da forma de pagamento
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetCondVend]
	@CVD VARCHAR(30),
	@CondVendID CHAR(30) OUTPUT,
	@CondVendDesc VARCHAR(55) OUTPUT
AS
BEGIN
	SELECT @CondVendID = tpstamp, @CondVendDesc = descricao FROM tp(nolock) WHERE tipo = 1 AND tpstamp = @CVD 
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetDadosDoc
-- Ler dados da configuração do documento
-- A partir da versão MSS43 não necessita de configurar infosdos/infoster e infosdoc/infoster desde que no MSS a série seja o número interno do documento
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetDadosDoc]
	@VdDossier INT,
	@DocTipo VARCHAR(10),
	@DocSerie VARCHAR(10),
	@CodIntDoc INT OUTPUT,
	@DocDesc VARCHAR(24) OUTPUT,
	@DocParamFor INT OUTPUT,
	@DocParam INT OUTPUT,
	@DocPCusto INT OUTPUT,
	@lifref INT OUTPUT,
	@stocks INT OUTPUT,
	@bdemp VARCHAR(2) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @DocPCusto = 0
	SET @stocks = 0
	SET @DocDesc = null
	SET @bdemp=''

	IF @VDDOSSIER = 1 
	BEGIN
		SELECT @CodIntDoc=ndos, @DocDesc=nmdos, @DocParam=rescli, @DocParamFor=resfor, @DocPCusto=qprecocusto, @lifref = lifref, @stocks = stocks, @bdemp=bdempresas FROM ts(nolock) WHERE infosdos = @DocTipo AND infoster = @DocSerie
		IF @DocDesc IS NULL
			SELECT @CodIntDoc=ndos, @DocDesc=nmdos, @DocParam=rescli, @DocParamFor=resfor, @DocPCusto=qprecocusto, @lifref = lifref, @stocks = stocks, @bdemp=bdempresas FROM ts(nolock) WHERE ndos = @DocSerie
	END
	ELSE IF @VDDOSSIER = 2
	BEGIN
		SELECT @CodIntDoc=ndoc, @DocDesc=nmdoc, @DocParam=tipodoc, @lifref = lifref FROM td(nolock) WHERE infosdoc = @DocTipo AND infoster = @DocSerie	

		IF @DocSerie = ''
		BEGIN
			SET @DocSerie = 0
		END	

		IF @DocDesc IS NULL
			SELECT @CodIntDoc=ndoc, @DocDesc=nmdoc, @DocParam=tipodoc, @lifref = lifref FROM td(nolock) WHERE ndoc = @DocSerie	
	END
	ELSE IF @VDDOSSIER = 3
	BEGIN
		SELECT @CodIntDoc=cm, @DocDesc=cmdesc  FROM cm1(nolock) WHERE cm = @DocSerie	
	END
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetDadosRec
-- Ler dados da configuração do recibo
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetDadosRec]
	@RecSerie VARCHAR(10),
	@RecDesc VARCHAR(24) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT @RecDesc=nmdoc FROM tsre(nolock) WHERE ndoc = @RecSerie
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetDocOrigStamp
-- Ler dados do documento origem quando uma factura regulariza uma encomenda ou quando é a origem de uma nota de crédito
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetDocOrigStamp]
	@ExrDocOrig VARCHAR(30),
	@TipoDocOrig VARCHAR(10),
	@SerieDocOrig VARCHAR(10),
	@NumDocOrig INT,
	@LinDocOrig INT,
	@TipoSaft VARCHAR(10),
	@Devolucao CHAR(1),
	@TipoOrigem INT, -- 0 (TD) / 1 (TS) / 2 (CM1)
	@orilinstamp VARCHAR(25) OUTPUT,
	@oriheadstamp VARCHAR(25) OUTPUT,
	@QtdPend NUMERIC(11,3) OUTPUT,
	@orindoc INT OUTPUT
AS
BEGIN
	DECLARE @ndos INT
	DECLARE @ndoc INT
	DECLARE @boano INT
	DECLARE @ftano INT
	DECLARE @nmdos VARCHAR(24)
	DECLARE @nmdoc VARCHAR(24)
	DECLARE @tipodos INT
	DECLARE @tipodosFor INT
	DECLARE @tipoFor INT
	DECLARE @tipodoc INT
	DECLARE @tipodocFor INT
	DECLARE @olinstamp VARCHAR(25)
	DECLARE @oheadstamp VARCHAR(25)

	DECLARE @DocCount INT

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT
	DECLARE @bdemp	VARCHAR(2)

	SET NOCOUNT ON;
	BEGIN TRY
		IF ((@TipoSaft <> 'NC' AND @Devolucao <> 'S') OR (@TipoOrigem = 1))
		BEGIN
			EXECUTE SPMSS_GetDadosDoc 1, @TipoDocOrig, @SerieDocOrig, @ndos OUTPUT, @nmdos OUTPUT, @tipodosFor OUTPUT, @tipodos OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT
			SET @boano = dbo.StringToNum(@ExrDocOrig)

			SELECT @oheadstamp = bostamp FROM bo(nolock) WHERE ndos = @ndos AND obrano = @NumDocOrig AND boano = @boano
			
			SET @orindoc = @ndos
			SELECT @olinstamp = bistamp, @QtdPend = qtt-qtt2 FROM bi(nolock) WHERE ndos = @ndos AND obrano = @NumDocOrig AND lordem = @LinDocOrig AND bostamp = @oheadstamp
			
			IF @olinstamp IS NULL OR @olinstamp = ''
			BEGIN
				IF (@LinDocOrig < 1000)
					SET @LinDocOrig = @LinDocOrig*10000
				SELECT @olinstamp = bistamp, @QtdPend = qtt-qtt2 FROM bi(nolock) WHERE ndos = @ndos AND obrano = @NumDocOrig AND lordem = @LinDocOrig AND bostamp = @oheadstamp
				
			END
		END
		ELSE
		BEGIN
			EXECUTE SPMSS_GetDadosDoc 2, @TipoDocOrig, @SerieDocOrig, @ndoc OUTPUT, @nmdoc OUTPUT, @tipodocFor OUTPUT, @tipodoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT
			IF @ndoc IS NULL
			BEGIN
				SELECT @nmdoc = nmdoc FROM td WHERE ndoc = @SerieDocOrig

				IF @nmdoc IS NULL
					SET @nmdoc = ''
			END
			IF @nmdoc <> ''
			BEGIN
				SET @ftano = dbo.StringToNum(@ExrDocOrig)
				SELECT @oheadstamp = ftstamp FROM ft(nolock) WHERE ndoc = @ndoc AND fno = @NumDocOrig AND ftano = @ftano
				SET @orindoc = @ndoc
				IF (@LinDocOrig < 1000)
					SET @LinDocOrig = @LinDocOrig*10000
				SELECT @olinstamp = fistamp, @QtdPend = 0 FROM fi(nolock) WHERE ndoc = @ndoc AND fno = @NumDocOrig AND lordem = @LinDocOrig AND ftstamp = @oheadstamp
			END
			ELSE
			BEGIN
				SET @orindoc = 0
				SET @ftano = ''
				SET @oheadstamp = ''
				SET @olinstamp = ''
			END
		END

		SET @oriheadstamp = @oheadstamp
		SET @orilinstamp = @olinstamp

	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH
	
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetTabIva
-- Ler código em função de uma taxa de IVA
-- Se existir mais do que um código é devolvido X para depois na SP que chamou executar outra que procura o código nas linhas do documento para validar qual a activa
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetTabIva]
	@ValIVA NUMERIC(18,5),
	@TabCod CHAR(1) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ValStr VARCHAR(100)
	
	SET @ValStr = CAST(@ValIVA AS VARCHAR(100)) + '%'

	SELECT @TabCod = Codigo FROM TaxasIva(nolock) WHERE Taxa = @ValIVA

	IF @@ROWCOUNT > 1
		SET @TabCod = 'X'
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetTabIvaFromDoc
-- Ler código da taxa de IVA nas linhas do documento
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetTabIvaFromDoc]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@ValIVA NUMERIC(18,5),
	@TabCod CHAR(1) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CliNum VARCHAR(20)
	DECLARE @no INT
	DECLARE @estab INT
	DECLARE @EstabSeparator CHAR(1)
	DECLARE @EstabSeparatorForn CHAR(1)
	DECLARE @CliNumTemp VARCHAR(20)

	IF @ValIva > 0 
		SELECT TOP 1 @TabCod=DCLIVA FROM MSDCL WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC AND DCLTXI = @ValIva
	ELSE
		BEGIN
			SELECT @CliNum=DCCCLI FROM MSDCC (NOLOCK) WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC

			--Clientes
			IF SUBSTRING(@CliNum,1,2)<>'F.'
				BEGIN
					SET @EstabSeparator = '.'

					IF CHARINDEX(@EstabSeparator, @CliNum) > 0
						BEGIN
							SET @no = CAST(LEFT(@CliNum, CHARINDEX(@EstabSeparator, @CliNum) - 1) AS INT)
							SET @estab = CAST(RIGHT(@CliNum, LEN(@CliNum) - CHARINDEX(@EstabSeparator, @CliNum)) AS INT)
						END
					ELSE
						BEGIN
							SET @no = CAST(@CliNum AS INT)
							SET @estab = 0
						END
			     END
		    ELSE --Fornecedores
				BEGIN
					SET @EstabSeparator = '-'
					SET @CliNumTemp = @CliNum

					IF (SUBSTRING(@CliNum, 1, 2) = 'F.')
						SET @CliNumTemp = SUBSTRING(@CliNum, 3, LEN(@CliNum) - 2) 

					IF CHARINDEX(@EstabSeparator, @CliNumTemp) > 0
						BEGIN
							SET @no = CAST(LEFT(@CliNumTemp, CHARINDEX(@EstabSeparator, @CliNumTemp) - 1) AS INT)
							SET @estab = CAST(RIGHT(@CliNumTemp, LEN(@CliNumTemp) - CHARINDEX(@EstabSeparator, @CliNumTemp)) AS INT)
						END
					ELSE
						BEGIN
							SET @no = CAST(@CliNum AS INT)
							SET @estab = 0
						END
				END

			--Clientes
			IF SUBSTRING(@CliNum,1,2)<>'F.'
			BEGIN
				--Validar se o cliente ou fornecedor é isento, verificando se o motivo de isenção está preenchido, se estiver irá-se passar o código do iva do cliente, caso contrário, passa-se o código de iva da linha do documento
				SELECT @TabCod=(CASE WHEN CL.CodMotiseimp = '' THEN (SELECT TOP 1 DCLIVA FROM MSDCL (NOLOCK) WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC AND DCLTXI = @ValIva) ELSE CL.TabIVA END) FROM CL (NOLOCK) WHERE CL.no = @no AND CL.estab=@estab
			END
			ELSE --Fornecedores
			BEGIN
				--Validar se o cliente ou fornecedor é isento, verificando se o motivo de isenção está preenchido, se estiver irá-se passar o código do iva do cliente, caso contrário, passa-se o código de iva da linha do documento
				SELECT @TabCod=(CASE WHEN FL.CodMotiseimp = '' THEN (SELECT TOP 1 DCLIVA FROM MSDCL (NOLOCK) WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC AND DCLTXI = @ValIva) ELSE FL.TabIVA END) FROM FL (NOLOCK) WHERE FL.no = @no AND FL.estab=@estab
			END
		END
END
GO
-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetTaxaIva
-- Ler taxa de IVA com base no código
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetTaxaIva]
	@TabIVA INT,
	@TaxaIVA NUMERIC(18,5) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT @TaxaIVA = taxa FROM taxasiva(nolock) WHERE codigo = @TabIVA
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetCorTamanho
-- Vai buscar a cor e o tamanho no caso de ser uma referencia com cor e tamanho
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetCorTamanho]
	@DCL VARCHAR(2000),
	@r varchar(60) OUTPUT,
	@c varchar(25) OUTPUT,
	@t varchar(25) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @r = dbo.ExtractFromACL(@DCL, 16)
	SET @c = dbo.ExtractFromACL(@DCL, 18)
	SET @t = dbo.ExtractFromACL(@DCL, 20)
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetVendNome
-- Ler nome do vendedor
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetVendNome]
	@VendNum INT,
	@VendNome VARCHAR(40) OUTPUT
AS
BEGIN
	SELECT @VendNome = cmdesc FROM cm3(nolock) WHERE cm = @VendNum
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ClientesUSR
-- Personalizações na integração de clientes
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ClientesUSR] 
	@CLICOD VARCHAR(20),	-- Código do cliente no MSS
	@no INT,				-- Código do cliente no PHC
	@estab INT				-- Código do estabelecimento no PHC
AS
BEGIN
	SET NOCOUNT ON;


END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Clientes
-- Integração de clientes
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_Clientes]
	@EstabSeparator CHAR(1),
	@Moeda VARCHAR(11)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @CliNumTmp VARCHAR(20)
	DECLARE @CondVendTmp VARCHAR(30)
	DECLARE @clstampTmp CHAR(25)
	DECLARE @CliTerminal VARCHAR(5)

	DECLARE @clstamp CHAR(25)
	DECLARE @clino INT
	DECLARE @nome VARCHAR(55)
	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @ncont VARCHAR(18)
	DECLARE @eplafond NUMERIC(19,6)
	DECLARE @esaldo NUMERIC(16,2)
	DECLARE @preco INT
	DECLARE @telefone VARCHAR(60)
	DECLARE @tlmvl VARCHAR(45)
	DECLARE @fax VARCHAR(60)
	DECLARE @c2tacto VARCHAR(30)
	DECLARE @contacto VARCHAR(30)
	DECLARE @c3tacto VARCHAR(30)
	DECLARE @email VARCHAR(45)
	DECLARE @obs VARCHAR(240)
	DECLARE @desconto NUMERIC(6,2)
	DECLARE @descpp NUMERIC(6,2)
	DECLARE @nome2 VARCHAR(55)
	DECLARE @tipodesc VARCHAR(20)
	DECLARE @nib VARCHAR(28)
	DECLARE @vendedor INT
	DECLARE @vendnm VARCHAR(20)
	DECLARE @estab INT
	DECLARE @pais INT
	DECLARE @tpstamp CHAR(25)
	DECLARE @tpdesc VARCHAR(55)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @descregiva VARCHAR(60)
	DECLARE @pncont VARCHAR(2)
	DECLARE @CliAcl VARCHAR(2000)
	DECLARE @CliEnd VARCHAR(256)
	DECLARE @CliPais VARCHAR(60)
	DECLARE @Contado INT
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	SET @Pais = 1

    DECLARE curClientes CURSOR FOR 
	SELECT 
		ISNULL(CLICOD, ''), -- código
		ISNULL(CLINOM, ''), -- nome
		ISNULL(CLIMOR, ''), -- morada
		ISNULL(CLILOC, ''), -- local
		ISNULL(CLICPT, ''), -- cod postal
		ISNULL(CLINCT, ''), -- contribuinte
		ISNULL(CLIPLA, 0), -- plafond
		ISNULL(CLIRES, 0), -- responsabilidade
		ISNULL(CLIPRC, 0), -- escalão preço
		ISNULL(CLITEL, ''), -- telefone
		ISNULL(CLITLM, ''), -- telemovel
		ISNULL(CLIFAX, ''), -- fax
		'', -- contacto fin
		'', -- contacto com
		'', -- contacto oper
		ISNULL(CLIEML, ''), -- email
		ISNULL(CLIOBS, ''), -- obs
		ISNULL(CLITDC, 0), -- taxa desconto
		ISNULL(CLIDPP, 0), -- desconto pp
		ISNULL(CLINM2, ''), -- nome 2
		ISNULL(CLICT1, ''), -- categoria
		ISNULL(CLINIB, ''), -- nib
		ISNULL(CLIVND, ''), -- vendedor
		ISNULL(CLICVD, ''), -- condição de venda
		ISNULL(CLITERM, 0),  -- terminal
		ISNULL(CLIIVA, ''),	-- regime de IVA
		ISNULL(CLIPAI, ''),  -- país
		ISNULL(CLIACL, '')
	FROM MSCLI(nolock) WHERE CLISYNCR = 'N' AND (CLITIP = 'C' OR CLITIP = 'c')

	OPEN curClientes

		FETCH NEXT FROM curClientes INTO @CliNumTmp, @nome, @morada, @local, @codpost, @ncont, @eplafond, @esaldo, @preco, @telefone, @tlmvl, @fax, @c2tacto, @contacto, @c3tacto, @email, @obs, @desconto, @descpp, @nome2, @tipodesc, @nib, @vendedor, @CondVendTmp, @CliTerminal, @descregiva, @pncont, @CliAcl
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
-- verificar se ? um registo com estabelecimento			
				SET @clstampTmp = null
				IF CHARINDEX(@EstabSeparator, @CliNumTmp) > 0
				BEGIN
					SET @clino = CAST(LEFT(@CliNumTmp, CHARINDEX(@EstabSeparator, @CliNumTmp) - 1) AS INT)
					SET @estab = CAST(RIGHT(@CliNumTmp, LEN(@CliNumTmp) - CHARINDEX(@EstabSeparator, @CliNumTmp)) AS INT)
				END
				ELSE
				BEGIN
					SET @clino = CAST(@CliNumTmp AS INT)
					SET @estab = 0
				END

				EXECUTE SPMSS_GetCondVend @CondVendTmp, @tpstamp OUTPUT, @tpdesc OUTPUT
				if @tpstamp is null
                    set @tpstamp = ''

				if @tpdesc is null
					set @tpdesc = ''

				SET @Contado = 0
					
				EXECUTE SPMSS_GetVendNome @vendedor, @vendnm OUTPUT

				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @clstamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@CliTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@CliTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				EXECUTE SPMSS_CheckCliente @clino, @estab, @clstampTmp OUTPUT

				IF dbo.ExtractFromACL(@CliAcl, 12) <> ''
					SET @CliEnd = dbo.ExtractFromACL(@CliAcl, 12)
				ELSE
					SET @CliEnd = ''

				IF @clstampTmp is null
				BEGIN
					INSERT INTO cl(clstamp,no,nome,morada,local,codpost,ncont,eplafond,esaldo,preco,telefone,tlmvl,fax,c2tacto,contacto,c3tacto,email,obs,desconto,descpp,nome2,tipodesc,nib,vendedor,vendnm,estab,moeda,pais,tpstamp,tpdesc,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,descregiva,pncont,contado,url) 
					VALUES (@clstamp,@clino,@nome,@morada,@local,@codpost,@ncont,@eplafond,@esaldo,@preco,@telefone,@tlmvl,@fax,@c2tacto,@contacto,@c3tacto,@email,@obs,@desconto,@descpp,@nome2,@tipodesc,@nib,@vendedor,@vendnm,@estab,@moeda,@pais,@tpstamp,@tpdesc,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,@descregiva,@pncont,@contado, @CliEnd)
					
					SELECT @CliPais=NOME FROM PAISES WHERE NOMEABRV=@pncont

					INSERT INTO cl2(cl2stamp,codpais,descpais,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,estabmod)
					VALUES (@clstamp,@pncont,@CliPais,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,@estab)
					
					IF @@ERROR = 0 
						UPDATE MSCLI SET CLISYNCR = 'S' WHERE CLICOD = @CliNumTmp
				END
				ELSE
				BEGIN
					UPDATE cl SET
						nome = @nome,
						morada = @morada,
						local = @local,
						codpost = @codpost,
						ncont = @ncont,
						eplafond = @eplafond,
						esaldo = @esaldo,
						preco = @preco,
						telefone = @telefone,
						tlmvl = @tlmvl,
						fax = @fax,
						c2tacto = @c2tacto,
						contacto = @contacto,
						c3tacto = @c3tacto,
						email = @email,
						obs = @obs,
						desconto = @desconto,
						descpp = @descpp,
						nome2 = @nome2,
						tipodesc = @tipodesc,
						nib = @nib,
						/*vendedor = @vendedor,
						vendnm = @vendnm,*/
						moeda = @moeda,
						pais = @pais,
						tpstamp = @tpstamp,
						tpdesc = @tpdesc,
						usrinis = @usrinis,
						usrdata = @usrdata,
						usrhora = @usrhora,
						descregiva = @descregiva,
						pncont = @pncont,
						contado=@contado,
						url=@CliEnd
					WHERE clstamp = @clstampTmp

					SELECT @CliPais=NOME FROM PAISES WHERE NOMEABRV=@pncont

					UPDATE cl2 SET codpais = @pncont, descpais = @CliPais, usrinis = @usrinis, usrdata = @usrdata, usrhora = @usrhora WHERE cl2stamp = @clstampTmp

					IF @@ERROR = 0 
						UPDATE MSCLI SET CLISYNCR = 'S' WHERE CLICOD = @CliNumTmp
				END
				
				EXECUTE SPMSS_ClientesUSR @CliNumTmp, @clino, @estab
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curClientes INTO @CliNumTmp, @nome, @morada, @local, @codpost, @ncont, @eplafond, @esaldo, @preco, @telefone, @tlmvl, @fax, @c2tacto, @contacto, @c3tacto, @email, @obs, @desconto, @descpp, @nome2, @tipodesc, @nib, @vendedor, @CondVendTmp, @CliTerminal, @descregiva, @pncont, @CliAcl
		END
	FIM:
		CLOSE curClientes
		DEALLOCATE curClientes	
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Estabelecimentos
-- Integração de estabelecimentos
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_Estabelecimentos]
	@EstabSeparator CHAR(1),
	@Moeda VARCHAR(11)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @CliNumTmp VARCHAR(20)
	DECLARE @CondVendTmp VARCHAR(30)
	DECLARE @clstampTmp CHAR(25)
	DECLARE @estabstampTmp CHAR(25)
	DECLARE @CliTerminal VARCHAR(5)

	DECLARE @LCECOD INT
	DECLARE @LCELCE VARCHAR(20)
	DECLARE @LCENOM VARCHAR(60)
	DECLARE @LCEMOR VARCHAR(60)
	DECLARE @LCELOC VARCHAR(60)
	DECLARE @LCECPT VARCHAR(60)
	DECLARE @LCECTC VARCHAR(60)
	DECLARE @LCETEL VARCHAR(20)
	DECLARE @LCEOBS VARCHAR(500)
	DECLARE @LCEDSC VARCHAR(100)
	DECLARE @LCEPAI VARCHAR(50)

	DECLARE @clstamp CHAR(25)
	DECLARE @clino INT
	DECLARE @nome VARCHAR(55)
	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @ncont VARCHAR(18)
	DECLARE @eplafond NUMERIC(19,6)
	DECLARE @esaldo NUMERIC(16,2)
	DECLARE @preco INT
	DECLARE @telefone VARCHAR(60)
	DECLARE @tlmvl VARCHAR(45)
	DECLARE @fax VARCHAR(60)
	DECLARE @c2tacto VARCHAR(30)
	DECLARE @contacto VARCHAR(30)
	DECLARE @c3tacto VARCHAR(30)
	DECLARE @email VARCHAR(45)
	DECLARE @obs VARCHAR(240)
	DECLARE @desconto NUMERIC(6,2)
	DECLARE @descpp NUMERIC(6,2)
	DECLARE @nome2 VARCHAR(55)
	DECLARE @tipodesc VARCHAR(20)
	DECLARE @nib VARCHAR(28)
	DECLARE @vendedor INT
	DECLARE @vendnm VARCHAR(20)
	DECLARE @estab INT
	DECLARE @pais INT
	DECLARE @tpstamp CHAR(25)
	DECLARE @tpdesc VARCHAR(55)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @descregiva VARCHAR(60)
	DECLARE @pncont VARCHAR(2)
	DECLARE @Contado INT

	DECLARE @DescPais VARCHAR(60)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	SET @Pais = 1

    DECLARE curEstabelecimentos CURSOR FOR 
	SELECT 
			ISNULL(LCECOD, ''),
			ISNULL(LCELCE, ''),
			ISNULL(LCENOM, ''),
			ISNULL(LCEMOR, ''),
			ISNULL(LCELOC, ''),
			ISNULL(LCECPT, ''),
			ISNULL(LCECTC, ''),
			ISNULL(LCETEL, ''),
			ISNULL(LCEOBS, ''),
			ISNULL(LCEDSC, ''),
			ISNULL(LCEPAI, '')
	FROM MSLCE(nolock) WHERE LCESYNCR = 'N'

	OPEN curEstabelecimentos

		FETCH NEXT FROM curEstabelecimentos INTO @CliNumTmp, @LCELCE, @LCENOM, @LCEMOR, @LCELOC, @LCECPT, @LCECTC, @LCETEL, @LCEOBS, @LCEDSC, @LCEPAI
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				IF CHARINDEX(@EstabSeparator, @CliNumTmp) > 0
					SET @LCECOD = CAST(LEFT(@CliNumTmp, CHARINDEX(@EstabSeparator, @CliNumTmp) - 1) AS INT)
				ELSE
					SET @LCECOD = CAST(@CliNumTmp AS INT)
				
				EXECUTE SPMSS_GetCondVend @LCECOD, @tpstamp OUTPUT, @tpdesc OUTPUT
				if @tpstamp is null
                    set @tpstamp = ''

				if @tpdesc is null
					set @tpdesc = ''

				SET @Contado = 0

				-- DADOS DO CLIENTE SEDE
				SET @clstampTmp = ''
				EXECUTE SPMSS_CheckCliente @LCECOD, 0, @clstampTmp OUTPUT
				IF ((@clstampTmp IS NOT NULL) AND (@clstampTmp <> ''))
				BEGIN
					SELECT @nome = nome,
						@morada=morada,
						@local=local,
						@codpost=codpost,
						@ncont = ncont,
						@eplafond=eplafond,
						@esaldo=esaldo,
						@preco=preco,
						@telefone=telefone,
						@tlmvl=tlmvl,
						@fax=fax,
						@c2tacto=c2tacto,
						@contacto=contacto,
						@c3tacto=c3tacto,
						@email=email,
						@obs=obs,
						@desconto=desconto,
						@descpp=descpp,
						@nome2=nome2,
						@tipodesc=tipodesc,
						@nib=nib,
						@vendedor=vendedor,
						@vendnm=vendnm,
						@moeda=moeda,
						@pais=pais,
						@tpstamp=tpstamp,
						@tpdesc=tpdesc,
						@usrinis=usrinis,
						@usrdata=usrdata,
						@usrhora=usrhora,
						@descregiva=descregiva,
						@pncont=pncont,
						@contado=contado
					FROM cl (NOLOCK) WHERE clstamp = @clstampTmp

					SET @estabstampTmp = ''
					-- VERIFICA SE A MORADA JÁ EXISTE COMO ESTABELICIMENTO
					EXECUTE SPMSS_CheckCliente @LCECOD, @LCELCE, @estabstampTmp OUTPUT
					IF ((@estabstampTmp IS NULL) OR (@estabstampTmp = '')) -- ESTABELICIMENTO NÃO EXISTE
					BEGIN

							WAITFOR DELAY '00:00:00.200' 
							SET @DateTimeTmp = GETDATE()
							SET @DateStr = dbo.DateToString(@DateTimeTmp)
							SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
							SET @clstamp = 'MSS_' + @DateStr + @TimeStr

							SET @ousrinis = 'MSS T-' + CAST(@LCECOD AS VARCHAR(3))
							SET @usrinis = 'MSS T-' + CAST(@LCECOD AS VARCHAR(3))

							SET @ousrdata = @DateStr
							SET @usrdata = @DateStr

							SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
							SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

							INSERT INTO cl(clstamp,no,nome,morada,local,codpost,ncont,eplafond,esaldo,preco,telefone,tlmvl,fax,c2tacto,contacto,c3tacto,email,obs,desconto,descpp,nome2,tipodesc,nib,vendedor,vendnm,estab,moeda,pais,tpstamp,tpdesc,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,descregiva,pncont,contado) 
							VALUES (@clstamp,@LCECOD,@LCENOM,@LCEMOR,@LCELOC,@LCECPT,@ncont,@eplafond,@esaldo,@preco,@LCETEL,@tlmvl,@fax,@c2tacto,@LCECTC,@c3tacto,@email,@LCEOBS,@desconto,@descpp,@nome2,@tipodesc,@nib,@vendedor,@vendnm,@LCELCE,@moeda,@pais,@tpstamp,@tpdesc,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,@descregiva,@LCEPAI,@contado)

							SELECT @DescPais=NOME FROM PAISES WHERE NOMEABRV=@LCEPAI

							INSERT INTO cl2(cl2stamp,codpais,descpais,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,estabmod)
							VALUES (@clstamp,@LCEPAI,@DescPais,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0)

					END
					ELSE
					BEGIN
						UPDATE cl SET
							nome = @LCENOM,
							morada = @LCEMOR,
							local = @LCELOC,
							codpost = @LCECPT,
							telefone = @LCETEL,
							contacto = @LCECTC,
							obs = @LCEOBS,
							pncont = @LCEPAI
						WHERE clstamp = @estabstampTmp
					END

				END

				IF @@ERROR = 0
					UPDATE MSLCE SET LCESYNCR = 'S' WHERE LCECOD = @CliNumTmp AND LCELCE = @LCELCE
								
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curEstabelecimentos INTO @CliNumTmp, @LCELCE, @LCENOM, @LCEMOR, @LCELOC, @LCECPT, @LCECTC, @LCETEL, @LCEOBS, @LCEDSC, @LCEPAI
		END
	FIM:
		CLOSE curEstabelecimentos
		DEALLOCATE curEstabelecimentos	
END
GO
-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocECOVal
-- Processamento de ecovalores (Embalagens) dossiers internos/faturas (linhas que tenham ecovalores)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocECOVal]
	@ref VARCHAR(60),
	@bistamp VARCHAR(25),
	@bostamp VARCHAR(25),
	@DocTerminal VARCHAR(5),
	@DocFlag INT --0 Dossier Interno, 1 Faturas
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @material CHAR(50)
		DECLARE @pesoeco NUMERIC (19,6)
		DECLARE @evalkg NUMERIC (19,6)
		DECLARE @valkg NUMERIC (19,6)
		DECLARE @ecoval NUMERIC (19,6)
		DECLARE @eecoval NUMERIC (19,6)
		DECLARE @ecoetstamp CHAR(50)
		DECLARE @BOECOSTAMP CHAR(25)
		DECLARE @TIPO VARCHAR(20)
		DECLARE @etecoval NUMERIC (19,6)
		DECLARE @DateStr CHAR(8)
		DECLARE @TimeStr CHAR(11)
		DECLARE @DateTimeTmp DATETIME
		DECLARE @ousrinis VARCHAR(30)
		DECLARE @ousrdata DATETIME
		DECLARE @ousrhora VARCHAR(8)
		DECLARE @usrinis VARCHAR(30)
		DECLARE @usrdata DATETIME
		DECLARE @usrhora VARCHAR(8)
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

	DECLARE curECO CURSOR FOR
		SELECT 
			ISNULL(MATERIAL, ''),
			ISNULL(PESO,0),
			ISNULL(EVALKG,0),
			ISNULL(VALKG,0),
			ISNULL(ECOETSTAMP,''),
			ISNULL(EECOVAL,''),
			ISNULL(ECOVAL,'')
		FROM ECOE 
		WHERE REF=@ref

	OPEN curECO

		FETCH NEXT FROM curECO INTO @material, @pesoeco, @evalkg, @valkg, @ecoetstamp, @eecoval, @ecoval

			WHILE @@FETCH_STATUS = 0 BEGIN
			    BEGIN TRY
					WAITFOR DELAY '00:00:00.200' 
					SET @DateTimeTmp = GETDATE()
				
					SET @DateStr = dbo.DateToString(@DateTimeTmp)
					SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
					SET @bistamp = 'MSS_' + @DateStr + @TimeStr
					SET @boecostamp = 'MSS' + @DateStr + @TimeStr

					SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
					SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

					SET @ousrdata = @DateStr
					SET @usrdata = @DateStr

					SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
					SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

					SET @TIPO = 'Embalagens'

					IF @DocFlag = 0 --DOSSIER INTERNOS
					BEGIN
						INSERT INTO BOECO (boecostamp, tipo, qtt, material, peso, adival, evalkg, valkg, eecoval, ecoval, ecoetstamp, bostamp, bistamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
						VALUES(@boecostamp, @TIPO, 0, @material, @pesoeco, 1, @evalkg, @valkg, @eecoval, @ecoval, @ecoetstamp, @bostamp, @bistamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
					END
					ELSE IF @DocFlag = 1 -- FATURAS
					BEGIN 
						INSERT INTO FTECO (ftecostamp, tipo, qtt, material, peso, adival, evalkg, valkg, eecoval, ecoval, ecoetstamp, ftstamp, fistamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
						VALUES (@boecostamp,@TIPO, 0, @material, @pesoeco, 1, @evalkg, @valkg, @eecoval, @ecoval, @ecoetstamp, @bostamp, @bistamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
					END
			
			FETCH NEXT FROM curECO INTO @material, @pesoeco, @evalkg, @valkg, @ecoetstamp, @eecoval, @ecoval

				END TRY
				BEGIN CATCH
					SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()				
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
					GOTO FIM
				END CATCH
		END
	FIM:
		CLOSE curECO
		DEALLOCATE curECO
END
GO
-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocECOValO
-- Processamento de ecovalores (Outros/REEE) dossiers internos/faturas (linhas que tenham ecovalores)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocECOValO]
	@ref VARCHAR(60),
	@bistamp VARCHAR(25),
	@bostamp VARCHAR(25),
	@DocTerminal VARCHAR(5),
	@DocFlag INT --0 Dossier Interno, 1 Faturas
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @eecorval NUMERIC (19,6)
		DECLARE @eecooval NUMERIC (19,6)
		DECLARE @ecorval NUMERIC (19,6)
		DECLARE @ecooval NUMERIC (19,6)
		DECLARE @pilha CHAR(25)
		DECLARE @designp CHAR(40)
		DECLARE @qtt NUMERIC (19,6)
		DECLARE @evalpu NUMERIC (19,6)
		DECLARE @valpu NUMERIC (19,6)
		DECLARE @evalkg NUMERIC (19,6)
		DECLARE @valkg NUMERIC (19,6)
		DECLARE @eecoval NUMERIC (19,6)
		DECLARE @ecoval NUMERIC (19,6)
		DECLARE @ecoptstamp CHAR(50)
		DECLARE @ecoptpstamp CHAR(50)
		DECLARE @BOECOSTAMP CHAR(25)
		DECLARE @TIPO VARCHAR(20)
		DECLARE @DateStr CHAR(8)
		DECLARE @TimeStr CHAR(11)
		DECLARE @DateTimeTmp DATETIME
		DECLARE @ousrinis VARCHAR(30)
		DECLARE @ousrdata DATETIME
		DECLARE @ousrhora VARCHAR(8)
		DECLARE @usrinis VARCHAR(30)
		DECLARE @usrdata DATETIME
		DECLARE @usrhora VARCHAR(8)
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

	
	    BEGIN TRY
			SELECT @eecorval=EECORVAL, @eecooval=EECOOVAL, @ecorval=ECORVAL, @ecooval=ECOOVAL FROM ST WHERE REF=@ref

			SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
			SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

			/*ECOVALOR REEE*/
			IF @eecorval > 0
			BEGIN
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @bistamp = 'MSS_' + @DateStr + @TimeStr
				SET @boecostamp = 'MSS' + @DateStr + @TimeStr

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				SET @TIPO = 'REEE'

				IF @DocFlag = 0 --DOSSIER INTERNOS
				BEGIN
					INSERT INTO BOECO (boecostamp, tipo,eecoval, ecoval, bostamp, bistamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
					VALUES(@boecostamp, @tipo, @eecorval, @ecorval, @bostamp, @bistamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
				END
				ELSE IF @DocFlag = 1 -- Faturas
				BEGIN
					INSERT INTO FTECO (ftecostamp, tipo,eecoval, ecoval, FTstamp, fistamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
					VALUES(@boecostamp, @tipo, @eecorval, @ecorval, @bostamp, @bistamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
				END
			END

			/*ECOVALOR OUTROS*/
			IF @eecooval > 0
			BEGIN
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @bistamp = 'MSS_' + @DateStr + @TimeStr
				SET @boecostamp = 'MSS' + @DateStr + @TimeStr

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				SET @TIPO = 'Outro'

				IF @DocFlag = 0 --DOSSIER INTERNOS
				BEGIN
					INSERT INTO BOECO (boecostamp, tipo,eecoval, ecoval, bostamp, bistamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
					VALUES(@boecostamp, @tipo, @eecooval, @ecooval, @bostamp, @bistamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
				END
				ELSE IF @DocFlag = 1 --Faturas
				BEGIN
					INSERT INTO FTECO (ftecostamp, tipo,eecoval, ecoval, ftstamp, fistamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
					VALUES(@boecostamp, @tipo, @eecooval, @ecooval, @bostamp, @bistamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
				END
			END

		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()				
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		END CATCH
END
GO
-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocECOValP
-- Processamento de ecovalores (Pilhas/Acumuladores) dossiers internos (linhas que tenham ecovalores)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocECOValP]
	@ref VARCHAR(60),
	@bistamp VARCHAR(25),
	@bostamp VARCHAR(25),
	@DocTerminal VARCHAR(5),
	@DocFlag INT --0 Dossier Interno, 1 Faturas
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @pilha CHAR(25)
		DECLARE @designp CHAR(40)
		DECLARE @qtt NUMERIC (19,6)
		DECLARE @evalpu NUMERIC (19,6)
		DECLARE @valpu NUMERIC (19,6)
		DECLARE @evalkg NUMERIC (19,6)
		DECLARE @valkg NUMERIC (19,6)
		DECLARE @eecoval NUMERIC (19,6)
		DECLARE @ecoval NUMERIC (19,6)
		DECLARE @ecoptstamp CHAR(50)
		DECLARE @ecoptpstamp CHAR(50)
		DECLARE @BOECOSTAMP CHAR(25)
		DECLARE @TIPO VARCHAR(20)
		DECLARE @DateStr CHAR(8)
		DECLARE @TimeStr CHAR(11)
		DECLARE @DateTimeTmp DATETIME
		DECLARE @ousrinis VARCHAR(30)
		DECLARE @ousrdata DATETIME
		DECLARE @ousrhora VARCHAR(8)
		DECLARE @usrinis VARCHAR(30)
		DECLARE @usrdata DATETIME
		DECLARE @usrhora VARCHAR(8)
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @ErrorSeverity INT
		DECLARE @ErrorState INT

	DECLARE curECO CURSOR FOR
		SELECT 
			ISNULL(PILHA, ''),
			ISNULL(DESIGNP, ''),
			ISNULL(QTT, 0),
			ISNULL(EVALPU, 0),
			ISNULL(VALPU, 0),
			ISNULL(EVALKG, 0),
			ISNULL(VALKG, 0),
			ISNULL(EECOVAL, 0),
			ISNULL(ECOVAL, 0),
			ISNULL(ECOPTSTAMP,''),
			ISNULL(ECOPTPSTAMP,'')
		FROM ECOP 
		WHERE REF=@ref

	OPEN curECO

		FETCH NEXT FROM curECO INTO @pilha, @designp, @qtt, @evalpu, @valpu, @evalkg, @valkg, @eecoval, @ecoval, @ecoptstamp, @ecoptpstamp

			WHILE @@FETCH_STATUS = 0 BEGIN
			    BEGIN TRY
					WAITFOR DELAY '00:00:00.200' 
					SET @DateTimeTmp = GETDATE()
				
					SET @DateStr = dbo.DateToString(@DateTimeTmp)
					SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
					SET @bistamp = 'MSS_' + @DateStr + @TimeStr
					SET @boecostamp = 'MSS' + @DateStr + @TimeStr

					SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
					SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

					SET @ousrdata = @DateStr
					SET @usrdata = @DateStr

					SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
					SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

					SET @TIPO = 'Pilhas/Acumuladores'

					IF @DocFlag = 0 --Dossier Internos
					BEGIN
						INSERT INTO BOECO (boecostamp, tipo, pilha, qtt, designp, adival, evalpu, valpu, evalkg, valkg, eecoval, ecoval, ecoptstamp, ecoptpstamp, bostamp, bistamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
						VALUES(@boecostamp, @tipo, @pilha, @qtt, @designp, 1, @evalpu, @valpu, @evalkg, @valkg, @eecoval, @ecoval, @ecoptstamp, @ecoptpstamp, @bostamp, @bistamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
					END
					ELSE IF @DocFlag = 1 --Faturas
					BEGIN
						INSERT INTO FTECO (ftecostamp, tipo, pilha, qtt, designp, adival, evalpu, valpu, evalkg, valkg, eecoval, ecoval, ecoptstamp, ecoptpstamp, ftstamp, fistamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora)
						VALUES(@boecostamp, @tipo, @pilha, @qtt, @designp, 1, @evalpu, @valpu, @evalkg, @valkg, @eecoval, @ecoval, @ecoptstamp, @ecoptpstamp, @bostamp, @bistamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
					END
			FETCH NEXT FROM curECO INTO @pilha, @designp, @qtt, @evalpu, @valpu, @evalkg, @valkg, @eecoval, @ecoval, @ecoptstamp, @ecoptpstamp

				END TRY
				BEGIN CATCH
					SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()				
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
					GOTO FIM
				END CATCH
		END
	FIM:
		CLOSE curECO
		DEALLOCATE curECO
END
GO
-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDossInternValIVAs
-- Ligação dos campos com as bases e valores de IVA do MSS aos do cabeçalho de dossiers internos do PHC baseado na tabela de taxas de IVA para se fazer a validação
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDossInternValIVAs]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@bostamp CHAR(25),
	@ValidateDocTotals NUMERIC(19,6),
	@Mensagem VARCHAR(200) OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @botstamp CHAR(25)
	DECLARE @CodTabIva CHAR(1)
	DECLARE @DocTax1 NUMERIC(6,2)
	DECLARE @DocTaxBIns1 NUMERIC(19,6)
	DECLARE @DocTaxVal1 NUMERIC(19,6)
	DECLARE @DocTax2 NUMERIC(6,2)
	DECLARE @DocTaxBIns2 NUMERIC(19,6)
	DECLARE @DocTaxVal2 NUMERIC(19,6)
	DECLARE @DocTax3 NUMERIC(6,2)
	DECLARE @DocTaxBIns3 NUMERIC(19,6)
	DECLARE @DocTaxVal3 NUMERIC(19,6)
	DECLARE @DocTax4 NUMERIC(6,2)
	DECLARE @DocTaxBIns4 NUMERIC(19,6)
	DECLARE @DocTaxVal4 NUMERIC(19,6)

	DECLARE @ebo12_bins NUMERIC(19,6)
	DECLARE @ebo12_iva NUMERIC(19,6)
	DECLARE @ebo22_bins NUMERIC(19,6)
	DECLARE @ebo22_iva NUMERIC(19,6)
	DECLARE @ebo32_bins NUMERIC(19,6)
	DECLARE @ebo32_iva NUMERIC(19,6)
	DECLARE @ebo42_bins NUMERIC(19,6)
	DECLARE @ebo42_iva NUMERIC(19,6)
	DECLARE @ebo52_bins NUMERIC(19,6)
	DECLARE @ebo52_iva NUMERIC(19,6)
	DECLARE @ebo62_bins NUMERIC(19,6)
	DECLARE @ebo62_iva NUMERIC(19,6)
	
	DECLARE @DifIncidencia NUMERIC(19,6)
	DECLARE @DifIva NUMERIC(19,6)
	DECLARE @DOC VARCHAR(80)

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	SELECT 
		@DocTax1 = ISNULL(DCCTX1, 0),
		@DocTaxBIns1 = ISNULL(DCCBI1, 0),
		@DocTaxVal1 = ISNULL(DCCVI1, 0),
		@DocTax2 = ISNULL(DCCTX2, 0),
		@DocTaxBIns2 = ISNULL(DCCBI2, 0),
		@DocTaxVal2 = ISNULL(DCCVI2, 0),
		@DocTax3 = ISNULL(DCCTX3, 0),
		@DocTaxBIns3 = ISNULL(DCCBI3, 0),
		@DocTaxVal3 = ISNULL(DCCVI3, 0),
		@DocTax4 = ISNULL(DCCTX4, 0),
		@DocTaxBIns4 = ISNULL(DCCBI4, 0),
		@DocTaxVal4 = ISNULL(DCCVI4, 0)
	FROM MSDCC(nolock)
	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC

	SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' BOSTAMP = ' + @bostamp
	SET @Mensagem=''

	IF @DocTaxBIns1 > 0  -- quando a base de incidência 1 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax1, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax1, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SELECT @ebo12_bins = ebo12_bins, @ebo12_iva = ebo12_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - @ebo12_bins)
			SET @DifIva = ABS(@DocTaxVal1 - @ebo12_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SELECT @ebo22_bins = ebo22_bins, @ebo22_iva = ebo22_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - @ebo22_bins)
			SET @DifIva = ABS(@DocTaxVal1 - @ebo22_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SELECT @ebo32_bins = ebo32_bins, @ebo32_iva = ebo32_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - @ebo32_bins)
			SET @DifIva = ABS(@DocTaxVal1 - @ebo32_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SELECT @ebo42_bins = ebo42_bins, @ebo42_iva = ebo42_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - @ebo42_bins)
			SET @DifIva = ABS(@DocTaxVal1 - @ebo42_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SELECT @ebo52_bins = ebo52_bins, @ebo52_iva = ebo52_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - @ebo52_bins)
			SET @DifIva = ABS(@DocTaxVal1 - @ebo52_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @ebo62_bins = @DocTaxBIns1		
			SET @ebo62_iva = @DocTaxVal1

			SELECT @ebo62_bins = ebo62_bins, @ebo62_iva = ebo62_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - @ebo62_bins)
			SET @DifIva = ABS(@DocTaxVal1 - @ebo62_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END
	END

	IF @DocTaxBIns2 > 0  -- quando a base de incidência 2 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax2, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax2, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SELECT @ebo12_bins = ebo12_bins, @ebo12_iva = ebo12_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - @ebo12_bins)
			SET @DifIva = ABS(@DocTaxVal2 - @ebo12_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SELECT @ebo22_bins = ebo22_bins, @ebo22_iva = ebo22_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - @ebo22_bins)
			SET @DifIva = ABS(@DocTaxVal2 - @ebo22_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SELECT @ebo32_bins = ebo32_bins, @ebo32_iva = ebo32_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - @ebo32_bins)
			SET @DifIva = ABS(@DocTaxVal2 - @ebo32_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!';

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SELECT @ebo42_bins = ebo42_bins, @ebo42_iva = ebo42_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - @ebo42_bins)
			SET @DifIva = ABS(@DocTaxVal2 - @ebo42_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SELECT @ebo52_bins = ebo52_bins, @ebo52_iva = ebo52_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - @ebo52_bins)
			SET @DifIva = ABS(@DocTaxVal2 - @ebo52_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SELECT @ebo62_bins = ebo62_bins, @ebo62_iva = ebo62_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - @ebo62_bins)
			SET @DifIva = ABS(@DocTaxVal2 - @ebo62_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END 
	END

	IF @DocTaxBIns3 > 0  -- quando a base de incidência 3 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax3, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax3, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SELECT @ebo12_bins = ebo12_bins, @ebo12_iva = ebo12_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - @ebo12_bins)
			SET @DifIva = ABS(@DocTaxVal3 - @ebo12_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SELECT @ebo22_bins = ebo22_bins, @ebo22_iva = ebo22_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - @ebo22_bins)
			SET @DifIva = ABS(@DocTaxVal3 - @ebo22_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SELECT @ebo32_bins = ebo32_bins, @ebo32_iva = ebo32_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - @ebo32_bins)
			SET @DifIva = ABS(@DocTaxVal3 - @ebo32_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SELECT @ebo42_bins = ebo42_bins, @ebo42_iva = ebo42_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - @ebo42_bins)
			SET @DifIva = ABS(@DocTaxVal3 - @ebo42_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SELECT @ebo52_bins = ebo52_bins, @ebo52_iva = ebo52_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - @ebo52_bins)
			SET @DifIva = ABS(@DocTaxVal3 - @ebo52_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SELECT @ebo62_bins = ebo62_bins, @ebo62_iva = ebo62_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - @ebo62_bins)
			SET @DifIva = ABS(@DocTaxVal3 - @ebo62_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END 
	END

	IF @DocTaxBIns4 > 0  -- quando a base de incidência 4 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax4, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax4, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SELECT @ebo12_bins = ebo12_bins, @ebo12_iva = ebo12_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - @ebo12_bins)
			SET @DifIva = ABS(@DocTaxVal4 - @ebo12_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SELECT @ebo22_bins = ebo22_bins, @ebo22_iva = ebo22_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - @ebo22_bins)
			SET @DifIva = ABS(@DocTaxVal4 - @ebo22_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SELECT @ebo32_bins = ebo32_bins, @ebo32_iva = ebo32_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - @ebo32_bins)
			SET @DifIva = ABS(@DocTaxVal4 - @ebo32_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SELECT @ebo42_bins = ebo42_bins, @ebo42_iva = ebo42_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - @ebo42_bins)
			SET @DifIva = ABS(@DocTaxVal4 - @ebo42_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SELECT @ebo52_bins = ebo52_bins, @ebo52_iva = ebo52_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - @ebo52_bins)
			SET @DifIva = ABS(@DocTaxVal4 - @ebo52_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SELECT @ebo62_bins = ebo62_bins, @ebo62_iva = ebo62_iva FROM bo where bostamp = @bostamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - @ebo62_bins)
			SET @DifIva = ABS(@DocTaxVal4 - @ebo62_iva) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

			IF (@Mensagem <>'')
				RETURN -1
		END 
	END

END
GO
-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFactIVAs
-- Ligação dos campos com as bases e valores de IVA do MSS aos do cabeçalho de documentos de facturação do PHC baseado na tabela de taxas de IVA para depois fazer a validação das incidências e dos valores dos ivas
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocFactValIVAs]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@ftstamp CHAR(25),
	@Sinal NUMERIC(6,2),
	@ValidateDocTotals NUMERIC(19,6),
	@Mensagem VARCHAR(200) OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @fttstamp CHAR(25)
	DECLARE @CodTabIva CHAR(1)
	DECLARE @DocTax1 NUMERIC(6,2)
	DECLARE @DocTaxBIns1 NUMERIC(19,6)
	DECLARE @DocTaxVal1 NUMERIC(19,6)
	DECLARE @DocTax2 NUMERIC(6,2)
	DECLARE @DocTaxBIns2 NUMERIC(19,6)
	DECLARE @DocTaxVal2 NUMERIC(19,6)
	DECLARE @DocTax3 NUMERIC(6,2)
	DECLARE @DocTaxBIns3 NUMERIC(19,6)
	DECLARE @DocTaxVal3 NUMERIC(19,6)
	DECLARE @DocTax4 NUMERIC(6,2)
	DECLARE @DocTaxBIns4 NUMERIC(19,6)
	DECLARE @DocTaxVal4 NUMERIC(19,6)

	DECLARE @eivain1 NUMERIC(19,6)
	DECLARE @eivav1 NUMERIC(19,6)
	DECLARE @eivain2 NUMERIC(19,6)
	DECLARE @eivav2 NUMERIC(19,6)
	DECLARE @eivain3 NUMERIC(19,6)
	DECLARE @eivav3 NUMERIC(19,6)
	DECLARE @eivain4 NUMERIC(19,6)
	DECLARE @eivav4 NUMERIC(19,6)
	DECLARE @eivain5 NUMERIC(19,6)
	DECLARE @eivav5 NUMERIC(19,6)
	DECLARE @eivain6 NUMERIC(19,6)
	DECLARE @eivav6 NUMERIC(19,6)
	DECLARE @eivain7 NUMERIC(19,6)
	DECLARE @eivav7 NUMERIC(19,6)
	DECLARE @eivain8 NUMERIC(19,6)
	DECLARE @eivav8 NUMERIC(19,6)
	DECLARE @eivain9 NUMERIC(19,6)
	DECLARE @eivav9 NUMERIC(19,6)

	DECLARE @DifIncidencia NUMERIC(19,6)
	DECLARE @DifIva NUMERIC(19,6)
	DECLARE @DOC VARCHAR(80)
	
	SELECT 
		@DocTax1 = ISNULL(DCCTX1, 0),
		@DocTaxBIns1 = ISNULL(DCCBI1, 0),
		@DocTaxVal1 = ISNULL(DCCVI1, 0),
		@DocTax2 = ISNULL(DCCTX2, 0),
		@DocTaxBIns2 = ISNULL(DCCBI2, 0),
		@DocTaxVal2 = ISNULL(DCCVI2, 0),
		@DocTax3 = ISNULL(DCCTX3, 0),
		@DocTaxBIns3 = ISNULL(DCCBI3, 0),
		@DocTaxVal3 = ISNULL(DCCVI3, 0),
		@DocTax4 = ISNULL(DCCTX4, 0),
		@DocTaxBIns4 = ISNULL(DCCBI4, 0),
		@DocTaxVal4 = ISNULL(DCCVI4, 0)
	FROM MSDCC(nolock)
	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC

	SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' FTSTAMP = ' + @ftstamp
	SET @Mensagem=''

	IF @DocTaxBIns1 > 0  -- quando a base de incidência 1 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax1, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax1, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SELECT @eivain1 = eivain1, @eivav1 = eivav1 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain1 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav1 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SELECT @eivain2 = eivain2, @eivav2 = eivav2 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain2 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav2 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SELECT @eivain3 = eivain3, @eivav3 = eivav3 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain3 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav3 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SELECT @eivain4 = eivain4, @eivav4 = eivav4 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain4 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav4 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SELECT @eivain5 = eivain5, @eivav5 = eivav5 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain5 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav5 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SELECT @eivain6 = eivain6, @eivav6 = eivav6 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain6 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav6 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SELECT @eivain7 = eivain7, @eivav7 = eivav7 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain7 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav7 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SELECT @eivain8 = eivain8, @eivav8 = eivav8 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain8 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav8 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SELECT @eivain9 = eivain9, @eivav9 = eivav9 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns1 - (@eivain9 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal1 - (@eivav9 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência1 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva1 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END
	END

	IF @DocTaxBIns2 > 0  -- quando a base de incidência 2 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax2, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax2, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SELECT @eivain1 = eivain1, @eivav1 = eivav1 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain1* @Sinal)) 
			SET @DifIva = ABS(@DocTaxVal2 -( @eivav1 * @Sinal) ) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SELECT @eivain2 = eivain2, @eivav2 = eivav2 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain2 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal2 - (@eivav2 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SELECT @eivain3 = eivain3, @eivav3 = eivav3 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain3 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal2 - (@eivav3 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SELECT @eivain4 = eivain4, @eivav4 = eivav4 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain4 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal2 - (@eivav4 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SELECT @eivain5 = eivain5, @eivav5 = eivav5 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain5 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal2 - (@eivav5 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SELECT @eivain6 = eivain6, @eivav6 = eivav6 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain6 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal2 - (@eivav6 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SELECT @eivain7 = eivain7, @eivav7 = eivav7 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain7 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal2 - (@eivav7 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SELECT @eivain8 = eivain8, @eivav8 = eivav8 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain8 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal2 - (@eivav8 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SELECT @eivain9 = eivain9, @eivav9 = eivav9 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns2 - (@eivain9 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal2 - (@eivav9 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência2 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva2 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END
	END

	IF @DocTaxBIns3 > 0  -- quando a base de incidência 3 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax3, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax3, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SELECT @eivain1 = eivain1, @eivav1 = eivav1 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain1 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 -( @eivav1 * @Sinal) ) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SELECT @eivain2 = eivain2, @eivav2 = eivav2 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain2 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 - (@eivav2 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SELECT @eivain3 = eivain3, @eivav3 = eivav3 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain3 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 - (@eivav3 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SELECT @eivain4 = eivain4, @eivav4 = eivav4 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain4 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 - (@eivav4 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SELECT @eivain5 = eivain5, @eivav5 = eivav5 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain5 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 - (@eivav5 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SELECT @eivain6 = eivain6, @eivav6 = eivav6 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain6 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 - (@eivav6 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SELECT @eivain7 = eivain7, @eivav7 = eivav7 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain7 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 - (@eivav7 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SELECT @eivain8 = eivain8, @eivav8 = eivav8 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain8 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 - (@eivav8 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SELECT @eivain9 = eivain9, @eivav9 = eivav9 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns3 - (@eivain9 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal3 - (@eivav9 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência3 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva3 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END
	END

	IF @DocTaxBIns4 > 0  -- quando a base de incidência 4 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax4, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax4, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SELECT @eivain1 = eivain1, @eivav1 = eivav1 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain1 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 -( @eivav1 * @Sinal) ) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SELECT @eivain2 = eivain2, @eivav2 = eivav2 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain2 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 - (@eivav2 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SELECT @eivain3 = eivain3, @eivav3 = eivav3 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain3 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 - (@eivav3 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SELECT @eivain4 = eivain4, @eivav4 = eivav4 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain4 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 - (@eivav4 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SELECT @eivain5 = eivain5, @eivav5 = eivav5 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain5 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 - (@eivav5 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SELECT @eivain6 = eivain6, @eivav6 = eivav6 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain6 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 - (@eivav6 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SELECT @eivain7 = eivain7, @eivav7 = eivav7 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain7 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 - (@eivav7 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SELECT @eivain8 = eivain8, @eivav8 = eivav8 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain8 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 - (@eivav8 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SELECT @eivain9 = eivain9, @eivav9 = eivav9 FROM ft where ftstamp = @ftstamp

			SET @DifIncidencia = ABS(@DocTaxBIns4 - (@eivain9 * @Sinal))
			SET @DifIva = ABS(@DocTaxVal4 - (@eivav9 * @Sinal)) 

			IF @DifIncidencia >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na incidência4 é superior à definida no parâmetro!'

			IF @DifIva >  @ValidateDocTotals
				SET @Mensagem = @DOC + ' Diferença na taxa de iva4 é superior à definida no parâmetro!'

            IF (@Mensagem <>'')
				RETURN -1
		END
	END
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFactLinUSR
-- Persoanlizações na integração de linhas de documentos de facturação
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocFactLinUSR] 
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@ftstamp CHAR(25),		-- Stamp do documento de facturação
	@fistamp CHAR(25),		-- Stamp da linha
	@ref VARCHAR(18),		-- Código do artigo
	@DCLLIN INT				-- Linha do documento no MSS
AS
BEGIN
	SET NOCOUNT ON;


END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFactLin
-- Integração de linhas de documentos de facturação
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocFactLin]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@ftstamp CHAR(25),
	@rdata DATETIME,
	@DCCDCG NUMERIC(18,5),
	@DCCARO VARCHAR(30),
	@DCCARD VARCHAR(30),
	@DCCTSF VARCHAR(10),
	@no INT,
	@estab INT,
	@nome VARCHAR(55),
	@DocAnul CHAR(1),
	@Imp1 CHAR(10),
	@Imp2 CHAR(10),
	@Imp3 CHAR(10),
	@Devolucao CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @DocTipo VARCHAR(10)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocLinDescV NUMERIC(18,5)
	DECLARE @DocLinDesc1 NUMERIC(6,2)
	DECLARE @DocLinDesc2 NUMERIC(6,2)
	DECLARE @DocLinDesc3 NUMERIC(6,2)
	DECLARE @DocLinDesc4 NUMERIC(6,2)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocIVI VARCHAR(1)
	DECLARE @DocDesc NUMERIC(18,5)
	DECLARE @DocUni2 VARCHAR(4)
	DECLARE @ArtPPond NUMERIC(19,6)
	DECLARE @ArtConv NUMERIC(19,6)
	DECLARE @ArtStock NUMERIC(11,3)
	DECLARE @ArtQttFor NUMERIC(11,3)
	DECLARE @ArtQttCli NUMERIC(11,3)
	DECLARE @ArtQttRec NUMERIC(11,3)
	DECLARE @ArtUsrQtt NUMERIC(11,3)
	DECLARE @ArtForref VARCHAR(20)

	DECLARE @CliTipo VARCHAR(20)
	DECLARE @CliTelef VARCHAR(60)
	DECLARE @CliNome VARCHAR(55)
	DECLARE @CliMorada VARCHAR(55)
	DECLARE @CliLocal VARCHAR(43)
	DECLARE @CliCPostal VARCHAR(45)
	DECLARE @CliNCont VARCHAR(18)
	DECLARE @CliPais INT
	DECLARE @CliZona VARCHAR(20)
	DECLARE @CliSegmento VARCHAR(25)

	DECLARE @fistamp CHAR(25)
	DECLARE @ref VARCHAR(60)
	DECLARE @design VARCHAR(60)
	DECLARE @lordem INT
	DECLARE @ndoc INT
	DECLARE @armazem INT
	DECLARE @qtt NUMERIC(11,3)
	DECLARE @altura NUMERIC(11,3)
	DECLARE @largura NUMERIC(11,3)
	DECLARE @espessura NUMERIC(11,3)
	DECLARE @peso NUMERIC(11,3)
	DECLARE @usr1 VARCHAR(20)
	DECLARE @usr2 VARCHAR(20)
	DECLARE @usr3 VARCHAR(35)
	DECLARE @usr4 VARCHAR(20)
	DECLARE @usr5 VARCHAR(120)
	DECLARE @usr6 VARCHAR(30)
	DECLARE @ivaincl INT
	DECLARE @cpoc INT
	DECLARE @stns INT
	DECLARE @usalote INT 
	DECLARE @lote VARCHAR(30)
	DECLARE @fno INT
	DECLARE @epv NUMERIC(19,6)
	DECLARE @pv NUMERIC(18,5)
	DECLARE @etiliquido NUMERIC(19,6)
	DECLARE @tiliquido NUMERIC(18,5)
	DECLARE @eslvu NUMERIC(19,6)
	DECLARE @slvu NUMERIC(18,5)
	DECLARE @epcp NUMERIC(19,6)
	DECLARE @pcp NUMERIC(18,5) 
	DECLARE @esltt NUMERIC(19,6)
	DECLARE @sltt NUMERIC(18,5)
	DECLARE @ecusto NUMERIC(19,6)
	DECLARE @custo NUMERIC(18,5)
	DECLARE @desconto NUMERIC(6,2)
	DECLARE @desc2 NUMERIC(6,2)
	DECLARE @desc3 NUMERIC(6,2)
	DECLARE @desc4 NUMERIC(6,2)
	DECLARE @desc5 NUMERIC(6,2)
	DECLARE @iva NUMERIC(6,2)
	DECLARE @uni2qtt NUMERIC(11,3)
	DECLARE @unidade VARCHAR(4)
	DECLARE @unidad2 VARCHAR(4)
	DECLARE @tabiva INT
	DECLARE @fivendedor INT
	DECLARE @fivendnm VARCHAR(20)
	DECLARE @nmdoc VARCHAR(20)
	DECLARE @ecomissao INT 
	DECLARE @tipodoc INT
	DECLARE @tipodocFor INT
	DECLARE @tliquido NUMERIC(18,5)
	DECLARE @codigo VARCHAR(18)
	DECLARE @familia VARCHAR(18)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @datalote VARCHAR(8)
	DECLARE @validade VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	DECLARE @ExerDocOrig VARCHAR(30)
	DECLARE @TipoDocOrig VARCHAR(10)
	DECLARE @SerieDocOrig VARCHAR(10)
	DECLARE @NumDocOrig INT
	DECLARE @LinDocOrig INT
	
	DECLARE @orilinstamp VARCHAR(25)
	DECLARE @oriheadstamp VARCHAR(25)
	DECLARE @orindoc INT
	
	DECLARE @To_Close INT
	DECLARE @QtdPend NUMERIC(11,3)
	DECLARE @Sinal NUMERIC(6,2)

	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT

	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @moradaentrega VARCHAR(55)
	DECLARE @localentrega VARCHAR(43)
	DECLARE @codpostentrega VARCHAR(45)

	DECLARE @motiseimp VARCHAR(60)
	DECLARE @codmotiseimp VARCHAR(3)
	DECLARE @DCLACL VARCHAR(2000)

	DECLARE @refCorTam VARCHAR(60)
	DECLARE @Cor VARCHAR(25)
	DECLARE @Tam VARCHAR(25)
	DECLARE @Texteis INT
	DECLARE @DCLLIN INT
	DECLARE @DCLTCL CHAR(1)
	DECLARE @DCLQTM NUMERIC(11,3)
	DECLARE @DCLPRO NUMERIC(19,6)

	DECLARE @NSERIE VARCHAR(60)
	DECLARE @CONT INT
	DECLARE @mastamp CHAR(25)
	DECLARE @ftmastamp CHAR(25)
	DECLARE @bdemp	VARCHAR(2)
	DECLARE @NOSERIE INT
	DECLARE @cont_ftma INT
	DECLARE @zona VARCHAR(13)
	DECLARE @segmento VARCHAR(25)
	DECLARE @moeda VARCHAR(11)
	DECLARE @CliLocTesoura VARCHAR(50)
	DECLARE @CliContado INT
	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)
	DECLARE @tabivaTemp INT
	
	/*impostos*/
	DECLARE @dcli1v NUMERIC (19,6)
	DECLARE @dcli2v NUMERIC(19,6)
	DECLARE @dcli3v NUMERIC(19,6)
	DECLARE @ecovalor NUMERIC(19,6)
	DECLARE @etecoval NUMERIC (19,6)
	DECLARE @eecoval NUMERIC (19,6)
	DECLARE @temeco INT
	DECLARE @ECONOTCALC INT

	/*composto*/
	DECLARE @DCLACP CHAR(1)
	DECLARE @lrecno CHAR(25)
	DECLARE @COMPOSTO INT

	/* descritivo */
	DECLARE @DESCRITIVO CHAR(1)

	SET @CONT = 0

	DECLARE curFI CURSOR FOR
	SELECT 
		ISNULL(DCLTPD, ''),
		ISNULL(DCLSER, ''),
		ISNULL(DCLNDC, 0),
		CASE WHEN DCLLIN < 1000 THEN ISNULL(DCLLIN*10000, 0)
		ELSE DCLLIN END,
		ISNULL(DCLART, ''),
		ISNULL(DCLQTD, 0.0),
		ISNULL(DCLPRU, 0.0),
		ISNULL(DCLTXI, 0.0),
		ISNULL(DCLTDC, 0.0),
		ISNULL(DCLTD2, 0.0),
		ISNULL(DCLTD3, 0.0),
		ISNULL(DCLTD4, 0.0),
		ISNULL(DCTLOT, ''),
		ISNULL(DCLDSA, ''),
		ISNULL(DCLVD1, 0.0),
		ISNULL(DCLUND, ''),
		ISNULL(DCLALT, 0.0),
		ISNULL(DCLLGR, 0.0),
		ISNULL(DCLCMP, 0.0),
		ISNULL(DCLPES, 0.0),
		ISNULL(DCLVND, ''),
		ISNULL(DCLTERM, 0),
		ISNULL(DCLIVI, 'N'),
		ISNULL(DCLVLD, 0),
		ISNULL(DCLIVA, 0),
		ISNULL(DCLQT2, 0),
		ISNULL(DCLOEX, ''),
		ISNULL(DCLOTP, ''),
		ISNULL(DCLOSR, ''),
		ISNULL(DCLOND, 0),
		ISNULL(DCLOLN, 0),
		ISNULL(DCTDTL, ''),
		ISNULL(DCTDVL, ''),
		ISNULL(DCLPLI, ''),
		ISNULL(DCLACL, ''),
		ISNULL(DCLUN2, ''),
		ISNULL(DCLLIN, 0),
		ISNULL(DCLTCL, ''),
		ISNULL(DCLQTM, 0),
		ISNULL(DCLPRO, 0), --PHC 23
		ISNULL(DCTNSR,''),
		ISNULL(DCLI1V, 0),
		ISNULL(DCLI2V, 0),
		ISNULL(DCLI3V, 0),
		ISNULL(DCLACP, 'N')
	FROM MSDCL(nolock)
	WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC

	OPEN curFI
		
		FETCH NEXT FROM curFI INTO @DocTipo, @DocSerie, @fno, @lordem, @ref, @qtt, @epv, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @fivendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @datalote, @validade, @motiseimp, @DCLACL, @DocUni2, @DCLLIN, @DCLTCL, @DCLQTM, @DCLPRO, @NSERIE, @dcli1v, @dcli2v, @dcli3v, @DCLACP
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				
				SET @ecovalor = 0

				IF (@dcli1v > 0 AND @Imp1='')
					RAISERROR('Documento com imposto 1 sem estar configurado!',16,1)

				IF (@dcli2v > 0 AND @Imp2='')
					RAISERROR('Documento com imposto 2 sem estar configurado!',16,1)

				IF (@dcli3v > 0 AND @Imp3='')
					RAISERROR('Documento com imposto 3 sem estar configurado!',16,1)

				if (upper(@Imp1) = 'ECOVALOR' and @dcli1v>0)
					SET @ecovalor = @dcli1v
				else if (upper(@Imp2) = 'ECOVALOR' and @dcli2v>0)
					SET @ecovalor = @dcli2v
				else if (upper(@Imp3) = 'ECOVALOR' and @dcli3v>0)
					SET @ecovalor = @dcli3v

				SET @eecoval = 0
				SET @etecoval = 0
				SET @TEMECO = 0
				
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @fistamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @armazem = dbo.StringToNum(@DCCARO)
				IF @armazem <= 0
					SET @armazem = dbo.StringToNum(@DCCARD)
				
				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				-- Dados do cliente
				EXECUTE SPMSS_GetCliInfo2 @no, @estab, @CliTipo OUTPUT, @Zona OUTPUT, @Segmento OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @CliLocTesoura OUTPUT, @CliContado OUTPUT, @fref OUTPUT, @ccusto OUTPUT, @tabivaTemp OUTPUT

				-- Verifica se é uma artigo descritivo
				SET @DESCRITIVO = dbo.ExtractFromACL(@DCLACL, 15)

				-- Verifica se é um artigo com cor e tamanho
				SET @refCorTam = dbo.ExtractFromACL(@DCLACL, 15)
				IF (@refCorTam = 'F')
				BEGIN
					SET @refCorTam = @ref
					EXECUTE SPMSS_GetCorTamanho @DCLACL, @ref OUTPUT, @Cor OUTPUT, @Tam OUTPUT
					SET @Texteis = 1
				END
				ELSE
				BEGIN
					SET @COR = ''
					SET @Tam = ''
					SET @Texteis = 0
				END

				-- Verifica o composto
				SET @COMPOSTO = 0
				IF @DCLACP = 'A'
					SET @lrecno = @fistamp
				ELSE IF @DCLACP = 'C'
				BEGIN
					SET @COMPOSTO = 1

					DECLARE @DCCDND AS INT
					SELECT @DCCDND = ISNULL(DCCDND, 0) FROM MSDCC WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC
					IF @DCCDND > 0
					BEGIN
						SET @COMPOSTO = 0
						SET @lrecno = @fistamp
					END

					
				END
				ELSE
				BEGIN
					SET @lrecno = @fistamp
					SET @COMPOSTO = 0
				END

				EXECUTE SPMSS_GetDadosDoc 2, @DocTipo, @DocSerie, @ndoc OUTPUT, @nmdoc OUTPUT, @tipodocFor OUTPUT, @tipodoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT

				EXECUTE SPMSS_GetVendNome @fivendedor, @fivendnm OUTPUT

				IF @DESCRITIVO <> 'D'
				BEGIN
				
					EXECUTE SPMSS_GetArtInfo @ref, @usr1 OUTPUT, @usr2 OUTPUT, @usr3 OUTPUT, @usr4 OUTPUT, @usr5 OUTPUT, @usr6 OUTPUT, @familia OUTPUT, @ecusto OUTPUT, @codigo OUTPUT, @ArtForref OUTPUT, @ivaincl OUTPUT, @ecomissao OUTPUT, @cpoc OUTPUT, @stns OUTPUT, @usalote OUTPUT, @epcp OUTPUT, @unidad2 OUTPUT, @ArtConv OUTPUT,	@ArtStock OUTPUT, @ArtQttFor OUTPUT, @ArtQttCli OUTPUT,	@ArtQttRec OUTPUT, @ArtUsrQtt OUTPUT
				
					EXECUTE SPMSS_GetArtPCusto @ref, @DocPCusto, @ecusto OUTPUT
				
				
				
					IF @usalote = 0
						SET @lote = ''
				
					IF @tipodoc = 3	 --******************* Quando são notas de crédito os totais têm de ser integrados com sinal negativo
						SET @Sinal = -1
					ELSE
						SET @Sinal = 1
				
				

					EXECUTE SPMSS_CalcDescontos @DocLinDescV, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @epv, @qtt, @DCCDCG, @desconto OUTPUT, @desc2 OUTPUT, @desc3 OUTPUT, @desc4 OUTPUT, @desc5 OUTPUT
				
					IF @DocIVI = 'S'
					begin
						IF (dbo.ExtractFromACL(@DCLACL, 24) <> '')
							SET @DocDesc = CAST(dbo.ExtractFromACL(@DCLACL, 24) AS NUMERIC(19,6))
						ELSE
							SET @DocDesc = 0
						
						if (@ecovalor > 0)
						begin
							SET @eecoval = @ecovalor
							SET @etecoval = @eecoval * @qtt
							SET @eslvu = (@epv - @DocLinDescV + @eecoval) / (@iva/100+1)
							SET @esltt = (@qtt * @epv - @DocDesc + @etecoval) / (@iva/100+1)
							SET @TEMECO=1
						end
						else
						begin
							SET @eslvu = (@epv - @DocLinDescV) / (@iva/100+1)
							SET @esltt = (@qtt * @epv - @DocDesc) / (@iva/100+1)
						end
						SET @ivaincl = 1
						
						SET @etiliquido = (@qtt * @epv)-@DocDesc
						
						
							-- só no fim é que arredonda a 2 casas
						SET @etiliquido = round(@etiliquido,2) * @Sinal
						--SET @tliquido = @etiliquido  * @Sinal
						SET @tliquido = @etiliquido
					end
					ELSE
					BEGIN
						SET @etiliquido = CAST(dbo.ExtractFromACL(@DCLACL, 3) AS NUMERIC(19,6)) * @Sinal
						--SET @tliquido = (@etiliquido * (@iva/100+1)) * @Sinal
						SET @tliquido = (@etiliquido * (@iva/100+1))

						if (@ecovalor > 0)
						begin
							SET @eecoval = @ecovalor
							SET @etecoval = @eecoval * @qtt
							SET @eslvu = @epv - round((@DocDesc / @qtt), 2) + @eecoval
							SET @esltt = @qtt * @epv - @DocDesc + @etecoval
							SET @TEMECO=1
						end
						else
						begin
							SET @eslvu = (@epv - round((@DocDesc / @qtt), 2))
							SET @esltt = (@qtt * @epv - @DocDesc)
						end

						SET @ivaincl = 0
					END
				
					/*Linha com ecovalor*/
					IF @ecovalor > 0
					BEGIN
						EXECUTE SPMSS_DocECOVal @ref, @fistamp, @ftstamp, @DocTerminal, 1
						EXECUTE SPMSS_DocECOValP @ref, @fistamp, @ftstamp, @DocTerminal, 1
						EXECUTE SPMSS_DocECOValO @ref, @fistamp, @ftstamp, @DocTerminal, 1
					END
				
					IF (@DCLTCL = 'Q')
					BEGIN
						SET @uni2qtt = @DCLQTM
						SET @unidad2 = dbo.ExtractFromACL(@DCLACL, 25)
					END
					ELSE
					BEGIN
						IF @unidad2 <> ''
						BEGIN
							IF @DocUni2 <> @unidad2
								SET @uni2qtt = @qtt * @ArtConv
						END
						ELSE
							SET @uni2qtt = 0
					END
				
				
					SET @orilinstamp = ''
					SET @oriheadstamp = ''
				
					IF ((@TipoDocOrig <> '') OR (@Devolucao = 'S'))
					BEGIN
						EXECUTE SPMSS_GetDocOrigStamp @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @DCCTSF, @Devolucao, 0, @orilinstamp OUTPUT, @oriheadstamp OUTPUT, @QtdPend OUTPUT, @orindoc OUTPUT
					END
					-- verificar se o lote existe na tabela se e caso não exista fazer o insert antes de inserir a linha
					IF @lote <> ''
					BEGIN
						EXECUTE SPMSS_CheckLote @ref, @design, @lote, @datalote, @validade, @DocTerminal, @rdata
					END
				
					-- ler dados do local de entrega
					SELECT @morada = DCCMOR, @local = DCCLOC, @codpost = DCCCPT, @moradaentrega = DCCEMO, @localentrega = DCCELO, @codpostentrega = DCCECP FROM MSDCC(nolock)	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC
					IF (@moradaentrega = '') AND (@localentrega = '') AND (@codpostentrega = '')
					BEGIN
						SET @moradaentrega = @morada
						SET @localentrega = @local
						SET @codpostentrega = @codpost
					END

					SET @codmotiseimp = dbo.ExtractFromACL(@DCLACL, 12)

					--Se for isento é preciso validar o códido iva para garantir que é bem inserido na tabela fi (linhas das faturas)
					if @iva=0.0
							EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @iva, @tabiva OUTPUT
				END
			    /*IF @NSERIE<>''
				BEGIN
					SET @NOSERIE=1
				END
				ELSE
				BEGIN
					SET @NOSERIE=0
				END*/

				IF (@DESCRITIVO = 'D')
				BEGIN
					SET @ref = ''
					SET @ecusto = 0
					SET @usr1 = ''
					SET @usr2 = ''
					SET @usr3 = ''
					SET @usr4 = ''
					SET @usr5 = ''
					SET @usr6 = ''
					SET @familia = ''
					SET @ecusto = 0
					SET @codigo = ''
					SET @ArtForref = ''
					SET @ivaincl = 0
					SET @ecomissao = 0
					SET @cpoc = 0
					SET @stns = 0
					SET @usalote= 0
					SET @epcp = 0
					SET @unidad2 = ''
					SET @ArtConv = 0
					SET @ArtStock = 0
					SET @ArtQttFor = 0
					SET @ArtQttCli = 0
					SET @ArtQttRec = 0
					SET @ArtUsrQtt = 0
					SET @etiliquido = 0
					SET @tliquido = 0
					SET @ecovalor = 0
					SET @eecoval = 0
					SET @etecoval = 0
					SET @eslvu = 0
					SET @esltt = 0
					SET @desconto = 0 
					SET @desc2 = 0 
					SET @desc3 = 0
					SET @desc4 = 0
					SET @desc5 = 0
					SET @moradaentrega = ''
					SET @localentrega = ''
					SET @codpostentrega = ''
					SET @codmotiseimp = dbo.ExtractFromACL(@DCLACL, 12)
				END

				-- ISENTO IVA
				IF @iva = 0 AND @tabiva <> @tabivaTemp AND @tabivaTemp > 0
					SET @tabiva = @tabivaTemp

				IF @DCCTSF <> 'NC'
				BEGIN
					IF @orilinstamp IS NULL
						SET @orilinstamp = ''
					
					INSERT INTO fi (fistamp, ref, design, lordem, ndoc, ftstamp, armazem, qtt, altura, largura, espessura, peso, usr1, usr2, usr3, usr4, usr5, usr6, ivaincl, cpoc, stns, usalote, lote, fno, epv, pv, etiliquido, tiliquido, eslvu, slvu, epcp, pcp, esltt, sltt, ecusto, custo, desconto, desc2, desc3, desc4, desc5, iva, rdata, uni2qtt, unidade, unidad2, tabiva, fivendedor, fivendnm, nmdoc, ecomissao, tipodoc, tliquido, codigo, familia, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, bistamp, evaldesc, morada, local, codpost, motiseimp, codmotiseimp, cor, tam, texteis, epvori, pvori, taxpointdt/*, series, noserie*/,temeco,eecoval,ecoval,etecoval,tecoval,lrecno,composto) 
					VALUES (@fistamp, @ref, @design, @lordem, @ndoc, @ftstamp, @armazem, @qtt, @altura, @largura, @espessura, @peso, @usr1, @usr2, @usr3, @usr4, @usr5, @usr6, @ivaincl, @cpoc, @stns, @usalote, @lote, @fno, @epv, dbo.EurToEsc(@epv), @etiliquido, dbo.EurToEsc(@etiliquido), @eslvu, dbo.EurToEsc(@eslvu), @epcp, dbo.EurToEsc(@epcp), @esltt, dbo.EurToEsc(@esltt), @ecusto, dbo.EurToEsc(@ecusto), @desconto, @desc2, @desc3, @desc4, @desc5, @iva, @rdata, @uni2qtt, @unidade, @unidad2, @tabiva, @fivendedor, @fivendnm, @nmdoc, @ecomissao, @tipodoc, @tliquido, @codigo, @familia, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @orilinstamp,  @DocLinDescV, @moradaentrega, @localentrega, @codpostentrega, @motiseimp, @codmotiseimp, @Cor, @Tam, @Texteis, @DCLPRO, dbo.EurToEsc(@DCLPRO),@usrdata/*,@NSERIE,@NOSERIE*/, @temeco,@eecoval,dbo.EurToEsc(@eecoval),@etecoval,dbo.EurToEsc(@etecoval),@lrecno,@COMPOSTO)
					
				
					IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'fi2'))
					BEGIN
						INSERT INTO fi2 (fi2stamp, prestsrv, ftstamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada)
						VALUES (@fistamp, 0, @ftstamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0)
					END
				
				
				
					EXEC SPMSS_DocDocFactLinUSR @DCCEXR,@DCCTPD,@DCCSER,@DCCNDC,@ftstamp,@fistamp,@ref,@DCLLIN

					IF @orilinstamp IS NOT NULL
					BEGIN
						IF @QtdPend = @qtt
						BEGIN
							UPDATE bi SET fechada = 1, datafecho = @rdata WHERE bistamp = @orilinstamp
						END
					
						SELECT @To_Close = COUNT(*) FROM BI(nolock) WHERE bostamp = @oriheadstamp AND fechada = 0 and ref <> ''

						IF @To_Close = 0
						BEGIN
							UPDATE bo SET fechada = 1, datafecho = @rdata WHERE bostamp = @oriheadstamp			
						END
					END
				END
				ELSE
				BEGIN
					IF @orilinstamp IS NULL
						SET @orilinstamp = ''

					INSERT INTO fi (fistamp, ref, design, lordem, ndoc, ftstamp, armazem, qtt, altura, largura, espessura, peso, usr1, usr2, usr3, usr4, usr5, usr6, ivaincl, cpoc, stns, usalote, lote, fno, epv, pv, etiliquido, tiliquido, eslvu, slvu, epcp, pcp, esltt, sltt, ecusto, custo, desconto, desc2, desc3, desc4, desc5, iva, rdata, uni2qtt, unidade, unidad2, tabiva, fivendedor, fivendnm, nmdoc, ecomissao, tipodoc, tliquido, codigo, familia, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, evaldesc, fnoft, ndocft, ftanoft, ofistamp, morada, local, codpost, motiseimp, codmotiseimp, cor, tam, texteis, epvori, pvori/*, series, noserie*/,temeco,eecoval,ecoval,etecoval,tecoval,lrecno,composto) 
					VALUES (@fistamp, @ref, @design, @lordem, @ndoc, @ftstamp, @armazem, @qtt, @altura, @largura, @espessura, @peso, @usr1, @usr2, @usr3, @usr4, @usr5, @usr6, @ivaincl, @cpoc, @stns, @usalote, @lote, @fno, @epv, dbo.EurToEsc(@epv), @etiliquido, dbo.EurToEsc(@etiliquido), @eslvu, dbo.EurToEsc(@eslvu), @epcp, dbo.EurToEsc(@epcp), @esltt, dbo.EurToEsc(@esltt), @ecusto, dbo.EurToEsc(@ecusto), @desconto, @desc2, @desc3, @desc4, @desc5, @iva, @rdata, @uni2qtt, @unidade, @unidad2, @tabiva, @fivendedor, @fivendnm, @nmdoc, @ecomissao, @tipodoc, @tliquido, @codigo, @familia, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora,  @DocLinDescV, @NumDocOrig, @orindoc, @ExerDocOrig, @orilinstamp, @moradaentrega, @localentrega, @codpostentrega, @motiseimp, @codmotiseimp, @Cor, @Tam, @Texteis, @DCLPRO, dbo.EurToEsc(@DCLPRO)/*,@NSERIE,@NOSERIE*/, @temeco,@eecoval,dbo.EurToEsc(@eecoval),@etecoval,dbo.EurToEsc(@etecoval),@lrecno,@composto)

					IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'fi2'))
					BEGIN
						INSERT INTO fi2 (fi2stamp, prestsrv, ftstamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada)
						VALUES (@fistamp, 0, @ftstamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0)
					END

					EXEC SPMSS_DocDocFactLinUSR @DCCEXR,@DCCTPD,@DCCSER,@DCCNDC,@ftstamp,@fistamp,@ref,@DCLLIN

					IF @oriheadstamp IS NOT NULL
						UPDATE ft SET facturada = 1, fnoft = @fno, nmdocft = @nmdoc WHERE ftstamp = @oriheadstamp			
					ELSE
					BEGIN
					WAITFOR DELAY '00:00:00.050' 
						SET @DateTimeTmp = GETDATE()
				
						SET @DateStr = dbo.DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
						SET @fistamp = 'MSS_' + @DateStr + @TimeStr
						SET @lordem = @lordem + 1

						SET @design = 'Orig. não encontrada:Ex:' + @ExerDocOrig + ',Cód:' + @TipoDocOrig + ',Sér:' + @SerieDocOrig + ',Num:' + CAST(@NumDocOrig AS VARCHAR(10))

						INSERT INTO fi (fistamp, design, lordem, ndoc, ftstamp, fno, fivendedor, fivendnm, nmdoc, tipodoc, ofistamp) 
						VALUES (@fistamp, @design, @lordem, @ndoc, @ftstamp, @fno, @fivendedor, @fivendnm, @nmdoc, @tipodoc, '')
					END
				END

				/*IF @NSERIE<>''
				BEGIN
				 SET @CONT= @CONT+1
				    IF @CONT > 1
					BEGIN
						update ft set SERIES=CAST(SERIES AS VARCHAR(60)) + CAST(',' as VARCHAR(1)) + @NSERIE where ftstamp=@ftstamp
				    END
					ELSE
					BEGIN
						update ft set SERIES=@NSERIE where ftstamp=@ftstamp
					END

					--INDICAR QUE ESTE ARTIGO COM O SERIAL NUMBER @NSERIE JÁ DEU SAIDA DO ARMAZEM
					--UPDATE MA SET NO=@no, CASA=0 WHERE SERIE=@NSERIE AND NOARM=@armazem

					WAITFOR DELAY '00:00:00.050' 
						SET @DateTimeTmp = GETDATE()
				
						SET @DateStr = dbo.DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

					SET @ftmastamp = 'MSS_' + @DateStr + @TimeStr

					IF @DocAnul = 'N'
					BEGIN
						SELECT @mastamp=mastamp FROM MA (NOLOCK) WHERE SERIE=@NSERIE AND NOARM=@armazem

						--Inserir nºs de série nos documentos de faturação
						INSERT INTO FTMA (ftmastamp,ftstamp,fistamp,mastamp,serie,serie2,ref,design,nome,no,nmdoc,fno,ndoc,fdata,estab,tipodoc,armazem,obs,recnum,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,marcada,maserierpl,serprvef)
						Values(@ftmastamp,@ftstamp,@fistamp,@mastamp,@NSERIE,'',@ref,@design,@nome,@no,@nmdoc,@fno,@ndoc,@rdata,@estab,@tipodoc,@armazem,'',@CONT,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0,'',0)  
					END
				END*/
				
				IF @@ERROR <> 0
				BEGIN
					SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
					SET @ErrorMessage = 'Insert fi - ' + @ErrorMessage
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				END
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curFI INTO @DocTipo, @DocSerie, @fno, @lordem, @ref, @qtt, @epv, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @fivendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @datalote, @validade, @motiseimp, @DCLACL, @DocUni2, @DCLLIN, @DCLTCL, @DCLQTM, @DCLPRO, @NSERIE, @dcli1v, @dcli2v, @dcli3v, @DCLACP
		END
	FIM:
		CLOSE curFI
		DEALLOCATE curFI
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFactUSR
-- Personalizações na integração de cabeçalhos de documentos de facturação
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocFactUSR]
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@ftstamp CHAR(25),		-- Stamp do documento de facturação
	@no INT					-- Nº do cliente
AS
BEGIN
	SET NOCOUNT ON;


END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFactIVAs
-- Ligação dos campos com as bases e valores de IVA do MSS aos do cabeçalho de documentos de facturação do PHC baseado na tabela de taxas de IVA
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocFactIVAs]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@ftstamp CHAR(25),
	@Sinal NUMERIC(6,2),
	@eivain1 NUMERIC(19,6) OUTPUT,
	@eivav1 NUMERIC(19,6) OUTPUT,
	@eivain2 NUMERIC(19,6) OUTPUT,
	@eivav2 NUMERIC(19,6) OUTPUT,
	@eivain3 NUMERIC(19,6) OUTPUT,
	@eivav3 NUMERIC(19,6) OUTPUT,
	@eivain4 NUMERIC(19,6) OUTPUT,
	@eivav4 NUMERIC(19,6) OUTPUT,
	@eivain5 NUMERIC(19,6) OUTPUT,
	@eivav5 NUMERIC(19,6) OUTPUT,
	@eivain6 NUMERIC(19,6) OUTPUT,
	@eivav6 NUMERIC(19,6) OUTPUT,
	@eivain7 NUMERIC(19,6) OUTPUT,
	@eivav7 NUMERIC(19,6) OUTPUT,
	@eivain8 NUMERIC(19,6) OUTPUT,
	@eivav8 NUMERIC(19,6) OUTPUT,
	@eivain9 NUMERIC(19,6) OUTPUT,
	@eivav9 NUMERIC(19,6) OUTPUT,
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
	DECLARE @fttstamp CHAR(25)
	DECLARE @CodTabIva CHAR(1)
	DECLARE @DocTax1 NUMERIC(6,2)
	DECLARE @DocTaxBIns1 NUMERIC(19,6)
	DECLARE @DocTaxVal1 NUMERIC(19,6)
	DECLARE @DocTax2 NUMERIC(6,2)
	DECLARE @DocTaxBIns2 NUMERIC(19,6)
	DECLARE @DocTaxVal2 NUMERIC(19,6)
	DECLARE @DocTax3 NUMERIC(6,2)
	DECLARE @DocTaxBIns3 NUMERIC(19,6)
	DECLARE @DocTaxVal3 NUMERIC(19,6)
	DECLARE @DocTax4 NUMERIC(6,2)
	DECLARE @DocTaxBIns4 NUMERIC(19,6)
	DECLARE @DocTaxVal4 NUMERIC(19,6)
	
	SELECT 
		@DocTax1 = ISNULL(DCCTX1, 0),
		@DocTaxBIns1 = ISNULL(DCCBI1, 0),
		@DocTaxVal1 = ISNULL(DCCVI1, 0),
		@DocTax2 = ISNULL(DCCTX2, 0),
		@DocTaxBIns2 = ISNULL(DCCBI2, 0),
		@DocTaxVal2 = ISNULL(DCCVI2, 0),
		@DocTax3 = ISNULL(DCCTX3, 0),
		@DocTaxBIns3 = ISNULL(DCCBI3, 0),
		@DocTaxVal3 = ISNULL(DCCVI3, 0),
		@DocTax4 = ISNULL(DCCTX4, 0),
		@DocTaxBIns4 = ISNULL(DCCBI4, 0),
		@DocTaxVal4 = ISNULL(DCCVI4, 0)
	FROM MSDCC(nolock)
	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC

	SET @eivain1 = 0
	SET @eivav1 = 0
	SET @eivain2 = 0
	SET @eivav2 = 0
	SET @eivain3 = 0
	SET @eivav3 = 0
	SET @eivain4 = 0
	SET @eivav4 = 0
	SET @eivain5 = 0
	SET @eivav5 = 0
	SET @eivain6 = 0
	SET @eivav6 = 0
	SET @eivain7 = 0
	SET @eivav7 = 0
	SET @eivain8 = 0
	SET @eivav8 = 0
	SET @eivain9 = 0
	SET @eivav9 = 0


	IF abs(@DocTaxBIns1) > 0  -- quando a base de incidência 1 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax1, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax1, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivain1 = @DocTaxBIns1		
			SET @eivav1 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivain2 = @DocTaxBIns1
			SET @eivav2 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivain3 = @DocTaxBIns1		
			SET @eivav3 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivain4 = @DocTaxBIns1		
			SET @eivav4 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivain5 = @DocTaxBIns1		
			SET @eivav5 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivain6 = @DocTaxBIns1		
			SET @eivav6 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivain7 = @DocTaxBIns1		
			SET @eivav7 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivain8 = @DocTaxBIns1		
			SET @eivav8 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivain9 = @DocTaxBIns1		
			SET @eivav9 = @DocTaxVal1
		END

		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
		SET @fttstamp = 'MSS_' + @DateStr + @TimeStr
		SET @DocTaxBIns1 = @DocTaxBIns1 * @Sinal
		SET @DocTaxVal1 = @DocTaxVal1 *@Sinal

		INSERT INTO ftt(fttstamp, ftstamp, codigo, taxa, ebaseinc, evalor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@fttstamp, @ftstamp, @CodTabIVA, @DocTax1, @DocTaxBIns1, @DocTaxVal1, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF abs(@DocTaxBIns2) > 0  -- quando a base de incidência 2 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax2, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax2, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivain1 = @DocTaxBIns2	
			SET @eivav1 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivain2 = @DocTaxBIns2
			SET @eivav2 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivain3 = @DocTaxBIns2		
			SET @eivav3 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivain4 = @DocTaxBIns2		
			SET @eivav4 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivain5 = @DocTaxBIns2		
			SET @eivav5 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivain6 = @DocTaxBIns2		
			SET @eivav6 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivain7 = @DocTaxBIns2		
			SET @eivav7 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivain8 = @DocTaxBIns2		
			SET @eivav8 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivain9 = @DocTaxBIns2		
			SET @eivav9 = @DocTaxVal2
		END

		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
		SET @fttstamp = 'MSS_' + @DateStr + @TimeStr
		SET @DocTaxBIns2 = @DocTaxBIns2 * @Sinal
		SET @DocTaxVal2 = @DocTaxVal2 *@Sinal
		
		INSERT INTO ftt(fttstamp, ftstamp, codigo, taxa, ebaseinc, evalor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@fttstamp, @ftstamp, @CodTabIVA, @DocTax2, @DocTaxBIns2, @DocTaxVal2, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF abs(@DocTaxBIns3) > 0  -- quando a base de incidência 3 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax3, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax3, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivain1 = @DocTaxBIns3		
			SET @eivav1 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivain2 = @DocTaxBIns3
			SET @eivav2 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivain3 = @DocTaxBIns3
			SET @eivav3 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivain4 = @DocTaxBIns3		
			SET @eivav4 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivain5 = @DocTaxBIns3		
			SET @eivav5 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivain6 = @DocTaxBIns3		
			SET @eivav6 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivain7 = @DocTaxBIns3		
			SET @eivav7 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivain8 = @DocTaxBIns3
			SET @eivav8 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivain9 = @DocTaxBIns3		
			SET @eivav9 = @DocTaxVal3
		END

		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
		SET @fttstamp = 'MSS_' + @DateStr + @TimeStr
		SET @DocTaxBIns3 = @DocTaxBIns3 * @Sinal
		SET @DocTaxVal3 = @DocTaxVal3 * @Sinal
		
		INSERT INTO ftt(fttstamp, ftstamp, codigo, taxa, ebaseinc, evalor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@fttstamp, @ftstamp, @CodTabIVA, @DocTax3, @DocTaxBIns3, @DocTaxVal3, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)

	END

	IF abs(@DocTaxBIns4) > 0  -- quando a base de incidência 4 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax4, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax4, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivain1 = @DocTaxBIns4	
			SET @eivav1 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivain2 = @DocTaxBIns4
			SET @eivav2 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivain3 = @DocTaxBIns4		
			SET @eivav3 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivain4 = @DocTaxBIns4
			SET @eivav4 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivain5 = @DocTaxBIns4
			SET @eivav5 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivain6 = @DocTaxBIns4		
			SET @eivav6 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivain7 = @DocTaxBIns4		
			SET @eivav7 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivain8 = @DocTaxBIns4		
			SET @eivav8 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivain9 = @DocTaxBIns4		
			SET @eivav9 = @DocTaxVal4
		END

		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
		SET @fttstamp = 'MSS_' + @DateStr + @TimeStr
		SET @DocTaxBIns4 = @DocTaxBIns4 * @Sinal
		SET @DocTaxVal4 = @DocTaxVal4 *@Sinal
		
		INSERT INTO ftt(fttstamp, ftstamp, codigo, taxa, ebaseinc, evalor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@fttstamp, @ftstamp, @CodTabIVA, @DocTax4, @DocTaxBIns4, @DocTaxVal4, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	SET @eivain1 = @eivain1 * @sinal
	SET @eivav1 = @eivav1 * @sinal
	SET @eivain2 = @eivain2 * @sinal
	SET @eivav2 = @eivav2 * @sinal
	SET @eivain3 = @eivain3 * @sinal
	SET @eivav3 = @eivav3 * @sinal
	SET @eivain4 = @eivain4 * @sinal
	SET @eivav4 = @eivav4 * @sinal
	SET @eivain5 = @eivain5 * @sinal
	SET @eivav5 = @eivav5 * @sinal
	SET @eivain6 = @eivain6 * @sinal
	SET @eivav6 = @eivav6 * @sinal
	SET @eivain7 = @eivain7 * @sinal
	SET @eivav7 = @eivav7 * @sinal
	SET @eivain8 = @eivain8 * @sinal
	SET @eivav8 = @eivav8 * @sinal
	SET @eivain9 = @eivain9 * @sinal
	SET @eivav9 = @eivav9 * @sinal
	
END

GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFact
-- Integração de cabeçalhos de documentos de facturação
-- *******************************************************************************************************************
-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFactIVAs
-- Ligação dos campos com as bases e valores de IVA do MSS aos do cabeçalho de documentos de facturação do PHC baseado na tabela de taxas de IVA
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocFactMultiIVAs]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@cont_pag INT,
	@eivav1 NUMERIC(19,6) OUTPUT,
	@eivav2 NUMERIC(19,6) OUTPUT,
	@eivav3 NUMERIC(19,6) OUTPUT,
	@eivav4 NUMERIC(19,6) OUTPUT,
	@eivav5 NUMERIC(19,6) OUTPUT,
	@eivav6 NUMERIC(19,6) OUTPUT,
	@eivav7 NUMERIC(19,6) OUTPUT,
	@eivav8 NUMERIC(19,6) OUTPUT,
	@eivav9 NUMERIC(19,6) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CodTabIva CHAR(1)
	DECLARE @DocTax1 NUMERIC(6,2)
	DECLARE @DocTaxBIns1 NUMERIC(19,6)
	DECLARE @DocTaxVal1 NUMERIC(19,6)
	DECLARE @DocTax2 NUMERIC(6,2)
	DECLARE @DocTaxBIns2 NUMERIC(19,6)
	DECLARE @DocTaxVal2 NUMERIC(19,6)
	DECLARE @DocTax3 NUMERIC(6,2)
	DECLARE @DocTaxBIns3 NUMERIC(19,6)
	DECLARE @DocTaxVal3 NUMERIC(19,6)
	DECLARE @DocTax4 NUMERIC(6,2)
	DECLARE @DocTaxBIns4 NUMERIC(19,6)
	DECLARE @DocTaxVal4 NUMERIC(19,6)
	
	SELECT 
		@DocTax1 = ISNULL(DCCTX1, 0),
		@DocTaxBIns1 = ISNULL(DCCBI1, 0),
		@DocTaxVal1 = ISNULL(DCCVI1, 0),
		@DocTax2 = ISNULL(DCCTX2, 0),
		@DocTaxBIns2 = ISNULL(DCCBI2, 0),
		@DocTaxVal2 = ISNULL(DCCVI2, 0),
		@DocTax3 = ISNULL(DCCTX3, 0),
		@DocTaxBIns3 = ISNULL(DCCBI3, 0),
		@DocTaxVal3 = ISNULL(DCCVI3, 0),
		@DocTax4 = ISNULL(DCCTX4, 0),
		@DocTaxBIns4 = ISNULL(DCCBI4, 0),
		@DocTaxVal4 = ISNULL(DCCVI4, 0)
	FROM MSDCC(nolock)
	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC

	SET @eivav1 = 0
	SET @eivav2 = 0
	SET @eivav3 = 0
	SET @eivav4 = 0
	SET @eivav5 = 0
	SET @eivav6 = 0
	SET @eivav7 = 0
	SET @eivav8 = 0
	SET @eivav9 = 0


	IF @DocTaxBIns1 > 0  -- quando a base de incidência 1 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax1, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax1, @CodTabIVA OUTPUT
        
		IF @DocTaxVal1 <> 0
		BEGIN
			SET @DocTaxVal1 = @DocTaxVal1 / @cont_pag
		END

		IF @CodTabIVA = 1
		BEGIN
			SET @eivav1 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivav2 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 3
		BEGIN	
			SET @eivav3 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivav4 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 5	
		BEGIN	
			SET @eivav5 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivav6 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 7	
		BEGIN	
			SET @eivav7 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivav8 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivav9 = @DocTaxVal1
		END
	END

	IF @DocTaxVal2 <> 0
	BEGIN
		SET @DocTaxVal2 = @DocTaxVal2 / @cont_pag
	END

	IF @DocTaxBIns2 > 0  -- quando a base de incidência 2 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax2, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax2, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivav1 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivav2 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 3
		BEGIN	
			SET @eivav3 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 4	
		BEGIN	
			SET @eivav4 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 5	
		BEGIN	
			SET @eivav5 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivav6 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 7	
		BEGIN	
			SET @eivav7 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 8	
		BEGIN	
			SET @eivav8 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 9	
		BEGIN	
			SET @eivav9 = @DocTaxVal2
		END
	END

	IF @DocTaxBIns3 > 0  -- quando a base de incidência 3 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax3, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax3, @CodTabIVA OUTPUT

		IF @DocTaxVal3 <> 0
		BEGIN
			SET @DocTaxVal3 = @DocTaxVal3 / @cont_pag
		END

		IF @CodTabIVA = 1
		BEGIN
			SET @eivav1 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivav2 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivav3 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 4	
		BEGIN	
			SET @eivav4 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivav5 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 6	
		BEGIN	
			SET @eivav6 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 7	
		BEGIN	
			SET @eivav7 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivav8 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 9	
		BEGIN	
			SET @eivav9 = @DocTaxVal3
		END
	END

	IF @DocTaxBIns4 > 0  -- quando a base de incidência 4 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax4, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax4, @CodTabIVA OUTPUT

		IF @DocTaxVal4 <> 0
		BEGIN
			SET @DocTaxVal4 = @DocTaxVal4 / @cont_pag
		END

		IF @CodTabIVA = 1
		BEGIN
			SET @eivav1 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivav2 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 3
		BEGIN	
			SET @eivav3 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivav4 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivav5 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 6	
		BEGIN	
			SET @eivav6 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivav7 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 8	
		BEGIN	
			SET @eivav8 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivav9 = @DocTaxVal4
		END

	END	
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocPag
-- Processamento de multipagamentos
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocPag]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@fdoc INT,
	@DCCNDC INT,
	@moeda VARCHAR(11),
	@ftstamp CHAR(25),
	@fdata datetime
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @contador INT
	DECLARE @lordem INT

	DECLARE @eivav1 NUMERIC(19,6)
	DECLARE @eivav2 NUMERIC(19,6)
	DECLARE @eivav3 NUMERIC(19,6)
	DECLARE @eivav4 NUMERIC(19,6)
	DECLARE @eivav5 NUMERIC(19,6)
	DECLARE @eivav6 NUMERIC(19,6)
	DECLARE @eivav7 NUMERIC(19,6)
	DECLARE @eivav8 NUMERIC(19,6)
	DECLARE @eivav9 NUMERIC(19,6)

	DECLARE @ivav1 NUMERIC(19,6)
	DECLARE @ivav2 NUMERIC(19,6)
	DECLARE @ivav3 NUMERIC(19,6)
	DECLARE @ivav4 NUMERIC(19,6)
	DECLARE @ivav5 NUMERIC(19,6)
	DECLARE @ivav6 NUMERIC(19,6)
	DECLARE @ivav7 NUMERIC(19,6)
	DECLARE @ivav8 NUMERIC(19,6)
	DECLARE @ivav9 NUMERIC(19,6)

	DECLARE @ftccstamp CHAR(25)
	DECLARE @ftrdstamp CHAR(15)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	DECLARE @FirstPagCheque INT

	DECLARE @DCPBAN VARCHAR(30)
	DECLARE @DCPNMC VARCHAR(35)
	DECLARE @clcheque VARCHAR(100)
	DECLARE @clbanco VARCHAR(100)
	DECLARE @DCPDTC VARCHAR(8)
	DECLARE @DCPVLC NUMERIC(18,5)
	DECLARE @DCPVLO NUMERIC(18,5)
	DECLARE @DCPVLD NUMERIC(18,5)
	DECLARE @DCPTIP CHAR(25)
	DECLARE @DCPTERM VARCHAR(4)
	DECLARE @DataCheque DateTime
	DECLARE @ValEsc NUMERIC(18,5)
	DECLARE @deb NUMERIC(18,5)
	DECLARE @edeb NUMERIC(18,5)

	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @cont_cursor INT
	DECLARE @pag VARCHAR(30)
	DECLARE @formapag varchar(100)
	DECLARE @fpag INT

	DECLARE @DCPACL VARCHAR(2000)
 
	SELECT @cont_cursor=COUNT(1) FROM MSDCP(nolock)
	WHERE DCPEXR = @DCCEXR AND DCPTPD = @DCCTPD AND DCPSER = @fdoc AND DCPNDC = @DCCNDC 

	IF @cont_cursor = 1
	BEGIN
		SELECT @PAG=DCPTIP, @clcheque=DCPNMC, @clbanco=DCPBAN, @DCPVLC=DCPVLC, @DCPDTC=DCPDTC FROM MSDCP WHERE DCPEXR = @DCCEXR AND DCPTPD = @DCCTPD AND DCPSER = @fdoc AND DCPNDC = @DCCNDC 

		select @formapag=descricao, @fpag=formapag from tp where tpstamp = @PAG

		IF @DCPVLC > 0 --PHC23
		BEGIN
		    SET @DataCheque=dbo.StringToDate(@DCPDTC)

			UPDATE ft SET tpdesc=@formapag, cdata=@fdata, cheque=1, clbanco=@clbanco, clcheque=@clcheque, echtotal=@DCPVLC, chtotal=dbo.EurToEsc(@DCPVLC), chdata=@DataCheque where ftstamp = @ftstamp
		END
		ELSE
		BEGIN
			UPDATE ft SET tpdesc=@formapag,tpstamp=@PAG where ftstamp = @ftstamp
		END

		UPDATE ft2 set formapag=@fpag where ft2stamp = @ftstamp
	END

	DECLARE curDP CURSOR FOR
	SELECT 
		ISNULL(DCPBAN, ''),
		ISNULL(DCPNMC, ''),
		ISNULL(DCPDTC, ''),
		ISNULL(DCPVLC, 0),
		ISNULL(DCPVLO, 0),
		ISNULL(DCPTIP, ''),
		ISNULL(DCPTERM, 0),
		ISNULL(DCPVLD, 0),
		ISNULL(DCPACL, '')
	FROM MSDCP(nolock)
	WHERE DCPEXR = @DCCEXR AND DCPTPD = @DCCTPD AND DCPSER = @fdoc AND DCPNDC = @DCCNDC
	
	SET @FirstPagCheque = 0
	SET @contador = 0

	OPEN curDP

		FETCH NEXT FROM curDP INTO @DCPBAN, @DCPNMC, @DCPDTC, @DCPVLC, @DCPVLO, @DCPTIP, @DCPTERM, @DCPVLD, @DCPACL
		
		/*Se devolver resultados e for multi pagamento*/
		WHILE @@FETCH_STATUS = 0 AND @cont_cursor > 1 BEGIN
			BEGIN TRY
			
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()

				SET @FirstPagCheque = @FirstPagCheque + 1	
				SET @contador = @contador + 1 	
				SET @lordem = 10000 * @contador		

				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

				
				SET @ftrdstamp = 'MSS_' + @DateStr + @TimeStr
				
				SET @ftccstamp = rtrim(@ftstamp) + '_' + CAST(@contador AS VARCHAR(2))

				SET @ousrinis = 'MSS T-' + CAST(@DCPTERM AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DCPTERM AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr
				
				SET @DataCheque = dbo.StringToDate(@DCPDTC)
				SET @ValEsc = dbo.EurToEsc(@DCPVLC)

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				IF @DCPVLC > 0
				BEGIN
					SET @clcheque = @DCPNMC
					SET @clbanco = @DCPBAN
					SET @deb = dbo.EurToEsc(@DCPVLC)
					SET @edeb = @DCPVLC
				END
				ELSE IF @DCPVLD > 0
				BEGIN
					SET @clcheque = ''
					SET @clbanco = ''
					SET @deb = dbo.EurToEsc(@DCPVLD)
					SET @edeb = @DCPVLD
				END
				ELSE
				BEGIN
					SET @clcheque = ''
					SET @clbanco = ''
					SET @deb = dbo.EurToEsc(@DCPVLO)
					SET @edeb = @DCPVLO
				END

				EXECUTE SPMSS_DocFactMultiIVAs @DCCEXR,@DCCTPD,@fdoc,@DCCNDC, @cont_cursor, @eivav1 OUTPUT, @eivav2 OUTPUT, @eivav3 OUTPUT, @eivav4 OUTPUT, @eivav5 OUTPUT, @eivav6 OUTPUT, @eivav7 OUTPUT, @eivav8 OUTPUT, @eivav9 OUTPUT

				SET @ivav1 = dbo.EurToEsc(@eivav1)
				SET @ivav2 = dbo.EurToEsc(@eivav2)
				SET @ivav3 = dbo.EurToEsc(@eivav3)
				SET @ivav4 = dbo.EurToEsc(@eivav4)
				SET @ivav5 = dbo.EurToEsc(@eivav5)
				SET @ivav6 = dbo.EurToEsc(@eivav6)
				SET @ivav7 = dbo.EurToEsc(@eivav7)
				SET @ivav8 = dbo.EurToEsc(@eivav8)
				SET @ivav9 = dbo.EurToEsc(@eivav9)

				/*Colocar o pagamento como multipagamento*/
			    UPDATE ft SET multi=1 where ftstamp = @ftstamp;
				
				IF dbo.ExtractFromACL(@DCPACL, 3) = 'R'
				BEGIN
					DECLARE @NDocOrig AS INT
					DECLARE @DocNumOrig AS INT
					DECLARE @DocAnoOrig AS INT
					DECLARE @DocTipoOrig VARCHAR(10)
					DECLARE @DocSerOrig VARCHAR(4)

					DECLARE @cdesc VARCHAR(20)
					DECLARE @nrdoc BIGINT
					DECLARE @datalc DATETIME
					DECLARE @dataven DATETIME
					DECLARE @ccstamp CHAR(25)
					DECLARE @cm INT
					DECLARE @eivavori1 NUMERIC(19,6)
					DECLARE @ivavori1 NUMERIC(18,5)
					DECLARE @eivavori2 NUMERIC(19,6)
					DECLARE @ivavori2 NUMERIC(18,5)
					DECLARE @eivavori3 NUMERIC(19,6)
					DECLARE @ivavori3 NUMERIC(18,5)
					DECLARE @eivavori4 NUMERIC(19,6)
					DECLARE @ivavori4 NUMERIC(18,5)
					DECLARE @eivavori5 NUMERIC(19,6)
					DECLARE @ivavori5 NUMERIC(18,5)
					DECLARE @eivavori6 NUMERIC(19,6)
					DECLARE @ivavori6 NUMERIC(18,5)
					DECLARE @eivavori7 NUMERIC(19,6)
					DECLARE @ivavori7 NUMERIC(18,5)
					DECLARE @eivavori8 NUMERIC(19,6)
					DECLARE @ivavori8 NUMERIC(18,5)
					DECLARE @eivavori9 NUMERIC(19,6)
					DECLARE @ivavori9 NUMERIC(18,5)
					DECLARE @CCIvaTx1 NUMERIC(5,2)
					DECLARE @CCIvaTx2 NUMERIC(5,2)
					DECLARE @CCIvaTx3 NUMERIC(5,2)
					DECLARE @CCIvaTx4 NUMERIC(5,2)
					DECLARE @CCIvaTx5 NUMERIC(5,2)
					DECLARE @CCIvaTx6 NUMERIC(5,2)
					DECLARE @CCIvaTx7 NUMERIC(5,2)
					DECLARE @CCIvaTx8 NUMERIC(5,2)
					DECLARE @CCIvaTx9 NUMERIC(5,2)

					DECLARE @DocNome VARCHAR(20)
					DECLARE @DocArmazem VARCHAR(10)
					DECLARE @DocTipoDoc VARCHAR(1)
					DECLARE @DocTipoDocFor VARCHAR(1)
					DECLARE @DocPCusto INT
					DECLARE @lifref INT
					DECLARE @stocks INT
					DECLARE @bdemp VARCHAR(2)
					DECLARE @fref VARCHAR(2)
					DECLARE @cred NUMERIC(18,5)
					DECLARE @ecred NUMERIC(19,6)
					DECLARE @ano INT

					SET @DocTipoOrig = dbo.ExtractFromACL(@DCPACL, 9)
					SET @DocSerOrig = dbo.ExtractFromACL(@DCPACL, 10)
					SET @DocNumOrig = dbo.ExtractFromACL(@DCPACL, 11)
					SET @ano = dbo.ExtractFromACL(@DCPACL, 8)

					EXECUTE SPMSS_GetDadosDoc 2, @DocTipoOrig, @DocSerOrig, @NDocOrig OUTPUT, @DocNome OUTPUT, @DocTipoDocFor OUTPUT, @DocTipoDoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT
					
					EXECUTE SPMSS_GetCCInfo2 @NDocOrig, @DocNumOrig, @ano, @cdesc OUTPUT, @nrdoc OUTPUT, @datalc OUTPUT, @dataven OUTPUT, @ccstamp OUTPUT, @cm OUTPUT, @eivavori1 OUTPUT, @ivavori1 OUTPUT, @eivavori2 OUTPUT, @ivavori2 OUTPUT, @eivavori3 OUTPUT, @ivavori3 OUTPUT, @eivavori4 OUTPUT, @ivavori4 OUTPUT, @eivavori5 OUTPUT, @ivavori5 OUTPUT, @eivavori6 OUTPUT, @ivavori6 OUTPUT, @eivavori7 OUTPUT, @ivavori7 OUTPUT, @eivavori8 OUTPUT, @ivavori8 OUTPUT, @eivavori9 OUTPUT, @ivavori9 OUTPUT, @CCIvaTx1 OUTPUT, @CCIvaTx2 OUTPUT, @CCIvaTx3 OUTPUT, @CCIvaTx4 OUTPUT, @CCIvaTx5 OUTPUT, @CCIvaTx6 OUTPUT, @CCIvaTx7 OUTPUT, @CCIvaTx8 OUTPUT, @CCIvaTx9 OUTPUT, @fref OUTPUT, @cred OUTPUT, @datalc OUTPUT, @ecred OUTPUT, @moeda OUTPUT
			
					INSERT INTO ftrd(ftrdstamp,cdesc,nrdoc,fref,vemissao,vreg,datalc,ftstamp,ccstamp,evemissao,evreg,moeda,ivav1,eivav1,ivav2,eivav2,ivav3,eivav3,ivav4,eivav4,ivav5,eivav5,ivav6,eivav6,ivav7,eivav7,ivav8,eivav8,ivav9,eivav9,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora)
					VALUES(@ftrdstamp,@cdesc,@nrdoc,@fref,@cred,@cred,@datalc,@ftstamp,@ccstamp,@ecred,@ecred,@moeda,@ivavori1,@eivavori1,@ivavori2,@eivavori2,@ivavori3,@eivavori3,@ivavori4,@eivavori4,@ivavori5,@eivavori5,@ivavori6,@eivavori6,@ivavori7,@eivavori7,@ivavori8,@eivavori8,@ivavori9,@eivavori9, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
				END
				ELSE
				BEGIN

					SELECT @formapag=formapag from tp where tpstamp=@DCPTIP

					INSERT INTO ftcc(ftccstamp, dataven, deb, edeb, ftstamp, ivav1, ivav2, ivav3, ivav4, ivav5, ivav6, ivav7, ivav8, ivav9, eivav1, eivav2, eivav3, eivav4, eivav5, eivav6, eivav7, eivav8, eivav9, lordem, clbanco, clcheque, debcc, edebcc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora,formapag) 
					VALUES (@ftccstamp, @DataCheque, @deb, @edeb, @ftstamp, @ivav1, @ivav2, @ivav3, @ivav4, @ivav5, @ivav6, @ivav7, @ivav8, @ivav9, @eivav1, @eivav2, @eivav3, @eivav4, @eivav5, @eivav6, @eivav7, @eivav8, @eivav9, @lordem, @clbanco,@clcheque, @deb, @edeb, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @formapag)

				END


			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curDP INTO @DCPBAN, @DCPNMC, @DCPDTC, @DCPVLC, @DCPVLO, @DCPTIP, @DCPTERM, @DCPVLD, @DCPACL
		END
	FIM:
		CLOSE curDP
		DEALLOCATE curDP
END

GO
-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFact
-- Integração de cabeçalhos de documentos de facturação
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocFact]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@EstabSeparator CHAR(1),
	@Imp1 CHAR(10),
	@Imp2 CHAR(10),
	@Imp3 CHAR(10),
	@ValidateDocLines INT,
	@ValidateDocSequence INT,
	@ValidateDocTotals NUMERIC(19,6),
	@memissao VARCHAR(15) = 'EURO'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @CliNumTmp VARCHAR(20)
	DECLARE @CliLocEnt VARCHAR(20)
	DECLARE @CondVendTmp VARCHAR(30)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocDataVenc VARCHAR(8)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocArmazem INT
	DECLARE @CodTabIva CHAR(1)
	
	DECLARE @CliNome VARCHAR(55)
	DECLARE @CliMorada VARCHAR(55)
	DECLARE @CliLocal VARCHAR(43)
	DECLARE @CliCPostal VARCHAR(45)
	DECLARE @CliNCont VARCHAR(18)
	DECLARE @CliPais INT
	DECLARE @CliLocTesoura VARCHAR(50)
	DECLARE @CliContado INT
	DECLARE @DocDesc NUMERIC(19,6)
	DECLARE @DocAnul CHAR(1)
	DECLARE @DocMotivoAnul VARCHAR(3)
	DECLARE @DESCDocMotivoAnul VARCHAR(60)
	DECLARE @DCCDCG NUMERIC(18,5)
	DECLARE @StatusErrorLines INT
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	DECLARE @DocAssinatura VARCHAR(1000)
	DECLARE @DocVsAssinatura VARCHAR(50)
	DECLARE @DocTipoSAFT VARCHAR(10)
	DECLARE @horasl VARCHAR(8)
	DECLARE @DocACL VARCHAR(2000)

	DECLARE @ftstamp CHAR(25)
	DECLARE @anulado INT
	DECLARE @pais INT
	DECLARE @nmdoc VARCHAR(20)
	DECLARE @fno INT
	DECLARE @no INT
	DECLARE @ndoc INT
	DECLARE @vendedor INT 
	DECLARE @vendnm VARCHAR(20)
	DECLARE @fdata DATETIME
	DECLARE @ftano INT
	DECLARE @pdata DATETIME
	DECLARE @nome VARCHAR(55)
	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @moeda VARCHAR(11)
	DECLARE @ncont VARCHAR(18)
	DECLARE @telefone VARCHAR(60)
	DECLARE @estab INT
	DECLARE @segmento VARCHAR(25) 
	DECLARE @tipo VARCHAR(20)
	DECLARE @zona VARCHAR(13)
	DECLARE @tipodoc INT
	DECLARE @tipodocFor INT
	DECLARE @tpstamp CHAR(25)
	DECLARE @tpdesc VARCHAR(55)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @eivain1 NUMERIC(19,6)
	DECLARE @eivav1 NUMERIC(19,6)
	DECLARE @eivain2 NUMERIC(19,6)
	DECLARE @eivav2 NUMERIC(19,6)
	DECLARE @eivain3 NUMERIC(19,6)
	DECLARE @eivav3 NUMERIC(19,6)
	DECLARE @eivain4 NUMERIC(19,6)
	DECLARE @eivav4 NUMERIC(19,6)
	DECLARE @eivain5 NUMERIC(19,6)
	DECLARE @eivav5 NUMERIC(19,6)
	DECLARE @eivain6 NUMERIC(19,6)
	DECLARE @eivav6 NUMERIC(19,6)
	DECLARE @eivain7 NUMERIC(19,6)
	DECLARE @eivav7 NUMERIC(19,6)
	DECLARE @eivain8 NUMERIC(19,6)
	DECLARE @eivav8 NUMERIC(19,6)
	DECLARE @eivain9 NUMERIC(19,6)
	DECLARE @eivav9 NUMERIC(19,6)
	DECLARE @ivatx1 NUMERIC(5,2)
	DECLARE @ivatx2 NUMERIC(5,2)
	DECLARE @ivatx3 NUMERIC(5,2)
	DECLARE @ivatx4 NUMERIC(5,2)
	DECLARE @ivatx5 NUMERIC(5,2)
	DECLARE @ivatx6 NUMERIC(5,2)
	DECLARE @ivatx7 NUMERIC(5,2)
	DECLARE @ivatx8 NUMERIC(5,2)
	DECLARE @ivatx9 NUMERIC(5,2)
	DECLARE @ettiliq NUMERIC(19,6)
	DECLARE @edescc NUMERIC(19,6)
	DECLARE @ettiva NUMERIC(19,6)
	DECLARE @etotal NUMERIC(19,6)
	DECLARE @totqtt NUMERIC(15,3)
	DECLARE @qtt1 NUMERIC(16,3)
	DECLARE @etot1 NUMERIC(19,6)
	DECLARE @ArmOrigem VARCHAR(30)
	DECLARE @ArmDestino VARCHAR(30)
	DECLARE @efinv NUMERIC(19,6)
	DECLARE @fin NUMERIC(19,6)
	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)
	DECLARE @Sinal NUMERIC(6,2)

	DECLARE @moradaentrega VARCHAR(55)
	DECLARE @localentrega VARCHAR(43)
	DECLARE @codpostentrega VARCHAR(45)

	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT

	DECLARE @atcodeid VARCHAR(200)
	DECLARE @cladrsdesc VARCHAR(50)
	DECLARE @cladrsstamp CHAR(25)
	DECLARE @cdata DATETIME
	DECLARE @chora VARCHAR(8)
	DECLARE @reexgiva INT
	DECLARE @saida VARCHAR(5) 
	DECLARE @motiseimp VARCHAR(60)
	DECLARE @codmotiseimp VARCHAR(3)
	DECLARE @DESCREGIVA VARCHAR(60)
	DECLARE @CODPAIS VARCHAR(60)
	DECLARE @DESCRPAIS VARCHAR(60)
	DECLARE @DCCLCE VARCHAR(20)

	DECLARE @InvoiceNo VARCHAR(60)
	DECLARE @ATCUD VARCHAR(100)
	DECLARE @bdemp VARCHAR(2)
	
	DECLARE @contImp INT
	DECLARE @TabIva INT
	
	/*Impostos*/
	DECLARE @dcci1v NUMERIC(19,6)
	DECLARE @dcci2v NUMERIC(19,6)
	DECLARE @dcci3v NUMERIC(19,6)
	DECLARE @ecovalor NUMERIC(19,6)
	
	/*Validações*/
	DECLARE @DCCPNS CHAR(1)
	DECLARE @DCCTDC NUMERIC(19,6)
	DECLARE @DOCValorizado CHAR(1)
	DECLARE @ContAnt INT
	DECLARE @ContLinhas INT
	DECLARE @ContLinhasTerminal INT
	DECLARE @TotalDOC NUMERIC(19,6)
	DECLARE @DiffVAL NUMERIC(19,6)
	DECLARE @Msg VARCHAR(200)
	DECLARE @MsgErro VARCHAR(200)
	DECLARE @DOC VARCHAR(80)

		/*ANULAÇÃO*/
	DECLARE @DCCDAN VARCHAR(9)
	DECLARE @DCCHRA VARCHAR(8)
	DECLARE @anulhora VARCHAR(8)
	DECLARE @anulinis VARCHAR(50)
	
	DECLARE curCabFT CURSOR FOR
	SELECT 
		ISNULL(DCCANU, 'N'),
		ISNULL(DCCMTA, ''),
		ISNULL(DCCNDC, 0),
		ISNULL(DCCDTA, ''),
		ISNULL(DCCCLI, ''),
		ISNULL(DCCNOM, ''),
		ISNULL(DCCMOR, ''),
		ISNULL(DCCLOC, ''),
		ISNULL(DCCCPT, ''),
		ISNULL(DCCNCT, ''),
		ISNULL(DCCVND, ''),
		ISNULL(DCCTERM, 0),
		ISNULL(DCCDTV, ''),
		ISNULL(DCCCVD, ''),
		ISNULL(DCCVLL, 0),
		ISNULL(DCCVDL, 0), 
		ISNULL(DCCVIV, 0),
		ISNULL(DCCDCG, 0), 
		ISNULL(DCCARO, ''),
		ISNULL(DCCARD, ''),
		ISNULL(DCCDPP, 0),
		ISNULL(DCCVPP, 0),
		ISNULL(DCCSIG, ''),
		ISNULL(DCCSIV, 0),
		ISNULL(DCCTSF, ''),
		ISNULL(DCCHOR, ''),
		ISNULL(DCCEMO, ''),
		ISNULL(DCCELO, ''),
		ISNULL(DCCECP, ''),
		ISNULL(DCCACL, ''),
		ISNULL(DCCREG, ''),
		ISNULL(DCCPAI, ''),
		ISNULL(DCCLCE, ''),
		ISNULL(DCCI1V,0),
		ISNULL(DCCI2V,0),
		ISNULL(DCCI3V,0),
		ISNULL(DCCPNS,'N'),
		ISNULL(DCCTDC,0),
		ISNULL(DCCDAN, ''),
		ISNULL(DCCHRA, '')

	FROM MSDCC(nolock)
	WHERE DCCSYNCR = 'N' AND DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC ORDER BY DCCDTA, DCCHOR

	OPEN curCabFT
		FETCH NEXT FROM curCabFT INTO @DocAnul, @DocMotivoAnul, @fno, @fdata, @CliNumTmp, @nome, @morada, @local, @codpost, @ncont, @vendedor, @DocTerminal, @DocDataVenc, @CondVendTmp, @ettiliq, @edescc, @ettiva, @DCCDCG, @ArmOrigem, @ArmDestino, @fin, @efinv, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @moradaentrega, @localentrega, @codpostentrega, @DocACL, @DESCREGIVA, @CODPAIS, @DCCLCE, @dcci1v, @dcci2v, @dcci3v, @DCCPNS, @DCCTDC, @DCCDAN, @DCCHRA
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY			
				BEGIN TRANSACTION
				
				EXECUTE SPMSS_GetDadosDoc 2, @DCCTPD, @DCCSER, @ndoc OUTPUT, @nmdoc OUTPUT, @tipodocFor OUTPUT, @tipodoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT

				select @contImp = count(1) from td where docsimport=1 and ndoc=@ndoc

				if (@contImp = 0 and @DocTipoSAFT<>'')
					RAISERROR('A série não está configurada para documentos importados para o documento!',16,1)
					
				IF (@dcci1v > 0 AND @Imp1='')
					RAISERROR('Documento com imposto 1 sem estar configurado!',16,1)

				IF (@dcci2v > 0 AND @Imp2='')
					RAISERROR('Documento com imposto 2 sem estar configurado!',16,1)

				IF (@dcci3v > 0 AND @Imp3='')
					RAISERROR('Documento com imposto 3 sem estar configurado!',16,1)

				SET @ecovalor = 0
				
				
				IF CHARINDEX(@EstabSeparator, @CliNumTmp) > 0
				BEGIN
					SET @no = CAST(LEFT(@CliNumTmp, CHARINDEX(@EstabSeparator, @CliNumTmp) - 1) AS INT)
					SET @estab = CAST(RIGHT(@CliNumTmp, LEN(@CliNumTmp) - CHARINDEX(@EstabSeparator, @CliNumTmp)) AS INT)
				END
				ELSE
				BEGIN
					SET @no = CAST(@CliNumTmp AS INT)
					SET @estab = 0
				END
				IF (@DCCLCE <> '') AND (CHARINDEX('LCD_ID_', @DCCLCE) > 0)
					SET @DCCLCE = REPLACE(@DCCLCE, 'LCD_ID_', '')
				IF ((@estab <= 0) AND (CAST(@DCCLCE AS INT) > 0))
					SET @estab = CAST(@DCCLCE AS INT)

				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @ftstamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				--2017-09-05 SE O DOCUMENTO TEM DESCONTO DE CABEÇALHO NÃO INTEGRA
				IF @fin > 0
					RAISERROR('O desconto PP não é suportado na integração com PHC. Contacte o suporte técnico da Sysdev',10,1)


				--2017-07-24 ALTERADO PARA INTEGRAR A DATA E HORA DO DOCUMENTO
				SET @ousrdata = @fdata
				SET @usrdata = @fdata

				SET @ousrhora = LEFT(@horasl, 2) + ':' + SUBSTRING(@horasl, 3, 2) + ':' + SUBSTRING(@horasl, 5, 2)
				SET @usrhora = LEFT(@horasl, 2) + ':' + SUBSTRING(@horasl, 3, 2) + ':' + SUBSTRING(@horasl, 5, 2)

				SET @horasl = LEFT(@horasl, 2) + ':' + SUBSTRING(@horasl, 3, 2) + ':' + SUBSTRING(@horasl, 5, 2)
				SET @saida = LEFT(@horasl, 5)
				SET @ftano = YEAR(@fdata)

				
				IF dbo.ExtractFromACL(@DocACL, 67) <> ''
					SET @InvoiceNO = dbo.ExtractFromACL(@DocACL, 67)
				ELSE
					SET @InvoiceNO = @DCCTPD + ' ' + @DCCSER + '/' + CAST(@fno AS VARCHAR(48))

				SET @ATCUD =dbo.ExtractFromACL(@DocACL, 59)

				/*Validar se o documento anterior existe, caso o parâmetro @ValidateDocSequence está a 1 e senão é o primeiro número da série*/
				IF (@ValidateDocSequence = 1 and @DCCPNS<>'S' AND @fno > 1)
				BEGIN
					SELECT @ContAnt = COUNT(1) FROM ft (NOLOCK) WHERE ndoc=@ndoc and ftano=@ftano and fno=(@fno - 1)

					SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' FTSTAMP = ' + @ftstamp
					SET @MsgErro = @DOC + ' Documento anterior não existe!'

					if @ContAnt = 0
						RAISERROR(@MsgErro,16,1)
				END
				
				IF @tipodoc = 3	 --******************* Quando são notas de crédito os totais têm de ser integrados com sinal negativo
					SET @Sinal = -1
				ELSE
					SET @Sinal = 1
				
				if (upper(@Imp1) = 'ECOVALOR' and @dcci1v>0)
					SET @ecovalor = @dcci1v
				else if (upper(@Imp2) = 'ECOVALOR' and @dcci2v>0)
					SET @ecovalor = @dcci2v
				else if (upper(@Imp3) = 'ECOVALOR' and @dcci3v>0)
					SET @ecovalor = @dcci3v
				
				IF @ecovalor > 0
					SET @ettiliq = (@ettiliq + @ecovalor) * @Sinal
				ELSE
					SET @ettiliq = @ettiliq * @Sinal
					
				SET @ettiva = @ettiva * @Sinal
				SET @edescc = @edescc * @Sinal
				
				EXECUTE SPMSS_GetVendNome @vendedor, @vendnm OUTPUT
				
				EXECUTE SPMSS_GetCliInfo2 @no, @estab, @tipo OUTPUT, @zona OUTPUT, @segmento OUTPUT, @telefone OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @CliLocTesoura OUTPUT, @CliContado OUTPUT, @fref OUTPUT, @ccusto OUTPUT, @TabIva  OUTPUT

				EXECUTE SPMSS_GetCondVend @CondVendTmp, @tpstamp OUTPUT, @tpdesc OUTPUT
				if @tpstamp is null
                    set @tpstamp = ''
                
                if @tpdesc is null
                    set @tpdesc = ''
				SET @pdata = dbo.StringToDate(@DocDataVenc)
				
				EXECUTE SPMSS_GetTaxaIVA 1, @ivatx1 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 2, @ivatx2 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 3, @ivatx3 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 4, @ivatx4 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 5, @ivatx5 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 6, @ivatx6 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 7, @ivatx7 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 8, @ivatx8 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 9, @ivatx9 OUTPUT

				SET @etotal = (@ettiliq + @ettiva)
				SET @etot1 = @ettiliq
				IF @telefone IS NULL SET @telefone = ' '

				SELECT @totqtt=SUM(DCLQTD) FROM MSDCL(nolock) WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @fno
				SET @qtt1 = @totqtt
				
				
				-- Número do programa certificado
				IF @DocAssinatura <> ''
				BEGIN
					IF dbo.ExtractFromACL(@DocACL, 2) <> ''
						SET @DocVsAssinatura  = dbo.ExtractFromACL(@DocACL, 2)  + @DocVsAssinatura
					ELSE
						SET @DocVsAssinatura = '0240.' + @DocVsAssinatura
				END
				ELSE
				BEGIN
					SET @DocVsAssinatura = ''
				END

				IF (@moradaentrega = '') AND (@localentrega = '') AND (@codpostentrega = '')
				BEGIN
					SET @moradaentrega = @morada
					SET @localentrega = @local
					SET @codpostentrega = @codpost
				END
				-- testar se documento tem cód AT
				IF dbo.ExtractFromACL(@DocACL, 13) <> ''
				BEGIN
					SET @atcodeid = dbo.ExtractFromACL(@DocACL, 13)
					SET @cdata = dbo.StringToDate(dbo.ExtractFromACL(@DocACL, 21))
					SET @chora = LEFT(dbo.ExtractFromACL(@DocACL, 22), 4)
				END
				ELSE
				BEGIN
					SET @atcodeid = ''
					SET @cdata = 0
					SET @chora = ''
				END
				
				-- testar se é factura em regime de iva de caixa
				IF dbo.ExtractFromACL(@DocACL, 28) = 'S'
					SET @reexgiva = 1
				ELSE
					SET @reexgiva = 0
				-- verificar se existem linhas com IVA 0 para preencher na ft2 o motivo de isenção e respectivo código
				SELECT TOP 1 @motiseimp = DCLPLI, @codmotiseimp = dbo.ExtractFromACL(DCLACL, 12) FROM MSDCL WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @fno AND DCLPLI <> ''
				IF @motiseimp IS NULL
				BEGIN
					SET @motiseimp = ''
					SET @codmotiseimp = ''
				END

				SELECT @DESCRPAIS=nome FROM paises WHERE nomeabrvsaft=@CODPAIS
				IF @DESCRPAIS IS NULL
				BEGIN
					SET @DESCRPAIS = ''
				END

				IF (@DESCREGIVA = '')
				BEGIN
					SELECT @DESCREGIVA = CL.DESCREGIVA FROM CL WHERE CL.no = @no
				END

				INSERT INTO ft2 (ft2stamp, assinatura, versaochave, tiposaft, horasl, moradaentrega, locallocent, codpentrega, morada, local, codpost, atcodeid, reexgiva, motiseimp, codmotiseimp, DESCREGIVA, ettecoval, ttecoval, ettecoval2, ttecoval2) VALUES (@ftstamp, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @morada, @local, @codpost, @morada, @local, @codpost, @atcodeid, @reexgiva, @motiseimp, @codmotiseimp, @DESCREGIVA, @ecovalor, dbo.EurToEsc(@ecovalor), @ecovalor, dbo.EurToEsc(@ecovalor))

				IF ((@DocAnul = 'S') and (@DocMotivoAnul <> ''))
				BEGIN
					SET @DESCDocMotivoAnul = dbo.ExtractFromACL(@DocACL, 11)
					IF @DESCDocMotivoAnul IS NULL
						SET @DESCDocMotivoAnul = ''

					IF (@DCCDAN = '')
						SET @DCCDAN = @fdata

					IF (@DCCHRA <> '')
					BEGIN
						IF (@DCCHRA <> '')
						BEGIN
							IF (LEN(@DCCHRA) > 4)
								SET @anulhora = LEFT(@DCCHRA, 2) + ':' + SUBSTRING(@DCCHRA, 3, 2) + ':' + SUBSTRING(@DCCHRA, 5, 2)
							ELSE
								SET @anulhora = LEFT(@DCCHRA, 2) + ':' + SUBSTRING(@DCCHRA, 3, 2)
						END
					ELSE
						SET @anulhora = ''
					END
					SET @anulinis = dbo.ExtractFromACL(@DocACL, 12)

				END
				ELSE
				BEGIN
					SET @DESCDocMotivoAnul = ''
					SET @DCCDAN = ''
					SET @anulhora = ''
					SET @anulinis = ''
				END

				INSERT INTO ft3 (ft3stamp,codpais,descpais,ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, invoicenoori, motanul, anuldata, anulhora, anulinis, atcud) VALUES(@ftstamp, @CODPAIS, @DESCRPAIS, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @InvoiceNO, @DESCDocMotivoAnul, @DCCDAN, @anulhora, @anulinis, @atcud)

				EXECUTE SPMSS_DocDocFactIVAs @DCCEXR,@DCCTPD,@DCCSER,@fno,@ftstamp,@sinal, @eivain1 OUTPUT, @eivav1 OUTPUT, @eivain2 OUTPUT, @eivav2 OUTPUT, @eivain3 OUTPUT, @eivav3 OUTPUT, @eivain4 OUTPUT, @eivav4 OUTPUT, @eivain5 OUTPUT, @eivav5 OUTPUT, @eivain6 OUTPUT, @eivav6 OUTPUT, @eivain7 OUTPUT, @eivav7 OUTPUT, @eivain8 OUTPUT, @eivav8 OUTPUT, @eivain9 OUTPUT, @eivav9 OUTPUT, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora 				

				IF @DocAnul = 'S'
					INSERT INTO ft (ftstamp, anulado, pais, nmdoc, fno, no, ndoc, vendedor, vendnm, fdata, ftano, pdata, nome, morada, local, codpost, ncont, telefone, moeda, qtt1, totqtt, estab, etot1, segmento, tipo, zona, tipodoc, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, eivain1, eivav1, eivain2, eivav2, eivain3, eivav3, eivain4, eivav4, eivain5, eivav5, eivain6, eivav6, eivain7, eivav7, eivain8, eivav8, eivain9, eivav9, ivatx1, ivatx2, ivatx3, ivatx4, ivatx5, ivatx6, ivatx7, ivatx8, ivatx9, memissao, cdata, chora, saida,ettiliq, edescc, ettiva, etotal) 
					VALUES (@ftstamp, 1, 1, @nmdoc, @fno, @no, @ndoc, @vendedor, @vendnm, @fdata, @ftano, @pdata, @nome, @morada, @local, @codpost, @ncont, @telefone, @moeda, @qtt1, @totqtt, @estab, @etot1, @segmento, @tipo, @zona, @tipodoc, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @eivain1, @eivav1, @eivain2, @eivav2, @eivain3, @eivav3, @eivain4, @eivav4, @eivain5, @eivav5, @eivain6, @eivav6, @eivain7, @eivav7, @eivain8, @eivav8, @eivain9, @eivav9, @ivatx1, @ivatx2, @ivatx3, @ivatx4, @ivatx5, @ivatx6, @ivatx7, @ivatx8, @ivatx9, @memissao, @cdata, @chora, @saida, @ettiliq, @edescc, @ettiva, @etotal) 
				ELSE
					INSERT INTO ft (ftstamp, anulado, pais, nmdoc, fno, no, ndoc, vendedor, vendnm, fdata, ftano, pdata, nome, morada, local, codpost, ncont, telefone, moeda, qtt1, totqtt, estab, etot1, segmento, tipo, zona, tipodoc, ettiliq, edescc, ettiva, etotal, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, efinv, introfin, fin, eivain1, eivav1, eivain2, eivav2, eivain3, eivav3, eivain4, eivav4, eivain5, eivav5, eivain6, eivav6, eivain7, eivav7, eivain8, eivav8, eivain9, eivav9, ivatx1, ivatx2, ivatx3, ivatx4, ivatx5, ivatx6, ivatx7, ivatx8, ivatx9, memissao, cdata, chora, saida, fref, ccusto) 
					VALUES (@ftstamp, 0, 1, @nmdoc, @fno, @no, @ndoc, @vendedor, @vendnm, @fdata, @ftano, @pdata, @nome, @morada, @local, @codpost, @ncont, @telefone, @moeda, @qtt1, @totqtt, @estab, @etot1, @segmento, @tipo, @zona, @tipodoc, @ettiliq, @edescc, @ettiva, @etotal, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @efinv, 0, @fin, @eivain1, @eivav1, @eivain2, @eivav2, @eivain3, @eivav3, @eivain4, @eivav4, @eivain5, @eivav5, @eivain6, @eivav6, @eivain7, @eivav7, @eivain8, @eivav8, @eivain9, @eivav9, @ivatx1, @ivatx2, @ivatx3, @ivatx4, @ivatx5, @ivatx6, @ivatx7, @ivatx8, @ivatx9, @memissao, @cdata, @chora, @saida, @fref, @ccusto)
				
				EXEC SPMSS_DocDocFactUSR @DCCEXR,@DCCTPD,@DCCSER,@fno,@ftstamp,@no				

				DECLARE @DEVOLUCAO CHAR(1)
				SET @DEVOLUCAO = dbo.ExtractFromACL(@DocACL, 27)
				EXECUTE SPMSS_DocDocFactLin @DCCEXR, @DCCTPD, @DCCSER, @fno, @ftstamp, @fdata, @DCCDCG, @ArmOrigem, @ArmDestino, @DocTipoSAFT, @no, @estab, @nome, @DocAnul, @Imp1, @Imp2, @Imp3, @DEVOLUCAO
				
				SET @DOCValorizado = dbo.ExtractFromACL(@DocACL, 25)

				IF(@ValidateDocTotals >= 0 AND @DOCValorizado = 'S')
				BEGIN
					/*Obter o total do documento do PHC*/
					SELECT @TotalDOC=etotal FROM FT WHERE ftstamp=@ftstamp

					SET @DCCTDC = @DCCTDC * @Sinal


					SET @DiffVAL = ABS(@DCCTDC - @TotalDOC)

					SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' FTSTAMP = ' + @ftstamp
					SET @MsgErro = @DOC + ' A diferença do documento do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)

					EXECUTE SPMSS_DocDocFactValIVAs @DCCEXR,@DCCTPD,@DCCSER,@fno,@ftstamp,@sinal, @ValidateDocTotals, @Msg OUT

					IF (@Msg<>'')
						RAISERROR(@Msg,16,1)
				END

				IF @ValidateDocLines = 1
				BEGIN
					IF dbo.ExtractFromACL(@DocACL, 46) <> ''
					BEGIN
						SET @ContLinhasTerminal = CAST(dbo.ExtractFromACL(@DocACL, 46) AS INT)

						SELECT @ContLinhas = count(1) FROM fi WHERE ftstamp= @ftstamp

						SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' FTSTAMP = ' + @ftstamp
						SET @MsgErro = @DOC + ' Nº de linhas inserido no PHC (' + CAST(@ContLinhas AS VARCHAR(10)) + ') é diferente do número de linhas geradas no terminal (' + CAST(@ContLinhasTerminal AS VARCHAR(10)) + ')'


						if @ContLinhas <> @ContLinhasTerminal
							RAISERROR(@MsgErro,16,1)
					END
				END
				
				EXECUTE SPMSS_DocPag @DCCEXR, @DCCTPD, @ndoc, @fno, @moeda, @ftstamp, @fdata
				
				UPDATE MSDCC Set DCCSYNCR='S' WHERE DCCEXR=@DCCEXR AND DCCTPD=@DCCTPD And DCCSER=@DCCSER And DCCNDC=@fno
				UPDATE MSDCL Set DCLSYNCR='S' WHERE DCLEXR=@DCCEXR AND DCLTPD=@DCCTPD And DCLSER=@DCCSER And DCLNDC=@fno
		
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				ROLLBACK TRANSACTION
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curCabFT INTO @DocAnul, @DocMotivoAnul, @fno, @fdata, @CliNumTmp, @nome, @morada, @local, @codpost, @ncont, @vendedor, @DocTerminal, @DocDataVenc, @CondVendTmp, @ettiliq, @edescc, @ettiva, @DCCDCG, @ArmOrigem, @ArmDestino, @fin, @efinv, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @moradaentrega, @localentrega, @codpostentrega, @DocACL, @DESCREGIVA, @CODPAIS, @DCCLCE, @dcci1v, @dcci2v, @dcci3v, @DCCPNS, @DCCTDC, @DCCDAN, @DCCHRA
		END
		
FIM:
		CLOSE curCabFT
		DEALLOCATE curCabFT
END

GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_GetForInfo
-- Ler dados da ficha do fornecedor
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_GetForInfo]
	@ForNum INT,
	@EstabNum INT,
	@ForTipo VARCHAR(20) OUTPUT,
	@ForZona VARCHAR(20) OUTPUT,
	@ForTelef VARCHAR(60) OUTPUT,
	@ForPais INT OUTPUT,
	@ForMoeda VARCHAR(11) OUTPUT,
	@fref VARCHAR(20) OUTPUT,
	@ccusto VARCHAR(20) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		@ForTipo = ISNULL(tipo, ''),
		@ForZona = ISNULL(zona, ''),
		@ForPais = ISNULL(pais, 0),
		@ForMoeda = ISNULL(moeda, ''),
		@fref = ISNULL(fref, ''),
		@ccusto = ISNULL(ccusto, '')
	FROM fl(nolock) WHERE no = @ForNum and estab = @EstabNum
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDossInternLinUSR
-- Personalizações na integração de linhas de dossiers internos
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDossInternLinUSR] 
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@bostamp CHAR(25),		-- Stamp do dossier interno
	@bistamp CHAR(25),		-- Stamp da linha
	@no INT,				-- Nº do cliente
	@ref VARCHAR(18),		-- Código do artigo
	@DCLLIN INT				-- Linha do documento no MSS
AS
BEGIN
	SET NOCOUNT ON;


END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDossInternLin
-- Integração de linhas de dossiers internos
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDossInternLin]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@EstabSeparator CHAR(1),
	@no INT,
	@estab INT,
	@bostamp CHAR(25),
	@dataobra DATETIME,
	@rdata DATETIME,
	@local VARCHAR(55),
	@morada VARCHAR(55),
	@codpost VARCHAR(55),
	@nome VARCHAR(55),
	@DCCDCG NUMERIC(18,5),
	@ArmOrigem VARCHAR(30),
	@ArmDestino VARCHAR(30),
	@Entidade VARCHAR(1),
	@DocAnul VARCHAR(1),
	@Imp1 CHAR(10),
	@Imp2 CHAR(10),
	@Imp3 CHAR(10),
	@Devolucao CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @DocTipo VARCHAR(10)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocLinDescV NUMERIC(18,5)
	DECLARE @DocLinDesc1 NUMERIC(6,2)
	DECLARE @DocLinDesc2 NUMERIC(6,2)
	DECLARE @DocLinDesc3 NUMERIC(6,2)
	DECLARE @DocLinDesc4 NUMERIC(6,2)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocParam INT
	DECLARE @DocParamFor INT
	DECLARE @DocPCusto INT
	DECLARE @DocIVI VARCHAR(1)
	DECLARE @DocDesc NUMERIC(18,5)
	DECLARE @DocUni2 VARCHAR(4)
	DECLARE @DCLACL VARCHAR(2000)
	DECLARE @ArtComissao INT 
	DECLARE @ArtPPond NUMERIC(19,6)
	DECLARE @ArtConv NUMERIC(18,5)
	DECLARE @ArtStock NUMERIC(11,3)
	DECLARE @ArtQttFor NUMERIC(11,3)
	DECLARE @ArtQttCli NUMERIC(11,3)
	DECLARE @ArtQttRec NUMERIC(11,3)
	DECLARE @ArtUsrQtt NUMERIC(11,3)

	DECLARE @CliTipo VARCHAR(20)
	DECLARE @CliTelef VARCHAR(60)
	DECLARE @CliNome VARCHAR(55)
	DECLARE @CliMorada VARCHAR(55)
	DECLARE @CliLocal VARCHAR(43)
	DECLARE @CliCPostal VARCHAR(45)
	DECLARE @CliNCont VARCHAR(18)
	DECLARE @CliPais INT
	DECLARE @CliLocTesoura VARCHAR(50)
	DECLARE @CliContado INT
	
	DECLARE @bistamp CHAR(25)
	DECLARE @ref VARCHAR(60)
	DECLARE @design VARCHAR(60)
	DECLARE @lordem INT
	DECLARE @ndos INT
	DECLARE @nmdos VARCHAR(24)
	DECLARE @armazem INT
	DECLARE @qtt NUMERIC(11,3)
	DECLARE @altura NUMERIC(11,3)
	DECLARE @largura NUMERIC(11,3)
	DECLARE @espessura NUMERIC(11,3)
	DECLARE @moeda VARCHAR(11)
	DECLARE @peso NUMERIC(11,3)
	DECLARE @stipo INT
	DECLARE @usr1 VARCHAR(20)
	DECLARE @usr2 VARCHAR(20)
	DECLARE @usr3 VARCHAR(35)
	DECLARE @usr4 VARCHAR(20)
	DECLARE @usr5 VARCHAR(120)
	DECLARE @usr6 VARCHAR(30)
	DECLARE @ivaincl INT
	DECLARE @cpoc INT
	DECLARE @stns INT
	DECLARE @usalote INT
	DECLARE @lote VARCHAR(30)
	DECLARE @obrano INT
	DECLARE @epu NUMERIC(19,6)
	DECLARE @pu NUMERIC(18,5)
	DECLARE @edebito NUMERIC(19,6)
	DECLARE @debito NUMERIC(18,5)
	DECLARE @eslvu NUMERIC(19,6)
	DECLARE @slvu NUMERIC(18,5)
	DECLARE @ettdeb NUMERIC(19,6)
	DECLARE @ttdeb NUMERIC(18,5)
	DECLARE @esltt NUMERIC(19,6)
	DECLARE @sltt NUMERIC(18,5)
	DECLARE @epcusto NUMERIC(19,6)
	DECLARE @pcusto NUMERIC(18,5)
	DECLARE @ar2mazem INT
	DECLARE @desconto NUMERIC(18,5)
	DECLARE @desc2 NUMERIC(6,2)
	DECLARE @desc3 NUMERIC(6,2)
	DECLARE @desc4 NUMERIC(6,2)
	DECLARE @desc5 NUMERIC(6,2)
	DECLARE @iva NUMERIC(5,2)
	DECLARE @uni2qtt NUMERIC(11,3)
	DECLARE @unidade VARCHAR(4)
	DECLARE @unidad2 VARCHAR(4)
	DECLARE @tabiva INT
	DECLARE @vendedor INT
	DECLARE @vendnm VARCHAR(20)
	DECLARE @eprorc NUMERIC(19,6)
	DECLARE @prorc NUMERIC(18,5)
	DECLARE @codigo VARCHAR(18)
	DECLARE @forref VARCHAR(20) 
	DECLARE @zona VARCHAR(13)
	DECLARE @segmento VARCHAR(25)
	DECLARE @familia VARCHAR(18)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)
	DECLARE @datalote VARCHAR(8)
	DECLARE @validade VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @lifref INT 
	DECLARE @stocks INT

	DECLARE @refCorTam VARCHAR(60)
	DECLARE @Cor VARCHAR(25)
	DECLARE @Tam VARCHAR(25)
	DECLARE @Texteis INT
	DECLARE @DCLLIN INT
	DECLARE @DCLTCL CHAR(1)
	DECLARE @DCLQTM NUMERIC(11,3)

	DECLARE @ExerDocOrig VARCHAR(30)
	DECLARE @TipoDocOrig VARCHAR(10)
	DECLARE @SerieDocOrig VARCHAR(10)
	DECLARE @NumDocOrig INT
	DECLARE @LinDocOrig INT

	DECLARE @orilinstamp VARCHAR(25)
	DECLARE @oriheadstamp VARCHAR(25)
	DECLARE @orindoc INT

	DECLARE @To_Close INT
	DECLARE @QtdPend NUMERIC(11,3)

	DECLARE @NSERIE VARCHAR(60)
	DECLARE @CONT INT
	DECLARE @NOSERIE INT
	DECLARE @mastamp CHAR(25)
	DECLARE @bomastamp CHAR(25)
	DECLARE @situacao CHAR(60)
	DECLARE @bdemp	VARCHAR(2)
	DECLARE @TabIvaTemp INT

	SET @CONT = 0
	
	/*impostos*/
	DECLARE @dcli1v NUMERIC (19,6)
	DECLARE @dcli2v NUMERIC(19,6)
	DECLARE @dcli3v NUMERIC(19,6)
	DECLARE @ecovalor NUMERIC(19,6)
	DECLARE @etecoval NUMERIC (19,6)
	DECLARE @eecoval NUMERIC (19,6)
	DECLARE @temeco INT
	DECLARE @ECONOTCALC INT

	/*composto*/
	DECLARE @DCLACP CHAR(1)
	DECLARE @lrecno CHAR(25)
	DECLARE @COMPOSTO INT

	/* descritivo */
	DECLARE @DESCRITIVO CHAR(1)

	DECLARE curBI CURSOR FOR
	SELECT 
		ISNULL(DCLTPD, ''),
		ISNULL(DCLSER, ''),
		ISNULL(DCLNDC, 0),
		CASE WHEN DCLLIN < 1000 THEN ISNULL(DCLLIN*10000, 0)
		ELSE DCLLIN END,
		ISNULL(DCLART, ''),
		ISNULL(DCLQTD, 0.0),
		ISNULL(DCLPRU, 0.0),
		ISNULL(DCLTXI, 0.0),
		ISNULL(DCLTDC, 0.0),
		ISNULL(DCLTD2, 0.0),
		ISNULL(DCLTD3, 0.0),
		ISNULL(DCLTD4, 0.0),
		ISNULL(DCTLOT, ''),
		ISNULL(DCLDSA, ''),
		ISNULL(DCLVD1, 0.0),
		ISNULL(DCLUND, ''),
		ISNULL(DCLALT, 0.0),
		ISNULL(DCLLGR, 0.0),
		ISNULL(DCLCMP, 0.0),
		ISNULL(DCLPES, 0.0),
		ISNULL(DCLVND, ''),
		ISNULL(DCLTERM, 0),
		ISNULL(DCLIVI, 'N'),
		ISNULL(DCLVLD, 0),
		ISNULL(DCLIVA, 0),
		ISNULL(DCLQT2, 0),
		ISNULL(DCTDTL, ''),
		ISNULL(DCTDVL, ''),
		ISNULL(DCLUN2, ''),
		ISNULL(DCLACL, ''),
		ISNULL(DCLLIN, 0),
		ISNULL(DCLTCL, ''),
		ISNULL(DCLQTM, 0),
		ISNULL(DCLOEX, ''),
		ISNULL(DCLOTP, ''),
		ISNULL(DCLOSR, ''),
		ISNULL(DCLOND, 0),
		ISNULL(DCLOLN, 0),
		ISNULL(DCTNSR,''),
		ISNULL(DCLI1V, 0),
		ISNULL(DCLI2V, 0),
		ISNULL(DCLI3V, 0),
		ISNULL(DCLACP, 'N')
	FROM MSDCL(nolock)
	WHERE DCLTIPO = 'P' AND DCLEXR = @DCCEXR AND DCLTPD=@DCCTPD And DCLSER=@DCCSER And DCLNDC=@DCCNDC
	Order By DCLLIN

	OPEN curBI
		FETCH NEXT FROM curBI INTO @DocTipo, @DocSerie, @obrano, @lordem, @ref, @qtt, @epu, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @vendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @datalote, @validade, @DocUni2, @DCLACL, @DCLLIN, @DCLTCL, @DCLQTM, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @NSERIE, @dcli1v, @dcli2v, @dcli3v, @DCLACP
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				
				SET @ecovalor = 0
			    
				IF (@dcli1v > 0 AND @Imp1='')
					RAISERROR('Documento com imposto 1 sem estar configurado!',16,1)

				IF (@dcli2v > 0 AND @Imp2='')
					RAISERROR('Documento com imposto 2 sem estar configurado!',16,1)

				IF (@dcli3v > 0 AND @Imp3='')
					RAISERROR('Documento com imposto 3 sem estar configurado!',16,1)

				if (upper(@Imp1) = 'ECOVALOR' and @dcli1v>0)
					SET @ecovalor = @dcli1v
				else if (upper(@Imp2) = 'ECOVALOR' and @dcli2v>0)
					SET @ecovalor = @dcli2v
				else if (upper(@Imp3) = 'ECOVALOR' and @dcli3v>0)
					SET @ecovalor = @dcli3v

				SET @eecoval = 0
				SET @etecoval = 0
				SET @TEMECO = 0
				
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @bistamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				-- Verifica se é uma artigo descritivo
				SET @DESCRITIVO = dbo.ExtractFromACL(@DCLACL, 15)

				-- Verifica se é um artigo com cor e tamanho
				SET @refCorTam = dbo.ExtractFromACL(@DCLACL, 15)
				IF (@refCorTam = 'F')
				BEGIN
					SET @refCorTam = @ref
					EXECUTE SPMSS_GetCorTamanho @DCLACL, @ref OUTPUT, @Cor OUTPUT, @Tam OUTPUT
					SET @Texteis = 1
				END
				ELSE
				BEGIN
					SET @COR = ''
					SET @Tam = ''
					SET @Texteis = 0
				END

				-- Verifica o composto
				SET @COMPOSTO = 0
				IF @DCLACP = 'A'
					SET @lrecno = @bistamp
				ELSE IF @DCLACP = 'C'
					SET @COMPOSTO = 1
				ELSE
				BEGIN
					SET @lrecno = @bistamp
					SET @COMPOSTO = 0
				END

				EXECUTE SPMSS_GetDadosDoc 1, @DocTipo, @DocSerie, @ndos OUTPUT, @nmdos OUTPUT, @DocParamFor OUTPUT, @DocParam OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT
				
				EXECUTE SPMSS_GetArtInfo @ref, @usr1 OUTPUT, @usr2 OUTPUT, @usr3 OUTPUT, @usr4 OUTPUT, @usr5 OUTPUT, @usr6 OUTPUT, @familia OUTPUT, @epcusto OUTPUT, @codigo OUTPUT, @forref OUTPUT, @ivaincl OUTPUT, @ArtComissao OUTPUT, @cpoc OUTPUT, @stns OUTPUT, @usalote OUTPUT, @ArtPPond OUTPUT, @unidad2 OUTPUT, @ArtConv OUTPUT,	@ArtStock OUTPUT, @ArtQttFor OUTPUT, @ArtQttCli OUTPUT,	@ArtQttRec OUTPUT, @ArtUsrQtt OUTPUT
				
				EXECUTE SPMSS_GetArtPCusto @ref, @DocPCusto, @epcusto OUTPUT

				EXECUTE SPMSS_GetVendNome @vendedor, @vendnm OUTPUT

				IF @DESCRITIVO <> 'D'
				BEGIN
				
					SET @stipo = 4
					SET @eprorc = @qtt * @epu

					IF (@DCLTCL = 'Q')
					BEGIN
						SET @uni2qtt = @DCLQTM
						SET @unidad2 = dbo.ExtractFromACL(@DCLACL, 25)
					END
					ELSE
					BEGIN
						IF @unidad2 <> ''
						BEGIN
							IF @DocUni2 <> @unidad2
								SET @uni2qtt = @qtt * @ArtConv
						END
						ELSE
							SET @uni2qtt = 0
					END

				
					IF @usalote = 0
						SET @lote = ''

					IF @DocIVI = 'S'
					begin
						IF (dbo.ExtractFromACL(@DCLACL, 24) <> '')
							SET @DocDesc = CAST(dbo.ExtractFromACL(@DCLACL, 24) AS NUMERIC(19,6))
						ELSE
							SET @DocDesc = 0
						
						if (@ecovalor > 0)
						BEGIN
							SET @eecoval = @ecovalor
							SET @etecoval = @eecoval * @qtt 
							SET @eslvu = (@epu + @etecoval) / (@iva/100+1) 
							SET @ettdeb = ((@qtt * @epu - @docdesc) + @etecoval)
							SET @esltt = ((@qtt * @epu - @docdesc + @etecoval) / (@iva/100+1))

							SET @TEMECO=1
						END
						ELSE
						BEGIN
							SET @edebito = @epu 
							SET @eslvu = @epu / (@iva/100+1)
							SET @ettdeb = (@qtt * @epu - @docdesc)
							SET @esltt = (@qtt * @epu - @docdesc) / (@iva/100+1)
						END

						SET @ivaincl = 1
					end
					ELSE
					BEGIN
						if (@ecovalor > 0)
						BEGIN
							SET @TEMECO=1
							SET @ECONOTCALC=''
							SET @eecoval = @ecovalor
							set @etecoval= @eecoval * @qtt
							SET @edebito = @epu
							SET @eslvu = @epu + @etecoval 
							SET @ettdeb = (((@qtt * @epu) - @docdesc) + @etecoval)
							SET @esltt = (((@qtt * @epu) - @docdesc) + @etecoval)
						END
						ELSE
						BEGIN
							SET @edebito = @epu
							SET @eslvu = @epu
							SET @ettdeb = @qtt * @epu - @docdesc
							SET @esltt = @qtt * @epu - @docdesc
						END

						SET @ivaincl = 0
					END
				
					/*Linha com ecovalor*/
					IF @ecovalor > 0
					BEGIN
						EXECUTE SPMSS_DocECOVal @ref, @bistamp, @bostamp, @DocTerminal, 0
						EXECUTE SPMSS_DocECOValP @ref, @bistamp, @bostamp, @DocTerminal, 0
						EXECUTE SPMSS_DocECOValO @ref, @bistamp, @bostamp, @DocTerminal, 0
					END
			
					IF @stocks = 0
					BEGIN
						SET @eslvu = 0
						SET @esltt = 0
					END

					IF (@Entidade = 'F')
					BEGIN
						EXECUTE SPMSS_GetForInfo @no, @estab, @CliTipo OUTPUT, @Zona OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @fref OUTPUT, @ccusto OUTPUT
						SET @Segmento = ''
					END
					ELSE IF (@Entidade = 'P')
					BEGIN
						SET @CliTipo = '' 
						SET @Zona = ''
						SET @CliTelef = ''
						SET @CliPais = ''
						SET @moeda = ''
						SET @fref = ''
						SET @ccusto = ''
						SET @Segmento = ''
					END
					ELSE
					BEGIN
						EXECUTE SPMSS_GetCliInfo2 @no, @estab, @CliTipo OUTPUT, @Zona OUTPUT, @Segmento OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @CliLocTesoura OUTPUT, @CliContado OUTPUT, @fref OUTPUT, @ccusto OUTPUT, @TabIvaTemp OUTPUT
						IF @iva = 0 AND @tabiva <> @TabIvaTemp AND @TabIvaTemp > 0
							SET @tabiva = @TabIvaTemp
					END

					IF @CliContado is null
						set @CliContado = 0

					SELECT @nome = nome, @morada = morada, @local = local, @codpost = codpost FROM bo WHERE bostamp = @bostamp

					SET @armazem = dbo.StringToNum(@ArmOrigem)
					SET @Ar2mazem = dbo.StringToNum(@ArmDestino)

					EXECUTE SPMSS_CalcDescontos @DocLinDescV, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @epu, @qtt, @DCCDCG, @desconto OUTPUT, @desc2 OUTPUT, @desc3 OUTPUT, @desc4 OUTPUT, @desc5 OUTPUT

					SET @orilinstamp = ''
					SET @oriheadstamp = ''
				
					IF ((@TipoDocOrig <> '') OR (@Devolucao = 'S'))
					BEGIN
						EXECUTE SPMSS_GetDocOrigStamp @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, '', @Devolucao, 1, @orilinstamp OUTPUT, @oriheadstamp OUTPUT, @QtdPend OUTPUT, @orindoc OUTPUT
					END

					INSERT INTO bi2(bi2stamp, bostamp, local,morada,codpost) VALUES (@bistamp, @bostamp, @local,@morada,@codpost)
				
					-- verificar se o lote existe na tabela se e caso não exista fazer o insert antes de inserir a linha
					IF @lote <> ''
					BEGIN
						EXECUTE SPMSS_CheckLote @ref, @design, @lote, @datalote, @validade, @DocTerminal, @rdata
					END

				END
				/*IF @NSERIE<>''
				BEGIN
					SET @NOSERIE=1
				END
				ELSE
				BEGIN
					SET @NOSERIE=0
				END*/

				IF (@DESCRITIVO = 'D')
				BEGIN
					SET @ref = ''
					SET @epcusto = 0
				END

				INSERT INTO bi (bistamp, ref, design, lordem, ndos, bostamp, armazem, qtt, altura, largura, espessura, peso, stipo,usr1,usr2,usr3,usr4,usr5,usr6, ivaincl, cpoc, stns, usalote, obrano,epu,pu, edebito,debito,eslvu,slvu,ettdeb,ttdeb, esltt,sltt,no, epcusto,pcusto, ar2mazem,desconto,desc2,desc3,desc4,desc5,iva,dataobra,rdata,uni2qtt,unidade,unidad2,tabiva,vendedor,vendnm,estab,nmdos,local,morada,codpost,nome,eprorc,prorc,codigo,rescli,resfor,forref,zona,segmento,familia,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora, lote, lifref, dataopen, cor, tam, texteis, OBISTAMP, oobistamp/*, series, noserie*/,temeco,eecoval,ecoval,etecoval,tecoval,lrecno,composto) 
				VALUES (@bistamp, @ref, @design, @lordem, @ndos, @bostamp, @armazem, @qtt, @altura, @largura, @espessura, @peso, @stipo, @usr1,@usr2,@usr3,@usr4,@usr5,@usr6, @ivaincl, @cpoc, @stns, @usalote, @obrano, @epu, dbo.EurToEsc(@epu), @edebito, dbo.EurToEsc(@edebito), @eslvu, dbo.EurToEsc(@eslvu), @ettdeb, dbo.EurToEsc(@ettdeb), @esltt, dbo.EurToEsc(@esltt), @no, @epcusto, dbo.EurToEsc(@epcusto), @ar2mazem,@desconto,@desc2,@desc3,@desc4,@desc5,@iva,@dataobra,@rdata,@uni2qtt,@unidade,@unidad2,@tabiva,@vendedor,@vendnm,@estab,@nmdos,@local,@morada,@codpost,@nome,@eprorc,dbo.EurToEsc(@eprorc),@codigo,@DocParam,@DocParamFor,@forref,@zona,@segmento,@familia,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora, @lote, @lifref, @dataobra, @Cor, @Tam, @Texteis, @orilinstamp, @orilinstamp/*, @NSERIE, @NOSERIE*/, @temeco,@eecoval,dbo.EurToEsc(@eecoval),@etecoval,dbo.EurToEsc(@etecoval),@lrecno,@COMPOSTO)
				
				-- Actualizar totais no cabeçalho com base nos valores das linhas
				UPDATE bo SET estot4 = estot4 + @eprorc, esdeb4 = esdeb4 + @ettdeb, ecusto = ecusto + (@epcusto * @qtt) WHERE bostamp = @bostamp

				IF @orilinstamp IS NOT NULL
				BEGIN
					IF @QtdPend = @qtt
					BEGIN
						UPDATE bi SET fechada = 1, datafecho = @rdata WHERE bistamp = @orilinstamp
					END
					
					SELECT @To_Close = COUNT(*) FROM BI(nolock) WHERE bostamp = @oriheadstamp AND fechada = 0 and ref <> ''

					IF @To_Close = 0
					BEGIN
						UPDATE bo SET fechada = 1, datafecho = @rdata WHERE bostamp = @oriheadstamp			
					END
				END

				EXECUTE SPMSS_DocDossInternLinUSR @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @bistamp, @no, @ref, @DCLLIN

			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			
			END CATCH
			
			FETCH NEXT FROM curBI INTO @DocTipo, @DocSerie, @obrano, @lordem, @ref, @qtt, @epu, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @vendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @datalote, @validade, @DocUni2, @DCLACL, @DCLLIN, @DCLTCL, @DCLQTM, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @NSERIE, @dcli1v, @dcli2v, @dcli3v,@DCLACP
			
		END
	FIM:
		CLOSE curBI
		DEALLOCATE curBI
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDossInternUSR
-- Persoanlização de integração de cabeçalhos de dossiers internos
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDossInternUSR]
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@bostamp CHAR(25),		-- Stamp do dossier interno
	@no INT					-- Nº do cliente
AS
BEGIN
	SET NOCOUNT ON;


END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDossInternIVAs
-- Ligação dos campos com as bases e valores de IVA do MSS aos do cabeçalho de dossiers internos do PHC baseado na tabela de taxas de IVA
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDossInternIVAs]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@bostamp CHAR(25),
	@ebo12_bins NUMERIC(19,6) OUTPUT,
	@ebo12_iva NUMERIC(19,6) OUTPUT,
	@ebo22_bins NUMERIC(19,6) OUTPUT,
	@ebo22_iva NUMERIC(19,6) OUTPUT,
	@ebo32_bins NUMERIC(19,6) OUTPUT,
	@ebo32_iva NUMERIC(19,6) OUTPUT,
	@ebo42_bins NUMERIC(19,6) OUTPUT,
	@ebo42_iva NUMERIC(19,6) OUTPUT,
	@ebo52_bins NUMERIC(19,6) OUTPUT,
	@ebo52_iva NUMERIC(19,6) OUTPUT,
	@ebo62_bins NUMERIC(19,6) OUTPUT,
	@ebo62_iva NUMERIC(19,6) OUTPUT,
	@ebo72_bins NUMERIC(19,6) OUTPUT,
	@ebo72_iva NUMERIC(19,6) OUTPUT,
	@ebo82_bins NUMERIC(19,6) OUTPUT,
	@ebo82_iva NUMERIC(19,6) OUTPUT,
	@ebo92_bins NUMERIC(19,6) OUTPUT,
	@ebo92_iva NUMERIC(19,6) OUTPUT,
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
	DECLARE @CodTabIva CHAR(1)
	DECLARE @DocTax1 NUMERIC(6,2)
	DECLARE @DocTaxBIns1 NUMERIC(19,6)
	DECLARE @DocTaxVal1 NUMERIC(19,6)
	DECLARE @DocTax2 NUMERIC(6,2)
	DECLARE @DocTaxBIns2 NUMERIC(19,6)
	DECLARE @DocTaxVal2 NUMERIC(19,6)
	DECLARE @DocTax3 NUMERIC(6,2)
	DECLARE @DocTaxBIns3 NUMERIC(19,6)
	DECLARE @DocTaxVal3 NUMERIC(19,6)
	DECLARE @DocTax4 NUMERIC(6,2)
	DECLARE @DocTaxBIns4 NUMERIC(19,6)
	DECLARE @DocTaxVal4 NUMERIC(19,6)

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	SELECT 
		@DocTax1 = ISNULL(DCCTX1, 0),
		@DocTaxBIns1 = ISNULL(DCCBI1, 0),
		@DocTaxVal1 = ISNULL(DCCVI1, 0),
		@DocTax2 = ISNULL(DCCTX2, 0),
		@DocTaxBIns2 = ISNULL(DCCBI2, 0),
		@DocTaxVal2 = ISNULL(DCCVI2, 0),
		@DocTax3 = ISNULL(DCCTX3, 0),
		@DocTaxBIns3 = ISNULL(DCCBI3, 0),
		@DocTaxVal3 = ISNULL(DCCVI3, 0),
		@DocTax4 = ISNULL(DCCTX4, 0),
		@DocTaxBIns4 = ISNULL(DCCBI4, 0),
		@DocTaxVal4 = ISNULL(DCCVI4, 0)
	FROM MSDCC(nolock)
	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC

	SET @ebo12_bins = 0
	SET @ebo12_iva = 0
	SET @ebo22_bins = 0
	SET @ebo22_iva = 0
	SET @ebo32_bins = 0
	SET @ebo32_iva = 0
	SET @ebo42_bins = 0
	SET @ebo42_iva = 0
	SET @ebo52_bins = 0
	SET @ebo52_iva = 0
	SET @ebo62_bins = 0
	SET @ebo62_iva = 0
	SET @ebo72_bins = 0
	SET @ebo72_iva = 0
	SET @ebo82_bins = 0
	SET @ebo82_iva = 0
	SET @ebo92_bins = 0
	SET @ebo92_iva = 0


	

	IF @DocTaxBIns1 > 0  -- quando a base de incidência 1 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax1, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax1, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @ebo12_bins = @DocTaxBIns1		
			SET @ebo12_iva = @DocTaxVal1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @ebo22_bins = @DocTaxBIns1
			SET @ebo22_iva = @DocTaxVal1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @ebo32_bins = @DocTaxBIns1		
			SET @ebo32_iva = @DocTaxVal1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @ebo42_bins = @DocTaxBIns1		
			SET @ebo42_iva = @DocTaxVal1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @ebo52_bins = @DocTaxBIns1		
			SET @ebo52_iva = @DocTaxVal1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @ebo62_bins = @DocTaxBIns1		
			SET @ebo62_iva = @DocTaxVal1
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @ebo72_bins = @DocTaxBIns1		
			SET @ebo72_iva = @DocTaxVal1
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @ebo82_bins = @DocTaxBIns1		
			SET @ebo82_iva = @DocTaxVal1
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @ebo92_bins = @DocTaxBIns1		
			SET @ebo92_iva = @DocTaxVal1
		END

		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'MSS_' + @DateStr + @TimeStr

		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, evalor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, @CodTabIVA, @DocTax1, @DocTaxBIns1, @DocTaxVal1, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF @DocTaxBIns2 > 0  -- quando a base de incidência 2 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax2, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax2, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @ebo12_bins = @DocTaxBIns2	
			SET @ebo12_iva = @DocTaxVal2
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @ebo22_bins = @DocTaxBIns2
			SET @ebo22_iva = @DocTaxVal2
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @ebo32_bins = @DocTaxBIns2		
			SET @ebo32_iva = @DocTaxVal2
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @ebo42_bins = @DocTaxBIns2		
			SET @ebo42_iva = @DocTaxVal2
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @ebo52_bins = @DocTaxBIns2		
			SET @ebo52_iva = @DocTaxVal2
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @ebo62_bins = @DocTaxBIns2		
			SET @ebo62_iva = @DocTaxVal2
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @ebo72_bins = @DocTaxBIns2		
			SET @ebo72_iva = @DocTaxVal2
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @ebo82_bins = @DocTaxBIns2		
			SET @ebo82_iva = @DocTaxVal2
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @ebo92_bins = @DocTaxBIns2		
			SET @ebo92_iva = @DocTaxVal2
		END

		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'MSS_' + @DateStr + @TimeStr

		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, evalor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, @CodTabIVA, @DocTax2, @DocTaxBIns2, @DocTaxVal2, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF @DocTaxBIns3 > 0  -- quando a base de incidência 3 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax3, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax3, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @ebo12_bins = @DocTaxBIns3		
			SET @ebo12_iva = @DocTaxVal3
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @ebo22_bins = @DocTaxBIns3
			SET @ebo22_iva = @DocTaxVal3
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @ebo32_bins = @DocTaxBIns3
			SET @ebo32_iva = @DocTaxVal3
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @ebo42_bins = @DocTaxBIns3		
			SET @ebo42_iva = @DocTaxVal3
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @ebo52_bins = @DocTaxBIns3		
			SET @ebo52_iva = @DocTaxVal3
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @ebo62_bins = @DocTaxBIns3		
			SET @ebo62_iva = @DocTaxVal3
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @ebo72_bins = @DocTaxBIns3		
			SET @ebo72_iva = @DocTaxVal3
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @ebo82_bins = @DocTaxBIns3
			SET @ebo82_iva = @DocTaxVal3
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @ebo92_bins = @DocTaxBIns3		
			SET @ebo92_iva = @DocTaxVal3
		END

		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'MSS_' + @DateStr + @TimeStr
		
		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, evalor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, @CodTabIVA, @DocTax3, @DocTaxBIns3, @DocTaxVal3, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

	IF @DocTaxBIns4 > 0  -- quando a base de incidência 4 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax4, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax4, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @ebo12_bins = @DocTaxBIns4	
			SET @ebo12_iva = @DocTaxVal4
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @ebo22_bins = @DocTaxBIns4
			SET @ebo22_iva = @DocTaxVal4
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @ebo32_bins = @DocTaxBIns4		
			SET @ebo32_iva = @DocTaxVal4
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @ebo42_bins = @DocTaxBIns4
			SET @ebo42_iva = @DocTaxVal4
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @ebo52_bins = @DocTaxBIns4
			SET @ebo52_iva = @DocTaxVal4
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @ebo62_bins = @DocTaxBIns4		
			SET @ebo62_iva = @DocTaxVal4
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @ebo72_bins = @DocTaxBIns4		
			SET @ebo72_iva = @DocTaxVal4
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @ebo82_bins = @DocTaxBIns4		
			SET @ebo82_iva = @DocTaxVal4
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @ebo92_bins = @DocTaxBIns4		
			SET @ebo92_iva = @DocTaxVal4
		END

		WAITFOR DELAY '00:00:00.200' 
		SET @DateTimeTmp = GETDATE()
		SET @DateStr = dbo.DateToString(@DateTimeTmp)
		SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
		SET @botstamp = 'MSS_' + @DateStr + @TimeStr
		
		INSERT INTO bot(botstamp, bostamp, codigo, taxa, ebaseinc, evalor, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
		VALUES(@botstamp, @bostamp, @CodTabIVA, @DocTax4, @DocTaxBIns4, @DocTaxVal4, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
	END

END

GO

CREATE PROCEDURE [dbo].[SPMSS_DocDossIntern]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@EstabSeparator CHAR(1),
	@EstabSeparatorFor CHAR(1),
	@Imp1 CHAR(10),
	@Imp2 CHAR(10),
	@Imp3 CHAR(10),
	@ValidateDocLines INT,
	@ValidateDocSequence INT,
	@ValidateDocTotals NUMERIC(19,6),
	@memissao VARCHAR(15) = 'EURO'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @CliNumTmp VARCHAR(20)
	DECLARE @CliLocEnt VARCHAR(20)	
	DECLARE @CondVendTmp VARCHAR(30)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocTipo VARCHAR(10)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocArmazem INT
	DECLARE @DocAnul CHAR(1)
	DECLARE @DocParam INT
	DECLARE @DocParamFor INT 
	DECLARE @CliTipo VARCHAR(20) 
	DECLARE @CliZona VARCHAR(20) 
	DECLARE @CliSegmento VARCHAR(25)
	DECLARE @CliTelef VARCHAR(60)
	DECLARE @CliNome VARCHAR(55)
	DECLARE @CliMorada VARCHAR(55)
	DECLARE @CliLocal VARCHAR(43)
	DECLARE @CliCPostal VARCHAR(45)
	DECLARE @CliNCont VARCHAR(18)
	DECLARE @CliPais INT
	DECLARE @CliLocTesoura VARCHAR(50)
	DECLARE @CliContado INT
	DECLARE @DocDesc NUMERIC(19,6)
	DECLARE @DocAssinatura VARCHAR(1000)
	DECLARE @DocVsAssinatura VARCHAR(50)
	DECLARE @DocTipoSAFT VARCHAR(10)
	DECLARE @horasl VARCHAR(8)

	DECLARE @bistamp CHAR(25)
	DECLARE @bostamp CHAR(25)
	DECLARE @boano INT
	DECLARE @obrano INT
	DECLARE @ndos INT
	DECLARE @nmdos VARCHAR(24)
	DECLARE @dataobra DATETIME
	DECLARE @nome CHAR(55)
	DECLARE @morada VARCHAR(55)
	DECLARE @moeda VARCHAR(11)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @no INT
	DECLARE @obs VARCHAR(67)
	DECLARE @etotaldeb NUMERIC(19,6)
	DECLARE @estot1 NUMERIC(19,6)
	DECLARE @estot2 NUMERIC(19,6)
	DECLARE @estot3 NUMERIC(19,6)
	DECLARE @estot4 NUMERIC(19,6)
	DECLARE @vendedor INT
	DECLARE @vendnm VARCHAR(20)
	DECLARE @ncont VARCHAR(18)
	DECLARE @ebo_2tvall NUMERIC(19,6)

	DECLARE @etotal NUMERIC(19,6)
	DECLARE @ebo_1tvall NUMERIC(19,6)
	DECLARE @ebo_totp1 NUMERIC(19,6)
	DECLARE @ebo_totp2 NUMERIC(19,6)
	DECLARE @edescc NUMERIC(19,6)
	DECLARE @estab INT
	DECLARE @inome VARCHAR(50)
	DECLARE @tpstamp CHAR(25)
	DECLARE @tpdesc VARCHAR(55)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)

	DECLARE @ebo12_bins NUMERIC(19,6)
	DECLARE @ebo12_iva NUMERIC(19,6)
	DECLARE @ebo22_bins NUMERIC(19,6)
	DECLARE @ebo22_iva NUMERIC(19,6)
	DECLARE @ebo32_bins NUMERIC(19,6)
	DECLARE @ebo32_iva NUMERIC(19,6)
	DECLARE @ebo42_bins NUMERIC(19,6)
	DECLARE @ebo42_iva NUMERIC(19,6)
	DECLARE @ebo52_bins NUMERIC(19,6)
	DECLARE @ebo52_iva NUMERIC(19,6)
	DECLARE @ebo62_bins NUMERIC(19,6)
	DECLARE @ebo62_iva NUMERIC(19,6)
	DECLARE @ebo72_bins NUMERIC(19,6)
	DECLARE @ebo72_iva NUMERIC(19,6)
	DECLARE @ebo82_bins NUMERIC(19,6)
	DECLARE @ebo82_iva NUMERIC(19,6)
	DECLARE @ebo92_bins NUMERIC(19,6)
	DECLARE @ebo92_iva NUMERIC(19,6)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	DECLARE @ArmOrigem VARCHAR(30)
	DECLARE @ArmDestino VARCHAR(30)
	
	DECLARE @etotalciva NUMERIC(19,6)
	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT
	DECLARE @atcodeid VARCHAR(200)
	DECLARE @cdata DATETIME
	DECLARE @chora VARCHAR(8)
	DECLARE @DocACL VARCHAR(2000)
	DECLARE @DocTip VARCHAR(1)
	DECLARE @CODPAIS VARCHAR(60)
	DECLARE @DESCRPAIS VARCHAR(60)

	DECLARE @ENTIDADE VARCHAR(1)
	DECLARE @InvoiceNO VARCHAR(60)
	DECLARE @ATCUD VARCHAR(100)

	DECLARE @paStamp CHAR(25)
	DECLARE @DCCSSR VARCHAR(10)
	DECLARE @DCCSND INT
	DECLARE @Anul INT
	DECLARE @motanul VARCHAR(100)
	DECLARE @bdemp VARCHAR(2)
	DECLARE @TabIva INT
	
	DECLARE @motiseimp VARCHAR(60)
	DECLARE @codmotiseimp VARCHAR(3)
	
	DECLARE @contImp INT
	
	/*Impostos*/
	DECLARE @dcci1v NUMERIC(19,6)
	DECLARE @dcci2v NUMERIC(19,6)
	DECLARE @dcci3v NUMERIC(19,6)
	DECLARE @ecovalor NUMERIC(19,6)
	
	/*Validações*/
	DECLARE @DCCPNS CHAR(1)
	DECLARE @DOCValorizado CHAR(1)
	DECLARE @ContAnt INT
	DECLARE @ContLinhas INT
	DECLARE @ContLinhasTerminal INT
	DECLARE @TotalDOC NUMERIC(19,6)
	DECLARE @DiffVAL NUMERIC(19,6)
	DECLARE @Msg VARCHAR(200)
	DECLARE @MsgErro VARCHAR(200)
	DECLARE @DOC VARCHAR(80)

	DECLARE curCabBO CURSOR FOR
	SELECT 
		ISNULL(DCCTPD, ''),
		ISNULL(DCCSER, ''),
		ISNULL(DCCNDC, 0),
		ISNULL(DCCDTA, ''),
		ISNULL(DCCCLI, ''),
		ISNULL(DCCLCE, ''),
		ISNULL(DCCNOM, ''),
		ISNULL(DCCMOR, ''),
		ISNULL(DCCLOC, ''),
		ISNULL(DCCCPT, ''),
		ISNULL(DCCNCT, ''),
		ISNULL(DCCVLI, 0),
		ISNULL(DCCVLL, 0),
		ISNULL(DCCVDC, 0),
		ISNULL(DCCOBS, ''),
		ISNULL(DCCVND, ''),
		ISNULL(DCCTERM, 0),
		ISNULL(DCCCVD, ''),
		ISNULL(DCCDCG, 0),
		ISNULL(DCCARO, ''),
		ISNULL(DCCARD, ''),
		ISNULL(DCCANU, 'N'),
		ISNULL(DCCSIG, ''),
		ISNULL(DCCSIV, 0),
		ISNULL(DCCTSF, ''),
		ISNULL(DCCHOR, ''),
		ISNULL(DCCTDC, 0),
		ISNULL(DCCACL, ''),
		ISNULL(DCCTIP, ''),
		ISNULL(DCCPAI, ''),
		ISNULL(DCCSSR, ''),
		ISNULL(DCCSND, 0),
		ISNULL(DCCI1V,0),
		ISNULL(DCCI2V,0),
		ISNULL(DCCI3V,0),
		ISNULL(DCCPNS,'N')
	FROM MSDCC(nolock)
	WHERE DCCSYNCR = 'N' AND DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC ORDER BY DCCDTA, DCCHOR

	OPEN curCabBo
		
		FETCH NEXT FROM curCabBO INTO @DocTipo, @DocSerie, @obrano, @dataobra, @CliNumTmp, @CliLocEnt, @nome, @morada, @local, @codpost, @ncont, @etotal, @etotaldeb, @edescc, @obs, @vendedor, @DocTerminal, @CondVendTmp, @DocDesc, @ArmOrigem, @ArmDestino, @DocAnul, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @etotalciva, @DocACL, @DocTip, @CODPAIS, @DCCSSR, @DCCSND, @dcci1v, @dcci2v, @dcci3v, @DCCPNS
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				BEGIN TRANSACTION

				EXECUTE SPMSS_GetDadosDoc 1, @DocTipo, @DocSerie, @ndos OUTPUT, @nmdos OUTPUT, @DocParamFor OUTPUT, @DocParam OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT

				select @contImp = count(1) from ts inner join ts2 on ts.tsstamp=ts2stamp where ts2.docsimport=1 and ndos=@ndos

				if (@contImp = 0 and @DocTipoSAFT<>'')
					RAISERROR('A série não está configurada para documentos importados para o documento!',16,1)
				
				IF (@dcci1v > 0 AND @Imp1='')
					RAISERROR('Documento com imposto 1 sem estar configurado!',16,1)

				IF (@dcci2v > 0 AND @Imp2='')
					RAISERROR('Documento com imposto 2 sem estar configurado!',16,1)

				IF (@dcci3v > 0 AND @Imp3='')
					RAISERROR('Documento com imposto 3 sem estar configurado!',16,1)

				SET @ecovalor = 0
				
				SET @ENTIDADE = ''
				IF (LEN(@CliNumTmp) > 1)
				BEGIN
					IF ((SUBSTRING(@CliNumTmp, 1, 2) = 'F.') OR (CHARINDEX(@EstabSeparatorFor, @CliNumTmp) > 0))
						SET @ENTIDADE = 'F'
					ELSE IF ((SUBSTRING(@CliNumTmp, 1, 2) = 'P.'))
						SET @ENTIDADE = 'P'
				END
					
				IF (@ENTIDADE = 'F')
				BEGIN
					IF CHARINDEX(@EstabSeparatorFor, @CliNumTmp) > 0
					BEGIN
						SET @estab = CAST(RIGHT(@CliNumTmp, LEN(@CliNumTmp) - CHARINDEX(@EstabSeparatorFor, @CliNumTmp)) AS INT)
						SET @CliNumTmp = LEFT(@CliNumTmp, CHARINDEX(@EstabSeparatorFor, @CliNumTmp) - 1)
					END
					ELSE
					BEGIN
						/*IF LEFT(@CliLocEnt, 3) = 'LCD' SET @CliLocEnt = '0'
							SET @estab = @CliLocEnt*/
						IF LEFT(@CliLocEnt, 3) = 'LCD' SET @CliLocEnt = '0'
						SET @estab = CAST(@CliLocEnt AS INT)
						/*IF (@CliLocEnt <> '') AND (CHARINDEX('LCD_ID_', @CliLocEnt) > 0)
							SET @CliLocEnt = REPLACE(@CliLocEnt, 'LCD_ID_', '')
						IF ((@estab <= 0) AND (CAST(@CliLocEnt AS INT) > 0))
							SET @estab = CAST(@CliLocEnt AS INT)*/
					END
					IF (SUBSTRING(@CliNumTmp, 1, 2) = 'F.')
						SET @no = CAST(SUBSTRING(@CliNumTmp, 3, LEN(@CliNumTmp) - 2) AS INT)
					ELSE
						SET @no = CAST(@CliNumTmp AS INT)

					EXECUTE SPMSS_GetForInfo @no, @estab, @CliTipo OUTPUT, @CliZona OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @fref OUTPUT, @ccusto OUTPUT
					SET @CliSegmento = ''
				END
				ELSE IF (@ENTIDADE = 'P')
				BEGIN
					SET @estab = 0
					
					IF (SUBSTRING(@CliNumTmp, 1, 2) = 'P.')
						SET @no = CAST(SUBSTRING(@CliNumTmp, 3, LEN(@CliNumTmp) - 2) AS INT)
					ELSE
						SET @no = CAST(@CliNumTmp AS INT)

					SET @CliTipo = ''
					SET @CliZona = ''
					SET @CliTelef = ''
					SET @CliPais = 0 
					SET @moeda = '' 
					SET @fref = '' 
					SET @ccusto = ''
					
					SET @CliSegmento = ''
				END
				ELSE
				BEGIN
				IF CHARINDEX(@EstabSeparator, @CliNumTmp) > 0
				BEGIN
					SET @no = CAST(LEFT(@CliNumTmp, CHARINDEX(@EstabSeparator, @CliNumTmp) - 1) AS INT)
					SET @estab = CAST(RIGHT(@CliNumTmp, LEN(@CliNumTmp) - CHARINDEX(@EstabSeparator, @CliNumTmp)) AS INT)
				END
				ELSE
				BEGIN
					SET @no = CAST(@CliNumTmp AS INT)
					/*IF LEFT(@CliLocEnt, 3) = 'LCD' SET @CliLocEnt = '0'
					SET @estab = @CliLocEnt*/
					
					IF LEFT(@CliLocEnt, 3) = 'LCD' SET @CliLocEnt = '0'
					SET @estab = CAST(@CliLocEnt AS INT)
							
					/*IF (@CliLocEnt <> '') AND (CHARINDEX('LCD_ID_', @CliLocEnt) > 0)
						SET @CliLocEnt = REPLACE(@CliLocEnt, 'LCD_ID_', '')
					IF ((@estab <= 0) AND (CAST(@CliLocEnt AS INT) > 0))
						SET @estab = CAST(@CliLocEnt AS INT)*/
				END
				END

				/*IF ((@estab <= 0) AND (CAST(@CliLocEnt AS INT) > 0))
					SET @estab = @CliLocEnt*/
					
						
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @bostamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				SET @horasl = LEFT(@horasl, 2) + ':' + SUBSTRING(@horasl, 3, 2) + ':' + SUBSTRING(@horasl, 5, 2)

				SET @boano = YEAR(@dataobra)

				IF dbo.ExtractFromACL(@DocACL, 67) <> ''
					SET @InvoiceNO = dbo.ExtractFromACL(@DocACL, 67)
				ELSE IF (@DocTipoSAFT <> '')
					SET @InvoiceNO = @DCCTPD + ' ' + @DocSerie + '/' + CAST(@obrano AS VARCHAR(48)) --@DocTipoSAFT + ' ' + @DocSerie + '/' + CAST(@obrano AS VARCHAR(48)) 
				ELSE
					SET @InvoiceNO = ''

				

				/*Validar se o documento anterior existe, caso o parâmetro @ValidateDocSequence está a 1 e senão é o primeiro número da série*/
				IF (@ValidateDocSequence = 1 and @DCCPNS<>'S' AND @obrano > 1)
				BEGIN
					SELECT @ContAnt = COUNT(1) FROM bo (NOLOCK) WHERE ndos=@ndos and boano=@boano and obrano=(@obrano - 1)

					SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' BOSTAMP = ' + @bostamp
					SET @MsgErro = @DOC + ' Documento anterior não existe!'

					if @ContAnt = 0
						RAISERROR(@MsgErro,16,1)
				END
				
				EXECUTE SPMSS_GetVendNome @vendedor, @vendnm OUTPUT

				SET @ebo_2tvall = @etotaldeb

				SET @ebo_1tvall = @etotal
				SET @ebo_totp1 = @etotal
				SET @ebo_totp2 = @etotal
				
				IF ((@ENTIDADE <> 'F') AND (@ENTIDADE <> 'P'))
				BEGIN
					IF @DocTip = 'S'
					BEGIN
						IF @no <= 0
							SELECT TOP 1 @no=no FROM CL WITH (NOLOCK) WHERE clivd = 1 order by no

						EXECUTE SPMSS_GetCliInfo @no, @estab, @CliTipo OUTPUT, @CliZona OUTPUT, @CliSegmento OUTPUT, @CliTelef OUTPUT, @nome OUTPUT, @morada OUTPUT, @local OUTPUT, @codpost OUTPUT, @ncont OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @CliLocTesoura OUTPUT, @CliContado OUTPUT, @fref OUTPUT, @ccusto OUTPUT, @TabIva OUTPUT
					END						
					ELSE
						EXECUTE SPMSS_GetCliInfo2 @no, @estab, @CliTipo OUTPUT, @CliZona OUTPUT, @CliSegmento OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @CliLocTesoura OUTPUT, @CliContado OUTPUT, @fref OUTPUT, @ccusto OUTPUT, @TabIva OUTPUT
				END

				IF @CliContado is null
					set @CliContado = 0
				
				SET @inome = 'MSS'

				EXECUTE SPMSS_GetCondVend @CondVendTmp, @tpstamp OUTPUT, @tpdesc OUTPUT

				IF @tpstamp IS NULL
                    SET @tpstamp = ''
                IF @tpdesc IS NULL
                    SET @tpdesc = ''
					
				SET @estot1 = 0
				SET @estot2 = 0
				SET @estot3 = 0
				SET @estot4 = 0
			
				-- Número do programa certificado
				
				
				IF @DocAssinatura <> ''
				BEGIN
					IF dbo.ExtractFromACL(@DocACL, 2) <> ''
						SET @DocVsAssinatura  = dbo.ExtractFromACL(@DocACL, 2)  + @DocVsAssinatura
					ELSE
						SET @DocVsAssinatura = '0240.' + @DocVsAssinatura
				END
				ELSE
				BEGIN
					SET @DocVsAssinatura = ''
				END
				
				IF dbo.ExtractFromACL(@DocACL, 13) <> ''
				BEGIN
					SET @atcodeid = dbo.ExtractFromACL(@DocACL, 13)
					SET @cdata = dbo.StringToDate(dbo.ExtractFromACL(@DocACL, 21))
					SET @chora = LEFT(dbo.ExtractFromACL(@DocACL, 22), 4)
				END
				ELSE
				BEGIN
					SET @atcodeid = ''
					SET @cdata = 0
					SET @chora = ''
				END
				

				EXECUTE SPMSS_DocDossInternIVAs @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @ebo12_bins OUTPUT, @ebo12_iva OUTPUT, @ebo22_bins OUTPUT, @ebo22_iva OUTPUT, @ebo32_bins OUTPUT, @ebo32_iva OUTPUT, @ebo42_bins OUTPUT, @ebo42_iva OUTPUT, @ebo52_bins OUTPUT, @ebo52_iva OUTPUT, @ebo62_bins OUTPUT, @ebo62_iva OUTPUT, @ebo72_bins OUTPUT, @ebo72_iva OUTPUT, @ebo82_bins OUTPUT, @ebo82_iva OUTPUT, @ebo92_bins OUTPUT, @ebo92_iva OUTPUT, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora


				SELECT @DESCRPAIS=nome FROM paises WHERE nomeabrvsaft=@CODPAIS
				IF @DESCRPAIS IS NULL
				BEGIN
					SET @DESCRPAIS = ''
				END

				SET @paStamp = ''

				--Serviços técnicos PHC
				--IF (@DCCSND > 0)
				--BEGIN
					--IF (@DCCSSR <> '0')
						--SELECT @paStamp = pastamp FROM pa (NOLOCK)  WHERE u_nomss = @DCCSND
					--ELSE
						--SELECT @paStamp = pastamp FROM pa (NOLOCK)  WHERE nopat = @DCCSND
				--END
				
				IF @DocAnul = 'S'
				BEGIN
					SET @Anul = 1;
				END
				ELSE
				BEGIN
					SET @Anul = 0;
				END	
				
				if (upper(@Imp1) = 'ECOVALOR' and @dcci1v>0)
					SET @ecovalor = @dcci1v
				else if (upper(@Imp2) = 'ECOVALOR' and @dcci2v>0)
					SET @ecovalor = @dcci2v
				else if (upper(@Imp3) = 'ECOVALOR' and @dcci3v>0)
					SET @ecovalor = @dcci3v
					
				-- verificar se existem linhas com IVA 0 para preencher na ft2 o motivo de isenção e respectivo código
				SELECT TOP 1 @motiseimp = DCLPLI, @codmotiseimp = dbo.ExtractFromACL(DCLACL, 12) FROM MSDCL WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC AND DCLPLI <> ''
				IF @motiseimp IS NULL
				BEGIN
					SET @motiseimp = ''
					SET @codmotiseimp = ''
				END
				
				INSERT INTO bo2 (bo2stamp, Armazem, Ar2mazem, Assinatura, VersaoChave, TipoSaft, horasl, etotalciva, morada, local, codpost, ebo72_bins, ebo72_iva, ebo82_bins, ebo82_iva, ebo92_bins, ebo92_iva, atcodeid,xpddata,xpdhora, anulado, ettecoval2, ttecoval2, ettecoval, ttecoval) VALUES (@bostamp, CAST(@ArmOrigem as int), CAST(@ArmDestino as int), @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @etotalciva, @morada, @local, @codpost, @ebo72_bins, @ebo72_iva, @ebo82_bins, @ebo82_iva, @ebo92_bins, @ebo92_iva,@atcodeid,@cdata,@chora, @Anul, @ecovalor, dbo.EurToEsc(@ecovalor), @ecovalor, dbo.EurToEsc(@ecovalor))

				SET @motanul = dbo.ExtractFromACL(@DocACL, 11)

				INSERT INTO bo3 (bo3stamp,codpais,descpais,ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, documentnumberori, motanul, taxpointdt, codmotiseimp, motiseimp) VALUES(@bostamp, @CODPAIS, @DESCRPAIS, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @InvoiceNO, @motanul, @usrdata, @codmotiseimp, @motiseimp)
				
				if (@ecovalor > 0)
				BEGIN
					SET @etotaldeb = @etotaldeb + @ecovalor
					SET @ebo_totp2 = @ebo_totp2 + @ecovalor
					SET @ebo_2tvall = @etotaldeb
				END
				
				DECLARE @DEVOLUCAO CHAR(1)
				SET @DEVOLUCAO = dbo.ExtractFromACL(@DocACL, 27)

				IF @DocAnul = 'S'
				BEGIN
					/*INSERT INTO bo (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, obs, moeda, etotaldeb, estot1, estot2, estot3, estot4, vendedor, vendnm, ncont, ebo_2tvall, etotal, ebo_1tvall, ebo_totp1, ebo_totp2, edescc, tipo, zona, segmento, estab, memissao, inome, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fechada, ebo12_bins, ebo12_iva, ebo22_bins, ebo22_iva, ebo32_bins, ebo32_iva, ebo42_bins, ebo42_iva, ebo52_bins, ebo52_iva, ebo62_bins, ebo62_iva, pastamp) 
					VALUES (@bostamp, @boano, @obrano, @ndos, @nmdos, @dataobra, @nome, @morada, @local, @codpost, @no, @obs, @moeda, 0, 0, 0, 0, 0, @vendedor, @vendnm, @ncont, 0, 0, 0, 0, 0, 0, @CliTipo, @CliZona, @CliSegmento, @estab, @memissao, @inome, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 1, @ebo12_bins, @ebo12_iva, @ebo22_bins, @ebo22_iva, @ebo32_bins, @ebo32_iva, @ebo42_bins, @ebo42_iva, @ebo52_bins, @ebo52_iva, @ebo62_bins, @ebo62_iva, @paStamp) */
					
					INSERT INTO bo (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, obs, moeda, etotaldeb, estot1, estot2, estot3, estot4, vendedor, vendnm, ncont, ebo_2tvall, etotal, ebo_1tvall, ebo_totp1, ebo_totp2, edescc, tipo, zona, segmento, estab, memissao, inome, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fref, ccusto, lifref, dataopen, ebo_2tdes1, ebo12_bins, ebo12_iva, ebo22_bins, ebo22_iva, ebo32_bins, ebo32_iva, ebo42_bins, ebo42_iva, ebo52_bins, ebo52_iva, ebo62_bins, ebo62_iva, pastamp) 
					VALUES (@bostamp, @boano, @obrano, @ndos, @nmdos, @dataobra, @nome, @morada, @local, @codpost, @no, @obs, @moeda, @etotaldeb, @estot1, @estot2, @estot3, @estot4, @vendedor, @vendnm, @ncont, @ebo_2tvall, @etotal, @ebo_1tvall, @ebo_totp1, @ebo_totp2, @edescc, @CliTipo, @CliZona, @CliSegmento, @estab, @memissao, @inome, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @fref, @ccusto, @lifref, @dataobra, @edescc, @ebo12_bins, @ebo12_iva, @ebo22_bins, @ebo22_iva, @ebo32_bins, @ebo32_iva, @ebo42_bins, @ebo42_iva, @ebo52_bins, @ebo52_iva, @ebo62_bins, @ebo62_iva, @paStamp) 

					EXECUTE SPMSS_DocDossInternUSR @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @no

					SET @bistamp = 'MSS_' + @DateStr + @TimeStr

					INSERT INTO bi2(bi2stamp) VALUES (@bistamp)
				
					EXECUTE SPMSS_DocDossInternLin @DCCEXR, @DCCTPD, @DCCSER, @obrano, @EstabSeparator, @no, @estab, @bostamp, @dataobra, @dataobra, @local, @morada, @codpost, @nome, @DocDesc, @ArmOrigem, @ArmDestino, @ENTIDADE, @DocAnul, @Imp1, @Imp2, @Imp3, @DEVOLUCAO

					
					/*INSERT INTO bi (bistamp, ref, design, lordem, ndos, bostamp, armazem, qtt, altura, largura, espessura, peso, stipo,usr1,usr2,usr3,usr4,usr5,usr6, ivaincl, cpoc, stns, usalote, obrano,epu,pu, edebito,debito,eslvu,slvu,ettdeb,ttdeb, esltt,sltt,no, epcusto,pcusto, ar2mazem,desconto,desc2,desc3,desc4,desc5,iva,dataobra,rdata,uni2qtt,unidade,unidad2,tabiva,vendedor,vendnm,estab,nmdos,local,morada,codpost,nome,eprorc,prorc,codigo,rescli,forref,zona,segmento,familia,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora, vumoeda, ttmoeda, fechada) 
					VALUES (@bistamp, '', 'Documento anulado', 10000, @ndos, @bostamp, 0, 0, 0, 0, 0, 0, 4, '','','','','','', 0, 0, 0, 0, @obrano, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @no, 0, 0, 0,0,0,0,0,0,0,@dataobra,@dataobra,0,'','',0,@vendedor,@vendnm,@estab,@nmdos,@local,@morada,@codpost,@nome,0,0,'',@DocParam,'',@CliZona,'','',@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora, 0, 0, 1)*/
				END
				ELSE
				BEGIN
					INSERT INTO bo (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, obs, moeda, etotaldeb, estot1, estot2, estot3, estot4, vendedor, vendnm, ncont, ebo_2tvall, etotal, ebo_1tvall, ebo_totp1, ebo_totp2, edescc, tipo, zona, segmento, estab, memissao, inome, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fref, ccusto, lifref, dataopen, ebo_2tdes1, ebo12_bins, ebo12_iva, ebo22_bins, ebo22_iva, ebo32_bins, ebo32_iva, ebo42_bins, ebo42_iva, ebo52_bins, ebo52_iva, ebo62_bins, ebo62_iva, pastamp) 
					VALUES (@bostamp, @boano, @obrano, @ndos, @nmdos, @dataobra, @nome, @morada, @local, @codpost, @no, @obs, @moeda, @etotaldeb, @estot1, @estot2, @estot3, @estot4, @vendedor, @vendnm, @ncont, @ebo_2tvall, @etotal, @ebo_1tvall, @ebo_totp1, @ebo_totp2, @edescc, @CliTipo, @CliZona, @CliSegmento, @estab, @memissao, @inome, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @fref, @ccusto, @lifref, @dataobra, @edescc, @ebo12_bins, @ebo12_iva, @ebo22_bins, @ebo22_iva, @ebo32_bins, @ebo32_iva, @ebo42_bins, @ebo42_iva, @ebo52_bins, @ebo52_iva, @ebo62_bins, @ebo62_iva, @paStamp) 

					EXECUTE SPMSS_DocDossInternUSR @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @no

					EXECUTE SPMSS_DocDossInternLin @DCCEXR, @DCCTPD, @DCCSER, @obrano, @EstabSeparator, @no, @estab, @bostamp, @dataobra, @dataobra, @local, @morada, @codpost, @nome, @DocDesc, @ArmOrigem, @ArmDestino, @ENTIDADE, @DocAnul, @Imp1, @Imp2, @Imp3, @DEVOLUCAO

				END

				/*INSERT INTO bo (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, obs, moeda, etotaldeb, estot1, estot2, estot3, estot4, vendedor, vendnm, ncont, ebo_2tvall, etotal, ebo_1tvall, ebo_totp1, ebo_totp2, edescc, tipo, zona, segmento, estab, memissao, inome, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fref, ccusto, lifref, dataopen, ebo_2tdes1, ebo12_bins, ebo12_iva, ebo22_bins, ebo22_iva, ebo32_bins, ebo32_iva, ebo42_bins, ebo42_iva, ebo52_bins, ebo52_iva, ebo62_bins, ebo62_iva, pastamp, u_totaldoc) 
				VALUES (@bostamp, @boano, @obrano, @ndos, @nmdos, @dataobra, @nome, @morada, @local, @codpost, @no, @obs, @moeda, @etotaldeb, @estot1, @estot2, @estot3, @estot4, @vendedor, @vendnm, @ncont, @ebo_2tvall, @etotal, @ebo_1tvall, @ebo_totp1, @ebo_totp2, @edescc, @CliTipo, @CliZona, @CliSegmento, @estab, @memissao, @inome, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @fref, @ccusto, @lifref, @dataobra, @edescc, @ebo12_bins, @ebo12_iva, @ebo22_bins, @ebo22_iva, @ebo32_bins, @ebo32_iva, @ebo42_bins, @ebo42_iva, @ebo52_bins, @ebo52_iva, @ebo62_bins, @ebo62_iva, @paStamp, @etotalciva) 

				EXECUTE SPMSS_DocDossInternUSR @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @no

			    EXECUTE SPMSS_DocDossInternLin @DCCEXR, @DCCTPD, @DCCSER, @obrano, @EstabSeparator, @no, @estab, @bostamp, @dataobra, @dataobra, @local, @morada, @codpost, @nome, @DocDesc, @ArmOrigem, @ArmDestino, @ENTIDADE, @DocAnul*/

				SET @DOCValorizado = dbo.ExtractFromACL(@DocACL, 25)

				IF(@ValidateDocTotals >= 0 AND @DOCValorizado = 'S')
				BEGIN
					/*Obter o total do documento do PHC*/
					SELECT @TotalDOC=(etotaldeb + ebo12_iva + ebo22_iva + ebo32_iva + ebo42_iva + ebo52_iva + ebo62_iva) FROM BO WHERE bostamp=@bostamp
					SELECT @TotalDOC=@TotalDOC+(ebo72_iva + ebo82_iva + ebo92_iva) FROM BO2 WHERE bo2stamp=@bostamp

					SET @DiffVAL = ABS(@etotalciva - @TotalDOC)

					SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' BOSTAMP = ' + @bostamp
					SET @MsgErro = @DOC + ' A diferença do documento do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)

					EXECUTE SPMSS_DocDossInternValIVAs  @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @ValidateDocTotals, @Msg OUT

					IF (@Msg<>'')
						RAISERROR(@Msg,16,1)
				END

				IF @ValidateDocLines = 1
				BEGIN
					IF dbo.ExtractFromACL(@DocACL, 46) <> ''
					BEGIN
						SET @ContLinhasTerminal = CAST(dbo.ExtractFromACL(@DocACL, 46) AS INT)

						SELECT @ContLinhas = count(1) FROM bi WHERE bostamp= @bostamp

						SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' BOSTAMP = ' + @bostamp
						SET @MsgErro = @DOC + ' Nº de linhas inserido no PHC (' + CAST(@ContLinhas AS VARCHAR(10)) + ') é diferente do número de linhas geradas no terminal (' + CAST(@ContLinhasTerminal AS VARCHAR(10)) + ')'


						if @ContLinhas <> @ContLinhasTerminal
							RAISERROR(@MsgErro,16,1)
					END
				END
				
				UPDATE MSDCC Set DCCSYNCR='S' WHERE DCCEXR=@DCCEXR AND DCCTPD=@DCCTPD And DCCSER=@DCCSER And DCCNDC=@obrano
				UPDATE MSDCL Set DCLSYNCR='S' WHERE DCLEXR=@DCCEXR AND DCLTPD=@DCCTPD And DCLSER=@DCCSER And DCLNDC=@obrano
				
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				ROLLBACK TRANSACTION
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			
			END CATCH
			
			FETCH NEXT FROM curCabBO INTO @DocTipo, @DocSerie, @obrano, @dataobra, @CliNumTmp, @CliLocEnt, @nome, @morada, @local, @codpost, @ncont, @etotal, @etotaldeb, @edescc, @obs, @vendedor, @DocTerminal, @CondVendTmp, @DocDesc, @ArmOrigem, @ArmDestino, @DocAnul, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @etotalciva, @DocACL, @DocTip, @CODPAIS, @DCCSSR, @DCCSND, @dcci1v, @dcci2v, @dcci3v, @DCCPNS
		END
	FIM:
		CLOSE curCabBo
		DEALLOCATE curCabBo
END

GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ReciboLinUSR
-- Personalizações na integração de linhas de recibos
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ReciboLinUSR]
	@RCCEXR VARCHAR(30),	-- Exercício do recibo no MSS
	@RCCTPD VARCHAR(10),	-- Código do recibo no MSS
	@RCCSER VARCHAR(4),		-- Série do recibo no MSS
	@RCCNDC INT,			-- Número do recibo no MSS
	@restamp CHAR(25),		-- Stamp do recibo
	@rlstamp CHAR(25)		-- Stamp da linha do recibo
AS
BEGIN
	SET NOCOUNT ON;


END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ReciboLinIVAs
-- Ligação dos campos com os valores de IVA pago no recibo do MSS aos registo de liquidação no PHC
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ReciboLinIVAs]
	@RCLEXR VARCHAR(30),
	@RCLTPD VARCHAR(10),
	@RCLSER VARCHAR(4),
	@RCLNDC INT,
	@RCLLIN INT,
	@restamp CHAR(25),
	@rlstamp CHAR(25),
	@ivatx1 NUMERIC(5,2),
	@ivatx2 NUMERIC(5,2),
	@ivatx3 NUMERIC(5,2),
	@ivatx4 NUMERIC(5,2),
	@ivatx5 NUMERIC(5,2),
	@ivatx6 NUMERIC(5,2),
	@ivatx7 NUMERIC(5,2),
	@ivatx8 NUMERIC(5,2),
	@ivatx9 NUMERIC(5,2),
	@eivav1 NUMERIC(19,6) OUTPUT,
	@eivav2 NUMERIC(19,6) OUTPUT,
	@eivav3 NUMERIC(19,6) OUTPUT,
	@eivav4 NUMERIC(19,6) OUTPUT,
	@eivav5 NUMERIC(19,6) OUTPUT,
	@eivav6 NUMERIC(19,6) OUTPUT,
	@eivav7 NUMERIC(19,6) OUTPUT,
	@eivav8 NUMERIC(19,6) OUTPUT,
	@eivav9 NUMERIC(19,6) OUTPUT,
	@ebivav1 NUMERIC(19,6) OUTPUT,
	@ebivav2 NUMERIC(19,6) OUTPUT,
	@ebivav3 NUMERIC(19,6) OUTPUT,
	@ebivav4 NUMERIC(19,6) OUTPUT,
	@ebivav5 NUMERIC(19,6) OUTPUT,
	@ebivav6 NUMERIC(19,6) OUTPUT,
	@ebivav7 NUMERIC(19,6) OUTPUT,
	@ebivav8 NUMERIC(19,6) OUTPUT,
	@ebivav9 NUMERIC(19,6) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RCILIL INT
	DECLARE @RCITXI NUMERIC(5,2)
	DECLARE @RCIVLB NUMERIC(19,6)
	DECLARE @RCIVLI NUMERIC(19,6)
	DECLARE @RCIVLA NUMERIC(19,6)
	DECLARE @RCIVLR NUMERIC(19,6)
	DECLARE @RCITIP VARCHAR(50)
	DECLARE @RCIPRG VARCHAR(50)
	DECLARE @RCIPLI VARCHAR(500)
	DECLARE @RCICMI VARCHAR(50)
	DECLARE @CodTabIVA CHAR(1)
	
	DECLARE curRI CURSOR FOR
	SELECT 
		ISNULL(RCILIL, 0),
		ISNULL(RCITXI, 0),
		ISNULL(RCIVLB, 0),
		ISNULL(RCIVLI, 0),
		ISNULL(RCIVLA, 0),
		ISNULL(RCIVLR, 0),
		ISNULL(RCITIP, ''),
		ISNULL(RCIPRG, ''),
		ISNULL(RCIPLI, ''),
		ISNULL(RCICMI, 0)
	FROM MSRCI(nolock)
	WHERE RCIEXR = @RCLEXR AND RCITPD = @RCLTPD AND RCISER = @RCLSER AND RCINDC = @RCLNDC AND RCILIN = @RCLLIN

	OPEN curRI
		FETCH NEXT FROM curRI INTO @RCILIL,@RCITXI,@RCIVLB,@RCIVLI,@RCIVLA,@RCIVLR,@RCITIP,@RCIPRG,@RCIPLI,@RCICMI
		

		WHILE @@FETCH_STATUS = 0 BEGIN
			IF @RCITXI = @ivatx1
			BEGIN
				SET @eivav1 = @RCIVLR
				SET @ebivav1 = @RCIVLB
			END

			IF @RCITXI = @ivatx2
			BEGIN
				SET @eivav2 = @RCIVLR
				SET @ebivav2 = @RCIVLB
			END

			IF @RCITXI = @ivatx3
			BEGIN
				SET @eivav3 = @RCIVLR
				SET @ebivav3 = @RCIVLB
			END

			IF @RCITXI = @ivatx4
			BEGIN
				SET @eivav4 = @RCIVLR
				SET @ebivav4 = @RCIVLB
			END

			IF @RCITXI = @ivatx5
			BEGIN
				SET @eivav5 = @RCIVLR
				SET @ebivav5 = @RCIVLB
			END

			IF @RCITXI = @ivatx6
			BEGIN
				SET @eivav6 = @RCIVLR
				SET @ebivav6 = @RCIVLB
			END

			IF @RCITXI = @ivatx7
			BEGIN
				SET @eivav7 = @RCIVLR
				SET @ebivav7 = @RCIVLB
			END

			IF @RCITXI = @ivatx8
			BEGIN
				SET @eivav8 = @RCIVLR
				SET @ebivav8 = @RCIVLB
			END

			IF @RCITXI = @ivatx9
			BEGIN
				SET @eivav9 = @RCIVLR
				SET @ebivav9 = @RCIVLB
			END
			
			FETCH NEXT FROM curRI INTO @RCILIL,@RCITXI,@RCIVLB,@RCIVLI,@RCIVLA,@RCIVLR,@RCITIP,@RCIPRG,@RCIPLI,@RCICMI
		END
	FIM:
		CLOSE curRI
		DEALLOCATE curRI
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ReciboLin
-- Integração de linhas de recibos (documentos liquidados)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ReciboLin]
	@RCCEXR VARCHAR(30),
	@RCCTPD VARCHAR(10),
	@ndoc INT,
	@RCCNDC INT,
	@moeda VARCHAR(11),
	@restamp CHAR(25),
	@rdata DATETIME,
	@cheque INT,
	@process INT,
	@ValidateDocTotals NUMERIC(19,6)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @DocTipoOrig VARCHAR(10)
	DECLARE @DocSerOrig VARCHAR(4)
	DECLARE @DocNumOrig BIGINT
	DECLARE @DocAnoOrig INT
	DECLARE @NDocOrig INT
	DECLARE @PercPagOrig NUMERIC(18,5)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocNome VARCHAR(20)
	DECLARE @DocArmazem VARCHAR(10)
	DECLARE @DocTipoDoc VARCHAR(1)
	DECLARE @DocTipoDocFor VARCHAR(1)

	DECLARE @RCLLIN INT
	DECLARE @RCLACL VARCHAR(2000)

	DECLARE @rlstamp CHAR(25)
	DECLARE @rno INT
	DECLARE @cdesc VARCHAR(20)
	DECLARE @nrdoc BIGINT
	DECLARE @eval NUMERIC(19,6)
	DECLARE @val NUMERIC(18,5)
	DECLARE @erec NUMERIC(19,6)
	DECLARE @rec NUMERIC(18,5)
	DECLARE @datalc DATETIME
	DECLARE @dataven DATETIME
	DECLARE @ccstamp CHAR(25)
	DECLARE @cm INT
	--DECLARE @process INT
	DECLARE @escval NUMERIC(18,5)
	DECLARE @escrec NUMERIC(18,5)
	DECLARE @eivav1 NUMERIC(19,6)
	DECLARE @ivav1 NUMERIC(18,5)
	DECLARE @bivav1 NUMERIC(18,5)
	DECLARE @eivav2 NUMERIC(19,6)
	DECLARE @ivav2 NUMERIC(18,5)
	DECLARE @bivav2 NUMERIC(18,5)
	DECLARE @eivav3 NUMERIC(19,6)
	DECLARE @ivav3 NUMERIC(18,5)
	DECLARE @bivav3 NUMERIC(18,5)
	DECLARE @eivav4 NUMERIC(19,6)
	DECLARE @ivav4 NUMERIC(18,5)
	DECLARE @bivav4 NUMERIC(18,5)
	DECLARE @eivav5 NUMERIC(19,6)
	DECLARE @ivav5 NUMERIC(18,5)
	DECLARE @bivav5 NUMERIC(18,5)
	DECLARE @eivav6 NUMERIC(19,6)
	DECLARE @ivav6 NUMERIC(18,5)
	DECLARE @bivav6 NUMERIC(18,5)
	DECLARE @eivav7 NUMERIC(19,6)
	DECLARE @ivav7 NUMERIC(18,5)
	DECLARE @bivav7 NUMERIC(18,5)
	DECLARE @eivav8 NUMERIC(19,6)
	DECLARE @ivav8 NUMERIC(18,5)
	DECLARE @bivav8 NUMERIC(18,5)
	DECLARE @eivav9 NUMERIC(19,6)
	DECLARE @ivav9 NUMERIC(18,5)
	DECLARE @bivav9 NUMERIC(18,5)
	DECLARE @lordem INT
	DECLARE @evori NUMERIC(19,6)
	DECLARE @vori NUMERIC(18,5)
	DECLARE @eivavori1 NUMERIC(19,6)
	DECLARE @ivavori1 NUMERIC(18,5)
	DECLARE @eivavori2 NUMERIC(19,6)
	DECLARE @ivavori2 NUMERIC(18,5)
	DECLARE @eivavori3 NUMERIC(19,6)
	DECLARE @ivavori3 NUMERIC(18,5)
	DECLARE @eivavori4 NUMERIC(19,6)
	DECLARE @ivavori4 NUMERIC(18,5)
	DECLARE @eivavori5 NUMERIC(19,6)
	DECLARE @ivavori5 NUMERIC(18,5)
	DECLARE @eivavori6 NUMERIC(19,6)
	DECLARE @ivavori6 NUMERIC(18,5)
	DECLARE @eivavori7 NUMERIC(19,6)
	DECLARE @ivavori7 NUMERIC(18,5)
	DECLARE @eivavori8 NUMERIC(19,6)
	DECLARE @ivavori8 NUMERIC(18,5)
	DECLARE @eivavori9 NUMERIC(19,6)
	DECLARE @ivavori9 NUMERIC(18,5)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT
	DECLARE @desc1 VARCHAR(100)
	DECLARE @enaval NUMERIC(19,6)
	DECLARE @CCIvaTx1 NUMERIC(5,2)
	DECLARE @CCIvaTx2 NUMERIC(5,2)
	DECLARE @CCIvaTx3 NUMERIC(5,2)
	DECLARE @CCIvaTx4 NUMERIC(5,2)
	DECLARE @CCIvaTx5 NUMERIC(5,2)
	DECLARE @CCIvaTx6 NUMERIC(5,2)
	DECLARE @CCIvaTx7 NUMERIC(5,2)
	DECLARE @CCIvaTx8 NUMERIC(5,2)
	DECLARE @CCIvaTx9 NUMERIC(5,2)
	DECLARE @CountRCI INT

	DECLARE @reexgiva INT

	DECLARE @RETstamp CHAR(25)
	DECLARE @RETDateTimeTmp DATETIME
	DECLARE @RETDateStr CHAR(8)
	DECLARE @RETTimeStr CHAR(11)
	DECLARE @ivatx1 NUMERIC(5,2)
	DECLARE @ivatx2 NUMERIC(5,2)
	DECLARE @ivatx3 NUMERIC(5,2)
	DECLARE @ivatx4 NUMERIC(5,2)
	DECLARE @ivatx5 NUMERIC(5,2)
	DECLARE @ivatx6 NUMERIC(5,2)
	DECLARE @ivatx7 NUMERIC(5,2)
	DECLARE @ivatx8 NUMERIC(5,2)
	DECLARE @ivatx9 NUMERIC(5,2)

	DECLARE @bdemp VARCHAR(2)
	DECLARE @Desconto NUMERIC(19,6)
	
	/*Validações*/
	DECLARE @BaseInc NUMERIC(19,6)
	DECLARE @DiffVAL NUMERIC(19,6)
	DECLARE @iva1 NUMERIC(19,6)
	DECLARE @iva2 NUMERIC(19,6)
	DECLARE @iva3 NUMERIC(19,6)
	DECLARE @iva4 NUMERIC(19,6)
	DECLARE @iva5 NUMERIC(19,6)
	DECLARE @iva6 NUMERIC(19,6)
	DECLARE @iva7 NUMERIC(19,6)
	DECLARE @iva8 NUMERIC(19,6)
	DECLARE @iva9 NUMERIC(19,6)
	DECLARE @Msg VARCHAR(200)
	DECLARE @MsgErro VARCHAR(200)
	DECLARE @DOC VARCHAR(80)

	DECLARE curRCL CURSOR FOR
	SELECT 
		ISNULL(RCLNDC, 0),
		ISNULL(RCLDOT, ''),
		ISNULL(RCLDOS, ''),
		ISNULL(RCLDON, 0),
		YEAR(RCLDDO),
		ISNULL(RCLVLA, 0.0),
		ISNULL(RCLVLR, 0.0),
		ISNULL(RCLVLO, 0.0),
		ISNULL(RCLLIN*10000, 0),
		CAST(ISNULL(RCLTERM, 0) AS VARCHAR(4)),
		ISNULL(RCLLIN, 0),
		ISNULL(RCLACL, '')
	FROM MSRCL(nolock)
	WHERE RCLEXR = @RCCEXR AND RCLTPD = @RCCTPD AND RCLSER = @ndoc AND RCLNDC = @RCCNDC

	OPEN curRCL

		FETCH NEXT FROM curRCL INTO @rno, @DocTipoOrig, @DocSerOrig, @DocNumOrig, @DocAnoOrig, @eval, @erec, @evori, @lordem, @DocTerminal, @RCLLIN, @RCLACL
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
			
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @rlstamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				
				SET @ccstamp = ''
				IF (@RCLACL <> '')
				BEGIN
					SET @ccstamp = dbo.ExtractFromACL(@RCLACL, 5)
				END
				
				EXECUTE SPMSS_GetDadosDoc 2, @DocTipoOrig, @DocSerOrig, @NDocOrig OUTPUT, @DocNome OUTPUT, @DocTipoDocFor OUTPUT, @DocTipoDoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT
				EXECUTE SPMSS_GetCCInfo @NDocOrig, @DocNumOrig, @DocAnoOrig, @cdesc OUTPUT, @nrdoc OUTPUT, @datalc OUTPUT, @dataven OUTPUT, @ccstamp OUTPUT, @cm OUTPUT, @eivavori1 OUTPUT, @ivavori1 OUTPUT, @eivavori2 OUTPUT, @ivavori2 OUTPUT, @eivavori3 OUTPUT, @ivavori3 OUTPUT, @eivavori4 OUTPUT, @ivavori4 OUTPUT, @eivavori5 OUTPUT, @ivavori5 OUTPUT, @eivavori6 OUTPUT, @ivavori6 OUTPUT, @eivavori7 OUTPUT, @ivavori7 OUTPUT, @eivavori8 OUTPUT, @ivavori8 OUTPUT, @eivavori9 OUTPUT, @ivavori9 OUTPUT, @CCIvaTx1 OUTPUT, @CCIvaTx2 OUTPUT, @CCIvaTx3 OUTPUT, @CCIvaTx4 OUTPUT, @CCIvaTx5 OUTPUT, @CCIvaTx6 OUTPUT, @CCIvaTx7 OUTPUT, @CCIvaTx8 OUTPUT, @CCIvaTx9 OUTPUT

				--SET @process = 1

				SET @PercPagOrig = @erec / @evori
				SET @enaval = @eval

				SET @eivav1 = @eivavori1 * @PercPagOrig
				SET @eivav2 = @eivavori2 * @PercPagOrig
				SET @eivav3 = @eivavori3 * @PercPagOrig
				SET @eivav4 = @eivavori4 * @PercPagOrig
				SET @eivav5 = @eivavori5 * @PercPagOrig
				SET @eivav6 = @eivavori6 * @PercPagOrig
				SET @eivav7 = @eivavori7 * @PercPagOrig
				SET @eivav8 = @eivavori8 * @PercPagOrig
				SET @eivav9 = @eivavori9 * @PercPagOrig
				SET @ivav1 = @ivavori1 * @PercPagOrig
				SET @ivav2 = @ivavori2 * @PercPagOrig
				SET @ivav3 = @ivavori3 * @PercPagOrig
				SET @ivav4 = @ivavori4 * @PercPagOrig
				SET @ivav5 = @ivavori5 * @PercPagOrig
				SET @ivav6 = @ivavori6 * @PercPagOrig
				SET @ivav7 = @ivavori7 * @PercPagOrig
				SET @ivav8 = @ivavori8 * @PercPagOrig
				SET @ivav9 = @ivavori9 * @PercPagOrig

				-- validar se é recibo de iva de caixa
				SELECT @reexgiva = CASE WHEN dbo.ExtractFromACL(RCCACL, 2) = 'S' THEN 1 ELSE 0 END FROM MSRCC WHERE RCCEXR = @RCCEXR AND RCCTPD = @RCCTPD AND RCCSER = @ndoc AND RCCNDC = @RCCNDC 
				
				-- se existir detalhes de IVA no MSS sobrepor os cálculos anteriores (poderia dar diferenças de arredondamentos)
				SELECT @CountRCI=Count(*) FROM MSRCI WHERE RCIEXR = @RCCEXR AND RCITPD = @RCCTPD AND RCISER = @ndoc AND RCINDC = @RCCNDC AND RCILIN = @RCLLIN
				IF @CountRCI > 0
				BEGIN
					EXEC SPMSS_ReciboLinIVAs @RCCEXR, @RCCTPD, @ndoc, @RCCNDC, @RCLLIN,	@restamp, @rlstamp, @ccivatx1, @ccivatx2, @ccivatx3, @ccivatx4, @ccivatx5, @ccivatx6, @ccivatx7, @ccivatx8, @ccivatx9, @eivav1 OUTPUT, @eivav2 OUTPUT, @eivav3 OUTPUT, @eivav4 OUTPUT, @eivav5 OUTPUT, @eivav6 OUTPUT, @eivav7 OUTPUT, @eivav8 OUTPUT, @eivav9 OUTPUT, @bivav1 OUTPUT, @bivav2 OUTPUT, @bivav3 OUTPUT, @bivav4 OUTPUT, @bivav5 OUTPUT, @bivav6 OUTPUT, @bivav7 OUTPUT, @bivav8 OUTPUT, @bivav9 OUTPUT

					-- Vai inserir no tabela ret os totais por taxa de iva da linha
					IF @eivav1 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 1, @ivatx1 OUTPUT

						IF @bivav1 IS NULL
							SET @bivav1 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 1, @ivatx1, 0, 0, @eivav1, 0, @bivav1, 0, @bivav1, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0)

						IF(@ValidateDocTotals >= 0 and @bivav1<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav1 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência1 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END 
						
					END
					IF @eivav2 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 2, @ivatx2 OUTPUT

						IF @bivav2 IS NULL
							SET @bivav2 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 2, @ivatx2, 0, 0, @eivav2, 0, @bivav2, 0, @bivav2, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0)

						IF(@ValidateDocTotals >= 0 and @bivav2<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav2 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência2 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END 
						
					END
					IF @eivav3 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 3, @ivatx3 OUTPUT

						IF @bivav3 IS NULL
							SET @bivav3 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 3, @ivatx3, 0, 0, @eivav3, 0, @bivav3, 0, @bivav3, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0) 

						IF(@ValidateDocTotals >= 0 and @bivav3<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav3 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência3 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END  
						
					END
					IF @eivav4 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 4, @ivatx4 OUTPUT

						IF @bivav4 IS NULL
							SET @bivav4 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 4, @ivatx4, 0, 0, @eivav4, 0, @bivav4, 0, @bivav4, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0)

						IF(@ValidateDocTotals >= 0 and @bivav4<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav4 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência4 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END 
						
					END
					IF @eivav5 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 5, @ivatx5 OUTPUT

						IF @bivav5 IS NULL
							SET @bivav5 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 5, @ivatx5, 0, 0, @eivav5, 0, @bivav5, 0, @bivav5, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0) 

						IF(@ValidateDocTotals >= 0 and @bivav5<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav5 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência5 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END
						
					END
					IF @eivav6 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 6, @ivatx6 OUTPUT

						IF @bivav6 IS NULL
							SET @bivav6 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 6, @ivatx6, 0, 0, @eivav6, 0, @bivav6, 0, @bivav6, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0)

						IF(@ValidateDocTotals >= 0 and @bivav6<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav6 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência6 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END  
						
					END
					IF @eivav7 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 7, @ivatx7 OUTPUT

						IF @bivav7 IS NULL
							SET @bivav7 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 7, @ivatx7, 0, 0, @eivav7, 0, @bivav7, 0, @bivav7, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0)

						IF(@ValidateDocTotals >= 0 and @bivav7<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav7 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência7 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END  
						
					END
					IF @eivav8 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 8, @ivatx8 OUTPUT

						IF @bivav8 IS NULL
							SET @bivav8 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 8, @ivatx8, 0, 0, @eivav8, 0, @bivav8, 0, @bivav8, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0)

						IF(@ValidateDocTotals >= 0 and @bivav8<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav8 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência8 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END  
						
					END
					IF @eivav9 > 0
					BEGIN
						WAITFOR DELAY '00:00:00.200' 
						SET @RETDateTimeTmp = GETDATE()
						SET @RETDateStr = dbo.DateToString(@RETDateTimeTmp)
						SET @RETTimeStr = dbo.TimeToString(@RETDateTimeTmp)
						SET @RETstamp = 'MSS_' + @RETDateStr + @RETTimeStr

						EXECUTE SPMSS_GetTaxaIVA 9, @ivatx9 OUTPUT
					
						IF @bivav9 IS NULL
							SET @bivav9 = 0

						INSERT INTO ret(retstamp, restamp, rlstamp, ccstamp, codigo, taxa, evalivacaixa, valivacaixa, eivaori, ivaori, ebaseori, baseori, ebase, base, ivacaixasup12, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, marcada) 
						VALUES(@RETstamp, @restamp, @rlstamp, @ccstamp, 9, @ivatx9, 0, 0, @eivav9, 0, @bivav9, 0, @bivav9, 0, 0, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 0) 

						IF(@ValidateDocTotals >= 0 and @bivav9<>0)
						BEGIN
							SELECT @BaseInc = ebase FROM ret WHERE retstamp=@RETstamp

							SET @DiffVAL = ABS(@bivav9 - @BaseInc)

							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RETSTAMP = ' + @RETstamp
							SET @MsgErro = @DOC + ' A diferença da base de incidência9 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

							if (@DiffVAL > @ValidateDocTotals)
								RAISERROR(@MsgErro,16,1)
						END 
						
					END
				END

				SET @Desconto = 0
				IF dbo.ExtractFromACL(@RCLACL, 7) <> ''
					SET @Desconto = CAST(dbo.ExtractFromACL(@RCLACL, 7) AS NUMERIC(19,6))

				INSERT INTO rl(rlstamp, rno, cdesc, nrdoc, eval, erec, datalc, dataven, restamp, ccstamp, cm, process, cheque, moeda, rdata, escval, escrec, eivav1, ivav1, eivav2, ivav2, eivav3, ivav3, eivav4, ivav4, eivav5, ivav5, eivav6, ivav6, eivav7, ivav7, eivav8, ivav8, eivav9, ivav9, lordem, ndoc, evori, vori, eivavori1, ivavori1, eivavori2, ivavori2, eivavori3, ivavori3, eivavori4, ivavori4, eivavori5, ivavori5, eivavori6, ivavori6, eivavori7, ivavori7, eivavori8, ivavori8, eivavori9, ivavori9, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, moedoc, enaval, reexgiva, ivatx1, ivatx2, ivatx3, ivatx4, ivatx5, ivatx6, ivatx7, ivatx8, ivatx9, desconto) 
				VALUES (@rlstamp, @rno, @cdesc, @nrdoc, @eval, @erec, @datalc, @dataven, @restamp, @ccstamp, @cm, @process, @cheque, @moeda, @rdata, dbo.EurToEsc(@eval), dbo.EurToEsc(@erec), @eivav1, @ivav1, @eivav2, @ivav2, @eivav3, @ivav3, @eivav4, @ivav4, @eivav5, @ivav5, @eivav6, @ivav6, @eivav7, @ivav7, @eivav8, @ivav8, @eivav9, @ivav9, @lordem, @ndoc, @evori, dbo.EurToEsc(@evori), @eivavori1, @ivavori1, @eivavori2, @ivavori2, @eivavori3, @ivavori3, @eivavori4, @ivavori4, @eivavori5, @ivavori5, @eivavori6, @ivavori6, @eivavori7, @ivavori7, @eivavori8, @ivavori8, @eivavori9, @ivavori9, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @moeda, @enaval, @reexgiva, @ccivatx1, @ccivatx2, @ccivatx3, @ccivatx4, @ccivatx5, @ccivatx6, @ccivatx7, @ccivatx8, @ccivatx9, @Desconto)
				
				IF(@ValidateDocTotals >= 0)
				BEGIN
					SELECT @iva1 = eivav1, @iva2 = eivav2, @iva3 = eivav3, @iva4 = eivav4, @iva5 = eivav5, @iva6 = eivav6, @iva7 = eivav7, @iva8 = eivav8, @iva9 = eivav9 from rl where rlstamp=@rlstamp

					SET @DiffVAL = ABS(@iva1 - @eivav1)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva1 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)
					
					SET @DiffVAL = ABS(@iva2 - @eivav2)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva2 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1) 
					
					SET @DiffVAL = ABS(@iva3 - @eivav3)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva3 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)   

					SET @DiffVAL = ABS(@iva4 - @eivav4)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva4 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)
						
					SET @DiffVAL = ABS(@iva5 - @eivav5)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva5 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)
					
					SET @DiffVAL = ABS(@iva6 - @eivav6)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva6 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)

					SET @DiffVAL = ABS(@iva7 - @eivav7)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva7 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)

					SET @DiffVAL = ABS(@iva8 - @eivav8)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva8 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)

					SET @DiffVAL = ABS(@iva9 - @eivav9)
					
					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@RCCNDC as VARCHAR(10)) + ' RLSTAMP = ' + @rlstamp
					SET @MsgErro = @DOC + ' A diferença do valor do iva9 do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)
				END
				
				-- actualizar descrição que aparece nas observações das contas correntes
				SELECT @desc1 = RTRIM(LTRIM(desc1)) FROM re WHERE restamp = @restamp
				IF LEN(@desc1) < 100
				BEGIN
					IF @desc1 <> ''
						SET @desc1 = @desc1 + ' '
					SET @desc1 = @desc1 + RTRIM(LTRIM(@cdesc)) + ' nº ' + CAST(@DocNumOrig AS VARCHAR(10))
					UPDATE re SET desc1 = LEFT(@desc1, 100) WHERE restamp = @restamp
				END
				
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curRCL INTO @rno, @DocTipoOrig, @DocSerOrig, @DocNumOrig, @DocAnoOrig, @eval, @erec, @evori, @lordem, @DocTerminal, @RCLLIN, @RCLACL
		END
	FIM:
		CLOSE curRCL
		DEALLOCATE curRCL
END

GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ReciboUSR
-- Personalizações na integração de cabeçalhos de recibos
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ReciboUSR]
	@RCCEXR VARCHAR(30),	-- Exercício do recibo no MSS
	@RCCTPD VARCHAR(10),	-- Código do recibo no MSS
	@RCCSER VARCHAR(4),		-- Série do recibo no MSS
	@RCCNDC INT,			-- Número do recibo no MSS
	@restamp CHAR(25),		-- Stamp do recibo
	@no INT					-- Nº do cliente
AS
BEGIN
	SET NOCOUNT ON;


END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ReciboPag
-- Lançamento de títulos quando no MSS o pagamento é do tipo Cheque
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ReciboPag]
	@RCCEXR VARCHAR(30),
	@RCCTPD VARCHAR(10),
	@ndoc INT,
	@RCCNDC INT,
	@moeda VARCHAR(11),
	@restamp CHAR(25),
	@rdata CHAR(8)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @DocTerminal VARCHAR(5)

	DECLARE @rechstamp CHAR(25)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	DECLARE @FirstPagCheque INT

	DECLARE @RCPBAN VARCHAR(30)
	DECLARE @RCPNMC VARCHAR(35)
	DECLARE @RCPDTC VARCHAR(8)
	DECLARE @RCPVLC NUMERIC(18,5)
	DECLARE @RCPTIP CHAR(25)
	DECLARE @RCPTERM VARCHAR(4)
	DECLARE @DataCheque DateTime
	DECLARE @ValEsc NUMERIC(18,5)
	DECLARE @TpTit VARCHAR(55)
	DECLARE @TpTitId CHAR(25)

	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE curRP CURSOR FOR
	SELECT 
		ISNULL(RCPBAN, ''),
		ISNULL(RCPNMC, ''),
		ISNULL(RCPDTC, ''),
		ISNULL(RCPVLC, 0),
		ISNULL(RCPTIP, ''),
		ISNULL(RCPTERM, 0)
	FROM MSRCP(nolock)
	WHERE RCPEXR = @RCCEXR AND RCPTPD = @RCCTPD AND RCPSER = @ndoc AND RCPNDC = @RCCNDC AND RCPVLC > 0
	
	SET @FirstPagCheque = 0

	OPEN curRP

		FETCH NEXT FROM curRP INTO @RCPBAN, @RCPNMC, @RCPDTC, @RCPVLC, @RCPTIP, @RCPTERM 
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
			
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()

				SET @FirstPagCheque = @FirstPagCheque + 1				

				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @rechstamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@RCPTERM AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@RCPTERM AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr
				
				EXECUTE SPMSS_GetCondVend @RCPTIP, @TpTitId output, @TpTit output
				
				SET @DataCheque = dbo.StringToDate(@RCPDTC)
				SET @ValEsc = dbo.EurToEsc(@RCPVLC)

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				
				IF @FirstPagCheque = 1
				BEGIN
					UPDATE re SET cheque = 1, chdata = @DataCheque, chmoeda = @moeda, echtotal=0, chtotal=0 where restamp = @restamp
				END
				
				INSERT INTO rech(rechstamp, clbanco, clcheque, chdata, chvalor, echvalor, tptit, restamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) 
				VALUES (@rechstamp, @RCPBAN, @RCPNMC, @DataCheque, @ValEsc, @RCPVLC, @TpTit, @restamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)

				UPDATE re SET chtotal = chtotal + @ValEsc, echtotal = echtotal + @RCPVLC where restamp = @restamp					

			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curRP INTO @RCPBAN, @RCPNMC, @RCPDTC, @RCPVLC, @RCPTIP, @RCPTERM 
		END
	FIM:
		CLOSE curRP
		DEALLOCATE curRP
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Recibo
-- Integração do cabeçalho de recibo
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_Recibo]
	@EstabSeparator CHAR(1),
	@ClassificRecibo VARCHAR(12),
	@DescontoFinanceiro INT, -- Código do desconto financeiro da tabela CM1
	@ValidateDocLines INT,
	@ValidateDocSequence INT,
	@ValidateDocTotals NUMERIC(19,6)
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @DocAnul CHAR(1)
	DECLARE @CliNumTmp VARCHAR(20)
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @CliTelefone VARCHAR(60)
	DECLARE @RecTerminal INT
	DECLARE @RCCEXR VARCHAR(30)
	DECLARE @RCCTPD VARCHAR(10)
	DECLARE @RCPNMC VARCHAR(35)
	DECLARE @RCPVLC NUMERIC(19,6)
	DECLARE @RCPDTC VARCHAR(8)
	DECLARE @RCPBAN VARCHAR(30)
	DECLARE @RCPTIP VARCHAR(30)

	DECLARE @restamp CHAR(25) 
	DECLARE @rno INT
	DECLARE @rdata DATETIME
	DECLARE @nome VARCHAR(55)
	DECLARE @etotal NUMERIC(19,6)
	DECLARE @total NUMERIC(18,6)
	DECLARE @no INT
	DECLARE @morada VARCHAR(55) 
	DECLARE @moeda VARCHAR(11)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @ncont VARCHAR(18)
	DECLARE @reano INT
	DECLARE @telocal VARCHAR(1)
	DECLARE @contado INT
	DECLARE @process INT
	DECLARE @procdata DATETIME
	DECLARE @cheque INT
	DECLARE @tptit VARCHAR(50)
	DECLARE @chmoeda VARCHAR(50)
	DECLARE @echtotal NUMERIC(19,6)
	DECLARE @chdata datetime
	DECLARE @clcheque VARCHAR(100)
	DECLARE @clbanco VARCHAR(100)
	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)
	
	DECLARE @zona VARCHAR(13)
	DECLARE @ollocal VARCHAR(50)
	DECLARE @vendedor INT
	DECLARE @vendnm VARCHAR(20)
	DECLARE @segmento VARCHAR(25)
	DECLARE @tipo VARCHAR(20)
	DECLARE @pais INT
	DECLARE @estab INT
	DECLARE @nmdoc VARCHAR(20)
	DECLARE @ndoc INT
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @rlstamp CHAR(25)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	DECLARE @DescontoFinanceiroNome NVARCHAR(20)
    SET @DescontoFinanceiroNome =(SELECT cmdesc FROM cm1 WHERE cm=@DescontoFinanceiro)
	DECLARE @descfin NUMERIC(19,6)
    DECLARE @eurovalorfin NUMERIC(19,6)
	DECLARE @TabIva INT

	DECLARE @InvoiceNO VARCHAR(60)
	DECLARE @ATCUD VARCHAR(100)
	DECLARE @anul INT
	
	/*Validações*/
	DECLARE @TotalRec NUMERIC(19,6)
	DECLARE @ContAnt INT
	DECLARE @ContLinhas INT
	DECLARE @ContLinhasTerminal INT
	DECLARE @TotalDOC NUMERIC(19,6)
	DECLARE @DiffVAL NUMERIC(19,6)
	DECLARE @Msg VARCHAR(200)
	DECLARE @MsgErro VARCHAR(200)
	DECLARE @DOC VARCHAR(80)
	DECLARE @DocACL VARCHAR(2000)
	
DECLARE curCabRe CURSOR FOR
	SELECT 
		ISNULL(RCCEXR, ''),
		ISNULL(RCCTPD, ''),
		CAST(ISNULL(RCCSER, '0') AS INT),
		ISNULL(RCCANU, 'N'),
		ISNULL(RCCNDC, 0),
		ISNULL(RCCDTA, ''),
		ISNULL(RCCCLI, ''),
		ISNULL(RCCVDC, 0),
		ISNULL(RCCVND, ''),
		ISNULL(RCCTERM, 0),
		ISNULL(RCPNMC, ''),
		ISNULL(RCPVLC, 0),
		ISNULL(RCPDTC, ''),
		ISNULL(RCPBAN, ''),
		ISNULL(RCPTIP, ''),
		ISNULL(RCCNOM, ''),
		ISNULL(RCCMOR, ''),
		ISNULL(RCCLOC, ''),
		ISNULL(RCCCPT, ''),
		ISNULL(RCCNCT, ''),
        ISNULL(RCCTXD, 0),
        ISNULL(RCCVLD, 0),
		ISNULL(RCCACL,'')
	FROM MSRCC(nolock)
	WHERE RCCSYNCR = 'N' ORDER BY RCCEXR, RCCTPD, RCCSER, RCCNDC

	OPEN curCabRe

		FETCH NEXT FROM curCabRe INTO @RCCEXR, @RCCTPD, @ndoc, @DocAnul, @rno, @rdata, @CliNumTmp, @etotal, @vendedor, @RecTerminal, @RCPNMC, @RCPVLC, @RCPDTC, @RCPBAN, @RCPTIP, @nome, @morada, @local, @codpost, @ncont, @DESCFIN,@eurovalorfin,@DocACL
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				BEGIN TRANSACTION
				
				IF CHARINDEX(@EstabSeparator, @CliNumTmp) > 0
				BEGIN
					SET @no = CAST(LEFT(@CliNumTmp, CHARINDEX(@EstabSeparator, @CliNumTmp) - 1) AS INT)
					SET @estab = CAST(RIGHT(@CliNumTmp, LEN(@CliNumTmp) - CHARINDEX(@EstabSeparator, @CliNumTmp)) AS INT)
				END
				ELSE
				BEGIN
					SET @no = CAST(@CliNumTmp AS INT)
					SET @estab = 0
				END

				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @restamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@RecTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@RecTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				SET @reano = YEAR(@rdata)
				
				SET @procdata = @DateStr

				IF dbo.ExtractFromACL(@DocACL, 23) <> ''
					SET @InvoiceNO = dbo.ExtractFromACL(@DocACL, 23)
				ELSE
					SET @InvoiceNO = @RCCTPD + ' ' + CAST(@ndoc AS VARCHAR(10)) + '/' + CAST(@rno AS VARCHAR(48))

				SET @ATCUD =  dbo.ExtractFromACL(@DocACL, 19)
				
				EXECUTE SPMSS_GetDadosRec @ndoc, @nmdoc OUTPUT
				
				/*Validar se o rec anterior existe, caso o parâmetro @ValidateDocSequence está a 1 e senão é o primeiro número da série*/
				IF (@ValidateDocSequence = 1 AND @rno > 1)
				BEGIN
					SELECT @ContAnt = COUNT(1) FROM re (NOLOCK) WHERE ndoc=@ndoc and reano=@reano and rno=(@rno - 1)

					IF @ContAnt = 0
					BEGIN
						SELECT @ContAnt = COUNT(1) FROM re (NOLOCK) WHERE ndoc=@ndoc and reano=@reano

						if @ContAnt <> 0
						BEGIN
							SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@rno-1 as VARCHAR(10)) + ' RESTAMP = ' + @restamp
							SET @MsgErro = @DOC + ' A sequência da numeração do Recibo não está correta!'
							RAISERROR(@MsgErro,16,1)
						END
					END
				END

				EXECUTE SPMSS_GetVendNome @vendedor, @vendnm OUTPUT
				
				EXECUTE SPMSS_GetCliInfo2 @no, @estab, @tipo OUTPUT, @zona OUTPUT, @segmento OUTPUT, @CliTelefone OUTPUT, @pais OUTPUT, @moeda OUTPUT, @ollocal OUTPUT, @contado OUTPUT, @fref OUTPUT, @ccusto OUTPUT, @TabIva OUTPUT
					
				IF @RCPVLC = 0
				BEGIN
					SET @cheque = 0
					SET @tptit = ''
					SET @chmoeda = ''
					SET @echtotal = 0
					SET @chdata = ''
					SET @clcheque = ''
					SET @clbanco = ''
					SET @telocal = 'C'
				END
				ELSE
				BEGIN
					SET @cheque = 1
					SET @tptit = 'Cheque'
					SET @chmoeda = @moeda
					SET @echtotal = @RCPVLC
					SET @chdata = dbo.DateToString(@RCPDTC)
					SET @clcheque = @RCPNMC
					SET @clbanco = @RCPBAN
					SET @telocal = 'B'
				END
					
				SET @RCPTIP = (SELECT descricao FROM tp(nolock) WHERE tpstamp = @RCPTIP)
				IF @RCPTIP is null SET @RCPTIP =''
				SET @RCPTIP = LEFT(@RCPTIP, 20)

				/*IF @DocAnul = 'S'
				BEGIN
					INSERT INTO re(restamp, rno, rdata, nome, no, morada, local, codpost, ncont, reano, vendedor, vendnm, segmento, tipo, pais, estab, nmdoc, ndoc,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,paymentrefnoori)
					VALUES (@restamp, @rno, @rdata, @nome, @no, @morada, @local, @codpost, @ncont, @reano, @vendedor, @vendnm, @segmento, @tipo, @pais, @estab, @nmdoc, @ndoc,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,@InvoiceNO) 

					SET @DateTimeTmp = GETDATE()
					SET @DateStr = dbo.DateToString(@DateTimeTmp)
					SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
					SET @rlstamp = 'MSS_' + @DateStr + @TimeStr
					
					SET @ousrinis = 'MSS T-' + CAST(@RecTerminal AS VARCHAR(3))
					SET @usrinis = 'MSS T-' + CAST(@RecTerminal AS VARCHAR(3))

					SET @ousrdata = @DateStr
					SET @usrdata = @DateStr

					SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
					SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

					INSERT INTO rl(rlstamp, rno, cdesc, restamp, rdata, lordem, ndoc, ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora) 
					VALUES (@rlstamp, @rno, 'DOC.ANULADO', @restamp, @rdata, 10000, @ndoc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora)
					
				END
				ELSE
				BEGIN
					INSERT INTO re(restamp, rno, rdata, nome, etotal, total, no, morada, local, codpost, ncont, reano, olcodigo, moeda, contado, process, procdata, vdata, zona, ollocal, vendedor, vendnm, segmento, tipo, pais, estab, nmdoc, ndoc,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora, cobrador, cobranca, memissao, moeda2, fref, ccusto, telocal, cheque, chdata, echtotal, chtotal, chmoeda, paymentrefnoori)
					VALUES (@restamp, @rno, @rdata, @nome, @etotal-@eurovalorfin, dbo.EurToEsc(@etotal-@eurovalorfin), @no, @morada, @local, @codpost, @ncont, @reano, @ClassificRecibo, @moeda, @contado, @process, @procdata, @rdata, @zona, case when rtrim(@ollocal)<>'' then @ollocal else 'Caixa' end, @vendedor, @vendnm, @segmento, @tipo, @pais, @estab, @nmdoc, @ndoc,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora, @vendnm, @RCPTIP, 'EURO', @moeda, @fref, @ccusto, @telocal, @cheque, @chdata, @echtotal, dbo.EurToEsc(@echtotal), @moeda, @InvoiceNO)					
					
					IF @DESCFIN>0
						INSERT INTO cc(ccstamp,datalc,dataven,cmdesc,nrdoc,ecred,nome,moeda,no,cm,ecredf,origem,obs,restamp) VALUES ('d'+@restamp,@rdata,@rdata,@DescontoFinanceiroNome,@rno,@eurovalorfin,@nome,'PTE ou EURO',@no,@DescontoFinanceiro,@eurovalorfin,'RE','',@restamp) 
					
					EXECUTE SPMSS_ReciboUSR @RCCEXR,@RCCTPD,@ndoc,@rno,@restamp,@no
					
					EXECUTE SPMSS_ReciboLin @RCCEXR, @RCCTPD, @ndoc, @rno, @moeda, @restamp, @rdata, @cheque
					
					EXECUTE SPMSS_ReciboPag @RCCEXR, @RCCTPD, @ndoc, @rno, @moeda, @restamp, @rdata
				END*/

				IF @DocAnul = 'S'
				BEGIN
					SET @process = 0
					SET @anul=1
				END
				ELSE
				BEGIN
					SET @anul=0
					SET @process = 1
				END

				INSERT INTO re(restamp, rno, rdata, nome, etotal, total, no, morada, local, codpost, ncont, reano, olcodigo, moeda, contado, process, procdata, vdata, zona, ollocal, vendedor, vendnm, segmento, tipo, pais, estab, nmdoc, ndoc,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora, cobrador, cobranca, memissao, moeda2, fref, ccusto, telocal, cheque, chdata, echtotal, chtotal, chmoeda, paymentrefnoori, anulado, efinv, fin, finv, atcud)
				VALUES (@restamp, @rno, @rdata, @nome, @etotal-@eurovalorfin, dbo.EurToEsc(@etotal-@eurovalorfin), @no, @morada, @local, @codpost, @ncont, @reano, @ClassificRecibo, @moeda, @contado, @process, @procdata, @rdata, @zona, case when rtrim(@ollocal)<>'' then @ollocal else 'Caixa' end, @vendedor, @vendnm, @segmento, @tipo, @pais, @estab, @nmdoc, @ndoc,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora, @vendnm, @RCPTIP, 'EURO', @moeda, @fref, @ccusto, @telocal, @cheque, @chdata, @echtotal, dbo.EurToEsc(@echtotal), @moeda, @InvoiceNO, @anul, @eurovalorfin, @DESCFIN, dbo.EurToEsc(@eurovalorfin), @ATCUD)					
					
				IF(@ValidateDocTotals >= 0)
				BEGIN
					/*Obter o total do recibo do PHC*/
					SELECT @TotalDOC=etotal FROM RE WHERE restamp=@restamp

					SET @TotalRec = @etotal-@eurovalorfin 


					SET @DiffVAL = ABS(@TotalRec - @TotalDOC)

					SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@rno as VARCHAR(10)) + ' RESTAMP = ' + @restamp
					SET @MsgErro = @DOC + ' A diferença do recibo do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)
				END
					
				IF @DESCFIN>0
					INSERT INTO cc(ccstamp,datalc,dataven,cmdesc,nrdoc,ecred,nome,moeda,no,cm,ecredf,origem,obs,restamp) VALUES ('d'+@restamp,@rdata,@rdata,@DescontoFinanceiroNome,@rno,@eurovalorfin,@nome,/*'PTE ou EURO'*/@moeda,@no,@DescontoFinanceiro,@eurovalorfin,'RE','',@restamp) 
					
				EXECUTE SPMSS_ReciboUSR @RCCEXR,@RCCTPD,@ndoc,@rno,@restamp,@no
					
				EXECUTE SPMSS_ReciboLin @RCCEXR, @RCCTPD, @ndoc, @rno, @moeda, @restamp, @rdata, @cheque, @process, @ValidateDocTotals
				
				IF @ValidateDocLines = 1
				BEGIN
					
					IF (dbo.ExtractFromACL(@DocACL, 15) <> '')
					BEGIN
						SET @ContLinhasTerminal = CAST(dbo.ExtractFromACL(@DocACL, 15) AS INT)

						SELECT @ContLinhas = count(1) FROM rl WHERE restamp= @restamp

						SET @DOC = @RCCEXR + ' ' + @RCCTPD + ' ' + CAST(@ndoc as VARCHAR(10)) + '/' + CAST(@rno as VARCHAR(10)) + ' RESTAMP = ' + @restamp
						SET @MsgErro = @DOC + ' Nº de linhas inserido no PHC (' + CAST(@ContLinhas AS VARCHAR(10)) + ') é diferente do número de linhas geradas no terminal (' + CAST(@ContLinhasTerminal AS VARCHAR(10)) + ')'

						if @ContLinhas <> @ContLinhasTerminal
							RAISERROR(@MsgErro,16,1)
					END
				END
				
				EXECUTE SPMSS_ReciboPag @RCCEXR, @RCCTPD, @ndoc, @rno, @moeda, @restamp, @rdata

				UPDATE MSRCC Set RCCSYNCR='S' WHERE RCCEXR=@RCCEXR AND RCCTPD=@RCCTPD And RCCSER=@ndoc And RCCNDC=@rno
				UPDATE MSRCL Set RCLSYNCR='S' WHERE RCLEXR=@RCCEXR AND RCLTPD=@RCCTPD And RCLSER=@ndoc And RCLNDC=@rno
				UPDATE MSRCP Set RCPSYNCR='S' WHERE RCPEXR=@RCCEXR AND RCPTPD=@RCCTPD And RCPSER=@ndoc And RCPNDC=@rno
				
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				ROLLBACK TRANSACTION
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			FETCH NEXT FROM curCabRe INTO @RCCEXR, @RCCTPD, @ndoc, @DocAnul, @rno, @rdata, @CliNumTmp, @etotal, @vendedor, @RecTerminal, @RCPNMC, @RCPVLC, @RCPDTC, @RCPBAN, @RCPTIP, @nome, @morada, @local, @codpost, @ncont, @DESCFIN,@eurovalorfin,@DocACL
		END
	FIM:
		CLOSE curCabRe
		DEALLOCATE curCabRe
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_CheckFornecedor
-- Verificar se o fornecedor já existe
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_CheckFornecedor]
	@ForNum INT,
	@EstabNum INT,
	@flstamp CHAR(25) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ForCount INT
	SELECT @flstamp = flstamp FROM fl(nolock) WHERE "no" = @ForNum AND estab = @EstabNum
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_FornecedoresUSR
-- Personalizações na integração de fornecedores
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_FornecedoresUSR] 
	@FORCOD VARCHAR(20),	-- Código do fornecedor no MSS
	@no INT,				-- Código do fornecedor no PHC
	@estab INT				-- Código do estabelecimento no PHC
AS
BEGIN
	SET NOCOUNT ON;
END

GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Fornecedores
-- Integração de fornecedores
-- *******************************************************************************************************************

CREATE PROCEDURE [dbo].[SPMSS_Fornecedores]
	@EstabSeparator CHAR(1),
	@Moeda VARCHAR(11)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @ForNumTmp VARCHAR(20)
	DECLARE @CondVendTmp VARCHAR(30)
	DECLARE @flstampTmp CHAR(25)
	DECLARE @ForTerminal VARCHAR(5)

	DECLARE @fostamp CHAR(25)
	DECLARE @Forno INT
	DECLARE @nome VARCHAR(55)
	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @ncont VARCHAR(18)
	DECLARE @eplafond NUMERIC(19,6)
	DECLARE @esaldo NUMERIC(16,2)
	DECLARE @telefone VARCHAR(60)
	DECLARE @tlmvl VARCHAR(45)
	DECLARE @fax VARCHAR(60)
	DECLARE @c2tacto VARCHAR(30)
	DECLARE @contacto VARCHAR(30)
	DECLARE @c3tacto VARCHAR(30)
	DECLARE @email VARCHAR(45)
	DECLARE @obs VARCHAR(240)
	DECLARE @desconto NUMERIC(6,2)
	DECLARE @descpp NUMERIC(6,2)
	DECLARE @nome2 VARCHAR(55)
	DECLARE @nib VARCHAR(28)
	DECLARE @estab INT
	DECLARE @pais INT
	DECLARE @tpstamp CHAR(25)
	DECLARE @tpdesc VARCHAR(55)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @descregiva VARCHAR(60)
	DECLARE @pncont VARCHAR(2)
	DECLARE @CliAcl VARCHAR(2000)
	DECLARE @CliEnd VARCHAR(256)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @ForNumTmpORI VARCHAR(20)

	SET @Pais = 1

    DECLARE curFornecedores CURSOR FOR 
	SELECT 
		ISNULL(CLICOD, ''), -- código
		ISNULL(CLINOM, ''), -- nome
		ISNULL(CLIMOR, ''), -- morada
		ISNULL(CLILOC, ''), -- local
		ISNULL(CLICPT, ''), -- cod postal
		ISNULL(CLINCT, ''), -- contribuinte
		ISNULL(CLIPLA, 0), -- plafond
		ISNULL(CLIRES, 0), -- responsabilidade
		ISNULL(CLITEL, ''), -- telefone
		ISNULL(CLITLM, ''), -- telemovel
		ISNULL(CLIFAX, ''), -- fax
		'', -- contacto fin
		'', -- contacto com
		'', -- contacto oper
		ISNULL(CLIEML, ''), -- email
		ISNULL(CLIOBS, ''), -- obs
		ISNULL(CLITDC, 0), -- taxa desconto
		ISNULL(CLIDPP, 0), -- desconto pp
		ISNULL(CLINM2, ''), -- nome 2
		--ISNULL(CLICT1, ''), -- categoria
		ISNULL(CLINIB, ''), -- nib
		ISNULL(CLICVD, ''), -- condição de venda
		ISNULL(CLITERM, 0),  -- terminal
		ISNULL(CLIIVA, ''),	-- regime de IVA
		ISNULL(CLIPAI, ''),  -- país
		ISNULL(CLIACL, '')
	FROM MSCLI(nolock) WHERE CLISYNCR = 'N' AND (UPPER(CLITIP) = 'F')

	OPEN curFornecedores

		FETCH NEXT FROM curFornecedores INTO @ForNumTmp, @nome, @morada, @local, @codpost, @ncont, @eplafond, @esaldo, @telefone, @tlmvl, @fax, @c2tacto, @contacto, @c3tacto, 
		@email, @obs, @desconto, @descpp, @nome2, @nib, @CondVendTmp, @ForTerminal, @descregiva, @pncont, @CliAcl
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				SET @ForNumTmpORI = @ForNumTmp
				SET @flstampTmp = null
				
				IF (SUBSTRING(@ForNumTmp, 1, 2) = 'F.')
					SET @ForNumTmp = SUBSTRING(@ForNumTmp, 3, LEN(@ForNumTmp) - 2) 
				
				SET @Forno = CAST(@ForNumTmp AS INT)
				SET @estab = 0

				EXECUTE SPMSS_GetCondVend @CondVendTmp, @tpstamp OUTPUT, @tpdesc OUTPUT
				if @tpstamp is null
                    set @tpstamp = ''

				if @tpdesc is null
					set @tpdesc = ''

				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @fostamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@ForTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@ForTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				EXECUTE SPMSS_CheckFornecedor @Forno, @estab, @flstampTmp OUTPUT
				
				IF dbo.ExtractFromACL(@CliAcl, 12) <> ''
					SET @CliEnd = dbo.ExtractFromACL(@CliAcl, 12)
				ELSE
					SET @CliEnd = ''

				IF @flstampTmp is null
				BEGIN
					INSERT INTO fl(flstamp,no,nome,morada,local,codpost,ncont,eplafond,esaldo,telefone,tlmvl,fax,c2tacto,contacto,c3tacto,email,obs,desconto,descpp,nome2,nib,estab,moeda,pais,tpstamp,tpdesc,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,descregiva,pncont,url) 
					VALUES (@fostamp,@Forno,@nome,@morada,@local,@codpost,@ncont,@eplafond,@esaldo,@telefone,@tlmvl,@fax,@c2tacto,@contacto,@c3tacto,@email,@obs,@desconto,@descpp,@nome2,@nib,@estab,@moeda,@pais,@tpstamp,@tpdesc,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,@descregiva,@pncont,@CliEnd)

					IF @@ERROR = 0 
						UPDATE MSCLI SET CLISYNCR = 'S' WHERE CLICOD = @ForNumTmpORI
				END
				ELSE
				BEGIN
					UPDATE fl SET
						nome = @nome,
						morada = @morada,
						local = @local,
						codpost = @codpost,
						ncont = @ncont,
						eplafond = @eplafond,
						esaldo = @esaldo,
						telefone = @telefone,
						tlmvl = @tlmvl,
						fax = @fax,
						c2tacto = @c2tacto,
						contacto = @contacto,
						c3tacto = @c3tacto,
						email = @email,
						obs = @obs,
						desconto = @desconto,
						descpp = @descpp,
						nome2 = @nome2,
						nib = @nib,
						moeda = @moeda,
						pais = @pais,
						tpstamp = @tpstamp,
						tpdesc = @tpdesc,
						usrinis = @usrinis,
						usrdata = @usrdata,
						usrhora = @usrhora,
						descregiva = @descregiva,
						pncont = @pncont,
						url=@CliEnd
					WHERE flstamp = @flstampTmp

					IF @@ERROR = 0 
						UPDATE MSCLI SET CLISYNCR = 'S' WHERE CLICOD = @ForNumTmpORI
				END
				
				EXECUTE SPMSS_FornecedoresUSR @ForNumTmp, @Forno, @estab
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curFornecedores INTO @ForNumTmp, @nome, @morada, @local, @codpost, @ncont, @eplafond, @esaldo, @telefone, @tlmvl, @fax, @c2tacto, @contacto, @c3tacto, @email, @obs, @desconto, @descpp, @nome2, @nib, @CondVendTmp, @ForTerminal, @descregiva, @pncont, @CliAcl
		END
	FIM:
		CLOSE curFornecedores
		DEALLOCATE curFornecedores	
END

GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_CheckProspect
-- Verificar se o prospect já existe
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_CheckProspect]
	@CliNum INT,
	@agstamp CHAR(25) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CliCount INT
	SELECT @agstamp=agstamp FROM ag(nolock) WHERE "no" = @CliNum

END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ProspectsUSR
-- Personalizações na integração de prospects
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ProspectsUSR] 
	@CLICOD VARCHAR(20),	-- Código do prospect no MSS
	@no INT				-- Código do prospect no PHC
AS
BEGIN
	SET NOCOUNT ON;


END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Prospects
-- Integração de prospects
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_Prospects]
	@EstabSeparator CHAR(1),
	@Moeda VARCHAR(11)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @CliNumTmp VARCHAR(20)
	DECLARE @CondVendTmp VARCHAR(30)
	DECLARE @agstampTmp CHAR(25)
	DECLARE @CliTerminal VARCHAR(5)

	DECLARE @agstamp CHAR(25)
	DECLARE @clino INT
	DECLARE @nome VARCHAR(55)
	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @ncont VARCHAR(18)
	DECLARE @telefone VARCHAR(60)
	DECLARE @tlmvl VARCHAR(45)
	DECLARE @fax VARCHAR(60)
	DECLARE @contacto VARCHAR(30)
	DECLARE @email VARCHAR(45)
	DECLARE @nome2 VARCHAR(55)
	DECLARE @nib VARCHAR(28)
	DECLARE @vendedor INT
	DECLARE @vendnm VARCHAR(20)
	DECLARE @pais INT
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @pncont VARCHAR(2)
	DECLARE @CliAcl VARCHAR(2000)
	DECLARE @CliEnd VARCHAR(256)
	
	DECLARE @ProNumTmpORI VARCHAR(20)

	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	SET @Pais = 1

    DECLARE curProspects CURSOR FOR 
	SELECT 
		ISNULL(CLICOD, ''), -- código
		ISNULL(CLINOM, ''), -- nome
		ISNULL(CLIMOR, ''), -- morada
		ISNULL(CLILOC, ''), -- local
		ISNULL(CLICPT, ''), -- cod postal
		ISNULL(CLINCT, ''), -- contribuinte
		ISNULL(CLITEL, ''), -- telefone
		ISNULL(CLITLM, ''), -- telemovel
		ISNULL(CLIFAX, ''), -- fax
		'', -- contacto com
		ISNULL(CLIEML, ''), -- email
		ISNULL(CLINM2, ''), -- nome 2
		ISNULL(CLINIB, ''), -- nib
		ISNULL(CLIVND, ''), -- vendedor
		ISNULL(CLICVD, ''), -- condição de venda
		ISNULL(CLITERM, 0),  -- terminal
		ISNULL(CLIPAI, ''),  -- país
		ISNULL(CLIACL, '')
	FROM MSCLI(nolock) WHERE CLISYNCR = 'N' AND (UPPER(CLITIP) = 'P')

	OPEN curProspects

		FETCH NEXT FROM curProspects INTO @CliNumTmp, @nome, @morada, @local, @codpost, @ncont, @telefone, @tlmvl, @fax, @contacto, @email, @nome2, @nib, @vendedor, @CondVendTmp, @CliTerminal, @pncont, @CliAcl
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				SET @ProNumTmpORI = @CliNumTmp		
				SET @agstampTmp = null

				IF (SUBSTRING(@CliNumTmp, 1, 2) = 'P.')
					SET @CliNumTmp = SUBSTRING(@CliNumTmp, 3, LEN(@CliNumTmp) - 2) 
				
				SET @clino = CAST(@CliNumTmp AS INT)

					
				EXECUTE SPMSS_GetVendNome @vendedor, @vendnm OUTPUT

				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @agstamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@CliTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@CliTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				EXECUTE SPMSS_CheckProspect @clino, @agstampTmp OUTPUT

				
				IF dbo.ExtractFromACL(@CliAcl, 12) <> ''
					SET @CliEnd = dbo.ExtractFromACL(@CliAcl, 12)
				ELSE
					SET @CliEnd = ''

				IF @agstampTmp is null
				BEGIN
					INSERT INTO ag(agstamp,no,nome,morada,local,codpost,ncont,telefone,tlmvl,fax,contacto,email,nome2,nib,vendedor,vendnm,pais,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,pncont,url) 
					VALUES (@agstamp,@clino,@nome,@morada,@local,@codpost,@ncont,@telefone,@tlmvl,@fax,@contacto,@email,@nome2,@nib,@vendedor,@vendnm,@pais,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,@pncont,@CliEnd)

					IF @@ERROR = 0 
						UPDATE MSCLI SET CLISYNCR = 'S' WHERE CLICOD = @ProNumTmpORI
				END
				ELSE
				BEGIN
					UPDATE ag SET
						nome = @nome,
						morada = @morada,
						local = @local,
						codpost = @codpost,
						ncont = @ncont,
						telefone = @telefone,
						tlmvl = @tlmvl,
						fax = @fax,
						contacto = @contacto,
						email = @email,
						nome2 = @nome2,
						nib = @nib,
						vendedor = @vendedor,
						vendnm = @vendnm,
						pais = @pais,
						usrinis = @usrinis,
						usrdata = @usrdata,
						usrhora = @usrhora,
						pncont = @pncont,
						url = @CliEnd
					WHERE agstamp = @agstampTmp

					IF @@ERROR = 0 
						UPDATE MSCLI SET CLISYNCR = 'S' WHERE CLICOD = @ProNumTmpORI
				END
				
				EXECUTE SPMSS_ProspectsUSR @CliNumTmp, @clino
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curProspects INTO @CliNumTmp, @nome, @morada, @local, @codpost, @ncont, @telefone, @tlmvl, @fax, @contacto, @email, @nome2, @nib, @vendedor, @CondVendTmp, @CliTerminal, @pncont, @CliAcl
		END
	FIM:
		CLOSE curProspects
		DEALLOCATE curProspects	
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocComprasLinUSR
-- Persoanlizações na integração de linhas de documentos de facturação
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocComprasLinUSR] 
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@fostamp CHAR(25),		-- Stamp do documento de compra
	@fnstamp CHAR(25),		-- Stamp da linha
	@ref VARCHAR(18),		-- Código do artigo
	@DCLLIN INT				-- Linha do documento no MSS
AS
BEGIN
	SET NOCOUNT ON;
END

GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocComprasLin
-- Integração de linhas de documentos de facturação
-- *******************************************************************************************************************

CREATE PROCEDURE [dbo].[SPMSS_DocDocComprasLin]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@fostamp CHAR(25),
	@rdata DATETIME,
	@DCCDCG NUMERIC(18,5),
	@DCCARO VARCHAR(30),
	@DCCARD VARCHAR(30),
	@DCCTSF VARCHAR(10),
	@DocNome VARCHAR(20),
	@DCCRQC VARCHAR(30),
	@estab INT,
	@no INT,
	@nome Varchar(55),
	@ccusto VARCHAR(20),
	@DocAnul CHAR(1),
	@Devolucao CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @DocTipo VARCHAR(10)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocLinDescV NUMERIC(18,5)
	DECLARE @DocLinDesc1 NUMERIC(6,2)
	DECLARE @DocLinDesc2 NUMERIC(6,2)
	DECLARE @DocLinDesc3 NUMERIC(6,2)
	DECLARE @DocLinDesc4 NUMERIC(6,2)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocIVI VARCHAR(1)
	DECLARE @DocDesc NUMERIC(18,5)
	DECLARE @DocUni2 VARCHAR(4)
	DECLARE @ArtPPond NUMERIC(19,6)
	DECLARE @ArtConv NUMERIC(19,6)
	DECLARE @ArtStock NUMERIC(11,3)
	DECLARE @ArtQttFor NUMERIC(11,3)
	DECLARE @ArtQttCli NUMERIC(11,3)
	DECLARE @ArtQttRec NUMERIC(11,3)
	DECLARE @ArtUsrQtt NUMERIC(11,3)
	DECLARE @ArtForref VARCHAR(20)

	DECLARE @ForTipo VARCHAR(20)
	DECLARE @ForTelef VARCHAR(60)
	DECLARE @ForNome VARCHAR(55)
	DECLARE @ForMorada VARCHAR(55)
	DECLARE @ForLocal VARCHAR(43)
	DECLARE @ForCPostal VARCHAR(45)
	DECLARE @ForNCont VARCHAR(18)
	DECLARE @ForPais INT
	DECLARE @ForZona VARCHAR(20)
	DECLARE @ForSegmento VARCHAR(25)

	DECLARE @fnstamp CHAR(25)
	DECLARE @ref VARCHAR(60)
	DECLARE @design VARCHAR(60)
	DECLARE @lordem INT
	DECLARE @ndoc INT
	DECLARE @armazem INT
	DECLARE @qtt NUMERIC(11,3)
	DECLARE @altura NUMERIC(11,3)
	DECLARE @largura NUMERIC(11,3)
	DECLARE @espessura NUMERIC(11,3)
	DECLARE @peso NUMERIC(11,3)
	DECLARE @usr1 VARCHAR(20)
	DECLARE @usr2 VARCHAR(20)
	DECLARE @usr3 VARCHAR(35)
	DECLARE @usr4 VARCHAR(20)
	DECLARE @usr5 VARCHAR(120)
	DECLARE @usr6 VARCHAR(30)
	DECLARE @ivaincl INT
	DECLARE @cpoc INT
	DECLARE @stns INT
	DECLARE @usalote INT 
	DECLARE @lote VARCHAR(30)
	DECLARE @fno INT
	DECLARE @epv NUMERIC(19,6)
	DECLARE @pv NUMERIC(18,5)
	DECLARE @etiliquido NUMERIC(19,6)
	DECLARE @tiliquido NUMERIC(18,5)
	DECLARE @eslvu NUMERIC(19,6)
	DECLARE @slvu NUMERIC(18,5)
	DECLARE @epcp NUMERIC(19,6)
	DECLARE @pcp NUMERIC(18,5) 
	DECLARE @esltt NUMERIC(19,6)
	DECLARE @sltt NUMERIC(18,5)
	DECLARE @ecusto NUMERIC(19,6)
	DECLARE @custo NUMERIC(18,5)
	DECLARE @desconto NUMERIC(6,2)
	DECLARE @desc2 NUMERIC(6,2)
	DECLARE @desc3 NUMERIC(6,2)
	DECLARE @desc4 NUMERIC(6,2)
	DECLARE @desc5 NUMERIC(6,2)
	DECLARE @iva NUMERIC(6,2)
	DECLARE @uni2qtt NUMERIC(11,3)
	DECLARE @unidade VARCHAR(4)
	DECLARE @unidad2 VARCHAR(4)
	DECLARE @tabiva INT
	DECLARE @fivendedor INT
	DECLARE @fivendnm VARCHAR(20)
	DECLARE @nmdoc VARCHAR(20)
	DECLARE @ecomissao INT 
	DECLARE @tipodoc INT
	DECLARE @tipodocFor INT
	DECLARE @tliquido NUMERIC(18,5)
	DECLARE @codigo VARCHAR(18)
	DECLARE @familia VARCHAR(18)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @datalote VARCHAR(8)
	DECLARE @validade VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	DECLARE @ExerDocOrig VARCHAR(30)
	DECLARE @TipoDocOrig VARCHAR(10)
	DECLARE @SerieDocOrig VARCHAR(10)
	DECLARE @NumDocOrig INT
	DECLARE @LinDocOrig INT
	
	DECLARE @orilinstamp VARCHAR(25)
	DECLARE @oriheadstamp VARCHAR(25)
	DECLARE @orindoc INT
	
	DECLARE @To_Close INT
	DECLARE @QtdPend NUMERIC(11,3)
	DECLARE @Sinal NUMERIC(6,2)

	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT

	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @moradaentrega VARCHAR(55)
	DECLARE @localentrega VARCHAR(43)
	DECLARE @codpostentrega VARCHAR(45)

	DECLARE @motiseimp VARCHAR(60)
	DECLARE @codmotiseimp VARCHAR(3)
	DECLARE @DCLACL VARCHAR(2000)

	DECLARE @refCorTam VARCHAR(60)
	DECLARE @Cor VARCHAR(25)
	DECLARE @Tam VARCHAR(25)
	DECLARE @Texteis INT
	DECLARE @DCLLIN INT
	DECLARE @bdemp	VARCHAR(2)

	DECLARE @NSERIE VARCHAR(60)
	DECLARE @CONT INT
	DECLARE @NOSERIE INT
	DECLARE @bomastamp CHAR(25)
	DECLARE @situacao CHAR(60)
	DECLARE @mastamp CHAR(25)
	DECLARE @fomastamp CHAR(25)

	SET @CONT = 0

	DECLARE curFN CURSOR FOR
	SELECT 
		ISNULL(DCLTPD, ''),
		ISNULL(DCLSER, ''),
		ISNULL(DCLNDC, 0),
		CASE WHEN DCLLIN < 1000 THEN ISNULL(DCLLIN*10000, 0)
		ELSE DCLLIN END,
		ISNULL(DCLART, ''),
		ISNULL(DCLQTD, 0.0),
		ISNULL(DCLPRU, 0.0),
		ISNULL(DCLTXI, 0.0),
		ISNULL(DCLTDC, 0.0),
		ISNULL(DCLTD2, 0.0),
		ISNULL(DCLTD3, 0.0),
		ISNULL(DCLTD4, 0.0),
		ISNULL(DCTLOT, ''),
		ISNULL(DCLDSA, ''),
		ISNULL(DCLVD1, 0.0),
		ISNULL(DCLUND, ''),
		ISNULL(DCLALT, 0.0),
		ISNULL(DCLLGR, 0.0),
		ISNULL(DCLCMP, 0.0),
		ISNULL(DCLPES, 0.0),
		ISNULL(DCLVND, ''),
		ISNULL(DCLTERM, 0),
		ISNULL(DCLIVI, 'N'),
		ISNULL(DCLVLD, 0),
		ISNULL(DCLIVA, 0),
		ISNULL(DCLQT2, 0),
		ISNULL(DCLOEX, ''),
		ISNULL(DCLOTP, ''),
		ISNULL(DCLOSR, ''),
		ISNULL(DCLOND, 0),
		ISNULL(DCLOLN, 0),
		ISNULL(DCTDTL, ''),
		ISNULL(DCTDVL, ''),
		ISNULL(DCLPLI, ''),
		ISNULL(DCLACL, ''),
		ISNULL(DCLUN2, ''),
		ISNULL(DCLLIN, 0),
		ISNULL(DCTNSR,'')
	FROM MSDCL(nolock)
	WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC

	OPEN curFN
		
		FETCH NEXT FROM curFN INTO @DocTipo, @DocSerie, @fno, @lordem, @ref, @qtt, @epv, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @fivendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @datalote, @validade, @motiseimp, @DCLACL, @DocUni2, @DCLLIN, @NSERIE
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
			
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @fnstamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @armazem = dbo.StringToNum(@DCCARO)
				IF @armazem <= 0
					SET @armazem = dbo.StringToNum(@DCCARD)
				IF (@armazem ='')
					SET @armazem = @fivendedor
				
				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				-- Verifica se é um artigo com cor e tamanho
				SET @refCorTam = dbo.ExtractFromACL(@DCLACL, 15)
				IF (@refCorTam = 'F')
				BEGIN
					SET @refCorTam = @ref
					EXECUTE SPMSS_GetCorTamanho @DCLACL, @ref OUTPUT, @Cor OUTPUT, @Tam OUTPUT
					SET @Texteis = 1
				END
				ELSE
				BEGIN
					SET @COR = ''
					SET @Tam = ''
					SET @Texteis = 0
				END
				
				EXECUTE SPMSS_GetDadosDoc 3, @DocTipo, @DocSerie, @ndoc OUTPUT, @nmdoc OUTPUT, @tipodocFor OUTPUT, @tipodoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT

				EXECUTE SPMSS_GetArtInfo @ref, @usr1 OUTPUT, @usr2 OUTPUT, @usr3 OUTPUT, @usr4 OUTPUT, @usr5 OUTPUT, @usr6 OUTPUT, @familia OUTPUT, @ecusto OUTPUT, @codigo OUTPUT, @ArtForref OUTPUT, @ivaincl OUTPUT, @ecomissao OUTPUT, @cpoc OUTPUT, @stns OUTPUT, @usalote OUTPUT, @epcp OUTPUT, @unidad2 OUTPUT, @ArtConv OUTPUT,	@ArtStock OUTPUT, @ArtQttFor OUTPUT, @ArtQttCli OUTPUT,	@ArtQttRec OUTPUT, @ArtUsrQtt OUTPUT
				
				EXECUTE SPMSS_GetArtPCusto @ref, @DocPCusto, @ecusto OUTPUT
				
				EXECUTE SPMSS_GetVendNome @fivendedor, @fivendnm OUTPUT
				
				IF @usalote = 0
					SET @lote = ''
				
				IF @tipodoc = 3	 --******************* Quando são notas de crédito os totais têm de ser integrados com sinal negativo
					SET @Sinal = -1
				ELSE
					SET @Sinal = 1
				
				SET @etiliquido = (@qtt * @epv - @DocDesc) * @Sinal
				SET @tliquido = ((@qtt * @epv - @DocDesc) * (@iva/100+1)) * @Sinal
				
				IF @DocIVI = 'S'
				begin
					SET @eslvu = @epv - round((@DocDesc / @qtt), 2) / (@iva/100+1)
					SET @esltt = (@qtt * @epv - @DocDesc) / (@iva/100+1)
					SET @ivaincl = 1
				end
				ELSE
				BEGIN
					SET @eslvu = @epv - round((@DocDesc / @qtt), 2)
					SET @esltt = @qtt * @epv - @DocDesc
					SET @ivaincl = 0
				END
				
				IF @unidad2 <> ''
				BEGIN
					IF @DocUni2 <> @unidad2
						SET @uni2qtt = @qtt * @ArtConv
				END
				ELSE
					SET @uni2qtt = 0
				
				EXECUTE SPMSS_CalcDescontos @DocLinDescV, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @epv, @qtt, @DCCDCG, @desconto OUTPUT, @desc2 OUTPUT, @desc3 OUTPUT, @desc4 OUTPUT, @desc5 OUTPUT
				
				SET @orilinstamp = ''
				SET @oriheadstamp = ''
				
				IF ((@TipoDocOrig <> '') OR (@Devolucao = 'S'))
				BEGIN
					EXECUTE SPMSS_GetDocOrigStamp @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @DCCTSF, @Devolucao, 3, @orilinstamp OUTPUT, @oriheadstamp OUTPUT, @QtdPend OUTPUT, @orindoc OUTPUT
				END
				-- verificar se o lote existe na tabela se e caso não exista fazer o insert antes de inserir a linha
				IF @lote <> ''
				BEGIN
					EXECUTE SPMSS_CheckLote @ref, @design, @lote, @datalote, @validade, @DocTerminal, @rdata
				END
				
				-- ler dados do local de entrega
				SELECT @morada = DCCMOR, @local = DCCLOC, @codpost = DCCCPT, @moradaentrega = DCCEMO, @localentrega = DCCELO, @codpostentrega = DCCECP FROM MSDCC(nolock)	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC
				IF (@moradaentrega = '') AND (@localentrega = '') AND (@codpostentrega = '')
				BEGIN
					SET @moradaentrega = @morada
					SET @localentrega = @local
					SET @codpostentrega = @codpost
				END

				SET @codmotiseimp = dbo.ExtractFromACL(@DCLACL, 12)


				IF @orilinstamp IS NULL
						SET @orilinstamp = ''	
						
				/*IF @NSERIE<>''
				BEGIN
					SET @NOSERIE=1
				END
				ELSE
				BEGIN
					SET @NOSERIE=0
				END*/
								

					INSERT INTO fn(fnstamp, ref, design, docnome, adoc, qtt, iva, ivaincl, tabiva, armazem, lordem, data, etiliquido, epv, eslvu, esltt, desconto, desc2, desc3, desc4, usr1, usr2, usr3, usr4, usr5, usr6, familia, ncmassa, ncunsup, fostamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora/*,noserie,series*/) 
					VALUES(@fnstamp, @ref, @design, @docnome, @DCCRQC, @qtt, @iva, @ivaincl, @tabiva, @armazem, @lordem, @rdata, @etiliquido, @epv, @eslvu, @esltt,  @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4,  @usr1, @usr2, @usr3, @usr4, @usr5, @usr6, @familia, @qtt, @qtt, @fostamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora/*,@noserie,@NSERIE*/)

					EXEC SPMSS_DocDocComprasLinUSR @DCCEXR,@DCCTPD,@DCCSER,@DCCNDC,@fostamp,@fnstamp,@ref,@DCLLIN

				/*Processamento dos nºs de série*/
				/*IF @NSERIE<>''
				BEGIN
				 SET @CONT= @CONT+1
				    IF @CONT > 1
					BEGIN
						update fo set SERIES=CAST(SERIES AS VARCHAR(60)) + CAST(',' as VARCHAR(1)) + @NSERIE where fostamp=@fostamp
				    END
					ELSE
					BEGIN
						update fo set SERIES=@NSERIE where fostamp=@fostamp
					END

					WAITFOR DELAY '00:00:00.050' 
						SET @DateTimeTmp = GETDATE()
				
						SET @DateStr = dbo.DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

					SET @fomastamp = 'MSS_' + @DateStr + @TimeStr

					IF @DocAnul = 'N'
					BEGIN
						INSERT INTO FOMA (fomastamp,fostamp,fnstamp,serie,ref,design,marca,maquina,tipo,ccusto,situacao,nome,no,estab,nmdoc,adoc,data,armazem,doccode,recnum,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,marcada)
						Values(@fomastamp,@fostamp,@fnstamp,@NSERIE,@ref,@design,@usr1,@usr2,@usr4,@ccusto,'Disponivel',@nome,@no,@estab,@docnome,@DCCRQC,@usrdata,@armazem,@DocSerie,@CONT,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0)		
					END

					--INSERT INTO FOMA (fomastamp,fostamp,fnstamp,serie,ref,design,marca,maquina,tipo,ccusto,situacao,nome,no,estab,nmdoc,adoc,data,armazem,doccode,recnum,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,marcada)
					--Values(@fomastamp,@fostamp,@fnstamp,@NSERIE,@ref,@design,@usr1,@usr2,@usr4,@ccusto,'Disponivel',@nome,@no,@estab,@docnome,@DCCRQC,@usrdata,@armazem,@DocSerie,@CONT,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0)		

					/*INSERT INTO MA (mastamp,tipo,no,situacao,serie,marca,maquina,ref,design,casa,retfor,armdatain,noarm,estab,ccusto,periodo,vendedor,flnome,flno,flestab,flnomea,flnoa,flestaba,flnmdoc,fladoc,fldata,snno,ftnmdoc,ftfno,ftndoc,psobs,foorigem,fomastamp,fostamp,indisponivel,focl,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora)
					VALUES (@mastamp,@usr4,0,'Disponivel',@NSERIE,@usr1,@usr2,@ref, @design,1,0,@usrdata,@armazem,@estab,@ccusto,0,0,@nome,@no,@estab,'',0,0,@docnome,@DCCRQC,@usrdata,0,'',0,0,'','FO',@fomastamp,@fostamp,0,0,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora)*/

				END*/
				
				IF @@ERROR <> 0
				BEGIN
					SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
					SET @ErrorMessage = 'Insert fn - ' + @ErrorMessage
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				END
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curFN INTO @DocTipo, @DocSerie, @fno, @lordem, @ref, @qtt, @epv, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @fivendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @datalote, @validade, @motiseimp, @DCLACL, @DocUni2, @DCLLIN, @NSERIE
		END
	FIM:
		CLOSE curFN
		DEALLOCATE curFN
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocComprasUSR
-- Persoanlizações na integração de documentos de compras
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocComprasUSR]
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@fostamp CHAR(25),		-- Stamp do documento de compras
	@no INT					-- Nº do fornecedor
AS
BEGIN
	SET NOCOUNT ON;

END

GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocComprasIVAs
-- Ligação dos campos com as bases e valores de IVA do MSS aos do cabeçalho de documentos de facturação do PHC baseado na tabela de taxas de IVA
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocComprasIVAs]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@ftstamp CHAR(25),
	@Sinal NUMERIC(6,2),
	@eivain1 NUMERIC(19,6) OUTPUT,
	@eivav1 NUMERIC(19,6) OUTPUT,
	@eivain2 NUMERIC(19,6) OUTPUT,
	@eivav2 NUMERIC(19,6) OUTPUT,
	@eivain3 NUMERIC(19,6) OUTPUT,
	@eivav3 NUMERIC(19,6) OUTPUT,
	@eivain4 NUMERIC(19,6) OUTPUT,
	@eivav4 NUMERIC(19,6) OUTPUT,
	@eivain5 NUMERIC(19,6) OUTPUT,
	@eivav5 NUMERIC(19,6) OUTPUT,
	@eivain6 NUMERIC(19,6) OUTPUT,
	@eivav6 NUMERIC(19,6) OUTPUT,
	@eivain7 NUMERIC(19,6) OUTPUT,
	@eivav7 NUMERIC(19,6) OUTPUT,
	@eivain8 NUMERIC(19,6) OUTPUT,
	@eivav8 NUMERIC(19,6) OUTPUT,
	@eivain9 NUMERIC(19,6) OUTPUT,
	@eivav9 NUMERIC(19,6) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @fttstamp CHAR(25)
	DECLARE @CodTabIva CHAR(1)
	DECLARE @DocTax1 NUMERIC(6,2)
	DECLARE @DocTaxBIns1 NUMERIC(19,6)
	DECLARE @DocTaxVal1 NUMERIC(19,6)
	DECLARE @DocTax2 NUMERIC(6,2)
	DECLARE @DocTaxBIns2 NUMERIC(19,6)
	DECLARE @DocTaxVal2 NUMERIC(19,6)
	DECLARE @DocTax3 NUMERIC(6,2)
	DECLARE @DocTaxBIns3 NUMERIC(19,6)
	DECLARE @DocTaxVal3 NUMERIC(19,6)
	DECLARE @DocTax4 NUMERIC(6,2)
	DECLARE @DocTaxBIns4 NUMERIC(19,6)
	DECLARE @DocTaxVal4 NUMERIC(19,6)
	
	SELECT 
		@DocTax1 = ISNULL(DCCTX1, 0),
		@DocTaxBIns1 = ISNULL(DCCBI1, 0),
		@DocTaxVal1 = ISNULL(DCCVI1, 0),
		@DocTax2 = ISNULL(DCCTX2, 0),
		@DocTaxBIns2 = ISNULL(DCCBI2, 0),
		@DocTaxVal2 = ISNULL(DCCVI2, 0),
		@DocTax3 = ISNULL(DCCTX3, 0),
		@DocTaxBIns3 = ISNULL(DCCBI3, 0),
		@DocTaxVal3 = ISNULL(DCCVI3, 0),
		@DocTax4 = ISNULL(DCCTX4, 0),
		@DocTaxBIns4 = ISNULL(DCCBI4, 0),
		@DocTaxVal4 = ISNULL(DCCVI4, 0)
	FROM MSDCC(nolock)
	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC

	SET @eivain1 = 0
	SET @eivav1 = 0
	SET @eivain2 = 0
	SET @eivav2 = 0
	SET @eivain3 = 0
	SET @eivav3 = 0
	SET @eivain4 = 0
	SET @eivav4 = 0
	SET @eivain5 = 0
	SET @eivav5 = 0
	SET @eivain6 = 0
	SET @eivav6 = 0
	SET @eivain7 = 0
	SET @eivav7 = 0
	SET @eivain8 = 0
	SET @eivav8 = 0
	SET @eivain9 = 0
	SET @eivav9 = 0


	IF @DocTaxBIns1 > 0  -- quando a base de incidência 1 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax1, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax1, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivain1 = @DocTaxBIns1		
			SET @eivav1 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivain2 = @DocTaxBIns1
			SET @eivav2 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivain3 = @DocTaxBIns1		
			SET @eivav3 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivain4 = @DocTaxBIns1		
			SET @eivav4 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivain5 = @DocTaxBIns1		
			SET @eivav5 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivain6 = @DocTaxBIns1		
			SET @eivav6 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivain7 = @DocTaxBIns1		
			SET @eivav7 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivain8 = @DocTaxBIns1		
			SET @eivav8 = @DocTaxVal1
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivain9 = @DocTaxBIns1		
			SET @eivav9 = @DocTaxVal1
		END

	END

	IF @DocTaxBIns2 > 0  -- quando a base de incidência 2 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax2, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax2, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivain1 = @DocTaxBIns2	
			SET @eivav1 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivain2 = @DocTaxBIns2
			SET @eivav2 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivain3 = @DocTaxBIns2		
			SET @eivav3 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivain4 = @DocTaxBIns2		
			SET @eivav4 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivain5 = @DocTaxBIns2		
			SET @eivav5 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivain6 = @DocTaxBIns2		
			SET @eivav6 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivain7 = @DocTaxBIns2		
			SET @eivav7 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivain8 = @DocTaxBIns2		
			SET @eivav8 = @DocTaxVal2
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivain9 = @DocTaxBIns2		
			SET @eivav9 = @DocTaxVal2
		END

	END

	IF @DocTaxBIns3 > 0  -- quando a base de incidência 3 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax3, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax3, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivain1 = @DocTaxBIns3		
			SET @eivav1 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivain2 = @DocTaxBIns3
			SET @eivav2 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivain3 = @DocTaxBIns3
			SET @eivav3 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivain4 = @DocTaxBIns3		
			SET @eivav4 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivain5 = @DocTaxBIns3		
			SET @eivav5 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivain6 = @DocTaxBIns3		
			SET @eivav6 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivain7 = @DocTaxBIns3		
			SET @eivav7 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivain8 = @DocTaxBIns3
			SET @eivav8 = @DocTaxVal3
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivain9 = @DocTaxBIns3		
			SET @eivav9 = @DocTaxVal3
		END

	END

	IF @DocTaxBIns4 > 0  -- quando a base de incidência 4 do MSS está preenchida
	BEGIN
		EXECUTE SPMSS_GetTabIva @DocTax4, @CodTabIVA OUTPUT
		IF @CodTabIVA = 'X'
			EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DocTax4, @CodTabIVA OUTPUT

		IF @CodTabIVA = 1
		BEGIN
			SET @eivain1 = @DocTaxBIns4	
			SET @eivav1 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 2	
		BEGIN
			SET @eivain2 = @DocTaxBIns4
			SET @eivav2 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 3
		BEGIN
			SET @eivain3 = @DocTaxBIns4		
			SET @eivav3 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 4	
		BEGIN
			SET @eivain4 = @DocTaxBIns4
			SET @eivav4 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 5	
		BEGIN
			SET @eivain5 = @DocTaxBIns4
			SET @eivav5 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 6	
		BEGIN
			SET @eivain6 = @DocTaxBIns4		
			SET @eivav6 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 7	
		BEGIN
			SET @eivain7 = @DocTaxBIns4		
			SET @eivav7 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 8	
		BEGIN
			SET @eivain8 = @DocTaxBIns4		
			SET @eivav8 = @DocTaxVal4
		END ELSE IF @CodTabIVA = 9	
		BEGIN
			SET @eivain9 = @DocTaxBIns4		
			SET @eivav9 = @DocTaxVal4
		END

	END

	SET @eivain1 = @eivain1 * @sinal
	SET @eivav1 = @eivav1 * @sinal
	SET @eivain2 = @eivain2 * @sinal
	SET @eivav2 = @eivav2 * @sinal
	SET @eivain3 = @eivain3 * @sinal
	SET @eivav3 = @eivav3 * @sinal
	SET @eivain4 = @eivain4 * @sinal
	SET @eivav4 = @eivav4 * @sinal
	SET @eivain5 = @eivain5 * @sinal
	SET @eivav5 = @eivav5 * @sinal
	SET @eivain6 = @eivain6 * @sinal
	SET @eivav6 = @eivav6 * @sinal
	SET @eivain7 = @eivain7 * @sinal
	SET @eivav7 = @eivav7 * @sinal
	SET @eivain8 = @eivain8 * @sinal
	SET @eivav8 = @eivav8 * @sinal
	SET @eivain9 = @eivain9 * @sinal
	SET @eivav9 = @eivav9 * @sinal
	
END

GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocCompras
-- Integração de cabeçalhos de documentos de facturação
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_DocDocCompras]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@EstabSeparator CHAR(1),
	@Imp1 CHAR(10),
	@Imp2 CHAR(10),
	@Imp3 CHAR(10),
	@memissao VARCHAR(15) = 'EURO'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @ForNumTmp VARCHAR(20)
	DECLARE @ForLocEnt VARCHAR(20)
	DECLARE @CondVendTmp VARCHAR(30)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocDataVenc VARCHAR(8)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocArmazem INT
	DECLARE @CodTabIva CHAR(1)
	
	DECLARE @ForNome VARCHAR(55)
	DECLARE @ForMorada VARCHAR(55)
	DECLARE @ForLocal VARCHAR(43)
	DECLARE @ForCPostal VARCHAR(45)
	DECLARE @ForNCont VARCHAR(18)
	DECLARE @ForPais INT
	DECLARE @ForLocTesoura VARCHAR(50)
	DECLARE @ForContado INT
	DECLARE @DocDesc NUMERIC(19,6)
	DECLARE @DocAnul CHAR(1)
	DECLARE @DCCDCG NUMERIC(18,5)
	DECLARE @StatusErrorLines INT
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	DECLARE @DocAssinatura VARCHAR(1000)
	DECLARE @DocVsAssinatura VARCHAR(50)
	DECLARE @DocTipoSAFT VARCHAR(10)
	DECLARE @horasl VARCHAR(8)
	DECLARE @DocACL VARCHAR(2000)

	DECLARE @fostamp CHAR(25)
	DECLARE @anulado INT
	DECLARE @pais INT
	DECLARE @nmdoc VARCHAR(20)
	DECLARE @fno INT
	DECLARE @no INT
	DECLARE @ndoc INT
	DECLARE @fdata DATETIME
	DECLARE @ftano INT
	DECLARE @pdata DATETIME
	DECLARE @nome VARCHAR(55)
	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @moeda VARCHAR(11)
	DECLARE @ncont VARCHAR(18)
	DECLARE @telefone VARCHAR(60)
	DECLARE @estab INT
	DECLARE @segmento VARCHAR(25) 
	DECLARE @tipo VARCHAR(20)
	DECLARE @zona VARCHAR(13)
	DECLARE @tipodoc INT
	DECLARE @tipodocFor INT
	DECLARE @tpstamp CHAR(25)
	DECLARE @tpdesc VARCHAR(55)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @eivain1 NUMERIC(19,6)
	DECLARE @eivav1 NUMERIC(19,6)
	DECLARE @eivain2 NUMERIC(19,6)
	DECLARE @eivav2 NUMERIC(19,6)
	DECLARE @eivain3 NUMERIC(19,6)
	DECLARE @eivav3 NUMERIC(19,6)
	DECLARE @eivain4 NUMERIC(19,6)
	DECLARE @eivav4 NUMERIC(19,6)
	DECLARE @eivain5 NUMERIC(19,6)
	DECLARE @eivav5 NUMERIC(19,6)
	DECLARE @eivain6 NUMERIC(19,6)
	DECLARE @eivav6 NUMERIC(19,6)
	DECLARE @eivain7 NUMERIC(19,6)
	DECLARE @eivav7 NUMERIC(19,6)
	DECLARE @eivain8 NUMERIC(19,6)
	DECLARE @eivav8 NUMERIC(19,6)
	DECLARE @eivain9 NUMERIC(19,6)
	DECLARE @eivav9 NUMERIC(19,6)
	DECLARE @ivatx1 NUMERIC(5,2)
	DECLARE @ivatx2 NUMERIC(5,2)
	DECLARE @ivatx3 NUMERIC(5,2)
	DECLARE @ivatx4 NUMERIC(5,2)
	DECLARE @ivatx5 NUMERIC(5,2)
	DECLARE @ivatx6 NUMERIC(5,2)
	DECLARE @ivatx7 NUMERIC(5,2)
	DECLARE @ivatx8 NUMERIC(5,2)
	DECLARE @ivatx9 NUMERIC(5,2)
	DECLARE @ettiliq NUMERIC(19,6)
	DECLARE @edescc NUMERIC(19,6)
	DECLARE @ettiva NUMERIC(19,6)
	DECLARE @etotal NUMERIC(19,6)
	DECLARE @totqtt NUMERIC(15,3)
	DECLARE @qtt1 NUMERIC(16,3)
	DECLARE @etot1 NUMERIC(19,6)
	DECLARE @ArmOrigem VARCHAR(30)
	DECLARE @ArmDestino VARCHAR(30)
	DECLARE @efinv NUMERIC(19,6)
	DECLARE @fin NUMERIC(19,6)
	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)
	DECLARE @Sinal NUMERIC(6,2)

	DECLARE @moradaentrega VARCHAR(55)
	DECLARE @localentrega VARCHAR(43)
	DECLARE @codpostentrega VARCHAR(45)

	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT

	DECLARE @atcodeid VARCHAR(200)
	DECLARE @cladrsdesc VARCHAR(50)
	DECLARE @cladrsstamp CHAR(25)
	DECLARE @cdata DATETIME
	DECLARE @chora VARCHAR(8)
	DECLARE @reexgiva INT
	DECLARE @saida VARCHAR(5) 
	DECLARE @motiseimp VARCHAR(60)
	DECLARE @codmotiseimp VARCHAR(3)
	DECLARE @DESCREGIVA VARCHAR(60)
	DECLARE @CODPAIS VARCHAR(60)
	DECLARE @DESCRPAIS VARCHAR(60)

	DECLARE @FTTDateTimeTmp DATETIME
	DECLARE @FTTDateStr CHAR(8)
	DECLARE @FTTTimeStr CHAR(11)
	DECLARE @fttstamp CHAR(25)

	DECLARE @DCCRQC VARCHAR(30) 
	DECLARE @bdemp VARCHAR(2)
	
	/*Impostos*/
	DECLARE @dcci1v NUMERIC(19,6)
	DECLARE @dcci2v NUMERIC(19,6)
	DECLARE @dcci3v NUMERIC(19,6)
	
	DECLARE curCabFT CURSOR FOR
	SELECT 
		ISNULL(DCCANU, 'N'),
		ISNULL(DCCNDC, 0),
		ISNULL(DCCDTA, ''),
		ISNULL(DCCCLI, ''),
		ISNULL(DCCNOM, ''),
		ISNULL(DCCMOR, ''),
		ISNULL(DCCLOC, ''),
		ISNULL(DCCCPT, ''),
		ISNULL(DCCNCT, ''),
		ISNULL(DCCTERM, 0),
		ISNULL(DCCDTV, ''),
		ISNULL(DCCCVD, ''),
		ISNULL(DCCVLL, 0),
		ISNULL(DCCVDL, 0),
		ISNULL(DCCVIV, 0),
		ISNULL(DCCDCG, 0), 
		ISNULL(DCCARO, ''),
		ISNULL(DCCARD, ''),
		ISNULL(DCCDPP, 0),
		ISNULL(DCCVDG, 0),
		ISNULL(DCCSIG, ''),
		ISNULL(DCCSIV, 0),
		ISNULL(DCCTSF, ''),
		ISNULL(DCCHOR, ''),
		ISNULL(DCCEMO, ''),
		ISNULL(DCCELO, ''),
		ISNULL(DCCECP, ''),
		ISNULL(DCCACL, ''),
		ISNULL(DCCREG, ''),
		ISNULL(DCCPAI, ''),
		ISNULL(DCCRQC, ''),
		ISNULL(DCCI1V,0),
		ISNULL(DCCI2V,0),
		ISNULL(DCCI3V,0)
	FROM MSDCC(nolock)
	WHERE DCCSYNCR = 'N' AND DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC ORDER BY DCCDTA, DCCHOR

	OPEN curCabFT
		FETCH NEXT FROM curCabFT INTO @DocAnul, @fno, @fdata, @ForNumTmp, @nome, @morada, @local, @codpost, @ncont, @DocTerminal, @DocDataVenc, @CondVendTmp, @ettiliq, @edescc, @ettiva, @DCCDCG, @ArmOrigem, @ArmDestino, @fin, @efinv, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @moradaentrega, @localentrega, @codpostentrega, @DocACL, @DESCREGIVA, @CODPAIS, @DCCRQC, @dcci1v, @dcci2v, @dcci3v
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY			
				BEGIN TRANSACTION
				
				IF (@dcci1v > 0 OR @dcci2v > 0 OR @dcci3v > 0)
					RAISERROR('Não é possível a integração de impostos nas compras!',16,1)
				
				IF (SUBSTRING(@ForNumTmp, 1, 2) = 'F.')
					SET @ForNumTmp = SUBSTRING(@ForNumTmp, 3, LEN(@ForNumTmp) - 2) 
				
				IF CHARINDEX(@EstabSeparator, @ForNumTmp) > 0
				BEGIN
					SET @no = CAST(LEFT(@ForNumTmp, CHARINDEX(@EstabSeparator, @ForNumTmp) - 1) AS INT)
					SET @estab = CAST(RIGHT(@ForNumTmp, LEN(@ForNumTmp) - CHARINDEX(@EstabSeparator, @ForNumTmp)) AS INT)
				END
				ELSE
				BEGIN
					SET @no = CAST(@ForNumTmp AS INT)
					SET @estab = 0
				END

				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @fostamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				SET @horasl = LEFT(@horasl, 2) + ':' + SUBSTRING(@horasl, 3, 2) + ':' + SUBSTRING(@horasl, 5, 2)
				SET @saida = LEFT(@horasl, 5)
				SET @ftano = YEAR(@fdata)

				EXECUTE SPMSS_GetDadosDoc 3, @DCCTPD, @DCCSER, @ndoc OUTPUT, @nmdoc OUTPUT, @tipodocFor OUTPUT, @tipodoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT

				IF @tipodoc = 3	 --******************* Quando são notas de crédito os totais têm de ser integrados com sinal negativo
					SET @Sinal = -1
				ELSE
					SET @Sinal = 1
				
				SET @ettiliq = @ettiliq * @Sinal
				SET @ettiva = @ettiva * @Sinal
				
				EXECUTE SPMSS_GetForInfo @no, @estab, @tipo OUTPUT, @zona OUTPUT, @telefone OUTPUT, @ForPais OUTPUT, @moeda OUTPUT, @fref OUTPUT, @ccusto OUTPUT

				IF @ForContado is null
					set @ForContado = 0
				
				EXECUTE SPMSS_GetCondVend @CondVendTmp, @tpstamp OUTPUT, @tpdesc OUTPUT
				if @tpstamp is null
                    set @tpstamp = ''
                
                if @tpdesc is null
                    set @tpdesc = ''


				SET @pdata = dbo.StringToDate(@DocDataVenc)
				
				EXECUTE SPMSS_GetTaxaIVA 1, @ivatx1 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 2, @ivatx2 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 3, @ivatx3 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 4, @ivatx4 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 5, @ivatx5 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 6, @ivatx6 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 7, @ivatx7 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 8, @ivatx8 OUTPUT
				EXECUTE SPMSS_GetTaxaIVA 9, @ivatx9 OUTPUT

				SET @etotal = (@ettiliq + @ettiva)
				SET @etot1 = @ettiliq
				IF @telefone IS NULL SET @telefone = ' '

				SELECT @totqtt=SUM(DCLQTD) FROM MSDCL(nolock) WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @fno
				SET @qtt1 = @totqtt

				-- Número do programa certificado
				IF @DocAssinatura <> ''
				BEGIN
					IF dbo.ExtractFromACL(@DocACL, 2) <> ''
						SET @DocVsAssinatura  = dbo.ExtractFromACL(@DocACL, 2)  + @DocVsAssinatura
					ELSE
						SET @DocVsAssinatura = '0240.' + @DocVsAssinatura
				END
				ELSE
				BEGIN
					SET @DocVsAssinatura = ''
				END

				IF (@moradaentrega = '') AND (@localentrega = '') AND (@codpostentrega = '')
				BEGIN
					SET @moradaentrega = @morada
					SET @localentrega = @local
					SET @codpostentrega = @codpost
				END
				-- testar se documento tem cód AT
				IF dbo.ExtractFromACL(@DocACL, 13) <> ''
				BEGIN
					SET @atcodeid = dbo.ExtractFromACL(@DocACL, 13)
					SET @cdata = dbo.StringToDate(dbo.ExtractFromACL(@DocACL, 21))
					SET @chora = LEFT(dbo.ExtractFromACL(@DocACL, 22), 4)
				END
				ELSE
				BEGIN
					SET @atcodeid = ''
					SET @cdata = 0
					SET @chora = ''
				END
				
				-- testar se é factura em regime de iva de caixa
				IF dbo.ExtractFromACL(@DocACL, 28) = 'S'
					SET @reexgiva = 1
				ELSE
					SET @reexgiva = 0
				-- verificar se existem linhas com IVA 0 para preencher na ft2 o motivo de isenção e respectivo código
				SELECT TOP 1 @motiseimp = DCLPLI, @codmotiseimp = dbo.ExtractFromACL(DCLACL, 12) FROM MSDCL WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @fno AND DCLPLI <> ''
				IF @motiseimp IS NULL
				BEGIN
					SET @motiseimp = ''
					SET @codmotiseimp = ''
				END

				SELECT @DESCRPAIS=nome FROM paises WHERE nomeabrvsaft=@CODPAIS
				IF @DESCRPAIS IS NULL
				BEGIN
					SET @DESCRPAIS = ''
				END

				EXECUTE SPMSS_DocDocComprasIVAs @DCCEXR,@DCCTPD,@DCCSER,@fno,@fostamp,@sinal, @eivain1 OUTPUT, @eivav1 OUTPUT, @eivain2 OUTPUT, @eivav2 OUTPUT, @eivain3 OUTPUT, @eivav3 OUTPUT, @eivain4 OUTPUT, @eivav4 OUTPUT, @eivain5 OUTPUT, @eivav5 OUTPUT, @eivain6 OUTPUT, @eivav6 OUTPUT, @eivain7 OUTPUT, @eivav7 OUTPUT, @eivain8 OUTPUT, @eivav8 OUTPUT, @eivain9 OUTPUT, @eivav9 OUTPUT				

				INSERT INTO fo2 (fo2stamp, ousrdata, usrdata, ivatx1, ivatx2, ivatx3, ivatx4, ivatx5, ivatx6, ivatx7, ivatx8, ivatx9, formapag)
				VALUES(@fostamp, @ousrdata, @usrdata, @ivatx1, @ivatx2, @ivatx3, @ivatx4, @ivatx5, @ivatx6, @ivatx7, @ivatx8, @ivatx9, 1)

				--IF @DocAnul = 'S'
				--	INSERT INTO ft (ftstamp, anulado, pais, nmdoc, fno, no, ndoc, vendedor, vendnm, fdata, ftano, pdata, nome, morada, local, codpost, ncont, telefone, moeda, qtt1, totqtt, estab, etot1, segmento, tipo, zona, tipodoc, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, eivain1, eivav1, eivain2, eivav2, eivain3, eivav3, eivain4, eivav4, eivain5, eivav5, eivain6, eivav6, eivain7, eivav7, eivain8, eivav8, eivain9, eivav9, ivatx1, ivatx2, ivatx3, ivatx4, ivatx5, ivatx6, ivatx7, ivatx8, ivatx9, memissao, cdata, chora, saida) 
				--	VALUES (@ftstamp, 1, 1, @nmdoc, @fno, @no, @ndoc, @vendedor, @vendnm, @fdata, @ftano, @pdata, @nome, @morada, @local, @codpost, @ncont, @telefone, @moeda, @qtt1, @totqtt, @estab, @etot1, @segmento, @tipo, @zona, @tipodoc, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @eivain1, @eivav1, @eivain2, @eivav2, @eivain3, @eivav3, @eivain4, @eivav4, @eivain5, @eivav5, @eivain6, @eivav6, @eivain7, @eivav7, @eivain8, @eivav8, @eivain9, @eivav9, @ivatx1, @ivatx2, @ivatx3, @ivatx4, @ivatx5, @ivatx6, @ivatx7, @ivatx8, @ivatx9, @memissao, @cdata, @chora, @saida) 
				--ELSE
				--	INSERT INTO ft (ftstamp, anulado, pais, nmdoc, fno, no, ndoc, vendedor, vendnm, fdata, ftano, pdata, nome, morada, local, codpost, ncont, telefone, moeda, qtt1, totqtt, estab, etot1, segmento, tipo, zona, tipodoc, ettiliq, edescc, ettiva, etotal, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, efinv, introfin, fin, eivain1, eivav1, eivain2, eivav2, eivain3, eivav3, eivain4, eivav4, eivain5, eivav5, eivain6, eivav6, eivain7, eivav7, eivain8, eivav8, eivain9, eivav9, ivatx1, ivatx2, ivatx3, ivatx4, ivatx5, ivatx6, ivatx7, ivatx8, ivatx9, memissao, cdata, chora, saida, fref, ccusto) 
				--	VALUES (@ftstamp, 0, 1, @nmdoc, @fno, @no, @ndoc, @vendedor, @vendnm, @fdata, @ftano, @pdata, @nome, @morada, @local, @codpost, @ncont, @telefone, @moeda, @qtt1, @totqtt, @estab, @etot1, @segmento, @tipo, @zona, @tipodoc, @ettiliq, @edescc, @ettiva, @etotal, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @efinv, 0, @fin, @eivain1, @eivav1, @eivain2, @eivav2, @eivain3, @eivav3, @eivain4, @eivav4, @eivain5, @eivav5, @eivain6, @eivav6, @eivain7, @eivav7, @eivain8, @eivav8, @eivain9, @eivav9, @ivatx1, @ivatx2, @ivatx3, @ivatx4, @ivatx5, @ivatx6, @ivatx7, @ivatx8, @ivatx9, @memissao, @cdata, @chora, @saida, @fref, @ccusto)
				
				INSERT INTO fo (fostamp, docnome, adoc, nome, etotal, data, docdata, foano, doccode, no, ccusto, moeda, pdata, zona, eivain, ettiva, ettiliq, eivainsns, memissao, eivav1, eivav2, eivav3, eivav4, eivav5, eivav6, eivav7, eivav8, eivav9, morada, local, codpost, ncont, epaivav1, epaivav2, epaivav3, epaivav4, epaivav5, epaivav6, epaivav7, epaivav8, epaivav9, epaivain, epatotal, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fin, efinv) 
				VALUES (@fostamp, @nmdoc, @DCCRQC, @nome, @etotal, @pdata, @pdata, @ftano, @ndoc, @no, @ccusto, @moeda, @pdata, @zona, @etot1, @ettiva, @etot1, @etot1, @moeda, @eivav1, @eivav2, @eivav3, @eivav4, @eivav5, @eivav6, @eivav7, @eivav8, @eivav9, @morada, @local, @codpost, @ncont, @eivav1, @eivav2, @eivav3, @eivav4, @eivav5, @eivav6, @eivav7, @eivav8, @eivav9, @etot1, @etotal, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @DCCDCG, @efinv)

				EXEC SPMSS_DocDocComprasUSR @DCCEXR,@DCCTPD,@DCCSER,@fno,@fostamp,@no				

				DECLARE @DEVOLUCAO CHAR(1)
				SET @DEVOLUCAO = dbo.ExtractFromACL(@DocACL, 27)
				EXECUTE SPMSS_DocDocComprasLin @DCCEXR, @DCCTPD, @DCCSER, @fno, @fostamp, @fdata, @DCCDCG, @ArmOrigem, @ArmDestino, @DocTipoSAFT, @nmdoc, @DCCRQC, @estab, @no, @nome, @ccusto, @DocAnul, @DEVOLUCAO
	
				UPDATE MSDCC Set DCCSYNCR='S' WHERE DCCEXR=@DCCEXR AND DCCTPD=@DCCTPD And DCCSER=@DCCSER And DCCNDC=@fno
				UPDATE MSDCL Set DCLSYNCR='S' WHERE DCLEXR=@DCCEXR AND DCLTPD=@DCCTPD And DCLSER=@DCCSER And DCLNDC=@fno
		
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				ROLLBACK TRANSACTION
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curCabFT INTO @DocAnul, @fno, @fdata, @ForNumTmp, @nome, @morada, @local, @codpost, @ncont, @DocTerminal, @DocDataVenc, @CondVendTmp, @ettiliq, @edescc, @ettiva, @DCCDCG, @ArmOrigem, @ArmDestino, @fin, @efinv, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @moradaentrega, @localentrega, @codpostentrega, @DocACL, @DESCREGIVA, @CODPAIS, @DCCRQC, @dcci1v, @dcci2v, @dcci3v
		END
		
FIM:
		CLOSE curCabFT
		DEALLOCATE curCabFT
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Docs
-- Integração de documentos
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_Docs]
	@EstabSeparator CHAR(1),
	@EstabSeparatorFor CHAR(1),
	@Imposto1 CHAR(10),
	@Imposto2 CHAR(10),
	@Imposto3 CHAR(10),
	@ValidateDocLines INT,
	@ValidateDocSequence INT,
	@ValidateDocTotals NUMERIC(19,6),
	@MoeEmissao VARCHAR(15) = 'EURO'
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DCCEXR VARCHAR(30)
	DECLARE @DCCTPD VARCHAR(10)
	DECLARE @DCCSER VARCHAR(4)
	DECLARE @DCCNDC INT
	DECLARE @DCCTIPO CHAR(1)
	DECLARE @DCCDTA VARCHAR(8)
	DECLARE @DCCHOR VARCHAR(6)

    DECLARE curDocsCab CURSOR FOR 
	SELECT DISTINCT DCCEXR, DCCTPD, DCCSER, DCCNDC, DCCTIPO, DCCDTA, DCCHOR FROM MSDCC(nolock) WHERE DCCSYNCR = 'N' AND (DCCTIPO IN ('A', 'P', 'C', 'F')) ORDER BY DCCDTA, DCCHOR,DCCTIPO, DCCEXR, DCCTPD, DCCSER, DCCNDC

	OPEN curDocsCab
		FETCH NEXT FROM curDocsCab INTO @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DCCTIPO, @DCCDTA, @DCCHOR
		WHILE @@FETCH_STATUS = 0 BEGIN
			IF (@@ERROR <> 0) GOTO FIM
			
			IF @DCCTIPO = 'P' EXECUTE SPMSS_DocDossIntern @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @EstabSeparator, @EstabSeparatorFor, @Imposto1, @Imposto2, @Imposto3, @ValidateDocLines, @ValidateDocSequence, @ValidateDocTotals
			ELSE IF @DCCTIPO = 'A' EXECUTE SPMSS_DocDocFact @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @EstabSeparator, @Imposto1, @Imposto2, @Imposto3, @ValidateDocLines, @ValidateDocSequence, @ValidateDocTotals
			ELSE IF @DCCTIPO = 'F' EXECUTE SPMSS_DocDocCompras @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @EstabSeparatorFor, @Imposto1, @Imposto2, @Imposto3
			
			IF @@ERROR<>0
			BEGIN	
				GOTO FIM
			END
			
			FETCH NEXT FROM curDocsCab INTO @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @DCCTIPO, @DCCDTA, @DCCHOR
		END
	FIM:
		CLOSE curDocsCab
		DEALLOCATE curDocsCab	
		
END
GO

-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Integra
-- Procedimento principal que inicia a integração de todos os tipos de registos feitos no MSS
-- SPMSS_Clientes
--			'.' 	-> separador utilizado para identificar que factura a filiais
--			'EURO' 	-> moeda atribuida ao novo cliente
-- SPMSS_Estabelecimentos
--			'.' 	-> separador utilizado para identificar que factura a filiais
--			'EURO' 	-> moeda atribuida ao novo estabelecimento
-- SPMSS_Fornecedores
--			'-' 	-> separador utilizado para identificar que factura a filiais
--			'EURO' 	-> moeda atribuida ao novo fornecedor
-- SPMSS_Prospects
--			'-' 	-> separador utilizado para identificar que factura a filiais
--			'EURO' 	-> moeda atribuida ao novo Prospect
-- SPMSS_Docs
--			'.' 	-> separador utilizado para identificar que factura a filiais
--			'-'	 	-> separador utilizado para identificar que factura a filiais de fornecedor
--          ''      -> imposto 1 (Valor possível (ecovalor))
--          ''      -> imposto 2 (Valor possível (ecovalor))
--          ''      -> imposto 3 (Valor possível (ecovalor))
--          1       -> Validar número de linhas de documentos ( 0 – Não / 1 – Sim)
--          1       -> Validar sequência do número de documento ( 0 – Não / 1 – Sim)
--          0       -> Validar totais de documento (Com a margem indicada)
-- SPMSS_Recibo
--			'.' 	-> separador utilizado para identificar que factura a filiais
--			'R10001'-> classificação do recibo
--			94		-> código de movimento de conta corrente dos descontos financeiros
--          1      -> Validar número de linhas de documentos ( 0 – Não / 1 – Sim)
--          1       -> Validar sequência do número de documento ( 0 – Não / 1 – Sim)
--          0       -> Validar totais do recibo (Com a margem indicada)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_Integra]
AS
BEGIN
	SET NOCOUNT ON

    EXEC SPMSS_Clientes '.', 'EURO'
	EXEC SPMSS_Estabelecimentos '.', 'EURO'
	EXEC SPMSS_Fornecedores '-', 'EURO'
	EXEC SPMSS_Prospects'-', 'EURO'
	EXEC SPMSS_Docs '.', '-','','','',1,1,0,'EURO'
	EXEC SPMSS_Recibo '.', 'R10001', 94,1,1,0
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'SPMSS_Reconstroi_SP_USR')
	DROP PROCEDURE [dbo].[SPMSS_Reconstroi_SP_USR]
GO

CREATE PROCEDURE [dbo].[SPMSS_Reconstroi_SP_USR]
	@name varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	declare @spsql varchar(MAX)
	declare @spsqlnovo varchar(MAX)

	set @spsql = ''

	SET @spsql = (select (substring(sm.definition, charindex('SET NOCOUNT ON;', RTRIM(sm.definition)) + 16, LEN(sm.definition) - (charindex('SET NOCOUNT ON;', sm.definition) + 15)))
	from sys.sql_modules as sm JOIN sys.objects AS o ON sm.object_id = o.object_id where o.type = 'P'
	and OBJECT_NAME(sm.object_id) like '%' + @name + '%')

	IF (@spsql <> '')
	BEGIN
		IF UPPER(@name) = UPPER('SPMSS_DocDocComprasLinUSR')
		begin
			DROP PROCEDURE [dbo].[SPMSS_DocDocComprasLinUSR]
			
			SET @spsqlnovo = 'CREATE PROCEDURE [dbo].[SPMSS_DocDocComprasLinUSR] 
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@fostamp CHAR(25),		-- Stamp do documento de compra
	@fnstamp CHAR(25),		-- Stamp da linha
	@ref VARCHAR(18),		-- Código do artigo
	@DCLLIN INT				-- Linha do documento no MSS
AS
BEGIN
	SET NOCOUNT ON; ' + @spsql

	exec (@spsqlnovo)
		end

		IF UPPER(@name) = UPPER('SPMSS_DocDocFactLinUSR')
		begin
			DROP PROCEDURE [dbo].[SPMSS_DocDocFactLinUSR]
			
			SET @spsqlnovo = 'CREATE PROCEDURE [dbo].[SPMSS_DocDocFactLinUSR] 
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@ftstamp CHAR(25),		-- Stamp do documento de facturação
	@fistamp CHAR(25),		-- Stamp da linha
	@ref VARCHAR(18),		-- Código do artigo
	@DCLLIN INT				-- Linha do documento no MSS
AS
BEGIN
	SET NOCOUNT ON; ' + @spsql
	exec (@spsqlnovo)

		end

		IF UPPER(@name) = UPPER('SPMSS_DocDossInternLinUSR')
		begin
			DROP PROCEDURE [dbo].[SPMSS_DocDossInternLinUSR]
			
			SET @spsqlnovo = 'CREATE PROCEDURE [dbo].[SPMSS_DocDossInternLinUSR] 
	@DCCEXR VARCHAR(30),	-- Exercício do documento no MSS
	@DCCTPD VARCHAR(10),	-- Código do documento no MSS
	@DCCSER VARCHAR(4),		-- Série do documento no MSS
	@DCCNDC INT,			-- Número do documento no MSS
	@bostamp CHAR(25),		-- Stamp do dossier interno
	@bistamp CHAR(25),		-- Stamp da linha
	@no INT,				-- Nº do cliente
	@ref VARCHAR(18),		-- Código do artigo
	@DCLLIN INT				-- Linha do documento no MSS
AS
BEGIN
	SET NOCOUNT ON; ' + @spsql

		exec (@spsqlnovo)
		end

	END
END
GO

EXEC SPMSS_Reconstroi_SP_USR 'SPMSS_DocDocComprasLinUSR'
GO
EXEC SPMSS_Reconstroi_SP_USR 'SPMSS_DocDocFactLinUSR'
GO
EXEC SPMSS_Reconstroi_SP_USR 'SPMSS_DocDossInternLinUSR'
GO
