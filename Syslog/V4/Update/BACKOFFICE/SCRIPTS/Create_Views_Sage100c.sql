IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers]'))
DROP view [dbo].[v_Kapps_Customers]
GO
CREATE view [dbo].[v_Kapps_Customers] as 
select cli.Nome as NAME, cli.CODIGO as Code, '' AS 'NameByLabel', '' AS 'AdressByLabel'
, cli.NContrib AS NIF
, CAST('0' as varchar(1)) as RuleForSSCC	-- Regra a usar na criação de SSCC no packing 0-Um SSCC por caixa	1-Um SSCC por cada combinação de Artigo/Lote/Validade
, MORADA As Adress
, MORADA2 As Adress1
, CDPOSTAL As PostalCode
, Local As Area
, PAIS As Country
, TELEF As Phone
, CAST(0 as numeric(10,6)) as Latitude
, CAST(0 as numeric(10,6)) as Longitude
, BLNOTAS as OBS
, 0 AS InternalCustomer						-- 0 Externo, 1 Interno
, cli.Nome As ShortName
from Clientes cli WITH(NOLOCK)
where cli.INACTIVO = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Suppliers]'))
DROP view [dbo].[v_Kapps_Suppliers]
GO
CREATE view [dbo].[v_Kapps_Suppliers] as 
select forn.Nome as NAME, forn.CODIGO as Code 
, forn.NContrib AS NIF
, MORADA As Adress
, MORADA2 As Adress1
, CDPOSTAL As PostalCode
, Local As Area
, PAIS As Country
, TELEF As Phone
, CAST(0 as numeric(10,6)) as Latitude
, CAST(0 as numeric(10,6)) as Longitude
,  BLNOTAS as OBS
from FORNEC forn WITH(NOLOCK)
where forn.INACTIVO = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Documents]'))
DROP view [dbo].[v_Kapps_Documents]
GO
CREATE view [dbo].[v_Kapps_Documents] as
select DC.DESCR	as 'Description', 
DC.CODIGO as 'Code',		
CASE WHEN TPDSAFT IN(21) THEN 1 ELSE 0 END as 'Orders',	
CASE WHEN TPDSAFT IN(1,9,26) THEN 1 ELSE 0 END as 'Sales', 											
CASE WHEN TPDSAFT IN(18,29,27) THEN 1 ELSE 0 END as 'Purchase', 
 0 as 'Internal', 
