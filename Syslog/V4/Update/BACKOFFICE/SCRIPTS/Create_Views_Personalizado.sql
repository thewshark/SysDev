IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Customers] as 
SELECT 
'' as Name, 
'' as Code, 
'' as 'NameByLabel', 
'' as 'AdressByLabel', 
'' as NIF, 
CAST('0' as varchar(1)) as RuleForSSCC,	-- Regra a usar na criação de SSCC no packing 0-Um SSCC por caixa	1-Um SSCC por cada combinação de Artigo/Lote/Validade
'' as Adress,
'' as Adress1,
'' as PostalCode,
'' as Area,
'' as Country,
'' as Phone,
'' as Latitude,
'' as Longitude,
'' as OBS,
0 as InternalCustomer
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Suppliers]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Suppliers] as 
select 
'' as Name, 
'' as Code, 
'' as NIF, 
'' as Adress, 
'' as Adress1, 
'' as PostalCode, 
'' as Area, 
'' as Country, 
'' as Phone, 
'' as Latitude, 
'' as Longitude, 
'' as OBS
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Documents]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Documents]  
as
select  
'' as 'Description', 
'' as 'Code', 
0 as 'Orders', 
0 as 'Sales', 
1 as 'Purchase', 
0 as 'Internal', 
0 as 'Stock', 
0 as 'Transfer', 
'FL' as Entity, 
1 as 'ValidaStock', 
0 as 'StockBreak',
'' as DefaultEntity
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Warehouses]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Warehouses] as 
select 
'' as Description, 
'' as Code,
cast(1 as bit) as UseLocations,  -- (1-Sim) (0-Não)
'' as DefaultLocation
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Articles]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Articles] as 
select 
'' as 'Description', 
'' as 'Code', 
'' as 'Barcode',
'' as 'UseLots', 
0 as 'UseSerialNumber',
'' as 'BaseUnit', 
'' as 'Family', 
0 as 'MovStock',
'' as 'GTIN',
'' as DefaultWarehouse,
'' as DefaultLocation,
cast(1 as bit) as UseLocations,						-- (1-Sim) (0-Não)
'' as SellUnit,
'' as BuyUnit,
0 as LoteControlOut,						-- 0-Manual 1-FIFO, 2-FEFO, 3-LIFO
1 as UseExpirationDate,
CAST(0 as bit) as UseWeight,							-- (1-Sim) (0-Não)
0 as StoreInNrDays,
0 as StoreOutNrDays,
'' as 'Filter1', '' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5' 
GO


IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Barcodes]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Barcodes] as 
select 
'' as Code, 
'' as Barcode, 
'' as Unit,
0 as Quantity
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Stock] as 
select 
'' as Article, 
'' as Warehouse, 
'' as Stock, 
'' as Location, 
'' as Lote, 
0 as AvailableStock
GO


IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Lots]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Lots] as 
select 
'' as Lot, 
'' as Article, 
'' as Warehouse, 
'' as ExpirationDate, 
0 as Stock, 
'' as Location, 
'' as ProductionDate
GO


IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_SerialNumbers]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_SerialNumbers] as 
select 
'' as SerialNumber, 
'' as Article,
'' as Warehouse
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Families]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Families] as 
select 
'' as 'Description', 
'' as 'Code' 
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Documents]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Picking_Documents]
as 
select distinct 
'' as 'PickingKey',
'' as 'Number',
'' as 'CustomerName',
'' as 'Date',
'' as 'Customer',
'' as 'Document',
'' as 'DocumentName',
'' as 'UserCol1',
'' as 'UserCol2',
'' as 'UserCol3',
'' as 'UserCol4',
'' as 'UserCol5',
'' as 'UserCol6',
'' as 'UserCol7',
'' as 'UserCol8',
'' as 'UserCol9',
'' as 'UserCol10',
'' as 'EXR',
'' as 'SEC',
'' as 'TPD',
'' as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as DeliveryCustomer,
'' as DeliveryCode,
'' as Barcode
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Lines]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Picking_Lines] as
Select distinct 
'' as 'PickingLineKey',
'' as 'Article',
'' as 'Description',
0 as 'Quantity',
0 as 'QuantitySatisfied',
0 as 'QuantityPending',
0 as 'QuantityPicked', 
'' as 'BaseUnit',
'' as 'BusyUnit',
1 as 'ConversionFator',
'' as 'Warehouse',
'' as 'PickingKey',
0 as 'OriginalLineNumber',
'' as UserCol1,
'' as UserCol2,
'' as UserCol3,
'' as UserCol4,
'' as UserCol5,
'' as UserCol6,
'' as UserCol7,
'' as UserCol8,
'' as UserCol9,
'' as UserCol10,
'' as 'EXR',
'' as 'SEC',
'' as 'TPD',
'' as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5', 
'' as Location, 
'' as Lot,
'' as PalletType, 
0 as PalletMaxUnits
GO


IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Documents]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Packing_Documents]
as 
select distinct 
'' as 'PackingKey',
'' as 'Number',
'' as 'CustomerName',
'' as 'Date',
'' as 'Customer',
'' as 'Document',
'' as 'DocumentName',
'' as 'UserCol1',
'' as 'UserCol2',
'' as 'UserCol3',
'' as 'UserCol4',
'' as 'UserCol5',
'' as 'UserCol6',
'' as 'UserCol7',
'' as 'UserCol8',
'' as 'UserCol9',
'' as 'UserCol10',
'' as 'EXR',
'' as 'SEC',
'' as 'TPD',
'' as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as 'PurchaseOrder', 
'' as 'MySupplierNumber',
'' as DeliveryCustomer, 
'' as DeliveryCode,
'' as Barcode
GO

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Lines]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Packing_Lines] as
Select
'' as 'PackingLineKey',
'' as 'Article',
'' as 'Description',
0 as 'Quantity',
0 as 'QuantitySatisfied',
0 as 'QuantityPending',
0 as 'QuantityPicked', 
'' as 'BaseUnit',
'' as 'BusyUnit',
1 as 'ConversionFator',
'' as 'Warehouse',
'' as 'PackingKey',
0 as 'OriginalLineNumber',
'' as UserCol1,
'' as UserCol2,
'' as UserCol3,
'' as UserCol4,
'' as UserCol5,
'' as UserCol6,
'' as UserCol7,
'' as UserCol8,
'' as UserCol9,
'' as UserCol10,
'' as 'EXR',
'' as 'SEC',
'' as 'TPD',
'' as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as Location,
'' as Lot
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Documents]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Reception_Documents]
as 
select distinct
'' as 'ReceptionKey',
'' as 'Number',
'' as 'SupplierName',
'' as 'Date',
'' as 'Supplier',
'' as 'Document',
'' as 'DocumentName',
'' as 'UserCol1',
'' as 'UserCol2',
'' as 'UserCol3',
'' as 'UserCol4',
'' as 'UserCol5',
'' as 'UserCol6',
'' as 'UserCol7',
'' as 'UserCol8',
'' as 'UserCol9',
'' as 'UserCol10',
'' as 'EXR',
'' as 'SEC',
'' as 'TPD',
'' as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as ExternalDoc,
'' as Barcode
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Lines]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Reception_Lines] as
Select
'' as 'ReceptionLineKey',
'' as 'Article',
'' as 'Description',
0 as 'Quantity',
0 as 'QuantitySatisfied',
0 as 'QuantityPending',
0 as 'QuantityPicked', 
'' as 'BaseUnit',
'' as 'BusyUnit',
1 as 'ConversionFator',
'' as 'Warehouse',
'' as 'ReceptionKey',
0 as 'OriginalLineNumber',
'' as UserCol1,
'' as UserCol2,
'' as UserCol3,
'' as UserCol4,
'' as UserCol5,
'' as UserCol6,
'' as UserCol7,
'' as UserCol8,
'' as UserCol9,
'' as UserCol10,
'' as 'EXR',
'' as 'SEC',
'' as 'TPD',
'' as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as Location,
'' as Lot
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Units]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Units] as 
SELECT 
'' as 'Code', 
'' as 'Unit', 
1 as 'Factor' 
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_WarehousesLocations]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_WarehousesLocations] as 
select 
'' as Warehouse,
'' as ZoneLocation,
'' as Location,
'' as Description,
'' as LocActiva,
cast(1 as bit) as Checkdigit,
cast(0 as int) as LocationType						-- 1(Localizações do tipo Receção), 2(Localizações do tipo expedição)
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Documents]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Stock_Documents]
as 
select distinct 
'' as 'CabKey',		-- Chave unica
'' as 'Date',		-- Data e Hora de criação
'' as 'Warehouse',
'' as 'DocumentName',	-- Descrição da contagem
'' as 'UserCol1',
'' as 'UserCol2',
'' as 'UserCol3',
'' as 'UserCol4',
'' as 'UserCol5',
'' as 'UserCol6',
'' as 'UserCol7',
'' as 'UserCol8',
'' as 'UserCol9',
'' as 'UserCol10',
'' as 'EXR',			-- Exercicio
'' as 'SEC',			-- Serie/Secção
'' as 'TPD',			-- Tipo Documento
'' as 'NDC',			-- Numero de Documento
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as DocType,				-- 'C' Cega
'' as ZoneLocation,
'' as Location,
'' as InternalStampDoc
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Lines]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Stock_Lines] as
Select 
'' as 'LineKey', -- Chave Unica
0 as 'OrigLineNumber',
'' as 'Article',
'' as 'Description',
0 as 'Quantity',
0 as 'QuantityPicked', 
'' as 'BaseUnit',
'' as 'Warehouse',
'' as Location,
'' as Lot,
'' as 'CabKey',
'' as 'UserCol1',
'' as 'UserCol2',
'' as 'UserCol3',
'' as 'UserCol4',
'' as 'UserCol5',
'' as 'UserCol6',
'' as 'UserCol7',
'' as 'UserCol8',
'' as 'UserCol9',
'' as 'UserCol10',
'' as 'EXR',			-- Exercicio
'' as 'SEC',			-- Serie/Secção
'' as 'TPD',			-- TipoDocumento
'' as 'NDC',			-- Numero Documento
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers_DeliveryLocations]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Customers_DeliveryLocations] as 
select 
'' as DeliveryCode,
'' as ClientCode,
'' as Name,
'' as Address1,
'' as Address2,
'' as City,
'' as PostalCode,
'' as PostalCodeAddress,
'' as AreaCode,
'' as Country,
'' as CountryName
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_RestrictedUsersZones]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_RestrictedUsersZones] as 
select 
'' as UserName,
'' as ZoneLocation
GO


IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_StockBreakReasons]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_StockBreakReasons] as 
select '' as Reason
GO


IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_RestrictedArticles]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_RestrictedArticles] as 
select 
'' as RuleType,											--(R - Restringe / A - Autoriza)
'' as Warehouse,
'' as ZoneLocation,
'' as Location,
'' as Family,
'' as Article
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Entities]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_Entities] as 
select '' as Name
, '' as Code
, '' as NIF
, '' as EntityType
,'' as Adress
,'' as Adress1
,'' as PostalCode
,'' as Area
,'' as Country
,'' as Phone
,'' as Latitude
,'' as Longitude
,'' as OBS
GO


IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_SSCC_Lines]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_SSCC_Lines] as 
select 
'' as HeaderSSCC, 
'' as DetailSSCC, 
'' as PackId, 
'' as Article, 
0 as Quantity, 
'' as Unit, 
'' as Lot, 
'' as ExpirationDate, 
'' as SerialNumber,
0 as NetWeight,
'' as LinUserField1,
'' as LinUserField2,
'' as LinUserField3,
'' as LinUserField4,
'' as LinUserField5,
'' as LinUserField6,
'' as LinUserField7,
'' as LinUserField8,
'' as LinUserField9,
'' as LinUserField10,
'' as Location,
'' as CurrentWarehouse,
'' as CurrentLocation,
0 as PackStatus
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Documents]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_PickTransf_Documents]
as 
select 
'' as 'PickingKey',
'' as 'Number',
'' as 'CustomerName',
'' as 'Date',
'' as 'Customer',
'' as 'Document',
'' as 'DocumentName',
'' as 'UserCol1',
'' as 'UserCol2',
'' as 'UserCol3',
'' as 'UserCol4',
'' as 'UserCol5',
'' as 'UserCol6',
'' as 'UserCol7',
'' as 'UserCol8',
'' as 'UserCol9',
'' as 'UserCol10',
'' as 'EXR',
'' as 'SEC',
'' as 'TPD',
'' as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as DeliveryCustomer, 
'' as DeliveryCode, 
'' as OriginWarehouse, 
'' as TransitWarehouse, 
'' as DestinationWarehouse,
'' as Barcode
GO
SET NOEXEC OFF
GO



IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Lines]'))
BEGIN
	SET NOEXEC ON
END
GO
CREATE view [dbo].[v_Kapps_PickTransf_Lines] as
Select 
'' as 'PickingLineKey',
'' as 'Article',
'' as 'Description',
0 as 'Quantity',
0 as 'QuantitySatisfied',
0 as 'QuantityPending',
0 as 'QuantityPicked', 
'' as 'BaseUnit',
'' as 'BusyUnit',
1 as 'ConversionFator',
'' as 'Warehouse',
'' as 'PickingKey',
0 as 'OriginalLineNumber',
'' as UserCol1,
'' as UserCol2,
'' as UserCol3,
'' as UserCol4,
'' as UserCol5,
'' as UserCol6,
'' as UserCol7,
'' as UserCol8,
'' as UserCol9,
'' as UserCol10,
'' as 'EXR',
'' as 'SEC',
'' as 'TPD',
'' as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as Location, 
'' Lot, 
'' as PalletType, 
0 as PalletMaxUnits
GO
SET NOEXEC OFF
GO


