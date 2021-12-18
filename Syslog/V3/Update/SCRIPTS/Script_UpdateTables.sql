CREATE PROCEDURE [SP_u_Kapps_UpdateBackoffice]
      @BackDBVersion INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @STATE INT
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @DatabaseVersion INT
	DECLARE @DatabaseVersionScript INT
	DECLARE @NrTerminalAtual INT

	DECLARE @estado varchar(5)
    DECLARE @descerro varchar(255)
	DECLARE @APPCODE varchar(6)
	DECLARE @SQL nvarchar(1000)

	BEGIN TRY
	BEGIN TRANSACTION

	SET @estado = 'ERROR'
    SET @descerro = 'Ocorreu um erro ao atualizar a base de dados. '
	SET @DatabaseVersion = 0
	SET @APPCODE='AP0002'

	--Vai buscar a versão da base de dados e compara com a versão da base de dados desta versão do backoffice
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Parameters') AND type in (N'U'))
		SELECT @DatabaseVersion = ISNULL(ParameterValue, 0) FROM u_Kapps_Parameters (NOLOCK) WHERE (UPPER(AppCode) = @APPCODE OR UPPER(AppCode)='SYT') AND ParameterGroup='MAIN' AND UPPER(ParameterID) = UPPER('DATABASEVERSION')
	ELSE
		SELECT @DatabaseVersion = ISNULL(ParameterValue, 0) FROM Kapps_Parameters (NOLOCK) WHERE UPPER(AppCode) = @APPCODE AND UPPER(ParameterID) = UPPER('DATABASEVERSION')	

	IF ((@DatabaseVersion = null) OR (@DatabaseVersion <= 0))
	BEGIN
		SET @DatabaseVersion = 0
	END
	IF (@DatabaseVersion < 47)	
	BEGIN
		RAISERROR('Actualize a APP Logistica para a v47 antes actualizar para o SYSLOG', 16, 1)
	END

	IF (@DatabaseVersion < @BackDBVersion)
	BEGIN
		
		IF (@DatabaseVersion < 48)
		BEGIN
			CREATE TABLE u_Kapps_Parameters(
					[id] [int] IDENTITY(1,1) NOT NULL,
					[AppCode] [nvarchar](50) NOT NULL,
					[ParameterType] [nvarchar](50) NOT NULL,
					[ParameterGroup] [nvarchar](100) NOT NULL,
					[ParameterOrder] [numeric](18, 0) NULL,
					[ParameterID] [nvarchar](50) NOT NULL,
					[ParameterDescription] [nvarchar](100) NULL,
					[ParameterValue] [nvarchar](4000) NULL,
					[ParameterDefaultValue] [nvarchar](4000) NULL,
					[ParameterInfo] [nvarchar](4000) NULL,
					[ParameterRequired] [nvarchar](1) NULL,
					[ParameterDependent] [nvarchar](50) NULL,
					[ParameterERP] [nvarchar](200) NULL,
				 CONSTRAINT [PK_u_Kapps_Parameters] PRIMARY KEY CLUSTERED 
				(
					[AppCode] ASC,
					[ParameterType] ASC,
					[ParameterGroup] ASC,
					[ParameterID] ASC
				) ON [PRIMARY]
				) ON [PRIMARY]
			ALTER TABLE u_Kapps_Parameters ADD  CONSTRAINT [DF_u_Kapps_Parameters_ParameterERP]  DEFAULT ('') FOR [ParameterERP]

			CREATE TABLE [u_Kapps_ParametersTypes](
				[TypeID] [varchar](25) NOT NULL,
				[Name] [varchar](100) NULL,
				[IsParameter] [int] NOT NULL,
				[TypeOrder] [int] NOT NULL,
				[DefaultDescription] [varchar](1000) NOT NULL,
			 CONSTRAINT [PK_u_Kapps_ParametersTypes] PRIMARY KEY CLUSTERED 
			(
				[TypeID] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]

			ALTER TABLE u_Kapps_ParametersTypes ADD  CONSTRAINT [DF_u_Kapps_ParametersTypes_IsParameter]  DEFAULT ((0)) FOR [IsParameter]
			ALTER TABLE u_Kapps_ParametersTypes ADD  CONSTRAINT [DF_u_Kapps_ParametersTypes_DefaultDescription]  DEFAULT ('') FOR [DefaultDescription]

			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'MAIN', N'Parâmetros Gerais', 0, 0, '')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'EXT', N'Extensibilidade', 0, 1, '')

			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'GENERAL', N'Gerais', 1, 1, '')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'EAN128', N'Códigos de Barras', 1, 2, '')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'LOTES', N'Lotes', 1, 3, '')

			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'STORE IN', N'Receção', 2, 1, 'Entrada de mercadoria')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'PICKING', N'Picking', 2, 2, 'Contagem de material a preparar para expedição')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'PACKING', N'Packing', 2, 3, 'Empacotamento do material')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'INSPECTION', N'Contagens', 2, 4, 'Contagens')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'OTHERS', N'Outros Documentos', 2, 5, 'Registo de quebras, etc...')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'TRANSF', N'Transferências', 2, 6, 'Transferências entre armazéns')
			
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'PRICECHECKING', N'Preços', 2, 7, '')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'STOCKS', N'Stock Arm.', 2, 8, '')
			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'QUERIES', N'Consultas', 2, 9, '')


			INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES (N'USR', N'USR', 3, 1, '')


			CREATE TABLE [u_Kapps_Processes](
				[id] [int] IDENTITY(1,1) NOT NULL,
				[ProcessID] [varchar](25) NOT NULL,
				[TypeID] [varchar](25) NULL,
				[Name] [varchar](100) NULL,
				[Description] [varchar](1000) NULL,
				[ProcessOrder] [int] NOT NULL,
			 CONSTRAINT [PK_u_Kapps_Processes_1] PRIMARY KEY CLUSTERED 
			(
				[id] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]		
			ALTER TABLE [u_Kapps_Processes] ADD  CONSTRAINT [DF_u_Kapps_Processes_ProcessOrder]  DEFAULT ((0)) FOR [ProcessOrder]


			CREATE TABLE [u_Kapps_UsersProcesses](
				[Username] [varchar](50) NOT NULL,
				[ProcessID] [varchar](25) NOT NULL,
			 CONSTRAINT [PK_u_Kapps_UsersProcesses] PRIMARY KEY CLUSTERED 
			(
				[Username] ASC,
				[ProcessID] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]

			CREATE TABLE [u_Kapps_UsersWarehouses](
				[Username] [varchar](50) NOT NULL,
				[Warehouse] [varchar](50) NOT NULL,
			 CONSTRAINT [PK_u_Kapps_UsersWarehouses] PRIMARY KEY CLUSTERED 
			(
				[Username] ASC,
				[Warehouse] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]


			
			UPDATE Kapps_Parameters SET ParameterID='SECCAO' WHERE ParameterID='Secção';
			

			SET IDENTITY_INSERT u_Kapps_Parameters ON
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (4, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'BD_Empresas', N'', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (3, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'BD_Sistema', N'', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (5, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'Driver_Path', N'', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (1, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'ERP', N'', N'Phc', N'PHC', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (6, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'UPDATE', N'', N'', N'1', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (7, @APPCODE, N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'DATABASEVERSION', N'DATABASE VERSION', N'34', N'0', N'', N'0', N'', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (8, @APPCODE, N'MAIN', N'MAIN', CAST(2 AS Numeric(18, 0)), N'SCRIPTSVERSION', N'SCRIPTS VERSION', N'0', N'0', N'', N'0', N'', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (15, @APPCODE, N'EAN128', N'EAN128', CAST(6 AS Numeric(18, 0)), N'AILOTE', N'AI do EAN128 para o lote', N'10', N'10', N'Ver lista na pasta documentation', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (17, @APPCODE, N'EAN128', N'EAN128', CAST(8 AS Numeric(18, 0)), N'AINUMEROSERIE', N'AI do EAN128 para o número de série', N'21', N'21', N'Ver lista na pasta documentation', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (18, @APPCODE, N'EAN128', N'EAN128', CAST(9 AS Numeric(18, 0)), N'AIQUANTIDADE', N'AI do EAN128 para a quantidade', N'37', N'37', N'Ver lista na pasta documentation', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (14, @APPCODE, N'EAN128', N'EAN128', CAST(5 AS Numeric(18, 0)), N'AIREFERENCIA', N'AI do EAN128 para a referência/código de barras', N'01', N'01', N'Ver lista na pasta documentation', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (16, @APPCODE, N'EAN128', N'EAN128', CAST(7 AS Numeric(18, 0)), N'AIVALIDADELOTE', N'AI do EAN128 para a validade do lote', N'17', N'17', N'Ver lista na pasta documentation', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (20, @APPCODE, N'EAN128', N'EAN128', CAST(11 AS Numeric(18, 0)), N'EAN1128_LOCKLOTE', N'Deixa alterar o lote quando vem de um EAN128', N'S', N'S', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (12, @APPCODE, N'EAN128', N'EAN128', CAST(3 AS Numeric(18, 0)), N'EAN13_LEGHT', N'Numero de caracteres do EAN13', N'12', N'12', N'Número de carateres do código de barras EAN13 lido pelo leitor', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (19, @APPCODE, N'EAN128', N'EAN128', CAST(10 AS Numeric(18, 0)), N'EAN13VALID', N'EAN13 válidos (para preço)', N'28,29', N'28,29', N'Tipos de EAN13 separados por vírgula ex.(28,29)', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (11, @APPCODE, N'EAN128', N'EAN128', CAST(3 AS Numeric(18, 0)), N'MIN_LEGHT', N'Numero de caracteres necessários para ser considerado EAN128', N'', N'', N'Ao ler um código de barras superior ao valor inserido considera como EAN 128', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (10, @APPCODE, N'EAN128', N'EAN128', CAST(2 AS Numeric(18, 0)), N'PREFIX', N'Usa Prefixo?', N'', N'0', N'0-não / 1-sim', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (9, @APPCODE, N'EAN128', N'EAN128', CAST(1 AS Numeric(18, 0)), N'USEEAN128', N'Usa EAN128?', N'', N'0', N'0-não / 1-sim', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (13, @APPCODE, N'EAN128', N'EAN128', CAST(4 AS Numeric(18, 0)), N'USEEAN13', N'Usa EAN13?', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (25, @APPCODE, N'DEFAULT', N'USR', CAST(5 AS Numeric(18, 0)), N'MOEDA', N'Código da moeda default na integração com (Sage 100C / Sendys)', N'', N'', N'', N'0', N'0', N'Sage_100C;Sendys;')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (21, @APPCODE, N'DEFAULT', N'USR', CAST(1 AS Numeric(18, 0)), N'ProductReplacement', N'Subsituir referencias?', N'', N'', N'0-não / 1-sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (27, @APPCODE, N'DEFAULT', N'USR', CAST(7 AS Numeric(18, 0)), N'REGIME_IVA', N'Regime de Iva (Sage 100C / Sendys)', N'', N'', N'', N'0', N'0', N'Sage_100C;Sendys;')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (23, @APPCODE, N'DEFAULT', N'USR', CAST(3 AS Numeric(18, 0)), N'RESERVA_QUANTIDADES', N'Reserva quantidades em Primavera', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'primavera;')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (22, @APPCODE, N'DEFAULT', N'USR', CAST(2 AS Numeric(18, 0)), N'SECCAO', N'Secção para Eticadata/Serie para primavera,Sage100C e Sendys', N'', N'', N'0', N'0', N'0', N'Eticadata_16/17/18/19;primavera;Sage_100C;Sendys;')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (24, @APPCODE, N'DEFAULT', N'USR', CAST(4 AS Numeric(18, 0)), N'SETOR', N'Código do setor default na integração com Sage 100C', N'', N'', N'', N'0', N'0', N'Sage_100C;')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (26, @APPCODE, N'DEFAULT', N'USR', CAST(6 AS Numeric(18, 0)), N'TIPO_DOC_INVENTARIO', N'Código do documento de inventário', N'INV', N'INV', N'', N'0', N'0', N'')
			
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (33, @APPCODE, N'GENERAL', N'GENERAL', CAST(98 AS Numeric(18, 0)), N'ADDBARCODE', N'Criar e Associar código de barras inexistente a produto?', N'', N'', N'0-não / 1-sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (32, @APPCODE, N'GENERAL', N'GENERAL', CAST(4 AS Numeric(18, 0)), N'ARTICLE_FILTER', N'Filtro de artigos (stored procedure "SP_u_Kapps_Products")', N'', N'', N'and ? tabela.campo = xpto', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (31, @APPCODE, N'GENERAL', N'GENERAL', CAST(3 AS Numeric(18, 0)), N'ARTICLE_FILTER_APP', N'Filtro de artigos (Pesquisa de artigos)', N'', N'', N'and ? tabela.campo = xpto', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (37, @APPCODE, N'GENERAL', N'GENERAL', CAST(102 AS Numeric(18, 0)), N'MORE_LINES_SAME_PRODUCT', N'Permite inserir novas linhas de produtos existentes no documento de origem', N'', N'', N'Permite inserir novas linhas de produtos existentes no documento de origem', N'0', N'100', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (30, @APPCODE, N'GENERAL', N'GENERAL', CAST(3 AS Numeric(18, 0)), N'MULTI_USERS', N'Vários utilizadores para o mesmo documento', N'', N'0', N'0-não / 1-sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (29, @APPCODE, N'GENERAL', N'GENERAL', CAST(2 AS Numeric(18, 0)), N'NEW_PRD', N'Adicionar novo produto?', N'', N'0', N'0-não / 1-sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (35, @APPCODE, N'GENERAL', N'GENERAL', CAST(100 AS Numeric(18, 0)), N'QTY_CTRL', N'Aceita quantidades superiores ao documento de origem. Valores:0,1,2', N'0', N'0', N'0-não / 1-sim com mensagem a avisar / 2- sim sem mensagem a avisar', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (36, @APPCODE, N'GENERAL', N'GENERAL', CAST(101 AS Numeric(18, 0)), N'REPRINT_LABEL', N'Permite a reimpressão de etiquetas', N'0', N'0', N'0-não / 1-sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (28, @APPCODE, N'GENERAL', N'GENERAL', CAST(1 AS Numeric(18, 0)), N'STOCK_CTRL', N'Aceita stock negativo.', N'0', N'0', N'0-não / 1-sim com mensagem a avisar / 2- sim sem mensagem a avisar', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (38, @APPCODE, N'GENERAL', N'GENERAL', CAST(103 AS Numeric(18, 0)), N'USER_PIN', N'Utilizadores necessitem de PIN code para efetuar login', N'0', N'0', N'1-Necessita / 0-Não necessita', N'0', N'100', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (34, @APPCODE, N'GENERAL', N'GENERAL', CAST(99 AS Numeric(18, 0)), N'WAREHOUSE', N'Armazém por defeito', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (39, @APPCODE, N'DEFAULT', N'INSPECTION', CAST(1 AS Numeric(18, 0)), N'DEF_QTY', N'Quantidade por defeito para contagem', N'', N'1', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (41, @APPCODE, N'DEFAULT', N'INSPECTION', CAST(3 AS Numeric(18, 0)), N'INCREMENT', N'Incrementa a quantidade do artigo lido', N'1', N'1', N'1-Sim / 0-Não  (Considera-se para tal o mesmo artigo, armazém e lote)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (40, @APPCODE, N'DEFAULT', N'INSPECTION', CAST(2 AS Numeric(18, 0)), N'INV_CNT', N'Contador por defeito', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (42, @APPCODE, N'DEFAULT', N'INSPECTION', CAST(4 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (43, @APPCODE, N'DEFAULT', N'INSPECTION', CAST(5 AS Numeric(18, 0)), N'SHOW_STOCK', N'Mostra stock atual do artigo', N'0', N'0', N'0-Não /1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (44, @APPCODE, N'DEFAULT', N'INSPECTION', CAST(6 AS Numeric(18, 0)), N'UPDATE_CTRL', N'Avisa que o artigo já foi lido, e se pretende atualizar a quantidade', N'0', N'0', N'0-Não /1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (45, @APPCODE, N'LOTES', N'LOTES', CAST(1 AS Numeric(18, 0)), N'ENB_LOTE_ALT', N'Permite editar o campo de lote', N'', N'', N'', N'0', N'0', N'')

			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (56, @APPCODE, N'DEFAULT', N'OTHERS', CAST(9 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (53, @APPCODE, N'DEFAULT', N'OTHERS', CAST(6 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (55, @APPCODE, N'DEFAULT', N'OTHERS', CAST(8 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (54, @APPCODE, N'DEFAULT', N'OTHERS', CAST(7 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (60, @APPCODE, N'DEFAULT', N'OTHERS', CAST(13 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (57, @APPCODE, N'DEFAULT', N'OTHERS', CAST(10 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (59, @APPCODE, N'DEFAULT', N'OTHERS', CAST(12 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (58, @APPCODE, N'DEFAULT', N'OTHERS', CAST(11 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (64, @APPCODE, N'DEFAULT', N'OTHERS', CAST(17 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (61, @APPCODE, N'DEFAULT', N'OTHERS', CAST(14 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (63, @APPCODE, N'DEFAULT', N'OTHERS', CAST(16 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (62, @APPCODE, N'DEFAULT', N'OTHERS', CAST(15 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (77, @APPCODE, N'DEFAULT', N'OTHERS', CAST(30 AS Numeric(18, 0)), N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (49, @APPCODE, N'DEFAULT', N'OTHERS', CAST(2 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (68, @APPCODE, N'DEFAULT', N'OTHERS', CAST(21 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (65, @APPCODE, N'DEFAULT', N'OTHERS', CAST(18 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (67, @APPCODE, N'DEFAULT', N'OTHERS', CAST(20 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (66, @APPCODE, N'DEFAULT', N'OTHERS', CAST(19 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (72, @APPCODE, N'DEFAULT', N'OTHERS', CAST(25 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (69, @APPCODE, N'DEFAULT', N'OTHERS', CAST(22 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (71, @APPCODE, N'DEFAULT', N'OTHERS', CAST(24 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (70, @APPCODE, N'DEFAULT', N'OTHERS', CAST(23 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (76, @APPCODE, N'DEFAULT', N'OTHERS', CAST(29 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (73, @APPCODE, N'DEFAULT', N'OTHERS', CAST(26 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (75, @APPCODE, N'DEFAULT', N'OTHERS', CAST(28 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (74, @APPCODE, N'DEFAULT', N'OTHERS', CAST(27 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (51, @APPCODE, N'DEFAULT', N'OTHERS', CAST(4 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (52, @APPCODE, N'DEFAULT', N'OTHERS', CAST(5 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (48, @APPCODE, N'DEFAULT', N'OTHERS', CAST(1 AS Numeric(18, 0)), N'OTHERS', N'Outros documentos', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (50, @APPCODE, N'DEFAULT', N'OTHERS', CAST(3 AS Numeric(18, 0)), N'VALIDA_STOCK', N'Valida Stock dos documentos', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (95, @APPCODE, N'DEFAULT', N'PACKING', CAST(19 AS Numeric(18, 0)), N'AUTONAME', N'Prefixo para código da caixa gerada pela app logistica', N'', N'', N'Se o prefixo foi do tipo texto é contactenado a um contador continuo com 5 digitos, ex. Caixa_00001   /  Se o prefixo conter uma das seguintes chaves:[REF];[DOCTYPE];[DOCNUMBER];[CUSTOMERID];[CUSTOMERNAME];[LOT];[WAREHOUSE];[USERID] será contacnetado o valor correspondente do documento seleccionado à um contador para essa chave até 3 digitos, ex.: DOS1_001   ', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (96, @APPCODE, N'DEFAULT', N'PACKING', CAST(20 AS Numeric(18, 0)), N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar? 1-Sim/0-Não.', N'', N'0', N'Apresentar teclado para quantidade automaticamente após leitura de CB', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (110, @APPCODE, N'DEFAULT', N'PACKING', CAST(31 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (107, @APPCODE, N'DEFAULT', N'PACKING', CAST(28 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (109, @APPCODE, N'DEFAULT', N'PACKING', CAST(30 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (108, @APPCODE, N'DEFAULT', N'PACKING', CAST(29 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (114, @APPCODE, N'DEFAULT', N'PACKING', CAST(35 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (111, @APPCODE, N'DEFAULT', N'PACKING', CAST(32 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (113, @APPCODE, N'DEFAULT', N'PACKING', CAST(34 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (112, @APPCODE, N'DEFAULT', N'PACKING', CAST(33 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (118, @APPCODE, N'DEFAULT', N'PACKING', CAST(39 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (115, @APPCODE, N'DEFAULT', N'PACKING', CAST(36 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (117, @APPCODE, N'DEFAULT', N'PACKING', CAST(38 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (116, @APPCODE, N'DEFAULT', N'PACKING', CAST(37 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (105, @APPCODE, N'DEFAULT', N'PACKING', CAST(26 AS Numeric(18, 0)), N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (132, @APPCODE, N'DEFAULT', N'PACKING', CAST(99 AS Numeric(18, 0)), N'DOC_DATE', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'', N'<=', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (79, @APPCODE, N'DEFAULT', N'PACKING', CAST(2 AS Numeric(18, 0)), N'DST_DOSSIER', N'Tipos de documentos a gerar na integração do documento de packing', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (131, @APPCODE, N'DEFAULT', N'PACKING', CAST(52 AS Numeric(18, 0)), N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (84, @APPCODE, N'DEFAULT', N'PACKING', CAST(7 AS Numeric(18, 0)), N'GRID1_ALIAS', N'Documentos: Titulos para os cabeçalhos das 10 colunas adicionais', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (86, @APPCODE, N'DEFAULT', N'PACKING', CAST(9 AS Numeric(18, 0)), N'GRID1_COL_DIM', N'Documentos: Dimensão para todos os cabeçalhos', N'', N'0,50,0,0,0,0,170', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (85, @APPCODE, N'DEFAULT', N'PACKING', CAST(8 AS Numeric(18, 0)), N'GRID1_COL_TYPE', N'Documentos: Tipos de dados para as colunas adicionais nos documentos', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (83, @APPCODE, N'DEFAULT', N'PACKING', CAST(6 AS Numeric(18, 0)), N'GRID1_COLUMNS', N'Documentos: 10 colunas de utilizador adicionais para os docs.', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha o <GRID1_QUERY> preenchido, ex. tabela.name, tabela.date, tabela.status', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (87, @APPCODE, N'DEFAULT', N'PACKING', CAST(10 AS Numeric(18, 0)), N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'deve começar por: and..condições adicionais para a lista de documentos', N'0', N'0', N'')
			--GO
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (82, @APPCODE, N'DEFAULT', N'PACKING', CAST(5 AS Numeric(18, 0)), N'GRID1_QUERY', N'Documentos: Join  para obter adicionar colunas de outras tabelas', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela da lista de documentos', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (90, @APPCODE, N'DEFAULT', N'PACKING', CAST(13 AS Numeric(18, 0)), N'GRID2_ALIAS', N'Linhas: Titulos para os cabeçalhos das colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (92, @APPCODE, N'DEFAULT', N'PACKING', CAST(15 AS Numeric(18, 0)), N'GRID2_COL_DIM', N'Linhas: Dimensão para todos os cabeçalhos', N'', N'50,50,0,120,170,0,50,50,0,0,0,0', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (91, @APPCODE, N'DEFAULT', N'PACKING', CAST(14 AS Numeric(18, 0)), N'GRID2_COL_TYPE', N'Linhas: Tipos de dados para as colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (89, @APPCODE, N'DEFAULT', N'PACKING', CAST(12 AS Numeric(18, 0)), N'GRID2_COLUMNS', N'Linhas: 10 colunas adiconais para as linhas de documento', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha acrescentado colunas à lista de documentos, ex. tabela.name, tabela.date, tabela.status', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (93, @APPCODE, N'DEFAULT', N'PACKING', CAST(16 AS Numeric(18, 0)), N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional.', N'', N'', N'deve começar por: and..condições adicionais para a tabela das linhas do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (88, @APPCODE, N'DEFAULT', N'PACKING', CAST(11 AS Numeric(18, 0)), N'GRID2_QUERY', N'Linhas: Join  para adicionar colunas às linhas do documento', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela das linhas do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (97, @APPCODE, N'DEFAULT', N'PACKING', CAST(20 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (80, @APPCODE, N'DEFAULT', N'PACKING', CAST(3 AS Numeric(18, 0)), N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo index do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (122, @APPCODE, N'DEFAULT', N'PACKING', CAST(43 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (119, @APPCODE, N'DEFAULT', N'PACKING', CAST(40 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (121, @APPCODE, N'DEFAULT', N'PACKING', CAST(42 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (120, @APPCODE, N'DEFAULT', N'PACKING', CAST(41 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (126, @APPCODE, N'DEFAULT', N'PACKING', CAST(47 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (123, @APPCODE, N'DEFAULT', N'PACKING', CAST(44 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (125, @APPCODE, N'DEFAULT', N'PACKING', CAST(46 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (124, @APPCODE, N'DEFAULT', N'PACKING', CAST(45 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (130, @APPCODE, N'DEFAULT', N'PACKING', CAST(51 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (127, @APPCODE, N'DEFAULT', N'PACKING', CAST(48 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (129, @APPCODE, N'DEFAULT', N'PACKING', CAST(50 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (128, @APPCODE, N'DEFAULT', N'PACKING', CAST(49 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (106, @APPCODE, N'DEFAULT', N'PACKING', CAST(27 AS Numeric(18, 0)), N'MESSAGE_LINES_QUERY', N'Linhas: Query que corre ao seleccionar uma linha', N'', N'', N'Consulta que vai despoltar um aviso e/ou uma acção ao seleccionar uma linha.

								Podem ser utilizadas as seguintes keywords:
								[CHAVECAB] - O campo identificador do documento
								[NUMERODOC] - Número do documento
								[NOMEENTIDADE] - Nome da entidade
								[DATAFINAL] - Data do documento
								[CODIGOENTIDADE] - Código da Entidade
								[CODINTDOCUMENTO] - Código interno do documento
								[NOMEDOCUMENTO] - Nome do documento
								[NUNLINHA] - Número da linha
								[REFARTIGO] - Referência do Artigo', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (94, @APPCODE, N'DEFAULT', N'PACKING', CAST(17 AS Numeric(18, 0)), N'MESSAGE_QUERY', N'Documentos: Query que corre ao seleccionar 1 doc.', N'', N'', N'Consulta que vai despoltar um aviso e uma acção ao entrar num documento de rececão.

								Podem ser utilizadas as seguintes keywords:
								[CHAVECAB] - O campo identificador do documento
								[NUMERODOC] - Número do documento
								[NOMEENTIDADE] - Nome da entidade
								[DATAFINAL] - Data do documento
								[CODIGOENTIDADE] - Código da Entidade
								[CODINTDOCUMENTO] - Código interno do documento
								[NOMEDOCUMENTO] - Nome do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (102, @APPCODE, N'DEFAULT', N'PACKING', CAST(23 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (103, @APPCODE, N'DEFAULT', N'PACKING', CAST(24 AS Numeric(18, 0)), N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo cliente', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (98, @APPCODE, N'DEFAULT', N'PACKING', CAST(20 AS Numeric(18, 0)), N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (99, @APPCODE, N'DEFAULT', N'PACKING', CAST(21 AS Numeric(18, 0)), N'NOQTY', N'Mostar quantidade a picar por defeito? 1-Sim/0-Não.', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (104, @APPCODE, N'DEFAULT', N'PACKING', CAST(25 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (100, @APPCODE, N'DEFAULT', N'PACKING', CAST(21 AS Numeric(18, 0)), N'PACKORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (101, @APPCODE, N'DEFAULT', N'PACKING', CAST(22 AS Numeric(18, 0)), N'PACKORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (81, @APPCODE, N'DEFAULT', N'PACKING', CAST(4 AS Numeric(18, 0)), N'SERIE_ORIGEM', N'Série do documento de destino igual á do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai integrar na mesma série do documento de origem! Não aplicável em modo Multi-Documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (78, @APPCODE, N'DEFAULT', N'PACKING', CAST(1 AS Numeric(18, 0)), N'SRC_DOSSIER', N'Tipos de docs que dão origem ao packing.', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (151, @APPCODE, N'DEFAULT', N'PICKING', CAST(19 AS Numeric(18, 0)), N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar? 1-Sim/0-Não.', N'', N'0', N'Apresentar teclado para quantidade automaticamente após leitura de CB', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (164, @APPCODE, N'DEFAULT', N'PICKING', CAST(31 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (161, @APPCODE, N'DEFAULT', N'PICKING', CAST(28 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (163, @APPCODE, N'DEFAULT', N'PICKING', CAST(30 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (162, @APPCODE, N'DEFAULT', N'PICKING', CAST(29 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (168, @APPCODE, N'DEFAULT', N'PICKING', CAST(35 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (165, @APPCODE, N'DEFAULT', N'PICKING', CAST(32 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (167, @APPCODE, N'DEFAULT', N'PICKING', CAST(34 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (166, @APPCODE, N'DEFAULT', N'PICKING', CAST(33 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (172, @APPCODE, N'DEFAULT', N'PICKING', CAST(39 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (169, @APPCODE, N'DEFAULT', N'PICKING', CAST(36 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (171, @APPCODE, N'DEFAULT', N'PICKING', CAST(38 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (170, @APPCODE, N'DEFAULT', N'PICKING', CAST(37 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (159, @APPCODE, N'DEFAULT', N'PICKING', CAST(26 AS Numeric(18, 0)), N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (186, @APPCODE, N'DEFAULT', N'PICKING', CAST(99 AS Numeric(18, 0)), N'DOC_DATE', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'', N'<=', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (134, @APPCODE, N'DEFAULT', N'PICKING', CAST(2 AS Numeric(18, 0)), N'DST_DOSSIER', N'Tipos de documentos a gerar na integração do picking', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (185, @APPCODE, N'DEFAULT', N'PICKING', CAST(52 AS Numeric(18, 0)), N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (139, @APPCODE, N'DEFAULT', N'PICKING', CAST(7 AS Numeric(18, 0)), N'GRID1_ALIAS', N'Documentos: Titulos para os cabeçalhos das 10 colunas adicionais', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (141, @APPCODE, N'DEFAULT', N'PICKING', CAST(9 AS Numeric(18, 0)), N'GRID1_COL_DIM', N'Documentos: Dimensão para todos os cabeçalhos', N'', N'0,50,0,0,0,0,170', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (140, @APPCODE, N'DEFAULT', N'PICKING', CAST(8 AS Numeric(18, 0)), N'GRID1_COL_TYPE', N'Documentos: Tipos de dados para as colunas adicionais nos documentos', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (138, @APPCODE, N'DEFAULT', N'PICKING', CAST(6 AS Numeric(18, 0)), N'GRID1_COLUMNS', N'Documentos: 10 colunas de utilizador adicionais para os docs.', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha o <GRID1_QUERY> preenchido, ex. tabela.name, tabela.date, tabela.status', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (142, @APPCODE, N'DEFAULT', N'PICKING', CAST(10 AS Numeric(18, 0)), N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'deve começar por: and..condições adicionais para a lista de documentos', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (137, @APPCODE, N'DEFAULT', N'PICKING', CAST(5 AS Numeric(18, 0)), N'GRID1_QUERY', N'Documentos: Join  para obter adicionar colunas de outras tabelas', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela da lista de documentos', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (145, @APPCODE, N'DEFAULT', N'PICKING', CAST(13 AS Numeric(18, 0)), N'GRID2_ALIAS', N'Linhas: Titulos para os cabeçalhos das colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (147, @APPCODE, N'DEFAULT', N'PICKING', CAST(15 AS Numeric(18, 0)), N'GRID2_COL_DIM', N'Linhas: Dimensão para todos os cabeçalhos', N'', N'50,50,0,120,170,0,50,50,0,0,0,0', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'1', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (146, @APPCODE, N'DEFAULT', N'PICKING', CAST(14 AS Numeric(18, 0)), N'GRID2_COL_TYPE', N'Linhas: Tipos de dados para as colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (144, @APPCODE, N'DEFAULT', N'PICKING', CAST(12 AS Numeric(18, 0)), N'GRID2_COLUMNS', N'Linhas: 10 colunas adiconais para as linhas de documento', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha acrescentado colunas à lista de documentos, ex. tabela.name, tabela.date, tabela.status', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (148, @APPCODE, N'DEFAULT', N'PICKING', CAST(16 AS Numeric(18, 0)), N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional.', N'', N'', N'deve começar por: and..condições adicionais para a tabela das linhas do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (143, @APPCODE, N'DEFAULT', N'PICKING', CAST(11 AS Numeric(18, 0)), N'GRID2_QUERY', N'Linhas: Join  para adicionar colunas às linhas do documento', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela das linhas do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (153, @APPCODE, N'DEFAULT', N'PICKING', CAST(20 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (135, @APPCODE, N'DEFAULT', N'PICKING', CAST(3 AS Numeric(18, 0)), N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo index do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (176, @APPCODE, N'DEFAULT', N'PICKING', CAST(43 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (173, @APPCODE, N'DEFAULT', N'PICKING', CAST(40 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (175, @APPCODE, N'DEFAULT', N'PICKING', CAST(42 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (174, @APPCODE, N'DEFAULT', N'PICKING', CAST(41 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (180, @APPCODE, N'DEFAULT', N'PICKING', CAST(47 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (177, @APPCODE, N'DEFAULT', N'PICKING', CAST(44 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (179, @APPCODE, N'DEFAULT', N'PICKING', CAST(46 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (178, @APPCODE, N'DEFAULT', N'PICKING', CAST(45 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (184, @APPCODE, N'DEFAULT', N'PICKING', CAST(51 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (181, @APPCODE, N'DEFAULT', N'PICKING', CAST(48 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (183, @APPCODE, N'DEFAULT', N'PICKING', CAST(50 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (182, @APPCODE, N'DEFAULT', N'PICKING', CAST(49 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (160, @APPCODE, N'DEFAULT', N'PICKING', CAST(27 AS Numeric(18, 0)), N'MESSAGE_LINES_QUERY', N'Linhas: Query que corre ao seleccionar uma linha', N'', N'', N'Consulta que vai despoltar um aviso e/ou uma acção ao seleccionar uma linha.

								Podem ser utilizadas as seguintes keywords:
								[CHAVECAB] - O campo identificador do documento
								[NUMERODOC] - Número do documento
								[NOMEENTIDADE] - Nome da entidade
								[DATAFINAL] - Data do documento
								[CODIGOENTIDADE] - Código da Entidade
								[CODINTDOCUMENTO] - Código interno do documento
								[NOMEDOCUMENTO] - Nome do documento
								[NUNLINHA] - Número da linha
								[REFARTIGO] - Referência do Artigo', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (149, @APPCODE, N'DEFAULT', N'PICKING', CAST(17 AS Numeric(18, 0)), N'MESSAGE_QUERY', N'Documentos: Query que corre ao seleccionar 1 doc.', N'', N'', N'Consulta que vai despoltar um aviso e uma acção ao entrar num documento de rececão.

								Podem ser utilizadas as seguintes keywords:
								[CHAVECAB] - O campo identificador do documento
								[NUMERODOC] - Número do documento
								[NOMEENTIDADE] - Nome da entidade
								[DATAFINAL] - Data do documento
								[CODIGOENTIDADE] - Código da Entidade
								[CODINTDOCUMENTO] - Código interno do documento
								[NOMEDOCUMENTO] - Nome do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (156, @APPCODE, N'DEFAULT', N'PICKING', CAST(23 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (157, @APPCODE, N'DEFAULT', N'PICKING', CAST(24 AS Numeric(18, 0)), N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo cliente', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (150, @APPCODE, N'DEFAULT', N'PICKING', CAST(19 AS Numeric(18, 0)), N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (152, @APPCODE, N'DEFAULT', N'PICKING', CAST(20 AS Numeric(18, 0)), N'NOQTY', N'Mostar quantidade a picar por defeito? 1-Sim/0-Não.', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (158, @APPCODE, N'DEFAULT', N'PICKING', CAST(25 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (154, @APPCODE, N'DEFAULT', N'PICKING', CAST(21 AS Numeric(18, 0)), N'PICKORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (155, @APPCODE, N'DEFAULT', N'PICKING', CAST(22 AS Numeric(18, 0)), N'PICKORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (136, @APPCODE, N'DEFAULT', N'PICKING', CAST(4 AS Numeric(18, 0)), N'SERIE_ORIGEM', N'Série do documento de destino igual á do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai integrar na mesma série do documento de origem! Não aplicável em modo Multi-Documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (133, @APPCODE, N'DEFAULT', N'PICKING', CAST(1 AS Numeric(18, 0)), N'SRC_DOSSIER', N'Tipos de docs que dão origem no picking.', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (204, @APPCODE, N'DEFAULT', N'STORE IN', CAST(19 AS Numeric(18, 0)), N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar? 1-Sim/0-Não.', N'', N'0', N'Apresentar teclado para quantidade automaticamente após leitura de CB', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (218, @APPCODE, N'DEFAULT', N'STORE IN', CAST(31 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (215, @APPCODE, N'DEFAULT', N'STORE IN', CAST(28 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (217, @APPCODE, N'DEFAULT', N'STORE IN', CAST(30 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (216, @APPCODE, N'DEFAULT', N'STORE IN', CAST(29 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (222, @APPCODE, N'DEFAULT', N'STORE IN', CAST(35 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (219, @APPCODE, N'DEFAULT', N'STORE IN', CAST(32 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (221, @APPCODE, N'DEFAULT', N'STORE IN', CAST(34 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (220, @APPCODE, N'DEFAULT', N'STORE IN', CAST(33 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (226, @APPCODE, N'DEFAULT', N'STORE IN', CAST(39 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (223, @APPCODE, N'DEFAULT', N'STORE IN', CAST(36 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (225, @APPCODE, N'DEFAULT', N'STORE IN', CAST(38 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (224, @APPCODE, N'DEFAULT', N'STORE IN', CAST(37 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (213, @APPCODE, N'DEFAULT', N'STORE IN', CAST(26 AS Numeric(18, 0)), N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (240, @APPCODE, N'DEFAULT', N'STORE IN', CAST(99 AS Numeric(18, 0)), N'DOC_DATE', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'', N'<=', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'0', N'0', N'')
			--GO
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (188, @APPCODE, N'DEFAULT', N'STORE IN', CAST(2 AS Numeric(18, 0)), N'DST_DOSSIER', N'Tipos de documentos a gerar na integração da receção', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (239, @APPCODE, N'DEFAULT', N'STORE IN', CAST(52 AS Numeric(18, 0)), N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (193, @APPCODE, N'DEFAULT', N'STORE IN', CAST(7 AS Numeric(18, 0)), N'GRID1_ALIAS', N'Documentos: Titulos para os cabeçalhos das 10 colunas adicionais', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (195, @APPCODE, N'DEFAULT', N'STORE IN', CAST(9 AS Numeric(18, 0)), N'GRID1_COL_DIM', N'Documentos: Dimensão para todos os cabeçalhos', N'', N'0,50,0,0,0,0,170', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (194, @APPCODE, N'DEFAULT', N'STORE IN', CAST(8 AS Numeric(18, 0)), N'GRID1_COL_TYPE', N'Documentos: Tipos de dados para as colunas adicionais nos documentos', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (192, @APPCODE, N'DEFAULT', N'STORE IN', CAST(6 AS Numeric(18, 0)), N'GRID1_COLUMNS', N'Documentos: 10 colunas de utilizador adicionais para os docs.', N'', N'', N'As colunas de utilizador são do tipo multilinha podendo assim apresentar informação contactenada até 2 linhas', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (196, @APPCODE, N'DEFAULT', N'STORE IN', CAST(10 AS Numeric(18, 0)), N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'deve começar por: and..condições adicionais para a lista de documentos', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (191, @APPCODE, N'DEFAULT', N'STORE IN', CAST(5 AS Numeric(18, 0)), N'GRID1_QUERY', N'Documentos: Join  para obter adicionar colunas de outras tabelas', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela da lista de documentos', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (199, @APPCODE, N'DEFAULT', N'STORE IN', CAST(13 AS Numeric(18, 0)), N'GRID2_ALIAS', N'Linhas: Titulos para os cabeçalhos das colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (201, @APPCODE, N'DEFAULT', N'STORE IN', CAST(15 AS Numeric(18, 0)), N'GRID2_COL_DIM', N'Linhas: Dimensão para todos os cabeçalhos', N'', N'50,50,0,120,170,0,50,50,0,0,0,0', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (200, @APPCODE, N'DEFAULT', N'STORE IN', CAST(14 AS Numeric(18, 0)), N'GRID2_COL_TYPE', N'Linhas: Tipos de dados para as colunas adicionais ', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (198, @APPCODE, N'DEFAULT', N'STORE IN', CAST(12 AS Numeric(18, 0)), N'GRID2_COLUMNS', N'Linhas: 10 colunas adiconais para as linhas de documento', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha acrescentado colunas à lista de documentos, ex. tabela.name, tabela.date, tabela.status', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (202, @APPCODE, N'DEFAULT', N'STORE IN', CAST(16 AS Numeric(18, 0)), N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional.', N'', N'', N'deve começar por: and..condições adicionais para a tabela das linhas do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (197, @APPCODE, N'DEFAULT', N'STORE IN', CAST(11 AS Numeric(18, 0)), N'GRID2_QUERY', N'Linhas: Join  para adicionar colunas às linhas do documento', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela das linhas do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (205, @APPCODE, N'DEFAULT', N'STORE IN', CAST(19 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (189, @APPCODE, N'DEFAULT', N'STORE IN', CAST(3 AS Numeric(18, 0)), N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo index do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (230, @APPCODE, N'DEFAULT', N'STORE IN', CAST(43 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (227, @APPCODE, N'DEFAULT', N'STORE IN', CAST(40 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (228, @APPCODE, N'DEFAULT', N'STORE IN', CAST(41 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (229, @APPCODE, N'DEFAULT', N'STORE IN', CAST(41 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (234, @APPCODE, N'DEFAULT', N'STORE IN', CAST(47 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (231, @APPCODE, N'DEFAULT', N'STORE IN', CAST(44 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (233, @APPCODE, N'DEFAULT', N'STORE IN', CAST(46 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (232, @APPCODE, N'DEFAULT', N'STORE IN', CAST(45 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (238, @APPCODE, N'DEFAULT', N'STORE IN', CAST(51 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (235, @APPCODE, N'DEFAULT', N'STORE IN', CAST(48 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (237, @APPCODE, N'DEFAULT', N'STORE IN', CAST(50 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (236, @APPCODE, N'DEFAULT', N'STORE IN', CAST(49 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (214, @APPCODE, N'DEFAULT', N'STORE IN', CAST(27 AS Numeric(18, 0)), N'MESSAGE_LINES_QUERY', N'Linhas: Query que corre ao seleccionar uma linha', N'', N'', N'Consulta que vai despoltar um aviso e/ou uma acção ao seleccionar uma linha.

								Podem ser utilizadas as seguintes keywords:
								[CHAVECAB] - O campo identificador do documento
								[NUMERODOC] - Número do documento
								[NOMEENTIDADE] - Nome da entidade
								[DATAFINAL] - Data do documento
								[CODIGOENTIDADE] - Código da Entidade
								[CODINTDOCUMENTO] - Código interno do documento
								[NOMEDOCUMENTO] - Nome do documento
								[NUNLINHA] - Número da linha
								[REFARTIGO] - Referência do Artigo', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (203, @APPCODE, N'DEFAULT', N'STORE IN', CAST(17 AS Numeric(18, 0)), N'MESSAGE_QUERY', N'Documentos: Query que corre ao seleccionar 1 doc.', N'', N'', N'Consulta que vai despoltar um aviso e uma acção ao entrar num documento de rececão.

								Podem ser utilizadas as seguintes keywords:
								[CHAVECAB] - O campo identificador do documento
								[NUMERODOC] - Número do documento
								[NOMEENTIDADE] - Nome da entidade
								[DATAFINAL] - Data do documento
								[CODIGOENTIDADE] - Código da Entidade
								[CODINTDOCUMENTO] - Código interno do documento
								[NOMEDOCUMENTO] - Nome do documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (210, @APPCODE, N'DEFAULT', N'STORE IN', CAST(23 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (211, @APPCODE, N'DEFAULT', N'STORE IN', CAST(24 AS Numeric(18, 0)), N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo fornecedor', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (206, @APPCODE, N'DEFAULT', N'STORE IN', CAST(19 AS Numeric(18, 0)), N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (207, @APPCODE, N'DEFAULT', N'STORE IN', CAST(20 AS Numeric(18, 0)), N'NOQTY', N'Mostar quantidade a picar por defeito? 1-Sim/0-Não.', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (212, @APPCODE, N'DEFAULT', N'STORE IN', CAST(25 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (208, @APPCODE, N'DEFAULT', N'STORE IN', CAST(21 AS Numeric(18, 0)), N'RECEORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (209, @APPCODE, N'DEFAULT', N'STORE IN', CAST(22 AS Numeric(18, 0)), N'RECEORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (190, @APPCODE, N'DEFAULT', N'STORE IN', CAST(4 AS Numeric(18, 0)), N'SERIE_ORIGEM', N'Série do documento de destino igual á do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai integrar na mesma série do documento de origem! Não aplicável em modo Multi-Documento', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters(id, AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES (187, @APPCODE, N'DEFAULT', N'STORE IN', CAST(1 AS Numeric(18, 0)), N'SRC_DOSSIER', N'Tipos de docs que dão origem à receção', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N'')	
			SET IDENTITY_INSERT u_Kapps_Parameters OFF

			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(9 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(6 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(8 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(7 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(13 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(10 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(12 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(11 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(17 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(14 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(16 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(15 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(2 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(21 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(18 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(20 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(19 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(25 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(22 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(24 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(23 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(29 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(26 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(28 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(27 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(4 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(5 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenção das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(1 AS Numeric(18, 0)), N'TRANSF', N'Tipos de documentos (transferências)', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(3 AS Numeric(18, 0)), N'VALIDA_STOCK', N'Valida Stock dos documentos', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(30 AS Numeric(18, 0)), N'DESTCONHECIDO', N'Destino conhecido', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N'')



			-- parametros adicionados na v33
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'USR', CAST(8 AS Numeric(18, 0)), N'COD_LOTE', N'Código da propriedade associada ao lote (Sage 50C)', N'', N'', N'', N'0', N'0', N'Sage_50C')
			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) VALUES (@APPCODE, N'DEFAULT', N'USR', CAST(9 AS Numeric(18, 0)), N'DOC_CLOSE_COD', N'Código do estado para fechar documento (Sage 50C)', N'', N'', N'', N'0', N'0', N'Sage_50C')

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Código da moeda default na integração com (Sage 50C/Sage 100C/Sendys)', ParameterERP='Sage_50C;Sage_100C;Sendys;' WHERE ParameterType = 'USR' AND ParameterID = 'MOEDA'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Secção para Eticadata/Serie para primavera,Sage50C,Sage100C e Sendys', ParameterERP='Eticadata_13;Eticadata_16/17/18/19;primavera;Sage_50C;Sage_100C;Sendys;' WHERE ParameterType = 'USR' AND ParameterID = 'SECCAO'

			UPDATE u_Kapps_Parameters SET ParameterValue=ISNULL((SELECT ParameterValue FROM [Kapps_Parameters] WHERE ParameterID='DATABASEVERSION'),'') WHERE ParameterID='DATABASEVERSION' and ParameterGroup='MAIN'
			UPDATE u_Kapps_Parameters SET ParameterValue=ISNULL((SELECT ParameterValue FROM [Kapps_Parameters] WHERE ParameterID='SCRIPTSVERSION'),'') WHERE ParameterID='SCRIPTSVERSION' and ParameterGroup='MAIN'
			UPDATE u_Kapps_Parameters SET ParameterValue=ISNULL((SELECT TOP 1 ParameterValue FROM [Kapps_Parameters] WHERE ParameterID='Driver_Path'),'') WHERE ParameterID='Driver_Path' and ParameterGroup='MAIN'
			UPDATE u_Kapps_Parameters SET ParameterValue=ISNULL((SELECT TOP 1 ParameterValue FROM [Kapps_Parameters] WHERE ParameterID='UPDATE'),'') WHERE ParameterID='UPDATE' and ParameterGroup='MAIN'
			UPDATE u_Kapps_Parameters SET ParameterValue=ISNULL((SELECT TOP 1 ParameterValue FROM [Kapps_Parameters] WHERE ParameterID='ERP'),'') WHERE ParameterID='ERP' and ParameterGroup='MAIN'
			UPDATE u_Kapps_Parameters SET ParameterValue=ISNULL((SELECT TOP 1 ParameterValue FROM [Kapps_Parameters] WHERE ParameterID='BD_Sistema_16'),'') WHERE ParameterID='BD_Sistema' and ParameterGroup='MAIN'
			UPDATE u_Kapps_Parameters SET ParameterValue=ISNULL((SELECT TOP 1 ParameterValue FROM [Kapps_Parameters] WHERE ParameterID='BD_Empresas'),'') WHERE ParameterID='BD_Empresas' and ParameterGroup='MAIN'

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(104, @APPCODE, 'GENERAL', 'GENERAL','USE_LOCATIONS','Usar Localizações?','0','0','0-não / 1-sim',0,0)
					
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(105, @APPCODE, 'GENERAL', 'GENERAL','LOCATIONS_CTRL','Permitir alterar localizações?','0','0','0-Não / 1-Sim com mensagem de aviso / 2-Sim sem mensagem de aviso',0,0)

			ALTER TABLE u_Kapps_DossierLin ADD OriginalLot nvarchar(50) NULL
			ALTER TABLE u_Kapps_DossierLin ADD OriginalLocation nvarchar(50) NULL
			
			
			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType)
			VALUES('Foi criada uma nova view "v_Kapps_WarehousesLocations". Deverá correr o script para a criação da mesma. Se estiver em modo personalizado terá de construir esta nova view',1,34,0)
			
			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType)
			VALUES('Foram alteradas as views. Deverá correr os scripts para a recriação das mesmas.',1,34,0)
 
			ALTER TABLE u_Kapps_InvLines ADD Location nvarchar(50) NULL
			
			ALTER TABLE u_Kapps_Users ADD Actif bit NOT NULL DEFAULT (1) WITH VALUES

			INSERT INTO u_Kapps_Parameters([AppCode],[ParameterType],[ParameterGroup],[ParameterOrder],[ParameterID],[ParameterDescription],[ParameterValue],[ParameterDefaultValue],[ParameterInfo],[ParameterRequired],[ParameterDependent],[ParameterERP])
			SELECT [AppCode],[ParameterType],UserName,[ParameterOrder],[ParameterID],[ParameterDescription],[ParameterValue],[ParameterDefaultValue],[ParameterInfo],[ParameterRequired],[ParameterDependent],[ParameterERP]
			FROM u_Kapps_Parameters
			LEFT JOIN u_Kapps_Users on 1=1  
			WHERE ParameterGroup='DEFAULT' and ParameterType='USR' and Username is not null
			ORDER BY UserName, ParameterOrder
			
			UPDATE u_Kapps_Parameters SET ParameterDescription='Ordenação das linhas a integrar' where ParameterID='ORDER_INTEGRATION'
			
			--parametros acrescentados na v35
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(12, @APPCODE, 'EAN128', 'EAN128', 'SSCC_CONTROLDIGIT', 'SSCC - Dígito de Extensão','','','',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(13, @APPCODE, 'EAN128', 'EAN128', 'SSCC_COMPANYPREFIX', 'SSCC - Prefixo da Empresa','','','',0,0)		
			
			ALTER TABLE u_Kapps_DossierLin ADD LocationOUT nvarchar(50) NULL 
			
			ALTER TABLE u_Kapps_DossierLin ADD DefaultWarehouse varchar(50) NULL
			ALTER TABLE u_Kapps_DossierLin ADD DefaultLocation varchar(50) NULL
			ALTER TABLE u_Kapps_DossierLin ADD DefaultWarehouseOut varchar(50) NULL
			ALTER TABLE u_Kapps_DossierLin ADD DefaultLocationOut varchar(50) NULL
				
			
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(3, @APPCODE, 'MAIN', 'MAIN','SMTP_SERVER','Servidor SMTP','','','',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(4, @APPCODE, 'MAIN', 'MAIN','SMTP_PORT','Porta (SMTP)','','','',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(5, @APPCODE, 'MAIN', 'MAIN','SMTP_USERNAME','Utilizador (SMTP)','','','',0,0)
			
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(6, @APPCODE, 'MAIN', 'MAIN','SMTP_PASSWORD','Password (SMTP)','','','',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(7, @APPCODE, 'MAIN', 'MAIN','SMTP_SECURECONNECTION','Secure connection','1','1','1-Yes 2-No',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(8, @APPCODE, 'MAIN', 'MAIN','SMTP_STARTTLS','Start TLS','1','1','1-Yes 2-No',0,0)



			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(53, @APPCODE, 'STORE IN', 'DEFAULT','QUALITY_NOTIFY','Notifica por email os produtos não conformes?','','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(54, @APPCODE, 'STORE IN', 'DEFAULT','QUALITY_SENDER_NAME','Utilizador que envia os emails qualidade','','','Nome do utilizador e email separado por ;

			ex:
			Pedro Neves;pedroneves@gmail.com
			',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(55, @APPCODE, 'STORE IN', 'DEFAULT','QUALITY_SENDER_EMAIL','Email dos destinatários para envio de emails qualidade','','','Endereços de email separados por ;

			ex:
			pedroneves@gmail.com;rui@hotmail.com
			',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(56, @APPCODE, 'STORE IN', 'DEFAULT','QUALITY_SUBJECT','Assunto para envio de emails qualidade','','','',0,0)
			
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(57, @APPCODE, 'STORE IN', 'DEFAULT','DEFAULT_ARM_LOCATION','Armazém e localização por defeito','','',
			'Armazem;Localização;Permite Alterar(0-Não 1-Sim)'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+
			'Podem ser utilizadas as seguintes keywords:'+ CHAR(13)+CHAR(10)+
			'[CURRENT_WAREHOUSE]'+ CHAR(13)+CHAR(10)+ 
			CHAR(13)+CHAR(10)+
			'ex:'+ CHAR(13)+CHAR(10)+
			'A1;A1.A.1.001;0 '+ CHAR(13)+CHAR(10)+
			'(Armazem: A1; Localização: A1.A.1.001 RECECAO; 0: Não permite alterar)'+ CHAR(13)+CHAR(10)+
			CHAR(13)+CHAR(10)+
			'ex:'+ CHAR(13)+CHAR(10)+
			'[CURRENT_WAREHOUSE];RECECAO;1 '+ CHAR(13)+CHAR(10)+
			'(Armazem: Armazem definido no terminal; Localização: RECECAO; 1: Permite alterar)'
			,0,0)
			
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(58, @APPCODE, 'STORE IN', 'DEFAULT','QUALITY_ARM_LOCATION','Armazém e localização por defeito para produtos não conformes','','',
			'Armazem;Localização;Permite Alterar(0-Não 1-Sim)'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+
			'Podem ser utilizadas as seguintes keywords:'+ CHAR(13)+CHAR(10)+
			'[CURRENT_WAREHOUSE]'+ CHAR(13)+CHAR(10)+ 
			CHAR(13)+CHAR(10)+
			'ex:'+ CHAR(13)+CHAR(10)+
			'A1;A1.A.1.001;0 '+ CHAR(13)+CHAR(10)+
			'(Armazem: A1; Localização: A1.A.1.001 RECECAO; 0: Não permite alterar)'+ CHAR(13)+CHAR(10)+
			CHAR(13)+CHAR(10)+
			'ex:'+ CHAR(13)+CHAR(10)+
			'[CURRENT_WAREHOUSE];RECECAO;1 '+ CHAR(13)+CHAR(10)+
			'(Armazem: Armazem definido no terminal; Localização: RECECAO; 1: Permite alterar)'
			,0,0)
			
			DELETE FROM u_Kapps_Parameters WHERE ParameterID='DESTCONHECIDO' AND ParameterType='TRANSF'
			
			ALTER TABLE u_Kapps_DossierLin ADD InternalDocType nvarchar(10) NOT NULL DEFAULT ('') WITH VALUES
					
            INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			VALUES (@APPCODE, N'DEFAULT', N'TRANSF', CAST(5 AS Numeric(18, 0)), N'TIPO_TRANSFERENCIA', N'Tipo de transferência', N'0', N'0', 		
			N'0 - Transferência com destino conhecido'+ CHAR(13)+CHAR(10)+
			N'1 - Transferência sem destino conhecido'+ CHAR(13)+CHAR(10)+
			N'2 - Transferência directa'+ CHAR(13)+CHAR(10)+
			N'3 - Transferência dois passos', N'0', N'0', N'')					
			
			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Parameters 
			LEFT JOIN u_Kapps_Processes p ON TypeID='TRANSF' 
			WHERE p.ProcessID is not null and ParameterID='TIPO_TRANSFERENCIA' and ParameterGroup='DEFAULT'

			UPDATE u_Kapps_Parameters SET ParameterERP='Eticadata_13;Eticadata_16/17/18/19;primavera;Sage_50C;Sage_100C;Sendys;Personalizado;',ParameterDescription='Secção para Eticadata/Serie para primavera,Sage50C,Sage100C,Sendys e Personalizado'
			WHERE ParameterID='SECCAO' AND ParameterType='USR'

			UPDATE u_Kapps_Parameters SET ParameterDescription='Código do documento de contagens', ParameterID='TIPO_DOC_CONTAGENS' 
			WHERE ParameterID='TIPO_DOC_INVENTARIO' AND ParameterType='USR'
			
			ALTER TABLE u_Kapps_DossierLin ADD InternalQty decimal(18,3) NOT NULL DEFAULT (0) WITH VALUES			
			
			CREATE TABLE [u_Kapps_StockLines](
				[StampLin] [nvarchar](50) NOT NULL,
				[OrigStampHeader] [nvarchar](50) NOT NULL,
				[OrigStampLin] [nvarchar](50) NOT NULL,
				[Warehouse] [nvarchar](50) NOT NULL,
				[Location] [nvarchar](50) NOT NULL,
				[Lot] [nvarchar](50) NOT NULL,
				[Ref] [nvarchar](60) NOT NULL,
				[Description] [nvarchar](100) NOT NULL,
				[Qty] [numeric](18, 5) NOT NULL,
				[SerialNumber] [nvarchar](50) NOT NULL,
				[MovDate] [datetime] NULL,
				[TerminalID] [int] NOT NULL,
				[UserID] [nvarchar](50) NOT NULL,
				[Status] [nvarchar](1) NOT NULL,
				[Syncr] [nvarchar](1) NOT NULL,
				[SyncrDate] [datetime] NULL,
				[SyncrUser] [nvarchar](50) NOT NULL,
			 CONSTRAINT [PK_u_Kapps_StockLines] PRIMARY KEY CLUSTERED 
			(
				[StampLin] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_OrigStampHeader]  DEFAULT ('') FOR [OrigStampHeader]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_OrigStampLin]  DEFAULT ('') FOR [OrigStampLin]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_Warehouse]  DEFAULT ('') FOR [Warehouse]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_Location]  DEFAULT ('') FOR [Location]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_Lot]  DEFAULT ('') FOR [Lot]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_Ref]  DEFAULT ('') FOR [Ref]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_Description]  DEFAULT ('') FOR [Description]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_Qty]  DEFAULT ((0)) FOR [Qty]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_SerialNumber]  DEFAULT ('') FOR [SerialNumber]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_TerminalID]  DEFAULT ((0)) FOR [TerminalID]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_UserID]  DEFAULT ('') FOR [UserID]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_Status]  DEFAULT ('') FOR [Status]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_Syncr]  DEFAULT ('') FOR [Syncr]
			ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT [DF_u_Kapps_StockLines_SyncrUser]  DEFAULT ('') FOR [SyncrUser]
		
			UPDATE u_Kapps_Parameters SET ParameterOrder=14 WHERE ParameterID='USEEAN13'
			UPDATE u_Kapps_Parameters SET ParameterOrder=15 WHERE ParameterID='EAN13_LEGHT'
			UPDATE u_Kapps_Parameters SET ParameterOrder=16 WHERE ParameterID='EAN13VALID'
			UPDATE u_Kapps_Parameters SET ParameterDescription='EAN13 válidos para quantidade e peso' WHERE ParameterID='EAN13VALID'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Usa Prefixo EAN128' WHERE ParameterID='PREFIX'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Usa EAN13' WHERE ParameterID='USEEAN13'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Usa EAN128' WHERE ParameterID='USEEAN128'
			
			INSERT INTO u_Kapps_Events(EventID, EventDescription) VALUES ('EVT_BTN_PRINT_STOCKS','Botão de impressão nas contagens assitidas')
		
			
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Título do campo a mostrar no ecrã' 
			WHERE ParameterID in ('LIN_USER_FIELD1_NAME','LIN_USER_FIELD2_NAME','LIN_USER_FIELD3_NAME'
								 ,'CAB_USER_FIELD1_NAME','CAB_USER_FIELD2_NAME','CAB_USER_FIELD3_NAME')

			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)' WHERE ParameterID in ('CAB_USER_FIELD1_INTEGRATION_NAME', 'CAB_USER_FIELD2_INTEGRATION_NAME', 'CAB_USER_FIELD3_INTEGRATION_NAME')
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)' WHERE ParameterID in ('LIN_USER_FIELD1_INTEGRATION_NAME', 'LIN_USER_FIELD2_INTEGRATION_NAME', 'LIN_USER_FIELD3_INTEGRATION_NAME')
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Ex: ORDER BY Number' WHERE ParameterID in ('RECEORDERBYDOC', 'PACKORDERBYDOC', 'PICKORDERBYDOC')
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Ex: ORDER BY Description' WHERE ParameterID in ('RECEORDERBYLIN', 'PACKORDERBYLIN', 'PICKORDERBYLIN')
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'S-Sim N-Não' WHERE ParameterID='EAN1128_LOCKLOTE' 			
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Armazém a utilizar por defeito. Se não indicar nenhum pergunta sempre que iniciar a aplicação.' WHERE ParameterID='WAREHOUSE'
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Apresenta teclado para quantidade automaticamente após leitura de CB 1-Sim/0-Não.' WHERE ParameterID='NOQTY'
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Permite substituir artigo não existente no documento por outra referencia'+ CHAR(13)+CHAR(10)+'0-Não 1-Sim' WHERE ParameterID='ProductReplacement'

			UPDATE u_Kapps_Parameters SET ParameterDefaultValue = '0' WHERE ParameterID='MORE_LINES_SAME_PRODUCT'
			UPDATE u_Kapps_Parameters SET ParameterDefaultValue = '0' WHERE ParameterID='ADDBARCODE'
			UPDATE u_Kapps_Parameters SET ParameterDefaultValue = '0' WHERE ParameterID='ProductReplacement'
			UPDATE u_Kapps_Parameters SET ParameterDefaultValue = '0' WHERE ParameterID='MIN_LEGHT'
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Apenas usado no ERP Eticadata' WHERE ParameterID='INV_CNT'

			UPDATE u_Kapps_Parameters SET ParameterInfo = 'ERP: Primavera, Sage50c, Sage100, Sendsys'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+'   Série de destino dos documentos a integrar'
			+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+'ERP: Eticadata'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+'   Secção de destino dos documentos a integrar' WHERE ParameterID='Seccao'


			--UPDATE u_Kapps_Parameters SET ParameterInfo = 'Opçoes disponíveis por ordem:'+ CHAR(13)+CHAR(10)
			--+'Picking, Packing, Receção, Criar Documento, Contagens, Consultas, Verificar Preço, Stock Armazéns'+ CHAR(13)+CHAR(10)+
			--+ CHAR(13)+CHAR(10)+
			--+'Ex. 8,2,3,4,5,6,7,1'+ CHAR(13)+CHAR(10)+
			--+'Mostra'+ CHAR(13)+CHAR(10)+'Stock Armazéns, Picking, Packing, Receção, Criar Documento, Contagens, Consultas, Verificar Preço'	WHERE ParameterID='ORDER' and ParameterGroup='MENU'
			
			--UPDATE u_Kapps_Parameters SET ParameterInfo = 'Opçoes disponíveis por ordem:'+ CHAR(13)+CHAR(10)
			--+'Picking, Packing, Receção, Criar Documento, Contagens, Consultas, Verificar Preço, Stock Armazéns'+ CHAR(13)+CHAR(10)+
			--+ CHAR(13)+CHAR(10)+
			--+'Ex. 1,1,0,0,0,0,1,0'+ CHAR(13)+CHAR(10)+'Apenas fica disponivel Picking, Packing e Verificar Preço' WHERE ParameterID='VISIBLE' and ParameterGroup='MENU'
			

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Título do campo de utilizador 1' WHERE ParameterID='CAB_USER_FIELD1_NAME'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Título do campo de utilizador 2' WHERE ParameterID='CAB_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Título do campo de utilizador 3' WHERE ParameterID='CAB_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Nome do campo de utilizador 1 onde vai integrar' WHERE ParameterID='CAB_USER_FIELD1_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Nome do campo de utilizador 2 onde vai integrar' WHERE ParameterID='CAB_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Nome do campo de utilizador 3 onde vai integrar' WHERE ParameterID='CAB_USER_FIELD3_INTEGRATION_NAME'

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Tipo do campo de utilizador 1' WHERE ParameterID='CAB_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Tipo do campo de utilizador 2' WHERE ParameterID='CAB_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Tipo do campo de utilizador 3' WHERE ParameterID='CAB_USER_FIELD3_TYPE'

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Tamanho do campo de utilizador 1' WHERE ParameterID='CAB_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Tamanho do campo de utilizador 2' WHERE ParameterID='CAB_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Documento: Tamanho do campo de utilizador 3' WHERE ParameterID='CAB_USER_FIELD3_SIZE'

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Título do campo de utilizador 1' WHERE ParameterID='LIN_USER_FIELD1_NAME'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Título do campo de utilizador 2' WHERE ParameterID='LIN_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Título do campo de utilizador 3' WHERE ParameterID='LIN_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Nome do campo de utilizador 1 onde vai integrar' WHERE ParameterID='LIN_USER_FIELD1_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Nome do campo de utilizador 2 onde vai integrar' WHERE ParameterID='LIN_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Nome do campo de utilizador 3 onde vai integrar' WHERE ParameterID='LIN_USER_FIELD3_INTEGRATION_NAME'

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Tipo do campo de utilizador 1' WHERE ParameterID='LIN_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Tipo do campo de utilizador 2' WHERE ParameterID='LIN_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Tipo do campo de utilizador 3' WHERE ParameterID='LIN_USER_FIELD3_TYPE'

			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Tamanho do campo de utilizador 1' WHERE ParameterID='LIN_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Tamanho do campo de utilizador 2' WHERE ParameterID='LIN_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Tamanho do campo de utilizador 3' WHERE ParameterID='LIN_USER_FIELD3_SIZE'

			UPDATE u_Kapps_Parameters SET ParameterOrder=10 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=11 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD3_INTEGRATION_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=15 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=16 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=17 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD3_SIZE'

			UPDATE u_Kapps_Parameters SET ParameterOrder=12 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=13 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=14 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD3_TYPE'

			UPDATE u_Kapps_Parameters SET ParameterOrder=7 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=8 WHERE ParameterType='OTHERS' and ParameterID='CAB_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=22 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=23 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD3_INTEGRATION_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=27 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=28 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=29 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD3_SIZE'

			UPDATE u_Kapps_Parameters SET ParameterOrder=24 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=25 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=26 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD3_TYPE'

			UPDATE u_Kapps_Parameters SET ParameterOrder=19 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=20 WHERE ParameterType='OTHERS' and ParameterID='LIN_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=29 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=30 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=32 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=33 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD3_INTEGRATION_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=35 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=36 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=37 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD3_TYPE'

			UPDATE u_Kapps_Parameters SET ParameterOrder=38 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=39 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=40 WHERE ParameterType='PACKING' and ParameterID='CAB_USER_FIELD3_SIZE'

			UPDATE u_Kapps_Parameters SET ParameterOrder=44 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=45 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD3_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=49 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=50 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=51 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD3_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=46 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=47 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=48 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD3_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=41 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=42 WHERE ParameterType='PACKING' and ParameterID='LIN_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=32 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=33 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD3_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=37 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=38 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=39 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD3_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=34 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=35 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=36 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD3_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=29 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=30 WHERE ParameterType='PICKING' and ParameterID='CAB_USER_FIELD3_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=44 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=45 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD3_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=49 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=50 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=51 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD3_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=46 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=47 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=48 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD3_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=41 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=42 WHERE ParameterType='PICKING' and ParameterID='LIN_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=29 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=30 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=32 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=33 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD3_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=34 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=35 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=36 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD3_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=37 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=38 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=39 WHERE ParameterType='STORE IN' and ParameterID='CAB_USER_FIELD3_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=41 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD2_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=42 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD3_NAME'

			UPDATE u_Kapps_Parameters SET ParameterOrder=44 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD2_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=45 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD3_INTEGRATION_NAME'
			UPDATE u_Kapps_Parameters SET ParameterOrder=46 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD1_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=47 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD2_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=48 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD3_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=49 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD1_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=50 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD2_SIZE'
			UPDATE u_Kapps_Parameters SET ParameterOrder=51 WHERE ParameterType='STORE IN' and ParameterID='LIN_USER_FIELD3_SIZE'

			UPDATE u_Kapps_Parameters set ParameterDescription='Código da moeda por defeito na integração com (Sage 50C/Sage 100C/Sendys)' WHERE ParameterID='MOEDA' and ParameterType='USR'
			UPDATE u_Kapps_Parameters set ParameterDescription='Código do setor por defeito na integração com Sage 100C' WHERE ParameterID='SETOR' and ParameterType='USR'

			UPDATE u_Kapps_Parameters set ParameterDescription='Documento de destino pelo mesmo índex do documento de origem' WHERE ParameterID='INTEGRATION_BY_INDEX'
			UPDATE u_Kapps_Parameters set ParameterDescription='Documentos: Query que corre ao selecionar um documento' WHERE ParameterID='MESSAGE_QUERY'
			UPDATE u_Kapps_Parameters set ParameterDescription='Documentos: Títulos para os cabeçalhos das 10 colunas adicionais' WHERE ParameterID='GRID1_ALIAS'
			UPDATE u_Kapps_Parameters set ParameterDescription='Documentos: 10 colunas de utilizador adicionais para os documentos' WHERE ParameterID='GRID1_COLUMNS'
			
			UPDATE u_Kapps_Parameters set ParameterDescription='Linhas: 10 colunas adicionais para as linhas do documento' WHERE ParameterID='GRID2_COLUMNS'
			UPDATE u_Kapps_Parameters set ParameterDescription='Linhas: Query que corre ao selecionar uma linha' WHERE ParameterID='MESSAGE_LINES_QUERY'
			UPDATE u_Kapps_Parameters set ParameterDescription='Linhas: Títulos para os cabeçalhos das colunas adicionais' WHERE ParameterID='GRID2_ALIAS'
			UPDATE u_Kapps_Parameters set ParameterDescription='Mostrar quantidade a picar por defeito' WHERE ParameterID='NOQTY'			
			UPDATE u_Kapps_Parameters set ParameterDescription='Ordenação das linhas a integrar' WHERE ParameterID='ORDER_INTEGRATION'
			UPDATE u_Kapps_Parameters set ParameterDescription='Prefixo para código da caixa gerada pela app logística' WHERE ParameterID='AUTONAME' and ParameterType='PACKING'
			UPDATE u_Kapps_Parameters set ParameterDescription='Substituir referencias' WHERE ParameterID='ProductReplacement' and ParameterType='USR'
			UPDATE u_Kapps_Parameters set ParameterDescription='Tipo do Campo de Utilizador 3 das linhas' WHERE ParameterID='LIN_USER_FIELD3_TYPE'
			UPDATE u_Kapps_Parameters set ParameterDescription='Tipos de documentos que dão origem à receção' WHERE ParameterID='SRC_DOSSIER' and ParameterType='STORE IN'
			UPDATE u_Kapps_Parameters set ParameterDescription='Tipos de documentos que dão origem ao packing.' WHERE ParameterID='SRC_DOSSIER' and ParameterType='PACKING'
			UPDATE u_Kapps_Parameters set ParameterDescription='Tipos de documentos que dão origem ao picking.' WHERE ParameterID='SRC_DOSSIER' and ParameterType='PICKING'
			UPDATE u_Kapps_Parameters set ParameterDescription='Mostrar todos os documentos até a data atual' WHERE ParameterID='DOC_DATE'
			UPDATE u_Kapps_Parameters set ParameterDescription='Criar e associar código de barras inexistente a produto' WHERE ParameterID='ADDBARCODE'
			UPDATE u_Kapps_Parameters set ParameterDescription='Vários utilizadores para o mesmo documento' WHERE ParameterID='MULTI_USERS'
			UPDATE u_Kapps_Parameters set ParameterDescription='Adicionar novo produto' WHERE ParameterID='NEW_PRD'
			UPDATE u_Kapps_Parameters set ParameterDescription='Aceita quantidades superiores ao documento de origem' WHERE ParameterID='QTY_CTRL' and ParameterType='GENERAL'
			UPDATE u_Kapps_Parameters set ParameterDescription='Aceita stock negativo' WHERE ParameterID='STOCK_CTRL' and ParameterType='GENERAL'
	
			ALTER TABLE u_Kapps_DossierLin ADD ExpeditionWarehouse nvarchar(50) NULL
			ALTER TABLE u_Kapps_DossierLin ADD ExpeditionLocation nvarchar(50) NULL

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(59, @APPCODE, 'STORE IN', 'DEFAULT','USE_RECEPTION_LOCATIONS','Usar apenas localizações do tipo receção','0','0','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Se usar localizações do tipo receção não permite escolher outras localizações',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(53, @APPCODE, 'PICKING', 'DEFAULT','USE_EXPEDITION','Usar localização de expedição','0','0','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Antes de integrar é pedida a localização de expedição',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(53, @APPCODE, 'PACKING', 'DEFAULT','USE_EXPEDITION','Usar localização de expedição','0','0','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Antes de integrar é pedida a localização de expedição',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Parameters 
			LEFT JOIN u_Kapps_Processes p ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE p.ProcessID is not null and ParameterID='USE_EXPEDITION'	and ParameterGroup='DEFAULT'


			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(53, @APPCODE, 'PRICECHECKING', 'DEFAULT','TITLELABEL1','Título do campo User1','','',''+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Título do campo User1 que é mostrado na opção consulta de Preços',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(53, @APPCODE, 'PRICECHECKING', 'DEFAULT','TITLELABEL2','Título do campo User2','','',''+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Título do campo User2 que é mostrado na opção consulta de Preços',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='TITLELABEL1' OR ParameterID='TITLELABEL2') and ParameterGroup='DEFAULT' and p.TypeID='PRICECHECKING'

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			VALUES (@APPCODE, N'EAN128', N'EAN128', CAST(4 AS Numeric(18, 0)), N'USAR_KEYWORD_QTYLABELS', N'Enviar para a impressora uma etiqueta de cada vez?', N'0', N'0', N'0-Não / 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)
			+'0 - Usar a KEYWORD QTYLABELS na etiqueta para definir a quantidade a imprimir'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)
			+'1 - Vai criar um trabalho de impressão para cada etiqueta', N'0', N'0', N'')
			
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Pode definir mais do que um AI separado por virgulas'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Consultar a lista de AI na pasta Documentation' 
			WHERE ParameterID in ('AILOTE', 'AINUMEROSERIE', 'AINUMEROSERIE', 'AIQUANTIDADE', 'AIREFERENCIA', 'AIVALIDADELOTE')

			--v2 v39
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(54, @APPCODE, 'PICKING', 'DEFAULT', 'MODIFY_DELIVERY', 'Permite alterar o local de descarga','0','0','(0-Não permite 1-Permite)',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(54, @APPCODE, 'PACKING', 'DEFAULT', 'MODIFY_DELIVERY', 'Permite alterar o local de descarga','0','0','(0-Não permite 1-Permite)',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(31, @APPCODE, 'OTHERS', 'DEFAULT', 'MODIFY_DELIVERY', 'Permite alterar o local de descarga','0','0','(0-Não permite 1-Permite)',0,0)
			
			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='MODIFY_DELIVERY') and ParameterGroup='DEFAULT' and p.TypeID in ('PICKING','PACKING','OTHERS')			

			--v2 v40
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(10, @APPCODE, 'USR', 'DEFAULT', 'LINHA_ESPECIAL','No documento a gerar incluir linhas com a indicação dos documentos originais','0','0','(0-Não 1-Sim) Apenas para o ERP Primavera',0,0)								
			
			--v2 v41
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(54, @APPCODE, 'PACKING', 'DEFAULT', 'BOX_AUTO_OPEN','Após adicionar um artigo, mostrar opção de fechar a caixa / abrir uma caixa nova','0','0','(0-Não 1-Sim)',0,0)
			
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(55, @APPCODE, 'PACKING', 'DEFAULT' ,'DEFAULT_BOX','Caixa a usar por defeito','','','Indicar a caixa a usar por defeito'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Ao abrir uma caixa nova usa sempre a mesma e não mostra o ecrã de seleção e detalhes da caixa',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='BOX_AUTO_OPEN') and ParameterGroup='DEFAULT' and p.TypeID='PACKING'

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='DEFAULT_BOX') and ParameterGroup='DEFAULT' and p.TypeID='PACKING'

			INSERT INTO u_Kapps_Events(EventID, EventDescription) VALUES ('EVT_ON_CLOSE_PICKING', 'Imprimir Picking List depois de integrar o picking')
			INSERT INTO u_Kapps_Events(EventID, EventDescription) VALUES ('EVT_ON_CLOSE_PACKING', 'Imprimir Packing List depois de fechar a caixa')

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(9, @APPCODE, 'MAIN', 'MAIN','ULOL','','','','',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(10, @APPCODE, 'MAIN', 'MAIN','LSER','','','','',0,0)

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(11, @APPCODE, 'MAIN', 'MAIN','LSERP','','','','',0,0)
		END
		IF (@DatabaseVersion < 49)
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_u_Kapps_Parameters_Group_ID] ON [u_Kapps_Parameters] ([ParameterGroup],[ParameterID])
			
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup,
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(10, @APPCODE, 'EAN128', 'EAN128', 'AISSCC','AI do EAN128 para o SSCC','00','00','Ver lista na pasta documentation',0,0)

			--v2 v43
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(60, @APPCODE, 'STORE IN', 'DEFAULT' ,'FECHAR_DOC_ORIGEM','Fechar o documento de origem','0','0',
			'0 - Ao integrar o documento confirma se pretende fechar o documento de origem'+CHAR(13)+CHAR(10)+
			'1 - Ao integrar o documento não confirma e fecha sempre o documento de origem'+CHAR(13)+CHAR(10)+
			'2 - Ao integrar o documento não confirma e nunca fecha o documento de origem',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='FECHAR_DOC_ORIGEM') and ParameterGroup='DEFAULT' and p.TypeID='STORE IN'

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(55, @APPCODE, 'PICKING', 'DEFAULT' ,'FECHAR_DOC_ORIGEM','Fechar o documento de origem','0','0',
			'0 - Ao integrar o documento confirma se pretende fechar o documento de origem'+CHAR(13)+CHAR(10)+
			'1 - Ao integrar o documento não confirma e fecha sempre o documento de origem'+CHAR(13)+CHAR(10)+
			'2 - Ao integrar o documento não confirma e nunca fecha o documento de origem',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='FECHAR_DOC_ORIGEM') and ParameterGroup='DEFAULT' and p.TypeID='PICKING'

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(56, @APPCODE, 'PACKING', 'DEFAULT' ,'FECHAR_DOC_ORIGEM','Fechar o documento de origem','0','0',
			'0 - Ao integrar o documento confirma se pretende fechar o documento de origem'+CHAR(13)+CHAR(10)+
			'1 - Ao integrar o documento não confirma e fecha sempre o documento de origem'+CHAR(13)+CHAR(10)+
			'2 - Ao integrar o documento não confirma e nunca fecha o documento de origem',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='FECHAR_DOC_ORIGEM') and ParameterGroup='DEFAULT' and p.TypeID='PACKING'
		END
		IF (@DatabaseVersion < 50)
		BEGIN
			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, Username, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Parameters
			LEFT JOIN u_Kapps_Users on 1=1  
 			WHERE ParameterGroup='DEFAULT' and ParameterType='USR' and Username is not null	and (ParameterID='LINHA_ESPECIAL') 
			
			UPDATE u_Kapps_Parameters SET ParameterERP='Primavera;' WHERE ParameterID='LINHA_ESPECIAL' and ParameterType='USR'
			UPDATE u_Kapps_Parameters SET ParameterERP='Sage_50C;' WHERE ParameterERP='Sage_50C'
			
			ALTER TABLE u_Kapps_DossierLin ADD StockBreakReason nvarchar(300) NOT NULL DEFAULT ('') WITH VALUES
		END
		IF (@DatabaseVersion < 51) --v2 v44
		BEGIN
			UPDATE u_Kapps_Parameters SET ParameterDescription = 'Linha: Tipo do campo de utilizador 3' WHERE ParameterID='LIN_USER_FIELD3_TYPE'
			UPDATE u_Kapps_Parameters SET ParameterValue='Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])' WHERE ParameterID='QUALITY_SUBJECT'
			UPDATE u_Kapps_Parameters SET ParameterDefaultValue='Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])' WHERE ParameterID='QUALITY_SUBJECT'
			UPDATE u_Kapps_Parameters SET ParameterInfo='Assunto para envio de emails qualidade'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser usadas as keywords [NOME_ENTIDADE] e [DATA_HORA]' WHERE ParameterID='QUALITY_SUBJECT'
			UPDATE u_Kapps_Parameters SET ParameterInfo='Nome do utilizador e email separado por ;'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'ex:'+CHAR(13)+CHAR(10)+'Pedro Neves;pedroneves@gmail.com' WHERE ParameterID = 'QUALITY_SENDER_NAME'
			UPDATE u_Kapps_Parameters SET ParameterInfo='Endereços de email separados por ;'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'ex:'+CHAR(13)+CHAR(10)+'armazem@hotmail.com;responsavel@gmail.com' WHERE ParameterID = 'QUALITY_SENDER_EMAIL'
			UPDATE u_Kapps_Parameters SET ParameterID='QUALITY_TO_EMAIL' WHERE ParameterID='QUALITY_SENDER_EMAIL'
			

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(60, @APPCODE, 'PACKING', 'DEFAULT','QUALITY_NOTIFY','Notifica por email os produtos não conformes?','','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(61, @APPCODE, 'PACKING', 'DEFAULT','QUALITY_SENDER_NAME','Utilizador que envia os emails qualidade','','','Nome do utilizador e email separado por ;'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'ex:'+CHAR(13)+CHAR(10)+'Pedro Neves;pedroneves@gmail.com',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(62, @APPCODE, 'PACKING', 'DEFAULT','QUALITY_TO_EMAIL','Email dos destinatários para envio de emails qualidade','','','Endereços de email separados por ;'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'ex:'+CHAR(13)+CHAR(10)+'armazem@hotmail.com;responsavel@gmail.com',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(63, @APPCODE, 'PACKING', 'DEFAULT','QUALITY_SUBJECT','Assunto para envio de emails qualidade','Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])','Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])','Assunto para envio de emails qualidade'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser usadas as keywords [NOME_ENTIDADE] e [DATA_HORA]',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('QUALITY_NOTIFY','QUALITY_SENDER_NAME','QUALITY_TO_EMAIL','QUALITY_SUBJECT') and ParameterGroup='DEFAULT' and p.TypeID='PACKING'


			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(60, @APPCODE, 'PICKING', 'DEFAULT','QUALITY_NOTIFY','Notifica por email os produtos não conformes?','','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(61, @APPCODE, 'PICKING', 'DEFAULT','QUALITY_SENDER_NAME','Utilizador que envia os emails qualidade','','','Nome do utilizador e email separado por ;'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'ex:'+CHAR(13)+CHAR(10)+'Pedro Neves;pedroneves@gmail.com',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(62, @APPCODE, 'PICKING', 'DEFAULT','QUALITY_TO_EMAIL','Email dos destinatários para envio de emails qualidade','','','Endereços de email separados por ;'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'ex:'+CHAR(13)+CHAR(10)+'armazem@hotmail.com;responsavel@gmail.com',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(63, @APPCODE, 'PICKING', 'DEFAULT','QUALITY_SUBJECT','Assunto para envio de emails qualidade','Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])','Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])','Assunto para envio de emails qualidade'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser usadas as keywords [NOME_ENTIDADE] e [DATA_HORA]',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('QUALITY_NOTIFY','QUALITY_SENDER_NAME','QUALITY_TO_EMAIL','QUALITY_SUBJECT') and ParameterGroup='DEFAULT' and p.TypeID='PICKING'
		END
		IF (@DatabaseVersion < 52)
		BEGIN
			ALTER TABLE u_Kapps_DossierLin ADD ProductionDate datetime

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(17, @APPCODE, 'EAN128', 'EAN128', 'LOCATION_PREFIX', 'Prefixo dos códigos de barras de localizações','','','O prefixo é usado para verificar se o código de barras lido é uma localização',0,0)				

			UPDATE u_Kapps_Parameters SET ParameterInfo=
			N'0 - Transferência com destino conhecido'+ CHAR(13)+CHAR(10)+
			N'1 - Transferência sem destino conhecido'+ CHAR(13)+CHAR(10)+
			N'2 - Transferência directa de um produto dentro do mesmo armazém'+ CHAR(13)+CHAR(10)+ --directa
			N'3 - Transferência dois passos entre armazéns'+ CHAR(13)+CHAR(10)+ --dois passos
			N'4 - Transferência directa de uma localização completa para outra localização dentro do mesmo armazém'+ CHAR(13)+CHAR(10)+
			N'5 - Transferência dois passos de uma localização para várias localizações dentro do mesmo armazém'
			WHERE ParameterID='TIPO_TRANSFERENCIA';	
			


			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(30, @APPCODE, 'TRANSF', 'DEFAULT', 'USE_SERIALNUMBER', 'Gere números de série','1','1','0 - Não é pedido o número de série nos artigos que na view v_Kapps_Articles venham com o valor 2 no campo UseSerialNumber'
			+ CHAR(13)+CHAR(10)+'1 - Gere números de série',0,0)				

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='USE_SERIALNUMBER') and ParameterGroup='DEFAULT' and p.TypeID='TRANSF'
		END
		IF (@DatabaseVersion < 54)
		BEGIN	
			ALTER TABLE u_Kapps_PackingDetails ADD Location nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES
		END
		IF (@DatabaseVersion < 55)
		BEGIN	
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, 
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(1, @APPCODE, 'STOCKS', 'DEFAULT','QUANTITY_AVAILABLE','Mostrar a quantidade disponível','0','0','0-Não 1-Sim (Quantidades são atribuidas na SP_u_Kapps_ProductStockUSR)',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID='QUANTITY_AVAILABLE' and ParameterGroup='DEFAULT' and p.TypeID='STOCKS'
		END
		IF (@DatabaseVersion < 56) --v2 v45 v46 e v47
		BEGIN	
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(61, @APPCODE, 'STORE IN', 'DEFAULT','CAB_FIELDS_REQUIRED','Documento: Campos de utilizador obrigatórios','0','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(62, @APPCODE, 'STORE IN', 'DEFAULT','LIN_FIELDS_REQUIRED','Linha: Campos de utilizador obrigatórios','0','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(64, @APPCODE, 'PICKING', 'DEFAULT','CAB_FIELDS_REQUIRED','Documento: Campos de utilizador obrigatórios','0','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(65, @APPCODE, 'PICKING', 'DEFAULT','LIN_FIELDS_REQUIRED','Linha: Campos de utilizador obrigatórios','0','0','0-Não 1-Sim',0,0)
			
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(64, @APPCODE, 'PACKING', 'DEFAULT','CAB_FIELDS_REQUIRED','Documento: Campos de utilizador obrigatórios','0','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(65, @APPCODE, 'PACKING', 'DEFAULT','LIN_FIELDS_REQUIRED','Linha: Campos de utilizador obrigatórios','0','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(32, @APPCODE, 'OTHERS', 'DEFAULT','CAB_FIELDS_REQUIRED','Documento: Campos de utilizador obrigatórios','0','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(33, @APPCODE, 'OTHERS', 'DEFAULT','LIN_FIELDS_REQUIRED','Linha: Campos de utilizador obrigatórios','0','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('CAB_FIELDS_REQUIRED','LIN_FIELDS_REQUIRED') and ParameterGroup='DEFAULT' and p.TypeID in ( 'STORE IN', 'PICKING', 'PACKING', 'OTHERS')


			DELETE FROM u_Kapps_Parameters where ParameterID in ('GRID1_QUERY','GRID2_QUERY', 'GRID1_COLUMNS', 'GRID2_COLUMNS')
			
		END
		IF (@DatabaseVersion < 57)
		BEGIN	
			ALTER TABLE u_Kapps_StockLines ADD Validade VARCHAR(8)
			ALTER TABLE u_Kapps_StockLines ADD CONSTRAINT [DF_u_Kapps_StockLines_Validade] DEFAULT ('') FOR [Validade]
			ALTER TABLE u_Kapps_StockLines ADD ProductionDate VARCHAR(8)
			ALTER TABLE u_Kapps_StockLines ADD CONSTRAINT [DF_u_Kapps_StockLines_ProductionDate] DEFAULT ('') FOR [ProductionDate]
		
			SET @SQL = 'UPDATE u_Kapps_StockLines SET Validade='''', ProductionDate='''''
			exec sp_executesql @SQL
					
			SET @SQL = 'ALTER TABLE u_Kapps_DossierLin ADD TempProductionDate VARCHAR(8);'
			exec sp_executesql @SQL
			
			SET @SQL='UPDATE u_Kapps_DossierLin SET TempProductionDate = ISNULL(CONVERT(VARCHAR,ProductionDate , 112)	,'''');'
			exec sp_executesql @SQL
			
			SET @SQL='ALTER TABLE u_Kapps_DossierLin DROP COLUMN ProductionDate;'
			exec sp_executesql @SQL
			
			SET @SQL='ALTER TABLE u_Kapps_DossierLin ADD ProductionDate VARCHAR(8);'
			exec sp_executesql @SQL
			
			SET @SQL='UPDATE u_Kapps_DossierLin SET ProductionDate = TempProductionDate;'
			exec sp_executesql @SQL
			
			SET @SQL='ALTER TABLE u_Kapps_DossierLin DROP COLUMN TempProductionDate;'
			exec sp_executesql @SQL
			
			ALTER TABLE u_Kapps_DossierLin ADD CONSTRAINT [DF_u_Kapps_DossierLin_ProductionDate] DEFAULT ('') FOR [ProductionDate]
			
			UPDATE u_Kapps_Parameters SET ParameterInfo='0-Não / 1-Sim' WHERE ParameterID in ('EAN1128_LOCKLOTE')
		END
		IF (@DatabaseVersion < 58)
		BEGIN	
			CREATE TABLE [u_Kapps_InquiryHeader](
				[InquiryHeaderUniqueID] [nvarchar](100) NOT NULL,
				[Description] [nvarchar](100) NULL,
			 CONSTRAINT [PK_u_Kapps_InquiryHeader] PRIMARY KEY CLUSTERED 
			(
				[InquiryHeaderUniqueID] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]

			CREATE TABLE [u_Kapps_InquiryQuestions](
				[InquiryHeaderUniqueID] [nvarchar](100) NOT NULL,
				[InquiryQuestionUniqueID] [nvarchar](100) NOT NULL,
				[InquiryQuestionPosition] [int] NULL,
				[InquiryQuestionName] [nvarchar](100) NULL,
				[InquiryQuestionType] [nvarchar](1) NULL,
				[InquiryQuestionMinValue] [numeric](11, 3) NULL,
				[InquiryQuestionMaxValue] [numeric](11, 3) NULL,
				[InquiryQuestionMandatory] [nvarchar](1) NULL,
				[InquiryQuestionAnswerList] [nvarchar](1000) NULL,
				[InquiryQuestionAutoFill] [nvarchar](1) NULL,
			 CONSTRAINT [PK_u_Kapps_InquiryQuestions] PRIMARY KEY CLUSTERED 
			(
				[InquiryHeaderUniqueID] ASC,
				[InquiryQuestionUniqueID] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]

			CREATE TABLE [u_Kapps_InquiryQuestionsAnswers](
				[InquiryAnswersHeaderUniqueID] [nvarchar](100) NULL,
				[InquiryQuestionsAnswerUniqueID] [nvarchar](100) NOT NULL,
				[InquiryHeaderID] [nvarchar](100) NULL,
				[QuestionID] [nvarchar](100) NULL,
				[QuestionName] [nvarchar](100) NULL,
				[QuestionType] [nvarchar](1) NULL,
				[QuestionAnswer] [nvarchar](1000) NULL,
				[AutoFill] [nvarchar](1) NULL,
			 CONSTRAINT [PK_InquiryQuestionsAnswers] PRIMARY KEY CLUSTERED 
			(
				[InquiryQuestionsAnswerUniqueID] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]

			CREATE TABLE [u_Kapps_InquiryAnswersHeader](
				[InquiryAnswerHeaderUniqueID] [nvarchar](100) NOT NULL,
				[InquiryAnswerHeaderID] [nvarchar](100) NOT NULL,
				[InquiryDescription] [nvarchar](100) NULL,
				[InquiryDate] [nvarchar](8) NULL,
				[InquiryTime] [nvarchar](6) NULL,
				[InquiryUser] [nvarchar](50) NULL,
				[SyslogProcessType] [nvarchar](100) NULL,
				[SyslogProcessID] [nvarchar](100) NULL,
				[EntityID] [nvarchar](50) NULL,
				[EntityType] [nvarchar](50) NULL,
				[EntityName] [nvarchar](100) NULL,
			 CONSTRAINT [PK_u_Kapps_InquiryAnswersHeader] PRIMARY KEY CLUSTERED 
			(
				[InquiryAnswerHeaderUniqueID] ASC,
				[InquiryAnswerHeaderID] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]

			CREATE TABLE [u_Kapps_Messages](
				[MesssageUniqueID] [varchar](100) NOT NULL,
				[SentBy] [varchar](50) NULL,
				[SentDate] [varchar](8) NULL,
				[SentTime] [varchar](6) NULL,
				[SentTo] [varchar](50) NULL,
				[Message] [varchar](1000) NULL,
				[Read] [varchar](1) NULL,
				[ReadDate] [varchar](8) NULL,
				[ReadTime] [varchar](6) NULL,
				[Priority] [varchar](50) NULL,
			 CONSTRAINT [PK_u_Kapps_Messages] PRIMARY KEY CLUSTERED 
			(
				[MesssageUniqueID] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]

		END
		IF (@DatabaseVersion < 59)
		BEGIN
			ALTER TABLE u_Kapps_Messages ADD OriginMessageID varchar(100) NOT NULL DEFAULT ('') WITH VALUES

			UPDATE u_Kapps_Parameters set ParameterDescription='Utilizadores necessitam de PIN para efetuar login' WHERE ParameterID='USER_PIN'
			UPDATE u_Kapps_Parameters set ParameterDescription='Usar localizações?' WHERE ParameterID='USE_LOCATIONS'
			UPDATE u_Kapps_Parameters set ParameterInfo='Pode definir mais do que um AI separado por virgulas'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+'Consultar https://www.gs1-128.info/application-identifiers/' WHERE ParameterType='EAN128' and ParameterDescription like 'AI %'
			UPDATE u_Kapps_Events set EventDescription='Ao confirmar quantidade no picking' WHERE EventID='EVT_ON_QTY_CNF_PICK'
			UPDATE u_Kapps_ParametersTypes set DefaultDescription='Consulta de preços' WHERE TypeID='PRICECHECKING'
			UPDATE u_Kapps_ParametersTypes set DefaultDescription='Consulta de stock em armazém' WHERE TypeID='STOCKS'
			UPDATE u_Kapps_ParametersTypes set DefaultDescription='Consultas e operações diversas' WHERE TypeID='QUERIES'
			UPDATE u_Kapps_Parameters set ParameterDescription='Série do documento de destino igual à do documento de origem' WHERE ParameterID='SERIE_ORIGEM'
			UPDATE u_Kapps_Parameters set ParameterDescription='Apresentar automaticamente o teclado para indicar quantidade a picar?', ParameterInfo='1-Sim/0-Não.' WHERE ParameterID='AUTOQTY'		
			
			ALTER TABLE u_Kapps_Users ADD AcessoBackoffice varchar(1) NULL DEFAULT ('') WITH VALUES
			ALTER TABLE u_Kapps_Users ADD AcessoTerminal varchar(1) NULL DEFAULT ('') WITH VALUES
		END
		IF (@DatabaseVersion < 60)
		BEGIN
			CREATE TABLE [u_Kapps_InquirySchedule](
				[id] [int] IDENTITY(1,1) NOT NULL,
				[InquiryID] [nvarchar](100) NULL,
				[InitialDate] [nvarchar](50) NULL,
				[FinalDate] [nvarchar](8) NULL,
				[ProcessID] [nvarchar](25) NULL,
				[EntityType] [nvarchar](50) NULL,
				[EntityNumber] [nvarchar](50) NULL,
				[Actif] [nvarchar](1) NULL,
				[ActiveWhen] [nvarchar](1) NULL
			) ON [PRIMARY]

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(106, @APPCODE, 'GENERAL', 'GENERAL','PICTURES_FOLDER','Pasta para guardar as fotografias e desenhos dos inquéritos','','','Por defeito guarda na pasta Syncro configurada no MIS communicator',0,0)

			UPDATE u_Kapps_Parameters SET ParameterValue='Eticadata_16/17/18/19' where ParameterID='ERP' and ParameterValue='Eticadata_16'
		END
		IF (@DatabaseVersion < 61)
		BEGIN
			DELETE FROM u_Kapps_Parameters where ParameterID='GRID1_COL_DIM'
			DELETE FROM u_Kapps_Parameters where ParameterID='GRID2_COL_DIM'
			
			UPDATE u_Kapps_Parameters SET ParameterDescription='Documentos: Títulos para os cabeçalhos das 10 colunas (UserCol1,UserCol2,...)',
			ParameterInfo='Deve indicar os nomes das colunas separados por virgula, ex: Nome,Data,Estado'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Estas colunas são usadas nos filtros'
			WHERE ParameterID='GRID1_ALIAS'

			UPDATE u_Kapps_Parameters SET ParameterDescription='Linhas: Títulos para os cabeçalhos das 10 colunas (UserCol1,UserCol2,...)', 
			ParameterInfo='Deve indicar os nomes das colunas separados por virgula, ex: Nome,Data,Estado'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Estas colunas são usadas nos filtros' 
			WHERE ParameterID='GRID2_ALIAS'

			UPDATE u_Kapps_Parameters SET ParameterDescription='Documentos: Tipos de dados das 10 colunas (UserCol1,UserCol2,...)',
			ParameterInfo='Deve indicar os tipos das colunas separados por virgula, ex: s,d,n,s,s,s,s,s,s,s'+CHAR(13)+CHAR(10)
			+CHAR(13)+CHAR(10)+'s - alfanumérico'
			+CHAR(13)+CHAR(10)+'d - data'
			+CHAR(13)+CHAR(10)+'n - numérico'
			WHERE ParameterID='GRID1_COL_TYPE'

			UPDATE u_Kapps_Parameters SET ParameterDescription='Linhas: Tipos de dados das 10 colunas (UserCol1,UserCol2,...)',
			ParameterInfo='Deve indicar os tipos das colunas separados por virgula, ex: s,d,n,s,s,s,s,s,s,s'+CHAR(13)+CHAR(10)
			+CHAR(13)+CHAR(10)+'s - alfanumérico'
			+CHAR(13)+CHAR(10)+'d - data'
			+CHAR(13)+CHAR(10)+'n - numérico'
			WHERE ParameterID='GRID2_COL_TYPE'

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(9, @APPCODE, 'STORE IN', 'DEFAULT','DOC_OBS1'
			,'Documentos: Informação adicional primeira linha','',''
			,'Usada para mostrar informação adicional na lista de documentos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', cab.UserCol1 + cab.UserCol2 + cab.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT Observacoes FROM CabecCompras WHERE CabecCompras.ID=cab.ReceptionKey)',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(9, @APPCODE, 'STORE IN', 'DEFAULT','DOC_OBS2'
			,'Documentos: Informação adicional segunda linha','',''
			,'Usada para mostrar informação adicional na lista de documentos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', cab.UserCol1 + cab.UserCol2 + cab.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT CodPostal+'' ''+CodPostalLocalidade FROM CabecCompras WHERE CabecCompras.ID=cab.ReceptionKey)',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(15, @APPCODE, 'STORE IN', 'DEFAULT','LIN_OBS1'
			,'Linhas: Informação adicional','',''
			,'Usada para mostrar informação adicional na lista de artigos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', lin.UserCol1 + lin.UserCol2 + lin.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT convert(varchar(100), Observacoes) FROM Artigo Art WHERE Art.Artigo = lin.Article )',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(9, @APPCODE, 'PICKING', 'DEFAULT','DOC_OBS1'
			,'Documentos: Informação adicional primeira linha','',''
			,'Usada para mostrar informação adicional na lista de documentos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', cab.UserCol1 + cab.UserCol2 + cab.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT Observacoes FROM CabecDoc WHERE CabecDoc.ID=cab.PickingKey)',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(9, @APPCODE, 'PICKING', 'DEFAULT','DOC_OBS2'
			,'Documentos: Informação adicional segunda linha','',''
			,'Usada para mostrar informação adicional na lista de documentos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', cab.UserCol1 + cab.UserCol2 + cab.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT CodPostal+'' ''+CodPostalLocalidade FROM CabecDoc WHERE CabecDoc.ID=cab.PickingKey)',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(15, @APPCODE, 'PICKING', 'DEFAULT','LIN_OBS1'
			,'Linhas: Informação adicional','',''
			,'Usada para mostrar informação adicional na lista de artigos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', lin.UserCol1 + lin.UserCol2 + lin.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT convert(varchar(100), Observacoes) FROM Artigo Art WHERE Art.Artigo = lin.Article )',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(9, @APPCODE, 'PACKING', 'DEFAULT','DOC_OBS1'
			,'Documentos: Informação adicional primeira linha','',''
			,'Usada para mostrar informação adicional na lista de documentos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', cab.UserCol1 + cab.UserCol2 + cab.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT Observacoes FROM CabecDoc WHERE CabecDoc.ID=cab.PackingKey)',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(9, @APPCODE, 'PACKING', 'DEFAULT','DOC_OBS2'
			,'Documentos: Informação adicional segunda linha','',''
			,'Usada para mostrar informação adicional na lista de documentos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', cab.UserCol1 + cab.UserCol2 + cab.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT CodPostal+'' ''+CodPostalLocalidade FROM CabecDoc WHERE CabecDoc.ID=cab.PackingKey)',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(15, @APPCODE, 'PACKING', 'DEFAULT','LIN_OBS1'
			,'Linhas: Informação adicional','',''
			,'Usada para mostrar informação adicional na lista de artigos a picar'+
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', lin.UserCol1 + lin.UserCol2 + lin.UserCol3 '
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'outro exemplo usando SQL'
			+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+', (SELECT convert(varchar(100), Observacoes) FROM Artigo Art WHERE Art.Artigo = lin.Article )',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('DOC_OBS1','DOC_OBS2','LIN_OBS1') and ParameterGroup='DEFAULT' and p.TypeID in ( 'STORE IN', 'PICKING', 'PACKING')		
		END
		IF (@DatabaseVersion < 62)
		BEGIN
			ALTER TABLE u_Kapps_Messages ADD BlockingMessage varchar(1) NULL DEFAULT ('') WITH VALUES
			EXEC sp_RENAME 'u_Kapps_Messages.Read' , 'Readed', 'COLUMN'

			UPDATE u_Kapps_Parameters SET ParameterDescription='Regime de Iva' WHERE ParameterID='REGIME_IVA'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Reserva quantidades' WHERE ParameterType='USR' and ParameterID='RESERVA_QUANTIDADES'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Código da propriedade associada ao lote' WHERE ParameterType='USR' and ParameterID='COD_LOTE'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Código da moeda por defeito' WHERE ParameterType='USR' and ParameterID='MOEDA'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Código do setor por defeito' WHERE ParameterType='USR' and ParameterID='SETOR'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Secção (Eticadata) / Série (restantes ERPs)' WHERE ParameterType='USR' and ParameterID='SECCAO'
			UPDATE u_Kapps_Parameters SET ParameterInfo='(0-Não 1-Sim)' WHERE ParameterType='USR' and ParameterID='LINHA_ESPECIAL'
		END
		IF (@DatabaseVersion < 63)
		BEGIN
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(107, @APPCODE, 'GENERAL', 'GENERAL','TIMER_VERIFY_NEWMSG','Intervalo de tempo para verificar novas mensagens','15','15','Indicar valor em segundos, se indicar 0 nunca verifica',0,0)	
		END
		IF (@DatabaseVersion < 64)
		BEGIN
			DELETE FROM u_Kapps_Parameters WHERE ParameterID='ARTICLE_FILTER'
			
			ALTER TABLE u_Kapps_StockLines ADD InternalStampDoc nvarchar(50) NULL DEFAULT('') WITH VALUES

			CREATE TABLE [u_Kapps_StockDocs](
				[Stamp] [nvarchar](25) NOT NULL,
				[Warehouse] [nvarchar](50) NOT NULL,
				[Terminal] [int] NOT NULL,
				[DocDate] [datetime] NULL,
				[Status] [varchar](1) NOT NULL,
				[Syncr] [varchar](1) NOT NULL,
				[Name] [varchar](50) NULL,
			 CONSTRAINT [PK_u_Kapps_StockDocs] PRIMARY KEY CLUSTERED 
			(
				[Stamp] ASC
			) ON [PRIMARY]
			) ON [PRIMARY]
			ALTER TABLE [u_Kapps_StockDocs] ADD  CONSTRAINT [DF_u_Kapps_StockDocs_Stamp]  DEFAULT ('') FOR [Stamp]
			ALTER TABLE [u_Kapps_StockDocs] ADD  CONSTRAINT [DF_u_Kapps_StockDocs_Warehouse]  DEFAULT ('') FOR [Warehouse]
			ALTER TABLE [u_Kapps_StockDocs] ADD  CONSTRAINT [DF_u_Kapps_StockDocs_Terminal]  DEFAULT ((0)) FOR [Terminal]
			ALTER TABLE [u_Kapps_StockDocs] ADD  CONSTRAINT [DF_u_Kapps_StockDocs_Status]  DEFAULT ('') FOR [Status]
			ALTER TABLE [u_Kapps_StockDocs] ADD  CONSTRAINT [DF_u_Kapps_StockDocs_Syncr]  DEFAULT ('N') FOR [Syncr]
			ALTER TABLE [u_Kapps_StockDocs] ADD  CONSTRAINT [DF_u_Kapps_StockDocs_Name]  DEFAULT ('') FOR [Name]

			UPDATE u_Kapps_Parameters SET ParameterInfo=
			N'0 - Transferência com destino conhecido'+ CHAR(13)+CHAR(10)+
			N'1 - Transferência sem destino conhecido'+ CHAR(13)+CHAR(10)+
			N'2 - Transferência directa de um produto dentro do mesmo armazém'+ CHAR(13)+CHAR(10)+ 
			N'3 - Transferência dois passos entre localizações dentro do mesmo armazém'+ CHAR(13)+CHAR(10)+
			N'4 - Transferência directa de uma localização completa para outra localização dentro do mesmo armazém'+ CHAR(13)+CHAR(10)+
			N'5 - Transferência dois passos de uma localização para várias localizações dentro do mesmo armazém'
			WHERE ParameterID='TIPO_TRANSFERENCIA';	
			
			ALTER TABLE u_Kapps_Log ADD LogTerminal int NULL DEFAULT(0) WITH VALUES		

			UPDATE u_Kapps_Parameters SET ParameterDescription='Código do documento de inventário', ParameterERP='Eticadata_13;Eticadata_16/17/18/19;Sage_50C;Sage_100C;Sendys;' 
			WHERE ParameterID='TIPO_DOC_CONTAGENS' AND ParameterType='USR'

			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType)
			VALUES('Alterações na view v_Kapps_Stock_Documents.',1,64,0)
			
			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType)
			VALUES('Foi eliminada a stored procedure SP_u_Kapps_Products.',1,64,0)

			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType)
			VALUES('Alterações em SP_u_Kapps_BarCode, SP_u_Kapps_Dossiers, SP_u_Kapps_LinhasContagem, SP_u_Kapps_Contagem, SP_u_Kapps_ContagemUSR (novo parâmetro).',1,64,0)		
		END
		
		SET @APPCODE='SYT'
		
		IF (@DatabaseVersion < 65)
		BEGIN
			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, 'DEFAULT' as ParameterGroup, TypeID, ParameterOrder, ParameterID, ParameterDescription, ParameterDefaultValue AS ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Parameters 
			RIGHT JOIN u_Kapps_ParametersTypes ON TypeID in ( 'STORE IN', 'PICKING', 'PACKING')
			WHERE ParameterID='QTY_CTRL'

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, 
			(select ParameterValue from u_Kapps_parameters where ParameterID='QTY_CTRL' and ParameterGroup='GENERAL') as ParameterValue, 
			ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			LEFT JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID ='QTY_CTRL' and ParameterGroup='DEFAULT' and p.TypeID in ( 'STORE IN', 'PICKING', 'PACKING')
			
			DELETE from u_Kapps_parameters where ParameterID='QTY_CTRL' and ParameterGroup='GENERAL'			

			INSERT INTO u_Kapps_Parameters([AppCode], [ParameterGroup], [ParameterType], [ParameterOrder], [ParameterID], [ParameterDescription], [ParameterValue], [ParameterDefaultValue], [ParameterInfo], [ParameterRequired], [ParameterDependent], [ParameterERP]) 
			VALUES (@APPCODE, N'DEFAULT', N'INSPECTION', CAST(7 AS Numeric(18, 0)), N'ADDNEWINV', N'Permite criar contagens cegas', N'1', N'1', N'0-Não /1-Sim', N'0', N'0', N'')
			
			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			LEFT JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID ='ADDNEWINV' and ParameterGroup='DEFAULT' and p.TypeID='INSPECTION'

			UPDATE u_Kapps_Session_Docs SET AppCode='SYT' WHERE AppCode='AP0002'
			UPDATE u_Kapps_Session_Users SET AppCode='SYT' WHERE AppCode='AP0002'			
			UPDATE u_Kapps_Parameters SET AppCode='SYT' WHERE AppCode='AP0002'			

			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType)
			VALUES('SAGE50c alterações na view v_Kapps_Stock.',1,65,0)

			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType)
			VALUES('PHC alterações na view v_Kapps_Barcodes',1,65,0)
		END
		IF (@DatabaseVersion < 66)
		BEGIN
			CREATE TABLE [u_Kapps_ParametersMonitors](
				[id] [int] IDENTITY(1,1) NOT NULL,
				[AppCode] [nvarchar](10) NULL,
				[ConfigurationID] [int] NULL,
				[ConfigurationName] [nvarchar](100) NULL,
				[Timer] [int] NULL,
				[PickingActive] [bit] NULL,
				[ReceptionActive] [bit] NULL,
				[PickingColumnNames] [nvarchar](1000) NULL,
				[PickingColumnSizes] [nvarchar](100) NULL,
				[ReceptionColumnNames] [nvarchar](1000) NULL,
				[ReceptionColumnSizes] [nvarchar](100) NULL,
				[PickingDocLinesSQL] [nvarchar](max) NULL,
				[PickingDocTotalsSQL] [nvarchar](max) NULL,
				[PickingRowTotalsSQL] [nvarchar](max) NULL,
				[ReceptionDocLinesSQL] [nvarchar](max) NULL,
				[ReceptionDocTotalsSQL] [nvarchar](max) NULL,
				[ReceptionRowTotalsSQL] [nvarchar](max) NULL
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			
			IF EXISTS (SELECT ParameterValue FROM u_Kapps_Parameters WHERE ParameterID='ERP' and UPPER(ParameterValue)=UPPER('Sage_50C'))
			BEGIN
				UPDATE u_Kapps_DossierLin SET StampBi=REVERSE(LEFT(REVERSE(StampBo), CHARINDEX('*', REVERSE(Stampbo))-1 ))+REVERSE(LEFT(REVERSE(StampBi), CHARINDEX('*', REVERSE(Stampbi)))) WHERE stampbo<>'' and StampBi<>'' and SUBSTRING(stampbi,1,len(stampbo))=stampbo
			END
		END
		IF (@DatabaseVersion < 67)
		BEGIN
			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(108, @APPCODE, 'GENERAL', 'GENERAL','MORE_LINES_SAME_PRODUCT_LINKTOFIRST','Após satisfazer a quantidade, associar a artigo existênte','0','0','1-Associa 0-Não associa'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Após satisfazer a quantidade de todas as linhas desse artigo associa o artigo á primeira linha do artigo do documento de origem apenas quando o parâmetro [Permite inserir novas linhas de produtos existentes no documento de origem] estiver activo',0,0)			

			INSERT INTO u_Kapps_parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup,
			ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(10, @APPCODE, 'EAN128', 'EAN128', 'AIPESO','AI do EAN128 para o peso líquido','3100,3101,3102,3103,3104,3105','3100,3101,3102,3103,3104,3105','Pode definir mais do que um AI separado por virgulas'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+'Consultar https://www.gs1-128.info/application-identifiers/',0,0)
			
			ALTER TABLE u_Kapps_DossierLin ADD NetWeight decimal(18,3) NULL DEFAULT(0) WITH VALUES		
		END
		IF (@DatabaseVersion < 68)
		BEGIN
			ALTER TABLE u_Kapps_PackingDetails ADD NetWeight decimal(18,3) NULL DEFAULT(0) WITH VALUES		
		END
		IF (@DatabaseVersion < 69)
		BEGIN
			INSERT INTO u_Kapps_ParametersTypes(TypeID,Name,IsParameter,TypeOrder,DefaultDescription)
			VALUES ('EXTPROJ', 'Projecto de extensibilidade', 2, 10 ,'Processo a usar nos projectos de extensibilidade')		

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(1, @APPCODE, 'EXTPROJ', 'DEFAULT','READ_PROCESSID_PARAM','Ler parâmetros do ProcessID','','','Vai ler os parametros do processo (indicar o valor do campo ProcessID ver tabela u_Kapps_Processes))',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('READ_PROCESSID_PARAM') and ParameterGroup='DEFAULT' and p.TypeID in ('EXTPROJ')


			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(101, @APPCODE, 'STORE IN', 'DEFAULT','OVERRIDE_LOCATION','Pedir a localização de destino após selecionar o documento','0','0','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Pedir a localização de destino após selecionar o documento e não usar a localização de origem',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('OVERRIDE_LOCATION') and ParameterGroup='DEFAULT' and p.TypeID in ('STORE IN')


			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(63, 'SYT', 'STORE IN', 'DEFAULT','GRIDFORSERIALNUMBERS','Pedir numeros de série numa grelha','0','0','0-Não 1-Sim',0,0)
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(66, 'SYT', 'PICKING', 'DEFAULT','GRIDFORSERIALNUMBERS','Pedir numeros de série numa grelha','0','0','0-Não 1-Sim',0,0)
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(66, 'SYT', 'PACKING', 'DEFAULT','GRIDFORSERIALNUMBERS','Pedir numeros de série numa grelha','0','0','0-Não 1-Sim',0,0)
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(34, 'SYT', 'OTHERS', 'DEFAULT','GRIDFORSERIALNUMBERS','Pedir numeros de série numa grelha','0','0','0-Não 1-Sim',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('GRIDFORSERIALNUMBERS') and ParameterGroup='DEFAULT' and p.TypeID in ( 'STORE IN', 'PICKING', 'PACKING', 'OTHERS')

			CREATE TABLE [u_Kapps_Serials](
				[id] [bigint] IDENTITY(1,1) NOT NULL,
				[StampLin] [nvarchar](50) NULL,
				[Serial] [nvarchar](50) NULL
			) ON [PRIMARY]
		END
		IF (@DatabaseVersion < 70)
		BEGIN
			UPDATE u_Kapps_Parameters SET ParameterInfo='Usar um dos seguintes operadores <, <=, =, >, >='+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'<=	(Mostra todos os documentos até à data atual)'+CHAR(13)+CHAR(10)+'=	(Mostra apenas os documentos da data atual)'+CHAR(13)+CHAR(10)+'>=	(Mostra os documentos iguais e posteriores à data atual)' WHERE ParameterID='DOC_DATE'
			
			UPDATE u_Kapps_Parameters SET ParameterDefaultValue='ORDER BY lin.Article, lin.PackingLineKey' WHERE ParameterID='PACKORDERBYLIN'
			UPDATE u_Kapps_Parameters SET ParameterDefaultValue='ORDER BY lin.Article, lin.PickingLineKey' WHERE ParameterID='PICKORDERBYLIN'
			UPDATE u_Kapps_Parameters SET ParameterDefaultValue='ORDER BY lin.Article, lin.ReceptionLineKey' WHERE ParameterID='RECEORDERBYLIN'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Pedir numeros de série numa grelha', ParameterInfo='0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Permite que se possa ler vários números de série para a mesma linha' WHERE ParameterID='GRIDFORSERIALNUMBERS'

			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType) VALUES('Alterações na view v_Kapps_Reception_Documents',1,70,0)
			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType) VALUES('Alterações na view v_Kapps_Reception_Lines (Sage100c )',1,70,0)
			INSERT INTO u_Kapps_Alerts (Alert,Show,DatabaseVersion,AlertType) VALUES('Alterações nas views v_Kapps_Articles, v_Kapps_Picking_Lines, v_Kapps_Packing_Lines, v_Kapps_Reception_Lines (Sage50c)',1,70,0)
		END
		IF (@DatabaseVersion < 71)
		BEGIN
			UPDATE u_Kapps_Parameters SET ParameterOrder=67, ParameterInfo='Se o prefixo for por exemplo “Caixa” é concatenado a um contador continuo com x dígitos, ex. Caixa00001'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
			'Podem ser usadas as keywords:'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'[DOCTYPE];[DOCNUMBER];[DOCNAME];[CUSTOMERID];[CUSTOMERNAME];[WAREHOUSE];[USERID]'
			WHERE ParameterID='AUTONAME'

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(68, 'SYT', 'PACKING', 'DEFAULT','PACKNUMDIGITS','Nº digitos a usar na numeração da caixa','5','5','O nº da caixa é sequencial e por defeito com 5 digitos fixos 00001,00002...etc',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('PACKNUMDIGITS') and ParameterGroup='DEFAULT' and p.TypeID in ('PACKING')
			
			UPDATE u_Kapps_Parameters 
			SET ParameterValue=(SELECT CASE WHEN charindex('[',temp.ParameterValue,1)>0 THEN 2 ELSE 5 END FROM u_Kapps_Parameters temp WHERE temp.ParameterType='PACKING' and temp.ParameterID='AUTONAME' and temp.ParameterGroup=u_Kapps_Parameters.ParameterGroup)
			WHERE ParameterType='PACKING' and ParameterID='PACKNUMDIGITS' and ParameterGroup<>'DEFAULT'			

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(18, 'SYT', 'EAN128', 'EAN128', 'LOCATION_PREFIXOPCIONAL', 'Permitir ler localizações sem prefixo nos códigos de barras de localizações','0','0','0-Não /1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Quando a localização usa prefixo permite usar localizações com e sem prefixo',0,0)
		END
		IF (@DatabaseVersion < 72)
		BEGIN
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(102, 'SYT', 'PICKING', 'DEFAULT','VERIFYPENDING','Mostrar artigos pendentes quando integra','1','1','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Antes de integrar se existirem artigos pendentes mostra lista dos artigos',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(102, 'SYT', 'PACKING', 'DEFAULT','VERIFYPENDING','Mostrar artigos pendentes quando integra','1','1','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Antes de integrar se existirem artigos pendentes mostra lista dos artigos',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(102, 'SYT', 'STORE IN', 'DEFAULT','VERIFYPENDING','Mostrar artigos pendentes quando integra','1','1','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Antes de integrar se existirem artigos pendentes mostra lista dos artigos',0,0)

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('VERIFYPENDING') and ParameterGroup='DEFAULT' and p.TypeID in ('PICKING','PACKING','STORE IN')
		END
		IF (@DatabaseVersion < 73)
		BEGIN
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(5, 'SYT', 'PICKING', 'DEFAULT','DST_SERIE','Secção/Série do documento a gerar','','','Secção/Série de destino dos documentos a integrar'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+
			'Lista de secções/séries separada por virgulas ex: A,B,C'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+'Se não indicar nenhuma série é usada a série definida nos parâmetros do utilizador',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(5, 'SYT', 'PACKING', 'DEFAULT','DST_SERIE','Secção/Série do documento a gerar','','','Secção/Série de destino dos documentos a integrar'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+
			'Lista de secções/séries separada por virgulas ex: A,B,C se não indicar nenhuma série é usada a série definida nos parâmetros do utilizador',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(5, 'SYT', 'STORE IN', 'DEFAULT','DST_SERIE','Secção/Série do documento a gerar','','','Secção/Série de destino dos documentos a integrar'+ CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10)+
			'Lista de secções/séries separada por virgulas ex: A,B,C se não indicar nenhuma série é usada a série definida nos parâmetros do utilizador',0,0)


			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(5, 'SYT', 'PICKING', 'DEFAULT','SERIE_BY_INDEX','Secção/Série de destino pelo mesmo índex do documento de origem','0','0','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Vai procurar qual a secção/série de destino que está no mesmo index do documento de origem',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(5, 'SYT', 'PACKING', 'DEFAULT','SERIE_BY_INDEX','Secção/Série de destino pelo mesmo índex do documento de origem','0','0','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Vai procurar qual a secção/série de destino que está no mesmo index do documento de origem',0,0)

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(5, 'SYT', 'STORE IN', 'DEFAULT','SERIE_BY_INDEX','Secção/Série de destino pelo mesmo índex do documento de origem','0','0','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Vai procurar qual a secção/série de destino que está no mesmo index do documento de origem',0,0)


			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('DST_SERIE','SERIE_BY_INDEX') and ParameterGroup='DEFAULT' and p.TypeID in ('PICKING','PACKING','STORE IN') ORDER BY u_Kapps_Parameters.id
			
			UPDATE u_Kapps_Parameters SET ParameterDescription='Secção/Série do documento de destino igual à do documento de origem', ParameterInfo='0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Vai integrar na mesma secção/série do documento de origem!' WHERE ParameterID='SERIE_ORIGEM'
			UPDATE u_Kapps_Parameters SET ParameterDescription='Secção/Série do documento a gerar', ParameterInfo='Secção/Série de destino dos documentos a integrar' WHERE ParameterID='SECCAO'	
		END
		IF (@DatabaseVersion < 74)
		BEGIN
			UPDATE u_Kapps_Parameters SET ParameterDescription='Usar localizações de artigos em armazém' WHERE ParameterID='USE_LOCATIONS';
			UPDATE u_Kapps_Parameters SET ParameterDescription='Permitir alterar localizações de artigos em armazém' WHERE ParameterID='LOCATIONS_CTRL';

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(103, 'SYT', 'STORE IN', 'DEFAULT','ONEDOC_INTEGRATION','Integra no ERP em apenas um documento','1','1','0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'0 - Integra em apenas um documento'+CHAR(13)+CHAR(10)+'1 - Quando permite satisfazer vários documentos em simultâneo para o mesmo fornecedor vai integrar em vários documentos conforme o número de documentos de origem selecionados',0,0);

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('ONEDOC_INTEGRATION') and ParameterGroup='DEFAULT' and p.TypeID in ('STORE IN') ORDER BY u_Kapps_Parameters.id;
	
			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			VALUES ('SYT', N'DEFAULT', N'USR', 11, N'IGNORE_PROFIT_MARGIN', N'Ignora a margem de lucro mínima', N'0', N'0', N'0-Não 1-Sim'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Ao integrar ignora a verificação se a margem é inferior á margem de lucro mínima', N'0', N'0', N'Eticadata_16/17/18/19;');
			
			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, Username, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Parameters
			LEFT JOIN u_Kapps_Users on 1=1  
 			WHERE ParameterGroup='DEFAULT' and ParameterType='USR' and Username is not null	and (ParameterID='IGNORE_PROFIT_MARGIN');
		END
		IF (@DatabaseVersion < 75)
		BEGIN
			CREATE TABLE u_Kapps_InquiryAnswersStamps(
				id int IDENTITY(1,1) NOT NULL,
				InquiryAnswersHeaderUniqueID nvarchar(100) NULL,
				StampBo nvarchar(50) NULL
			);		
			
			UPDATE u_Kapps_Parameters SET ParameterInfo= 'Quando permite satisfazer vários documentos em simultâneo para o mesmo fornecedor'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'1 - Sim (vai criar apenas um documento no ERP)'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'0 - Não (vai criar vários documentos no ERP conforme o número de documentos de origem selecionados)'
			WHERE ParameterID='ONEDOC_INTEGRATION';		

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(104, 'SYT', 'PICKING', 'DEFAULT','PRINT_DOCUMENT','Imprime o documento que foi integrado no ERP','0','0','Depois de criar o documento no ERP imprime. (Apenas para documentos integrados em Vendas/Encomendas)'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'0 - Não'+CHAR(13)+CHAR(10)+'1 - Imprime todos os documentos'+CHAR(13)+CHAR(10)+'2 - Imprime apenas os documentos que a série esteja configurada para comunicar á AT',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(105, 'SYT', 'PICKING', 'DEFAULT','REPORT_NAME','Nome do report a imprimir','','','Nome do report sem a extensão',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(106, 'SYT', 'PICKING', 'DEFAULT','NUMBER_COPIES','Número de copias a imprimir','0','0','',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(104, 'SYT', 'PACKING', 'DEFAULT','PRINT_DOCUMENT','Imprime o documento que foi integrado no ERP','0','0','Depois de criar o documento no ERP imprime. (Apenas para documentos integrados em Vendas/Encomendas)'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'0 - Não'+CHAR(13)+CHAR(10)+'1 - Imprime todos os documentos'+CHAR(13)+CHAR(10)+'2 - Imprime apenas os documentos que a série esteja configurada para comunicar á AT',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(105, 'SYT', 'PACKING', 'DEFAULT','REPORT_NAME','Nome do report a imprimir','','','Nome do report sem a extensão',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(106, 'SYT', 'PACKING', 'DEFAULT','NUMBER_COPIES','Número de copias a imprimir','0','0','',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(104, 'SYT', 'OTHERS', 'DEFAULT','PRINT_DOCUMENT','Imprime o documento que foi integrado no ERP','0','0','Depois de criar o documento no ERP imprime. (Apenas para documentos integrados em Vendas/Encomendas)'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'0 - Não'+CHAR(13)+CHAR(10)+'1 - Imprime todos os documentos'+CHAR(13)+CHAR(10)+'2 - Imprime apenas os documentos que a série esteja configurada para comunicar á AT',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(105, 'SYT', 'OTHERS', 'DEFAULT','REPORT_NAME','Nome do report a imprimir','','','Nome do report sem a extensão',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP)
			VALUES(106, 'SYT', 'OTHERS', 'DEFAULT','NUMBER_COPIES','Número de copias a imprimir','0','0','',0,0,'Primavera;');

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and ParameterID in ('PRINT_DOCUMENT','REPORT_NAME','NUMBER_COPIES') and ParameterGroup='DEFAULT' and p.TypeID in ('PICKING','PACKING','OTHERS') ORDER BY u_Kapps_Parameters.id;
			
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Usando syntax SQL deve começar por AND seguido da condição'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords: [WORKWAREHOUSE]'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Exemplo para mostrar apenas os documentos do armazém selecionado usando a coluna Filter1:'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'AND cab.Filter1=''[WORKWAREHOUSE]''' WHERE ParameterID='GRID1_DEF_FILTER';
			UPDATE u_Kapps_Parameters SET ParameterInfo = 'Usando syntax SQL deve começar por AND seguido da condição'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords: [WORKWAREHOUSE]'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Exemplo para mostrar apenas as linhas do armazém selecionado:'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'AND lin.Warehouse=''[WORKWAREHOUSE]''' WHERE ParameterID='GRID2_DEF_FILTER';
		END
		IF (@DatabaseVersion < 76)
		BEGIN
			UPDATE u_Kapps_Parameters SET ParameterERP='Eticadata_16/17/18/19;' WHERE ParameterID='INV_CNT';
			ALTER TABLE u_Kapps_StockDocs ADD ZoneLocation nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
			ALTER TABLE u_Kapps_StockDocs ADD Location nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
		END
		IF (@DatabaseVersion < 77)
		BEGIN
			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(19, 'SYT', 'EAN128', 'EAN128', 'BOX_PREFIX', 'Prefixo para identificação de uma caixa','','','Na leitura de códigos de barras com este prefixo vai fazer a picagem de todos os artigos que estão dentro dessa caixa',0,0);

			ALTER TABLE u_Kapps_DossierLin ADD SSCC nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
		END
		IF (@DatabaseVersion < 78)
		BEGIN
			ALTER TABLE u_Kapps_Printers ADD ServiceUUID nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
			ALTER TABLE u_Kapps_Printers ADD CharacteristicUUID nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
			
			DELETE FROM u_Kapps_Parameters WHERE ParameterID='INV_CNT';
					
			UPDATE u_Kapps_Parameters SET ParameterDescription='Documentos: Mensagem ao seleccionar um documento', ParameterInfo ='Consulta(SQL) que vai mostrar uma mensagem ao entrar num documento'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Usar syntax SQL ex:'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'SELECT 0 as resultado, Obs as Mensagem FROM tabela WHERE cabkey=[CHAVECAB]'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'resultado=0 Mostra mensagem e continua'+CHAR(13)+CHAR(10)+'resultado=1 Mostra mensagem e cancela a acção'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords:'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'[CHAVECAB] - O campo identificador do documento'+CHAR(13)+CHAR(10)+'[NUMERODOC] - Número do documento'+CHAR(13)+CHAR(10)+'[NOMEENTIDADE] - Nome da entidade'+CHAR(13)+CHAR(10)+'[DATAFINAL] - Data do documento'+CHAR(13)+CHAR(10)+'[CODIGOENTIDADE] - Código da Entidade'+CHAR(13)+CHAR(10)+'[CODINTDOCUMENTO] - Código interno do documento'+CHAR(13)+CHAR(10)+'[NOMEDOCUMENTO] - Nome do documento' WHERE ParameterID='MESSAGE_QUERY';
			UPDATE u_Kapps_Parameters SET ParameterDescription='Linhas: Mensagem ao seleccionar um artigo', ParameterInfo ='Consulta(SQL) que vai mostrar uma mensagem ao selecionar num artigo'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Usar syntax SQL ex:'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'SELECT 0 as resultado, Obs as Mensagem FROM tabela WHERE ref=[REFARTIGO]'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'resultado=0 Mostra mensagem e continua'+CHAR(13)+CHAR(10)+'resultado=1 Mostra mensagem e cancela a acção'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords:'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'[CHAVECAB] - O campo identificador do documento'+CHAR(13)+CHAR(10)+'[NUMERODOC] - Número do documento'+CHAR(13)+CHAR(10)+'[NOMEENTIDADE] - Nome da entidade'+CHAR(13)+CHAR(10)+'[DATAFINAL] - Data do documento'+CHAR(13)+CHAR(10)+'[CODIGOENTIDADE] - Código da Entidade'+CHAR(13)+CHAR(10)+'[CODINTDOCUMENTO] - Código interno do documento'+CHAR(13)+CHAR(10)+'[NOMEDOCUMENTO] - Nome do documento'+CHAR(13)+CHAR(10)+'[NUNLINHA] - Número da linha'+CHAR(13)+CHAR(10)+'[REFARTIGO] - Referência do Artigo' WHERE ParameterID='MESSAGE_LINES_QUERY';		

			UPDATE u_Kapps_Parameters SET ParameterInfo=
			N'0 - Transferência entre armazéns com destino conhecido'+ CHAR(13)+CHAR(10)+
			N'1 - Transferência entre armazéns sem destino conhecido'+ CHAR(13)+CHAR(10)+
			N'2 - Transferência directa entre localizações de um produto dentro do mesmo armazém'+ CHAR(13)+CHAR(10)+ 
			N'3 - Transferência dois passos entre armazéns/localizações'+ CHAR(13)+CHAR(10)+
			N'4 - Transferência directa de uma localização completa para outra localização dentro do mesmo armazém'+ CHAR(13)+CHAR(10)+
			N'5 - Transferência dois passos de uma localização para vários armazéns/localizações'
			WHERE ParameterID='TIPO_TRANSFERENCIA';	

			INSERT INTO u_Kapps_Parameters(ParameterOrder, AppCode, ParameterType, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent)
			VALUES(31, 'SYT', 'TRANSF', 'DEFAULT', 'USE_ALL_WAREHOUSES', 'Pode transferir para outros armazéns','0','0','Permite selecionar outros armazens no armazém de destino (Apenas usado nas transferências do tipo dois passos)',0,0);

			INSERT INTO u_Kapps_Parameters(AppCode, ParameterGroup, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) 
			SELECT AppCode, p.ProcessID, ParameterType, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP
			FROM u_Kapps_Processes p
			INNER JOIN u_Kapps_Parameters ON p.TypeID = u_Kapps_Parameters.ParameterType
			WHERE ParameterID is not null and (ParameterID='USE_ALL_WAREHOUSES') and ParameterGroup='DEFAULT' and p.TypeID='TRANSF';
		END
		IF (@DatabaseVersion < 79)
		BEGIN
			ALTER TABLE u_Kapps_PackingDetails ADD SSCC nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;

			SET @SQL = 'UPDATE u_Kapps_PackingDetails SET SSCC=COALESCE(temp.SSCC,'''')
			FROM (SELECT PackId, SSCC FROM u_Kapps_PackingHeader GROUP BY PackId, SSCC)temp
			WHERE u_Kapps_PackingDetails.PackId=temp.PackId';
			exec sp_executesql @SQL;
			
			SET @SQL = (
			SELECT TOP 1 'ALTER TABLE u_Kapps_PackingHeader DROP CONSTRAINT '+name
            FROM Sys.default_constraints A
            JOIN sysconstraints B on A.parent_object_id = B.id
            WHERE id = OBJECT_ID('u_Kapps_PackingHeader') AND COL_NAME(id, colid)='SSCC' AND OBJECTPROPERTY(constid,'IsDefaultCnst')=1 AND name like '%SSCC%'
			);
			exec sp_executesql @SQL;

			ALTER TABLE u_Kapps_PackingHeader DROP COLUMN SSCC;
		END
		IF (@DatabaseVersion < 80)
		BEGIN
			ALTER TABLE u_Kapps_DossierLin ADD KeyDocGerado nvarchar(50) NOT NULL DEFAULT ('') WITH VALUES;
		END
		
		--
		-- Actualizar DATABASEVERSION
		--
		UPDATE u_Kapps_Parameters SET ParameterValue = @BackDBVersion WHERE UPPER(AppCode) = @APPCODE AND ParameterGroup='MAIN' and UPPER(ParameterID) = UPPER('DATABASEVERSION')

	END

	IF (@DatabaseVersion = 80 and @BackDBVersion=80)
	BEGIN
		IF  NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_u_Kapps_Serials_StampLin')
			CREATE NONCLUSTERED INDEX [IX_u_Kapps_Serials_StampLin] ON [u_Kapps_Serials] ([StampLin],[Serial]);
	END


	COMMIT TRANSACTION


 	SET @estado = 'OK'
	SET @descerro = ''

	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE() + ERROR_LINE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		ROLLBACK TRANSACTION
		SET @STATE = 1
		SET @descerro = @descerro + @ErrorMessage
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH

	SELECT @estado, @descerro
END