CASE WHEN TPDSAFT IN(19,40,35) THEN 1 ELSE 0 END as 'Stock',
CASE WHEN TPDSAFT IN(48) THEN 1 ELSE 0 END as 'Transfer',
CASE WHEN DC.ENTIDADE = '2' THEN 'CL' WHEN DC.ENTIDADE = '1' THEN 'FL' ELSE '' END as Entity
,1 as 'ValidaStock'
,0 as 'StockBreak'
,'' as DefaultEntity
from TPDOC DC WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Warehouses]'))
DROP view [dbo].[v_Kapps_Warehouses]
GO
CREATE view [dbo].[v_Kapps_Warehouses] as 
select arm.NOME as Description, arm.CODIGO as Code
, CAST(0 as bit) UseLocations
, '' AS DefaultLocation
from ARMAZENS arm WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Articles]'))
DROP view [dbo].[v_Kapps_Articles]
GO
CREATE view [dbo].[v_Kapps_Articles] as 
select art.NOME as 'Description', art.CODIGO as 'Code', '' as 'Barcode',
CASE WHEN art.CONTROLO_LOTES <> 0 THEN 1 ELSE art.E_LOTE END as 'UseLots', art.E_NUMERO_SERIE as 'UseSerialNumber',
art.UNBASE as 'BaseUnit', art.Familia as 'Family', CASE WHEN art.CTRSTOCK <> 0 THEN 1 ELSE 0 END AS 'MovStock',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5', '' AS 'GTIN'
,CAST('' as varchar(10)) AS DefaultWarehouse
,CAST('' as varchar(30)) AS DefaultLocation
,CAST(0 AS bit) AS UseLocations
, art.UNVND AS SellUnit
, art.UNCMP AS BuyUnit
, 0 as LoteControlOut									-- 0-Manual 1-FIFO, 2-FEFO, 3-LIFO
, CASE WHEN (SELECT VALIDADE FROM CATEGORIAS_LOTES WHERE CATEGORIA = art.CATEGORIA_LOTES)>0 THEN 1 ELSE 0 END as UseExpirationDate
, CAST(0 as bit) as UseWeight							-- (1-Sim) (0-Não)
, 0 AS StoreInNrDays									-- Nº de dias minimo de validade na receção (excepto se existir regra a contrariar em [Validades mínimas])
, 0 AS StoreOutNrDays									-- Nº de dias minimo de validade na expedição (excepto se existir regra a contrariar em [Validades mínimas])
, CAST(0 as int) AS BoxMaxQuantity
from Artigos art WITH(NOLOCK)
where art.INACTIVO = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Barcodes]'))
DROP view [dbo].[v_Kapps_Barcodes]
GO
CREATE view [dbo].[v_Kapps_Barcodes] as 
select cb.Artigo as Code, cb.CODIGO as Barcode, cb.UNID as Unit, cb.QTD as Quantity
from CBARRAS cb WITH(NOLOCK)
left join Artigos art WITH(NOLOCK) on art.CODIGO = cb.Artigo
where art.INACTIVO = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock]'))
DROP view [dbo].[v_Kapps_Stock]
GO
CREATE view [dbo].[v_Kapps_Stock] as 
SELECT sa.Artigo AS Article
, CAST(sa.armazem AS VARCHAR(5)) AS Warehouse
, SUM(CASE WHEN ISNULL(lot.CODLOTE, '') = '' THEN sa.EXISTENC ELSE (lot.QTDINICI - lot.QTDSID) END) AS Stock
, sa.LOCAL AS Location
, ISNULL(lot.CODLOTE, '') AS Lote, SUM(CASE WHEN ISNULL(lot.CODLOTE, '') = '' THEN sa.EXISTENC ELSE (lot.QTDINICI - lot.QTDSID) END) AS AvailableStock
--,sa.EXISTENC-sa.STRESOBR AS AvailableStock				--A Confirmar
FROM ARTARM sa(NOLOCK)
LEFT JOIN ARTIGOS art(NOLOCK) ON art.CODIGO = sa.Artigo
LEFT JOIN ARTLOT lot ON lot.ARTIGO = sa.ARTIGO AND lot.ARMAZEM = sa.ARMAZEM
WHERE art.INACTIVO = 0
GROUP BY sa.Artigo, CAST(sa.armazem AS VARCHAR(5)), sa.LOCAL, ISNULL(lot.CODLOTE, '')
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Lots]'))
DROP view [dbo].[v_Kapps_Lots]
GO
CREATE view [dbo].[v_Kapps_Lots] as 
select lot.CODLOTE as Lot
, lot.ARTIGO as Article
, lot.DTAVALPR AS ExpirationDate
, lot.DTAENTRA AS ProductionDate
, CAST(1 as bit) as Actif
from ARTLOT lot WITH(NOLOCK) 
join ARTIGOS art WITH(NOLOCK) on art.CODIGO = lot.ARTIGO
where art.INACTIVO = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_SerialNumbers]'))
DROP view [dbo].[v_Kapps_SerialNumbers]
GO
CREATE view [dbo].[v_Kapps_SerialNumbers] as 
select distinct (nsr.NUMSER) as SerialNumber, nsr.ARTIGO as Article, nsr.ARMAZEM as Warehouse
from NSERMOVS nsr WITH(NOLOCK)
join Artigos art WITH(NOLOCK) on art.CODIGO = nsr.Artigo
where art.INACTIVO = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Families]'))
DROP view [dbo].[v_Kapps_Families]
GO
CREATE view [dbo].[v_Kapps_Families] as 
select DESCR as 'Description' ,COD as 'Code' from Familia WITH(NOLOCK) 
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Documents]'))
DROP view [dbo].[v_Kapps_Picking_Documents]
GO
CREATE view [dbo].[v_Kapps_Picking_Documents]
as 
select distinct 
cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)) as 'PickingKey',
cab.NNUMDOC as 'Number',
cli.Nome as 'CustomerName',
cab.Data as 'Date',
cab.TERCEIRO as 'Customer',
cab.TPDOC as 'Document',
tdoc.DESCR as 'DocumentName',
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
cab.ANO as 'EXR',
cab.SERIE as 'SEC',
cab.TPDOC as 'TPD',
cab.NNUMDOC as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.TERCEIRO as DeliveryCustomer
,cab.ONDEENTR as DeliveryCode
,'' as Barcode
from DOCGCCAB cab WITH(NOLOCK)
join Clientes cli WITH(NOLOCK) ON cli.CODIGO = cab.TERCEIRO
join TPDOC tdoc WITH(NOLOCK) on tdoc.CODIGO = cab.TPDOC
left join u_Kapps_DossierLin WITH(NOLOCK) on (u_Kapps_DossierLin.StampBo = (cast(cab.SERIE AS VARCHAR(20)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))) 
and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
where cab.aprovado = 1 and cab.TPFSTC = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Lines]'))
DROP view [dbo].[v_Kapps_Picking_Lines]
GO
CREATE view [dbo].[V_Kapps_Picking_Lines] as
Select 
cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PickingLineKey',
lin.Artigo as 'Article',
Lin.DESCR as 'Description',
(Lin.QTDORIG / Lin.FACTOR) AS 'Quantity', 
((Lin.QTDORIG / Lin.FACTOR) - (Lin.QUANT/ Lin.FACTOR)) AS 'QuantitySatisfied', 
((Lin.QTDORIG / Lin.FACTOR) - ((Lin.QTDORIG / Lin.FACTOR) - (Lin.QUANT/ Lin.FACTOR))) -  
       (
       select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) 
       from u_Kapps_DossierLin WITH(NOLOCK) 
       where u_Kapps_DossierLin.Status = 'A' 
       and u_Kapps_DossierLin.Integrada = 'N' 
       and ((cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))=u_Kapps_DossierLin.stampbo) 
       and ((cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15))) = u_Kapps_DossierLin.Stampbi))                                         as 'QuantityPending',
              (
              select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) 
              from u_Kapps_DossierLin WITH(NOLOCK) 
              where u_Kapps_DossierLin.Status = 'A' 
              and u_Kapps_DossierLin.Integrada = 'N' 
              and ((cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))=u_Kapps_DossierLin.stampbo) 
              and ((cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15))) = u_Kapps_DossierLin.Stampbi))                                         as 'QuantityPicked',
