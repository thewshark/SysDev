CREATE PROCEDURE [SP_UpdateDatabaseGeneral]
      @GeneralDBVersion INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @STATE INT
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @DatabaseVersion INT
	DECLARE @ThisScriptVersion INT

	DECLARE @estado varchar(5)
    DECLARE @descerro varchar(255)

	BEGIN TRY
	BEGIN TRANSACTION

	SET @estado = 'ERROR'
    SET @descerro = 'Ocorreu um erro ao atualizar a base de dados General. '
	
	SET @DatabaseVersion = 0

	--Vai buscar a versão da base de dados e compara com a versão da base de dados desta versão do backoffice
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'General') AND type in (N'U'))
	BEGIN
		SELECT @DatabaseVersion = COALESCE(ParameterValue, 0) FROM General (NOLOCK) WHERE (UPPER(ParameterID)) = 'GENERAL_DATABASEVERSION'
	END
	ELSE
		SELECT @DatabaseVersion = 0

	IF ((@DatabaseVersion = null) OR (@DatabaseVersion <= 0))
	BEGIN
		SET @DatabaseVersion = 0
	END

	IF (@DatabaseVersion <= @GeneralDBVersion)
	BEGIN
	
		IF (@DatabaseVersion < 1)
		BEGIN
			CREATE TABLE Scales(
				ScaleID int NOT NULL,
				ScaleDescription nvarchar(300) NULL,
				SerialPort int NULL,
				BaudRate int NULL,
				DataBits int NULL,
				StopBits int NULL,
				Parity int NULL,
				OperationMode int NULL,
				ConnectionString nvarchar(100) NULL,
				WeightStartPosition int NULL,
				WeightLenth int NULL,
				Timeout int NULL,
				Tries int NULL,
			CONSTRAINT PK_Scales PRIMARY KEY CLUSTERED 
			(
				ScaleID ASC
			)
			);
		END

		-- versão 8 start
		IF (@DatabaseVersion < 8)
		BEGIN
			CREATE TABLE dbo.Tmp_Scales
				(
				Id int NOT NULL IDENTITY (1, 1),
				ScaleID int NOT NULL,
				ScaleDescription nvarchar(300) NULL,
				SerialPort int NULL,
				BaudRate int NULL,
				DataBits int NULL,
				StopBits int NULL,
				Parity int NULL,
				OperationMode int NULL,
				ConnectionString nvarchar(100) NULL,
				WeightStartPosition int NULL,
				WeightLenth int NULL,
				Timeout int NULL,
				Tries int NULL,
				WeightMinimum numeric(18, 6) NOT NULL
				)  ON [PRIMARY];

			ALTER TABLE dbo.Tmp_Scales SET (LOCK_ESCALATION = TABLE);

			ALTER TABLE dbo.Tmp_Scales ADD CONSTRAINT
				DF_Scales_WeightMinimum DEFAULT 0 FOR WeightMinimum;

			SET IDENTITY_INSERT dbo.Tmp_Scales OFF;

			IF EXISTS(SELECT * FROM dbo.Scales)
				 EXEC('INSERT INTO dbo.Tmp_Scales (ScaleID, ScaleDescription, SerialPort, BaudRate, DataBits, StopBits, Parity, OperationMode, ConnectionString, WeightStartPosition, WeightLenth, Timeout, Tries)
					SELECT ScaleID, ScaleDescription, SerialPort, BaudRate, DataBits, StopBits, Parity, OperationMode, ConnectionString, WeightStartPosition, WeightLenth, Timeout, Tries FROM dbo.Scales WITH (HOLDLOCK TABLOCKX)');

			DROP TABLE dbo.Scales;

			EXECUTE sp_rename N'dbo.Tmp_Scales', N'Scales', 'OBJECT';

			ALTER TABLE dbo.Scales ADD CONSTRAINT
				PK_Scales PRIMARY KEY CLUSTERED 
				(
				ScaleID
				) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];

			CREATE NONCLUSTERED INDEX IX_Scales_AutoId ON dbo.Scales
				(
				Id
				) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];

			CREATE NONCLUSTERED INDEX IX_Scales_ScaleDescription ON dbo.Scales
				(
				ScaleDescription
				) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
		END
		-- versão 8 end

		IF (@DatabaseVersion < 9)
		BEGIN
			ALTER TABLE CompaniesProperties ALTER COLUMN ParameterValue nvarchar(500)
		END

		--
		-- Actualizar GENERAL DATABASEVERSION
		--
		SET @ThisScriptVersion = 9
		
		IF (@ThisScriptVersion <> @GeneralDBVersion)
		BEGIN
			SET @ErrorMessage = 'A versão dos scripts da base de dados general (' + CAST(@ThisScriptVersion as varchar(5))  + ') não corresponde com a versão do backoffice ('+ CAST(@GeneralDBVersion as varchar(5))+')';
			RAISERROR (@ErrorMessage, 16, 1);
		END		
		UPDATE General SET ParameterValue = @GeneralDBVersion WHERE ParameterID = 'General_DatabaseVersion'
	END

	COMMIT TRANSACTION


 	SET @estado = 'OK'
	SET @descerro = ''

	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE() + ' Line: '+ CAST(ERROR_LINE() AS nVarchar(50)), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		ROLLBACK TRANSACTION
		SET @STATE = 1
		SET @descerro = @descerro + @ErrorMessage
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH

	SELECT @estado, @descerro
END
