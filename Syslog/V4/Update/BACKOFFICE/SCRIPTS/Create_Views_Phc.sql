IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers]'))
DROP view [dbo].[v_Kapps_Customers]
GO
CREATE view [dbo].[v_Kapps_Customers] as 
select cl.Nome as Name, CASE WHEN cl.estab > 0 then cast(cl.no as varchar(50)) + '.' + cast(cl.estab  as varchar(50)) else cast(cl.no as varchar(50)) end as Code
, '' AS 'NameByLabel', '' AS 'AdressByLabel'
, cl.ncont AS NIF
, CAST('0' as varchar(1)) as RuleForSSCC	-- Regra a usar na criação de SSCC no packing 0-Um SSCC por caixa	1-Um SSCC por cada combinação de Artigo/Lote/Validade
,morada As Adress
,'' As Adress1
,codpost As PostalCode
,local As Area
,Case when pais = '1' Then 'Nacional' Else Case when pais = '2' Then 'U.E.' Else 'Outros' End End  As Country
,telefone As Phone
,CAST(0 as numeric(10,6)) as Latitude
,CAST(0 as numeric(10,6)) as Longitude
,Obs as OBS
, 0 AS InternalCustomer						-- 0 Externo, 1 Interno
, Case When cl.nome2>'' Then cl.nome2 Else cl.Nome End  As ShortName
from cl WITH(NOLOCK)
where cl.inactivo = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Suppliers]'))
DROP view [dbo].[v_Kapps_Suppliers]
GO
CREATE view [dbo].[v_Kapps_Suppliers] as 
select forn.nome as Name, CASE WHEN forn.estab > 0 then cast(forn.no as varchar(50)) + '.' + cast(forn.estab  as varchar(50)) else cast(forn.no as varchar(50)) end as Code
, forn.ncont AS NIF
,morada As Adress
,'' As Adress1
,codpost As PostalCode
,local As Area
,Case when pais = '1' Then 'Nacional' Else Case when pais = '2' Then 'U.E.' Else 'Outros' End End  As Country
,telefone As Phone
,latitude as Latitude
,longitude as Longitude
,obs as OBS
from fl forn WITH(NOLOCK)
where inactivo = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Documents]'))
DROP view [dbo].[v_Kapps_Documents]
GO
CREATE view [dbo].[v_Kapps_Documents]  
as
select  nmdos as 'Description', 
ndos as 'Code', 
CASE WHEN (bdempresas = 'CL') THEN 1 ELSE 0 END as 'Orders', 
CASE WHEN (bdempresas = 'CL') THEN 1 ELSE 0 END as 'Sales', 
CASE WHEN (bdempresas = 'FL') THEN 1 ELSE 0 END as 'Purchase', 
0 as 'Internal', 
CASE WHEN trfa = 0 then 0 when stocks = 1 and trfa = 0  THEN 1 ELSE 0 END as 'Stock', 
CASE WHEN trfa = 1 THEN 1 ELSE 0 END as 'Transfer', 
CASE WHEN trfa = 1 THEN bdempresas WHEN (bdempresas = 'CL') THEN 'CL' WHEN (bdempresas = 'FL') THEN 'FL' WHEN (bdempresas = 'AG') THEN 'AG' ELSE 'I' END  as Entity
,1 as 'ValidaStock'
,0 as 'StockBreak'
,'' as DefaultEntity
from ts WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Warehouses]'))
DROP view [dbo].[v_Kapps_Warehouses]
GO
CREATE view [dbo].[v_Kapps_Warehouses] as 
select arm.nome as Description, CAST(arm.no as nvarchar(5)) as Code
, cast(0 as bit) AS UseLocations						-- (1-Sim) (0-Não)
, '' AS DefaultLocation
from sz arm WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Articles]'))
DROP view [dbo].[v_Kapps_Articles]
GO
CREATE view [dbo].[v_Kapps_Articles] as 
select art.design as 'Description', art.ref as 'Code', art.codigo as 'Barcode',
art.usalote as 'UseLots', art.noserie as 'UseSerialNumber',
art.unidade as 'BaseUnit', art.familia as 'Family', CASE WHEN art.STNS = 1 THEN 0 ELSE 1 END as 'MovStock',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5', '' AS 'GTIN'
, '' AS DefaultWarehouse
, '' AS DefaultLocation
, cast(0 as bit) AS UseLocations						-- (1-Sim) (0-Não)
, art.Unidade AS SellUnit
, art.Unidade AS BuyUnit
, 0 as LoteControlOut									-- 0-Manual 1-FIFO, 2-FEFO, 3-LIFO
, 0 as UseExpirationDate
, CAST(0 as bit) as UseWeight							-- (1-Sim) (0-Não)
, 0 AS StoreInNrDays									-- Nº de dias minimo de validade na receção (excepto se existir regra a contrariar em [Validades mínimas])
, 0 AS StoreOutNrDays									-- Nº de dias minimo de validade na expedição (excepto se existir regra a contrariar em [Validades mínimas])
, CAST(0 as int) AS BoxMaxQuantity
from st art WITH(NOLOCK)
where art.inactivo = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Barcodes]'))
DROP view [dbo].[v_Kapps_Barcodes]
GO
CREATE view [dbo].[v_Kapps_Barcodes] as 
select bc.ref as Code, bc.codigo as Barcode, art.Unidade as Unit, bc.qtt as Quantity
from bc WITH(NOLOCK)
JOIN st art WITH(NOLOCK) on art.Ref = bc.ref
where art.inactivo = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock]'))
DROP view [dbo].[v_Kapps_Stock]
GO
CREATE view [dbo].[v_Kapps_Stock] as 
select sa.ref as Article, CAST(sa.armazem as VARCHAR(5)) as Warehouse, case when COALESCE(sal.lote,'')='' then sa.stock else sal.stock end as Stock
, '' as Location
, COALESCE(sal.lote,'') AS Lote
, case when COALESCE(sal.lote,'')='' then sa.stock-sa.rescli else sal.stock end as AvailableStock
from sa WITH(NOLOCK)
join st art WITH(NOLOCK) on art.ref = sa.ref
left join sal WITH(NOLOCK) on sal.ref = sa.ref and sal.armazem = sa.armazem
where art.inactivo = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Lots]'))
DROP view [dbo].[v_Kapps_Lots]
GO
CREATE view [dbo].[v_Kapps_Lots] as 
select lot.Lote as Lot, lot.ref as Article, lot.Validade as ExpirationDate
, lot.Data AS ProductionDate
, CASE WHEN lot.inactivo=1 then 0 ELSE 1 END as Actif
from se lot WITH(NOLOCK)
join st art WITH(NOLOCK) on art.ref = lot.ref
where art.inactivo = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_SerialNumbers]'))
DROP view [dbo].[v_Kapps_SerialNumbers]
GO
DECLARE @tempSQL nvarchar(MAX);

