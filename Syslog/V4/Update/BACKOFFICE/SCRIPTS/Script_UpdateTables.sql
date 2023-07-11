CREATE PROCEDURE [SP_u_Kapps_UpdateBackoffice]
      @BackDBVersion INT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON
	DECLARE @STATE INT
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @DatabaseVersion INT
	DECLARE @DatabaseVersionScript INT
	DECLARE @ParametersVersion INT
	DECLARE @ThisScriptVersion INT

	DECLARE @estado varchar(5)
	DECLARE @descerro varchar(255)

	BEGIN TRY
	BEGIN TRANSACTION

	SET @estado = 'ERROR'
	SET @descerro = 'Ocorreu um erro ao atualizar a base de dados. '
	SET @DatabaseVersion = 0
	SET @ParametersVersion = 0

	--Vai buscar a versão da base de dados e compara com a versão da base de dados desta versão do backoffice
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Parameters') AND type in (N'U'))
	BEGIN
		SELECT @DatabaseVersion = COALESCE(ParameterValue, 0) FROM u_Kapps_Parameters (NOLOCK) WHERE (UPPER(AppCode) = 'AP0002' OR UPPER(AppCode)='SYT') AND ParameterGroup='MAIN' AND UPPER(ParameterID) = UPPER('DATABASEVERSION')
		SELECT @ParametersVersion = COALESCE(ParameterValue, 0) FROM u_Kapps_Parameters (NOLOCK) WHERE (UPPER(AppCode) = 'AP0002' OR UPPER(AppCode)='SYT') AND ParameterGroup='MAIN' AND UPPER(ParameterID) = UPPER('PARAMETERSVERSION')
	END
	ELSE
		SELECT @DatabaseVersion = COALESCE(ParameterValue, 0) FROM Kapps_Parameters (NOLOCK) WHERE UPPER(AppCode) = 'AP0002' AND UPPER(ParameterID) = UPPER('DATABASEVERSION')	

	IF ((@DatabaseVersion = null) OR (@DatabaseVersion <= 0))
	BEGIN
		SET @DatabaseVersion = 0
	END
	IF (@DatabaseVersion < 47)	
	BEGIN
		RAISERROR('Actualize a APP Logistica para a versão da base de dados v47.33 antes de actualizar para o SYSLOG_V30', 16, 1)
	END
	IF (@DatabaseVersion < 80)	
	BEGIN
		RAISERROR('Actualize o SYSLOG_V30 para a versão da base de dados v80.44 antes de actualizar para o SYSLOG_V40', 16, 1)
	END
	IF (@ParametersVersion < 87)	
	BEGIN
		RAISERROR('Actualize o SYSLOG_V30 para a versão da base de dados v80.44 build 20210223 antes de actualizar para o SYSLOG_V40', 16, 1)
	END
	

	IF (@DatabaseVersion < @BackDBVersion)
	BEGIN
	
		IF (@DatabaseVersion < 81)
		BEGIN
			ALTER TABLE u_Kapps_Users ADD UserERP nvarchar(50) NULL;

			ALTER TABLE u_Kapps_InquiryQuestions ADD InquiryQuestionMaxLength numeric(11, 3) NULL;

			ALTER TABLE u_Kapps_Labels ADD LabelType nvarchar(50);

			ALTER TABLE u_Kapps_Log ADD LogIsError bit;

			ALTER TABLE u_Kapps_Parameters ADD 
				ParentID nvarchar(50) NULL,
				ParameterValuesQuery nvarchar(max) NULL;

			ALTER TABLE u_Kapps_LabelRules ADD 
				EntityType nvarchar(50) NULL,
				EntityNumber nvarchar(50) NULL,
				EntityName nvarchar(100) NULL;

			ALTER TABLE u_Kapps_ParametersMonitors ADD 
				Panel01_Texto nvarchar(50) NULL,
				Panel01_Background nvarchar(50) NULL,
				Panel01_Foreground nvarchar(50) NULL,
				Panel01_FontFamily nvarchar(50) NULL,
				Panel01_FontSize nvarchar(50) NULL,
				Panel01_FontStyle nvarchar(50) NULL,
				Panel01_FontWeight nvarchar(50) NULL,
				Panel01_FontAligment nvarchar(50) NULL,
				Panel02_Texto nvarchar(50) NULL,
				Panel02_Background nvarchar(50) NULL,
				Panel02_Foreground nvarchar(50) NULL,
				Panel02_FontFamily nvarchar(50) NULL,
				Panel02_FontSize nvarchar(50) NULL,
				Panel02_FontStyle nvarchar(50) NULL,
				Panel02_FontWeight nvarchar(50) NULL,
				Panel02_FontAligment nvarchar(50) NULL,
				Panel03_Texto nvarchar(50) NULL,
				Panel03_Background nvarchar(50) NULL,
				Panel03_Foreground nvarchar(50) NULL,
				Panel03_FontFamily nvarchar(50) NULL,
				Panel03_FontSize nvarchar(50) NULL,
				Panel03_FontStyle nvarchar(50) NULL,
				Panel03_FontWeight nvarchar(50) NULL,
				Panel03_FontAligment nvarchar(50) NULL,
				Panel04_Texto nvarchar(50) NULL,
				Panel04_Background nvarchar(50) NULL,
				Panel04_Foreground nvarchar(50) NULL,
				Panel04_FontFamily nvarchar(50) NULL,
				Panel04_FontSize nvarchar(50) NULL,
				Panel04_FontStyle nvarchar(50) NULL,
				Panel04_FontWeight nvarchar(50) NULL,
				Panel04_FontAligment nvarchar(50) NULL,
				Panel05_Texto nvarchar(50) NULL,
				Panel05_Background nvarchar(50) NULL,
				Panel05_Foreground nvarchar(50) NULL,
				Panel05_FontFamily nvarchar(50) NULL,
				Panel05_FontSize nvarchar(50) NULL,
				Panel05_FontStyle nvarchar(50) NULL,
				Panel05_FontWeight nvarchar(50) NULL,
				Panel05_FontAligment nvarchar(50) NULL,
				Panel06_Texto nvarchar(50) NULL,
				Panel06_Background nvarchar(50) NULL,
				Panel06_Foreground nvarchar(50) NULL,
				Panel06_FontFamily nvarchar(50) NULL,
				Panel06_FontSize nvarchar(50) NULL,
				Panel06_FontStyle nvarchar(50) NULL,
				Panel06_FontWeight nvarchar(50) NULL,
				Panel06_FontAligment nvarchar(50) NULL,
				Panel07_Texto nvarchar(50) NULL,
				Panel07_Background nvarchar(50) NULL,
				Panel07_Foreground nvarchar(50) NULL,
				Panel07_FontFamily nvarchar(50) NULL,
				Panel07_FontSize nvarchar(50) NULL,
				Panel07_FontStyle nvarchar(50) NULL,
				Panel07_FontWeight nvarchar(50) NULL,
				Panel07_FontAligment nvarchar(50) NULL,
				Panel08_Texto nvarchar(50) NULL,
				Panel08_Background nvarchar(50) NULL,
				Panel08_Foreground nvarchar(50) NULL,
				Panel08_FontFamily nvarchar(50) NULL,
				Panel08_FontSize nvarchar(50) NULL,
				Panel08_FontStyle nvarchar(50) NULL,
				Panel08_FontWeight nvarchar(50) NULL,
				Panel08_FontAligment nvarchar(50) NULL,
				Panel09_Texto nvarchar(50) NULL,
				Panel09_Background nvarchar(50) NULL,
				Panel09_Foreground nvarchar(50) NULL,
				Panel09_FontFamily nvarchar(50) NULL,
				Panel09_FontSize nvarchar(50) NULL,
				Panel09_FontStyle nvarchar(50) NULL,
				Panel09_FontWeight nvarchar(50) NULL,
				Panel09_FontAligment nvarchar(50) NULL,
				Panel10_Texto nvarchar(50) NULL,
				Panel10_Background nvarchar(50) NULL,
				Panel10_Foreground nvarchar(50) NULL,
				Panel10_FontFamily nvarchar(50) NULL,
				Panel10_FontSize nvarchar(50) NULL,
				Panel10_FontStyle nvarchar(50) NULL,
				Panel10_FontWeight nvarchar(50) NULL,
				Panel10_FontAligment nvarchar(50) NULL,
				Panel11_Texto nvarchar(50) NULL,
				Panel11_Background nvarchar(50) NULL,
				Panel11_Foreground nvarchar(50) NULL,
				Panel11_FontFamily nvarchar(50) NULL,
				Panel11_FontSize nvarchar(50) NULL,
				Panel11_FontStyle nvarchar(50) NULL,
				Panel11_FontWeight nvarchar(50) NULL,
				Panel11_FontAligment nvarchar(50) NULL,
				Panel12_Texto nvarchar(50) NULL,
				Panel12_Background nvarchar(50) NULL,
				Panel12_Foreground nvarchar(50) NULL,
				Panel12_FontFamily nvarchar(50) NULL,
				Panel12_FontSize nvarchar(50) NULL,
				Panel12_FontStyle nvarchar(50) NULL,
				Panel12_FontWeight nvarchar(50) NULL,
				Panel12_FontAligment nvarchar(50) NULL,
				SQLDocLines nvarchar(max) NULL,
				SQLDocTotals nvarchar(max) NULL,
				SQLRowTotals nvarchar(max) NULL;


			CREATE TABLE u_Kapps_Keywords (
			    id int IDENTITY(1,1) NOT NULL,
				AI nvarchar(100) NULL,
				Description nvarchar(300) NULL
			);


			CREATE TABLE u_Kapps_Translate(
				id int IDENTITY(1,1) NOT NULL,
				FormName nvarchar(30) NULL,
				ControlName nvarchar(5) NULL,
				TextLength int NULL,
				PT_Text nvarchar(200) NULL,
				EN_Text nvarchar(200) NULL,
				ES_Text nvarchar(200) NULL,
				FR_Text nvarchar(200) NULL,
				DE_Text nvarchar(200) NULL,
				IT_Text nvarchar(200) NULL
			 CONSTRAINT PK_u_Kapps_Translate PRIMARY KEY CLUSTERED 
			(
				id ASC
			) ON [PRIMARY]
			) ON [PRIMARY];

			ALTER TABLE u_Kapps_PackingHeader ADD
				CreationWarehouse nvarchar(50) NOT NULL DEFAULT(''),
				CreationOrigin nvarchar(1) NOT NULL DEFAULT(''),
				CurrentWarehouse nvarchar(50) NOT NULL DEFAULT(''),
				CurrentLocation nvarchar(50) NOT NULL DEFAULT(''),
				ModificationDate nvarchar(8) NOT NULL DEFAULT(''),
				ModificationTime nvarchar(6) NOT NULL DEFAULT(''),
				ModificationUser nvarchar(50) NOT NULL DEFAULT(''),
				DeleteReason nvarchar(100) NOT NULL DEFAULT(''),
				PackStatus int NOT NULL DEFAULT(0)
				;

			ALTER TABLE u_Kapps_PackingDetails ADD
				QuantityUM nvarchar(25) NOT NULL DEFAULT(''),
				Quantity2 decimal(18, 3) NOT NULL DEFAULT(0),
				Quantity2UM nvarchar(25) NOT NULL DEFAULT(''),
				ProductionDate nvarchar(8) NOT NULL DEFAULT(''),
				BestBeforeDate nvarchar(8) NOT NULL DEFAULT('')
				;
			
			CREATE TABLE u_Kapps_PackingStatus(
				Code int NULL,
				Description nvarchar(20) NULL
			);

			CREATE TABLE u_Kapps_BO_Menu(
				id int IDENTITY(1,1) NOT NULL,
				Name nvarchar(100) NULL,
				Keyword nvarchar(100) NULL,
				LevelNumber nvarchar(100) NULL,
				ParentNumber nvarchar(100) NULL,
				ImageName nvarchar(100) NULL,
				IsHeader int NULL
			);

			CREATE TABLE u_Kapps_UsersPermissions(
				UserID varchar(10) NULL,
				MenuName varchar(50) NULL,
				MenuLevel varchar(10) NULL,
				CanRead bit NULL,
				CanWrite bit NULL,
				CanDelete bit NULL
			);
		END

		IF (@DatabaseVersion < 82)
		BEGIN
			ALTER TABLE u_Kapps_Processes ADD AvailableOn nvarchar(1) NOT NULL DEFAULT('T') WITH VALUES;
			ALTER TABLE u_Kapps_PackingHeader ADD CustomerOrder nvarchar(100) NOT NULL DEFAULT('') WITH VALUES;

			ALTER TABLE u_Kapps_PackagingTypes ALTER COLUMN Height DECIMAL(18, 1);
			ALTER TABLE u_Kapps_PackagingTypes ALTER COLUMN Lenght DECIMAL(18, 1);
			ALTER TABLE u_Kapps_PackagingTypes ALTER COLUMN Width DECIMAL(18, 1);
			ALTER TABLE u_Kapps_PackagingTypes ALTER COLUMN Weight DECIMAL(18, 3);
 
			ALTER TABLE u_Kapps_PackingHeader ADD SSCC nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
		END

		IF (@DatabaseVersion < 83)
		BEGIN
			CREATE TABLE u_Kapps_LoadingLocations(
				LocationID nvarchar(50) NOT NULL,
				LocationDescription nvarchar(100) NOT NULL,
				WarehouseID nvarchar(50) NOT NULL,
				Actif int NOT NULL,
				ActiveLoadNr bigint NOT NULL
			);

			CREATE TABLE u_Kapps_LoadingHeader(
				LoadNr bigint NOT NULL,
				LoadStatus int NOT NULL,
				LoadDate nvarchar(8) NOT NULL,
				LoadTime nvarchar(6) NOT NULL,
				LoadLocation nvarchar(50) NOT NULL,
				VehiclePlate nvarchar(50) NOT NULL,
				CreationDate nvarchar(8) NOT NULL,
				CreationTime nvarchar(6) NOT NULL,
				CreationUser nvarchar(50) NOT NULL,
				StartLoadingDate nvarchar(8) NOT NULL,
				StartLoadingTime nvarchar(6) NOT NULL,
				EndLoadingDate nvarchar(8) NOT NULL,
				EndLoadingTime nvarchar(6) NOT NULL
			);

			CREATE TABLE u_Kapps_LoadingDeliveryPoints(
				LoadNr bigint NOT NULL,
				DocStatus int NOT NULL,
				Actif int NOT NULL,
				LoadingSequence int NOT NULL,
				DocEXR nvarchar(50) NOT NULL,
				DocTPD nvarchar(50) NOT NULL,
				DocSEC nvarchar(50) NOT NULL,
				DocNDC nvarchar(50) NOT NULL,
				DocID nvarchar(50) NOT NULL,
				CustomerID nvarchar(50) NOT NULL,
				CustomerName nvarchar(50) NOT NULL,
				CustomerZipCode nvarchar(50) NOT NULL,
				CustomerCity nvarchar(50) NOT NULL,
				CustomerCountry nvarchar(50) NOT NULL,
				StartLoadingDate nvarchar(8) NOT NULL,
				StartLoadingTime nvarchar(6) NOT NULL,
				EndLoadingDate nvarchar(8) NOT NULL,
				EndLoadingTime nvarchar(6) NOT NULL
			);

			CREATE TABLE u_Kapps_LoadingLines(
				id bigint NOT NULL IDENTITY (1, 1),
				LoadNr nvarchar(50) NOT NULL,
				LineStatus int NOT NULL,
				DocEXR nvarchar(50) NOT NULL,
				DocTPD nvarchar(50) NOT NULL,
				DocSEC nvarchar(50) NOT NULL,
				DocNDC nvarchar(50) NOT NULL,
				ProductID nvarchar(50) NOT NULL,
				ProductDescription nvarchar(100) NOT NULL,
				Lot varchar(50) NOT NULL,
				Quantity decimal(18, 3) NOT NULL,
				Unit nvarchar(25) NOT NULL,
				LoadedQuantity decimal(18, 3) NOT NULL,
				PalletQuantity decimal(18, 3) NOT NULL,
				PalletUnit nvarchar(25) NOT NULL,
				PalletLoadedQuantity decimal(18, 3) NOT NULL,
			    WarehouseOrigin nvarchar(50) NOT NULL,
				ErrorDescription nvarchar(100) NOT NULL,
				DocID nvarchar(50) NOT NULL,
				LineID nvarchar(50) NOT NULL
			);

			CREATE TABLE u_Kapps_LoadingPallets(
				LoadNr bigint NOT NULL,
				DocID nvarchar(50) NOT NULL,
				SSCC nvarchar(50) NOT NULL
			);

			ALTER TABLE u_Kapps_LoadingLocations ADD  CONSTRAINT DF_u_Kapps_LoadingLocations_LocationID  DEFAULT ('') FOR LocationID;
			ALTER TABLE u_Kapps_LoadingLocations ADD  CONSTRAINT DF_u_Kapps_LoadingLocations_LocationDescription  DEFAULT ('') FOR LocationDescription;
			ALTER TABLE u_Kapps_LoadingLocations ADD  CONSTRAINT DF_u_Kapps_LoadingLocations_WarehouseID  DEFAULT ('') FOR WarehouseID;
			ALTER TABLE u_Kapps_LoadingLocations ADD  CONSTRAINT DF_u_Kapps_LoadingLocations_Actif  DEFAULT (0) FOR Actif;
			ALTER TABLE u_Kapps_LoadingLocations ADD  CONSTRAINT DF_u_Kapps_LoadingLocations_ActiveLoadNr  DEFAULT (0) FOR ActiveLoadNr;

			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_LoadNr  DEFAULT (0) FOR LoadNr;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_LoadStatus  DEFAULT (0) FOR LoadStatus;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_LoadDate  DEFAULT ('') FOR LoadDate;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_LoadTime  DEFAULT ('') FOR LoadTime;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_LoadLocation  DEFAULT ('') FOR LoadLocation;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_VehiclePlate  DEFAULT ('') FOR VehiclePlate;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_CreationDate  DEFAULT ('') FOR CreationDate;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_CreationTime  DEFAULT ('') FOR CreationTime;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_CreationUser  DEFAULT ('') FOR CreationUser;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_StartLoadingDate  DEFAULT ('') FOR StartLoadingDate;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_StartLoadingTime  DEFAULT ('') FOR StartLoadingTime;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_EndLoadingDate  DEFAULT ('') FOR EndLoadingDate;
			ALTER TABLE u_Kapps_LoadingHeader ADD  CONSTRAINT DF_u_Kapps_LoadingHeader_EndLoadingTime  DEFAULT ('') FOR EndLoadingTime;
			CREATE CLUSTERED INDEX [IX_u_Kapps_LoadingHeader_LoadNr] ON [dbo].[u_Kapps_LoadingHeader] 
			(
				[LoadNr] ASC
			) 
			ON [PRIMARY]

			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_LoadNr  DEFAULT (0) FOR LoadNr;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_DocStatus  DEFAULT (0) FOR DocStatus;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_Actif  DEFAULT (0) FOR Actif;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_LoadingSequence  DEFAULT ('0') FOR LoadingSequence;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_DocEXR  DEFAULT ('') FOR DocEXR;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_DocTPD  DEFAULT ('') FOR DocTPD;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_DocSEC  DEFAULT ('') FOR DocSEC;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_DocNDC  DEFAULT ('') FOR DocNDC;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_DocID  DEFAULT ('') FOR DocID;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_CustomerID  DEFAULT ('') FOR CustomerID;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_CustomerName  DEFAULT ('') FOR CustomerName;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_CustomerZipCode  DEFAULT ('') FOR CustomerZipCode;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_CustomerCity  DEFAULT ('') FOR CustomerCity;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_CustomerCountry  DEFAULT ('') FOR CustomerCountry;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_StartLoadingDate  DEFAULT ('') FOR StartLoadingDate;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_StartLoadingTime  DEFAULT ('') FOR StartLoadingTime;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_EndLoadingDate  DEFAULT ('') FOR EndLoadingDate;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_EndLoadingTime  DEFAULT ('') FOR EndLoadingTime;
			CREATE CLUSTERED INDEX [IX_u_Kapps_LoadingDeliveryPoints_LoadNr] ON [dbo].[u_Kapps_LoadingDeliveryPoints] 
			(
				[LoadNr] ASC,
				[DocID]
			) 
			ON [PRIMARY]
			
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_LoadNr  DEFAULT (0) FOR LoadNr;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_LineStatus  DEFAULT (0) FOR LineStatus;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_DocTPD  DEFAULT ('') FOR DocTPD;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_DocSEC  DEFAULT ('') FOR DocSEC;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_DocNDC  DEFAULT ('') FOR DocNDC;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_ProductID  DEFAULT ('') FOR ProductID;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_ProductDescription  DEFAULT ('') FOR ProductDescription;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_Lot  DEFAULT ('') FOR Lot;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_Quantity  DEFAULT ((0)) FOR Quantity;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_Unit  DEFAULT ('') FOR Unit;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_LoadedQuantity  DEFAULT ((0)) FOR LoadedQuantity;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_PalletQuantity  DEFAULT ((0)) FOR PalletQuantity;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_PalletUnit  DEFAULT ('') FOR PalletUnit;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_PalletLoadedQuantity  DEFAULT ((0)) FOR PalletLoadedQuantity;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_WarehouseOrigin  DEFAULT ('') FOR WarehouseOrigin;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_ErrorDescription  DEFAULT ('') FOR ErrorDescription;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_DocID  DEFAULT ('') FOR DocID;
			ALTER TABLE u_Kapps_LoadingLines ADD  CONSTRAINT DF_u_Kapps_LoadingLines_LineID  DEFAULT ('') FOR LineID;
			ALTER TABLE u_Kapps_LoadingLines ADD CONSTRAINT	PK_u_Kapps_LoadingLines PRIMARY KEY CLUSTERED 	(
				id
				) ON [PRIMARY]		
			CREATE NONCLUSTERED INDEX [IX_u_Kapps_LoadingLines_LoadNr] ON [dbo].[u_Kapps_LoadingLines] 
			(
				LoadNr ASC,
				DocID ASC,
				LineID ASC
			);

			ALTER TABLE u_Kapps_LoadingPallets ADD  CONSTRAINT DF_u_Kapps_LoadingPallets_LoadNr  DEFAULT (0) FOR LoadNr;
			ALTER TABLE u_Kapps_LoadingPallets ADD  CONSTRAINT DF_u_Kapps_LoadingPallets_SSCC  DEFAULT ('') FOR SSCC;


			CREATE TABLE u_Kapps_Numerators(
				LastPackID bigint NOT NULL,
				LastSSCC bigint NOT NULL
			);
			ALTER TABLE u_Kapps_Numerators ADD CONSTRAINT DF_u_Kapps_Numerators_LastPackID DEFAULT 0 FOR LastPackID;
			ALTER TABLE u_Kapps_Numerators ADD CONSTRAINT DF_u_Kapps_Numerators_LastSSCC DEFAULT 0 FOR LastSSCC;

		END

		IF (@DatabaseVersion < 84)
		BEGIN
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD DeliveryCustomer nvarchar(24) NOT NULL
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD DeliveryCode nvarchar(60) NOT NULL
			
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_DeliveryCustomer  DEFAULT ('') FOR DeliveryCustomer;
			ALTER TABLE u_Kapps_LoadingDeliveryPoints ADD  CONSTRAINT DF_u_Kapps_LoadingDeliveryPoints_DeliveryCode  DEFAULT ('') FOR DeliveryCode;
			
			ALTER TABLE u_Kapps_LoadingLines ADD OriLineNumber int NOT NULL DEFAULT (0);
		END

		IF (@DatabaseVersion < 85)
		BEGIN
			ALTER TABLE u_Kapps_DossierLin ADD LoadNr bigint DEFAULT (0);
			ALTER TABLE u_Kapps_StockLines ADD SSCC nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
		END
			
		IF (@DatabaseVersion < 86)
		BEGIN
			DROP TABLE u_Kapps_LoadingPallets;
			CREATE TABLE u_Kapps_LoadingPallets(
				LoadNr bigint NOT NULL,
				DocID nvarchar(50) NOT NULL,
				LineID nvarchar(50) NOT NULL,
				SSCC nvarchar(50) NOT NULL,
				Qty decimal(18, 3) NOT NULL,
				Unit nvarchar(25) NOT NULL
			);
			ALTER TABLE u_Kapps_LoadingPallets ADD  CONSTRAINT DF_u_Kapps_LoadingPallets_LoadNr  DEFAULT ((0)) FOR LoadNr;
			ALTER TABLE u_Kapps_LoadingPallets ADD  CONSTRAINT DF_u_Kapps_LoadingPallets_SSCC  DEFAULT ('') FOR SSCC;
			ALTER TABLE u_Kapps_LoadingPallets ADD  CONSTRAINT DF_u_Kapps_LoadingPallets_Qty  DEFAULT ((0)) FOR Qty;
			ALTER TABLE u_Kapps_LoadingPallets ADD  CONSTRAINT DF_u_Kapps_LoadingPallets_Unit  DEFAULT ('') FOR Unit;
		END

		IF (@DatabaseVersion < 87)
		BEGIN
			ALTER TABLE u_Kapps_LoadingHeader ADD DriverPhoneNumber nvarchar(20) NOT NULL DEFAULT ('') WITH VALUES;
			ALTER TABLE u_Kapps_LoadingHeader ADD DriverName nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
			
			CREATE TABLE u_Kapps_LoadingLog(
				LoadNr bigint NOT NULL,
				ErrorDate nvarchar(8) NOT NULL,
				ErrorTime nvarchar(6) NOT NULL,
				ErrorID int NOT NULL,
				ErrorDescription varchar(255) NOT NULL
			);
			ALTER TABLE u_Kapps_LoadingLog ADD  CONSTRAINT DF_u_Kapps_LoadingLog_LoadNr  DEFAULT ((0)) FOR LoadNr;
			ALTER TABLE u_Kapps_LoadingLog ADD  CONSTRAINT DF_u_Kapps_LoadingLog_ErrorDate  DEFAULT ('') FOR ErrorDate;
			ALTER TABLE u_Kapps_LoadingLog ADD  CONSTRAINT DF_u_Kapps_LoadingLog_ErrorTime  DEFAULT ('') FOR ErrorTime;
			ALTER TABLE u_Kapps_LoadingLog ADD  CONSTRAINT DF_u_Kapps_LoadingLog_ErrorID  DEFAULT ((0)) FOR ErrorID;
			ALTER TABLE u_Kapps_LoadingLog ADD  CONSTRAINT DF_u_Kapps_LoadingLog_ErrorDescription  DEFAULT ('') FOR ErrorDescription;
		END

		IF (@DatabaseVersion < 88)
		BEGIN
			ALTER TABLE u_Kapps_LoadingHeader ADD LoadType int NOT NULL DEFAULT (1) WITH VALUES;
		END

		IF (@DatabaseVersion < 89)
		BEGIN
			ALTER TABLE u_Kapps_LoadingLocations ADD UseAutomaticBarcode int NOT NULL DEFAULT (1) WITH VALUES;
		END

		IF (@DatabaseVersion < 90)
		BEGIN
			DELETE FROM u_Kapps_Parameters WHERE ParameterID='RFID_MODEL'
			
			EXECUTE ('UPDATE u_Kapps_InquiryQuestions SET InquiryQuestionMaxValue=COALESCE(InquiryQuestionMaxLength, InquiryQuestionMaxValue,0) WHERE InquiryQuestionType=''S''')
			ALTER TABLE u_Kapps_InquiryQuestions DROP COLUMN InquiryQuestionMaxLength;
			
			CREATE TABLE u_Kapps_ExpirationDates(
				id bigint IDENTITY(1,1) NOT NULL,
				EntityType nvarchar(50) NULL,
				EntityNumber nvarchar(50) NULL,
				Family nvarchar(50) NULL,
				Ref nvarchar(50) NULL,
				StoreInNrDays int NULL,
				StoreOutNrDays int NULL
			);

			ALTER TABLE u_Kapps_ExpirationDates ADD CONSTRAINT	PK_u_Kapps_ExpirationDates PRIMARY KEY CLUSTERED 	
			(
				id
			);

			ALTER TABLE u_Kapps_ExpirationDates ADD  CONSTRAINT DF_u_Kapps_ExpirationDates_EntityType  DEFAULT ('') FOR EntityType;
			ALTER TABLE u_Kapps_ExpirationDates ADD  CONSTRAINT DF_u_Kapps_ExpirationDates_EntityNumber  DEFAULT ('') FOR EntityNumber;
			ALTER TABLE u_Kapps_ExpirationDates ADD  CONSTRAINT DF_u_Kapps_ExpirationDates_Family DEFAULT ('') FOR Family;
			ALTER TABLE u_Kapps_ExpirationDates ADD  CONSTRAINT DF_u_Kapps_ExpirationDates_Ref  DEFAULT ('') FOR Ref;
			ALTER TABLE u_Kapps_ExpirationDates ADD  CONSTRAINT DF_u_Kapps_ExpirationDates_StoreInNrDays  DEFAULT ((0)) FOR StoreInNrDays;
			ALTER TABLE u_Kapps_ExpirationDates ADD  CONSTRAINT DF_u_Kapps_ExpirationDates_StoreOutNrDays  DEFAULT ((0)) FOR StoreOutNrDays;
			
			ALTER TABLE u_Kapps_DossierLin ADD CabUserField4 varchar(max), CabUserField5 varchar(max), CabUserField6 varchar(max), CabUserField7 varchar(max), CabUserField8 varchar(max), CabUserField9 varchar(max), CabUserField10 varchar(max);
			ALTER TABLE u_Kapps_DossierLin ADD LinUserField4 varchar(max), LinUserField5 varchar(max), LinUserField6 varchar(max), LinUserField7 varchar(max), LinUserField8 varchar(max), LinUserField9 varchar(max), LinUserField10 varchar(max);
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField4  DEFAULT ('') FOR CabUserField4;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField5  DEFAULT ('') FOR CabUserField5;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField6  DEFAULT ('') FOR CabUserField6;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField7  DEFAULT ('') FOR CabUserField7;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField8  DEFAULT ('') FOR CabUserField8;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField9  DEFAULT ('') FOR CabUserField9;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField10  DEFAULT ('') FOR CabUserField10;
			
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField4  DEFAULT ('') FOR LinUserField4;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField5  DEFAULT ('') FOR LinUserField5;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField6  DEFAULT ('') FOR LinUserField6;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField7  DEFAULT ('') FOR LinUserField7;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField8  DEFAULT ('') FOR LinUserField8;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField9  DEFAULT ('') FOR LinUserField9;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField10  DEFAULT ('') FOR LinUserField10;
	
			CREATE TABLE u_Kapps_Queries(
				QueryID int IDENTITY(1,1) NOT NULL,
				QueryDescription nvarchar(200) NOT NULL,
				QuerySQL varchar(4000) NOT NULL,
				Actif nvarchar(1) NOT NULL
			);
			ALTER TABLE u_Kapps_Queries ADD CONSTRAINT	PK_u_Kapps_Queries PRIMARY KEY CLUSTERED 	
			(
				QueryID
			);
		END

		IF (@DatabaseVersion < 91)
		BEGIN
			ALTER TABLE u_Kapps_ParametersMonitors ADD SQLDataType nvarchar(1) NULL;
			ALTER TABLE u_Kapps_ParametersMonitors ADD LastModified nvarchar(14) NULL;
		END

		IF (@DatabaseVersion < 92)
		BEGIN
			ALTER TABLE u_Kapps_ExpirationDates ADD Processes nvarchar(50) NULL;
			ALTER TABLE u_Kapps_ExpirationDates ADD NumberOfDays INT NULL;

			ALTER TABLE u_Kapps_ExpirationDates ADD  CONSTRAINT DF_u_Kapps_ExpirationDates_Processes  DEFAULT ('') FOR Processes;
			ALTER TABLE u_Kapps_ExpirationDates ADD  CONSTRAINT DF_u_Kapps_ExpirationDates_NumberOfDays  DEFAULT ((0)) FOR NumberOfDays;

			ALTER TABLE u_Kapps_ExpirationDates DROP CONSTRAINT DF_u_Kapps_ExpirationDates_StoreInNrDays
			ALTER TABLE u_Kapps_ExpirationDates DROP CONSTRAINT DF_u_Kapps_ExpirationDates_StoreOutNrDays
			ALTER TABLE u_Kapps_ExpirationDates DROP COLUMN StoreInNrDays
			ALTER TABLE u_Kapps_ExpirationDates DROP COLUMN StoreOutNrDays
		END

		IF (@DatabaseVersion < 93)
		BEGIN
			CREATE TABLE u_Kapps_DocStatus(
				CabKey nvarchar(50) NOT NULL,
				LineKey nvarchar(50) NOT NULL,
				Qty1 decimal(18, 3) NULL,
				Qty2 decimal(18, 3) NULL,
				Qty3 decimal(18, 3) NULL,
				Qty4 decimal(18, 3) NULL,
				Qty5 decimal(18, 3) NULL,
				Qty6 decimal(18, 3) NULL,
				Qty7 decimal(18, 3) NULL,
				Qty8 decimal(18, 3) NULL,
				Qty9 decimal(18, 3) NULL,
			 CONSTRAINT PK_u_Kapps_DocStatus PRIMARY KEY CLUSTERED 
			(
				CabKey ASC,
				LineKey ASC
			));
			
			ALTER TABLE u_Kapps_Labels ADD EntityNumber nvarchar(50) NULL CONSTRAINT DF_u_Kapps_Labels_EntityNumber  DEFAULT ('');
			ALTER TABLE u_Kapps_Labels ADD Ref nvarchar(60) NULL CONSTRAINT DF_u_Kapps_Labels_Ref  DEFAULT ('');
		END

		IF (@DatabaseVersion < 94)
		BEGIN
			ALTER TABLE u_Kapps_Labels ADD LabelImagePath nvarchar(200) NULL CONSTRAINT DF_u_Kapps_Labels_LabelImagePath DEFAULT ('');
			ALTER TABLE u_Kapps_ExpirationDates ALTER COLUMN Ref nvarchar(60);
		END
		
		IF (@DatabaseVersion < 95)
		BEGIN
			ALTER TABLE u_Kapps_UsersPermissions ALTER COLUMN UserID varchar(50);
		END
		
		IF (@DatabaseVersion < 96)
		BEGIN
			ALTER TABLE u_Kapps_Keywords ADD KeywordValue nvarchar(200) NULL;
		END

		IF (@DatabaseVersion < 97)
		BEGIN
			CREATE TABLE u_Kapps_ProductLabelingLines(
				id bigint IDENTITY(1,1) NOT NULL,
				InternalStamp nvarchar(50) NULL,
				MovDate nvarchar(8) NULL,
				MovTime nvarchar(6) NULL,
				TerminalID int NULL,
				Ref nvarchar(60) NULL,
				Description nvarchar(100) NULL,
				Qty decimal(18, 3) NULL,
				NetWeight decimal(18, 3) NULL,
				Lot nvarchar(50) NULL,
				ExpirationDate nvarchar(8) NULL,
				EntityNumber nvarchar(50) NULL,
				LabelID nvarchar(100) NULL,
			CONSTRAINT PK_u_Kapps_ProductLabelingLines PRIMARY KEY CLUSTERED 
			(
				id ASC
			)
			);

			CREATE TABLE u_Kapps_ProductLabelingRules(
				id bigint IDENTITY(1,1) NOT NULL,
				EntityNumber nvarchar(50) NULL,
				Ref nvarchar(60) NULL,
				LabelID nvarchar(100) NULL,
			CONSTRAINT PK_u_Kapps_ProductLabelingRules PRIMARY KEY CLUSTERED 
			(
				id ASC
			)
			);

			CREATE TABLE u_Kapps_Scales(
				ScaleID int NOT NULL,
				ScaleDescription nvarchar(300) NULL,
				SerialPort int NULL,
				BaudRate int NULL,
				DataBits int NULL,
				StopBits int NULL,
				Parity int NULL,
				Timeout int NULL,
				Tries int NULL,
			CONSTRAINT PK_u_Kapps_Scales PRIMARY KEY CLUSTERED 
			(
				ScaleID ASC
			)
			);
		END


		IF (@DatabaseVersion < 98)
		BEGIN
			ALTER TABLE u_Kapps_Scales ADD OperationMode int NULL;
			ALTER TABLE u_Kapps_Scales ADD ConnectionString nvarchar(100) NULL;
			ALTER TABLE u_Kapps_Scales ADD WeightStartPosition int NULL;
			ALTER TABLE u_Kapps_Scales ADD WeightLenth int NULL;

			ALTER TABLE u_Kapps_ProductLabelingLines ADD RecordType nvarchar(100) NULL;

			ALTER TABLE u_Kapps_Labels ALTER COLUMN LabelCode varchar(max)
		END
		
		IF (@DatabaseVersion < 99)
		BEGIN
			DROP TABLE u_Kapps_Scales
		END

		IF (@DatabaseVersion < 100)
		BEGIN
			ALTER TABLE u_Kapps_LoadingPallets ADD Lot nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
			ALTER TABLE u_Kapps_LoadingPallets ADD ExpirationDate nvarchar(8) NOT NULL DEFAULT ('') WITH VALUES;
			
			DROP INDEX IX_u_Kapps_LoadingLines_LoadNr ON u_kapps_loadingLines;
			ALTER TABLE u_Kapps_LoadingLines DROP CONSTRAINT DF_u_Kapps_LoadingLines_LoadNr;
			ALTER TABLE u_Kapps_LoadingLines ALTER COLUMN LoadNr bigint;
			ALTER TABLE u_Kapps_LoadingLines ADD CONSTRAINT DF_u_Kapps_LoadingLines_LoadNr DEFAULT( ( 0 ) ) FOR LoadNr;
			CREATE NONCLUSTERED INDEX IX_u_Kapps_LoadingLines_LoadNr ON u_Kapps_LoadingLines ( LoadNr, DocID, LineID) ON [PRIMARY];
			
			ALTER TABLE u_Kapps_Log DROP CONSTRAINT DF_u_Kapps_Log_LogDetail;
			ALTER TABLE u_Kapps_Log ALTER COLUMN LogDetail varchar(max);
			ALTER TABLE u_Kapps_Log ADD CONSTRAINT DF_u_Kapps_Log_LogDetail DEFAULT ('') FOR LogDetail;

			ALTER TABLE u_Kapps_Users ADD PasswordERP nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
			ALTER TABLE u_Kapps_Users ADD CONSTRAINT DF_u_Kapps_Users_UserERP DEFAULT( ('') ) FOR UserERP;
		END
	
		IF (@DatabaseVersion < 101)
		BEGIN
			ALTER TABLE u_Kapps_StockLines ADD StockStatus nvarchar(50) NOT NULL DEFAULT ('DISP') WITH VALUES;
		END
		
		IF (@DatabaseVersion < 102)
		BEGIN
			ALTER TABLE u_Kapps_ProductLabelingRules ADD LabelPackID nvarchar(100) NOT NULL DEFAULT ('') WITH VALUES;
			ALTER TABLE u_Kapps_ProductLabelingLines ADD TotalBoxes int NULL;
		END

		IF (@DatabaseVersion < 103)
		BEGIN
			ALTER TABLE u_Kapps_ProductLabelingRules ADD LabelPaleteID nvarchar(100) NOT NULL DEFAULT ('') WITH VALUES;

			ALTER TABLE dbo.u_Kapps_UsersPermissions ADD
				FunctionId varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_FunctionId DEFAULT (''),
				CreationUser varchar(20) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_CreationUser DEFAULT (''),
				CreationDate varchar(8) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_CreationDate DEFAULT (''),
				CreationTime varchar(6) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_CreationTime DEFAULT (''),
				CreationProcess varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_CreationProcess DEFAULT (''),
				CreationNetIPAddress varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_CreationNetIPAddress DEFAULT (''),
				CreationNetMachineName varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_CreationNetMachineName DEFAULT (''),
				ModificationUser varchar(20) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_ModificationUser DEFAULT (''),
				ModificationDate varchar(8) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_ModificationDate DEFAULT (''),
				ModificationTime varchar(6) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_ModificationTime DEFAULT (''),
				ModificationProcess varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_ModificationProcess DEFAULT (''),
				ModificationNetIPAddress varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_ModificationNetIPAddress DEFAULT (''),
				ModificationNetMachineName varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_UsersPermissions_ModificationNetMachineName DEFAULT ('');

			--ALTER TABLE dbo.u_Kapps_UsersPermissions SET (LOCK_ESCALATION = TABLE);

			ALTER TABLE dbo.u_Kapps_BO_Menu ADD
				FunctionId varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_FunctionId DEFAULT (''),
				FunctionType varchar(1) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_FunctionType DEFAULT (''),
				FunctionGroup varchar(100) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_FunctionGroup DEFAULT (''),
				Root varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_Root DEFAULT (''),
				Node01 varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_Node01 DEFAULT (''),
				Node02 varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_Node02 DEFAULT (''),
				Node03 varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_Node03 DEFAULT (''),
				Node04 varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_Node04 DEFAULT (''),
				Node05 varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_Node05 DEFAULT (''),
				Sequence int NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_Sequence DEFAULT ((0)),
				CreationUser varchar(20) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_CreationUser DEFAULT (''),
				CreationDate varchar(8) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_CreationDate DEFAULT (''),
				CreationTime varchar(6) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_CreationTime DEFAULT (''),
				CreationProcess varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_CreationProcess DEFAULT (''),
				CreationNetIPAddress varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_CreationNetIPAddress DEFAULT (''),
				CreationNetMachineName varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_CreationNetMachineName DEFAULT (''),
				ModificationUser varchar(20) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_ModificationUser DEFAULT (''),
				ModificationDate varchar(8) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_ModificationDate DEFAULT (''),
				ModificationTime varchar(6) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_ModificationTime DEFAULT (''),
				ModificationProcess varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_ModificationProcess DEFAULT (''),
				ModificationNetIPAddress varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_ModificationNetIPAddress DEFAULT (''),
				ModificationNetMachineName varchar(50) NOT NULL CONSTRAINT DF_u_Kapps_BO_Menu_ModificationNetMachineName DEFAULT ('');

			--ALTER TABLE dbo.u_Kapps_BO_Menu SET (LOCK_ESCALATION = TABLE);

			ALTER TABLE u_Kapps_BO_Menu ADD	IsDefault bit NOT NULL DEFAULT 0;
			ALTER TABLE u_Kapps_Queries ADD	Stamp varchar(20) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_Users ADD IsAdmin bit NOT NULL DEFAULT 0;
		END
		
		--IF (@DatabaseVersion < 104)
		--BEGIN
		--END
		
		IF (@DatabaseVersion < 105)
		BEGIN
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel13_Texto varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel13_Background varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel13_Foreground varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel13_FontFamily varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel13_FontSize varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel13_FontStyle varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel13_FontWeight varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel13_FontAligment varchar(50) NOT NULL DEFAULT ('');

			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel14_Texto varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel14_Background varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel14_Foreground varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel14_FontFamily varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel14_FontSize varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel14_FontStyle varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel14_FontWeight varchar(50) NOT NULL DEFAULT ('');
			ALTER TABLE u_Kapps_ParametersMonitors ADD Panel14_FontAligment varchar(50) NOT NULL DEFAULT ('');
		END

		IF (@DatabaseVersion < 106)
		BEGIN
			ALTER TABLE u_Kapps_Keywords ADD KeywordType varchar(10) NOT NULL DEFAULT ('');

			CREATE TABLE u_Kapps_QueriesDetails (
				id int NOT NULL,
				Keyword nvarchar(100) NULL,
				Description nvarchar(200) NULL
			);
		END

		IF (@DatabaseVersion < 107)
		BEGIN
			CREATE TABLE u_Kapps_InquiryAnswersDocGer(
				id int IDENTITY(1,1) NOT NULL,
				InquiryAnswersHeaderUniqueID nvarchar(100) NULL,
				StampDocGer nvarchar(50) NULL,
				KeyDocGer nvarchar(50) NULL
			);
		END

		IF (@DatabaseVersion < 108)
		BEGIN
			ALTER TABLE u_Kapps_Labels ADD LinesPerPage int NOT NULL CONSTRAINT DF_u_Kapps_Labels_LinesPerPage DEFAULT (0);
		END

		IF (@DatabaseVersion < 109)
		BEGIN
			ALTER TABLE u_Kapps_Users ALTER COLUMN PasswordERP nvarchar(200);
		END

		IF (@DatabaseVersion < 110)
		BEGIN
			CREATE TABLE u_Kapps_ParametersMonitorsPanel(
				id int IDENTITY(1,1) NOT NULL,
				ApplicationID nvarchar(50) NOT NULL,
				ConfigurationID int NOT NULL,
				ParameterID nvarchar(50) NOT NULL,
				ParameterValue nvarchar(MAX) NOT NULL
			)  ON [PRIMARY];

			CREATE TABLE u_Kapps_Reasons(
				ReasonID int IDENTITY(1,1) NOT NULL,
				ReasonDescription nvarchar(150) NOT NULL,
				ReasonType nvarchar(20) NOT NULL
			)  ON [PRIMARY];

			DECLARE @ObjectName NVARCHAR(100);
			SELECT @ObjectName = OBJECT_NAME([default_object_id]) FROM SYS.COLUMNS WHERE [object_id] = OBJECT_ID('u_Kapps_DossierLin') AND [name] = 'CabUserField1';
			IF @ObjectName IS NOT NULL
			BEGIN
				EXEC ('ALTER TABLE u_Kapps_DossierLin DROP CONSTRAINT ' + @ObjectName);
			END
			SELECT @ObjectName = OBJECT_NAME([default_object_id]) FROM SYS.COLUMNS WHERE [object_id] = OBJECT_ID('u_Kapps_DossierLin') AND [name] = 'CabUserField2';
			IF @ObjectName IS NOT NULL
			BEGIN
				EXEC ('ALTER TABLE u_Kapps_DossierLin DROP CONSTRAINT ' + @ObjectName);
			END
			SELECT @ObjectName = OBJECT_NAME([default_object_id]) FROM SYS.COLUMNS WHERE [object_id] = OBJECT_ID('u_Kapps_DossierLin') AND [name] = 'CabUserField3';
			IF @ObjectName IS NOT NULL
			BEGIN
				EXEC ('ALTER TABLE u_Kapps_DossierLin DROP CONSTRAINT ' + @ObjectName);
			END
			SELECT @ObjectName = OBJECT_NAME([default_object_id]) FROM SYS.COLUMNS WHERE [object_id] = OBJECT_ID('u_Kapps_DossierLin') AND [name] = 'LinUserField1';
			IF @ObjectName IS NOT NULL
			BEGIN
				EXEC ('ALTER TABLE u_Kapps_DossierLin DROP CONSTRAINT ' + @ObjectName);
			END
			SELECT @ObjectName = OBJECT_NAME([default_object_id]) FROM SYS.COLUMNS WHERE [object_id] = OBJECT_ID('u_Kapps_DossierLin') AND [name] = 'LinUserField2';
			IF @ObjectName IS NOT NULL
			BEGIN
				EXEC ('ALTER TABLE u_Kapps_DossierLin DROP CONSTRAINT ' + @ObjectName);
			END
			SELECT @ObjectName = OBJECT_NAME([default_object_id]) FROM SYS.COLUMNS WHERE [object_id] = OBJECT_ID('u_Kapps_DossierLin') AND [name] = 'LinUserField3';
			IF @ObjectName IS NOT NULL
			BEGIN
				EXEC ('ALTER TABLE u_Kapps_DossierLin DROP CONSTRAINT ' + @ObjectName);
			END

			ALTER TABLE u_Kapps_DossierLin ALTER COLUMN CabUserField1 varchar(max);
			ALTER TABLE u_Kapps_DossierLin ALTER COLUMN CabUserField2 varchar(max);
			ALTER TABLE u_Kapps_DossierLin ALTER COLUMN CabUserField3 varchar(max);
			ALTER TABLE u_Kapps_DossierLin ALTER COLUMN LinUserField1 varchar(max);
			ALTER TABLE u_Kapps_DossierLin ALTER COLUMN LinUserField2 varchar(max);
			ALTER TABLE u_Kapps_DossierLin ALTER COLUMN LinUserField3 varchar(max);
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField1  DEFAULT ('') FOR CabUserField1;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField2  DEFAULT ('') FOR CabUserField2;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_CabUserField3  DEFAULT ('') FOR CabUserField3;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField1  DEFAULT ('') FOR LinUserField1;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField2  DEFAULT ('') FOR LinUserField2;
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT DF_u_Kapps_DossierLin_LinUserField3  DEFAULT ('') FOR LinUserField3;
		END

		IF (@DatabaseVersion < 111)
		BEGIN
			CREATE TABLE u_Kapps_InquiryAnswersStampLin(
				id int IDENTITY(1,1) NOT NULL,
				InquiryAnswersHeaderUniqueID nvarchar(100) NULL,
				StampLin nvarchar(50) NULL
			);

			ALTER TABLE u_Kapps_InquiryAnswersHeader ADD ActiveWhen int NOT NULL CONSTRAINT DF_u_Kapps_InquiryAnswersHeader_ActiveWhen DEFAULT (0);
			ALTER TABLE u_Kapps_InquiryAnswersHeader ADD Ref nvarchar(60) NOT NULL CONSTRAINT DF_u_Kapps_InquiryAnswersHeader_Ref DEFAULT ('');
			ALTER TABLE u_Kapps_InquirySchedule ADD Ref nvarchar(60) NOT NULL CONSTRAINT DF_u_Kapps_InquirySchedule_Ref DEFAULT ('');
			ALTER TABLE u_Kapps_InquirySchedule ADD Family nvarchar(50) NOT NULL CONSTRAINT DF_u_Kapps_InquirySchedule_Family DEFAULT ('');
		END

		IF (@DatabaseVersion < 112)
		BEGIN
			CREATE TABLE u_Kapps_LogSP(
				LogDate nvarchar(8) NOT NULL,
				LogTime nvarchar(6) NOT NULL,
				LogErrorID int NOT NULL,
				LogDescription varchar(255) NOT NULL,
				LogSP varchar(100) NOT NULL,
				LogParameters varchar(255) NOT NULL
			) ON [PRIMARY];

			ALTER TABLE u_Kapps_LogSP ADD CONSTRAINT DF_u_Kapps_LogSP_LogDate DEFAULT ('') FOR LogDate;
			ALTER TABLE u_Kapps_LogSP ADD CONSTRAINT DF_u_Kapps_LogSP_LogTime DEFAULT ('') FOR LogTime;
			ALTER TABLE u_Kapps_LogSP ADD CONSTRAINT DF_u_Kapps_LogSP_LogErrorID DEFAULT ((0)) FOR LogErrorID;
			ALTER TABLE u_Kapps_LogSP ADD CONSTRAINT DF_u_Kapps_LogSP_LogDescription DEFAULT ('') FOR LogDescription;
			ALTER TABLE u_Kapps_LogSP ADD CONSTRAINT DF_u_Kapps_LogSP_LogSP DEFAULT ('') FOR LogSP;
			ALTER TABLE u_Kapps_LogSP ADD CONSTRAINT DF_u_Kapps_LogSP_LogParameters DEFAULT ('') FOR LogParameters;
		END

		IF (@DatabaseVersion < 113)
		BEGIN
			CREATE TABLE u_Kapps_NumeratorsSet(
				[AutoId] [int] IDENTITY(1,1) NOT NULL,
				[NumeratorId] [varchar](50) NOT NULL,
				[Description] [varchar](200) NOT NULL,
				[NumeratorSeries] [varchar](50) NOT NULL,
				[LastNumber] [numeric](18, 0) NOT NULL,
				[IsInactive] [tinyint] NOT NULL,
				[Locked] [tinyint] NOT NULL,
				[LockedUser] [varchar](20) NOT NULL,
				[LockedDate] [varchar](8) NOT NULL,
				[LockedTime] [varchar](6) NOT NULL,
				[Notes] [varchar](250) NOT NULL,
				[NumeratorStamp] [varchar](100) NOT NULL,
				[CreationNetIPAddress] [varchar](50) NOT NULL,
				[CreationNetMachineName] [varchar](50) NOT NULL,
				[CreationProcess] [varchar](50) NOT NULL,
				[CreationUser] [varchar](20) NOT NULL,
				[CreationDate] [varchar](8) NOT NULL,
				[CreationTime] [varchar](6) NOT NULL,
				[ModificationNetIPAddress] [varchar](50) NOT NULL,
				[ModificationNetMachineName] [varchar](50) NOT NULL,
				[ModificationProcess] [varchar](50) NOT NULL,
				[ModificationUser] [varchar](20) NOT NULL,
				[ModificationDate] [varchar](8) NOT NULL,
				[ModificationTime] [varchar](6) NOT NULL,
				 CONSTRAINT [PK_u_Kapps_NumeratorsSet] PRIMARY KEY CLUSTERED 
				(
					[AutoId] ASC
				) ON [PRIMARY]
				) ON [PRIMARY];
				
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_NumeratorId]  DEFAULT ('') FOR [NumeratorId];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_Description]  DEFAULT ('') FOR [Description];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_NumeratorSeries]  DEFAULT ('') FOR [NumeratorSeries];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_LastNumber]  DEFAULT ((0)) FOR [LastNumber];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_IsInactive]  DEFAULT ((0)) FOR [IsInactive];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_Locked]  DEFAULT ((0)) FOR [Locked];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_LockedUser]  DEFAULT ('') FOR [LockedUser];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_LockedDate]  DEFAULT ('') FOR [LockedDate];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_LockedTime]  DEFAULT ('') FOR [LockedTime];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_Notes]  DEFAULT ('') FOR [Notes];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_NumeratorStamp]  DEFAULT ('') FOR [NumeratorStamp];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_CreationNetIPAddress]  DEFAULT ('') FOR [CreationNetIPAddress];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_CreationNetMachineName]  DEFAULT ('') FOR [CreationNetMachineName];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_CreationProcess]  DEFAULT ('') FOR [CreationProcess];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_CreationUser]  DEFAULT ('') FOR [CreationUser];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_CreationDate]  DEFAULT ('') FOR [CreationDate];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_CreationTime]  DEFAULT ('') FOR [CreationTime];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_ModificationNetIPAddress]  DEFAULT ('') FOR [ModificationNetIPAddress];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_ModificationNetMachineName]  DEFAULT ('') FOR [ModificationNetMachineName];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_ModificationProcess]  DEFAULT ('') FOR [ModificationProcess];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_ModificationUser]  DEFAULT ('') FOR [ModificationUser];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_ModificationDate]  DEFAULT ('') FOR [ModificationDate];
			ALTER TABLE [dbo].[u_Kapps_NumeratorsSet] ADD  CONSTRAINT [DF_u_Kapps_NumeratorsSet_ModificationTime]  DEFAULT ('') FOR [ModificationTime];
			
			
			CREATE TABLE u_Kapps_tBOM_Header (
				[AutoId] [int] IDENTITY(1,1) NOT NULL,
				[BOMKey] [varchar](25) NOT NULL,
				[Number] [numeric](10, 0) NOT NULL,
				[CustomerName] [varchar](255) NOT NULL,
				[Date] [datetime] NOT NULL,
				[Customer] [varchar](101) NOT NULL,
				[Document] [numeric](3, 0) NOT NULL,
				[DocumentName] [varchar](200) NOT NULL,
				[UserCol1] [varchar](max) NOT NULL,
				[UserCol2] [varchar](max) NOT NULL,
				[UserCol3] [varchar](max) NOT NULL,
				[UserCol4] [varchar](max) NOT NULL,
				[UserCol5] [varchar](max) NOT NULL,
				[UserCol6] [varchar](max) NOT NULL,
				[UserCol7] [varchar](max) NOT NULL,
				[UserCol8] [varchar](max) NOT NULL,
				[UserCol9] [varchar](max) NOT NULL,
				[UserCol10] [varchar](max) NOT NULL,
				[EXR] [varchar](50) NOT NULL,
				[SEC] [varchar](50) NOT NULL,
				[TPD] [varchar](50) NOT NULL,
				[NDC] [numeric](10, 0) NOT NULL,
				[Filter1] [varchar](max) NOT NULL,
				[Filter2] [varchar](max) NOT NULL,
				[Filter3] [varchar](max) NOT NULL,
				[Filter4] [varchar](max) NOT NULL,
				[Filter5] [varchar](max) NOT NULL,
				[DeliveryCustomer] [varchar](101) NOT NULL,
				[DeliveryCode] [varchar](60) NOT NULL,
				[barcode] [varchar](255) NOT NULL,
				[CreationNetIPAddress] [varchar](50) NOT NULL,
				[CreationNetMachineName] [varchar](50) NOT NULL,
				[CreationProcess] [varchar](50) NOT NULL,
				[CreationUser] [varchar](20) NOT NULL,
				[CreationDate] [varchar](8) NOT NULL,
				[CreationTime] [varchar](6) NOT NULL,
				[ModificationProcess] [varchar](50) NOT NULL,
				[ModificationUser] [varchar](20) NOT NULL,
				[ModificationDate] [varchar](8) NOT NULL,
				[ModificationTime] [varchar](6) NOT NULL,
				[ModificationNetIPAddress] [varchar](50) NOT NULL,
				[ModificationNetMachineName] [varchar](50) NOT NULL,
				[Status] [tinyint] NOT NULL,
				 CONSTRAINT [PK_u_Kapps_tBOM_Header] PRIMARY KEY CLUSTERED 
				(
					[AutoId] ASC
				) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_BOMKey]  DEFAULT ('') FOR [BOMKey];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Number]  DEFAULT ((0)) FOR [Number];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_CustomerName]  DEFAULT ('') FOR [CustomerName];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Date]  DEFAULT ('') FOR [Date];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Customer]  DEFAULT ('') FOR [Customer];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Document]  DEFAULT ((0)) FOR [Document];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_DocumentName]  DEFAULT ('') FOR [DocumentName];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol1]  DEFAULT ('') FOR [UserCol1];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol2]  DEFAULT ('') FOR [UserCol2];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol3]  DEFAULT ('') FOR [UserCol3];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol4]  DEFAULT ('') FOR [UserCol4];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol5]  DEFAULT ('') FOR [UserCol5];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol6]  DEFAULT ('') FOR [UserCol6];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol7]  DEFAULT ('') FOR [UserCol7];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol8]  DEFAULT ('') FOR [UserCol8];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol9]  DEFAULT ('') FOR [UserCol9];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_UserCol10]  DEFAULT ('') FOR [UserCol10];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_EXR]  DEFAULT ('') FOR [EXR];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_SEC]  DEFAULT ('') FOR [SEC];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_TPD]  DEFAULT ('') FOR [TPD];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_NDC]  DEFAULT ((0)) FOR [NDC];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Filter1]  DEFAULT ('') FOR [Filter1];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Filter2]  DEFAULT ('') FOR [Filter2];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Filter3]  DEFAULT ('') FOR [Filter3];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Filter4]  DEFAULT ('') FOR [Filter4];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_Filter5]  DEFAULT ('') FOR [Filter5];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_DeliveryCustomer]  DEFAULT ('') FOR [DeliveryCustomer];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_DeliveryCode]  DEFAULT ('') FOR [DeliveryCode];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_barcode]  DEFAULT ('') FOR [barcode];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_CreationNetIPAddress]  DEFAULT ('') FOR [CreationNetIPAddress];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_CreationNetMachineName]  DEFAULT ('') FOR [CreationNetMachineName];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_CreationProcess]  DEFAULT ('') FOR [CreationProcess];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_CreationUser]  DEFAULT ('') FOR [CreationUser];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_CreationDate]  DEFAULT ('') FOR [CreationDate];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_CreationTime]  DEFAULT ('') FOR [CreationTime];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_ModificationProcess]  DEFAULT ('') FOR [ModificationProcess];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_ModificationUser]  DEFAULT ('') FOR [ModificationUser];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_ModificationDate]  DEFAULT ('') FOR [ModificationDate];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_ModificationTime]  DEFAULT ('') FOR [ModificationTime];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_ModificationNetIPAddress]  DEFAULT ('') FOR [ModificationNetIPAddress];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_ModificationNetMachineName]  DEFAULT ('') FOR [ModificationNetMachineName];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Header] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Header_IsFinalProductBOM]  DEFAULT ((0)) FOR [Status];
			
			
			CREATE TABLE u_Kapps_tBOM_Items (
				[AutoId] [int] IDENTITY(1,1) NOT NULL,
				[BOMItemsKey] [char](25) NOT NULL,
				[Article] [char](100) NOT NULL,
				[Description] [varchar](200) NOT NULL,
				[Quantity] [numeric](14, 4) NOT NULL,
				[QuantitySatisfied] [numeric](14, 4) NOT NULL,
				[QuantityPending] [numeric](38, 3) NOT NULL,
				[QuantityPicked] [decimal](38, 3) NOT NULL,
				[BaseUnit] [varchar](25) NOT NULL,
				[BusyUnit] [varchar](25) NOT NULL,
				[ConversionFator] [int] NOT NULL,
				[Warehouse] [varchar](50) NOT NULL,
				[BOMKey] [char](25) NOT NULL,
				[OriginalLineNumber] [numeric](10, 0) NOT NULL,
				[UserCol1] [varchar](max) NOT NULL,
				[UserCol2] [varchar](max) NOT NULL,
				[UserCol3] [varchar](max) NOT NULL,
				[UserCol4] [varchar](max) NOT NULL,
				[UserCol5] [varchar](max) NOT NULL,
				[UserCol6] [varchar](max) NOT NULL,
				[UserCol7] [varchar](max) NOT NULL,
				[UserCol8] [varchar](max) NOT NULL,
				[UserCol9] [varchar](max) NOT NULL,
				[UserCol10] [varchar](max) NOT NULL,
				[EXR] [varchar](50) NOT NULL,
				[SEC] [varchar](50) NOT NULL,
				[TPD] [varchar](50) NOT NULL,
				[NDC] [numeric](10, 0) NOT NULL,
				[Filter1] [varchar](max) NOT NULL,
				[Filter2] [varchar](max) NOT NULL,
				[Filter3] [varchar](max) NOT NULL,
				[Filter4] [varchar](max) NOT NULL,
				[Filter5] [varchar](max) NOT NULL,
				[Location] [varchar](max) NOT NULL,
				[Lot] [varchar](100) NOT NULL,
				[PalletType] [varchar](1) NOT NULL,
				[PalletMaxUnits] [int] NOT NULL,
				[IsComponent] [bit] NOT NULL,
				[Sequence] [int] NOT NULL,
				[Replaceable] [bit] NOT NULL,
				[Tolerance] [int] NOT NULL,
				[CreationNetIPAddress] [varchar](50) NOT NULL,
				[CreationNetMachineName] [varchar](50) NOT NULL,
				[CreationProcess] [varchar](50) NOT NULL,
				[CreationUser] [varchar](20) NOT NULL,
				[CreationDate] [varchar](8) NOT NULL,
				[CreationTime] [varchar](6) NOT NULL,
				[ModificationProcess] [varchar](50) NOT NULL,
				[ModificationUser] [varchar](20) NOT NULL,
				[ModificationDate] [varchar](8) NOT NULL,
				[ModificationTime] [varchar](6) NOT NULL,
				[ModificationNetIPAddress] [varchar](50) NOT NULL,
				[ModificationNetMachineName] [varchar](50) NOT NULL,
				[Status] [tinyint] NOT NULL,
				CONSTRAINT [PK_u_Kapps_tBOM_Items] PRIMARY KEY CLUSTERED 
				(
					[AutoId] ASC
				) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_BOMItemsKey]  DEFAULT ('') FOR [BOMItemsKey];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Article]  DEFAULT ('') FOR [Article];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Description]  DEFAULT ('') FOR [Description];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Quantity]  DEFAULT ((0)) FOR [Quantity];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_QuantitySatisfied]  DEFAULT ((0)) FOR [QuantitySatisfied];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_QuantityPending]  DEFAULT ((0)) FOR [QuantityPending];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_QuantityPicked]  DEFAULT ((0)) FOR [QuantityPicked];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_BaseUnit]  DEFAULT ('') FOR [BaseUnit];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_BusyUnit]  DEFAULT ('') FOR [BusyUnit];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_ConversionFator]  DEFAULT ((0)) FOR [ConversionFator];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Warehouse]  DEFAULT ((0)) FOR [Warehouse];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_BOMKey]  DEFAULT ('') FOR [BOMKey];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_OriginalLineNumber]  DEFAULT ((0)) FOR [OriginalLineNumber];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol1]  DEFAULT ('') FOR [UserCol1];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol2]  DEFAULT ('') FOR [UserCol2];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol3]  DEFAULT ('') FOR [UserCol3];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol4]  DEFAULT ('') FOR [UserCol4];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol5]  DEFAULT ('') FOR [UserCol5];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol6]  DEFAULT ('') FOR [UserCol6];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol7]  DEFAULT ('') FOR [UserCol7];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol8]  DEFAULT ('') FOR [UserCol8];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol9]  DEFAULT ('') FOR [UserCol9];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_UserCol10]  DEFAULT ('') FOR [UserCol10];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_EXR]  DEFAULT ('') FOR [EXR];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_SEC]  DEFAULT ('') FOR [SEC];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_TPD]  DEFAULT ('') FOR [TPD];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_NDC]  DEFAULT ((0)) FOR [NDC];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Filter1]  DEFAULT ('') FOR [Filter1];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Filter2]  DEFAULT ('') FOR [Filter2];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Filter3]  DEFAULT ('') FOR [Filter3];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Filter4]  DEFAULT ('') FOR [Filter4];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Filter5]  DEFAULT ('') FOR [Filter5];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Location]  DEFAULT ('') FOR [Location];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Lot]  DEFAULT ('') FOR [Lot];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_PalletType]  DEFAULT ('') FOR [PalletType];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_PalletMaxUnits]  DEFAULT ((0)) FOR [PalletMaxUnits];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_IsComponent]  DEFAULT ((0)) FOR [IsComponent];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Sequence]  DEFAULT ((0)) FOR [Sequence];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Replaceable]  DEFAULT ((0)) FOR [Replaceable];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Tolerance]  DEFAULT ((0)) FOR [Tolerance];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_CreationNetIPAddress]  DEFAULT ('') FOR [CreationNetIPAddress];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_CreationNetMachineName]  DEFAULT ('') FOR [CreationNetMachineName];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_CreationProcess]  DEFAULT ('') FOR [CreationProcess];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_CreationUser]  DEFAULT ('') FOR [CreationUser];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_CreationDate]  DEFAULT ('') FOR [CreationDate];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_CreationTime]  DEFAULT ('') FOR [CreationTime];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_ModificationProcess]  DEFAULT ('') FOR [ModificationProcess];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_ModificationUser]  DEFAULT ('') FOR [ModificationUser];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_ModificationDate]  DEFAULT ('') FOR [ModificationDate];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_ModificationTime]  DEFAULT ('') FOR [ModificationTime];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_ModificationNetIPAddress]  DEFAULT ('') FOR [ModificationNetIPAddress];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_ModificationNetMachineName]  DEFAULT ('') FOR [ModificationNetMachineName];
			ALTER TABLE [dbo].[u_Kapps_tBOM_Items] ADD  CONSTRAINT [DF_u_Kapps_tBOM_Items_Status]  DEFAULT ((0)) FOR [Status];
			
			ALTER TABLE dbo.u_Kapps_DossierLin ADD IsFinalProductBOM bit NOT NULL CONSTRAINT DF_u_Kapps_DossierLin_IsFinalProductBOM DEFAULT ((0));
			
		END

		IF (@DatabaseVersion < 114)
		BEGIN
			ALTER TABLE u_Kapps_DossierLin ADD CabUserField11 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_CabUserField11 DEFAULT ('');
			ALTER TABLE u_Kapps_DossierLin ADD CabUserField12 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_CabUserField12 DEFAULT ('');
			ALTER TABLE u_Kapps_DossierLin ADD CabUserField13 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_CabUserField13 DEFAULT ('');
			ALTER TABLE u_Kapps_DossierLin ADD CabUserField14 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_CabUserField14 DEFAULT ('');
			ALTER TABLE u_Kapps_DossierLin ADD CabUserField15 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_CabUserField15 DEFAULT ('');

			ALTER TABLE u_Kapps_DossierLin ADD LinUserField11 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_LinUserField11 DEFAULT ('');
			ALTER TABLE u_Kapps_DossierLin ADD LinUserField12 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_LinUserField12 DEFAULT ('');
			ALTER TABLE u_Kapps_DossierLin ADD LinUserField13 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_LinUserField13 DEFAULT ('');
			ALTER TABLE u_Kapps_DossierLin ADD LinUserField14 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_LinUserField14 DEFAULT ('');
			ALTER TABLE u_Kapps_DossierLin ADD LinUserField15 varchar(max) CONSTRAINT DF_u_Kapps_DossierLin_LinUserField15 DEFAULT ('');
		END

		IF (@DatabaseVersion < 115)
		BEGIN
			ALTER TABLE u_Kapps_Numerators ADD LastLoadNr bigint CONSTRAINT DF_u_Kapps_Numerators_LastLoadNr DEFAULT ('0');
			ALTER TABLE u_Kapps_LoadingHeader ADD ProcessID varchar(25) CONSTRAINT DF_u_Kapps_LoadingHeader_ProcessID DEFAULT ('');
			ALTER TABLE u_Kapps_LoadingHeader ADD ProcessType varchar(25) CONSTRAINT DF_u_Kapps_LoadingHeader_ProcessType DEFAULT ('');
			ALTER TABLE u_Kapps_LoadingPallets ADD ProductID nvarchar(50) not null CONSTRAINT DF_u_Kapps_LoadingPallets_ProductID DEFAULT ('');
		END


		--
		-- Actualizar DATABASEVERSION
		--
		SET @ThisScriptVersion = 115

		IF (@ThisScriptVersion <> @BackDBVersion)
		BEGIN
			SET @ErrorMessage = 'A versão dos scripts da base de dados (' + CAST(@ThisScriptVersion as varchar(5))  + ') não corresponde com a versão do backoffice ('+ CAST(@BackDBVersion as varchar(5))+')';
			RAISERROR (@ErrorMessage, 16, 1);
		END

		UPDATE u_Kapps_Parameters SET ParameterValue = @BackDBVersion WHERE UPPER(AppCode) = 'SYT' AND ParameterGroup='MAIN' and UPPER(ParameterID) = UPPER('DATABASEVERSION');

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
	SET XACT_ABORT OFF
	SELECT @estado, @descerro
END