Art.UNBASE AS 'BaseUnit',
lin.UNIDADE as 'BusyUnit',
CASE WHEN Art.UNBASE = Lin.Unidade THEN 1 ELSE lin.Factor END AS 'ConversionFator',
Lin.Armazem as 'Warehouse',
cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)) as 'PickingKey',
lin.numlinha as 'OriginalLineNumber',
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
cab.ANO as 'EXR',
cab.serie as 'SEC',
cab.TPDOC as 'TPD',
cab.NNUMDOC as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,'' as Location											--A Confirmar
,'' as Lot												--A Confirmar
, '' as PalletType
, 0 as PalletMaxUnits
FROM DOCGCLIN lin WITH(NOLOCK) 
JOIN DOCGCCAB cab WITH(NOLOCK) ON cab.SERIE = lin.SERIE and cab.TPDOC = lin.TPDOCUM  and cab.ANO = lin.ANO and cab.NNUMDOC = lin.NNUMDOC
LEFT JOIN Artigos Art WITH(NOLOCK) ON Art.CODIGO = lin.Artigo
where cab.aprovado = 1 and cab.TPFSTC = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Documents]'))
DROP view [dbo].[v_Kapps_Packing_Documents]
GO
CREATE view [dbo].[v_Kapps_Packing_Documents]
as 
select distinct 
cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)) as 'PackingKey',
cab.NNUMDOC as 'Number',
cli.Nome as 'CustomerName',
cab.Data as 'Date',
cab.TERCEIRO as 'Customer',
cab.TPDOC as 'Document',
tdoc.DESCR as 'DocumentName',
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
cab.ANO as 'EXR',
cab.SERIE as 'SEC',
cab.TPDOC as 'TPD',
cab.NNUMDOC as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5','' AS 'PurchaseOrder', '' AS 'MySupplierNumber'
,cab.TERCEIRO as DeliveryCustomer
,cab.ONDEENTR as DeliveryCode
,'' as Barcode
from DOCGCCAB cab WITH(NOLOCK)
join Clientes cli WITH(NOLOCK) ON cli.CODIGO = cab.TERCEIRO
join TPDOC tdoc WITH(NOLOCK) on tdoc.CODIGO = cab.TPDOC
left join u_Kapps_DossierLin WITH(NOLOCK) on (u_Kapps_DossierLin.StampBo = (cast(cab.SERIE AS VARCHAR(20)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))) 
and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
where cab.aprovado = 1 and cab.TPFSTC = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Lines]'))
DROP view [dbo].[v_Kapps_Packing_Lines]
GO
CREATE view [dbo].[v_Kapps_Packing_Lines] as
Select  
cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PackingLineKey',
lin.Artigo as 'Article',
Lin.DESCR as 'Description',
(Lin.QTDORIG / Lin.FACTOR) AS 'Quantity', 
((Lin.QTDORIG / Lin.FACTOR) - (Lin.QUANT/ Lin.FACTOR)) AS 'QuantitySatisfied', 
((Lin.QTDORIG / Lin.FACTOR) - ((Lin.QTDORIG / Lin.FACTOR) - (Lin.QUANT/ Lin.FACTOR))) - 
       (
       select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) 
       from u_Kapps_DossierLin WITH(NOLOCK) 
       where u_Kapps_DossierLin.Status = 'A' 
       and u_Kapps_DossierLin.Integrada = 'N' 
       and ((cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))=u_Kapps_DossierLin.stampbo) 
       and ((cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15))) = u_Kapps_DossierLin.Stampbi))                                         as 'QuantityPending',
              (
              select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) 
              from u_Kapps_DossierLin WITH(NOLOCK) 
              where u_Kapps_DossierLin.Status = 'A' 
              and u_Kapps_DossierLin.Integrada = 'N' 
              and ((cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))=u_Kapps_DossierLin.stampbo) 
              and ((cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15))) = u_Kapps_DossierLin.Stampbi))                                         as 'QuantityPicked',