SET @tempSQL = 'CREATE view [dbo].[v_Kapps_SerialNumbers] as 
select distinct SerialNumber, Article, Warehouse
from (
';

IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'foma') AND type in (N'U'))
BEGIN
	SET @tempSQL = @tempSQL + '	select ans.SERIE as SerialNumber, ans.Ref as Article, ans.armazem as Warehouse
	from foma  ans WITH(NOLOCK)
	join st art WITH(NOLOCK) on art.ref = ans.ref
	where art.inactivo  = 0

	union all

';
END
SET @tempSQL = @tempSQL + '	select ans.SERIE as SerialNumber, ans.Ref as Article, ans.armazem as Warehouse
	from boma  ans WITH(NOLOCK)
	join st art WITH(NOLOCK) on art.ref = ans.ref
	where art.inactivo  = 0
	)temp ';
EXEC sp_executesql @tempSQL
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Families]'))
DROP view [dbo].[v_Kapps_Families]
GO
CREATE view [dbo].[v_Kapps_Families] as 
select nome as 'Description' ,ref as 'Code' from stfami WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Documents]'))
DROP view [dbo].[v_Kapps_Picking_Documents]
GO
CREATE view [dbo].[v_Kapps_Picking_Documents]
as 
select distinct  
bo.bostamp as 'PickingKey', 
bo.obrano as 'Number',
bo.nome as 'CustomerName',
bo.dataobra as 'Date', 
CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else cast(bo.no as varchar(50)) end as 'Customer',
bo.ndos as 'Document', 
bo.nmdos as 'DocumentName', 
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos  as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else CAST(bo.no as varchar(50)) end as DeliveryCustomer
,bo2.descar as DeliveryCode
,bo3.barcode as Barcode
from bo WITH(NOLOCK) 
left join u_Kapps_DossierLin WITH(NOLOCK) on u_Kapps_DossierLin.StampBo = bo.bostamp and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
left join bo2 WITH(NOLOCK) on bo.bostamp=bo2.bo2stamp 
left join bo3 WITH(NOLOCK) on bo3.bo3stamp=bo.bostamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Lines]'))
DROP view [dbo].[v_Kapps_Picking_Lines]
GO
CREATE view [dbo].[v_Kapps_Picking_Lines] as
select distinct 
bi.bistamp as 'PickingLineKey', 
bi.ref as 'Article', 
bi.design as 'Description', 
bi.qtt as 'Quantity',
bi.qtt2 as 'QuantitySatisfied',
bi.qtt-(bi.qtt2 + (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK)  where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and  bi.bistamp=u_Kapps_DossierLin.stampbi)) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK)  where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and  bi.bistamp=u_Kapps_DossierLin.stampbi) as 'QuantityPicked', 
bi.unidade AS 'BaseUnit',
bi.unidade as 'BusyUnit', 
1 AS 'ConversionFator',
bi.armazem as 'Warehouse',  
bi.bostamp as 'PickingKey',
bi.lordem as 'OriginalLineNumber',
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' AS Location
, bi.lote AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
from bi WITH(NOLOCK) 
join bo WITH(NOLOCK) ON bo.bostamp = bi.bostamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Documents]'))
DROP view [dbo].[v_Kapps_Packing_Documents]
GO
CREATE view [dbo].[v_Kapps_Packing_Documents]
as 
select distinct
bo.bostamp as 'PackingKey', 
bo.obrano as 'Number',
bo.nome as 'CustomerName',
bo.dataobra as 'Date', 
CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else cast(bo.no as varchar(50)) end as 'Customer',
bo.ndos as 'Document', 
bo.nmdos as 'DocumentName', 
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5','' AS 'PurchaseOrder', '' AS 'MySupplierNumber'
,CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else cast(bo.no as varchar(50)) end as DeliveryCustomer
,bo2.descar AS DeliveryCode
,bo3.barcode as Barcode
from bo WITH(NOLOCK) 
left join u_Kapps_DossierLin WITH(NOLOCK) on u_Kapps_DossierLin.StampBo = bo.bostamp and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'
left join bo2 WITH(NOLOCK) on bo.bostamp=bo2.bo2stamp 
left join bo3 WITH(NOLOCK) on bo3.bo3stamp=bo.bostamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Lines]'))
DROP view [dbo].[v_Kapps_Packing_Lines]
GO
CREATE view [dbo].[v_Kapps_Packing_Lines] as
select distinct 
bi.bistamp as 'PackingLineKey', 
bi.ref as 'Article', 
bi.design as 'Description', 
bi.qtt as 'Quantity',
bi.qtt2 as 'QuantitySatisfied',
bi.qtt-(bi.qtt2 + (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and  bi.bistamp=u_Kapps_DossierLin.stampbi)) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and  bi.bistamp=u_Kapps_DossierLin.stampbi) as 'QuantityPicked', 
bi.unidade AS 'BaseUnit',
bi.unidade as 'BusyUnit', 
1 AS 'ConversionFator',
bi.armazem as 'Warehouse',  
bi.bostamp as 'PackingKey',
bi.lordem as 'OriginalLineNumber',
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' AS Location
, bi.lote AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
from bi WITH(NOLOCK) 
JOIN bo WITH(NOLOCK) ON bo.bostamp = bi.bostamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Documents]'))
DROP view [dbo].[v_Kapps_Reception_Documents]
GO
CREATE view [dbo].[v_Kapps_Reception_Documents]
as 
select distinct
bo.bostamp as 'ReceptionKey',
bo.obrano as 'Number',
bo.nome as 'SupplierName',
bo.dataobra as 'Date', 
CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else cast(bo.no as varchar(50)) end as 'Supplier',
bo.ndos as 'Document', 
bo.nmdos as 'DocumentName', 
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as ExternalDoc
,bo3.barcode as Barcode
from bo WITH(NOLOCK) 
left join u_Kapps_DossierLin WITH(NOLOCK) on u_Kapps_DossierLin.StampBo = bo.bostamp and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'
left join bo3 WITH(NOLOCK) on bo3.bo3stamp=bo.bostamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Lines]'))
DROP view [dbo].[v_Kapps_Reception_Lines]
GO
CREATE view [dbo].[v_Kapps_Reception_Lines] as
select distinct 
bi.bistamp as 'ReceptionLineKey', 
bi.ref as 'Article',
bi.design  as 'Description', 
bi.qtt  as 'Quantity',
bi.qtt2 as 'QuantitySatisfied',
bi.qtt-bi.qtt2-(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and bi.bistamp=u_Kapps_DossierLin.stampbi) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and bi.bistamp=u_Kapps_DossierLin.stampbi)  as 'QuantityPicked', 
bi.unidade AS 'BaseUnit',
bi.unidade as 'BusyUnit',
1 AS 'ConversionFator',
bi.armazem as 'Warehouse',
bi.bostamp as 'ReceptionKey',
bi.lordem as 'OriginalLineNumber',
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' AS Location
, bi.lote AS Lot
from bi WITH(NOLOCK)
join bo WITH(NOLOCK) ON bo.bostamp = bi.bostamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Units]'))
DROP view [dbo].[v_Kapps_Units]
GO
CREATE view [dbo].[v_Kapps_Units] as
select distinct
art.ref as 'Code',
art.unidade as 'Unit',
1 as 'Factor'
FROM st art WITH(NOLOCK)
WHERE art.INACTIVO = 0

