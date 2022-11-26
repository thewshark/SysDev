IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers]'))
DROP view [dbo].[v_Kapps_Customers]
GO
CREATE view [dbo].[v_Kapps_Customers] as 
select cli.OrganizationName as NAME, cli.CustomerID as Code
, '' AS 'NameByLabel', '' AS 'AdressByLabel'
, cli.FederalTaxID AS NIF
, CAST('0' as varchar(1)) as RuleForSSCC	-- Regra a usar na criação de SSCC no packing 0-Um SSCC por caixa	1-Um SSCC por cada combinação de Artigo/Lote/Validade
, AddressLine1 As Adress
, AddressLine2 As Adress1
, [PartyAddress].PostalCode As PostalCode
, LocalityName As Area
, CountryName As Country
, Telephone1 As Phone
, CAST(0 as numeric(10,6)) as Latitude
, CAST(0 as numeric(10,6)) as Longitude
, Comments as OBS
, 0 AS InternalCustomer						-- 0 Externo, 1 Interno
, cli.OrganizationName As ShortName
FROM Customer cli (NOLOCK)
left join PartyAddress (NOLOCK) on cli.PartyID = PartyAddress.PartyID left join CountryCodes on PartyAddress.CountryID = CountryCodes.CountryID
left join LocalityCodes (NOLOCK) on LocalityCodes.CountryID = PartyAddress.CountryID AND LocalityCodes.ProvinceID = PartyAddress.ProvinceID AND LocalityCodes.LocalityID = PartyAddress.LocalityID
where cli.ActiveParty = 1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Suppliers]'))
DROP view [dbo].[v_Kapps_Suppliers]
GO
CREATE view [dbo].[v_Kapps_Suppliers] as 
select forn.OrganizationName as NAME, forn.SupplierID as Code 
, forn.FederalTaxID AS NIF
, AddressLine1 As Adress
, AddressLine2 As Adress1
, [PartyAddress].PostalCode As PostalCode
, LocalityName As Area
, CountryName As Country
, Telephone1 As Phone
, CAST(0 as numeric(10,6)) as Latitude
, CAST(0 as numeric(10,6)) as Longitude
, Comments as OBS
FROM Supplier forn (NOLOCK)
left join PartyAddress (NOLOCK) on forn.PartyID = PartyAddress.PartyID left join CountryCodes on PartyAddress.CountryID = CountryCodes.CountryID
left join LocalityCodes (NOLOCK) on LocalityCodes.CountryID = PartyAddress.CountryID AND LocalityCodes.ProvinceID = PartyAddress.ProvinceID AND LocalityCodes.LocalityID = PartyAddress.LocalityID
where forn.ActiveParty = 1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Documents]'))
DROP view [dbo].[v_Kapps_Documents]
GO
CREATE view [dbo].[v_Kapps_Documents]  
as
select Description as 'Description', documents.TransDocumentID as Code,0 as orders, 1 as sales, 0 as purchase, 0 as internal, 0 as stock, 0 as transfer, 'CL' as Entity, 1 as 'ValidaStock',0 as 'StockBreak', '' as DefaultEntity  from documents (nolock) join documentsname (nolock) on documents.TransDocumentID=DocumentsName.TransDocumentID  where transdoctype=1 and transactionNatureID not in (1060,1100) and inactive=0 and DocumentsName.LanguageID='PTG'
union all
select Description as 'Description', documents.TransDocumentID as Code,1 as orders,0 as sales,0 as purchase,0 as internal,0 as stock,0 as transfer, case when transactionNatureID=1060 then 'CL' else 'FL' end as Entity, 1 as 'ValidaStock',0 as 'StockBreak','' as DefaultEntity from documents (nolock) join documentsname (nolock) on documents.TransDocumentID=DocumentsName.TransDocumentID where /*transdoctype=1 and*/ transactionNatureID = 1060 and inactive=0 and DocumentsName.LanguageID='PTG'
union all
select Description as 'Description', documents.TransDocumentID as Code, 0 as orders, 0 as sales, 1 as purchase,0 as internal, 0 as stock, 0 as transfer, 'FL' as Entity, 1 as 'ValidaStock',0 as 'StockBreak', '' as DefaultEntity from documents (nolock) join documentsname (nolock) on documents.TransDocumentID=DocumentsName.TransDocumentID where transdoctype=0 and transactionNatureID <> 2100 and inactive=0  and DocumentsName.LanguageID='PTG'
union all
select Description as 'Description', documents.TransDocumentID as Code, 0 as orders, 0 as sales, 0 as purchase, 0 as internal, 1 as stock, 0 as transfer, '' as Entity, 1 as 'ValidaStock',0 as 'StockBreak', '' as DefaultEntity from documents (nolock) join documentsname (nolock) on documents.TransDocumentID=DocumentsName.TransDocumentID where transdoctype=2 and transactionNatureID<>3004 and inactive=0 and DocumentsName.LanguageID='PTG'
union all
select Description as 'Description', documents.TransDocumentID as Code, 0 as orders, 0 as sales, 0 as purchase, 0 as internal, 0 as stock, 1 as transfer, '' as Entity, 1 as 'ValidaStock',0 as 'StockBreak', '' as DefaultEntity  from documents (nolock) join documentsname (nolock) on documents.TransDocumentID=DocumentsName.TransDocumentID where transdoctype=2 and transactionNatureID=3004 and inactive=0 and DocumentsName.LanguageID='PTG'
union all
select Description as 'Description', documents.TransDocumentID as Code,1 as orders,0 as sales,0 as purchase,0 as internal,0 as stock,0 as transfer, case when transactionNatureID=1100 then 'CL' else 'FL' end as Entity, 1 as 'ValidaStock',0 as 'StockBreak', '' as DefaultEntity from documents (nolock) join documentsname (nolock) on documents.TransDocumentID=DocumentsName.TransDocumentID where transactionNatureID = 1100 and inactive=0 and DocumentsName.LanguageID='PTG'
union all
select Description as 'Description', documents.TransDocumentID as Code,0 as orders,0 as sales,1 as purchase,0 as internal,0 as stock,0 as transfer, case when transactionNatureID=1100 then 'CL' else 'FL' end as Entity, 1 as 'ValidaStock',0 as 'StockBreak', '' as DefaultEntity from documents (nolock) join documentsname (nolock) on documents.TransDocumentID=DocumentsName.TransDocumentID where transactionNatureID= 2100 and inactive=0 and DocumentsName.LanguageID='PTG'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Warehouses]'))
DROP view [dbo].[v_Kapps_Warehouses]
GO
CREATE view [dbo].[v_Kapps_Warehouses] as 
select arm.Description as Description, arm.WarehouseID as Code
, cast(0 as bit) AS UseLocations						-- (1-Sim) (0-Não)
, '' AS DefaultLocation
from Warehouse arm (NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Articles]'))
DROP view [dbo].[v_Kapps_Articles]
GO
CREATE view [dbo].[v_Kapps_Articles] as 
select LEFT(ItemNames.Description,100) as 'Description', 
Item.ItemID as 'Code', 
Item.BarCode as 'Barcode', 
case when (LEN(item.PropertyID1)>0 and item.PropertyMaximumQuantity=0) then 1 else 0 end as 'UseLots',
case when (LEN(item.PropertyID2)>0 and item.PropertyMaximumQuantity=0) then 1 else 0 end as 'UseSerialNumber',
Item.UnitOfSaleID as 'BaseUnit',
item.FamilyID as 'Family',
case when Item.StockManagement = 1 then 1 else 0 end AS 'MovStock', '' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5', '' AS 'GTIN'
, '' AS DefaultWarehouse
, '' AS DefaultLocation
, cast(0 as bit) AS UseLocations						-- (1-Sim) (0-Não)
, item.DefaultSellingUnit AS SellUnit
, item.DefaultBuyUnit AS BuyUnit
, 0 as LoteControlOut									-- 0-Manual 1-FIFO, 2-FEFO, 3-LIFO
, 0 as UseExpirationDate
, CAST(0 as bit) as UseWeight							-- (1-Sim) (0-Não)
, 0 AS StoreInNrDays									-- Nº de dias minimo de validade na receção (excepto se existir regra a contrariar em [Validades mínimas])
, 0 AS StoreOutNrDays									-- Nº de dias minimo de validade na expedição (excepto se existir regra a contrariar em [Validades mínimas])
, CAST(0 as int) AS BoxMaxQuantity
from Item (nolock) join ItemNames (nolock) on Item.ItemID=ItemNames.ItemID where ItemNames.LanguageID='PTG' and Discontinued=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Barcodes]'))
DROP view [dbo].[v_Kapps_Barcodes]
GO
CREATE view [dbo].[v_Kapps_Barcodes] as 
select 
art.itemid as code,
cb.positemid as barcode, 
cb.UnitOfMeasure as Unit, 
case when cb.UnitOfMeasure<>art.UnitOfSaleID then art.UnitConversion else 1 end as Quantity
from POSIdentity cb (nolock) join Item art (nolock) on art.ItemID=cb.ItemID 
where art.Discontinued=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock]'))
DROP view [dbo].[v_Kapps_Stock]
GO
CREATE view [dbo].[v_Kapps_Stock] as 
select Item.ItemID as Article, st.WarehouseID as Warehouse, CASE WHEN ISNULL(sp.PropertyValue1,'')='' THEN st.PhysicalQty ELSE sp.PhysicalQty END as Stock, '' as Location
,ISNULL(sp.PropertyValue1,'') as Lote, CASE WHEN ISNULL(sp.PropertyValue1,'')='' THEN st.AvailableQty ELSE sp.PhysicalQty END as AvailableStock
from Stock st WITH(NOLOCK) 
join Item WITH(NOLOCK) on Item.ItemID=st.ItemID 
left join StockProperty sp WITH(NOLOCK) on sp.ItemID=st.ItemID and st.WarehouseID=sp.WarehouseID
where Item.Discontinued=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Lots]'))
DROP view [dbo].[v_Kapps_Lots]
GO
CREATE view [dbo].[v_Kapps_Lots] as 
select 
sp.PropertyValue1 as Lot
, sp.itemid as Article
, ISNULL(sp.ExpirationDate, CAST('29991231' as  datetime)) as ExpirationDate
, sp.ProductionDate AS ProductionDate
, CAST(1 as bit) as Actif
from StockProperty sp (nolock)
join item (nolock) on sp.ItemID=Item.ItemID
where sp.FirstTransDocNumber<>0
and sp.PropertyValue1<>''
and sp.PropertyValue2=''
and Item.Discontinued=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_SerialNumbers]'))
DROP view [dbo].[v_Kapps_SerialNumbers]
GO
CREATE view [dbo].[v_Kapps_SerialNumbers] as 
SELECT
sp.PropertyValue1 As SerialNumber,	-- Alterar para PropertyValue2, PropertyValue3 conforme a configuração do numero de série
sp.itemid as Article,
sp.warehouseid as Warehouse
FROM StockProperty sp (nolock) join item (nolock) on sp.ItemID=Item.ItemID
WHERE sp.FirstTransDocNumber<>0
and sp.PropertyValue1<>''			-- Alterar para PropertyValue2, PropertyValue3 conforme a configuração do numero de série
and Item.Discontinued=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Families]'))
DROP view [dbo].[v_Kapps_Families]
GO
CREATE view [dbo].[v_Kapps_Families] as 
select Description as 'Description', FamilyID as 'Code' from Family (nolock)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Documents]'))
DROP view [dbo].[v_Kapps_Picking_Documents]
GO
CREATE view [dbo].[v_Kapps_Picking_Documents]
as 
select distinct 
cab.TransSerial+'*'+ cab.TransDocument+'*'+cast(YEAR(cab.CreateDate)as varchar(4))+'*'+CAST(cab.TransDocNumber as varchar(12)) as 'PickingKey', 
cab.TransDocNumber as Number,
c.OrganizationName as CustomerName,
cab.CreateDate as 'Date',
cab.PartyID as Customer,
cab.TransDocument as Document,
d.Description as DocumentName,
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
YEAR(cab.CreateDate) as EXR,
cab.TransSerial as SEC,
cab.TransDocument as TPD,
cab.TransDocNumber as NDC,
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.PartyID as DeliveryCustomer
,UnloadPlaceID as DeliveryCode
,'' as Barcode
from SaleTransaction (nolock) cab join Customer (nolock) c on cab.PartyID=c.PartyID 
join DocumentsName (nolock) d on cab.TransDocument=d.TransDocumentID
left join u_Kapps_DossierLin (NOLOCK) on (u_Kapps_DossierLin.StampBo = (cab.TransSerial+'*'+ cab.TransDocument+'*'+cast(YEAR(cab.CreateDate)as varchar(4))+'*'+CAST(cab.TransDocNumber as varchar(12)))) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'
where cab.TransStatus=0
and cab.TransactionConverted=0
and d.LanguageID='PTG'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Lines]'))
DROP view [dbo].[v_Kapps_Picking_Lines]
GO
CREATE view [dbo].[v_Kapps_Picking_Lines] as
select 
(CAST(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) as 'PickingLineKey',
lin.itemid as 'Article',
LEFT(n.Description,100) as 'Description',
(lin.Quantity) as 'Quantity',
(lin.DestinationQuantity) as 'QuantitySatisfied',
((lin.Quantity) - (lin.DestinationQuantity)) -
	   (
	   select isnull(sum(u_Kapps_DossierLin.Qty2),0) 
       from u_Kapps_DossierLin (NOLOCK) 
       where u_Kapps_DossierLin.Status = 'A' 
       and u_Kapps_DossierLin.Integrada = 'N'      
       and ((cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10))) = u_Kapps_DossierLin.Stampbo)
       and ((cast(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) = u_Kapps_DossierLin.Stampbi)
       ) as 'QuantityPending',
	   (select isnull(sum(u_Kapps_DossierLin.Qty2),0)
       from u_Kapps_DossierLin (NOLOCK) 
       where u_Kapps_DossierLin.Status = 'A' 
       and u_Kapps_DossierLin.Integrada = 'N' 
       and ((cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10))) = u_Kapps_DossierLin.StampBo)
       and ((cast(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) = u_Kapps_DossierLin.Stampbi)
       ) as 'QuantityPicked',