Art.UNBASE AS 'BaseUnit',
lin.UNIDADE as 'BusyUnit',
CASE WHEN Art.UNBASE = Lin.Unidade THEN 1 ELSE lin.Factor END AS 'ConversionFator',
Lin.Armazem as 'Warehouse',
cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)) as 'PackingKey',
lin.numlinha as 'OriginalLineNumber',
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
cab.ANO as 'EXR',
cab.serie as 'SEC',
cab.TPDOC as 'TPD',
cab.NNUMDOC as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,'' as Location											--A Confirmar
,'' as Lot												--A Confirmar
,'' as PalletType
,0 as PalletMaxUnits

FROM DOCGCLIN lin WITH(NOLOCK) 
JOIN DOCGCCAB cab WITH(NOLOCK) ON cab.SERIE = lin.SERIE and cab.TPDOC = lin.TPDOCUM  and cab.ANO = lin.ANO and cab.NNUMDOC = lin.NNUMDOC
LEFT JOIN Artigos Art WITH(NOLOCK) ON Art.CODIGO = lin.Artigo
where cab.aprovado = 1 and cab.TPFSTC = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Documents]'))
DROP view [dbo].[v_Kapps_Reception_Documents]
GO
CREATE view [dbo].[v_Kapps_Reception_Documents]
as 
select distinct 
cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)) as 'ReceptionKey',
cab.NNUMDOC as 'Number',
forn.Nome as 'SupplierName',
cab.Data as 'Date',
cab.TERCEIRO as 'Supplier',
cab.TPDOC as 'Document',
tdoc.DESCR as 'DocumentName',
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
cab.ANO as 'EXR',
cab.SERIE as 'SEC',
cab.TPDOC as 'TPD',
cab.NNUMDOC as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as ExternalDoc
,'' as Barcode
from DOCGCCAB cab WITH(NOLOCK)
join FORNEC forn WITH(NOLOCK) ON forn.CODIGO = cab.TERCEIRO
join TPDOC tdoc WITH(NOLOCK) on tdoc.CODIGO = cab.TPDOC
left join u_Kapps_DossierLin WITH(NOLOCK) on (u_Kapps_DossierLin.StampBo = (cast(cab.SERIE AS VARCHAR(20)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))) 
and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
where cab.TPFSTC = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Lines]'))
DROP view [dbo].[v_Kapps_Reception_Lines]
GO
CREATE view [dbo].[v_Kapps_Reception_Lines] as
Select distinct 
cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.NUMLINHA as varchar(15)) as 'ReceptionLineKey', 
lin.ARTIGO AS 'Article', 
lin.DESCR AS 'Description', 
(Lin.QTDORIG / Lin.FACTOR) AS 'Quantity', 
((Lin.QTDORIG / Lin.FACTOR) - (Lin.QUANT/ Lin.FACTOR)) AS 'QuantitySatisfied', 
((Lin.QTDORIG / Lin.FACTOR) - ((Lin.QTDORIG / Lin.FACTOR) - (Lin.QUANT/ Lin.FACTOR))) - 
(SELECT COALESCE(SUM(Qty2), 0) 
FROM dbo.u_Kapps_DossierLin WITH(NOLOCK)
WHERE (Status = 'A') AND (Integrada = 'N') 
AND (CAST(cab.SERIE AS VARCHAR(10)) + '*' + CAST(cab.TPDOC AS VARCHAR(50)) + '*' + CAST(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC AS varchar(10)) = StampBo) 
AND (CAST(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.NUMLINHA AS varchar(15)) = StampBi)) AS 'QuantityPending',
(SELECT COALESCE(SUM(Qty2), 0) FROM dbo.u_Kapps_DossierLin WITH(NOLOCK)
WHERE (Status = 'A') AND (Integrada = 'N') 
AND (CAST(cab.SERIE AS VARCHAR(10)) + '*' + CAST(cab.TPDOC AS VARCHAR(50)) + '*' + CAST(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC AS varchar(10)) = StampBo) 
AND (CAST(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.NUMLINHA AS varchar(15)) = StampBi)) AS QuantityPicked, Art.UNBASE AS BaseUnit, lin.UNIDADE AS 'BusyUnit', 
CASE WHEN Art.UNBASE = Lin.Unidade THEN 1 ELSE lin.Factor END AS 'ConversionFator', 
lin.ARMAZEM AS 'Warehouse', 
cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)) as 'ReceptionKey', 
lin.NUMLINHA AS 'OriginalLineNumber', 
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
cab.ANO AS 'EXR', 
cab.SERIE AS 'SEC', 
cab.TPDOC AS 'TPD', 
cab.NNUMDOC AS 'NDC', 
'' AS Filter1, 
'' AS Filter2, 
'' AS Filter3, 
'' AS Filter4, 
'' AS Filter5
,'' as Location											--A Confirmar
,'' as Lot												--A Confirmar
FROM dbo.DOCGCLIN AS lin WITH(NOLOCK) 
INNER JOIN dbo.DOCGCCAB AS cab WITH(NOLOCK) ON cab.SERIE = lin.SERIE and cab.TPDOC = lin.TPDOCUM  and cab.ANO = lin.ANO and cab.NNUMDOC = lin.NNUMDOC 
LEFT JOIN dbo.ARTIGOS AS Art WITH(NOLOCK) ON Art.CODIGO = lin.ARTIGO
WHERE (cab.TPFSTC = 0)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Units]'))
DROP view [dbo].[v_Kapps_Units]
GO
CREATE view [dbo].[v_Kapps_Units] as 
  SELECT distinct art.CODIGO as 'Code', art.UNBASE as 'Unit', 1 as 'Factor' FROM ARTIGOS art WITH(NOLOCK) WHERE art.INACTIVO = 0
  UNION ALL
  SELECT distinct art.CODIGO as 'Code', art.UNEMB as 'Unit', ART.FACTEMB as 'Factor' FROM ARTIGOS art WITH(NOLOCK) WHERE art.INACTIVO = 0 AND art.UNEMB <> '' AND art.UNEMB <> art.UNBASE
  UNION ALL
  SELECT distinct art.CODIGO as 'Code', art.UNTRANS as 'Unit', ART.FACTTRA as 'Factor' FROM ARTIGOS art WITH(NOLOCK) WHERE art.INACTIVO = 0 AND art.UNTRANS <> ''  AND art.UNTRANS <> art.UNBASE
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
, cast(0 as int) AS LocationType						-- 1(Localizações do tipo Receção), 2(Localizações do tipo expedição)
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
FROM u_Kapps_StockDocs stk WITH(NOLOCK)
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
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers_DeliveryLocations]'))
DROP view [dbo].[v_Kapps_Customers_DeliveryLocations]
GO
CREATE view [dbo].[v_Kapps_Customers_DeliveryLocations] as 
select 
mor.CDMorada AS DeliveryCode,
cli.CODIGO AS ClientCode,
cli.Nome AS Name,
mor.Morada AS Address1,
mor.Morada2 AS Address2,
mor.Local AS City,
mor.CDPostal AS PostalCode,
'' AS PostalCodeAddress,
'' AS AreaCode,
mor.PAÍS AS Country,
'' AS CountryName
from Moradas mor WITH(NOLOCK)
left join Clientes cli WITH(NOLOCK) ON mor.TPTERC=2 and mor.TERCEIRO=cli.CODIGO
where cli.INACTIVO = 0
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
cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)) as 'PickingKey',
cab.NNUMDOC as 'Number',
cli.Nome as 'CustomerName',
cab.Data as 'Date',
cab.TERCEIRO as 'Customer',
cab.TPDOC as 'Document',
tdoc.DESCR as 'DocumentName',
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
cab.ANO as 'EXR',
cab.SERIE as 'SEC',
cab.TPDOC as 'TPD',
cab.NNUMDOC as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.TERCEIRO as DeliveryCustomer
,cab.ONDEENTR as DeliveryCode
,'' as OriginWarehouse
,'' as TransitWarehouse
,'' as DestinationWarehouse
,'' as Barcode
from DOCGCCAB cab WITH(NOLOCK)
join Clientes cli WITH(NOLOCK) ON cli.CODIGO = cab.TERCEIRO
join TPDOC tdoc WITH(NOLOCK) on tdoc.CODIGO = cab.TPDOC
left join u_Kapps_DossierLin WITH(NOLOCK) on (u_Kapps_DossierLin.StampBo = (cast(cab.SERIE AS VARCHAR(20)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))) 
and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
where cab.aprovado = 1 and cab.TPFSTC = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Lines]'))
DROP view [dbo].[v_Kapps_PickTransf_Lines]
GO
CREATE view [dbo].[v_Kapps_PickTransf_Lines] as
Select 
cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PickingLineKey',
lin.Artigo as 'Article',
Lin.DESCR as 'Description',
(Lin.QTDORIG / Lin.FACTOR) AS 'Quantity', 
((Lin.QTDORIG / Lin.FACTOR) - (Lin.QUANT/ Lin.FACTOR)) AS 'QuantitySatisfied', 
((Lin.QTDORIG / Lin.FACTOR) - ((Lin.QTDORIG / Lin.FACTOR) - (Lin.QUANT/ Lin.FACTOR))) -  
       (
       select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) 
       from u_Kapps_DossierLin WITH(NOLOCK) 
       where u_Kapps_DossierLin.Status = 'A' 
       and u_Kapps_DossierLin.Integrada = 'N' 
       and ((cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))=u_Kapps_DossierLin.stampbo) 
       and ((cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15))) = u_Kapps_DossierLin.Stampbi))                                         as 'QuantityPending',
              (
              select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) 
              from u_Kapps_DossierLin WITH(NOLOCK) 
              where u_Kapps_DossierLin.Status = 'A' 
              and u_Kapps_DossierLin.Integrada = 'N' 
              and ((cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)))=u_Kapps_DossierLin.stampbo) 
              and ((cast(lin.NNUMDOC AS VARCHAR(20)) + '*' + CAST(lin.numlinha as varchar(15))) = u_Kapps_DossierLin.Stampbi))                                         as 'QuantityPicked',
