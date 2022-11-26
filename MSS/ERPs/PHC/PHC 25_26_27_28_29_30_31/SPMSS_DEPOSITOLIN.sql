CREATE PROCEDURE [dbo].[SPMSS_DepositoLin]
	@BClEXR VARCHAR(30),
	@BClSER VARCHAR(4)
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	DECLARE @Evalor NUMERIC(19,6)
	DECLARE @Entidade VARCHAR(40)
	DECLARE @numero VARCHAR(20)
	DECLARE @lordem INT
		
	DECLARE @moeda1 VARCHAR(11)
	DECLARE @moeda2 VARCHAR(11)
	DECLARE @contado int
	
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME 
	DECLARE @OySTAMP CHAR(25)
	DECLARE @DEPTERMINAL INT
	DECLARE @BCLLIN INT
	
	BEGIN TRY

	DECLARE curlindep CURSOR FOR
		SELECT 
		ISNULL(BCLEXR, ''),
		CAST(ISNULL(BCLSER, '0') AS INT),
		--ISNULL(BCLNDC, 0),
		ISNULL(BCLBAN, ''),
		ISNULL(BCLVAL, 0),
		ISNULL(BCLNCH, ''),	
		ISNULL(BCLLIN*10000, 0),
		ISNULL(BCLLIN, 0)
	FROM MSBCL(nolock)
	WHERE BCLSYNCR = 'N' ORDER BY BCLEXR, BCLSER, BCLNDC
---	
	OPEN curLinDEP

		FETCH NEXT FROM curLinDEP INTO 
		@BCLEXR, @BCLSER,@entidade, @evalor, @numero, @lordem, @BCLLIN
		
		
		WHILE @@FETCH_STATUS = 0 BEGIN

				
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @Oystamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DepTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DepTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
	
				
				
				SET @moeda1 = 'PTE ou EURO'
		        SET @contado = 0

				INSERT INTO OY(OYSTAMP, entidade, evalor, valor,  lordem, moeda1, moeda2, contado, numero )
				VALUES(@OySTAMP, @Entidade, @Evalor, dbo.EurToEsc(@evalor), @lordem, @moeda1, @moeda1, @contado, @numero )

							
				

			FETCH NEXT FROM curLinDEP INTO @BCLEXR, @BCLSER,  @entidade, @evalor, @numero, @lordem, @BCLLIN
		END

	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		GOTO FIM
	END CATCH

		FIM:
		CLOSE curLinDep
		DEALLOCATE curLinDep
END