art.UnitOfSaleID as 'BaseUnit',
lin.UnitOfSaleID as 'BusyUnit',
lin.PackQuantity as 'ConversionFator',
lin.WarehouseID as 'Warehouse',
cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(Year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10)) as 'PickingKey',
lin.LineItemID as 'OriginalLineNumber',
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
YEAR(lin.CreateDate) as EXR,
lin.TransSerial as SEC,
lin.TransDocument as TPD,
lin.TransDocNumber as NDC
, '' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' AS Location
, ISNULL((SELECT PropertyValue1 FROM TransactionPropDetails det WITH(NOLOCK) WHERE det.TransSerial=lin.TransSerial and det.TransDocument= lin.TransDocument and det.TransDocNumber=lin.TransDocNumber and det.LineItemID=lin.LineItemID and det.LineItemSubID=lin.LineItemSubID),'') AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
from saletransactiondetails lin WITH(nolock) join Item art WITH(nolock) on lin.ItemID=art.ItemID
join ItemNames n with(nolock) on art.ItemID=n.ItemID
--join SaleTransaction (nolock) cab on lin.TransDocument=cab.TransDocument and lin.TransSerial=cab.TransSerial and lin.TransDocNumber=cab.TransDocNumber
where n.LanguageID='PTG'
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Documents]'))
DROP view [dbo].[v_Kapps_Packing_Documents]
GO
CREATE view [dbo].[v_Kapps_Packing_Documents]
as 
select distinct cab.TransSerial+'*'+ cab.TransDocument+'*'+cast(YEAR(cab.CreateDate)as varchar(4))+'*'+CAST(cab.TransDocNumber as varchar(12)) as 'PackingKey', 
cab.TransDocNumber as Number,
c.OrganizationName as CustomerName,
cab.CreateDate as 'Date',
cab.PartyID as Customer,
cab.TransDocument as Document,
d.Description as DocumentName,
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
YEAR(cab.CreateDate) as EXR,
cab.TransSerial as SEC,
cab.TransDocument as TPD,
cab.TransDocNumber as NDC,
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5','' AS 'PurchaseOrder', '' AS 'MySupplierNumber'
,cab.PartyID as DeliveryCustomer
,UnloadPlaceID as DeliveryCode
,'' as Barcode
from SaleTransaction (nolock) cab join Customer (nolock) c on cab.PartyID=c.PartyID 
join DocumentsName (nolock) d on cab.TransDocument=d.TransDocumentID
left join u_Kapps_DossierLin (NOLOCK) on (u_Kapps_DossierLin.StampBo = (cab.TransSerial+'*'+ cab.TransDocument+'*'+cast(YEAR(cab.CreateDate)as varchar(4))+'*'+CAST(cab.TransDocNumber as varchar(12)))) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'
where cab.TransStatus=0
and cab.TransactionConverted=0
and d.LanguageID='PTG'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Lines]'))
DROP view [dbo].[v_Kapps_Packing_Lines]
GO
CREATE view [dbo].[V_Kapps_Packing_Lines] as
select 
(CAST(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) as 'PackingLineKey',
lin.itemid as 'Article',
LEFT(n.Description,100) as 'Description',
(lin.Quantity) as 'Quantity',
(lin.DestinationQuantity) as 'QuantitySatisfied',
((lin.Quantity) - (lin.DestinationQuantity)) -
		(
		select isnull(sum(u_Kapps_DossierLin.Qty2),0) 
		from u_Kapps_DossierLin (NOLOCK) 
		where u_Kapps_DossierLin.Status = 'A' 
		and u_Kapps_DossierLin.Integrada = 'N' 
		and ((cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10))) = u_Kapps_DossierLin.Stampbo)
		and ((cast(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) = u_Kapps_DossierLin.Stampbi)
		) as 'QuantityPending',

		(select isnull(sum(u_Kapps_DossierLin.Qty2),0)
		from u_Kapps_DossierLin (NOLOCK) 
		where u_Kapps_DossierLin.Status = 'A' 
		and u_Kapps_DossierLin.Integrada = 'N' 
		and ((cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10))) = u_Kapps_DossierLin.Stampbo)
		and ((cast(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) = u_Kapps_DossierLin.Stampbi)
		) as 'QuantityPicked',
