--
-- Drop Tables
--
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Terminals') AND type in (N'U'))
DROP TABLE u_Kapps_Terminals
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Session_USers') AND type in (N'U'))
DROP TABLE u_Kapps_Session_Users
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Session_Docs') AND type in (N'U'))
DROP TABLE u_Kapps_Session_Docs
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_DossierLin') AND type in (N'U'))
DROP TABLE u_Kapps_DossierLin
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'kApps_Parameters') AND type in (N'U'))
DROP TABLE kApps_Parameters
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Log') AND type in (N'U'))
DROP TABLE u_Kapps_Log
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Transporters') AND type in (N'U'))
DROP TABLE u_Kapps_Transporters
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Printers') AND type in (N'U'))
DROP TABLE u_Kapps_Printers
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_PackingHeader') AND type in (N'U'))
DROP TABLE u_Kapps_PackingHeader
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_PackingDetails') AND type in (N'U'))
DROP TABLE u_Kapps_PackingDetails
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Events') AND type in (N'U'))
DROP TABLE u_Kapps_Events
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_LabelRules') AND type in (N'U'))
DROP TABLE u_Kapps_LabelRules
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Labels') AND type in (N'U'))
DROP TABLE u_Kapps_Labels
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_packagingTypes') AND type in (N'U'))
DROP TABLE u_Kapps_packagingTypes
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

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_UsersProcesses') AND type in (N'U'))
DROP TABLE u_Kapps_UsersProcesses
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_UsersWarehouses') AND type in (N'U'))
DROP TABLE u_Kapps_UsersWarehouses
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_TU1') AND type in (N'U'))
DROP TABLE u_Kapps_TU1
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_TU2') AND type in (N'U'))
DROP TABLE u_Kapps_TU2
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_TU3') AND type in (N'U'))
DROP TABLE u_Kapps_TU3
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_TU4') AND type in (N'U'))
DROP TABLE u_Kapps_TU4
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Parameters') AND type in (N'U'))
DROP TABLE u_Kapps_Parameters
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_ParametersTypes') AND type in (N'U'))
DROP TABLE u_Kapps_ParametersTypes
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Processes') AND type in (N'U'))
DROP TABLE u_Kapps_Processes
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_ParametersMonitors') AND type in (N'U'))
DROP TABLE u_Kapps_ParametersMonitors
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_StockDocs') AND type in (N'U'))
DROP TABLE u_Kapps_StockDocs
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_OrigStampHeader') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_OrigStampHeader
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_OrigStampLin') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_OrigStampLin
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Warehouse') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Warehouse
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Location') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Location
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Lot') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Lot
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Ref') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Ref
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Description') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Description
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Qty') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Qty
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_SerialNumber') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_SerialNumber
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_TerminalID') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_TerminalID
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_UserID') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_UserID
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Status') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Status
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Syncr') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Syncr
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_SyncrUser') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_SyncrUser
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

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_BO_Menu') AND type in (N'U'))
DROP TABLE u_Kapps_BO_Menu
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Keywords') AND type in (N'U'))
DROP TABLE u_Kapps_Keywords
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Translate') AND type in (N'U'))
DROP TABLE u_Kapps_Translate
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_UsersPermissions') AND type in (N'U'))
DROP TABLE u_Kapps_UsersPermissions
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_PackingStatus') AND type in (N'U'))
DROP TABLE u_Kapps_PackingStatus
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_LoadingDeliveryPoints') AND type in (N'U'))
DROP TABLE u_Kapps_LoadingDeliveryPoints
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_LoadingHeader') AND type in (N'U'))
DROP TABLE u_Kapps_LoadingHeader
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_LoadingLines') AND type in (N'U'))
DROP TABLE u_Kapps_LoadingLines
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_LoadingLocations') AND type in (N'U'))
DROP TABLE u_Kapps_LoadingLocations
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_LoadingPallets') AND type in (N'U'))
DROP TABLE u_Kapps_LoadingPallets
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Numerators') AND type in (N'U'))
DROP TABLE u_Kapps_Numerators
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_LoadingLog') AND type in (N'U'))
DROP TABLE u_Kapps_LoadingLog
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Queries') AND type in (N'U'))
DROP TABLE u_Kapps_Queries
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_ExpirationDates') AND type in (N'U'))
DROP TABLE u_Kapps_ExpirationDates
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_DocStatus') AND type in (N'U'))
DROP TABLE u_Kapps_DocStatus
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_ProductLabelingLines') AND type in (N'U'))
DROP TABLE u_Kapps_ProductLabelingLines
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_ProductLabelingRules') AND type in (N'U'))
DROP TABLE u_Kapps_ProductLabelingRules
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Scales') AND type in (N'U'))
DROP TABLE u_Kapps_Scales
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_QueriesDetails') AND type in (N'U'))
DROP TABLE u_Kapps_QueriesDetails
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InquiryAnswersDocGer') AND type in (N'U'))
DROP TABLE u_Kapps_InquiryAnswersDocGer
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_ParametersMonitorsPanel') AND type in (N'U'))
DROP TABLE u_Kapps_ParametersMonitorsPanel
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_Reasons') AND type in (N'U'))
DROP TABLE u_Kapps_Reasons
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_InquiryAnswersStampLin') AND type in (N'U'))
DROP TABLE u_Kapps_InquiryAnswersStampLin
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_LogSP') AND type in (N'U'))
DROP TABLE u_Kapps_LogSP
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_NumeratorsSet') AND type in (N'U'))
DROP TABLE u_Kapps_NumeratorsSet
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_tBOM_Header') AND type in (N'U'))
DROP TABLE u_Kapps_tBOM_Header
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_tBOM_Items') AND type in (N'U'))
DROP TABLE u_Kapps_tBOM_Items
GO