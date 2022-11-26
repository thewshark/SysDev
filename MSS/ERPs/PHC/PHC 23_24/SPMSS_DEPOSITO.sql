

CREATE PROCEDURE [dbo].[SPMSS_Deposito]
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
	
	DECLARE @DATA DATETIME
	DECLARE @Dvalor DATETIME
	DECLARE @Enumer NUMERIC(19,6)
	DECLARE @Evalor NUMERIC(19,6)
	DECLARE @Echeque NUMERIC(19,6)
	DECLARE @Contado INT
	DECLARE @ollocal VARCHAR(50)
	DECLARE @OContado INT
	DECLARE @olorigem VARCHAR(50)
	
	DECLARE @moeda VARCHAR(11)
	DECLARE @moeda1 VARCHAR(11)
	
	DECLARE @NOTALAO INT   
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME 
	DECLARE @OXSTAMP CHAR(25)
	DECLARE @DEPTERMINAL INT

	DECLARE @BCCEXR VARCHAR(30)
	DECLARE @BCCSER VARCHAR(4)
	 
	BEGIN TRY
	BEGIN TRANSACTION

	DECLARE curcabdep CURSOR FOR
		SELECT 
		ISNULL(BCCEXR, ''),
		CAST(ISNULL(BCCSER, '0') AS INT),
		ISNULL(BCCNDC, 0),
		ISNULL(BCCDTA, ''),
		ISNULL(BCCVLN, 0),
		ISNULL(BCCVLC, 0),
		ISNULL(BCCBAN, '')			
		FROM MSBCC(nolock)
		WHERE BCCSYNCR = 'N' ORDER BY BCCEXR, BCCSER, BCCNDC
---	
	OPEN curCabDEP
	FETCH NEXT FROM curCabDEP INTO @BCCEXR, @BCCSER, @NOTALAO, @DATA, @ENUMER, @echeque, @OLLOCAL
	WHILE @@FETCH_STATUS = 0 BEGIN
			
			WAITFOR DELAY '00:00:00.200' 
			SET @DateTimeTmp = GETDATE()
			SET @DateStr = dbo.DateToString(@DateTimeTmp)
			SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
			SET @OXstamp = 'MSS_' + @DateStr + @TimeStr

			SET @ousrinis = 'MSS T-' + CAST(@DepTerminal AS VARCHAR(3))
			SET @usrinis = 'MSS T-' + CAST(@DepTerminal AS VARCHAR(3))

			SET @ousrdata = @DateStr
			SET @usrdata = @DateStr

			SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
			SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
	
				
			SET @Contado = 0	
			SET @Evalor=@Enumer+@echeque

			SET @moeda = 'PTE ou EURO'
			--Select @olorigem=u_CONTA, @ocontado=U_Nconta FROM cm3 WHERE cm = @BCCSER         

			INSERT INTO OX(oxstamp, data, dvalor,enumer, numer,contado, ollocal, ocontado, olorigem,evalor, valor, moeda, moeda1)
			VALUES(@OXSTAMP,@DATA, @data, @Enumer, dbo.EurToEsc(@Enumer),@Contado, @ollocal,@OContado, @olorigem, @Evalor,dbo.EurToEsc(@evalor),@moeda, @moeda  )


			EXECUTE SPMSS_DepositoLin @BCCEXR, @BCCSER


			UPDATE MSBCC Set BCCSYNCR='S' WHERE BCCEXR=@BCCEXR And BCCSER=@BCCSER And BCCNDC=@NOTALAO
			UPDATE MSBCL Set BCLSYNCR='S' WHERE BCLEXR=@BCCEXR And BCLSER=@BCCSER And BCLNDC=@NOTALAO
				
			FETCH NEXT FROM curCabDEP INTO @BCCEXR, @BCCSER, @NOTALAO, @DATA, @ENUMER,@echeque, @OLLOCAL
	END
		
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
		ROLLBACK TRANSACTION
				
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		GOTO FIM
	END CATCH
	FIM:
	CLOSE curCabdep
	DEALLOCATE curCabdep
END