art.UnitOfSaleID as 'BaseUnit',
lin.UnitOfSaleID as 'BusyUnit',
lin.PackQuantity as 'ConversionFator',
lin.WarehouseID as 'Warehouse',
cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(Year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10)) as 'PackingKey',
lin.LineItemID as 'OriginalLineNumber',
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
YEAR(lin.CreateDate) as EXR,
lin.TransSerial as SEC,
lin.TransDocument as TPD,
lin.TransDocNumber as NDC
, '' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' AS Location
, ISNULL((SELECT PropertyValue1 FROM TransactionPropDetails det WITH(NOLOCK) WHERE det.TransSerial=lin.TransSerial and det.TransDocument= lin.TransDocument and det.TransDocNumber=lin.TransDocNumber and det.LineItemID=lin.LineItemID and det.LineItemSubID=lin.LineItemSubID),'') AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
from saletransactiondetails (nolock) lin join Item (nolock) art on lin.ItemID=art.ItemID
join ItemNames (nolock) n on art.ItemID=n.ItemID
--join SaleTransaction (nolock) cab on lin.TransDocument=cab.TransDocument and lin.TransSerial=cab.TransSerial and lin.TransDocNumber=cab.TransDocNumber
where n.LanguageID='PTG'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Documents]'))
DROP view [dbo].[v_Kapps_Reception_Documents]
GO
CREATE view [dbo].[v_Kapps_Reception_Documents]
as 
select distinct cast(cab.TransSerial AS VARCHAR(10)) + '*' + cast(cab.TransDocument AS VARCHAR(50)) + '*' + cast(year(cab.CreateDate) AS VARCHAR(20)) + '*' + CAST(cab.TransDocNumber as varchar(10)) as 'ReceptionKey',
cab.TransDocNumber as 'Number',
f.OrganizationName as 'SupplierName',
cab.CreateDate as 'Date',
f.SupplierID as 'Supplier',
cab.TransDocument as 'Document',
dn.Description as 'DocumentName',
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
YEAR(cab.CreateDate) as EXR,
cab.TransSerial as SEC,
cab.TransDocument as TPD,
cab.TransDocNumber as NDC,
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as ExternalDoc
,'' as Barcode
from BuyTransaction (nolock) cab join Supplier (nolock) f on cab.PartyID=f.SupplierID
join DocumentsName (nolock) dn on dn.TransDocumentID=cab.TransDocument
where cab.TransStatus=0
and cab.TransactionConverted=0
and dn.LanguageID='PTG'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Lines]'))
DROP view [dbo].[v_Kapps_Reception_Lines]
GO
CREATE view [dbo].[v_Kapps_Reception_Lines] as
select 
(CAST(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) as 'ReceptionLineKey',
lin.itemid as 'Article',
LEFT(n.Description,100) as 'Description',
(lin.Quantity) as 'Quantity',
(lin.DestinationQuantity) as 'QuantitySatisfied',
((lin.Quantity) - (lin.DestinationQuantity)) -
		(
		select isnull(sum(u_Kapps_DossierLin.Qty2),0) 
		from u_Kapps_DossierLin (NOLOCK) 
		where u_Kapps_DossierLin.Status = 'A' 
		and u_Kapps_DossierLin.Integrada = 'N' 
		and ((cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10))) = u_Kapps_DossierLin.Stampbo)
		and ((cast(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) = u_Kapps_DossierLin.Stampbi)
		) as 'QuantityPending',
		(select isnull(sum(u_Kapps_DossierLin.Qty2),0)
		from u_Kapps_DossierLin (NOLOCK) 
		where u_Kapps_DossierLin.Status = 'A' 
		and u_Kapps_DossierLin.Integrada = 'N' 
		and ((cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10))) = u_Kapps_DossierLin.Stampbo)
		and ((cast(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) = u_Kapps_DossierLin.Stampbi)
		) as 'QuantityPicked',
