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