Art.UNBASE AS 'BaseUnit',
lin.UNIDADE as 'BusyUnit',
CASE WHEN Art.UNBASE = Lin.Unidade THEN 1 ELSE lin.Factor END AS 'ConversionFator',
Lin.Armazem as 'Warehouse',
cast(cab.SERIE AS VARCHAR(10)) + '*' + cast(cab.TPDOC AS VARCHAR(50)) + '*' + cast(cab.ANO AS VARCHAR(20)) + '*' + CAST(cab.NNUMDOC as varchar(10)) as 'PickingKey',
lin.numlinha as 'OriginalLineNumber',
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
cab.ANO as 'EXR',
cab.serie as 'SEC',
cab.TPDOC as 'TPD',
cab.NNUMDOC as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,'' as Location											--A Confirmar
,'' as Lot												--A Confirmar
, '' as PalletType
, 0 as PalletMaxUnits
FROM DOCGCLIN lin WITH(NOLOCK) 
JOIN DOCGCCAB cab WITH(NOLOCK) ON cab.SERIE = lin.SERIE and cab.TPDOC = lin.TPDOCUM  and cab.ANO = lin.ANO and cab.NNUMDOC = lin.NNUMDOC
LEFT JOIN Artigos Art WITH(NOLOCK) ON Art.CODIGO = lin.Artigo
where cab.aprovado = 1 and cab.TPFSTC = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Status]'))
DROP view [dbo].[v_Kapps_Stock_Status]
GO
CREATE view [dbo].[v_Kapps_Stock_Status] as 
select '' as Code
, '' AS Description
WHERE 1=0
GO