art.UnitOfSaleID as 'BaseUnit',
lin.UnitOfSaleID as 'BusyUnit',
lin.PackQuantity as 'ConversionFator',
lin.WarehouseID as 'Warehouse',
cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(Year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10)) as 'ReceptionKey',
lin.LineItemID as 'OriginalLineNumber',
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
YEAR(lin.CreateDate) as EXR,
lin.TransSerial as SEC,
lin.TransDocument as TPD,
lin.TransDocNumber as NDC
, '' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' AS Location
, ISNULL((SELECT PropertyValue1 FROM TransactionPropDetails det WITH(NOLOCK) WHERE det.TransSerial=lin.TransSerial and det.TransDocument= lin.TransDocument and det.TransDocNumber=lin.TransDocNumber and det.LineItemID=lin.LineItemID and det.LineItemSubID=lin.LineItemSubID),'') AS Lot
from buytransactiondetails lin with(nolock) join Item art with(nolock) on lin.ItemID=art.ItemID
join ItemNames n with(nolock) on art.ItemID=n.ItemID
--join SaleTransaction (nolock) cab on lin.TransDocument=cab.TransDocument and lin.TransSerial=cab.TransSerial and lin.TransDocNumber=cab.TransDocNumber
where n.LanguageID='PTG'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Units]'))
DROP view [dbo].[v_Kapps_Units]
GO
CREATE view [dbo].[v_Kapps_Units] as 
select art.ItemID as 'Code',
art.UnitOfSaleID as 'Unit',
1 as 'Factor' 
from Item (nolock) art
where art.Discontinued=0
union all
select art.ItemID as 'Code',
art.AlternativeUnitOfStock as 'Unit',
art.unitConversion as 'Factor' 
from Item (nolock) art
where art.Discontinued=0
and art.unitofSaleID<>art.AlternativeUnitOfStock
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_WarehousesLocations]'))
DROP view [dbo].[v_Kapps_WarehousesLocations]
GO
CREATE view [dbo].[v_Kapps_WarehousesLocations] as 
select 
'' AS Warehouse
, '' AS ZoneLocation
, '' AS Location
, '' AS Description
, '1' AS LocActiva
, cast(1 as bit) AS Checkdigit
, cast(0 as int) AS LocationType						-- int 1(Localizações do tipo Receção), 2(Localizações do tipo expedição)
WHERE 1 = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Documents]'))
DROP view [dbo].[v_Kapps_Stock_Documents]
GO
CREATE view [dbo].[v_Kapps_Stock_Documents]
as 
--select distinct 
--'' as 'CabKey',										-- Chave unica
--'' as 'Date',											-- Data e Hora de criação
--'' as 'Warehouse',
--'' as 'DocumentName',									-- Descrição da contagem
--'' as 'UserCol1',
--'' as 'UserCol2',
--'' as 'UserCol3',
--'' as 'UserCol4',
--'' as 'UserCol5',
--'' as 'UserCol6',
--'' as 'UserCol7',
--'' as 'UserCol8',
--'' as 'UserCol9',
--'' as 'UserCol10',
--'' as 'EXR',											-- Exercicio
--'' as 'SEC',											-- Serie/Secção
--'' as 'TPD',											-- Tipo Documento
--'' as 'NDC',											-- Numero de Documento
--'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
--'' as DocType,										-- 'C' Cega
--'' as ZoneLocation,
--'' as Location,
--'' as InternalStampDoc
--UNION ALL
SELECT 
stk.Stamp as 'CabKey',									-- Chave unica
stk.DocDate as 'Date',									-- Data e Hora de criação
stk.Warehouse,
stk.Name as 'DocumentName',								-- Descrição da contagem
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
'' as 'EXR',											-- Exercicio
'' as 'SEC',											-- Serie/Secção
'' as 'TPD',											-- Tipo Documento
'' as 'NDC',											-- Numero de Documento
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'C' as DocType,											-- 'C' Cega
'' as ZoneLocation,
'' as Location,
stk.Stamp as InternalStampDoc
FROM u_Kapps_StockDocs stk
WHERE stk.Syncr<>'S'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Lines]'))
DROP view [dbo].[v_Kapps_Stock_Lines]
GO
CREATE view [dbo].[v_Kapps_Stock_Lines] as
Select distinct 
'' as 'LineKey', 										-- Chave Unica
'' as 'OrigLineNumber',
'' as 'Article',
'' as 'Description',
'' as 'Quantity',
'' as 'QuantityPicked', 
'' as 'BaseUnit',
'' as 'Warehouse',
'' AS Location,
'' AS Lot,
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
'' as 'EXR',											-- Exercicio
'' as 'SEC',											-- Serie/Secção
'' as 'TPD',											-- TipoDocumento
'' as 'NDC',											-- Numero Documento
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
WHERE 1 = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers_DeliveryLocations]'))
DROP view [dbo].[v_Kapps_Customers_DeliveryLocations]
GO
CREATE view [dbo].[v_Kapps_Customers_DeliveryLocations] as 
select 
mor.AddressID AS DeliveryCode,
cli.CustomerID AS ClientCode,
cli.OrganizationName AS Name,
mor.AddressLine1 AS Address1,
mor.AddressLine2 AS Address2,
'' AS City,
mor.PostalCode AS PostalCode,
'' AS PostalCodeAddress,
'' AS AreaCode,
pais.CountryName AS Country,
'' AS CountryName
from PartyAddress mor WITH(NOLOCK)
left join Customer cli WITH(NOLOCK) ON mor.PartyId=cli.CustomerID
left join CountryCodes pais WITH(NOLOCK) ON pais.CountryID=mor.CountryID
where cli.ActiveParty = 1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_RestrictedUsersZones]'))
DROP view [dbo].[v_Kapps_RestrictedUsersZones]
GO
CREATE view [dbo].[v_Kapps_RestrictedUsersZones] as 
select 
'' AS UserName,
'' AS ZoneLocation
WHERE 1 = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_StockBreakReasons]'))
DROP view [dbo].[v_Kapps_StockBreakReasons]
GO
CREATE view [dbo].[v_Kapps_StockBreakReasons] as 
select ReasonID, ReasonDescription, ReasonType
FROM u_Kapps_Reasons
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_RestrictedArticles]'))
DROP view [dbo].[v_Kapps_RestrictedArticles]
GO
CREATE view [dbo].[v_Kapps_RestrictedArticles] as 
select 
'' AS RuleType,											--(R - Restringe / A - Autoriza)
'' AS Warehouse,
'' AS ZoneLocation,
'' AS Location,
'' AS Family,
'' AS Article
WHERE 1 = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Entities]'))
DROP view [dbo].[v_Kapps_Entities]
GO
CREATE view [dbo].[v_Kapps_Entities] as 
select '' as NAME, '' as Code
, '' AS NIF
, '' as EntityType
,'' As Adress
,'' As Adress1
,'' As PostalCode
,'' As Area
,'' As Country
,'' As Phone
,CAST(0 as numeric(10,6)) as Latitude
,CAST(0 as numeric(10,6)) as Longitude
,'' as OBS
WHERE 1 = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_SSCC_Lines]'))
DROP view [dbo].[v_Kapps_SSCC_Lines]
GO
CREATE view [dbo].[v_Kapps_SSCC_Lines] as 
select h.SSCC as HeaderSSCC
, d.SSCC as DetailSSCC
, h.PackId
, d.Ref AS Article
, d.Quantity2 as Quantity
, d.Quantity2UM as Unit
, d.Lot
, d.ExpirationDate
, d.Serial as SerialNumber
, d.NetWeight
, lin.LinUserField1
, lin.LinUserField2
, lin.LinUserField3
, lin.LinUserField4
, lin.LinUserField5
, lin.LinUserField6
, lin.LinUserField7
, lin.LinUserField8
, lin.LinUserField9
, lin.LinUserField10
, d.Location
, h.CurrentWarehouse
, h.CurrentLocation
, h.PackStatus
, h.PackType
FROM u_Kapps_PackingDetails d
LEFT JOIN u_Kapps_PackingHeader h on h.PackId=d.PackID
LEFT JOIN u_Kapps_DossierLin lin on lin.StampLin=d.StampLin
WHERE d.SSCC<>'' or h.SSCC<>''
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Documents]'))
DROP view [dbo].[v_Kapps_PickTransf_Documents]
GO
CREATE view [dbo].[v_Kapps_PickTransf_Documents]
as 
select distinct 
cab.TransSerial+'*'+ cab.TransDocument+'*'+cast(YEAR(cab.CreateDate)as varchar(4))+'*'+CAST(cab.TransDocNumber as varchar(12)) as 'PickingKey', 
cab.TransDocNumber as Number,
c.OrganizationName as CustomerName,
cab.CreateDate as 'Date',
cab.PartyID as Customer,
cab.TransDocument as Document,
d.Description as DocumentName,
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
YEAR(cab.CreateDate) as EXR,
cab.TransSerial as SEC,
cab.TransDocument as TPD,
cab.TransDocNumber as NDC,
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.PartyID as DeliveryCustomer
,UnloadPlaceID as DeliveryCode
,'' as OriginWarehouse
,'' as TransitWarehouse
,'' as DestinationWarehouse
,'' as Barcode
from SaleTransaction (nolock) cab join Customer (nolock) c on cab.PartyID=c.PartyID 
join DocumentsName (nolock) d on cab.TransDocument=d.TransDocumentID
left join u_Kapps_DossierLin (NOLOCK) on (u_Kapps_DossierLin.StampBo = (cab.TransSerial+'*'+ cab.TransDocument+'*'+cast(YEAR(cab.CreateDate)as varchar(4))+'*'+CAST(cab.TransDocNumber as varchar(12)))) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'
where cab.TransStatus=0
and cab.TransactionConverted=0
and d.LanguageID='PTG'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Lines]'))
DROP view [dbo].[v_Kapps_PickTransf_Lines]
GO
CREATE view [dbo].[v_Kapps_PickTransf_Lines] as
select 
(CAST(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) as 'PickingLineKey',
lin.itemid as 'Article',
LEFT(n.Description,100) as 'Description',
(lin.Quantity) as 'Quantity',
(lin.DestinationQuantity) as 'QuantitySatisfied',
((lin.Quantity) - (lin.DestinationQuantity)) -
	   (
	   select isnull(sum(u_Kapps_DossierLin.Qty2),0) 
       from u_Kapps_DossierLin (NOLOCK) 
       where u_Kapps_DossierLin.Status = 'A' 
       and u_Kapps_DossierLin.Integrada = 'N'      
       and ((cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10))) = u_Kapps_DossierLin.Stampbo)
       and ((cast(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) = u_Kapps_DossierLin.Stampbi)
       ) as 'QuantityPending',
	   (select isnull(sum(u_Kapps_DossierLin.Qty2),0)
       from u_Kapps_DossierLin (NOLOCK) 
       where u_Kapps_DossierLin.Status = 'A' 
       and u_Kapps_DossierLin.Integrada = 'N' 
       and ((cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10))) = u_Kapps_DossierLin.StampBo)
       and ((cast(lin.TransDocNumber as varchar(10))+'*' + cast (lin.LineItemID as varchar(15))+'_'+cast (lin.LineItemSubID as varchar(15))) = u_Kapps_DossierLin.Stampbi)
       ) as 'QuantityPicked',
