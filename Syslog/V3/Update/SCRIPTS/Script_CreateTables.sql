CREATE TABLE Kapps_Parameters(
	ParameterOrder numeric(18, 0),
	AppCode nvarchar(50),
	TerminalID nvarchar(50),
	ParameterGroup nvarchar(100),
	ParameterID nvarchar(50),
	ParameterDescription nvarchar(100),
	ParameterValue nvarchar(4000),
	ParameterDefaultValue nvarchar(4000),
	ParameterInfo nvarchar(4000),
	ParameterRequired nvarchar(1),
	ParameterDependent nvarchar(50)
);
CREATE TABLE u_Kapps_Alerts(
	Alert varchar(512) NOT NULL,
	Show bit NOT NULL,
	DatabaseVersion int NOT NULL,
	AlertType int NOT NULL,
	AlertCod int IDENTITY(1,1) NOT NULL
);
ALTER TABLE u_Kapps_Alerts ADD CONSTRAINT PK_u_Kapps_Alerts PRIMARY KEY (AlertCod);

CREATE TABLE u_Kapps_DossierLin(
	StampLin nvarchar(50),
	StampBo nvarchar(50),
	StampBi nvarchar(50),
	Ref nvarchar(60),
	Description nvarchar(100),
	Qty decimal(18, 3),
	Lot nvarchar(50),
	Serial nvarchar(50),
	UserID nvarchar(50),
	MovDate nvarchar(8),
	MovTime nvarchar(6),
	Status nvarchar(50),
	DocType nvarchar(50),
	DocNumber nvarchar(50),
	Integrada nvarchar(50),
	DataIntegracao nvarchar(8),
	HoraIntegracao nvarchar(6),
	UserIntegracao nvarchar(50),
	Process nvarchar(50),
	Validade nvarchar(50),
	Warehouse nvarchar(50),
	Location nvarchar(50),
	ExternalDocNum nvarchar(50),
	EntityType nvarchar(50),
	EntityNumber nvarchar(50),
	InternalStampDoc nvarchar(50),
	DestinationDocType nvarchar(50),
	TransactionDescription nvarchar(50),
	EntityName nvarchar(255),
	DocName nvarchar(50),
	VatNumber nvarchar(50),
	UnitPrice decimal(18, 6),
	QtyUM varchar(25) NOT NULL,
	Qty2 decimal(18, 3) NOT NULL,
	Qty2UM varchar(25) NOT NULL,
	StampDocGer varchar(50) NOT NULL,
	WarehouseOut varchar(50),
	TerminalID int,
	OriLineNumber int,
	LineClose bit,
	CabUserField1 varchar(4000),
	CabUserField2 varchar(4000),
	CabUserField3 varchar(4000),
	LinUserField1 varchar(4000),
	LinUserField2 varchar(4000),
	LinUserField3 varchar(4000),
	GTIN varchar(50) NOT NULL,
	DeliveryCustomer nvarchar(12) NOT NULL,
	DeliveryCode nvarchar(60) NOT NULL
);

CREATE TABLE u_Kapps_Events(
	EventID nvarchar(100) NOT NULL,
	EventDescription nvarchar(200)
);
CREATE TABLE u_Kapps_InvHeader(
	Terminal int NOT NULL,
	Date datetime,
	Status varchar(1) NOT NULL,
	Syncr varchar(1) NOT NULL,
	Name varchar(50),
	Stamp varchar(25) NOT NULL
);
ALTER TABLE u_Kapps_InvHeader ADD CONSTRAINT PK_u_Kapps_InvHeader_1 PRIMARY KEY (Stamp);

CREATE TABLE u_Kapps_InvLines(
	StampLin varchar(25) NOT NULL,
	StampHeader varchar(25) NOT NULL,
	Ref varchar(50) NOT NULL,
	Qty numeric(18, 5) NOT NULL,
	Lot varchar(100) NOT NULL,
	SerialNumber varchar(100) NOT NULL,
	Warehouse varchar(50) NOT NULL,
	Syncr varchar(1) NOT NULL,
	Description varchar(255),
	Date datetime,
	Validade varchar(8),
	SSCC nvarchar(50) NOT NULL
);
ALTER TABLE u_Kapps_InvLines ADD CONSTRAINT PK_u_Kapps_InvLines PRIMARY KEY (StampLin);

CREATE TABLE u_Kapps_LabelRules(
	ID nvarchar(100),
	TerminalId nvarchar(4),
	EventId nvarchar(100),
	PrinterId nvarchar(100),
	LabelId nvarchar(100),
	CustomerId nvarchar(100),
	CustomerAddressId nvarchar(200),
	TransporterAddressID nvarchar(100),
	Nrlabels nvarchar(100),
	Actif nvarchar(1),
	ConfirmaImpressao bit NOT NULL
);
CREATE TABLE u_Kapps_Labels(
	LabelId nvarchar(100),
	LabelDescription nvarchar(200),
	LabelEvent nvarchar(100),
	LabelCode varchar(4000),
	Actif nvarchar(1),
	Palete bit NOT NULL
);
CREATE TABLE u_Kapps_Log(
	LogStamp varchar(50) NOT NULL,
	LogType int NOT NULL,
	LogMessage varchar(255) NOT NULL,
	LogDetail varchar(4000) NOT NULL
);
ALTER TABLE u_Kapps_Log ADD CONSTRAINT PK_u_Kapps_Log PRIMARY KEY (LogStamp);

