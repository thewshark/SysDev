--
-- Drop Tables
--
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_Terminals') AND type in (N'U'))
DROP TABLE u_KApps_Terminals
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_Session_USers') AND type in (N'U'))
DROP TABLE u_KApps_Session_USers
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_Session_Docs') AND type in (N'U'))
DROP TABLE u_KApps_Session_Docs
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_DossierLin') AND type in (N'U'))
DROP TABLE u_KApps_DossierLin
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'kApps_Parameters') AND type in (N'U'))
DROP TABLE kApps_Parameters
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_Log') AND type in (N'U'))
DROP TABLE u_KApps_Log
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kapps_Transporters') AND type in (N'U'))
DROP TABLE u_kapps_Transporters
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kapps_Printers') AND type in (N'U'))
DROP TABLE u_kapps_Printers
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kapps_PackingHeader') AND type in (N'U'))
DROP TABLE u_kapps_PackingHeader
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kapps_PackingDetails') AND type in (N'U'))
DROP TABLE u_kapps_PackingDetails
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kapps_Events') AND type in (N'U'))
DROP TABLE u_kapps_Events
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kapps_LabelRules') AND type in (N'U'))
DROP TABLE u_kapps_LabelRules
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kapps_Labels') AND type in (N'U'))
DROP TABLE u_kapps_Labels
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kapps_packagingTypes') AND type in (N'U'))
DROP TABLE u_kapps_packagingTypes
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Alerts') AND type in (N'U'))
DROP TABLE u_Kapps_Alerts
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InvHeader') AND type in (N'U'))
DROP TABLE u_Kapps_InvHeader
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InvLines') AND type in (N'U'))
DROP TABLE u_Kapps_InvLines
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Users') AND type in (N'U'))
DROP TABLE u_Kapps_Users
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kApps_UsersProcesses') AND type in (N'U'))
DROP TABLE u_kApps_UsersProcesses
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_UsersWarehouses') AND type in (N'U'))
DROP TABLE u_Kapps_UsersWarehouses
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_TU1') AND type in (N'U'))
DROP TABLE u_KApps_TU1
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_TU2') AND type in (N'U'))
DROP TABLE u_KApps_TU2
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_TU3') AND type in (N'U'))
DROP TABLE u_KApps_TU3
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_KApps_TU4') AND type in (N'U'))
DROP TABLE u_KApps_TU4
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kApps_Parameters') AND type in (N'U'))
DROP TABLE u_kApps_Parameters
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kApps_ParametersTypes') AND type in (N'U'))
DROP TABLE u_kApps_ParametersTypes
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_kApps_Processes') AND type in (N'U'))
DROP TABLE u_kApps_Processes
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_ParametersMonitors') AND type in (N'U'))
DROP TABLE u_Kapps_ParametersMonitors
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_StockDocs') AND type in (N'U'))
DROP TABLE u_Kapps_StockDocs
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_OrigStampHeader') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_OrigStampHeader
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_OrigStampLin') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_OrigStampLin
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Warehouse') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Warehouse
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Location') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Location
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Lot') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Lot
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Ref') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Ref
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Description') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Description
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Qty') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Qty
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_SerialNumber') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_SerialNumber
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_TerminalID') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_TerminalID
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_UserID') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_UserID
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Status') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Status
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Syncr') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Syncr
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_SyncrUser') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_SyncrUser
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_StockLines') AND type in (N'U'))
DROP TABLE u_Kapps_StockLines
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InquiryHeader') AND type in (N'U'))
DROP TABLE u_Kapps_InquiryHeader
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InquiryQuestions') AND type in (N'U'))
DROP TABLE u_Kapps_InquiryQuestions
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InquiryQuestionsAnswers') AND type in (N'U'))
DROP TABLE u_Kapps_InquiryQuestionsAnswers
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InquiryAnswersHeader') AND type in (N'U'))
DROP TABLE u_Kapps_InquiryAnswersHeader
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Messages') AND type in (N'U'))
DROP TABLE u_Kapps_Messages
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InquirySchedule') AND type in (N'U'))
DROP TABLE u_Kapps_InquirySchedule
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Serials') AND type in (N'U'))
DROP TABLE u_Kapps_Serials
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InquiryAnswersStamps') AND type in (N'U'))
DROP TABLE u_Kapps_InquiryAnswersStamps
GO

