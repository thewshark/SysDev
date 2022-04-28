CREATE TABLE u_Kapps_Alerts(
	Alert varchar(512) NOT NULL,
	Show bit NOT NULL,
	DatabaseVersion int NOT NULL,
	AlertType int NOT NULL,
	AlertCod int IDENTITY(1,1) NOT NULL
);
ALTER TABLE u_Kapps_Alerts ADD CONSTRAINT PK_u_Kapps_Alerts PRIMARY KEY (AlertCod);

CREATE TABLE u_Kapps_DossierLin(
	StampLin nvarchar(50) NULL,
	StampBo nvarchar(50) NULL,
	StampBi nvarchar(50) NULL,
	Ref nvarchar(60) NULL,
	Description nvarchar(100) NULL,
	Qty decimal(18, 3) NULL,
	Lot nvarchar(50) NULL,
	Serial nvarchar(50) NULL,
	UserID nvarchar(50) NULL,
	MovDate nvarchar(8) NULL,
	MovTime nvarchar(6) NULL,
	Status nvarchar(50) NULL,
	DocType nvarchar(50) NULL,
	DocNumber nvarchar(50) NULL,
	Integrada nvarchar(50) NULL,
	DataIntegracao nvarchar(8) NULL,
	HoraIntegracao nvarchar(6) NULL,
	UserIntegracao nvarchar(50) NULL,
	Process nvarchar(50) NULL,
	Validade nvarchar(50) NULL,
	Warehouse nvarchar(50) NULL,
	Location nvarchar(50) NULL,
	ExternalDocNum nvarchar(50) NULL,
	EntityType nvarchar(50) NULL,
	EntityNumber nvarchar(50) NULL,
	InternalStampDoc nvarchar(50) NULL,
	DestinationDocType nvarchar(50) NULL,
	TransactionDescription nvarchar(50) NULL,
	EntityName nvarchar(255) NULL,
	DocName nvarchar(50) NULL,
	VatNumber nvarchar(50) NULL,
	UnitPrice decimal(18, 6) NULL,
	QtyUM varchar(25) NOT NULL,
	Qty2 decimal(18, 3) NOT NULL,
	Qty2UM varchar(25) NOT NULL,
	StampDocGer varchar(50) NOT NULL,
	WarehouseOut varchar(50) NULL,
	TerminalID int NULL,
	OriLineNumber int NULL,
	LineClose bit NULL,
	CabUserField1 varchar(4000) NULL,
	CabUserField2 varchar(4000) NULL,
	CabUserField3 varchar(4000) NULL,
	LinUserField1 varchar(4000) NULL,
	LinUserField2 varchar(4000) NULL,
	LinUserField3 varchar(4000) NULL,
	GTIN varchar(50) NOT NULL,
	DeliveryCustomer nvarchar(12) NOT NULL,
	DeliveryCode nvarchar(60) NOT NULL,
	OriginalLot nvarchar(50) NULL,
	OriginalLocation nvarchar(50) NULL,
	LocationOUT nvarchar(50) NULL,
	DefaultWarehouse varchar(50) NULL,
	DefaultLocation varchar(50) NULL,
	DefaultWarehouseOut varchar(50) NULL,
	DefaultLocationOut varchar(50) NULL,
	InternalDocType nvarchar(10) NOT NULL,
	InternalQty decimal(18, 3) NOT NULL,
	ExpeditionWarehouse nvarchar(50) NULL,
	ExpeditionLocation nvarchar(50) NULL,
	StockBreakReason nvarchar(300) NOT NULL,
	ProductionDate varchar(8) NULL,
	NetWeight decimal(18, 3) NULL,
	SSCC nvarchar(50) NOT NULL,
	KeyDocGerado nvarchar(50) NOT NULL
);
SET ANSI_PADDING ON;
CREATE CLUSTERED INDEX IX_u_Kapps_DossierLin_QtdFilter ON u_Kapps_DossierLin
(
	Status ASC,
	Integrada ASC,
	StampBo ASC,
	StampBi ASC
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Events(
	EventID nvarchar(100) NOT NULL,
	EventDescription nvarchar(200) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_InquiryAnswersHeader(
	InquiryAnswerHeaderUniqueID nvarchar(100) NOT NULL,
	InquiryAnswerHeaderID nvarchar(100) NOT NULL,
	InquiryDescription nvarchar(100) NULL,
	InquiryDate nvarchar(8) NULL,
	InquiryTime nvarchar(6) NULL,
	InquiryUser nvarchar(50) NULL,
	SyslogProcessType nvarchar(100) NULL,
	SyslogProcessID nvarchar(100) NULL,
	EntityID nvarchar(50) NULL,
	EntityType nvarchar(50) NULL,
	EntityName nvarchar(100) NULL,
 CONSTRAINT PK_u_Kapps_InquiryAnswersHeader PRIMARY KEY CLUSTERED 
(
	InquiryAnswerHeaderUniqueID ASC,
	InquiryAnswerHeaderID ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_InquiryAnswersStamps(
	id int IDENTITY(1,1) NOT NULL,
	InquiryAnswersHeaderUniqueID nvarchar(100) NULL,
	StampBo nvarchar(50) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_InquiryHeader(
	InquiryHeaderUniqueID nvarchar(100) NOT NULL,
	Description nvarchar(100) NULL,
 CONSTRAINT PK_u_Kapps_InquiryHeader PRIMARY KEY CLUSTERED 
(
	InquiryHeaderUniqueID ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_InquiryQuestions(
	InquiryHeaderUniqueID nvarchar(100) NOT NULL,
	InquiryQuestionUniqueID nvarchar(100) NOT NULL,
	InquiryQuestionPosition int NULL,
	InquiryQuestionName nvarchar(100) NULL,
	InquiryQuestionType nvarchar(1) NULL,
	InquiryQuestionMinValue numeric(11, 3) NULL,
	InquiryQuestionMaxValue numeric(11, 3) NULL,
	InquiryQuestionMandatory nvarchar(1) NULL,
	InquiryQuestionAnswerList nvarchar(1000) NULL,
	InquiryQuestionAutoFill nvarchar(1) NULL,
 CONSTRAINT PK_u_Kapps_InquiryQuestions PRIMARY KEY CLUSTERED 
(
	InquiryHeaderUniqueID ASC,
	InquiryQuestionUniqueID ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_InquiryQuestionsAnswers(
	InquiryAnswersHeaderUniqueID nvarchar(100) NULL,
	InquiryQuestionsAnswerUniqueID nvarchar(100) NOT NULL,
	InquiryHeaderID nvarchar(100) NULL,
	QuestionID nvarchar(100) NULL,
	QuestionName nvarchar(100) NULL,
	QuestionType nvarchar(1) NULL,
	QuestionAnswer nvarchar(1000) NULL,
	AutoFill nvarchar(1) NULL,
 CONSTRAINT PK_InquiryQuestionsAnswers PRIMARY KEY CLUSTERED 
(
	InquiryQuestionsAnswerUniqueID ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_InquirySchedule(
	id int IDENTITY(1,1) NOT NULL,
	InquiryID nvarchar(100) NULL,
	InitialDate nvarchar(50) NULL,
	FinalDate nvarchar(8) NULL,
	ProcessID nvarchar(25) NULL,
	EntityType nvarchar(50) NULL,
	EntityNumber nvarchar(50) NULL,
	Actif nvarchar(1) NULL,
	ActiveWhen nvarchar(1) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_InvHeader(
	Terminal int NOT NULL,
	Date datetime NULL,
	Status varchar(1) NOT NULL,
	Syncr varchar(1) NOT NULL,
	Name varchar(50) NULL,
	Stamp varchar(25) NOT NULL,
 CONSTRAINT PK_u_Kapps_InvHeader_1 PRIMARY KEY CLUSTERED 
(
	Stamp ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_InvLines(
	StampLin varchar(25) NOT NULL,
	StampHeader varchar(25) NOT NULL,
	Ref varchar(50) NOT NULL,
	Qty numeric(18, 5) NOT NULL,
	Lot varchar(100) NOT NULL,
	SerialNumber varchar(100) NOT NULL,
	Warehouse varchar(50) NOT NULL,
	Syncr varchar(1) NOT NULL,
	Description varchar(255) NULL,
	Date datetime NULL,
	Validade varchar(8) NULL,
	SSCC nvarchar(50) NOT NULL,
	Location nvarchar(50) NULL,
 CONSTRAINT PK_u_Kapps_InvLines PRIMARY KEY CLUSTERED 
(
	StampLin ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_LabelRules(
	ID nvarchar(100) NULL,
	TerminalId nvarchar(4) NULL,
	EventId nvarchar(100) NULL,
	PrinterId nvarchar(100) NULL,
	LabelId nvarchar(100) NULL,
	CustomerId nvarchar(100) NULL,
	CustomerAddressId nvarchar(200) NULL,
	TransporterAddressID nvarchar(100) NULL,
	Nrlabels nvarchar(100) NULL,
	Actif nvarchar(1) NULL,
	ConfirmaImpressao bit NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Labels(
	LabelId nvarchar(100) NULL,
	LabelDescription nvarchar(200) NULL,
	LabelEvent nvarchar(100) NULL,
	LabelCode varchar(4000) NULL,
	Actif nvarchar(1) NULL,
	Palete bit NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Log(
	LogStamp varchar(50) NOT NULL,
	LogType int NOT NULL,
	LogMessage varchar(255) NOT NULL,
	LogDetail varchar(4000) NOT NULL,
	LogTerminal int NULL,
 CONSTRAINT PK_u_Kapps_Log PRIMARY KEY CLUSTERED 
(
	LogStamp ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Messages(
	MesssageUniqueID varchar(100) NOT NULL,
	SentBy varchar(50) NULL,
	SentDate varchar(8) NULL,
	SentTime varchar(6) NULL,
	SentTo varchar(50) NULL,
	Message varchar(1000) NULL,
	Readed varchar(1) NULL,
	ReadDate varchar(8) NULL,
	ReadTime varchar(6) NULL,
	Priority varchar(50) NULL,
	OriginMessageID varchar(100) NOT NULL,
	BlockingMessage varchar(1) NULL,
 CONSTRAINT PK_u_Kapps_Messages PRIMARY KEY CLUSTERED 
(
	MesssageUniqueID ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_PackagingTypes(
	PackType nvarchar(100) NULL,
	Description nvarchar(200) NULL,
	Height numeric(18, 0) NULL,
	Lenght numeric(18, 0) NULL,
	Width numeric(18, 0) NULL,
	Weight numeric(18, 0) NULL,
	Type nvarchar(100) NULL,
	Status numeric(1, 0) NULL,
	Palete bit NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_PackingDetails(
	PackID nvarchar(100) NULL,
	LineID nvarchar(100) NULL,
	StampLin nvarchar(100) NULL,
	Ref nchar(100) NULL,
	Description nchar(200) NULL,
	Lot nvarchar(100) NULL,
	Serial nvarchar(100) NULL,
	Quantity decimal(18, 3) NULL,
	ExpirationDate varchar(15) NULL,
	Status nchar(1) NULL,
	Location nvarchar(50) NOT NULL,
	NetWeight decimal(18, 3) NULL,
	SSCC nvarchar(50) NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_PackingHeader(
	PackId nvarchar(100) NULL,
	CreationDate nvarchar(8) NULL,
	CreationTime nvarchar(4) NULL,
	EndDate nvarchar(8) NULL,
	EndTime nvarchar(4) NULL,
	UserId nvarchar(100) NULL,
	CustomerId nvarchar(100) NULL,
	CustomerName nvarchar(200) NULL,
	Status nvarchar(1) NULL,
	Height numeric(18, 0) NULL,
	Lenght numeric(18, 0) NULL,
	Width numeric(18, 0) NULL,
	Weight numeric(18, 0) NULL,
	PackType nvarchar(100) NULL,
	Palete bit NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Parameters(
	id int IDENTITY(1,1) NOT NULL,
	AppCode nvarchar(50) NOT NULL,
	ParameterType nvarchar(50) NOT NULL,
	ParameterGroup nvarchar(100) NOT NULL,
	ParameterOrder numeric(18, 0) NULL,
	ParameterID nvarchar(50) NOT NULL,
	ParameterDescription nvarchar(100) NULL,
	ParameterValue nvarchar(4000) NULL,
	ParameterDefaultValue nvarchar(4000) NULL,
	ParameterInfo nvarchar(4000) NULL,
	ParameterRequired nvarchar(1) NULL,
	ParameterDependent nvarchar(50) NULL,
	ParameterERP nvarchar(200) NULL,
 CONSTRAINT PK_u_Kapps_Parameters PRIMARY KEY CLUSTERED 
(
	AppCode ASC,
	ParameterType ASC,
	ParameterGroup ASC,
	ParameterID ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_ParametersMonitors(
	id int IDENTITY(1,1) NOT NULL,
	AppCode nvarchar(10) NULL,
	ConfigurationID int NULL,
	ConfigurationName nvarchar(100) NULL,
	Timer int NULL,
	PickingActive bit NULL,
	ReceptionActive bit NULL,
	PickingColumnNames nvarchar(1000) NULL,
	PickingColumnSizes nvarchar(100) NULL,
	ReceptionColumnNames nvarchar(1000) NULL,
	ReceptionColumnSizes nvarchar(100) NULL,
	PickingDocLinesSQL nvarchar(max) NULL,
	PickingDocTotalsSQL nvarchar(max) NULL,
	PickingRowTotalsSQL nvarchar(max) NULL,
	ReceptionDocLinesSQL nvarchar(max) NULL,
	ReceptionDocTotalsSQL nvarchar(max) NULL,
	ReceptionRowTotalsSQL nvarchar(max) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_ParametersTypes(
	TypeID varchar(25) NOT NULL,
	Name varchar(100) NULL,
	IsParameter int NOT NULL,
	TypeOrder int NOT NULL,
	DefaultDescription varchar(1000) NOT NULL,
 CONSTRAINT PK_u_Kapps_ParametersTypes PRIMARY KEY CLUSTERED 
(
	TypeID ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Printers(
	PrinterId nvarchar(100) NULL,
	PrinterDescription nvarchar(200) NULL,
	CommType nvarchar(100) NULL,
	IP_MacAddress_com nvarchar(100) NULL,
	Port nvarchar(100) NULL,
	Actif nvarchar(1) NULL,
	ServiceUUID nvarchar(50) NOT NULL,
	CharacteristicUUID nvarchar(50) NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Processes(
	id int IDENTITY(1,1) NOT NULL,
	ProcessID varchar(25) NOT NULL,
	TypeID varchar(25) NULL,
	Name varchar(100) NULL,
	Description varchar(1000) NULL,
	ProcessOrder int NOT NULL,
 CONSTRAINT PK_u_Kapps_Processes_1 PRIMARY KEY CLUSTERED 
(
	id ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Serials(
	id bigint IDENTITY(1,1) NOT NULL,
	StampLin nvarchar(50) NULL,
	Serial nvarchar(50) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Session_Docs(
	AppCode nvarchar(100) NULL,
	TerminalID nvarchar(100) NULL,
	SessionID nvarchar(100) NULL,
	SessionUserID nvarchar(100) NULL,
	SessionDocNumber nvarchar(100) NULL,
	SessionStartDateTime nvarchar(100) NULL,
	SessionEndDateTime nvarchar(100) NULL,
	SessionType nvarchar(100) NULL,
	SessionDocument nvarchar(100) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Session_Users(
	AppCode nvarchar(100) NULL,
	TerminalID nvarchar(100) NULL,
	SessionID nvarchar(100) NULL,
	SessionUser nvarchar(100) NULL,
	SessionLogInDateTime nvarchar(100) NULL,
	SessionLogOutDateTime nvarchar(100) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_StockDocs(
	Stamp nvarchar(25) NOT NULL,
	Warehouse nvarchar(50) NOT NULL,
	Terminal int NOT NULL,
	DocDate datetime NULL,
	Status varchar(1) NOT NULL,
	Syncr varchar(1) NOT NULL,
	Name varchar(50) NULL,
	ZoneLocation nvarchar(50) NOT NULL,
	Location nvarchar(50) NOT NULL,
 CONSTRAINT PK_u_Kapps_StockDocs PRIMARY KEY CLUSTERED 
(
	Stamp ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_StockLines(
	StampLin nvarchar(50) NOT NULL,
	OrigStampHeader nvarchar(50) NOT NULL,
	OrigStampLin nvarchar(50) NOT NULL,
	Warehouse nvarchar(50) NOT NULL,
	Location nvarchar(50) NOT NULL,
	Lot nvarchar(50) NOT NULL,
	Ref nvarchar(60) NOT NULL,
	Description nvarchar(100) NOT NULL,
	Qty numeric(18, 5) NOT NULL,
	SerialNumber nvarchar(50) NOT NULL,
	MovDate datetime NULL,
	TerminalID int NOT NULL,
	UserID nvarchar(50) NOT NULL,
	Status nvarchar(1) NOT NULL,
	Syncr nvarchar(1) NOT NULL,
	SyncrDate datetime NULL,
	SyncrUser nvarchar(50) NOT NULL,
	Validade varchar(8) NULL,
	ProductionDate varchar(8) NULL,
	InternalStampDoc nvarchar(50) NULL,
 CONSTRAINT PK_u_Kapps_StockLines PRIMARY KEY CLUSTERED 
(
	StampLin ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Terminals(
	TerminalID nvarchar(100) NULL,
	TerminalDescription nvarchar(1000) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Transporters(
	TransporterId nvarchar(4) NULL,
	TransporterName nvarchar(100) NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_TU1(
	TU1KU1 varchar(200) NULL,
	TU1KU2 varchar(200) NULL,
	TU1KU3 varchar(200) NULL,
	TU1KU4 varchar(200) NULL,
	TU1F01 varchar(400) NULL,
	TU1F02 varchar(400) NULL,
	TU1F03 varchar(400) NULL,
	TU1F04 varchar(400) NULL,
	TU1F05 varchar(400) NULL,
	TU1F06 varchar(400) NULL,
	TU1F07 varchar(400) NULL,
	TU1F08 varchar(400) NULL,
	TU1F09 varchar(400) NULL,
	TU1F10 varchar(400) NULL,
	TU1TER int NULL,
	ROWID bigint IDENTITY(1,1) NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_TU2(
	TU2KU1 varchar(200) NULL,
	TU2KU2 varchar(200) NULL,
	TU2KU3 varchar(200) NULL,
	TU2KU4 varchar(200) NULL,
	TU2F01 varchar(400) NULL,
	TU2F02 varchar(400) NULL,
	TU2F03 varchar(400) NULL,
	TU2F04 varchar(400) NULL,
	TU2F05 varchar(400) NULL,
	TU2F06 varchar(400) NULL,
	TU2F07 varchar(400) NULL,
	TU2F08 varchar(400) NULL,
	TU2F09 varchar(400) NULL,
	TU2F10 varchar(400) NULL,
	TU2TER int NULL,
	ROWID bigint IDENTITY(1,1) NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_TU3(
	TU3KU1 varchar(200) NULL,
	TU3KU2 varchar(200) NULL,
	TU3KU3 varchar(200) NULL,
	TU3KU4 varchar(200) NULL,
	TU3KU5 bigint NULL,
	TU3KU6 bigint NULL,
	TU3KU7 bigint NULL,
	TU3KU8 bigint NULL,
	TU3F01 varchar(400) NULL,
	TU3F02 varchar(400) NULL,
	TU3F03 varchar(400) NULL,
	TU3F04 varchar(400) NULL,
	TU3F05 varchar(400) NULL,
	TU3F06 varchar(400) NULL,
	TU3F07 varchar(400) NULL,
	TU3F08 varchar(400) NULL,
	TU3F09 varchar(400) NULL,
	TU3F10 varchar(400) NULL,
	TU3F11 varchar(1000) NULL,
	TU3F12 varchar(1000) NULL,
	TU3F13 varchar(1000) NULL,
	TU3F14 varchar(1000) NULL,
	TU3F15 varchar(1000) NULL,
	TU3F16 varchar(1000) NULL,
	TU3F17 varchar(1000) NULL,
	TU3F18 varchar(1000) NULL,
	TU3F19 varchar(1000) NULL,
	TU3F20 varchar(1000) NULL,
	TU3F21 bigint NULL,
	TU3F22 bigint NULL,
	TU3F23 bigint NULL,
	TU3F24 bigint NULL,
	TU3F25 bigint NULL,
	TU3F26 bigint NULL,
	TU3F27 bigint NULL,
	TU3F28 bigint NULL,
	TU3F29 bigint NULL,
	TU3F30 bigint NULL,
	TU3F31 decimal(15, 6) NULL,
	TU3F32 decimal(15, 6) NULL,
	TU3F33 decimal(15, 6) NULL,
	TU3F34 decimal(15, 6) NULL,
	TU3F35 decimal(15, 6) NULL,
	TU3F36 decimal(15, 6) NULL,
	TU3F37 decimal(15, 6) NULL,
	TU3F38 decimal(15, 6) NULL,
	TU3F39 decimal(15, 6) NULL,
	TU3F40 decimal(15, 6) NULL,
	TU3TER int NULL,
	ROWID bigint IDENTITY(1,1) NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_TU4(
	TU4KU1 varchar(200) NULL,
	TU4KU2 varchar(200) NULL,
	TU4KU3 varchar(200) NULL,
	TU4KU4 varchar(200) NULL,
	TU4KU5 bigint NULL,
	TU4KU6 bigint NULL,
	TU4KU7 bigint NULL,
	TU4KU8 bigint NULL,
	TU4F01 varchar(400) NULL,
	TU4F02 varchar(400) NULL,
	TU4F03 varchar(400) NULL,
	TU4F04 varchar(400) NULL,
	TU4F05 varchar(400) NULL,
	TU4F06 varchar(400) NULL,
	TU4F07 varchar(400) NULL,
	TU4F08 varchar(400) NULL,
	TU4F09 varchar(400) NULL,
	TU4F10 varchar(400) NULL,
	TU4F11 varchar(1000) NULL,
	TU4F12 varchar(1000) NULL,
	TU4F13 varchar(1000) NULL,
	TU4F14 varchar(1000) NULL,
	TU4F15 varchar(1000) NULL,
	TU4F16 varchar(1000) NULL,
	TU4F17 varchar(1000) NULL,
	TU4F18 varchar(1000) NULL,
	TU4F19 varchar(1000) NULL,
	TU4F20 varchar(1000) NULL,
	TU4F21 bigint NULL,
	TU4F22 bigint NULL,
	TU4F23 bigint NULL,
	TU4F24 bigint NULL,
	TU4F25 bigint NULL,
	TU4F26 bigint NULL,
	TU4F27 bigint NULL,
	TU4F28 bigint NULL,
	TU4F29 bigint NULL,
	TU4F30 bigint NULL,
	TU4F31 decimal(15, 6) NULL,
	TU4F32 decimal(15, 6) NULL,
	TU4F33 decimal(15, 6) NULL,
	TU4F34 decimal(15, 6) NULL,
	TU4F35 decimal(15, 6) NULL,
	TU4F36 decimal(15, 6) NULL,
	TU4F37 decimal(15, 6) NULL,
	TU4F38 decimal(15, 6) NULL,
	TU4F39 decimal(15, 6) NULL,
	TU4F40 decimal(15, 6) NULL,
	TU4TER int NULL,
	ROWID bigint IDENTITY(1,1) NOT NULL
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_Users(
	Username varchar(50) NOT NULL,
	Name varchar(50) NOT NULL,
	PIN varchar(10) NOT NULL,
	Actif bit NOT NULL,
	AcessoBackoffice varchar(1) NULL,
	AcessoTerminal varchar(1) NULL
);
ALTER TABLE u_Kapps_Users ADD CONSTRAINT PK_u_Kapps_Users PRIMARY KEY (Username);

CREATE TABLE u_Kapps_UsersProcesses(
	Username varchar(50) NOT NULL,
	ProcessID varchar(25) NOT NULL,
 CONSTRAINT PK_u_Kapps_UsersProcesses PRIMARY KEY CLUSTERED 
(
	Username ASC,
	ProcessID ASC
)
);
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE u_Kapps_UsersWarehouses(
	Username varchar(50) NOT NULL,
	Warehouse varchar(50) NOT NULL,
 CONSTRAINT PK_u_Kapps_UsersWarehouses PRIMARY KEY CLUSTERED 
(
	Username ASC,
	Warehouse ASC
)
);
SET ANSI_PADDING ON;
CREATE NONCLUSTERED INDEX IX_u_Kapps_Parameters_Group_ID ON u_Kapps_Parameters
(
	ParameterGroup ASC,
	ParameterID ASC
);



IF NOT EXISTS (select * FROM u_KApps_Terminals) 
BEGIN
	INSERT INTO u_Kapps_Terminals(TerminalID,TerminalDescription) SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY c1.id),'' FROM syscolumns AS c1;
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
ALTER TABLE u_Kapps_DossierLin ADD  DEFAULT ('') FOR InternalDocType;
ALTER TABLE u_Kapps_DossierLin ADD  DEFAULT ((0)) FOR InternalQty;
ALTER TABLE u_Kapps_DossierLin ADD  DEFAULT ('') FOR StockBreakReason;
ALTER TABLE u_Kapps_DossierLin ADD  CONSTRAINT DF_u_Kapps_DossierLin_ProductionDate  DEFAULT ('') FOR ProductionDate;
ALTER TABLE u_Kapps_DossierLin ADD  DEFAULT ((0)) FOR NetWeight;
ALTER TABLE u_Kapps_DossierLin ADD  DEFAULT ('') FOR SSCC;
ALTER TABLE u_Kapps_DossierLin ADD  DEFAULT ('') FOR KeyDocGerado;
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
ALTER TABLE u_Kapps_Log ADD  DEFAULT ((0)) FOR LogTerminal;
ALTER TABLE u_Kapps_Messages ADD  DEFAULT ('') FOR OriginMessageID;
ALTER TABLE u_Kapps_Messages ADD  DEFAULT ('') FOR BlockingMessage;
ALTER TABLE u_Kapps_PackagingTypes ADD  CONSTRAINT DF_u_Kapps_PackagingTypes_Palete  DEFAULT ((0)) FOR Palete;
ALTER TABLE u_Kapps_PackingDetails ADD  DEFAULT ('') FOR Location;
ALTER TABLE u_Kapps_PackingDetails ADD  DEFAULT ((0)) FOR NetWeight;
ALTER TABLE u_Kapps_PackingDetails ADD  DEFAULT ('') FOR SSCC;
ALTER TABLE u_Kapps_PackingHeader ADD  CONSTRAINT DF_u_Kapps_PackingHeader_Palete  DEFAULT ((0)) FOR Palete;
ALTER TABLE u_Kapps_Parameters ADD  CONSTRAINT DF_u_Kapps_Parameters_ParameterERP  DEFAULT ('') FOR ParameterERP;
ALTER TABLE u_Kapps_ParametersTypes ADD  CONSTRAINT DF_u_Kapps_ParametersTypes_IsParameter  DEFAULT ((0)) FOR IsParameter;
ALTER TABLE u_Kapps_ParametersTypes ADD  CONSTRAINT DF_u_Kapps_ParametersTypes_DefaultDescription  DEFAULT ('') FOR DefaultDescription;
ALTER TABLE u_Kapps_Printers ADD  DEFAULT ('') FOR ServiceUUID;
ALTER TABLE u_Kapps_Printers ADD  DEFAULT ('') FOR CharacteristicUUID;
ALTER TABLE u_Kapps_Processes ADD  CONSTRAINT DF_u_Kapps_Processes_ProcessOrder  DEFAULT ((0)) FOR ProcessOrder;
ALTER TABLE u_Kapps_StockDocs ADD  CONSTRAINT DF_u_Kapps_StockDocs_Stamp  DEFAULT ('') FOR Stamp;
ALTER TABLE u_Kapps_StockDocs ADD  CONSTRAINT DF_u_Kapps_StockDocs_Warehouse  DEFAULT ('') FOR Warehouse;
ALTER TABLE u_Kapps_StockDocs ADD  CONSTRAINT DF_u_Kapps_StockDocs_Terminal  DEFAULT ((0)) FOR Terminal;
ALTER TABLE u_Kapps_StockDocs ADD  CONSTRAINT DF_u_Kapps_StockDocs_Status  DEFAULT ('') FOR Status;
ALTER TABLE u_Kapps_StockDocs ADD  CONSTRAINT DF_u_Kapps_StockDocs_Syncr  DEFAULT ('N') FOR Syncr;
ALTER TABLE u_Kapps_StockDocs ADD  CONSTRAINT DF_u_Kapps_StockDocs_Name  DEFAULT ('') FOR Name;
ALTER TABLE u_Kapps_StockDocs ADD  DEFAULT ('') FOR ZoneLocation;
ALTER TABLE u_Kapps_StockDocs ADD  DEFAULT ('') FOR Location;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_OrigStampHeader  DEFAULT ('') FOR OrigStampHeader;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_OrigStampLin  DEFAULT ('') FOR OrigStampLin;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Warehouse  DEFAULT ('') FOR Warehouse;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Location  DEFAULT ('') FOR Location;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Lot  DEFAULT ('') FOR Lot;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Ref  DEFAULT ('') FOR Ref;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Description  DEFAULT ('') FOR Description;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Qty  DEFAULT ((0)) FOR Qty;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_SerialNumber  DEFAULT ('') FOR SerialNumber;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_TerminalID  DEFAULT ((0)) FOR TerminalID;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_UserID  DEFAULT ('') FOR UserID;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Status  DEFAULT ('') FOR Status;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Syncr  DEFAULT ('') FOR Syncr;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_SyncrUser  DEFAULT ('') FOR SyncrUser;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_Validade  DEFAULT ('') FOR Validade;
ALTER TABLE u_Kapps_StockLines ADD  CONSTRAINT DF_u_Kapps_StockLines_ProductionDate  DEFAULT ('') FOR ProductionDate;
ALTER TABLE u_Kapps_StockLines ADD  DEFAULT ('') FOR InternalStampDoc;
ALTER TABLE u_Kapps_Users ADD  CONSTRAINT DF_u_Kapps_Users_Username  DEFAULT ('') FOR Username;
ALTER TABLE u_Kapps_Users ADD  CONSTRAINT DF_u_Kapps_Users_Name  DEFAULT ('') FOR Name;
ALTER TABLE u_Kapps_Users ADD  CONSTRAINT DF_u_Kapps_Users_PIN  DEFAULT ('') FOR PIN;
ALTER TABLE u_Kapps_Users ADD  DEFAULT ((1)) FOR Actif;
ALTER TABLE u_Kapps_Users ADD  DEFAULT ('') FOR AcessoBackoffice;
ALTER TABLE u_Kapps_Users ADD  DEFAULT ('') FOR AcessoTerminal;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/*
CREATE TRIGGER [UpdateLineNumber]
ON [u_Kapps_PackingDetails]
 AFTER INSERT
AS
BEGIN
	UPDATE det set LineID = (SELECT MAX(LineID) + 1 FROM u_Kapps_PackingDetails) FROM u_Kapps_PackingDetails det JOIN inserted ins on det.StampLin = ins.StampLin and det.PackID = ins.PackID
END	;
ALTER TABLE [dbo].[u_Kapps_PackingDetails] ENABLE TRIGGER [UpdateLineNumber];
*/





SET IDENTITY_INSERT [u_Kapps_Alerts] ON 
GO
INSERT INTO u_Kapps_Alerts (Alert, Show, DatabaseVersion, AlertType, AlertCod) VALUES 
(N'Foram alteradas as colunas "BaseUnit", "BusyUnit", "ConversionFator" nas views de PickingLines, PackingLines e ReceptionLines de alguns ERPs. Caso tenha personalizações, deve confirmar com as views default´s se necessita de efetuar alterações, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 28, 0, 1),
(N'Foi alterado o stored procedure "SP_u_Kapps_Products" de forma a ter em consideração as unidades do artigo (base, venda e compra). Se estiver em modo personalizado terá de acrescentar as novas colunas de forma a devolver a informação corretamente', 0, 28, 0, 2),
(N'Foi criada uma nova view "v_Kapps_Units". Deverá correr o script para a criação da mesma. Se estiver em modo personalizado terá de construir esta nova view', 0, 28, 0, 3),
(N'Já é possível configurar o código do tipo de documento do inventário a ser integrado, no grupo "Específico ERP"', 0, 29, 0, 4),
(N'Já é possível utilizar extensibilidade! O acesso às funções disponíveis, está no ecrã de configuração de cada terminal', 0, 32, 0, 5),
(N'Foram disponibilizadas tabelas de utilizadores (u_Kapps_TU1,u_Kapps_TU2,u_Kapps_TU3,u_Kapps_TU4)', 0, 32, 0, 6),
(N'Nova tabela para gestão de utilizadores', 0, 32, 0, 7),
(N'Nos parâmetros gerais, é possível escolher se os utilizadores são obrigado a terem um PIN code', 0, 32, 0, 8),
(N'Novo parâmetro em cada um dos módulos, que permite indicar se aparece um novo campo no ecrã dos artigos, para indicar o fator multiplicativo.', 0, 32, 0, 9),
(N'Novo parâmetro para indicar o código da propriedade associada ao lote, quando se utiliza o Sage 50C', 0, 33, 0, 10),
(N'Novas configurações para indicar se a caixa é do tipo palete', 0, 35, 0, 11),
(N'Novas configurações para indicar se a etiqueta é do tipo palete', 0, 35, 0, 12),
(N'Foram acrescentas as colunas "PurchaseOrder", "MySupplierNumber" na view PackingDocuments. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar as colunas, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0, 13),
(N'Foram acrescentas as colunas "NameByLabel", "AdressByLabel" na view v_Kapps_Customers. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar as colunas, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0, 14),
(N'Foi acrescentado a coluna "GTIN" na view v_Kapps_Articles. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar a coluna, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0, 15),
(N'Foram acrescentados novos parâmetros no grupo do código de barras, necessários para calcular o SSCC, utilizado na impressão de etiquetas de paletes!', 0, 35, 0, 16),
(N'Foi acrescentada a coluna "ValidaStock" na view v_Kapps_Documents. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar as colunas, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0, 17),
(N'Foram acrescentadas as colunas "DeliveryCustomer" e "DeliveryCode" nas views v_Kapps_Picking_Documents e v_Kapps_Packing_Documents. Caso tenha personalizações, deve confirmar com as views default´s a configuração e acrescentar as colunas, caso contrário, deve voltar a criar as views default´s do seu ERP!', 0, 35, 0, 18),
(N'Foi acrescentada uma nova view v_Kapps_Customers_DeliveryLocations.', 0, 35, 0, 19),
(N'Foi criada uma nova view "v_Kapps_WarehousesLocations". Deverá correr o script para a criação da mesma. Se estiver em modo personalizado terá de construir esta nova view', 0, 34, 0, 20),
(N'Foram alteradas as views. Deverá correr os scripts para a recriação das mesmas.', 0, 34, 0, 21),
(N'Alterações na view v_Kapps_Stock_Documents.', 0, 64, 0, 22),
(N'Foi eliminada a stored procedure SP_u_Kapps_Products.', 0, 64, 0, 23),
(N'Alterações em SP_u_Kapps_BarCode, SP_u_Kapps_Dossiers, SP_u_Kapps_LinhasContagem, SP_u_Kapps_Contagem, SP_u_Kapps_ContagemUSR (novo parâmetro).', 0, 64, 0, 24),
(N'SAGE50c alterações na view v_Kapps_Stock.', 0, 65, 0, 25),
(N'PHC alterações na view v_Kapps_Barcodes', 0, 65, 0, 26),
(N'Alterações na view v_Kapps_Reception_Documents', 0, 70, 0, 27),
(N'Alterações na view v_Kapps_Reception_Lines (Sage100c )', 0, 70, 0, 28),
(N'Alterações nas views v_Kapps_Articles, v_Kapps_Picking_Lines, v_Kapps_Packing_Lines, v_Kapps_Reception_Lines (Sage50c)', 0, 70, 0, 29);
SET IDENTITY_INSERT [u_Kapps_Alerts] OFF;
INSERT INTO u_Kapps_Events (EventID, EventDescription) VALUES 
(N'EVT_ON_QTY_CNF_REC', N'Ao confirmar quantidade na receção'),
(N'EVT_ON_QTY_CNF_PICK', N'Ao confirmar quantidade no picking'),
(N'EVT_ON_QTY_CNF_PACK', N'Ao confirmar quantidade no packing'),
(N'EVT_ON_BTN_CLK_PICK', N'Botão de impressão no picking'),
(N'EVT_ON_BTN_CLK_PACK', N'Botão de impressão no packing'),
(N'EVT_ON_BTN_CLK_REC', N'Botão de impressão na receção'),
(N'EVT_ON_OPEN_NEW_BOX_PACK', N'Abrir uma caixa nova'),
(N'EVT_ON_CLOSE_BOX_PACK', N'Fechar uma caixa'),
(N'EVT_BTN_PRINT_PRICE_CHECKING', N'Botão de impressão em verificar preços'),
(N'EVT_ON_QTY_CNF_OTHER', N'Ao confirmar quantidade nos outros documentos'),
(N'EVT_ON_BTN_CLK_OTHER', N'Botão de impressão nos outros documentos'),
(N'EVT_BTN_PRINT_STOCKS', N'Botão de impressão nas contagens assitidas'),
(N'EVT_ON_CLOSE_PICKING', N'Imprimir Picking List depois de fechar o picking'),
(N'EVT_ON_CLOSE_PACKING', N'Imprimir Packing List depois de fechar a caixa'),
(N'EVT_ON_AFTER_SAVE_PICK', N'Depois de integrar o documento no picking'),
(N'EVT_ON_AFTER_SAVE_PACK', N'Depois de integrar o documento no packing'),
(N'EVT_ON_AFTER_SAVE_OTHER', N'Depois de integrar o documento nos outros documentos'),
(N'EVT_ON_AFTER_SAVE_REC', N'Depois de integrar o documento na recepção'),
(N'EVT_ON_CLOSE_OTHERS', N'Imprimir Picking List depois de fechar nos outros documentos');
SET IDENTITY_INSERT [u_Kapps_Parameters] ON ;
INSERT INTO u_Kapps_Parameters (id, AppCode, ParameterType, ParameterGroup, ParameterOrder, ParameterID, ParameterDescription, ParameterValue, ParameterDefaultValue, ParameterInfo, ParameterRequired, ParameterDependent, ParameterERP) VALUES 
(4, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'BD_Empresas', N'', N'', N'', N'', N'0', N'0', N''),
(3, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'BD_Sistema', N'', N'', N'', N'', N'0', N'0', N''),
(5, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'Driver_Path', N'', N'', N'', N'', N'0', N'0', N''),
(1, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'ERP', N'', N'', N'PHC', N'', N'0', N'0', N''),
(6, N'', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'UPDATE', N'', N'', N'1', N'', N'0', N'0', N''),
(15, N'SYT', N'EAN128', N'EAN128', CAST(6 AS Numeric(18, 0)), N'AILOTE', N'AI do EAN128 para o lote', N'10', N'10', N'Pode definir mais do que um AI separado por virgulas

Consultar https://www.gs1-128.info/application-identifiers/', N'0', N'0', N''),
(17, N'SYT', N'EAN128', N'EAN128', CAST(8 AS Numeric(18, 0)), N'AINUMEROSERIE', N'AI do EAN128 para o número de série', N'21', N'21', N'Pode definir mais do que um AI separado por virgulas

Consultar https://www.gs1-128.info/application-identifiers/', N'0', N'0', N''),
(344, N'SYT', N'EAN128', N'EAN128', CAST(10 AS Numeric(18, 0)), N'AIPESO', N'AI do EAN128 para o peso líquido', N'3100,3101,3102,3103,3104,3105', N'3100,3101,3102,3103,3104,3105', N'Pode definir mais do que um AI separado por virgulas

Consultar https://www.gs1-128.info/application-identifiers/', N'0', N'0', N''),
(18, N'SYT', N'EAN128', N'EAN128', CAST(9 AS Numeric(18, 0)), N'AIQUANTIDADE', N'AI do EAN128 para a quantidade', N'37', N'37', N'Pode definir mais do que um AI separado por virgulas

Consultar https://www.gs1-128.info/application-identifiers/', N'0', N'0', N''),
(14, N'SYT', N'EAN128', N'EAN128', CAST(5 AS Numeric(18, 0)), N'AIREFERENCIA', N'AI do EAN128 para a referência/código de barras', N'01', N'01', N'Pode definir mais do que um AI separado por virgulas

Consultar https://www.gs1-128.info/application-identifiers/', N'0', N'0', N''),
(305, N'SYT', N'EAN128', N'EAN128', CAST(10 AS Numeric(18, 0)), N'AISSCC', N'AI do EAN128 para o SSCC', N'00', N'00', N'Pode definir mais do que um AI separado por virgulas

Consultar https://www.gs1-128.info/application-identifiers/', N'0', N'0', N''),
(16, N'SYT', N'EAN128', N'EAN128', CAST(7 AS Numeric(18, 0)), N'AIVALIDADELOTE', N'AI do EAN128 para a validade do lote', N'17', N'17', N'Pode definir mais do que um AI separado por virgulas

Consultar https://www.gs1-128.info/application-identifiers/', N'0', N'0', N''),
(384, N'SYT', N'EAN128', N'EAN128', CAST(20 AS Numeric(18, 0)), N'BOX_ALLOWED_LOCATIONS', N'Localizações a satisfazer ao ler uma caixa', N'', N'', N'Quando se lê o conteudo de uma caixa, indicar quais as localizações que podem ser usadas para satisfazer as linhas do documento de origem.
Se este parametro estiver definido as linhas do documento de origem que tiverem esta localização apenas podem ser satisfeitas quando se lê o conteudo de uma caixa.
Se não indicar nenhuma localização permite satisfazer qualquer linha.

Localizações separadas por virgula ex: A1.1,A1.2
', N'0', N'0', N''),
(373, N'SYT', N'EAN128', N'EAN128', CAST(19 AS Numeric(18, 0)), N'BOX_PREFIX', N'Prefixo para identificação de uma caixa', N'', N'', N'Na leitura de códigos de barras com este prefixo vai fazer a picagem de todos os artigos que estão dentro dessa caixa', N'0', N'0', N''),
(20, N'SYT', N'EAN128', N'EAN128', CAST(11 AS Numeric(18, 0)), N'EAN1128_LOCKLOTE', N'Deixa alterar o lote quando vem de um EAN128', N'S', N'S', N'0-Não / 1-Sim', N'0', N'0', N''),
(12, N'SYT', N'EAN128', N'EAN128', CAST(15 AS Numeric(18, 0)), N'EAN13_LEGHT', N'Numero de caracteres do EAN13', N'12', N'12', N'Número de carateres do código de barras EAN13 lido pelo leitor', N'0', N'0', N''),
(19, N'SYT', N'EAN128', N'EAN128', CAST(16 AS Numeric(18, 0)), N'EAN13VALID', N'EAN13 válidos para quantidade e peso', N'28,29', N'28,29', N'Tipos de EAN13 separados por vírgula ex.(28,29)', N'0', N'1', N''),
(317, N'SYT', N'EAN128', N'EAN128', CAST(17 AS Numeric(18, 0)), N'LOCATION_PREFIX', N'Prefixo dos códigos de barras de localizações', N'', N'', N'O prefixo é usado para verificar se o código de barras lido é uma localização', N'0', N'0', N''),
(352, N'SYT', N'EAN128', N'EAN128', CAST(18 AS Numeric(18, 0)), N'LOCATION_PREFIXOPCIONAL', N'Permitir ler localizações sem prefixo nos códigos de barras de localizações', N'0', N'0', N'0-Não /1-Sim

Quando a localização usa prefixo permite usar localizações com e sem prefixo', N'0', N'0', N''),
(11, N'SYT', N'EAN128', N'EAN128', CAST(3 AS Numeric(18, 0)), N'MIN_LEGHT', N'Numero de caracteres necessários para ser considerado EAN128', N'', N'0', N'Ao ler um código de barras superior ao valor inserido considera como EAN 128', N'0', N'1', N''),
(10, N'SYT', N'EAN128', N'EAN128', CAST(2 AS Numeric(18, 0)), N'PREFIX', N'Usa Prefixo EAN128', N'', N'0', N'0-não / 1-sim', N'0', N'1', N''),
(276, N'SYT', N'EAN128', N'EAN128', CAST(13 AS Numeric(18, 0)), N'SSCC_COMPANYPREFIX', N'SSCC - Prefixo da Empresa', N'', N'', N'', N'0', N'0', N''),
(275, N'SYT', N'EAN128', N'EAN128', CAST(12 AS Numeric(18, 0)), N'SSCC_CONTROLDIGIT', N'SSCC - Dígito de Extensão', N'', N'', N'', N'0', N'0', N''),
(295, N'SYT', N'EAN128', N'EAN128', CAST(4 AS Numeric(18, 0)), N'USAR_KEYWORD_QTYLABELS', N'Enviar para a impressora uma etiqueta de cada vez?', N'0', N'0', N'0-Não / 1-Sim

0 - Usar a KEYWORD QTYLABELS na etiqueta para definir a quantidade a imprimir

1 - Vai criar um trabalho de impressão para cada etiqueta', N'0', N'0', N''),
(9, N'SYT', N'EAN128', N'EAN128', CAST(1 AS Numeric(18, 0)), N'USEEAN128', N'Usa EAN128', N'', N'0', N'0-não / 1-sim', N'0', N'1', N''),
(13, N'SYT', N'EAN128', N'EAN128', CAST(14 AS Numeric(18, 0)), N'USEEAN13', N'Usa EAN13', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(345, N'SYT', N'EXTPROJ', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'READ_PROCESSID_PARAM', N'Ler parâmetros do ProcessID', N'', N'', N'Vai ler os parametros do processo (indicar o valor do campo ProcessID ver tabela u_Kapps_Processes))', N'0', N'0', N''),
(33, N'SYT', N'GENERAL', N'GENERAL', CAST(98 AS Numeric(18, 0)), N'ADDBARCODE', N'Criar e associar código de barras inexistente a produto', N'', N'0', N'0-não / 1-sim', N'0', N'0', N''),
(31, N'SYT', N'GENERAL', N'GENERAL', CAST(3 AS Numeric(18, 0)), N'ARTICLE_FILTER_APP', N'Filtro de artigos (Pesquisa de artigos)', N'', N'', N'and ? tabela.campo = xpto', N'0', N'0', N''),
(387, N'SYT', N'GENERAL', N'GENERAL', CAST(111 AS Numeric(18, 0)), N'DECIMAL_SEPARATOR', N'Separador decimal', N'.', N'.', N'Caracter a usar em campos numéricos para separar as casas decimais ponto (.) ou virgula (,)', N'0', N'0', N''),
(379, N'SYT', N'GENERAL', N'GENERAL', CAST(109 AS Numeric(18, 0)), N'INSTORE_USEWEIGHT', N'Nas entradas de artigos de peso variável usar peso como unidade a movimentar', N'1', N'1', N'Nas entradas de artigos de peso variável usar peso como unidade a movimentar', N'0', N'0', N''),
(274, N'SYT', N'GENERAL', N'GENERAL', CAST(105 AS Numeric(18, 0)), N'LOCATIONS_CTRL', N'Permitir alterar localizações de artigos em armazém', N'0', N'0', N'0-Não / 1-Sim com mensagem de aviso / 2-Sim sem mensagem de aviso', N'0', N'0', N''),
(37, N'SYT', N'GENERAL', N'GENERAL', CAST(102 AS Numeric(18, 0)), N'MORE_LINES_SAME_PRODUCT', N'Permite inserir novas linhas de produtos existentes no documento de origem', N'', N'0', N'Permite inserir novas linhas de produtos existentes no documento de origem', N'0', N'100', N''),
(343, N'SYT', N'GENERAL', N'GENERAL', CAST(108 AS Numeric(18, 0)), N'MORE_LINES_SAME_PRODUCT_LINKTOFIRST', N'Após satisfazer a quantidade, associar a artigo existente', N'0', N'0', N'0-Não associar
1-Associar

Após satisfazer a quantidade de todas as linhas desse artigo associa o artigo á primeira linha do artigo do documento de origem apenas quando o parâmetro [Permite inserir novas linhas de produtos existentes no documento de origem] estiver ativo', N'0', N'0', N''),
(30, N'SYT', N'GENERAL', N'GENERAL', CAST(3 AS Numeric(18, 0)), N'MULTI_USERS', N'Vários utilizadores para o mesmo documento', N'', N'0', N'0-não / 1-sim', N'0', N'0', N''),
(29, N'SYT', N'GENERAL', N'GENERAL', CAST(2 AS Numeric(18, 0)), N'NEW_PRD', N'Adicionar novo produto', N'', N'0', N'0-não / 1-sim', N'0', N'0', N''),
(380, N'SYT', N'GENERAL', N'GENERAL', CAST(110 AS Numeric(18, 0)), N'OUTSTORE_USEWEIGHT', N'Nas saídas de artigos de peso variável usar peso como unidade a movimentar', N'0', N'0', N'Nas saídas de artigos de peso variável usar peso como unidade a movimentar', N'0', N'0', N''),
(328, N'SYT', N'GENERAL', N'GENERAL', CAST(106 AS Numeric(18, 0)), N'PICTURES_FOLDER', N'Pasta para guardar as fotografias e desenhos dos inquéritos', N'', N'', N'Por defeito guarda na pasta Syncro configurada no MIS communicator', N'0', N'0', N''),
(36, N'SYT', N'GENERAL', N'GENERAL', CAST(101 AS Numeric(18, 0)), N'REPRINT_LABEL', N'Permite a reimpressão de etiquetas', N'0', N'0', N'0-não / 1-sim', N'0', N'0', N''),
(28, N'SYT', N'GENERAL', N'GENERAL', CAST(1 AS Numeric(18, 0)), N'STOCK_CTRL', N'Aceita stock negativo', N'0', N'0', N'0-não / 1-sim com mensagem a avisar / 2- sim sem mensagem a avisar', N'0', N'0', N''),
(338, N'SYT', N'GENERAL', N'GENERAL', CAST(107 AS Numeric(18, 0)), N'TIMER_VERIFY_NEWMSG', N'Intervalo de tempo para verificar novas mensagens', N'15', N'15', N'Indicar valor em segundos, se indicar 0 nunca verifica', N'0', N'0', N''),
(273, N'SYT', N'GENERAL', N'GENERAL', CAST(104 AS Numeric(18, 0)), N'USE_LOCATIONS', N'Usar localizações de artigos em armazém', N'0', N'0', N'0-não / 1-sim', N'0', N'0', N''),
(38, N'SYT', N'GENERAL', N'GENERAL', CAST(103 AS Numeric(18, 0)), N'USER_PIN', N'Utilizadores necessitam de PIN para efetuar login', N'0', N'0', N'1-Necessita / 0-Não necessita', N'0', N'100', N''),
(34, N'SYT', N'GENERAL', N'GENERAL', CAST(99 AS Numeric(18, 0)), N'WAREHOUSE', N'Armazém por defeito', N'', N'', N'Armazém a utilizar por defeito. Se não indicar nenhum pergunta sempre que iniciar a aplicação.', N'0', N'0', N''),
(342, N'SYT', N'INSPECTION', N'DEFAULT', CAST(7 AS Numeric(18, 0)), N'ADDNEWINV', N'Permite criar contagens cegas', N'1', N'1', N'0-Não /1-Sim', N'0', N'0', N''),
(39, N'SYT', N'INSPECTION', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'DEF_QTY', N'Quantidade por defeito para contagem', N'', N'1', N'', N'0', N'0', N''),
(41, N'SYT', N'INSPECTION', N'DEFAULT', CAST(3 AS Numeric(18, 0)), N'INCREMENT', N'Incrementa a quantidade do artigo lido', N'1', N'1', N'1-Sim / 0-Não  (Considera-se para tal o mesmo artigo, armazém e lote)', N'0', N'0', N''),
(42, N'SYT', N'INSPECTION', N'DEFAULT', CAST(4 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(389, N'SYT', N'INSPECTION', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'RFID_BYTES', N'Tamanho em bytes do campo TagID', N'0', N'0', N'indicar nº de bytes do campo TagID', N'0', N'0', N''),
(390, N'SYT', N'INSPECTION', N'DEFAULT', CAST(10 AS Numeric(18, 0)), N'RFID_MODEL', N'Modelo RFID', N'0', N'0', N'0 - Zebra
1 - M3
2 - Nordic ID NUR', N'0', N'0', N''),
(43, N'SYT', N'INSPECTION', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'SHOW_STOCK', N'Mostra stock atual do artigo', N'0', N'0', N'0-Não /1-Sim', N'0', N'0', N''),
(44, N'SYT', N'INSPECTION', N'DEFAULT', CAST(6 AS Numeric(18, 0)), N'UPDATE_CTRL', N'Avisa que o artigo já foi lido, e se pretende atualizar a quantidade', N'0', N'0', N'0-Não /1-Sim', N'0', N'0', N''),
(388, N'SYT', N'INSPECTION', N'DEFAULT', CAST(8 AS Numeric(18, 0)), N'USE_RFID', N'Usar RFID', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(45, N'SYT', N'LOTES', N'LOTES', CAST(1 AS Numeric(18, 0)), N'ENB_LOTE_ALT', N'Permite editar o campo de lote', N'', N'', N'0-Não 1-Sim', N'0', N'0', N''),
(7, N'SYT', N'MAIN', N'MAIN', CAST(1 AS Numeric(18, 0)), N'DATABASEVERSION', N'DATABASE VERSION', N'80', N'0', N'', N'0', N'', N''),
(303, N'SYT', N'MAIN', N'MAIN', CAST(10 AS Numeric(18, 0)), N'LSER', N'', N'', N'', N'', N'0', N'0', N''),
(304, N'SYT', N'MAIN', N'MAIN', CAST(11 AS Numeric(18, 0)), N'LSERP', N'', N'', N'', N'', N'0', N'0', N''),
(375, N'SYT', N'MAIN', N'MAIN', CAST(12 AS Numeric(18, 0)), N'PARAMETERSVERSION', N'PARAMETERS VERSION', N'97', N'', N'', N'0', N'0', N''),
(8, N'SYT', N'MAIN', N'MAIN', CAST(2 AS Numeric(18, 0)), N'SCRIPTSVERSION', N'SCRIPTS VERSION', N'46', N'0', N'', N'0', N'', N''),
(280, N'SYT', N'MAIN', N'MAIN', CAST(6 AS Numeric(18, 0)), N'SMTP_PASSWORD', N'Password (SMTP)', N'', N'', N'', N'0', N'0', N''),
(278, N'SYT', N'MAIN', N'MAIN', CAST(4 AS Numeric(18, 0)), N'SMTP_PORT', N'Porta (SMTP)', N'', N'', N'', N'0', N'0', N''),
(281, N'SYT', N'MAIN', N'MAIN', CAST(7 AS Numeric(18, 0)), N'SMTP_SECURECONNECTION', N'Secure connection', N'1', N'1', N'1-Yes 2-No', N'0', N'0', N''),
(277, N'SYT', N'MAIN', N'MAIN', CAST(3 AS Numeric(18, 0)), N'SMTP_SERVER', N'Servidor SMTP', N'', N'', N'', N'0', N'0', N''),
(282, N'SYT', N'MAIN', N'MAIN', CAST(8 AS Numeric(18, 0)), N'SMTP_STARTTLS', N'Start TLS', N'1', N'1', N'1-Yes 2-No', N'0', N'0', N''),
(279, N'SYT', N'MAIN', N'MAIN', CAST(5 AS Numeric(18, 0)), N'SMTP_USERNAME', N'Utilizador (SMTP)', N'', N'', N'', N'0', N'0', N''),
(302, N'SYT', N'MAIN', N'MAIN', CAST(9 AS Numeric(18, 0)), N'ULOL', N'', N'', N'', N'', N'0', N'0', N''),
(326, N'SYT', N'OTHERS', N'DEFAULT', CAST(32 AS Numeric(18, 0)), N'CAB_FIELDS_REQUIRED', N'Documento: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(56, N'SYT', N'OTHERS', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(53, N'SYT', N'OTHERS', N'DEFAULT', CAST(6 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Documento: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(55, N'SYT', N'OTHERS', N'DEFAULT', CAST(15 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Documento: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(54, N'SYT', N'OTHERS', N'DEFAULT', CAST(12 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Documento: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(60, N'SYT', N'OTHERS', N'DEFAULT', CAST(10 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(57, N'SYT', N'OTHERS', N'DEFAULT', CAST(7 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Documento: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(59, N'SYT', N'OTHERS', N'DEFAULT', CAST(16 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Documento: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(58, N'SYT', N'OTHERS', N'DEFAULT', CAST(13 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Documento: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(64, N'SYT', N'OTHERS', N'DEFAULT', CAST(11 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(61, N'SYT', N'OTHERS', N'DEFAULT', CAST(8 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Documento: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(63, N'SYT', N'OTHERS', N'DEFAULT', CAST(17 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Documento: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(62, N'SYT', N'OTHERS', N'DEFAULT', CAST(14 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Documento: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(383, N'SYT', N'OTHERS', N'DEFAULT', CAST(107 AS Numeric(18, 0)), N'CONTINUE_AT_ERROR', N'Integra o documento quando dá erro de comunicação à AT', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N'Primavera;'),
(391, N'SYT', N'OTHERS', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'DST_SERIE', N'Secção/Série do documento a gerar', N'', N'', N'Secção/Série de destino dos documentos a integrar

Lista de secções/séries separada por virgulas ex: A,B,C se não indicar nenhuma série é usada a série definida nos parâmetros do utilizador', N'0', N'0', N''),
(77, N'SYT', N'OTHERS', N'DEFAULT', CAST(30 AS Numeric(18, 0)), N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0', N''),
(350, N'SYT', N'OTHERS', N'DEFAULT', CAST(34 AS Numeric(18, 0)), N'GRIDFORSERIALNUMBERS', N'Pedir números de série numa grelha', N'0', N'0', N'0-Não 1-Sim

Permite que se possa ler vários números de série para a mesma linha', N'0', N'0', N''),
(49, N'SYT', N'OTHERS', N'DEFAULT', CAST(2 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N''),
(327, N'SYT', N'OTHERS', N'DEFAULT', CAST(33 AS Numeric(18, 0)), N'LIN_FIELDS_REQUIRED', N'Linha: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(68, N'SYT', N'OTHERS', N'DEFAULT', CAST(21 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(65, N'SYT', N'OTHERS', N'DEFAULT', CAST(18 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Linha: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(67, N'SYT', N'OTHERS', N'DEFAULT', CAST(27 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Linha: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(66, N'SYT', N'OTHERS', N'DEFAULT', CAST(24 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Linha: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(72, N'SYT', N'OTHERS', N'DEFAULT', CAST(22 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(69, N'SYT', N'OTHERS', N'DEFAULT', CAST(19 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Linha: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(71, N'SYT', N'OTHERS', N'DEFAULT', CAST(28 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Linha: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(70, N'SYT', N'OTHERS', N'DEFAULT', CAST(25 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Linha: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(76, N'SYT', N'OTHERS', N'DEFAULT', CAST(23 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(73, N'SYT', N'OTHERS', N'DEFAULT', CAST(20 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Linha: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(75, N'SYT', N'OTHERS', N'DEFAULT', CAST(29 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Linha: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(74, N'SYT', N'OTHERS', N'DEFAULT', CAST(26 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Linha: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(298, N'SYT', N'OTHERS', N'DEFAULT', CAST(31 AS Numeric(18, 0)), N'MODIFY_DELIVERY', N'Permite alterar o local de descarga', N'0', N'0', N'(0-Não permite 1-Permite)', N'0', N'0', N''),
(51, N'SYT', N'OTHERS', N'DEFAULT', CAST(4 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(372, N'SYT', N'OTHERS', N'DEFAULT', CAST(106 AS Numeric(18, 0)), N'NUMBER_COPIES', N'Número de cópias a imprimir', N'0', N'0', N'', N'0', N'0', N'Primavera;'),
(52, N'SYT', N'OTHERS', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N''),
(48, N'SYT', N'OTHERS', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'OTHERS', N'Outros documentos', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'0', N'0', N''),
(370, N'SYT', N'OTHERS', N'DEFAULT', CAST(104 AS Numeric(18, 0)), N'PRINT_DOCUMENT', N'Imprime o documento que foi integrado no ERP', N'0', N'0', N'Depois de criar o documento no ERP imprime. (Apenas para documentos integrados em Compras)

0 - Não
1 - Imprime todos os documentos
2 - Imprime apenas os documentos em que a série esteja configurada para comunicar à AT', N'0', N'0', N'Eticadata_16/17/18/19;primavera;'),
(371, N'SYT', N'OTHERS', N'DEFAULT', CAST(105 AS Numeric(18, 0)), N'REPORT_NAME', N'Nome do report a imprimir', N'', N'', N'Nome do report sem a extensão', N'0', N'0', N'Primavera;'),
(392, N'SYT', N'OTHERS', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'SERIE_BY_INDEX', N'Secção/Série de destino usar o mesmo índex do documento de destino', N'0', N'0', N'0-Não 1-Sim

Vai atribuir a secção/série usando o mesmo index do documento de destino

ex: se o documento de destino for GT1,GT2,GT3 e a secção/série de destino for A,B,C

ao integrar se o documento de destino for GT1 vai atribuir a série A
ao integrar se o documento de destino for GT2 vai atribuir a série B
ao integrar se o documento de destino for GT3 vai atribuir a série C', N'0', N'0', N''),
(50, N'SYT', N'OTHERS', N'DEFAULT', CAST(3 AS Numeric(18, 0)), N'VALIDA_STOCK', N'Valida Stock dos documentos', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(95, N'SYT', N'PACKING', N'DEFAULT', CAST(67 AS Numeric(18, 0)), N'AUTONAME', N'Prefixo para código da caixa gerada pela app logística', N'', N'', N'Se o prefixo for por exemplo “Caixa” é concatenado a um contador continuo com x dígitos, ex. Caixa00001

Podem ser usadas as keywords:

[DOCTYPE];[DOCNUMBER];[DOCNAME];[CUSTOMERID];[CUSTOMERNAME];[WAREHOUSE];[USERID]', N'0', N'0', N''),
(96, N'SYT', N'PACKING', N'DEFAULT', CAST(20 AS Numeric(18, 0)), N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar?', N'', N'0', N'1-Sim/0-Não.', N'0', N'0', N''),
(300, N'SYT', N'PACKING', N'DEFAULT', CAST(54 AS Numeric(18, 0)), N'BOX_AUTO_OPEN', N'Após adicionar um artigo, mostrar opção de fechar a caixa / abrir uma caixa nova', N'0', N'0', N'(0-Não 1-Sim)', N'0', N'0', N''),
(324, N'SYT', N'PACKING', N'DEFAULT', CAST(64 AS Numeric(18, 0)), N'CAB_FIELDS_REQUIRED', N'Documento: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(110, N'SYT', N'PACKING', N'DEFAULT', CAST(31 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(107, N'SYT', N'PACKING', N'DEFAULT', CAST(28 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Documento: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(109, N'SYT', N'PACKING', N'DEFAULT', CAST(38 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Documento: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(108, N'SYT', N'PACKING', N'DEFAULT', CAST(35 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Documento: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(114, N'SYT', N'PACKING', N'DEFAULT', CAST(32 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(111, N'SYT', N'PACKING', N'DEFAULT', CAST(29 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Documento: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(113, N'SYT', N'PACKING', N'DEFAULT', CAST(39 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Documento: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(112, N'SYT', N'PACKING', N'DEFAULT', CAST(36 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Documento: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(118, N'SYT', N'PACKING', N'DEFAULT', CAST(33 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(115, N'SYT', N'PACKING', N'DEFAULT', CAST(30 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Documento: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(117, N'SYT', N'PACKING', N'DEFAULT', CAST(40 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Documento: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(116, N'SYT', N'PACKING', N'DEFAULT', CAST(37 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Documento: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(105, N'SYT', N'PACKING', N'DEFAULT', CAST(26 AS Numeric(18, 0)), N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(382, N'SYT', N'PACKING', N'DEFAULT', CAST(107 AS Numeric(18, 0)), N'CONTINUE_AT_ERROR', N'Integra o documento quando dá erro de comunicação à AT', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N'Primavera;'),
(301, N'SYT', N'PACKING', N'DEFAULT', CAST(55 AS Numeric(18, 0)), N'DEFAULT_BOX', N'Caixa a usar por defeito', N'', N'', N'Indicar a caixa a usar por defeito

Ao abrir uma caixa nova usa sempre a mesma e não mostra o ecrã de seleção e detalhes da caixa', N'0', N'0', N''),
(132, N'SYT', N'PACKING', N'DEFAULT', CAST(99 AS Numeric(18, 0)), N'DOC_DATE', N'Mostrar todos os documentos até a data atual', N'', N'<=', N'Usar um dos seguintes operadores <, <=, =, >, >=

<=	(Mostra todos os documentos até à data atual)
=	(Mostra apenas os documentos da data atual)
>=	(Mostra os documentos iguais e posteriores à data atual)', N'0', N'0', N''),
(335, N'SYT', N'PACKING', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'DOC_OBS1', N'Documentos: Informação adicional primeira linha', N'', N'', N'Usada para mostrar informação adicional na lista de documentos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, cab.UserCol1 + cab.UserCol2 + cab.UserCol3 

outro exemplo usando SQL

, (SELECT Observacoes FROM CabecDoc WHERE CabecDoc.ID=cab.PackingKey)', N'0', N'0', N''),
(336, N'SYT', N'PACKING', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'DOC_OBS2', N'Documentos: Informação adicional segunda linha', N'', N'', N'Usada para mostrar informação adicional na lista de documentos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, cab.UserCol1 + cab.UserCol2 + cab.UserCol3 

outro exemplo usando SQL

, (SELECT CodPostal+'' ''+CodPostalLocalidade FROM CabecDoc WHERE CabecDoc.ID=cab.PackingKey)', N'0', N'0', N''),
(79, N'SYT', N'PACKING', N'DEFAULT', CAST(2 AS Numeric(18, 0)), N'DST_DOSSIER', N'Tipos de documentos a gerar na integração do documento de packing', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N''),
(357, N'SYT', N'PACKING', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'DST_SERIE', N'Secção/Série do documento a gerar', N'', N'', N'Secção/Série de destino dos documentos a integrar

Lista de secções/séries separada por virgulas ex: A,B,C se não indicar nenhuma série é usada a série definida nos parâmetros do utilizador', N'0', N'0', N''),
(131, N'SYT', N'PACKING', N'DEFAULT', CAST(52 AS Numeric(18, 0)), N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0', N''),
(308, N'SYT', N'PACKING', N'DEFAULT', CAST(56 AS Numeric(18, 0)), N'FECHAR_DOC_ORIGEM', N'Fechar o documento de origem', N'0', N'0', N'0 - Ao integrar o documento confirma se pretende fechar o documento de origem
1 - Ao integrar o documento não confirma e fecha sempre o documento de origem
2 - Ao integrar o documento não confirma e nunca fecha o documento de origem', N'0', N'0', N''),
(84, N'SYT', N'PACKING', N'DEFAULT', CAST(7 AS Numeric(18, 0)), N'GRID1_ALIAS', N'Documentos: Títulos para os cabeçalhos das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os nomes das colunas separados por virgula, ex: Nome,Data,Estado

Estas colunas são usadas nos filtros', N'0', N'1', N''),
(85, N'SYT', N'PACKING', N'DEFAULT', CAST(8 AS Numeric(18, 0)), N'GRID1_COL_TYPE', N'Documentos: Tipos de dados das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os tipos das colunas separados por virgula, ex: s,d,n,s,s,s,s,s,s,s

s - alfanumérico
d - data
n - numérico', N'0', N'1', N''),
(87, N'SYT', N'PACKING', N'DEFAULT', CAST(10 AS Numeric(18, 0)), N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'Usando syntax SQL deve começar por AND seguido da condição

Podem ser utilizadas as seguintes keywords: [WORKWAREHOUSE],[USERNAME]

Exemplo para mostrar apenas os documentos do armazém selecionado usando a coluna Filter1:
AND cab.Filter1=''[WORKWAREHOUSE]''', N'0', N'0', N''),
(90, N'SYT', N'PACKING', N'DEFAULT', CAST(13 AS Numeric(18, 0)), N'GRID2_ALIAS', N'Linhas: Títulos para os cabeçalhos das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os nomes das colunas separados por virgula, ex: Nome,Data,Estado

Estas colunas são usadas nos filtros', N'0', N'1', N''),
(91, N'SYT', N'PACKING', N'DEFAULT', CAST(14 AS Numeric(18, 0)), N'GRID2_COL_TYPE', N'Linhas: Tipos de dados das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os tipos das colunas separados por virgula, ex: s,d,n,s,s,s,s,s,s,s

s - alfanumérico
d - data
n - numérico', N'0', N'0', N''),
(93, N'SYT', N'PACKING', N'DEFAULT', CAST(16 AS Numeric(18, 0)), N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional', N'', N'', N'Usando syntax SQL deve começar por AND seguido da condição

Podem ser utilizadas as seguintes keywords: [WORKWAREHOUSE],[USERNAME]

Exemplo para mostrar apenas as linhas do armazém selecionado:

AND lin.Warehouse=''[WORKWAREHOUSE]''', N'0', N'0', N''),
(349, N'SYT', N'PACKING', N'DEFAULT', CAST(66 AS Numeric(18, 0)), N'GRIDFORSERIALNUMBERS', N'Pedir números de série numa grelha', N'0', N'0', N'0-Não 1-Sim

Permite que se possa ler vários números de série para a mesma linha', N'0', N'0', N''),
(97, N'SYT', N'PACKING', N'DEFAULT', CAST(20 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N''),
(80, N'SYT', N'PACKING', N'DEFAULT', CAST(3 AS Numeric(18, 0)), N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo índex do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0', N''),
(325, N'SYT', N'PACKING', N'DEFAULT', CAST(65 AS Numeric(18, 0)), N'LIN_FIELDS_REQUIRED', N'Linha: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(337, N'SYT', N'PACKING', N'DEFAULT', CAST(15 AS Numeric(18, 0)), N'LIN_OBS1', N'Linhas: Informação adicional', N'', N'', N'Usada para mostrar informação adicional na lista de artigos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, lin.UserCol1 + lin.UserCol2 + lin.UserCol3 

outro exemplo usando SQL

, (SELECT convert(varchar(100), Observacoes) FROM Artigo Art WHERE Art.Artigo = lin.Article )', N'0', N'0', N''),
(122, N'SYT', N'PACKING', N'DEFAULT', CAST(43 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(119, N'SYT', N'PACKING', N'DEFAULT', CAST(40 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Linha: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(121, N'SYT', N'PACKING', N'DEFAULT', CAST(49 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Linha: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(120, N'SYT', N'PACKING', N'DEFAULT', CAST(46 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Linha: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(126, N'SYT', N'PACKING', N'DEFAULT', CAST(44 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(123, N'SYT', N'PACKING', N'DEFAULT', CAST(41 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Linha: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(125, N'SYT', N'PACKING', N'DEFAULT', CAST(50 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Linha: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(124, N'SYT', N'PACKING', N'DEFAULT', CAST(47 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Linha: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(130, N'SYT', N'PACKING', N'DEFAULT', CAST(45 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(127, N'SYT', N'PACKING', N'DEFAULT', CAST(42 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Linha: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(129, N'SYT', N'PACKING', N'DEFAULT', CAST(51 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Linha: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(128, N'SYT', N'PACKING', N'DEFAULT', CAST(48 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Linha: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(394, N'SYT', N'PACKING', N'DEFAULT', CAST(108 AS Numeric(18, 0)), N'LOAD_DOCS_STARTUP', N'Actualizar a lista de documentos ao entrar no processo', N'1', N'1', N'Apenas usado quando o parâmetro [Permite satisfazer vários documentos em simultâneo para o mesmo cliente] não está ativo', N'0', N'0', N''),
(106, N'SYT', N'PACKING', N'DEFAULT', CAST(27 AS Numeric(18, 0)), N'MESSAGE_LINES_QUERY', N'Linhas: Mensagem ao seleccionar um artigo', N'', N'', N'Consulta(SQL) que vai mostrar uma mensagem ao selecionar num artigo

Usar syntax SQL ex:

SELECT 0 as resultado, Obs as Mensagem FROM tabela WHERE ref=[REFARTIGO]

resultado=0 Mostra mensagem e continua
resultado=1 Mostra mensagem e cancela a acção

Podem ser utilizadas as seguintes keywords:

[CHAVECAB] - O campo identificador do documento
[NUMERODOC] - Número do documento
[NOMEENTIDADE] - Nome da entidade
[DATAFINAL] - Data do documento
[CODIGOENTIDADE] - Código da Entidade
[CODINTDOCUMENTO] - Código interno do documento
[NOMEDOCUMENTO] - Nome do documento
[NUNLINHA] - Número da linha
[REFARTIGO] - Referência do Artigo', N'0', N'0', N''),
(94, N'SYT', N'PACKING', N'DEFAULT', CAST(17 AS Numeric(18, 0)), N'MESSAGE_QUERY', N'Documentos: Mensagem ao seleccionar um documento', N'', N'', N'Consulta(SQL) que vai mostrar uma mensagem ao entrar num documento

Usar syntax SQL ex:

SELECT 0 as resultado, Obs as Mensagem FROM tabela WHERE cabkey=[CHAVECAB]

resultado=0 Mostra mensagem e continua
resultado=1 Mostra mensagem e cancela a acção

Podem ser utilizadas as seguintes keywords:

[CHAVECAB] - O campo identificador do documento
[NUMERODOC] - Número do documento
[NOMEENTIDADE] - Nome da entidade
[DATAFINAL] - Data do documento
[CODIGOENTIDADE] - Código da Entidade
[CODINTDOCUMENTO] - Código interno do documento
[NOMEDOCUMENTO] - Nome do documento', N'0', N'0', N''),
(297, N'SYT', N'PACKING', N'DEFAULT', CAST(54 AS Numeric(18, 0)), N'MODIFY_DELIVERY', N'Permite alterar o local de descarga', N'0', N'0', N'(0-Não permite 1-Permite)', N'0', N'0', N''),
(102, N'SYT', N'PACKING', N'DEFAULT', CAST(23 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(103, N'SYT', N'PACKING', N'DEFAULT', CAST(24 AS Numeric(18, 0)), N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo cliente', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(98, N'SYT', N'PACKING', N'DEFAULT', CAST(20 AS Numeric(18, 0)), N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N''),
(99, N'SYT', N'PACKING', N'DEFAULT', CAST(21 AS Numeric(18, 0)), N'NOQTY', N'Mostrar quantidade a picar por defeito', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB 1-Sim/0-Não.', N'0', N'0', N''),
(369, N'SYT', N'PACKING', N'DEFAULT', CAST(106 AS Numeric(18, 0)), N'NUMBER_COPIES', N'Número de cópias a imprimir', N'0', N'0', N'', N'0', N'0', N'Primavera;'),
(104, N'SYT', N'PACKING', N'DEFAULT', CAST(25 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N''),
(351, N'SYT', N'PACKING', N'DEFAULT', CAST(68 AS Numeric(18, 0)), N'PACKNUMDIGITS', N'N.º dígitos a usar na numeração da caixa', N'5', N'5', N'O N.º da caixa é sequencial e por defeito com 5 dígitos fixos 00001,00002...etc', N'0', N'0', N''),
(100, N'SYT', N'PACKING', N'DEFAULT', CAST(21 AS Numeric(18, 0)), N'PACKORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'Ex: ORDER BY Number', N'0', N'0', N''),
(101, N'SYT', N'PACKING', N'DEFAULT', CAST(22 AS Numeric(18, 0)), N'PACKORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'ORDER BY lin.Article, lin.PackingLineKey', N'Ex: ORDER BY Description', N'0', N'0', N''),
(367, N'SYT', N'PACKING', N'DEFAULT', CAST(104 AS Numeric(18, 0)), N'PRINT_DOCUMENT', N'Imprime o documento que foi integrado no ERP', N'0', N'0', N'Depois de criar o documento no ERP imprime. (Apenas para documentos integrados em Compras)

0 - Não
1 - Imprime todos os documentos
2 - Imprime apenas os documentos em que a série esteja configurada para comunicar à AT', N'0', N'0', N'Eticadata_16/17/18/19;primavera;'),
(339, N'SYT', N'PACKING', N'DEFAULT', CAST(100 AS Numeric(18, 0)), N'QTY_CTRL', N'Aceita quantidades superiores ao documento de origem', N'0', N'0', N'0-não / 1-sim com mensagem a avisar / 2- sim sem mensagem a avisar', N'0', N'0', N''),
(309, N'SYT', N'PACKING', N'DEFAULT', CAST(60 AS Numeric(18, 0)), N'QUALITY_NOTIFY', N'Notifica por email os produtos não conformes?', N'', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(310, N'SYT', N'PACKING', N'DEFAULT', CAST(61 AS Numeric(18, 0)), N'QUALITY_SENDER_NAME', N'Utilizador que envia os emails qualidade', N'', N'', N'Nome do utilizador e email separado por ;

ex:
Pedro Neves;pedroneves@gmail.com', N'0', N'0', N''),
(312, N'SYT', N'PACKING', N'DEFAULT', CAST(63 AS Numeric(18, 0)), N'QUALITY_SUBJECT', N'Assunto para envio de emails qualidade', N'Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])', N'Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])', N'Assunto para envio de emails qualidade

Podem ser usadas as keywords [NOME_ENTIDADE] e [DATA_HORA]', N'0', N'0', N''),
(311, N'SYT', N'PACKING', N'DEFAULT', CAST(62 AS Numeric(18, 0)), N'QUALITY_TO_EMAIL', N'Email dos destinatários para envio de emails qualidade', N'', N'', N'Endereços de email separados por ;

ex:
armazem@hotmail.com;responsavel@gmail.com', N'0', N'0', N''),
(368, N'SYT', N'PACKING', N'DEFAULT', CAST(105 AS Numeric(18, 0)), N'REPORT_NAME', N'Nome do report a imprimir', N'', N'', N'Nome do report sem a extensão', N'0', N'0', N'Primavera;'),
(360, N'SYT', N'PACKING', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'SERIE_BY_INDEX', N'Secção/Série de destino usar o mesmo índex do documento de destino', N'0', N'0', N'0-Não 1-Sim

Vai atribuir a secção/série usando o mesmo index do documento de destino

ex: se o documento de destino for GT1,GT2,GT3 e a secção/série de destino for A,B,C

ao integrar se o documento de destino for GT1 vai atribuir a série A
ao integrar se o documento de destino for GT2 vai atribuir a série B
ao integrar se o documento de destino for GT3 vai atribuir a série C', N'0', N'0', N''),
(81, N'SYT', N'PACKING', N'DEFAULT', CAST(4 AS Numeric(18, 0)), N'SERIE_ORIGEM', N'Secção/Série do documento de destino igual à do documento de origem', N'0', N'0', N'0-Não 1-Sim

Vai integrar na mesma secção/série do documento de origem!', N'0', N'0', N''),
(78, N'SYT', N'PACKING', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'SRC_DOSSIER', N'Tipos de documentos que dão origem ao packing.', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N''),
(292, N'SYT', N'PACKING', N'DEFAULT', CAST(53 AS Numeric(18, 0)), N'USE_EXPEDITION', N'Usar localização de expedição', N'0', N'0', N'0-Não 1-Sim

Antes de integrar é pedida a localização de expedição', N'0', N'0', N''),
(354, N'SYT', N'PACKING', N'DEFAULT', CAST(102 AS Numeric(18, 0)), N'VERIFYPENDING', N'Mostrar artigos pendentes quando integra', N'1', N'1', N'0-Não 1-Sim

Antes de integrar se existirem artigos pendentes mostra lista dos artigos', N'0', N'0', N''),
(151, N'SYT', N'PICKING', N'DEFAULT', CAST(19 AS Numeric(18, 0)), N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar?', N'', N'0', N'1-Sim/0-Não.', N'0', N'0', N''),
(322, N'SYT', N'PICKING', N'DEFAULT', CAST(64 AS Numeric(18, 0)), N'CAB_FIELDS_REQUIRED', N'Documento: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(164, N'SYT', N'PICKING', N'DEFAULT', CAST(31 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(161, N'SYT', N'PICKING', N'DEFAULT', CAST(28 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Documento: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(163, N'SYT', N'PICKING', N'DEFAULT', CAST(37 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Documento: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(162, N'SYT', N'PICKING', N'DEFAULT', CAST(34 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Documento: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(168, N'SYT', N'PICKING', N'DEFAULT', CAST(32 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(165, N'SYT', N'PICKING', N'DEFAULT', CAST(29 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Documento: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(167, N'SYT', N'PICKING', N'DEFAULT', CAST(38 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Documento: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(166, N'SYT', N'PICKING', N'DEFAULT', CAST(35 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Documento: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(172, N'SYT', N'PICKING', N'DEFAULT', CAST(33 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(169, N'SYT', N'PICKING', N'DEFAULT', CAST(30 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Documento: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(171, N'SYT', N'PICKING', N'DEFAULT', CAST(39 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Documento: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(170, N'SYT', N'PICKING', N'DEFAULT', CAST(36 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Documento: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(159, N'SYT', N'PICKING', N'DEFAULT', CAST(26 AS Numeric(18, 0)), N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(381, N'SYT', N'PICKING', N'DEFAULT', CAST(107 AS Numeric(18, 0)), N'CONTINUE_AT_ERROR', N'Integra o documento quando dá erro de comunicação à AT', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N'Primavera;'),
(186, N'SYT', N'PICKING', N'DEFAULT', CAST(99 AS Numeric(18, 0)), N'DOC_DATE', N'Mostrar todos os documentos até a data atual', N'', N'<=', N'Usar um dos seguintes operadores <, <=, =, >, >=

<=	(Mostra todos os documentos até à data atual)
=	(Mostra apenas os documentos da data atual)
>=	(Mostra os documentos iguais e posteriores à data atual)', N'0', N'0', N''),
(332, N'SYT', N'PICKING', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'DOC_OBS1', N'Documentos: Informação adicional primeira linha', N'', N'', N'Usada para mostrar informação adicional na lista de documentos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, cab.UserCol1 + cab.UserCol2 + cab.UserCol3 

outro exemplo usando SQL

, (SELECT Observacoes FROM CabecDoc WHERE CabecDoc.ID=cab.PickingKey)', N'0', N'0', N''),
(333, N'SYT', N'PICKING', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'DOC_OBS2', N'Documentos: Informação adicional segunda linha', N'', N'', N'Usada para mostrar informação adicional na lista de documentos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, cab.UserCol1 + cab.UserCol2 + cab.UserCol3 

outro exemplo usando SQL

, (SELECT CodPostal+'' ''+CodPostalLocalidade FROM CabecDoc WHERE CabecDoc.ID=cab.PickingKey)', N'0', N'0', N''),
(134, N'SYT', N'PICKING', N'DEFAULT', CAST(2 AS Numeric(18, 0)), N'DST_DOSSIER', N'Tipos de documentos a gerar na integração do picking', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N''),
(356, N'SYT', N'PICKING', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'DST_SERIE', N'Secção/Série do documento a gerar', N'', N'', N'Secção/Série de destino dos documentos a integrar

Lista de secções/séries separada por virgulas ex: A,B,C

Se não indicar nenhuma série é usada a série definida nos parâmetros do utilizador', N'0', N'0', N''),
(185, N'SYT', N'PICKING', N'DEFAULT', CAST(52 AS Numeric(18, 0)), N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0', N''),
(307, N'SYT', N'PICKING', N'DEFAULT', CAST(55 AS Numeric(18, 0)), N'FECHAR_DOC_ORIGEM', N'Fechar o documento de origem', N'0', N'0', N'0 - Ao integrar o documento confirma se pretende fechar o documento de origem
1 - Ao integrar o documento não confirma e fecha sempre o documento de origem
2 - Ao integrar o documento não confirma e nunca fecha o documento de origem', N'0', N'0', N''),
(139, N'SYT', N'PICKING', N'DEFAULT', CAST(7 AS Numeric(18, 0)), N'GRID1_ALIAS', N'Documentos: Títulos para os cabeçalhos das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os nomes das colunas separados por virgula, ex: Nome,Data,Estado

Estas colunas são usadas nos filtros', N'0', N'1', N''),
(140, N'SYT', N'PICKING', N'DEFAULT', CAST(8 AS Numeric(18, 0)), N'GRID1_COL_TYPE', N'Documentos: Tipos de dados das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os tipos das colunas separados por virgula, ex: s,d,n,s,s,s,s,s,s,s

s - alfanumérico
d - data
n - numérico', N'0', N'1', N''),
(142, N'SYT', N'PICKING', N'DEFAULT', CAST(10 AS Numeric(18, 0)), N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'Usando syntax SQL deve começar por AND seguido da condição

Podem ser utilizadas as seguintes keywords: [WORKWAREHOUSE],[USERNAME]

Exemplo para mostrar apenas os documentos do armazém selecionado usando a coluna Filter1:
AND cab.Filter1=''[WORKWAREHOUSE]''', N'0', N'0', N''),
(145, N'SYT', N'PICKING', N'DEFAULT', CAST(13 AS Numeric(18, 0)), N'GRID2_ALIAS', N'Linhas: Títulos para os cabeçalhos das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os nomes das colunas separados por virgula, ex: Nome,Data,Estado

Estas colunas são usadas nos filtros', N'0', N'1', N''),
(146, N'SYT', N'PICKING', N'DEFAULT', CAST(14 AS Numeric(18, 0)), N'GRID2_COL_TYPE', N'Linhas: Tipos de dados das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os tipos das colunas separados por virgula, ex: s,d,n,s,s,s,s,s,s,s

s - alfanumérico
d - data
n - numérico', N'0', N'0', N''),
(148, N'SYT', N'PICKING', N'DEFAULT', CAST(16 AS Numeric(18, 0)), N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional', N'', N'', N'Usando syntax SQL deve começar por AND seguido da condição

Podem ser utilizadas as seguintes keywords: [WORKWAREHOUSE],[USERNAME]

Exemplo para mostrar apenas as linhas do armazém selecionado:

AND lin.Warehouse=''[WORKWAREHOUSE]''', N'0', N'0', N''),
(348, N'SYT', N'PICKING', N'DEFAULT', CAST(66 AS Numeric(18, 0)), N'GRIDFORSERIALNUMBERS', N'Pedir números de série numa grelha', N'0', N'0', N'0-Não 1-Sim

Permite que se possa ler vários números de série para a mesma linha', N'0', N'0', N''),
(153, N'SYT', N'PICKING', N'DEFAULT', CAST(20 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N''),
(135, N'SYT', N'PICKING', N'DEFAULT', CAST(3 AS Numeric(18, 0)), N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo índex do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0', N''),
(323, N'SYT', N'PICKING', N'DEFAULT', CAST(65 AS Numeric(18, 0)), N'LIN_FIELDS_REQUIRED', N'Linha: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(334, N'SYT', N'PICKING', N'DEFAULT', CAST(15 AS Numeric(18, 0)), N'LIN_OBS1', N'Linhas: Informação adicional', N'', N'', N'Usada para mostrar informação adicional na lista de artigos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, lin.UserCol1 + lin.UserCol2 + lin.UserCol3 

outro exemplo usando SQL

, (SELECT convert(varchar(100), Observacoes) FROM Artigo Art WHERE Art.Artigo = lin.Article )', N'0', N'0', N''),
(176, N'SYT', N'PICKING', N'DEFAULT', CAST(43 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(173, N'SYT', N'PICKING', N'DEFAULT', CAST(40 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Linha: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(175, N'SYT', N'PICKING', N'DEFAULT', CAST(49 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Linha: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(174, N'SYT', N'PICKING', N'DEFAULT', CAST(46 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Linha: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(180, N'SYT', N'PICKING', N'DEFAULT', CAST(44 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(177, N'SYT', N'PICKING', N'DEFAULT', CAST(41 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Linha: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(179, N'SYT', N'PICKING', N'DEFAULT', CAST(50 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Linha: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(178, N'SYT', N'PICKING', N'DEFAULT', CAST(47 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Linha: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(184, N'SYT', N'PICKING', N'DEFAULT', CAST(45 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(181, N'SYT', N'PICKING', N'DEFAULT', CAST(42 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Linha: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(183, N'SYT', N'PICKING', N'DEFAULT', CAST(51 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Linha: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(182, N'SYT', N'PICKING', N'DEFAULT', CAST(48 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Linha: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(393, N'SYT', N'PICKING', N'DEFAULT', CAST(108 AS Numeric(18, 0)), N'LOAD_DOCS_STARTUP', N'Actualizar a lista de documentos ao entrar no processo', N'1', N'1', N'Apenas usado quando o parâmetro [Permite satisfazer vários documentos em simultâneo para o mesmo cliente] não está ativo', N'0', N'0', N''),
(160, N'SYT', N'PICKING', N'DEFAULT', CAST(27 AS Numeric(18, 0)), N'MESSAGE_LINES_QUERY', N'Linhas: Mensagem ao seleccionar um artigo', N'', N'', N'Consulta(SQL) que vai mostrar uma mensagem ao selecionar num artigo

Usar syntax SQL ex:

SELECT 0 as resultado, Obs as Mensagem FROM tabela WHERE ref=[REFARTIGO]

resultado=0 Mostra mensagem e continua
resultado=1 Mostra mensagem e cancela a acção

Podem ser utilizadas as seguintes keywords:

[CHAVECAB] - O campo identificador do documento
[NUMERODOC] - Número do documento
[NOMEENTIDADE] - Nome da entidade
[DATAFINAL] - Data do documento
[CODIGOENTIDADE] - Código da Entidade
[CODINTDOCUMENTO] - Código interno do documento
[NOMEDOCUMENTO] - Nome do documento
[NUNLINHA] - Número da linha
[REFARTIGO] - Referência do Artigo', N'0', N'0', N''),
(149, N'SYT', N'PICKING', N'DEFAULT', CAST(17 AS Numeric(18, 0)), N'MESSAGE_QUERY', N'Documentos: Mensagem ao seleccionar um documento', N'', N'', N'Consulta(SQL) que vai mostrar uma mensagem ao entrar num documento

Usar syntax SQL ex:

SELECT 0 as resultado, Obs as Mensagem FROM tabela WHERE cabkey=[CHAVECAB]

resultado=0 Mostra mensagem e continua
resultado=1 Mostra mensagem e cancela a acção

Podem ser utilizadas as seguintes keywords:

[CHAVECAB] - O campo identificador do documento
[NUMERODOC] - Número do documento
[NOMEENTIDADE] - Nome da entidade
[DATAFINAL] - Data do documento
[CODIGOENTIDADE] - Código da Entidade
[CODINTDOCUMENTO] - Código interno do documento
[NOMEDOCUMENTO] - Nome do documento', N'0', N'0', N''),
(296, N'SYT', N'PICKING', N'DEFAULT', CAST(54 AS Numeric(18, 0)), N'MODIFY_DELIVERY', N'Permite alterar o local de descarga', N'0', N'0', N'(0-Não permite 1-Permite)', N'0', N'0', N''),
(156, N'SYT', N'PICKING', N'DEFAULT', CAST(23 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(157, N'SYT', N'PICKING', N'DEFAULT', CAST(24 AS Numeric(18, 0)), N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo cliente', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(150, N'SYT', N'PICKING', N'DEFAULT', CAST(19 AS Numeric(18, 0)), N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N''),
(152, N'SYT', N'PICKING', N'DEFAULT', CAST(20 AS Numeric(18, 0)), N'NOQTY', N'Mostrar quantidade a picar por defeito', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB 1-Sim/0-Não.', N'0', N'0', N''),
(366, N'SYT', N'PICKING', N'DEFAULT', CAST(106 AS Numeric(18, 0)), N'NUMBER_COPIES', N'Número de cópias a imprimir', N'0', N'0', N'', N'0', N'0', N'Primavera;'),
(158, N'SYT', N'PICKING', N'DEFAULT', CAST(25 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N''),
(154, N'SYT', N'PICKING', N'DEFAULT', CAST(21 AS Numeric(18, 0)), N'PICKORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'Ex: ORDER BY Number', N'0', N'0', N''),
(155, N'SYT', N'PICKING', N'DEFAULT', CAST(22 AS Numeric(18, 0)), N'PICKORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'ORDER BY lin.Article, lin.PickingLineKey', N'Ex: ORDER BY Description', N'0', N'0', N''),
(364, N'SYT', N'PICKING', N'DEFAULT', CAST(104 AS Numeric(18, 0)), N'PRINT_DOCUMENT', N'Imprime o documento que foi integrado no ERP', N'0', N'0', N'Depois de criar o documento no ERP imprime. (Apenas para documentos integrados em Compras)

0 - Não
1 - Imprime todos os documentos
2 - Imprime apenas os documentos em que a série esteja configurada para comunicar à AT', N'0', N'0', N'Eticadata_16/17/18/19;primavera;'),
(340, N'SYT', N'PICKING', N'DEFAULT', CAST(100 AS Numeric(18, 0)), N'QTY_CTRL', N'Aceita quantidades superiores ao documento de origem', N'0', N'0', N'0-não / 1-sim com mensagem a avisar / 2- sim sem mensagem a avisar', N'0', N'0', N''),
(313, N'SYT', N'PICKING', N'DEFAULT', CAST(60 AS Numeric(18, 0)), N'QUALITY_NOTIFY', N'Notifica por email os produtos não conformes?', N'', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(314, N'SYT', N'PICKING', N'DEFAULT', CAST(61 AS Numeric(18, 0)), N'QUALITY_SENDER_NAME', N'Utilizador que envia os emails qualidade', N'', N'', N'Nome do utilizador e email separado por ;

ex:
Pedro Neves;pedroneves@gmail.com', N'0', N'0', N''),
(316, N'SYT', N'PICKING', N'DEFAULT', CAST(63 AS Numeric(18, 0)), N'QUALITY_SUBJECT', N'Assunto para envio de emails qualidade', N'Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])', N'Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])', N'Assunto para envio de emails qualidade

Podem ser usadas as keywords [NOME_ENTIDADE] e [DATA_HORA]', N'0', N'0', N''),
(315, N'SYT', N'PICKING', N'DEFAULT', CAST(62 AS Numeric(18, 0)), N'QUALITY_TO_EMAIL', N'Email dos destinatários para envio de emails qualidade', N'', N'', N'Endereços de email separados por ;

ex:
armazem@hotmail.com;responsavel@gmail.com', N'0', N'0', N''),
(365, N'SYT', N'PICKING', N'DEFAULT', CAST(105 AS Numeric(18, 0)), N'REPORT_NAME', N'Nome do report a imprimir', N'', N'', N'Nome do report sem a extensão', N'0', N'0', N'Primavera;'),
(359, N'SYT', N'PICKING', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'SERIE_BY_INDEX', N'Secção/Série de destino usar o mesmo índex do documento de destino', N'0', N'0', N'0-Não 1-Sim

Vai atribuir a secção/série usando o mesmo index do documento de destino

ex: se o documento de destino for GT1,GT2,GT3 e a secção/série de destino for A,B,C

ao integrar se o documento de destino for GT1 vai atribuir a série A
ao integrar se o documento de destino for GT2 vai atribuir a série B
ao integrar se o documento de destino for GT3 vai atribuir a série C', N'0', N'0', N''),
(136, N'SYT', N'PICKING', N'DEFAULT', CAST(4 AS Numeric(18, 0)), N'SERIE_ORIGEM', N'Secção/Série do documento de destino igual à do documento de origem', N'0', N'0', N'0-Não 1-Sim

Vai integrar na mesma secção/série do documento de origem!', N'0', N'0', N''),
(133, N'SYT', N'PICKING', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'SRC_DOSSIER', N'Tipos de documentos que dão origem ao picking.', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N''),
(291, N'SYT', N'PICKING', N'DEFAULT', CAST(53 AS Numeric(18, 0)), N'USE_EXPEDITION', N'Usar localização de expedição', N'0', N'0', N'0-Não 1-Sim

Antes de integrar é pedida a localização de expedição', N'0', N'0', N''),
(353, N'SYT', N'PICKING', N'DEFAULT', CAST(102 AS Numeric(18, 0)), N'VERIFYPENDING', N'Mostrar artigos pendentes quando integra', N'1', N'1', N'0-Não 1-Sim

Antes de integrar se existirem artigos pendentes mostra lista dos artigos', N'0', N'0', N''),
(293, N'SYT', N'PRICECHECKING', N'DEFAULT', CAST(53 AS Numeric(18, 0)), N'TITLELABEL1', N'Título do campo User1', N'', N'', N'

Título do campo User1 que é mostrado na opção consulta de Preços', N'0', N'0', N''),
(294, N'SYT', N'PRICECHECKING', N'DEFAULT', CAST(53 AS Numeric(18, 0)), N'TITLELABEL2', N'Título do campo User2', N'', N'', N'

Título do campo User2 que é mostrado na opção consulta de Preços', N'0', N'0', N''),
(319, N'SYT', N'STOCKS', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'QUANTITY_AVAILABLE', N'Mostrar a quantidade disponível', N'0', N'0', N'0-Não 1-Sim (Quantidades são atribuidas na SP_u_Kapps_ProductStockUSR)', N'0', N'0', N''),
(204, N'SYT', N'STORE IN', N'DEFAULT', CAST(19 AS Numeric(18, 0)), N'AUTOQTY', N'Apresentar automaticamente o teclado para indicar quantidade a picar?', N'', N'0', N'1-Sim/0-Não.', N'0', N'0', N''),
(320, N'SYT', N'STORE IN', N'DEFAULT', CAST(61 AS Numeric(18, 0)), N'CAB_FIELDS_REQUIRED', N'Documento: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(218, N'SYT', N'STORE IN', N'DEFAULT', CAST(31 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(215, N'SYT', N'STORE IN', N'DEFAULT', CAST(28 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Documento: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(217, N'SYT', N'STORE IN', N'DEFAULT', CAST(37 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Documento: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(216, N'SYT', N'STORE IN', N'DEFAULT', CAST(34 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Documento: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(222, N'SYT', N'STORE IN', N'DEFAULT', CAST(32 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(219, N'SYT', N'STORE IN', N'DEFAULT', CAST(29 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Documento: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(221, N'SYT', N'STORE IN', N'DEFAULT', CAST(38 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Documento: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(220, N'SYT', N'STORE IN', N'DEFAULT', CAST(35 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Documento: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(226, N'SYT', N'STORE IN', N'DEFAULT', CAST(33 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(223, N'SYT', N'STORE IN', N'DEFAULT', CAST(30 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Documento: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(225, N'SYT', N'STORE IN', N'DEFAULT', CAST(39 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Documento: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(224, N'SYT', N'STORE IN', N'DEFAULT', CAST(36 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Documento: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(213, N'SYT', N'STORE IN', N'DEFAULT', CAST(26 AS Numeric(18, 0)), N'CLOSE_LINE', N'Permite fechar a linha', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(287, N'SYT', N'STORE IN', N'DEFAULT', CAST(57 AS Numeric(18, 0)), N'DEFAULT_ARM_LOCATION', N'Armazém e localização por defeito', N'', N'', N'Armazem;Localização;Permite Alterar(0-Não 1-Sim)

Podem ser utilizadas as seguintes keywords:
[CURRENT_WAREHOUSE]

ex:
A1;A1.A.1.001;0 
(Armazem: A1; Localização: A1.A.1.001 RECECAO; 0: Não permite alterar)

ex:
[CURRENT_WAREHOUSE];RECECAO;1 
(Armazem: Armazem definido no terminal; Localização: RECECAO; 1: Permite alterar)', N'0', N'0', N''),
(240, N'SYT', N'STORE IN', N'DEFAULT', CAST(99 AS Numeric(18, 0)), N'DOC_DATE', N'Mostrar todos os documentos até a data atual', N'', N'<=', N'Usar um dos seguintes operadores <, <=, =, >, >=

<=	(Mostra todos os documentos até à data atual)
=	(Mostra apenas os documentos da data atual)
>=	(Mostra os documentos iguais e posteriores à data atual)', N'0', N'0', N''),
(329, N'SYT', N'STORE IN', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'DOC_OBS1', N'Documentos: Informação adicional primeira linha', N'', N'', N'Usada para mostrar informação adicional na lista de documentos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, cab.UserCol1 + cab.UserCol2 + cab.UserCol3 

outro exemplo usando SQL

, (SELECT Observacoes FROM CabecCompras WHERE CabecCompras.ID=cab.ReceptionKey)', N'0', N'0', N''),
(330, N'SYT', N'STORE IN', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'DOC_OBS2', N'Documentos: Informação adicional segunda linha', N'', N'', N'Usada para mostrar informação adicional na lista de documentos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, cab.UserCol1 + cab.UserCol2 + cab.UserCol3 

outro exemplo usando SQL

, (SELECT CodPostal+'' ''+CodPostalLocalidade FROM CabecCompras WHERE CabecCompras.ID=cab.ReceptionKey)', N'0', N'0', N''),
(188, N'SYT', N'STORE IN', N'DEFAULT', CAST(2 AS Numeric(18, 0)), N'DST_DOSSIER', N'Tipos de documentos a gerar na integração da receção', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N''),
(358, N'SYT', N'STORE IN', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'DST_SERIE', N'Secção/Série do documento a gerar', N'', N'', N'Secção/Série de destino dos documentos a integrar

Lista de secções/séries separada por virgulas ex: A,B,C se não indicar nenhuma série é usada a série definida nos parâmetros do utilizador', N'0', N'0', N''),
(239, N'SYT', N'STORE IN', N'DEFAULT', CAST(52 AS Numeric(18, 0)), N'FATOR_MULTIPLICATIVO', N'Mostra campo para colocar um fator multiplicativo', N'0', N'0', N'0-Não /1-Sim (Exemplo: Para colocar o número de caixas, de forma a não ter de picar todas as caixas)', N'0', N'0', N''),
(306, N'SYT', N'STORE IN', N'DEFAULT', CAST(60 AS Numeric(18, 0)), N'FECHAR_DOC_ORIGEM', N'Fechar o documento de origem', N'0', N'0', N'0 - Ao integrar o documento confirma se pretende fechar o documento de origem
1 - Ao integrar o documento não confirma e fecha sempre o documento de origem
2 - Ao integrar o documento não confirma e nunca fecha o documento de origem', N'0', N'0', N''),
(193, N'SYT', N'STORE IN', N'DEFAULT', CAST(7 AS Numeric(18, 0)), N'GRID1_ALIAS', N'Documentos: Títulos para os cabeçalhos das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os nomes das colunas separados por virgula, ex: Nome,Data,Estado

Estas colunas são usadas nos filtros', N'0', N'0', N''),
(194, N'SYT', N'STORE IN', N'DEFAULT', CAST(8 AS Numeric(18, 0)), N'GRID1_COL_TYPE', N'Documentos: Tipos de dados das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os tipos das colunas separados por virgula, ex: s,d,n,s,s,s,s,s,s,s

s - alfanumérico
d - data
n - numérico', N'0', N'0', N''),
(196, N'SYT', N'STORE IN', N'DEFAULT', CAST(10 AS Numeric(18, 0)), N'GRID1_DEF_FILTER', N'Documentos: Filtro adicional na lista de documentos', N'', N'', N'Usando syntax SQL deve começar por AND seguido da condição

Podem ser utilizadas as seguintes keywords: [WORKWAREHOUSE],[USERNAME]

Exemplo para mostrar apenas os documentos do armazém selecionado usando a coluna Filter1:
AND cab.Filter1=''[WORKWAREHOUSE]''', N'0', N'0', N''),
(199, N'SYT', N'STORE IN', N'DEFAULT', CAST(13 AS Numeric(18, 0)), N'GRID2_ALIAS', N'Linhas: Títulos para os cabeçalhos das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os nomes das colunas separados por virgula, ex: Nome,Data,Estado

Estas colunas são usadas nos filtros', N'0', N'0', N''),
(200, N'SYT', N'STORE IN', N'DEFAULT', CAST(14 AS Numeric(18, 0)), N'GRID2_COL_TYPE', N'Linhas: Tipos de dados das 10 colunas (UserCol1,UserCol2,...)', N'', N'', N'Deve indicar os tipos das colunas separados por virgula, ex: s,d,n,s,s,s,s,s,s,s

s - alfanumérico
d - data
n - numérico', N'0', N'0', N''),
(202, N'SYT', N'STORE IN', N'DEFAULT', CAST(16 AS Numeric(18, 0)), N'GRID2_DEF_FILTER', N'Linhas: Filtro adicional', N'', N'', N'Usando syntax SQL deve começar por AND seguido da condição

Podem ser utilizadas as seguintes keywords: [WORKWAREHOUSE],[USERNAME]

Exemplo para mostrar apenas as linhas do armazém selecionado:

AND lin.Warehouse=''[WORKWAREHOUSE]''', N'0', N'0', N''),
(347, N'SYT', N'STORE IN', N'DEFAULT', CAST(63 AS Numeric(18, 0)), N'GRIDFORSERIALNUMBERS', N'Pedir números de série numa grelha', N'0', N'0', N'0-Não 1-Sim

Permite que se possa ler vários números de série para a mesma linha', N'0', N'0', N''),
(205, N'SYT', N'STORE IN', N'DEFAULT', CAST(19 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N''),
(189, N'SYT', N'STORE IN', N'DEFAULT', CAST(3 AS Numeric(18, 0)), N'INTEGRATION_BY_INDEX', N'Documento de destino pelo mesmo índex do documento de origem', N'0', N'0', N'0-Não /1-Sim - Vai procurar qual o código do documento de destino que está no mesmo index do documento de origem', N'0', N'0', N''),
(321, N'SYT', N'STORE IN', N'DEFAULT', CAST(62 AS Numeric(18, 0)), N'LIN_FIELDS_REQUIRED', N'Linha: Campos de utilizador obrigatórios', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(331, N'SYT', N'STORE IN', N'DEFAULT', CAST(15 AS Numeric(18, 0)), N'LIN_OBS1', N'Linhas: Informação adicional', N'', N'', N'Usada para mostrar informação adicional na lista de artigos a picar

Deve começar por virgula e usar syntax SQL, exemplo usando campos da view:

, lin.UserCol1 + lin.UserCol2 + lin.UserCol3 

outro exemplo usando SQL

, (SELECT convert(varchar(100), Observacoes) FROM Artigo Art WHERE Art.Artigo = lin.Article )', N'0', N'0', N''),
(230, N'SYT', N'STORE IN', N'DEFAULT', CAST(43 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(227, N'SYT', N'STORE IN', N'DEFAULT', CAST(40 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Linha: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(228, N'SYT', N'STORE IN', N'DEFAULT', CAST(49 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Linha: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(229, N'SYT', N'STORE IN', N'DEFAULT', CAST(46 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Linha: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(234, N'SYT', N'STORE IN', N'DEFAULT', CAST(44 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(231, N'SYT', N'STORE IN', N'DEFAULT', CAST(41 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Linha: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(233, N'SYT', N'STORE IN', N'DEFAULT', CAST(50 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Linha: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(232, N'SYT', N'STORE IN', N'DEFAULT', CAST(47 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Linha: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(238, N'SYT', N'STORE IN', N'DEFAULT', CAST(45 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(235, N'SYT', N'STORE IN', N'DEFAULT', CAST(42 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Linha: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(237, N'SYT', N'STORE IN', N'DEFAULT', CAST(51 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Linha: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(236, N'SYT', N'STORE IN', N'DEFAULT', CAST(48 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Linha: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(395, N'SYT', N'STORE IN', N'DEFAULT', CAST(108 AS Numeric(18, 0)), N'LOAD_DOCS_STARTUP', N'Actualizar a lista de documentos ao entrar no processo', N'1', N'1', N'Apenas usado quando o parâmetro [Permite satisfazer vários documentos em simultâneo para o mesmo cliente] não está ativo', N'0', N'0', N''),
(214, N'SYT', N'STORE IN', N'DEFAULT', CAST(27 AS Numeric(18, 0)), N'MESSAGE_LINES_QUERY', N'Linhas: Mensagem ao seleccionar um artigo', N'', N'', N'Consulta(SQL) que vai mostrar uma mensagem ao selecionar num artigo

Usar syntax SQL ex:

SELECT 0 as resultado, Obs as Mensagem FROM tabela WHERE ref=[REFARTIGO]

resultado=0 Mostra mensagem e continua
resultado=1 Mostra mensagem e cancela a acção

Podem ser utilizadas as seguintes keywords:

[CHAVECAB] - O campo identificador do documento
[NUMERODOC] - Número do documento
[NOMEENTIDADE] - Nome da entidade
[DATAFINAL] - Data do documento
[CODIGOENTIDADE] - Código da Entidade
[CODINTDOCUMENTO] - Código interno do documento
[NOMEDOCUMENTO] - Nome do documento
[NUNLINHA] - Número da linha
[REFARTIGO] - Referência do Artigo', N'0', N'0', N''),
(203, N'SYT', N'STORE IN', N'DEFAULT', CAST(17 AS Numeric(18, 0)), N'MESSAGE_QUERY', N'Documentos: Mensagem ao seleccionar um documento', N'', N'', N'Consulta(SQL) que vai mostrar uma mensagem ao entrar num documento

Usar syntax SQL ex:

SELECT 0 as resultado, Obs as Mensagem FROM tabela WHERE cabkey=[CHAVECAB]

resultado=0 Mostra mensagem e continua
resultado=1 Mostra mensagem e cancela a acção

Podem ser utilizadas as seguintes keywords:

[CHAVECAB] - O campo identificador do documento
[NUMERODOC] - Número do documento
[NOMEENTIDADE] - Nome da entidade
[DATAFINAL] - Data do documento
[CODIGOENTIDADE] - Código da Entidade
[CODINTDOCUMENTO] - Código interno do documento
[NOMEDOCUMENTO] - Nome do documento', N'0', N'0', N''),
(210, N'SYT', N'STORE IN', N'DEFAULT', CAST(23 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(211, N'SYT', N'STORE IN', N'DEFAULT', CAST(24 AS Numeric(18, 0)), N'MULTI_DOCUMENT', N'Permite satisfazer vários documentos em simultâneo para o mesmo fornecedor', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(206, N'SYT', N'STORE IN', N'DEFAULT', CAST(19 AS Numeric(18, 0)), N'NO_SELECT_GRID', N'Permite selecionar artigo da grelha', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N''),
(207, N'SYT', N'STORE IN', N'DEFAULT', CAST(20 AS Numeric(18, 0)), N'NOQTY', N'Mostrar quantidade a picar por defeito', N'', N'1', N'Apresenta teclado para quantidade automaticamente após leitura de CB 1-Sim/0-Não.', N'0', N'0', N''),
(378, N'SYT', N'STORE IN', N'DEFAULT', CAST(106 AS Numeric(18, 0)), N'NUMBER_COPIES', N'Número de cópias a imprimir', N'0', N'0', N'', N'0', N'0', N'Primavera;'),
(362, N'SYT', N'STORE IN', N'DEFAULT', CAST(103 AS Numeric(18, 0)), N'ONEDOC_INTEGRATION', N'Integra no ERP em apenas um documento', N'1', N'1', N'Quando permite satisfazer vários documentos em simultâneo para o mesmo fornecedor

1 - Sim (vai criar apenas um documento no ERP)

0 - Não (vai criar vários documentos no ERP conforme o número de documentos de origem selecionados)', N'0', N'0', N''),
(212, N'SYT', N'STORE IN', N'DEFAULT', CAST(25 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N''),
(346, N'SYT', N'STORE IN', N'DEFAULT', CAST(101 AS Numeric(18, 0)), N'OVERRIDE_LOCATION', N'Pedir a localização de destino após selecionar o documento', N'0', N'0', N'0-Não 1-Sim

Pedir a localização de destino após selecionar o documento e não usar a localização de origem', N'0', N'0', N''),
(376, N'SYT', N'STORE IN', N'DEFAULT', CAST(104 AS Numeric(18, 0)), N'PRINT_DOCUMENT', N'Imprime o documento que foi integrado no ERP', N'0', N'0', N'Depois de criar o documento no ERP imprime. (Apenas para documentos integrados em Compras)

0 - Não
1 - Imprime todos os documentos
2 - Imprime apenas os documentos em que a série esteja configurada para comunicar à AT', N'0', N'0', N'Eticadata_16/17/18/19;primavera;'),
(341, N'SYT', N'STORE IN', N'DEFAULT', CAST(100 AS Numeric(18, 0)), N'QTY_CTRL', N'Aceita quantidades superiores ao documento de origem', N'0', N'0', N'0-não / 1-sim com mensagem a avisar / 2- sim sem mensagem a avisar', N'0', N'0', N''),
(288, N'SYT', N'STORE IN', N'DEFAULT', CAST(58 AS Numeric(18, 0)), N'QUALITY_ARM_LOCATION', N'Armazém e localização por defeito para produtos não conformes', N'', N'', N'Armazem;Localização;Permite Alterar(0-Não 1-Sim)

Podem ser utilizadas as seguintes keywords:
[CURRENT_WAREHOUSE]

ex:
A1;A1.A.1.001;0 
(Armazem: A1; Localização: A1.A.1.001 RECECAO; 0: Não permite alterar)

ex:
[CURRENT_WAREHOUSE];RECECAO;1 
(Armazem: Armazem definido no terminal; Localização: RECECAO; 1: Permite alterar)', N'0', N'0', N''),
(283, N'SYT', N'STORE IN', N'DEFAULT', CAST(53 AS Numeric(18, 0)), N'QUALITY_NOTIFY', N'Notifica por email os produtos não conformes?', N'', N'0', N'0-Não 1-Sim', N'0', N'0', N''),
(284, N'SYT', N'STORE IN', N'DEFAULT', CAST(54 AS Numeric(18, 0)), N'QUALITY_SENDER_NAME', N'Utilizador que envia os emails qualidade', N'', N'', N'Nome do utilizador e email separado por ;

ex:
Pedro Neves;pedroneves@gmail.com', N'0', N'0', N''),
(286, N'SYT', N'STORE IN', N'DEFAULT', CAST(56 AS Numeric(18, 0)), N'QUALITY_SUBJECT', N'Assunto para envio de emails qualidade', N'Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])', N'Syslog - [NOME_ENTIDADE] - Inconformidades ([DATA_HORA])', N'Assunto para envio de emails qualidade

Podem ser usadas as keywords [NOME_ENTIDADE] e [DATA_HORA]', N'0', N'0', N''),
(285, N'SYT', N'STORE IN', N'DEFAULT', CAST(55 AS Numeric(18, 0)), N'QUALITY_TO_EMAIL', N'Email dos destinatários para envio de emails qualidade', N'', N'', N'Endereços de email separados por ;

ex:
armazem@hotmail.com;responsavel@gmail.com', N'0', N'0', N''),
(208, N'SYT', N'STORE IN', N'DEFAULT', CAST(21 AS Numeric(18, 0)), N'RECEORDERBYDOC', N'Documentos: Ordenação dos documentos', N'', N'', N'Ex: ORDER BY Number', N'0', N'0', N''),
(209, N'SYT', N'STORE IN', N'DEFAULT', CAST(22 AS Numeric(18, 0)), N'RECEORDERBYLIN', N'Linhas: Ordenação das linhas', N'', N'ORDER BY lin.Article, lin.ReceptionLineKey', N'Ex: ORDER BY Description', N'0', N'0', N''),
(377, N'SYT', N'STORE IN', N'DEFAULT', CAST(105 AS Numeric(18, 0)), N'REPORT_NAME', N'Nome do report a imprimir', N'', N'', N'Nome do report sem a extensão', N'0', N'0', N'Primavera;'),
(361, N'SYT', N'STORE IN', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'SERIE_BY_INDEX', N'Secção/Série de destino usar o mesmo índex do documento de destino', N'0', N'0', N'0-Não 1-Sim

Vai atribuir a secção/série usando o mesmo index do documento de destino

ex: se o documento de destino for GT1,GT2,GT3 e a secção/série de destino for A,B,C

ao integrar se o documento de destino for GT1 vai atribuir a série A
ao integrar se o documento de destino for GT2 vai atribuir a série B
ao integrar se o documento de destino for GT3 vai atribuir a série C', N'0', N'0', N''),
(190, N'SYT', N'STORE IN', N'DEFAULT', CAST(4 AS Numeric(18, 0)), N'SERIE_ORIGEM', N'Secção/Série do documento de destino igual à do documento de origem', N'0', N'0', N'0-Não 1-Sim

Vai integrar na mesma secção/série do documento de origem!', N'0', N'0', N''),
(187, N'SYT', N'STORE IN', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'SRC_DOSSIER', N'Tipos de documentos que dão origem à receção', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'1', N'0', N''),
(290, N'SYT', N'STORE IN', N'DEFAULT', CAST(59 AS Numeric(18, 0)), N'USE_RECEPTION_LOCATIONS', N'Usar apenas localizações do tipo receção', N'0', N'0', N'0-Não 1-Sim

Se usar localizações do tipo receção não permite escolher outras localizações', N'0', N'0', N''),
(355, N'SYT', N'STORE IN', N'DEFAULT', CAST(102 AS Numeric(18, 0)), N'VERIFYPENDING', N'Mostrar artigos pendentes quando integra', N'1', N'1', N'0-Não 1-Sim

Antes de integrar se existirem artigos pendentes mostra lista dos artigos', N'0', N'0', N''),
(241, N'SYT', N'TRANSF', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'CAB_USER_FIELD1_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(242, N'SYT', N'TRANSF', N'DEFAULT', CAST(6 AS Numeric(18, 0)), N'CAB_USER_FIELD1_NAME', N'Documento: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(243, N'SYT', N'TRANSF', N'DEFAULT', CAST(8 AS Numeric(18, 0)), N'CAB_USER_FIELD1_SIZE', N'Documento: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(244, N'SYT', N'TRANSF', N'DEFAULT', CAST(7 AS Numeric(18, 0)), N'CAB_USER_FIELD1_TYPE', N'Documento: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(245, N'SYT', N'TRANSF', N'DEFAULT', CAST(13 AS Numeric(18, 0)), N'CAB_USER_FIELD2_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(246, N'SYT', N'TRANSF', N'DEFAULT', CAST(10 AS Numeric(18, 0)), N'CAB_USER_FIELD2_NAME', N'Documento: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(247, N'SYT', N'TRANSF', N'DEFAULT', CAST(12 AS Numeric(18, 0)), N'CAB_USER_FIELD2_SIZE', N'Documento: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(248, N'SYT', N'TRANSF', N'DEFAULT', CAST(11 AS Numeric(18, 0)), N'CAB_USER_FIELD2_TYPE', N'Documento: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(249, N'SYT', N'TRANSF', N'DEFAULT', CAST(17 AS Numeric(18, 0)), N'CAB_USER_FIELD3_INTEGRATION_NAME', N'Documento: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela do cabeçalho)', N'0', N'0', N''),
(250, N'SYT', N'TRANSF', N'DEFAULT', CAST(14 AS Numeric(18, 0)), N'CAB_USER_FIELD3_NAME', N'Documento: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(251, N'SYT', N'TRANSF', N'DEFAULT', CAST(16 AS Numeric(18, 0)), N'CAB_USER_FIELD3_SIZE', N'Documento: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(252, N'SYT', N'TRANSF', N'DEFAULT', CAST(15 AS Numeric(18, 0)), N'CAB_USER_FIELD3_TYPE', N'Documento: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(253, N'SYT', N'TRANSF', N'DEFAULT', CAST(2 AS Numeric(18, 0)), N'INTEGRATE_DOCUMENT', N'Integra os documentos', N'1', N'1', N'0-Não / 1-Sim', N'0', N'0', N''),
(254, N'SYT', N'TRANSF', N'DEFAULT', CAST(21 AS Numeric(18, 0)), N'LIN_USER_FIELD1_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 1 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(255, N'SYT', N'TRANSF', N'DEFAULT', CAST(18 AS Numeric(18, 0)), N'LIN_USER_FIELD1_NAME', N'Linha: Título do campo de utilizador 1', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(256, N'SYT', N'TRANSF', N'DEFAULT', CAST(20 AS Numeric(18, 0)), N'LIN_USER_FIELD1_SIZE', N'Linha: Tamanho do campo de utilizador 1', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(257, N'SYT', N'TRANSF', N'DEFAULT', CAST(19 AS Numeric(18, 0)), N'LIN_USER_FIELD1_TYPE', N'Linha: Tipo do campo de utilizador 1', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(258, N'SYT', N'TRANSF', N'DEFAULT', CAST(25 AS Numeric(18, 0)), N'LIN_USER_FIELD2_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 2 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(259, N'SYT', N'TRANSF', N'DEFAULT', CAST(22 AS Numeric(18, 0)), N'LIN_USER_FIELD2_NAME', N'Linha: Título do campo de utilizador 2', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(260, N'SYT', N'TRANSF', N'DEFAULT', CAST(24 AS Numeric(18, 0)), N'LIN_USER_FIELD2_SIZE', N'Linha: Tamanho do campo de utilizador 2', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(261, N'SYT', N'TRANSF', N'DEFAULT', CAST(23 AS Numeric(18, 0)), N'LIN_USER_FIELD2_TYPE', N'Linha: Tipo do campo de utilizador 2', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(262, N'SYT', N'TRANSF', N'DEFAULT', CAST(29 AS Numeric(18, 0)), N'LIN_USER_FIELD3_INTEGRATION_NAME', N'Linha: Nome do campo de utilizador 3 onde vai integrar', N'', N'', N'Nome do campo onde vai ser integrada a informação. (No ERP criar campo de utilizador na tabela das linhas)', N'0', N'0', N''),
(263, N'SYT', N'TRANSF', N'DEFAULT', CAST(26 AS Numeric(18, 0)), N'LIN_USER_FIELD3_NAME', N'Linha: Título do campo de utilizador 3', N'', N'', N'Título do campo a mostrar no ecrã', N'0', N'0', N''),
(264, N'SYT', N'TRANSF', N'DEFAULT', CAST(28 AS Numeric(18, 0)), N'LIN_USER_FIELD3_SIZE', N'Linha: Tamanho do campo de utilizador 3', N'0', N'0', N'0-Sem limite', N'0', N'0', N''),
(265, N'SYT', N'TRANSF', N'DEFAULT', CAST(27 AS Numeric(18, 0)), N'LIN_USER_FIELD3_TYPE', N'Linha: Tipo do campo de utilizador 3', N'', N'', N's-String / n-Numérico / d-Date', N'0', N'0', N''),
(266, N'SYT', N'TRANSF', N'DEFAULT', CAST(4 AS Numeric(18, 0)), N'MODO_AUTO', N'Assume automaticamente a quantidade lida', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(267, N'SYT', N'TRANSF', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'ORDER_INTEGRATION', N'Ordenação das linhas a integrar', N'0', N'0', N'0-Ordem de picagem / 1-Ordem do documento / 2-Referência do artigo / 3-Descrição do artigo', N'0', N'0', N''),
(289, N'SYT', N'TRANSF', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'TIPO_TRANSFERENCIA', N'Tipo de transferência', N'0', N'0', N'0 - Transferência entre armazéns com destino conhecido
1 - Transferência entre armazéns sem destino conhecido
2 - Transferência directa entre localizações de um produto dentro do mesmo armazém
3 - Transferência dois passos entre armazéns/localizações
4 - Transferência directa de uma localização completa para outra localização dentro do mesmo armazém
5 - Transferência dois passos de uma localização para vários armazéns/localizações', N'0', N'0', N''),
(268, N'SYT', N'TRANSF', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'TRANSF', N'Tipos de documentos (transferências)', N'', N'', N'tipos de documento separados por virgula ex.(1,2,3)', N'0', N'0', N''),
(374, N'SYT', N'TRANSF', N'DEFAULT', CAST(31 AS Numeric(18, 0)), N'USE_ALL_WAREHOUSES', N'Pode transferir para outros armazéns', N'0', N'0', N'Permite selecionar outros armazéns no armazém de destino (Apenas usado nas transferências do tipo dois passos)', N'0', N'0', N''),
(318, N'SYT', N'TRANSF', N'DEFAULT', CAST(30 AS Numeric(18, 0)), N'USE_SERIALNUMBER', N'Gere números de série', N'1', N'1', N'0 - Não é pedido o número de série nos artigos que na view v_Kapps_Articles venham com o valor 2 no campo UseSerialNumber
1 - Gere números de série', N'0', N'0', N''),
(269, N'SYT', N'TRANSF', N'DEFAULT', CAST(3 AS Numeric(18, 0)), N'VALIDA_STOCK', N'Valida Stock dos documentos', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N''),
(271, N'SYT', N'USR', N'DEFAULT', CAST(8 AS Numeric(18, 0)), N'COD_LOTE', N'Código da propriedade associada ao lote', N'', N'', N'', N'0', N'0', N'Sage_50C;'),
(272, N'SYT', N'USR', N'DEFAULT', CAST(9 AS Numeric(18, 0)), N'DOC_CLOSE_COD', N'Código do estado para fechar documento (Sage 50C)', N'', N'1', N'', N'1', N'0', N'Sage_50C;'),
(363, N'SYT', N'USR', N'DEFAULT', CAST(11 AS Numeric(18, 0)), N'IGNORE_PROFIT_MARGIN', N'Ignora a margem de lucro mínima', N'0', N'0', N'0-Não 1-Sim

Ao integrar ignora a verificação se a margem é inferior á margem de lucro mínima', N'0', N'0', N'Eticadata_16/17/18/19;'),
(385, N'SYT', N'USR', N'DEFAULT', CAST(12 AS Numeric(18, 0)), N'LINHA_COMENTARIO', N'No documento a gerar incluir linhas de comentário dos documentos originais', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N'Primavera;'),
(299, N'SYT', N'USR', N'DEFAULT', CAST(10 AS Numeric(18, 0)), N'LINHA_ESPECIAL', N'No documento a gerar incluir linhas com a indicação dos documentos originais', N'0', N'0', N'(0-Não 1-Sim)', N'0', N'0', N'Primavera;'),
(386, N'SYT', N'USR', N'DEFAULT', CAST(12 AS Numeric(18, 0)), N'LINHA_PORTES', N'No documento a gerar incluir linhas de portes dos documentos originais', N'0', N'0', N'0-Não 1-Sim', N'0', N'0', N'Primavera;'),
(25, N'SYT', N'USR', N'DEFAULT', CAST(5 AS Numeric(18, 0)), N'MOEDA', N'Código da moeda por defeito', N'', N'', N'', N'1', N'0', N'Sage_50C;Sage_100C;Sendys;'),
(21, N'SYT', N'USR', N'DEFAULT', CAST(1 AS Numeric(18, 0)), N'ProductReplacement', N'Substituir referencias', N'', N'0', N'Permite substituir artigo não existente no documento por outra referencia
0-Não 1-Sim', N'0', N'0', N''),
(27, N'SYT', N'USR', N'DEFAULT', CAST(7 AS Numeric(18, 0)), N'REGIME_IVA', N'Regime de Iva', N'', N'', N'', N'0', N'0', N'Sage_100C;Sendys;'),
(23, N'SYT', N'USR', N'DEFAULT', CAST(3 AS Numeric(18, 0)), N'RESERVA_QUANTIDADES', N'Reserva quantidades', N'0', N'0', N'0-Não / 1-Sim', N'0', N'0', N'primavera;'),
(22, N'SYT', N'USR', N'DEFAULT', CAST(2 AS Numeric(18, 0)), N'SECCAO', N'Secção/Série do documento a gerar', N'', N'', N'Secção/Série de destino dos documentos a integrar', N'0', N'0', N'Eticadata_13;Eticadata_16/17/18/19;primavera;Sage_50C;Sage_100C;Sendys;Personalizado;'),
(24, N'SYT', N'USR', N'DEFAULT', CAST(4 AS Numeric(18, 0)), N'SETOR', N'Código do setor por defeito', N'', N'', N'', N'0', N'0', N'Sage_100C;'),
(26, N'SYT', N'USR', N'DEFAULT', CAST(6 AS Numeric(18, 0)), N'TIPO_DOC_CONTAGENS', N'Código do documento de inventário', N'INV', N'INV', N'', N'0', N'0', N'Eticadata_13;Eticadata_16/17/18/19;Sage_50C;Sage_100C;Sendys;');
SET IDENTITY_INSERT [u_Kapps_Parameters] OFF;
INSERT INTO u_Kapps_ParametersTypes (TypeID, Name, IsParameter, TypeOrder, DefaultDescription) VALUES 
(N'EAN128', N'Códigos de Barras', 1, 2, N''),
(N'EXT', N'Extensibilidade', 0, 1, N''),
(N'EXTPROJ', N'Projecto de extensibilidade', 2, 10, N'Processo a usar nos projectos de extensibilidade'),
(N'GENERAL', N'Gerais', 1, 1, N''),
(N'INSPECTION', N'Contagens', 2, 4, N'Contagens'),
(N'LOTES', N'Lotes', 1, 3, N''),
(N'MAIN', N'Parâmetros Gerais', 0, 0, N''),
(N'OTHERS', N'Outros Documentos', 2, 5, N'Registo de quebras, etc...'),
(N'PACKING', N'Packing', 2, 3, N'Empacotamento do material'),
(N'PICKING', N'Picking', 2, 2, N'Contagem de material a preparar para expedição'),
(N'PRICECHECKING', N'Preços', 2, 7, N'Consulta de preços'),
(N'QUERIES', N'Consultas', 2, 9, N'Consultas e operações diversas'),
(N'STOCKS', N'Stock Arm.', 2, 8, N'Consulta de stock em armazém'),
(N'STORE IN', N'Receção', 2, 1, N'Entrada de mercadoria'),
(N'TRANSF', N'Transferências', 2, 6, N'Transferências entre armazéns'),
(N'USR', N'USR', 3, 1, N'');

