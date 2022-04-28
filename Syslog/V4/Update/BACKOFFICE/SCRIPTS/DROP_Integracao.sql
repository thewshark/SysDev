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
