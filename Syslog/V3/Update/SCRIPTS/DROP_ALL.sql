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

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_OrigStampHeader') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_OrigStampHeader
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_OrigStampLin') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_OrigStampLin
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Warehouse') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Warehouse
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Location') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Location
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Lot') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Lot
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Ref') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Ref
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Description') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Description
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Qty') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Qty
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_SerialNumber') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_SerialNumber
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_TerminalID') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_TerminalID
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_UserID') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_UserID
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Status') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Status
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Syncr') AND type = 'D')
BEGIN
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Syncr
END
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_SyncrUser') AND type = 'D')
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


--
-- Drop Views
--
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Customers'))
DROP view v_Kapps_Customers
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Suppliers'))
DROP view v_Kapps_Suppliers
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Documents'))
DROP view v_Kapps_Documents
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Warehouses'))
DROP view v_Kapps_Warehouses
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Articles'))
DROP view v_Kapps_Articles
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Barcodes'))
DROP view v_Kapps_Barcodes
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Stock'))
DROP view v_Kapps_Stock
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Lots'))
DROP view v_Kapps_Lots
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_SerialNumbers'))
DROP view v_Kapps_SerialNumbers
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Families'))
DROP view v_Kapps_Families
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Picking_Documents'))
DROP view v_Kapps_Picking_Documents
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Picking_Lines'))
DROP view v_Kapps_Picking_Lines
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Packing_Documents'))
DROP view v_Kapps_Packing_Documents
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Packing_Lines'))
DROP view v_Kapps_Packing_Lines
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Reception_Documents'))
DROP view v_Kapps_Reception_Documents
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Reception_Lines'))
DROP view v_Kapps_Reception_Lines
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Units'))
DROP view v_Kapps_Units
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_WarehousesLocations'))
DROP view v_Kapps_WarehousesLocations
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Stock_Documents'))
DROP view v_Kapps_Stock_Documents
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Stock_Lines'))
DROP view v_Kapps_Stock_Lines
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Customers_DeliveryLocations'))
DROP view v_Kapps_Customers_DeliveryLocations
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_RestrictedUsersZones'))
DROP view v_Kapps_RestrictedUsersZones
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_StockBreakReasons'))
DROP view v_Kapps_StockBreakReasons
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_RestrictedArticles'))
DROP view v_Kapps_RestrictedArticles
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Entities'))
DROP view v_Kapps_Entities
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_SSCC_Lines'))
DROP view v_Kapps_SSCC_Lines
GO


--
-- Drop Scripts Integração
--
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_DateToString') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_DateToString 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_TimeToString') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_TimeToString 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_EurToEsc') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_EurToEsc 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Login') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Login

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductPriceUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductPriceUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Products') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Products

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductsUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductsUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_BarCode') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_BarCode

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductStockUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductStockUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DossiersUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersLinUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DossiersLinUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DocDossInternIVAs') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DocDossInternIVAs

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Dossiers') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Dossiers

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasInventarioUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasInventarioUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_InventarioUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_InventarioUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasInventario') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasInventario

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Inventario') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Inventario

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_PriceCheckingUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_PriceCheckingUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductPriceUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductPriceUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductsUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductsUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DossiersUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'UpdateLineNUmber'))
DROP TRIGGER UpdateLineNUmber

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'u_Kapps_DossierLin') AND name = N'IX_u_Kapps_DossierLin_QtdFilter')
DROP INDEX IX_u_Kapps_DossierLin_QtdFilter ON u_Kapps_DossierLin WITH ( ONLINE = OFF )

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductStockUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductStockUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_PriceCheckingUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_PriceCheckingUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_EliminaTabelaTemporaria') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_EliminaTabelaTemporaria
		
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_RefreshUsers') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_RefreshUsers

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Temp') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Temp

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Contagem') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Contagem

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ContagemUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ContagemUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasContagem') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasContagem

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasContagemUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasContagemUSR

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_UpdateBackoffice') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_UpdateBackoffice

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_CriaTabelaTemporaria') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_CriaTabelaTemporaria

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_SSCCCheckDigit') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_SSCCCheckDigit
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DocumentUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DocumentUSR
GO
