-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ServicosAnexos
-- Integração de Anexos de Serviços
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ServicosAnexos]
	@SRVEXR varchar(30),	-- exercício do serviço
	@SRVSER varchar(10),	-- série do serviço
	@SRVNDC numeric(19, 0),	-- número do serviço
	@pastamp char(25)		-- stamp do PAT criado/alterado no PHC
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

		DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @FOTFIC varchar(2000)
	DECLARE @FOTTERM int

	DECLARE @FileName VARCHAR(200)
	DECLARE @FileExtension VARCHAR(5)
	DECLARE @Temp VARCHAR(200)
	DECLARE @anexosstamp VARCHAR(50)
	DECLARE @fullname VARCHAR(2000)

    DECLARE curAnexos CURSOR FOR 
	SELECT 
		ISNULL(FOTFIC, ''),
		ISNULL(FOTTERM, '')
	FROM MSFOT(nolock) WHERE FOTEXR = @SRVEXR AND FOTTPD = 'SRVC' AND FOTSER = @SRVSER AND FOTNDC = @SRVNDC

	OPEN curAnexos

		FETCH NEXT FROM curAnexos INTO @FOTFIC, @FOTTERM

		WHILE @@FETCH_STATUS = 0 BEGIN			
			WAITFOR DELAY '00:00:00.200' 
			SET @DateTimeTmp = GETDATE()
			SET @DateStr = dbo.DateToString(@DateTimeTmp)
			SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

			SET @anexosstamp = 'MSS_' + @DateStr + @TimeStr

			SET @usrinis = 'MSS T-' + CAST(@FOTTERM AS VARCHAR(3))
			SET @usrdata = @DateStr
			SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				
			SET @fullname = '<PATH SYNCHRO>\TR' + right('0000' + @FOTTERM, 4) + '\ToPC\' + @FOTFIC

			SET @FileExtension = reverse(left(reverse(@FOTFIC),charindex('.',reverse(@FOTFIC))-1))
			SET @FileName = replace(@FOTFIC, '.'+@FileExtension, '')

			SELECT @Temp=rtrim(ltrim(fname)) FROM anexos WHERE oritable = 'PA' AND fname = @FileName AND recstamp = @pastamp
			IF @Temp = '' or @Temp is null
			begin
				INSERT INTO anexos(anexosstamp, oritable, resumo, recstamp, fullname, fname, fext, flen, tipo, passw, origem, keylook, tpdos, tpdoc, ausrinis, ausrdata, ausrhora, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) values (@anexosstamp, 'PA', 'Foto Serviço', @pastamp, @fullname, @FileName, @FileExtension, 0, 2, '', '', '', 0, 0, @usrinis, @usrdata, @usrhora, @usrinis, @usrdata, @usrhora, @usrinis, @usrdata, @usrhora)
			end

			FETCH NEXT FROM curAnexos INTO @FOTFIC, @FOTTERM
		END
	FIM:
		CLOSE curAnexos
		DEALLOCATE curAnexos	
END
GO


