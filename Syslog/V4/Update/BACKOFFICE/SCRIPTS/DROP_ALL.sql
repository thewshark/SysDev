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

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_OrigStampHeader') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_OrigStampHeader
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_OrigStampLin') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_OrigStampLin
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Warehouse') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Warehouse
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Location') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Location
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Lot') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Lot
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Ref') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Ref
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Description') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Description
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Qty') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Qty
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_SerialNumber') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_SerialNumber
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_TerminalID') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_TerminalID
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_UserID') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_UserID
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Status') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Status
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_Syncr') AND type = 'D')
ALTER TABLE u_Kapps_StockLines DROP CONSTRAINT DF_u_Kapps_StockLines_Syncr
GO

IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'DF_u_Kapps_StockLines_SyncrUser') AND type = 'D')
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

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_PickTransf_Documents'))
DROP view v_Kapps_PickTransf_Documents
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_PickTransf_Lines'))
DROP view v_Kapps_PickTransf_Lines
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_PalletTransf_Documents'))
DROP view v_Kapps_PalletTransf_Documents
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_PalletTransf_Lines'))
DROP view v_Kapps_PalletTransf_Lines
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_Stock_Status'))
DROP view v_Kapps_Stock_Status
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_ProductsStruture'))
DROP view v_Kapps_ProductsStruture
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_BOM_Header'))
DROP view v_Kapps_BOM_Header
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'v_Kapps_BOM_Items'))
DROP view v_Kapps_BOM_Items
GO

--
-- Drop Scripts Integração
--
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_DateToString') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_DateToString 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_TimeToString') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_TimeToString 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_EurToEsc') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_EurToEsc 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Login') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Login
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductPriceUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductPriceUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Products') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Products
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductsUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductsUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_BarCode') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_BarCode
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductStockUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductStockUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DossiersUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersLinUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DossiersLinUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DocDossInternIVAs') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DocDossInternIVAs
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Dossiers') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Dossiers
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasInventarioUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasInventarioUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_InventarioUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_InventarioUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasInventario') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasInventario
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Inventario') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Inventario
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_PriceCheckingUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_PriceCheckingUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductPriceUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductPriceUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductsUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductsUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DossiersUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DossiersUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'UpdateLineNUmber'))
DROP TRIGGER UpdateLineNUmber
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'u_Kapps_DossierLin') AND name = N'IX_u_Kapps_DossierLin_QtdFilter')
DROP INDEX IX_u_Kapps_DossierLin_QtdFilter ON u_Kapps_DossierLin WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ProductStockUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ProductStockUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_PriceCheckingUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_PriceCheckingUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SPMSS_Reconstroi_APPSP_USR') AND type in (N'P', N'PC'))
DROP PROCEDURE SPMSS_Reconstroi_APPSP_USR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_EliminaTabelaTemporaria') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_EliminaTabelaTemporaria
GO
		
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_RefreshUsers') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_RefreshUsers
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Temp') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Temp
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Contagem') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Contagem
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_ContagemUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_ContagemUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasContagem') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasContagem
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LinhasContagemUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LinhasContagemUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_UpdateBackoffice') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_UpdateBackoffice
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_CriaTabelaTemporaria') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_CriaTabelaTemporaria
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'u_Kapps_SSCCCheckDigit') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION u_Kapps_SSCCCheckDigit
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_DocumentUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_DocumentUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_LoadingInsertSSCC') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_LoadingInsertSSCC
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_SSCC_NextNumberUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_SSCC_NextNumberUSR
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_UpdateStatus') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_UpdateStatus
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_CheckUserPermission') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_CheckUserPermission
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_UpdateLine') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_UpdateLine
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_InsertLot') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_InsertLot
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Dossiers_ParametersUCabULin') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Dossiers_ParametersUCabULin
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_UpdatePalletLocation') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_UpdatePalletLocation
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_tBOM_New') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_tBOM_New
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Products_AddToDossierLin') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Products_AddToDossierLin
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_BOM_CheckQuantity') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_BOM_CheckQuantity
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_SerialNumber_Insert') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_SerialNumber_Insert
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_Location_InsertLogModify') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_Location_InsertLogModify
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_GetRestrictions') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_GetRestrictions
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_u_Kapps_CalculateUserFieldsUSR') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_u_Kapps_CalculateUserFieldsUSR
GO