UNION ALL

select distinct
art.ref as 'Code',
art.uni2 as 'Unit',
art.conversao as 'Factor'
FROM st art WITH(NOLOCK)
WHERE art.INACTIVO = 0 and art.uni2 <> '' and art.uni2 <> art.unidade 
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
, 1 AS LocActiva
, cast(1 as bit) AS Checkdigit
, cast(0 as int) AS LocationType						-- 1(Localizações do tipo Receção), 2(Localizações do tipo expedição)
WHERE 1 = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Documents]'))
DROP view [dbo].[v_Kapps_Stock_Documents]
GO
CREATE view [dbo].[v_Kapps_Stock_Documents]
as 
select distinct 
cab.sticstamp as 'CabKey',		-- Chave unica
cab.data as 'Date',		-- Data e Hora de criação
'' as 'Warehouse',
cab.descricao as 'DocumentName',	-- Descrição da contagem
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
FROM stic cab WITH(NOLOCK)
where lanca = 0
UNION ALL
SELECT 
stk.Stamp as 'CabKey',		-- Chave unica
stk.DocDate as 'Date',		-- Data e Hora de criação
stk.Warehouse,
stk.Name as 'DocumentName',	-- Descrição da contagem
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
'C' as DocType,				-- 'C' Cega
'' as ZoneLocation,
'' as Location,
stk.Stamp as InternalStampDoc
FROM u_Kapps_StockDocs stk WITH(NOLOCK)
WHERE stk.Syncr<>'S'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Lines]'))
DROP view [dbo].[v_Kapps_Stock_Lines]
GO
CREATE view [dbo].[v_Kapps_Stock_Lines] as
select distinct 
stilstamp as 'LineKey', -- Chave Unica
lordem as 'OrigLineNumber',
ref as 'Article',
design as 'Description',
stock as 'Quantity',
0.0 as 'QuantityPicked', 
unidade as 'BaseUnit',
armazem as 'Warehouse',
[local] AS Location,
lote AS Lot,
sticstamp as 'CabKey',
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
FROM stil lin WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers_DeliveryLocations]'))
DROP view [dbo].[v_Kapps_Customers_DeliveryLocations]
GO
CREATE view [dbo].[v_Kapps_Customers_DeliveryLocations] as 
select 
mor.szadrsdesc AS DeliveryCode, 						--mor.szadrsstamp ???, -- confirmar cli.Nome no BO
CASE WHEN cli.estab > 0 then cast(cli.no as varchar(50)) + '.' + cast(cli.estab  as varchar(50)) else cast(cli.no as varchar(50)) end AS ClientCode,
cli.Nome AS Name,
mor.Morada AS Address1,
'' AS Address2,
mor.Local AS City,
mor.Codpost AS PostalCode,
'' AS PostalCodeAddress,
'' AS AreaCode,
mor.Pais AS Country,
'' AS CountryName
from szadrs mor WITH(NOLOCK)
left join cl cli WITH(NOLOCK) ON mor.szadrsdesc=cli.nome
where mor.inactivo = 0
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
FROM u_Kapps_Reasons WITH(NOLOCK)
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
select nome as Name, cast(no as varchar(50)) as Code
, ncont AS NIF
, 'AG' as EntityType
,'' As Adress
,'' As Adress1
,'' As PostalCode
,'' As Area
,'' As Country
,'' As Phone
,latitude as Latitude
,longitude as Longitude
,'' as OBS
from AG WITH(NOLOCK)
Where ag.inactivo=0
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
, lin.LinUserField11
, lin.LinUserField12
, lin.LinUserField13
, lin.LinUserField14
, lin.LinUserField15
, d.Location
, h.CurrentWarehouse
, h.CurrentLocation
, h.PackStatus
, h.PackType
, h.CustomerId
, h.CustomerName
FROM u_Kapps_PackingDetails d WITH(NOLOCK)
LEFT JOIN u_Kapps_PackingHeader h WITH(NOLOCK) on h.PackId=d.PackID
LEFT JOIN u_Kapps_DossierLin lin WITH(NOLOCK) on lin.StampLin=d.StampLin
WHERE d.SSCC<>'' or h.SSCC<>''
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Documents]'))
DROP view [dbo].[v_Kapps_PickTransf_Documents]
GO
CREATE view [dbo].[v_Kapps_PickTransf_Documents]
as 
select distinct  
bo.bostamp as 'PickingKey', 
bo.obrano as 'Number',
bo.nome as 'CustomerName',
bo.dataobra as 'Date', 
CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else cast(bo.no as varchar(50)) end as 'Customer',
bo.ndos as 'Document', 
bo.nmdos as 'DocumentName', 
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos  as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else CAST(bo.no as varchar(50)) end as DeliveryCustomer
,bo2.descar as DeliveryCode
,'' as OriginWarehouse
,'' as TransitWarehouse
,'' as DestinationWarehouse
,bo3.barcode as Barcode
from bo WITH(NOLOCK) 
left join u_Kapps_DossierLin WITH(NOLOCK) on u_Kapps_DossierLin.StampBo = bo.bostamp and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
left join bo2 WITH(NOLOCK) on bo.bostamp=bo2.bo2stamp 
left join bo3 WITH(NOLOCK) on bo3.bo3stamp=bo.bostamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Lines]'))
DROP view [dbo].[v_Kapps_PickTransf_Lines]
GO
CREATE view [dbo].[v_Kapps_PickTransf_Lines] as
select distinct 
bi.bistamp as 'PickingLineKey', 
bi.ref as 'Article', 
bi.design as 'Description', 
bi.qtt as 'Quantity',
bi.qtt2 as 'QuantitySatisfied',
bi.qtt-(bi.qtt2 + (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK)  where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and  bi.bistamp=u_Kapps_DossierLin.stampbi)) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK)  where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and  bi.bistamp=u_Kapps_DossierLin.stampbi) as 'QuantityPicked', 
bi.unidade as 'BaseUnit',
bi.unidade as 'BusyUnit', 
1 as 'ConversionFator',
bi.armazem as 'Warehouse',  
bi.bostamp as 'PickingKey',
bi.lordem as 'OriginalLineNumber',
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' as Location
, bi.lote as Lot
, '' as PalletType
, 0 as PalletMaxUnits
from bi WITH(NOLOCK) 
join bo WITH(NOLOCK) ON bo.bostamp = bi.bostamp
left join bi2 WITH(NOLOCK) ON bi.bistamp = bi2.bi2stamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PalletTransf_Documents]'))
DROP view [dbo].[v_Kapps_PalletTransf_Documents]
GO
CREATE view [dbo].[v_Kapps_PalletTransf_Documents]
as 
select distinct  
bo.bostamp as 'PickingKey', 
bo.obrano as 'Number',
bo.nome as 'CustomerName',
bo.dataobra as 'Date', 
CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else cast(bo.no as varchar(50)) end as 'Customer',
bo.ndos as 'Document', 
bo.nmdos as 'DocumentName', 
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos  as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,CASE WHEN bo.estab > 0 then cast(bo.no as varchar(50)) + '.' + cast(bo.estab as varchar(50)) else CAST(bo.no as varchar(50)) end as DeliveryCustomer
,bo2.descar as DeliveryCode
,bo3.barcode as Barcode
from bo WITH(NOLOCK) 
left join u_Kapps_DossierLin WITH(NOLOCK) on u_Kapps_DossierLin.StampBo = bo.bostamp and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
left join bo2 WITH(NOLOCK) on bo.bostamp=bo2.bo2stamp 
left join bo3 WITH(NOLOCK) on bo3.bo3stamp=bo.bostamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PalletTransf_Lines]'))
DROP view [dbo].[v_Kapps_PalletTransf_Lines]
GO
CREATE view [dbo].[v_Kapps_PalletTransf_Lines] as
select distinct 
bi.bistamp as 'PickingLineKey', 
bi.ref as 'Article', 
bi.design as 'Description', 
bi.qtt as 'Quantity',
bi.qtt2 
--+ bi.u_qttPalet -- descomentar a linha após ter criado o campo de utilizador
as 'QuantitySatisfied',
bi.qtt-(bi.qtt2 
--+ bi.u_qttPalet -- descomentar a linha após ter criado o campo de utilizador
+ (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK)  where u_Kapps_DossierLin.Status = 'I' and u_Kapps_DossierLin.Integrada = 'N'  and  bi.bistamp=u_Kapps_DossierLin.stampbi)) as 'QuantityPending',
0 as 'QuantityPicked', 
bi.unidade as 'BaseUnit',
bi.unidade as 'BusyUnit', 
1 as 'ConversionFator',
bi.armazem as 'Warehouse',  
bi.bostamp as 'PickingKey',
bi.lordem as 'OriginalLineNumber',
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
CAST(bo.boano as varchar(50)) as 'EXR',
CAST(bo.ndos as varchar(50)) as 'SEC',
CAST(bo.ndos as varchar(50)) as 'TPD',
bo.obrano as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, '' as Location
, bi.lote as Lot
, '' as PalletType
, 0 as PalletMaxUnits
from bi WITH(NOLOCK) 
join bo WITH(NOLOCK) ON bo.bostamp = bi.bostamp
left join bi2 WITH(NOLOCK) ON bi.bistamp = bi2.bi2stamp
where bo.fechada=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Status]'))
DROP view [dbo].[v_Kapps_Stock_Status]
GO
CREATE view [dbo].[v_Kapps_Stock_Status] as 
select
'' as Code
, '' AS Description
WHERE 1=0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_ProductsStruture]'))
DROP view [dbo].[v_Kapps_ProductsStruture]
GO
CREATE VIEW [dbo].[v_Kapps_ProductsStruture] AS 
select 
dbo.sc.refb AS ProductId,
dbo.st.design AS ProductDescription,
dbo.sc.ref AS ComponentId,
dbo.sc.design AS ComponentDescription,
dbo.sc.qtt AS Quantity,
dbo.sc.unidade AS MeasureUnit,
0 AS Sequence,
0 AS Replaceable,
0 AS Tolerance
FROM dbo.sc
INNER JOIN dbo.st WITH (NOLOCK) ON dbo.sc.refb=dbo.st.ref
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_BOM_Header]'))
DROP view [dbo].[v_Kapps_BOM_Header]
GO
CREATE VIEW [dbo].[v_Kapps_BOM_Header] AS 
select distinct
dbo.bo.bostamp AS BOMKey,
dbo.bo.obrano AS Number,
dbo.bo.nome AS CustomerName,
dbo.bo.dataobra AS Date,
CASE WHEN bo.estab>0 THEN CAST( bo.no AS VARCHAR(50) )+'.'+CAST( bo.estab AS VARCHAR(50) ) ELSE CAST( bo.no AS VARCHAR(50) ) END AS Customer,
dbo.bo.ndos AS [Document],
dbo.bo.nmdos AS DocumentName,
'' AS UserCol1,
'' AS UserCol2,
'' AS UserCol3,
'' AS UserCol4,
'' AS UserCol5,
'' AS UserCol6,
'' AS UserCol7,
'' AS UserCol8,
'' AS UserCol9,
'' AS UserCol10,
CAST( dbo.bo.boano AS VARCHAR(50) ) AS EXR,
CAST( dbo.bo.ndos AS VARCHAR(50) ) AS SEC,
CAST( dbo.bo.ndos AS VARCHAR(50) ) AS TPD,
dbo.bo.obrano AS NDC,
'' AS Filter1,
'' AS Filter2,
'' AS Filter3,
'' AS Filter4,
'' AS Filter5,
CASE WHEN bo.estab>0 THEN CAST( bo.no AS VARCHAR(50) )+'.'+CAST( bo.estab AS VARCHAR(50) ) ELSE CAST( bo.no AS VARCHAR(50) ) END AS DeliveryCustomer,
dbo.bo2.descar AS DeliveryCode,
dbo.bo3.barcode
FROM dbo.bo WITH (NOLOCK)
LEFT OUTER JOIN dbo.u_Kapps_DossierLin WITH (NOLOCK) ON dbo.u_Kapps_DossierLin.StampBo=dbo.bo.bostamp AND dbo.u_Kapps_DossierLin.Status='A' AND dbo.u_Kapps_DossierLin.Integrada='N'
LEFT OUTER JOIN dbo.bo2 ON dbo.bo.bostamp=dbo.bo2.bo2stamp
LEFT OUTER JOIN dbo.bo3 ON dbo.bo3.bo3stamp=dbo.bo.bostamp
WHERE (dbo.bo.fechada=0)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_BOM_Items]'))
DROP view [dbo].[v_Kapps_BOM_Items]
GO
CREATE VIEW [dbo].[v_Kapps_BOM_Items]
AS
select distinct 
dbo.bi.bistamp AS BOMItemsKey,
dbo.bi.ref AS Article,
dbo.bi.design AS Description,
dbo.bi.qtt AS Quantity,
dbo.bi.qtt2 AS QuantitySatisfied,
dbo.bi.qtt-(dbo.bi.qtt2+(select ISNULL( SUM( Qty2 ), 0 ) AS Expr1 FROM dbo.u_Kapps_DossierLin WITH (NOLOCK) WHERE (Status='A') AND (Integrada='N') AND (dbo.bi.bistamp=StampBi))) AS QuantityPending,
(select ISNULL( SUM( Qty2 ), 0 ) AS Expr1 FROM dbo.u_Kapps_DossierLin AS u_Kapps_DossierLin_1 WITH (NOLOCK) WHERE (Status='A') AND (Integrada='N') AND (dbo.bi.bistamp=StampBi)) AS QuantityPicked,
dbo.bi.unidade AS BaseUnit,
dbo.bi.unidade AS BusyUnit,
1 AS ConversionFator,
dbo.bi.armazem AS Warehouse,
dbo.bi.bostamp AS BOMKey,
dbo.bi.lordem AS OriginalLineNumber,
'' AS UserCol1,
'' AS UserCol2,
'' AS UserCol3,
'' AS UserCol4,
'' AS UserCol5,
'' AS UserCol6,
'' AS UserCol7,
'' AS UserCol8,
'' AS UserCol9,
'' AS UserCol10,
CAST( dbo.bo.boano AS VARCHAR(50) ) AS EXR,
CAST( dbo.bo.ndos AS VARCHAR(50) ) AS SEC,
CAST( dbo.bo.ndos AS VARCHAR(50) ) AS TPD,
dbo.bo.obrano AS NDC,
'' AS Filter1,
'' AS Filter2,
'' AS Filter3,
'' AS Filter4,
'' AS Filter5,
'' AS Location,
dbo.bi.lote AS Lot,
'' AS PalletType,
0 AS PalletMaxUnits,
dbo.bi.composto AS IsComponent,
0 AS Sequence,
CAST( 0 AS BIT ) AS Replaceable,
0 AS Tolerance
FROM dbo.bi WITH (NOLOCK)
INNER JOIN dbo.bo WITH (NOLOCK) ON dbo.bo.bostamp=dbo.bi.bostamp
WHERE (dbo.bo.fechada=0)
GO