art.UnitOfSaleID as 'BaseUnit',
lin.UnitOfSaleID as 'BusyUnit',
lin.PackQuantity as 'ConversionFator',
lin.WarehouseID as 'Warehouse',
cast(lin.TransSerial AS VARCHAR(10)) + '*' + cast(lin.TransDocument AS VARCHAR(50)) + '*' + cast(Year(lin.CreateDate) AS VARCHAR(20)) + '*' + CAST(lin.TransDocNumber as varchar(10)) as 'PickingKey',
lin.LineItemID as 'OriginalLineNumber',
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
YEAR(lin.CreateDate) as EXR,
lin.TransSerial as SEC,
lin.TransDocument as TPD,
lin.TransDocNumber as NDC
, '' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' AS Location
, ISNULL((SELECT PropertyValue1 FROM TransactionPropDetails det WITH(NOLOCK) WHERE det.TransSerial=lin.TransSerial and det.TransDocument= lin.TransDocument and det.TransDocNumber=lin.TransDocNumber and det.LineItemID=lin.LineItemID and det.LineItemSubID=lin.LineItemSubID),'') AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
from saletransactiondetails lin WITH(nolock) join Item art WITH(nolock) on lin.ItemID=art.ItemID
join ItemNames n with(nolock) on art.ItemID=n.ItemID
--join SaleTransaction (nolock) cab on lin.TransDocument=cab.TransDocument and lin.TransSerial=cab.TransSerial and lin.TransDocNumber=cab.TransDocNumber
where n.LanguageID='PTG'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Status]'))
DROP view [dbo].[v_Kapps_Stock_Status]
GO
CREATE view [dbo].[v_Kapps_Stock_Status] as 
select '' as Code
, '' AS Description
WHERE 1=0
GO