CREATE TABLE u_Kapps_PackagingTypes(
	PackType nvarchar(100),
	Description nvarchar(200),
	Height numeric(18, 0),
	Lenght numeric(18, 0),
	Width numeric(18, 0),
	Weight numeric(18, 0),
	Type nvarchar(100),
	Status numeric(1, 0),
	Palete bit NOT NULL
);
CREATE TABLE u_Kapps_PackingDetails(
	PackID nvarchar(100),
	LineID nvarchar(100),
	StampLin nvarchar(100),
	Ref nchar(100),
	Description nchar(200),
	Lot nvarchar(100),
	Serial nvarchar(100),
	Quantity decimal(18, 3),
	ExpirationDate varchar(15),
	Status nchar(1)
);
CREATE TABLE u_Kapps_PackingHeader(
	PackId nvarchar(100),
	CreationDate nvarchar(8),
	CreationTime nvarchar(4),
	EndDate nvarchar(8),
	EndTime nvarchar(4),
	UserId nvarchar(100),
	CustomerId nvarchar(100),
	CustomerName nvarchar(200),
	Status nvarchar(1),
	Height numeric(18, 0),
	Lenght numeric(18, 0),
	Width numeric(18, 0),
	Weight numeric(18, 0),
	PackType nvarchar(100),
	Palete bit NOT NULL,
	SSCC varchar(50) NOT NULL
);
CREATE TABLE u_Kapps_Printers(
	PrinterId nvarchar(100),
	PrinterDescription nvarchar(200),
	CommType nvarchar(100),
	IP_MacAddress_com nvarchar(100),
	Port nvarchar(100),
	Actif nvarchar(1)
);
CREATE TABLE u_Kapps_Session_Docs(
	AppCode nvarchar(100),
	TerminalID nvarchar(100),
	SessionID nvarchar(100),
	SessionUserID nvarchar(100),
	SessionDocNumber nvarchar(100),
	SessionStartDateTime nvarchar(100),
	SessionEndDateTime nvarchar(100),
	SessionType nvarchar(100),
	SessionDocument nvarchar(100)
);
CREATE TABLE u_Kapps_Session_Users(
	AppCode nvarchar(100),
	TerminalID nvarchar(100),
	SessionID nvarchar(100),
	SessionUser nvarchar(100),
	SessionLogInDateTime nvarchar(100),
	SessionLogOutDateTime nvarchar(100)
);
CREATE TABLE u_Kapps_Terminals(
	TerminalID nvarchar(100),
	TerminalDescription nvarchar(1000)
);
CREATE TABLE u_Kapps_Transporters(
	TransporterId nvarchar(4),
	TransporterName nvarchar(100)
);
CREATE TABLE u_Kapps_TU1(
	TU1KU1 varchar(200),
	TU1KU2 varchar(200),
	TU1KU3 varchar(200),
	TU1KU4 varchar(200),
	TU1F01 varchar(400),
	TU1F02 varchar(400),
	TU1F03 varchar(400),
	TU1F04 varchar(400),
	TU1F05 varchar(400),
	TU1F06 varchar(400),
	TU1F07 varchar(400),
	TU1F08 varchar(400),
	TU1F09 varchar(400),
	TU1F10 varchar(400),
	TU1TER int,
	ROWID bigint IDENTITY(1,1) NOT NULL
);
CREATE TABLE u_Kapps_TU2(
	TU2KU1 varchar(200),
	TU2KU2 varchar(200),
	TU2KU3 varchar(200),
	TU2KU4 varchar(200),
	TU2F01 varchar(400),
	TU2F02 varchar(400),
	TU2F03 varchar(400),
	TU2F04 varchar(400),
	TU2F05 varchar(400),
	TU2F06 varchar(400),
	TU2F07 varchar(400),
	TU2F08 varchar(400),
	TU2F09 varchar(400),
	TU2F10 varchar(400),
	TU2TER int,
	ROWID bigint IDENTITY(1,1) NOT NULL
);
CREATE TABLE u_Kapps_TU3(
	TU3KU1 varchar(200),
	TU3KU2 varchar(200),
	TU3KU3 varchar(200),
	TU3KU4 varchar(200),
	TU3KU5 bigint,
	TU3KU6 bigint,
	TU3KU7 bigint,
	TU3KU8 bigint,
	TU3F01 varchar(400),
	TU3F02 varchar(400),
	TU3F03 varchar(400),
	TU3F04 varchar(400),
	TU3F05 varchar(400),
	TU3F06 varchar(400),
	TU3F07 varchar(400),
	TU3F08 varchar(400),
	TU3F09 varchar(400),
	TU3F10 varchar(400),
	TU3F11 varchar(1000),
	TU3F12 varchar(1000),
	TU3F13 varchar(1000),
	TU3F14 varchar(1000),
	TU3F15 varchar(1000),
	TU3F16 varchar(1000),
	TU3F17 varchar(1000),
	TU3F18 varchar(1000),
	TU3F19 varchar(1000),
	TU3F20 varchar(1000),
	TU3F21 bigint,
	TU3F22 bigint,
	TU3F23 bigint,
	TU3F24 bigint,
	TU3F25 bigint,
	TU3F26 bigint,
	TU3F27 bigint,
	TU3F28 bigint,
	TU3F29 bigint,
	TU3F30 bigint,
	TU3F31 decimal(15, 6),
	TU3F32 decimal(15, 6),
	TU3F33 decimal(15, 6),
	TU3F34 decimal(15, 6),
	TU3F35 decimal(15, 6),
	TU3F36 decimal(15, 6),
	TU3F37 decimal(15, 6),
	TU3F38 decimal(15, 6),
	TU3F39 decimal(15, 6),
	TU3F40 decimal(15, 6),
	TU3TER int,
	ROWID bigint IDENTITY(1,1) NOT NULL
);
CREATE TABLE u_Kapps_TU4(
	TU4KU1 varchar(200),
	TU4KU2 varchar(200),
	TU4KU3 varchar(200),
	TU4KU4 varchar(200),
	TU4KU5 bigint,
	TU4KU6 bigint,
	TU4KU7 bigint,
	TU4KU8 bigint,
	TU4F01 varchar(400),
	TU4F02 varchar(400),
	TU4F03 varchar(400),
	TU4F04 varchar(400),
	TU4F05 varchar(400),
	TU4F06 varchar(400),
	TU4F07 varchar(400),
	TU4F08 varchar(400),
	TU4F09 varchar(400),
	TU4F10 varchar(400),
	TU4F11 varchar(1000),
	TU4F12 varchar(1000),
	TU4F13 varchar(1000),
	TU4F14 varchar(1000),
	TU4F15 varchar(1000),
	TU4F16 varchar(1000),
	TU4F17 varchar(1000),
	TU4F18 varchar(1000),
	TU4F19 varchar(1000),
	TU4F20 varchar(1000),
	TU4F21 bigint,
	TU4F22 bigint,
	TU4F23 bigint,
	TU4F24 bigint,
	TU4F25 bigint,
	TU4F26 bigint,
	TU4F27 bigint,
	TU4F28 bigint,
	TU4F29 bigint,
	TU4F30 bigint,
	TU4F31 decimal(15, 6),
	TU4F32 decimal(15, 6),
	TU4F33 decimal(15, 6),
	TU4F34 decimal(15, 6),
	TU4F35 decimal(15, 6),
	TU4F36 decimal(15, 6),
	TU4F37 decimal(15, 6),
	TU4F38 decimal(15, 6),
	TU4F39 decimal(15, 6),
	TU4F40 decimal(15, 6),
	TU4TER int,
	ROWID bigint IDENTITY(1,1) NOT NULL
);
CREATE TABLE u_Kapps_Users(
	Username varchar(50) NOT NULL,
	Name varchar(50) NOT NULL,
	PIN varchar(10) NOT NULL
);
ALTER TABLE u_Kapps_Users ADD CONSTRAINT PK_u_Kapps_Users PRIMARY KEY (Username);

INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(39 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(43 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(47 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(50 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(51 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(29 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(28 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(30 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(31 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(33 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(32 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(34 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(35 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(37 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(36 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(38 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(39 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(41 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(40 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(41 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(43 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(45 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(44 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(46 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(47 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(49 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(48 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(50 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(51 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(4 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'SETOR', N'Código do setor default na intergração com Sage 100C', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(5 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'MOEDA', N'Código da moeda default na intergração com (Sage 50C/Sage 100C/Sendys)', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo index do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo index do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo index do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(4 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'SERIE_ORIGEM', N'Série do documento de destino igual á do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai integrar na mesma série do documento de origem! Não aplicável em modo Multi-Documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(4 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'SERIE_ORIGEM', N'Série do documento de destino igual á do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai integrar na mesma série do documento de origem! Não aplicável em modo Multi-Documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(4 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'SERIE_ORIGEM', N'Série do documento de destino igual á do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai integrar na mesma série do documento de origem! Não aplicável em modo Multi-Documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(5 AS Numeric(18, 0)), N'AP0002', N'1', N'INSPECTION', N'SHOW_STOCK', N'Mostra stock atual do artigo', N'0', N'0', N'0-Não /1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(6 AS Numeric(18, 0)), N'AP0002', N'1', N'INSPECTION', N'UPDATE_CTRL', N'Avisa que o artigo já foi lido, e se pretende atualizar a quantidade', N'0', N'0', N'0-Não /1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(6 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'TIPO_DOC_INVENTARIO', N'Código do documento de inventário', N'INV', N'INV', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(7 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'REGIME_IVA', N'Regime de Iva (Sage 100C / Sendys)', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(103 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'USER_PIN', N'Utilizadores necessitem de PIN code para efetuar login', N'0', N'0', N'1-Necessita / 0-Não necessita', N'0', N'100');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(52 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(52 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(8 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'COD_LOTE', N'Código da propriedade associada ao lote (Sage 50C)', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(9 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'DOC_CLOSE_COD', N'Código do estado para fechar documento (Sage 50C)', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(12 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'SSCC_CONTROLDIGIT', N'SSCC - Dígito de Extensão', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(13 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'SSCC_COMPANYPREFIX', N'SSCC - Prefixo da Empresa', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(53 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'MODIFY_DELIVERY', N'Permite alterar o local de descarga', N'0', N'0', N'(0-Não permite 1-Permite)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(53 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'MODIFY_DELIVERY', N'Permite alterar o local de descarga', N'0', N'0', N'(0-Não permite 1-Permite)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(31 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'MODIFY_DELIVERY', N'Permite alterar o local de descarga', N'0', N'0', N'(0-Não permite 1-Permite)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(52 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(30 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(10 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'LINHA_ESPECIAL', N'No documento a gerar incluir linhas com a indicação dos documentos originais', N'0', N'0', N'(0-Não 1-Sim) Apenas para o ERP Primavera', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(54 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'BOX_AUTO_OPEN', N'Após adicionar um artigo, mostrar opção de fechar a caixa / abrir uma caixa nova', N'0', N'0', N'(0-Não 1-Sim)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(55 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'DEFAULT_BOX', N'Caixa a usar por defeito', N'', N'', N'Indicar a caixa a usar por defeito'+ CHAR(13)+CHAR(10)+'Ao abrir uma caixa nova usa sempre a mesma e não mostra o ecrã de seleção e detalhes da caixa', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(9 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'AISSCC', N'AI do EAN128 para o SSCC', N'00', N'00', N'Ver lista na pasta documentation', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(53 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'FECHAR_DOC_ORIGEM', N'Fechar o documento de origem', N'0', N'0', N'0 - Ao integrar o documento confirma se pretende fechar o documento de origem'+ CHAR(13)+CHAR(10)+'1 - Ao integrar o documento não confirma e fecha sempre o documento de origem'+ CHAR(13)+CHAR(10)+'2 - Ao integrar o documento não confirma e nunca fecha o documento de origem', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(54 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'FECHAR_DOC_ORIGEM', N'Fechar o documento de origem', N'0', N'0', N'0 - Ao integrar o documento confirma se pretende fechar o documento de origem'+ CHAR(13)+CHAR(10)+'1 - Ao integrar o documento não confirma e fecha sempre o documento de origem'+ CHAR(13)+CHAR(10)+'2 - Ao integrar o documento não confirma e nunca fecha o documento de origem', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(56 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'FECHAR_DOC_ORIGEM', N'Fechar o documento de origem', N'0', N'0', N'0 - Ao integrar o documento confirma se pretende fechar o documento de origem'+ CHAR(13)+CHAR(10)+'1 - Ao integrar o documento não confirma e fecha sempre o documento de origem'+ CHAR(13)+CHAR(10)+'2 - Ao integrar o documento não confirma e nunca fecha o documento de origem', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(54 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CAB_FIELDS_REQUIRED', N'Documento: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(55 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'LIN_FIELDS_REQUIRED', N'Linha: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(55 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_FIELDS_REQUIRED', N'Documento: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(56 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_FIELDS_REQUIRED', N'Linha: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(57 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_FIELDS_REQUIRED', N'Documento: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(58 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_FIELDS_REQUIRED', N'Linha: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(32 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_FIELDS_REQUIRED', N'Documento: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(33 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_FIELDS_REQUIRED', N'Linha: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'SRC_DOSSIER', N'Tipos de docs que dão origem à receção', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'DST_DOSSIER', N'Tipos de documentos a gerar na integração da receção', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(5 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID1_QUERY', N'Documentos: Join  para obter adicionar colunas de outras tabelas', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela da lista de documentos', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(6 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID1_COLUMNS', N'Documentos: 10 colunas de utilizador adicionais para os docs.', N'', N'', N'As colunas de utilizador são do tipo multilinha podendo assim apresentar informação contactenada até 2 linhas', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(7 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID1_ALIAS', N'Documentos: Titulos para os cabeçalhos das 10 colunas adicionais', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(8 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID1_COL_TYPE', N'Documentos: Tipos de dados para as colunas adicionais nos documentos', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(9 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID1_COL_DIM', N'Documentos: Dimensão para todos os cabeçalhos', N'', N'0,50,0,0,0,0,170', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(10 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'deve começar por: and..condições adicionais para a lista de documentos', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(11 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID2_QUERY', N'Linhas: Join  para adicionar colunas às linhas do documento', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela das linhas do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(12 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID2_COLUMNS', N'Linhas: 10 colunas adiconais para as linhas de documento', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha acrescentado colunas à lista de documentos, ex. tabela.name, tabela.date, tabela.status', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(13 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID2_ALIAS', N'Linhas: Titulos para os cabeçalhos das colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(14 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID2_COL_TYPE', N'Linhas: Tipos de dados para as colunas adicionais ', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(15 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID2_COL_DIM', N'Linhas: Dimensão para todos os cabeçalhos', N'', N'50,50,0,120,170,0,50,50,0,0,0,0', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(16 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional.', N'', N'', N'deve começar por: and..condições adicionais para a tabela das linhas do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(19 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar? 1-Sim/0-Não.', N'', N'0', N'Apresentar teclado para quantidade automaticamente após leitura de CB', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(20 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'NOQTY', N'Mostar quantidade a picar por defeito? 1-Sim/0-Não.', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'SRC_DOSSIER', N'Tipos de docs que dão origem no picking.', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'DST_DOSSIER', N'Tipos de documentos a gerar na integração do picking', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(10 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'deve começar por: and..condições adicionais para a lista de documentos', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(17 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'MESSAGE_QUERY', N'Documentos: Query que corre ao seleccionar 1 doc.', N'', N'', N'Consulta que vai despoltar um aviso e uma acção ao entrar num documento de rececão.'+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords:'+ CHAR(13)+CHAR(10)+'[CHAVECAB] - O campo identificador do documento'+ CHAR(13)+CHAR(10)+'[NUMERODOC] - Número do documento'+ CHAR(13)+CHAR(10)+'[NOMEENTIDADE] - Nome da entidade'+ CHAR(13)+CHAR(10)+'[DATAFINAL] - Data do documento'+ CHAR(13)+CHAR(10)+'[CODIGOENTIDADE] - Código da Entidade'+ CHAR(13)+CHAR(10)+'[CODINTDOCUMENTO] - Código interno do documento'+ CHAR(13)+CHAR(10)+'[NOMEDOCUMENTO] - Nome do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(5 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID1_QUERY', N'Documentos: Join  para obter adicionar colunas de outras tabelas', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela da lista de documentos', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(6 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID1_COLUMNS', N'Documentos: 10 colunas de utilizador adicionais para os docs.', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha o <GRID1_QUERY> preenchido, ex. tabela.name, tabela.date, tabela.status', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(7 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID1_ALIAS', N'Documentos: Titulos para os cabeçalhos das 10 colunas adicionais', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(8 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID1_COL_TYPE', N'Documentos: Tipos de dados para as colunas adicionais nos documentos', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(9 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID1_COL_DIM', N'Documentos: Dimensão para todos os cabeçalhos', N'', N'0,50,0,0,0,0,170', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(11 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID2_QUERY', N'Linhas: Join  para adicionar colunas às linhas do documento', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela das linhas do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(12 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID2_COLUMNS', N'Linhas: 10 colunas adiconais para as linhas de documento', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha acrescentado colunas à lista de documentos, ex. tabela.name, tabela.date, tabela.status', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(13 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID2_ALIAS', N'Linhas: Titulos para os cabeçalhos das colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(14 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID2_COL_TYPE', N'Linhas: Tipos de dados para as colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(15 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID2_COL_DIM', N'Linhas: Dimensão para todos os cabeçalhos', N'', N'50,50,0,120,170,0,50,50,0,0,0,0', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(16 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional.', N'', N'', N'deve começar por: and..condições adicionais para a tabela das linhas do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(17 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'MESSAGE_QUERY', N'Documentos: Query que corre ao seleccionar 1 doc.', N'', N'', N'Consulta que vai despoltar um aviso e uma acção ao entrar num documento de rececão.'+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords:'+ CHAR(13)+CHAR(10)+'[CHAVECAB] - O campo identificador do documento'+ CHAR(13)+CHAR(10)+'[NUMERODOC] - Número do documento'+ CHAR(13)+CHAR(10)+'[NOMEENTIDADE] - Nome da entidade'+ CHAR(13)+CHAR(10)+'[DATAFINAL] - Data do documento'+ CHAR(13)+CHAR(10)+'[CODIGOENTIDADE] - Código da Entidade'+ CHAR(13)+CHAR(10)+'[CODINTDOCUMENTO] - Código interno do documento'+ CHAR(13)+CHAR(10)+'[NOMEDOCUMENTO] - Nome do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'0', N'', N'SCRIPTSVERSION', N'SCRIPTS VERSION', N'0', N'0', N'', N'0', N'');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(19 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar? 1-Sim/0-Não.', N'', N'0', N'Apresentar teclado para quantidade automaticamente após leitura de CB', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(20 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'NOQTY', N'Mostar quantidade a picar por defeito? 1-Sim/0-Não.', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'STOCK_CTRL', N'Aceita stock negativo. Valores:0,1,2', N'0', N'0', N'0-não / 1-sim com mensagem a avisar / 2- sim sem mensagem a avisar', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(100 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'QTY_CTRL', N'Aceita quantidades superiores ao documento de origem. Valores:0,1,2', N'0', N'0', N'0-não / 1-sim com mensagem a avisar / 2- sim sem mensagem a avisar', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(19 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'MULTI_USERS', N'Vários utilizadores para o mesmo documento:  0/1', N'', N'0', N'0-não / 1-sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(4 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'ARTICLE_FILTER', N'Filtro de artigos (stored procedure "SP_u_Kapps_Products")', N'', N'', N'and … tabela.campo = xpto', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'NEW_PRD', N'Adicionar novo produto? V:0/1', N'', N'0', N'0-não / 1-sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'OTHERS', N'Outros documentos', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'USEEAN128', N'Usa EAN128', N'', N'0', N'0-não / 1-sim', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'PREFIX', N'Usa Prefixo EAN128', N'', N'0', N'0-não / 1-sim', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'MIN_LEGHT', N'Numero de caracteres necessários para ser considerado EAN128', N'', N'', N'Ao ler um código de barras superior ao valor inserido considera como EAN 128', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'INSPECTION', N'DEF_QTY', N'Quantidade por defeito na contagem', N'', N'1', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'MENU', N'ORDER', N'Ordem das opções do menu, ex.: 1,2,3,4,5,6  ', N'1,2,3,4,5,6,7,8', N'1,2,3,4,5,6,7,8', N'Opçoes disponíveis por ordem: Picking,Packing,Receção,Criar Documento,Inventario,Consultas,Verificar Preço, Stock Armazéns', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'MENU', N'VISIBLE', N'Lista de (1-visivel/0-invisivel) para as opções de menu (ver ajuda)', N'1,1,1,1,1,1,1,1', N'1,1,1,1,1,1,1,1', N'Opçoes disponíveis por ordem: Picking,Packing,Receção,Criar Documento,Inventario,Consultas,Verificar Preço, Stock Armazéns', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(99 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'DOC_DATE', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'', N'<=', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(99 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'DOC_DATE', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'', N'<=', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'', N'1', N'', N'ERP', N'', N'', N'PHC', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'', N'1', N'', N'BD_Sistema_13', N'', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'', N'1', N'', N'BD_Sistema_16', N'', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'', N'1', N'', N'BD_Empresas', N'', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'Secção', N'Secção para Eticadata/Serie para primavera,Sage50C,Sage100C e Sendys', N'', N'', N'0', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'ProductReplacement', N'Subsituir referencias? V:0/1', N'', N'', N'0-não / 1-sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'', N'1', N'', N'Driver_Path', N'', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'INSPECTION', N'INV_CNT', N'Contador por defeito', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'LOTES', N'ENB_LOTE_ALT', N'Permite editar o campo de lote', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(99 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'WAREHOUSE', N'Armazém por defeito', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(98 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'ADDBARCODE', N'Criar e Associar código de barras inexistente a produto? V: 0/1)', N'', N'', N'0-não / 1-sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'SRC_DOSSIER', N'Tipos de docs que dão origem ao packing.', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'DST_DOSSIER', N'Tipos de documentos a gerar na integração do documento de packing', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(5 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID1_QUERY', N'Documentos: Join  para obter adicionar colunas de outras tabelas', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela da lista de documentos', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(6 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID1_COLUMNS', N'Documentos: 10 colunas de utilizador adicionais para os docs.', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha o <GRID1_QUERY> preenchido, ex. tabela.name, tabela.date, tabela.status', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(7 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID1_ALIAS', N'Documentos: Titulos para os cabeçalhos das 10 colunas adicionais', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(10 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'deve começar por: and..condições adicionais para a lista de documentos', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(14 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID2_COL_TYPE', N'Linhas: Tipos de dados para as colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(16 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional.', N'', N'', N'deve começar por: and..condições adicionais para a tabela das linhas do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(26 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(8 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID1_COL_TYPE', N'Documentos: Tipos de dados para as colunas adicionais nos documentos', N'', N'', N'se acrescentou colunas à lista de documentos, deve indicar os tipos das colunas separados por virgula, ex: s,s, s', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(9 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID1_COL_DIM', N'Documentos: Dimensão para todos os cabeçalhos', N'', N'0,50,0,0,0,0,170', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(11 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID2_QUERY', N'Linhas: Join  para adicionar colunas às linhas do documento', N'', N'', N'deve começar sempre por: JOIN tabela on ?condições necessárias para ligar à tabela das linhas do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(12 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID2_COLUMNS', N'Linhas: 10 colunas adiconais para as linhas de documento', N'', N'', N'podem ser colunas da tabela mestre ou de outras tabelas caso tenha acrescentado colunas à lista de documentos, ex. tabela.name, tabela.date, tabela.status', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(13 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID2_ALIAS', N'Linhas: Titulos para os cabeçalhos das colunas adicionais', N'', N'', N'se acrescentou colunas à tabela das linhas do documento, deve indicar os nomes das colunas separados por virgula, ex: nome,data, estado', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(15 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'GRID2_COL_DIM', N'Linhas: Dimensão para todos os cabeçalhos', N'', N'50,50,0,120,170,0,50,50,0,0,0,0', N'Deve indicar a dimensão (VALORES NUMERICOS SEPARADOS POR VIRGULA TANTOS QUANTOS AS COLUNAS EXISTENTES E PELA MESMA ORDEM) de todas as colunas existentes + as colunas adiconais', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(17 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'MESSAGE_QUERY', N'Documentos: Query que corre ao seleccionar 1 doc.', N'', N'', N'Consulta que vai despoltar um aviso e uma acção ao entrar num documento de rececão.'+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords:'+ CHAR(13)+CHAR(10)+'[CHAVECAB] - O campo identificador do documento'+ CHAR(13)+CHAR(10)+'[NUMERODOC] - Número do documento'+ CHAR(13)+CHAR(10)+'[NOMEENTIDADE] - Nome da entidade'+ CHAR(13)+CHAR(10)+'[DATAFINAL] - Data do documento'+ CHAR(13)+CHAR(10)+'[CODIGOENTIDADE] - Código da Entidade'+ CHAR(13)+CHAR(10)+'[CODINTDOCUMENTO] - Código interno do documento'+ CHAR(13)+CHAR(10)+'[NOMEDOCUMENTO] - Nome do documento', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(20 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(19 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'AUTONAME', N'Prefixo para código da caixa gerada pela app logistica', N'', N'', N'Se o prefixo foi do tipo texto é contactenado a um contador continuo com 5 digitos, ex. Caixa_00001   /  Se o prefixo conter uma das seguintes chaves:[REF];[DOCTYPE];[DOCNUMBER];[CUSTOMERID];[CUSTOMERNAME];[LOT];[WAREHOUSE];[USERID] será contacnetado o valor correspondente do documento seleccionado à um contador para essa chave até 3 digitos, ex.: DOS1_001   ', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(20 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar? 1-Sim/0-Não.', N'', N'0', N'Apresentar teclado para quantidade automaticamente após leitura de CB', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'', N'1', N'', N'UPDATE', N'', N'', N'1', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(99 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'DOC_DATE', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'', N'<=', N'<= (mostra todos os documentos até a data atual) / = (Mostra apenas os documentos da data atual)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(21 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'NOQTY', N'Mostar quantidade a picar por defeito? 1-Sim/0-Não.', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(1 AS Numeric(18, 0)), N'AP0002', N'0', N'', N'DATABASEVERSION', N'DATABASE VERSION', N'47', N'0', N'', N'0', N'');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(19 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(101 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'REPRINT_LABEL', N'Permite a reimpressão de etiquetas', N'0', N'0', N'0-não / 1-sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(20 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(20 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(19 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(2 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(4 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'USEEAN13', N'Usa EAN13? : V:1/0', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(5 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'AIREFERENCIA', N'AI do EAN128 para a referência/código de barras', N'01', N'01', N'Ver lista na pasta documentation', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(6 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'AILOTE', N'AI do EAN128 para o lote', N'10', N'10', N'Ver lista na pasta documentation', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(7 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'AIVALIDADELOTE', N'AI do EAN128 para a validade do lote', N'17', N'17', N'Ver lista na pasta documentation', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(8 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'AINUMEROSERIE', N'AI do EAN128 para o número de série', N'21', N'21', N'Ver lista na pasta documentation', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(9 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'AIQUANTIDADE', N'AI do EAN128 para a quantidade', N'37', N'37', N'Ver lista na pasta documentation', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(21 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'PACKORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(22 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'PACKORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(21 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'PICKORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(22 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'PICKORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(21 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'RECEORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(22 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'RECEORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(10 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'EAN13VALID', N'EAN13 válidos (para preço)', N'28,29', N'28,29', N'Tipos de EAN13 separados por vírgula ex.(28,29)', N'0', N'1');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'VALIDA_STOCK', N'Valida Stock dos documentos', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(23 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(23 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(23 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(4 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'INSPECTION', N'INCREMENT', N'Incrementa a quantidade do artigo lido', N'1', N'1', N'1-Sim / 0-Não  (Considera-se para tal o mesmo artigo, armazém e lote)', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(24 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo cliente', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(24 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo cliente', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(24 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo fornecedor', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(25 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'ORDER_INTEGRATION', N'Ordenção das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(25 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'ORDER_INTEGRATION', N'Ordenção das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(25 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'ORDER_INTEGRATION', N'Ordenção das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(5 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'ORDER_INTEGRATION', N'Ordenção das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(26 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(26 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'ARTICLE_FILTER_APP', N'Filtro de artigos (Pesquisa de artigos)', N'', N'', N'and ? tabela.campo = xpto', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'EAN13_LEGHT', N'Numero de caracteres do EAN13', N'12', N'12', N'Número de carateres do código de barras EAN13 lido pelo leitor', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(11 AS Numeric(18, 0)), N'AP0002', N'1', N'EAN128', N'EAN1128_LOCKLOTE', N'Deixa alterar o lote quando vem de um EAN128', N'S', N'S', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(27 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'MESSAGE_LINES_QUERY', N'Linhas: Query que corre ao seleccionar uma linha', N'', N'', N'Consulta que vai despoltar um aviso e/ou uma acção ao seleccionar uma linha.'+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords:'+ CHAR(13)+CHAR(10)+'[CHAVECAB] - O campo identificador do documento'+ CHAR(13)+CHAR(10)+'[NUMERODOC] - Número do documento'+ CHAR(13)+CHAR(10)+'[NOMEENTIDADE] - Nome da entidade'+ CHAR(13)+CHAR(10)+'[DATAFINAL] - Data do documento'+ CHAR(13)+CHAR(10)+'[CODIGOENTIDADE] - Código da Entidade'+ CHAR(13)+CHAR(10)+'[CODINTDOCUMENTO] - Código interno do documento'+ CHAR(13)+CHAR(10)+'[NOMEDOCUMENTO] - Nome do documento'+ CHAR(13)+CHAR(10)+'[NUNLINHA] - Número da linha'+ CHAR(13)+CHAR(10)+'[REFARTIGO] - Referência do Artigo', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(27 AS Numeric(18, 0)), N'AP0002', N'1', N'STORE IN', N'MESSAGE_LINES_QUERY', N'Linhas: Query que corre ao seleccionar uma linha', N'', N'', N'Consulta que vai despoltar um aviso e/ou uma acção ao seleccionar uma linha.'+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords:'+ CHAR(13)+CHAR(10)+'[CHAVECAB] - O campo identificador do documento'+ CHAR(13)+CHAR(10)+'[NUMERODOC] - Número do documento'+ CHAR(13)+CHAR(10)+'[NOMEENTIDADE] - Nome da entidade'+ CHAR(13)+CHAR(10)+'[DATAFINAL] - Data do documento'+ CHAR(13)+CHAR(10)+'[CODIGOENTIDADE] - Código da Entidade'+ CHAR(13)+CHAR(10)+'[CODINTDOCUMENTO] - Código interno do documento'+ CHAR(13)+CHAR(10)+'[NOMEDOCUMENTO] - Nome do documento'+ CHAR(13)+CHAR(10)+'[NUNLINHA] - Número da linha'+ CHAR(13)+CHAR(10)+'[REFARTIGO] - Referência do Artigo', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(27 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'MESSAGE_LINES_QUERY', N'Linhas: Query que corre ao seleccionar uma linha', N'', N'', N'Consulta que vai despoltar um aviso e/ou uma acção ao seleccionar uma linha.'+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+'Podem ser utilizadas as seguintes keywords:'+ CHAR(13)+CHAR(10)+'[CHAVECAB] - O campo identificador do documento'+ CHAR(13)+CHAR(10)+'[NUMERODOC] - Número do documento'+ CHAR(13)+CHAR(10)+'[NOMEENTIDADE] - Nome da entidade'+ CHAR(13)+CHAR(10)+'[DATAFINAL] - Data do documento'+ CHAR(13)+CHAR(10)+'[CODIGOENTIDADE] - Código da Entidade'+ CHAR(13)+CHAR(10)+'[CODINTDOCUMENTO] - Código interno do documento'+ CHAR(13)+CHAR(10)+'[NOMEDOCUMENTO] - Nome do documento'+ CHAR(13)+CHAR(10)+'[NUNLINHA] - Número da linha'+ CHAR(13)+CHAR(10)+'[REFARTIGO] - Referência do Artigo', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(4 AS Numeric(18, 0)), N'AP0002', N'1', N'INSPECTION', N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(3 AS Numeric(18, 0)), N'AP0002', N'1', N'ERP', N'RESERVA_QUANTIDADES', N'Reserva quantidades em Primavera', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(102 AS Numeric(18, 0)), N'AP0002', N'1', N'GENERAL', N'MORE_LINES_SAME_PRODUCT', N'Permite inserir novas linhas de produtos existentes no documento de origem', N'', N'', N'Permite inserir novas linhas de produtos existentes no documento de origem', N'0', N'100');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(7 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(6 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(8 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(9 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(11 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(10 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(12 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(15 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(14 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(16 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(13 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(17 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(19 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(18 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(20 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(21 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(23 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(22 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(24 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(25 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(27 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(26 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(28 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(29 AS Numeric(18, 0)), N'AP0002', N'1', N'OTHERS', N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(29 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(28 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(30 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(31 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(33 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(32 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(34 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(35 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(37 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(36 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(38 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(46 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(49 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(48 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(39 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(41 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(40 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(42 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(43 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(45 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(44 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(46 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(47 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(49 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 ddas linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(48 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(50 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(51 AS Numeric(18, 0)), N'AP0002', N'1', N'PICKING', N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Nome do campo de utilizador 3 das linhas onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(29 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(28 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(30 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(31 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Nome do campo de utilizador 1 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(33 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(32 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(34 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD2_SIZE', N'Tamanho do Campo de Utilizador 2 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(35 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Nome do campo de utilizador 2 do cabeçalho onde vai integrar', N'', N'', N'Deve conter o nome do campo de utilizador do cabeçalho onde vai ser integrada a informação', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(37 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD3_TYPE', N'Tipo do Campo de Utilizador 3 do cabeçalho', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(36 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD3_NAME', N'Nome do Campo de Utilizador 3 do cabeçalho', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(38 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'CAB_USER_FIELD3_SIZE', N'Tamanho do Campo de Utilizador 3 do cabeçalho', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(41 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD1_TYPE', N'Tipo do Campo de Utilizador 1 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(40 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD1_NAME', N'Nome do Campo de Utilizador 1 das linhas', N'', N'', N'', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(42 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD1_SIZE', N'Tamanho do Campo de Utilizador 1 das linhas', N'0', N'0', N'0-Sem limite', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(45 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD2_TYPE', N'Tipo do Campo de Utilizador 2 das linhas', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0');
INSERT INTO Kapps_Parameters (ParameterOrder, AppCode, TerminalID, ParameterGroup, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent) VALUES (CAST(44 AS Numeric(18, 0)), N'AP0002', N'1', N'PACKING', N'LIN_USER_FIELD2_NAME', N'Nome do Campo de Utilizador 2 das linhas', N'', N'', N'', N'0', N'0');

INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foram alteradas as colunas "BaseUnit", "BusyUnit", "ConversionFator" nas views de PickingLines, PackingLines e ReceptionLines de alguns ERPs. Caso tenha personalizações, deve confirmar com as views default´s se necessita de efetuar alterações, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 28, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foi alterado o stored procedure "SP_u_Kapps_Products" de forma a ter em consideração as unidades do artigo (base, venda e compra). Se estiver em modo personalizado terá de acrescentar as novas colunas de forma a devolver a informação corretamente', 0, 28, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foi criada uma nova view "v_Kapps_Units". Deverá correr o script para a criação da mesma. Se estiver em modo personalizado terá de construir esta nova view', 0, 28, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Já é possível configurar o código do tipo de documento do inventário a ser integrado, no grupo "Específico ERP"', 0, 29, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Já é possível utilizar extensibilidade! O acesso às funções disponíveis, está no ecrã de configuração de cada terminal', 0, 32, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foram disponibilizadas tabelas de utilizadores (u_Kapps_TU1,u_Kapps_TU2,u_Kapps_TU3,u_Kapps_TU4)', 0, 32, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Nova tabela para gestão de utilizadores', 0, 32, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Nos parâmetros gerais, é possível escolher se os utilizadores são obrigado a terem um PIN code', 0, 32, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Novo parâmetro em cada um dos módulos, que permite indicar se aparece um novo campo no ecrã dos artigos, para indicar o fator multiplicativo.', 0, 32, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Novo parâmetro para indicar o código da propriedade associada ao lote, quando se utiliza o Sage 50C', 0, 33, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Novas configurações para indicar se a caixa é do tipo palete', 0, 35, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Novas configurações para indicar se a etiqueta é do tipo palete', 0, 35, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foram acrescentas as colunas "PurchaseOrder", "MySupplierNumber" na view PackingDocuments. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar as colunas, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foram acrescentas as colunas "NameByLabel", "AdressByLabel" na view v_Kapps_Customers. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar as colunas, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foi acrescentado a coluna "GTIN" na view v_Kapps_Articles. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar a coluna, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foram acrescentados novos parâmetros no grupo do código de barras, necessários para calcular o SSCC, utilizado na impressão de etiquetas de paletes!', 0, 35, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foi acrescentada a coluna "ValidaStock" na view v_Kapps_Documents. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar as colunas, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foram acrescentadas as colunas "DeliveryCustomer" e "DeliveryCode" nas views v_Kapps_Picking_Documents e v_Kapps_Packing_Documents. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar as colunas, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0);
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType) VALUES (N'Foi acrescentada uma nova view v_Kapps_Customers_DeliveryLocations.', 0, 35, 0);

INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_QTY_CNF_REC', N'Ao confirmar quantidade na receção');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_QTY_CNF_PICK', N'Ao confirmar quantidade na picking');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_QTY_CNF_PACK', N'Ao confirmar quantidade no packing');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_BTN_CLK_PICK', N'Botão de impressão no picking');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_BTN_CLK_PACK', N'Botão de impressão no packing');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_BTN_CLK_REC', N'Botão de impressão na receção');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_OPEN_NEW_BOX_PACK', N'Abrir uma caixa nova');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_CLOSE_BOX_PACK', N'Fechar uma caixa');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_BTN_PRINT_PRICE_CHECKING', N'Verificar Preço');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_QTY_CNF_OTHER', N'Ao confirmar quantidade nos outros documentos');
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES (N'EVT_ON_BTN_CLK_OTHER', N'Botão de impressão nos outros documentos');
 
IF NOT EXISTS (select * FROM u_KApps_Terminals) 
BEGIN
	INSERT INTO u_KApps_Terminals(TerminalID,TerminalDescription) SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY c1.id),'' FROM syscolumns AS c1;
END
 
ALTER TABLE u_Kapps_Alerts ADD  CONSTRAINT DF_u_Kapps_Alerts_Alert  DEFAULT ('') FOR Alert;
ALTER TABLE u_Kapps_Alerts ADD  CONSTRAINT DF_u_Kapps_Alerts_Show  DEFAULT ((1)) FOR Show;
ALTER TABLE u_Kapps_Alerts ADD  CONSTRAINT DF_u_Kapps_Alerts_DatabaseVersion  DEFAULT ((0)) FOR DatabaseVersion;
ALTER TABLE u_Kapps_Alerts ADD  CONSTRAINT DF_u_Kapps_Alerts_AlertType  DEFAULT ((0)) FOR AlertType;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_QtyUM  DEFAULT ('') FOR QtyUM;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_Qty2  DEFAULT ((0)) FOR Qty2;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_Qty2UM  DEFAULT ('') FOR Qty2UM;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_StampDocGer  DEFAULT ('') FOR StampDocGer;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_WarehouseOut  DEFAULT ('') FOR WarehouseOut;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_TerminalID  DEFAULT ((0)) FOR TerminalID;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_OriLineNumber  DEFAULT ((0)) FOR OriLineNumber;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_LineClose  DEFAULT ((0)) FOR LineClose;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_CabUserField1  DEFAULT ('') FOR CabUserField1;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_CabUserField2  DEFAULT ('') FOR CabUserField2;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_CabUserField3  DEFAULT ('') FOR CabUserField3;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_LinUserField1  DEFAULT ('') FOR LinUserField1;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_LinUserField2  DEFAULT ('') FOR LinUserField2;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_LinUserField3  DEFAULT ('') FOR LinUserField3;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_GTIN  DEFAULT ('') FOR GTIN;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_DeliveryCustomer  DEFAULT ('') FOR DeliveryCustomer;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_DeliveryCode  DEFAULT ('') FOR DeliveryCode;
ALTER TABLE u_Kapps_InvHeader ADD  CONSTRAINT DF_u_Kapps_InvHeader_Terminal  DEFAULT ((0)) FOR Terminal;
ALTER TABLE u_Kapps_InvHeader ADD  CONSTRAINT DF_u_Kapps_InvHeader_Status  DEFAULT ('') FOR Status;
ALTER TABLE u_Kapps_InvHeader ADD  CONSTRAINT DF_u_Kapps_InvHeader_Syncr  DEFAULT ('N') FOR Syncr;
ALTER TABLE u_Kapps_InvHeader ADD  CONSTRAINT DF_u_Kapps_InvHeader_Name  DEFAULT ('') FOR Name;
ALTER TABLE u_Kapps_InvHeader ADD  CONSTRAINT DF_u_Kapps_InvHeader_Stamp  DEFAULT ('') FOR Stamp;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_StampLin  DEFAULT ('') FOR StampLin;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_StampHeader  DEFAULT ('') FOR StampHeader;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_Ref  DEFAULT ('') FOR Ref;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_Qty  DEFAULT ((0)) FOR Qty;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_Lot  DEFAULT ('') FOR Lot;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_SerialNumber  DEFAULT ('') FOR SerialNumber;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_Warehouse  DEFAULT ('') FOR Warehouse;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_Syncr  DEFAULT ('N') FOR Syncr;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_Description  DEFAULT ('') FOR Description;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_Validade  DEFAULT ('') FOR Validade;
ALTER TABLE u_Kapps_InvLines ADD  CONSTRAINT DF_u_Kapps_InvLines_SSCC  DEFAULT ('') FOR SSCC;
ALTER TABLE u_Kapps_LabelRules ADD  CONSTRAINT DF_u_Kapps_LabelRules_ConfirmaImpressao  DEFAULT ((0)) FOR ConfirmaImpressao;
ALTER TABLE u_Kapps_Labels ADD  CONSTRAINT DF_u_Kapps_Labels_Palete  DEFAULT ((0)) FOR Palete;
ALTER TABLE u_Kapps_Log ADD  CONSTRAINT DF_u_Kapps_Log_LogStamp  DEFAULT ('') FOR LogStamp;
ALTER TABLE u_Kapps_Log ADD  CONSTRAINT DF_u_Kapps_Log_LogType  DEFAULT ((0)) FOR LogType;
ALTER TABLE u_Kapps_Log ADD  CONSTRAINT DF_u_Kapps_Log_LogMessage  DEFAULT ('') FOR LogMessage;
ALTER TABLE u_Kapps_Log ADD  CONSTRAINT DF_u_Kapps_Log_LogDetail  DEFAULT ('') FOR LogDetail;
ALTER TABLE u_Kapps_PackagingTypes ADD  CONSTRAINT DF_u_Kapps_PackagingTypes_Palete  DEFAULT ((0)) FOR Palete;
ALTER TABLE u_Kapps_PackingHeader ADD  CONSTRAINT DF_u_Kapps_PackingHeader_Palete  DEFAULT ((0)) FOR Palete;
ALTER TABLE u_Kapps_PackingHeader ADD  CONSTRAINT DF_u_Kapps_PackingHeader_SSCC  DEFAULT ('') FOR SSCC;
ALTER TABLE u_Kapps_Users ADD  CONSTRAINT DF_u_Kapps_Users_Username  DEFAULT ('') FOR Username;
ALTER TABLE u_Kapps_Users ADD  CONSTRAINT DF_u_Kapps_Users_Name  DEFAULT ('') FOR Name;
ALTER TABLE u_Kapps_Users ADD  CONSTRAINT DF_u_Kapps_Users_PIN  DEFAULT ('') FOR PIN;
