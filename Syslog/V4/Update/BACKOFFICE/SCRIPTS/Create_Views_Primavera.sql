IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers]'))
DROP view [dbo].[v_Kapps_Customers]
GO
CREATE view [dbo].[v_Kapps_Customers] as 
select cli.Nome as Name, cli.Cliente as Code
, '' AS 'NameByLabel', '' AS 'AdressByLabel'
, cli.NumContrib AS NIF
, CAST('0' as varchar(1)) as RuleForSSCC	-- Regra a usar na criação de SSCC no packing 0-Um SSCC por caixa	1-Um SSCC por cada combinação de Artigo/Lote/Validade
,Fac_Mor As Adress
,Fac_Local As Adress1
,Fac_Cp As PostalCode
,Fac_Cploc As Area
,CASE WHEN Pais is null then 'PT' else Pais end As Country
,Fac_Tel As Phone
,CAST(0 as numeric(10,6)) as Latitude
,CAST(0 as numeric(10,6)) as Longitude
,Notas as OBS
, 0 AS InternalCustomer						-- 0 Externo, 1 Interno
, cli.Nome As ShortName
from Clientes cli WITH(NOLOCK)
where cli.ClienteAnulado = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Suppliers]'))
DROP view [dbo].[v_Kapps_Suppliers]
GO
CREATE view [dbo].[v_Kapps_Suppliers] as 
select forn.Nome as Name, forn.Fornecedor as Code 
, forn.NumContrib AS NIF
,Morada As Adress
,Morada As Adress1
,Cp As PostalCode
,'' As Area
,CpLoc As Country
,Tel As Phone
,CAST(0 as numeric(10,6)) as Latitude
,CAST(0 as numeric(10,6)) as Longitude
,Notas as OBS
from Fornecedores forn WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Documents]'))
DROP view [dbo].[v_Kapps_Documents]
GO
CREATE view [dbo].[v_Kapps_Documents]  
as
select  DC.Descricao as 'Description', DC.Documento as 'Code', 0 as 'Orders', 0 as 'Sales', 1 as 'Purchase', 0 as 'Internal', 0 as 'Stock', 0 as 'Transfer', 'FL' as Entity,1 as 'ValidaStock', 0 AS 'StockBreak','' as DefaultEntity  from DocumentosCompra  DC WITH(NOLOCK)
union all 
select  DV.Descricao as 'Description', DV.Documento as 'Code', CASE WHEN DV.TipoDocumento = 2 THEN 1 ELSE 0 END  as 'Orders', CASE WHEN DV.TipoDocumento = 4 or DV.TipoDocumento = 3 THEN 1 ELSE 0 END as 'Sales', 0 as 'Purchase', 0 as 'Internal', 0 as 'Stock', 0 as 'Transfer', 'CL' as Entity,1 as 'ValidaStock', 0 AS 'StockBreak','' as DefaultEntity   from DocumentosVenda DV WITH(NOLOCK)
union all 
select  Descricao as 'Description', Documento as 'Code', 0 as 'Orders', 0 as 'Sales', 0 as 'Purchase', 1 as 'Internal', 0 as 'Stock', 0 as 'Transfer', CASE WHEN CLIENTES = 1 THEN 'CL' WHEN FORNECEDORES = '1' THEN 'FL' ELSE '' END as Entity,1 as 'ValidaStock', 0 AS 'StockBreak','' as DefaultEntity  FROM DocumentosInternos DI WITH(NOLOCK)
union all 
select  Descricao as 'Description', Documento as 'Code', 0 as 'Orders', 0 as 'Sales', 0 as 'Purchase', 0 as 'Internal', CASE WHEN DS.TipoDocumento <> 3 THEN 1 ELSE 0 END as 'Stock', CASE WHEN DS.TipoDocumento = 3 THEN 1 ELSE 0 END as 'Transfer', '' as Entity,1 as 'ValidaStock', CASE WHEN TipoDocumento=9 THEN 1 ELSE 0 END as 'StockBreak','' as DefaultEntity from DocumentosStk DS WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Warehouses]'))
DROP view [dbo].[v_Kapps_Warehouses]
GO
CREATE view [dbo].[v_Kapps_Warehouses] as 
select arm.Descricao as Description, arm.Armazem as Code
, cast(1 as bit) AS UseLocations						-- (1-Sim) (0-Não)
, arm.Armazem AS DefaultLocation
from Armazens arm WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Articles]'))
DROP view [dbo].[v_Kapps_Articles]
GO
CREATE view [dbo].[v_Kapps_Articles] as 
select art.Descricao as 'Description', art.Artigo as 'Code', art.CodBarras as 'Barcode',
art.TratamentoLotes as 'UseLots', case when art.TratamentoSeries = 1 then cast(1 as int) else cast(0 as int) end as 'UseSerialNumber',
art.UnidadeBase as 'BaseUnit', art.Familia as 'Family', CASE WHEN art.MovStock = 'S' THEN 1 ELSE 0 END AS 'MovStock',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5', '' AS 'GTIN'
, art.ArmazemSugestao AS DefaultWarehouse
, art.LocalizacaoSugestao AS DefaultLocation
, cast(1 as bit) AS UseLocations						-- (1-Sim) (0-Não)
, art.UnidadeVenda AS SellUnit
, art.UnidadeCompra AS BuyUnit
, CASE 
	WHEN LoteFormulaSaidas=1 and LoteSaidas=3 THEN 1
	WHEN LoteFormulaSaidas=1 and LoteSaidas=1 THEN 2
	WHEN LoteFormulaSaidas=1 and LoteSaidas=4 THEN 3
	ELSE 0 END as LoteControlOut						-- 0-Manual 1-FIFO, 2-FEFO, 3-LIFO
, 1 as UseExpirationDate
, CAST(0 as bit) as UseWeight							-- (1-Sim) (0-Não)
, 0 AS StoreInNrDays									-- Nº de dias minimo de validade na receção (excepto se existir regra a contrariar em [Validades mínimas])
, 0 AS StoreOutNrDays									-- Nº de dias minimo de validade na expedição (excepto se existir regra a contrariar em [Validades mínimas])
, CAST(0 as int) AS BoxMaxQuantity
from Artigo art WITH(NOLOCK)
where art.ArtigoAnulado = 0 and art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Barcodes]'))
DROP view [dbo].[v_Kapps_Barcodes]
GO
CREATE view [dbo].[v_Kapps_Barcodes] as 
select cb.Artigo as Code, cb.CodBarras as Barcode, cb.Unidade as Unit, CAST(1 as int) as Quantity
from ArtigoCodBarras cb WITH(NOLOCK)
JOIN Artigo art WITH(NOLOCK) on art.Artigo = cb.Artigo
where art.ArtigoAnulado = 0
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock]'))
DROP view [dbo].[v_Kapps_Stock]
GO
CREATE view [dbo].[v_Kapps_Stock] as 
select sa.Artigo as Article, sa.Armazem as Warehouse, sa.StkActual as Stock
, sa.Localizacao AS Location
, CASE WHEN sa.Lote <> '<L01>' THEN sa.Lote ELSE '' END AS Lote
, sa.StkActual-sa.QtReservada as AvailableStock
from ArtigoArmazem sa WITH(NOLOCK)
join Artigo art WITH(NOLOCK) on art.Artigo = sa.Artigo
where art.ArtigoAnulado = 0 and art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Lots]'))
DROP view [dbo].[v_Kapps_Lots]
GO
CREATE view [dbo].[v_Kapps_Lots] as 
select lot.Lote as Lot
, lot.Artigo as Article
, lot.Validade as ExpirationDate
, lot.DataFabrico as ProductionDate
, lot.Activo as Actif
from ArtigoLote lot WITH(NOLOCK)
join Artigo art WITH(NOLOCK) on art.Artigo = lot.Artigo
where art.ArtigoAnulado = 0 and art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_SerialNumbers]'))
DROP view [dbo].[v_Kapps_SerialNumbers]
GO
CREATE view [dbo].[v_Kapps_SerialNumbers] as 
select ans.NumSerie as SerialNumber, ans.Artigo as Article, ans.Armazem as Warehouse
from ArtigoNumSerie ans WITH(NOLOCK)
join Artigo art WITH(NOLOCK) on art.Artigo = ans.Artigo
where art.ArtigoAnulado = 0 and art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Families]'))
DROP view [dbo].[v_Kapps_Families]
GO
CREATE view [dbo].[v_Kapps_Families] as 
select Descricao as 'Description' ,Familia as 'Code' from Familias WITH(NOLOCK) 
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Documents]'))
DROP view [dbo].[v_Kapps_Picking_Documents]
GO
CREATE view [dbo].[v_Kapps_Picking_Documents]
as 
select distinct 
CAST(cab.ID as varchar(36)) as 'PickingKey',
cab.NumDoc as 'Number',
cab.Nome as 'CustomerName',
cab.Data as 'Date',
cab.Entidade as 'Customer',
cab.TipoDoc as 'Document',
tdoc.Descricao as 'DocumentName',
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
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.EntidadeEntrega AS DeliveryCustomer
,cab.MoradaAltEntrega AS DeliveryCode
,'' as Barcode
from CabecDoc cab WITH(NOLOCK)
join Clientes cli WITH(NOLOCK) ON cli.Cliente = cab.Entidade
join DocumentosVenda tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
join CabecDocStatus docs WITH(NOLOCK) on cab.Id = docs.IdCabecDoc 
left join u_Kapps_DossierLin WITH(NOLOCK) on (u_Kapps_DossierLin.StampBo = cab.ID) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
where docs.Anulado = 0
and docs.Fechado = 0
and docs.Estado = 'P'  -- Mostra apenas os documentos pendentes, comentar esta linha se for necessário mostrar todos
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Lines]'))
DROP view [dbo].[v_Kapps_Picking_Lines]
GO
CREATE view [dbo].[v_Kapps_Picking_Lines] as
select distinct 
CAST(lin.ID AS VARCHAR(36)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PickingLineKey',
lin.Artigo as 'Article',
lin.Descricao as 'Description',
lin.Quantidade as 'Quantity',
(SELECT COALESCE(SUM(Ltr.QuantTrans),0) FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID) as 'QuantitySatisfied',
lin.Quantidade - ((SELECT COALESCE(SUM(Ltr.QuantTrans),0) FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID) + (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and (cast(lin.IdCabecDoc as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi))) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and (cast(lin.IdCabecDoc as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.UnidadeBase AS 'BaseUnit',
lin.Unidade as 'BusyUnit',
CASE WHEN Art.UnidadeBase = lin.Unidade THEN 1 ELSE COALESCE(ARTUND.FactorConversao, uc.FactorConversao) END AS 'ConversionFator',
lin.Armazem as 'Warehouse',
CAST(lin.IdCabecDoc as varchar(36)) as 'PickingKey',
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
'' as 'EXR',
cab.serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, lin.Localizacao AS Location
, CASE WHEN lin.Lote='<L01>' then '' ELSE lin.Lote END AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM LinhasDoc lin WITH(NOLOCK) 
JOIN CabecDoc cab WITH(NOLOCK) ON cab.Id = lin.IdCabecDoc
JOIN Artigo Art WITH(NOLOCK) ON Art.Artigo = lin.Artigo 
LEFT JOIN ArtigoUnidades ARTUND WITH(NOLOCK) on ARTUND.Artigo = lin.Artigo AND ARTUND.UnidadeOrigem = lin.Unidade AND ARTUND.UnidadeDestino = Art.UnidadeBase
LEFT JOIN LinhasDocStatus LinSta WITH(NOLOCK) ON LinSta.IdLinhasDoc = lin.Id
LEFT JOIN UnidadesConversao uc WITH(NOLOCK) on uc.UnidadeOrigem=lin.Unidade and uc.UnidadeDestino=Art.UnidadeBase
WHERE LinSta.Fechado = 0 and Art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Documents]'))
DROP view [dbo].[v_Kapps_Packing_Documents]
GO
CREATE view [dbo].[v_Kapps_Packing_Documents]
as 
select distinct 
CAST(cab.ID as varchar(36)) as 'PackingKey',
cab.NumDoc as 'Number',
cab.Nome as 'CustomerName',
cab.Data as 'Date',
cab.Entidade as 'Customer',
cab.TipoDoc as 'Document',
tdoc.Descricao as 'DocumentName',
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
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5','' AS 'PurchaseOrder', '' AS 'MySupplierNumber'
,cab.EntidadeEntrega AS DeliveryCustomer
,cab.MoradaAltEntrega AS DeliveryCode
,'' as Barcode
from CabecDoc cab WITH(NOLOCK)
join Clientes cli WITH(NOLOCK) ON cli.Cliente = cab.Entidade
join DocumentosVenda tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
join CabecDocStatus docs WITH(NOLOCK) on cab.Id = docs.IdCabecDoc 
left join u_Kapps_DossierLin WITH(NOLOCK) on (u_Kapps_DossierLin.StampBo = cab.ID) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
where docs.Anulado = 0
and docs.Fechado = 0
and docs.Estado = 'P'  -- Mostra apenas os documentos pendentes, comentar esta linha se for necessário mostrar todos
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Lines]'))
DROP view [dbo].[v_Kapps_Packing_Lines]
GO
CREATE view [dbo].[v_Kapps_Packing_Lines] as
select distinct 
CAST(lin.ID AS VARCHAR(36)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PackingLineKey',
lin.Artigo as 'Article',
lin.Descricao as 'Description',
lin.Quantidade as 'Quantity',
(SELECT COALESCE(SUM(Ltr.QuantTrans),0) FROM LinhasDocTrans Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID) as 'QuantitySatisfied',
lin.Quantidade - ((SELECT COALESCE(SUM(Ltr.QuantTrans),0) FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID) + (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and (cast(lin.IdCabecDoc as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi))) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and (cast(lin.IdCabecDoc as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.UnidadeBase AS 'BaseUnit',
lin.Unidade as 'BusyUnit',
CASE WHEN Art.UnidadeBase = lin.Unidade THEN 1 ELSE COALESCE(ARTUND.FactorConversao, uc.FactorConversao) END AS 'ConversionFator',
lin.Armazem as 'Warehouse',
CAST(lin.IdCabecDoc as varchar(36)) as 'PackingKey',
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
'' as 'EXR',
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, lin.Localizacao AS Location
, CASE WHEN lin.Lote='<L01>' then '' ELSE lin.Lote END AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM LinhasDoc lin WITH(NOLOCK) 
JOIN CabecDoc cab WITH(NOLOCK) on cab.Id = lin.IdCabecDoc
JOIN Artigo Art WITH(NOLOCK) ON Art.Artigo = lin.Artigo 
LEFT JOIN ArtigoUnidades ARTUND WITH(NOLOCK) on ARTUND.Artigo = lin.Artigo AND ARTUND.UnidadeOrigem = lin.Unidade AND ARTUND.UnidadeDestino = Art.UnidadeBase
LEFT JOIN LinhasDocStatus LinSta WITH(NOLOCK) ON LinSta.IdLinhasDoc = lin.Id
LEFT JOIN UnidadesConversao uc WITH(NOLOCK) on uc.UnidadeOrigem=lin.Unidade and uc.UnidadeDestino=Art.UnidadeBase
WHERE LinSta.Fechado = 0 and Art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Documents]'))
DROP view [dbo].[v_Kapps_Reception_Documents]
GO
CREATE view [dbo].[v_Kapps_Reception_Documents]
as 
select distinct
CAST(cab.ID as varchar(36)) as 'ReceptionKey',
cab.NumDoc as 'Number',
cab.Nome as 'SupplierName',
cab.DataDoc as 'Date',
cab.Entidade as 'Supplier',
cab.TipoDoc as 'Document',
tdoc.Descricao as 'DocumentName',
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
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as ExternalDoc
,'' as Barcode
from CabecCompras cab WITH(NOLOCK)
join Fornecedores forn WITH(NOLOCK) ON forn.Fornecedor = cab.Entidade
join DocumentosCompra tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
join CabecComprasStatus docs WITH(NOLOCK) on cab.Id = docs.IdCabecCompras 
left join u_Kapps_DossierLin WITH(NOLOCK) on (u_Kapps_DossierLin.StampBo = cab.ID) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
where docs.Anulado = 0
and docs.Fechado = 0
and docs.Estado = 'P'  -- Mostra apenas os documentos pendentes, comentar esta linha se for necessário mostrar todos
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Lines]'))
DROP view [dbo].[v_Kapps_Reception_Lines]
GO
CREATE view [dbo].[v_Kapps_Reception_Lines] as
select distinct 
CAST(lin.ID AS VARCHAR(36)) + '*' + CAST(lin.numlinha as varchar(15)) as 'ReceptionLineKey',
lin.Artigo as 'Article',
lin.Descricao as 'Description',
ABS(lin.Quantidade) as 'Quantity',
(SELECT COALESCE(ABS(SUM(Ltr.QuantTrans)),0) FROM LinhasComprasTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasComprasOrigem = lin.ID) as 'QuantitySatisfied',
ABS(lin.Quantidade - ((SELECT COALESCE(SUM(Ltr.QuantTrans),0) FROM LinhasComprasTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasComprasOrigem = lin.ID) + (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and (cast(lin.IdCabecCompras as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi)))) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and (cast(lin.IdCabecCompras as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.UnidadeBase AS 'BaseUnit',
lin.Unidade as 'BusyUnit',
CASE WHEN Art.UnidadeBase = lin.Unidade THEN 1 ELSE COALESCE(ARTUND.FactorConversao, uc.FactorConversao) END AS 'ConversionFator',
lin.Armazem as 'Warehouse',
cast(lin.IdCabecCompras as varchar(36)) as 'ReceptionKey',
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
'' as 'EXR',
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, lin.Localizacao AS Location
, CASE WHEN lin.Lote='<L01>' then '' ELSE lin.Lote END AS Lot
FROM LinhasCompras lin WITH(NOLOCK) 
JOIN CabecCompras cab WITH(NOLOCK) on cab.Id = lin.IdCabecCompras
JOIN Artigo Art WITH(NOLOCK) ON Art.Artigo = lin.Artigo 
LEFT JOIN ArtigoUnidades ARTUND WITH(NOLOCK) on ARTUND.Artigo = lin.Artigo AND ARTUND.UnidadeOrigem = lin.Unidade AND ARTUND.UnidadeDestino = Art.UnidadeBase
LEFT JOIN LinhasComprasStatus LinSta WITH(NOLOCK) ON LinSta.IdLinhasCompras = lin.Id
LEFT JOIN UnidadesConversao uc WITH(NOLOCK) on uc.UnidadeOrigem=lin.Unidade and uc.UnidadeDestino=Art.UnidadeBase
WHERE LinSta.Fechado = 0 and Art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Units]'))
DROP view [dbo].[v_Kapps_Units]
GO
CREATE view [dbo].[v_Kapps_Units] as 
SELECT distinct art.artigo as 'Code', art.unidadebase as 'Unit', 1 as 'Factor' FROM artigo art WITH(NOLOCK) WHERE art.ArtigoAnulado = 0 and art.TratamentoDim<>1
UNION ALL
SELECT distinct art.artigo as 'Code', art.UnidadeVenda as 'Unit', ARTUND.FactorConversao  as 'Factor'
FROM artigo art WITH(NOLOCK) 
JOIN ArtigoUnidades ARTUND WITH(NOLOCK) ON ARTUND.Artigo = art.Artigo and ARTUND.UnidadeOrigem = art.UnidadeVenda and ARTUND.UnidadeDestino = art.UnidadeBase
WHERE art.ArtigoAnulado = 0 and art.TratamentoDim<>1
UNION ALL
SELECT distinct art.artigo as 'Code', art.UnidadeCompra as 'Unit', ARTUND.FactorConversao  as 'Factor'
FROM artigo art WITH(NOLOCK) 
JOIN ArtigoUnidades ARTUND WITH(NOLOCK) ON ARTUND.Artigo = art.Artigo and ARTUND.UnidadeOrigem = art.UnidadeCompra and ARTUND.UnidadeDestino = art.UnidadeBase
WHERE art.ArtigoAnulado = 0 and art.TratamentoDim<>1
UNION ALL
SELECT distinct art.artigo as 'Code', ARTUND.UnidadeOrigem 'Unit', ARTUND.FactorConversao  as 'Factor'
FROM artigo art WITH(NOLOCK) 
JOIN ArtigoUnidades ARTUND WITH(NOLOCK) ON ARTUND.Artigo = art.Artigo 
WHERE art.ArtigoAnulado = 0 and (ARTUND.UnidadeOrigem <> art.UnidadeVenda and ARTUND.UnidadeOrigem <> art.UnidadeCompra and ARTUND.UnidadeOrigem <> art.UnidadeBase)
and ARTUND.Unidadedestino = art.unidadebase and art.TratamentoDim<>1
UNION ALL
SELECT distinct art.artigo as 'Code', UC.UnidadeOrigem as 'Unit', UC.FactorConversao as 'Factor'
FROM Artigo art WITH(NOLOCK) 
LEFT JOIN UnidadesConversao UC WITH(NOLOCK) ON UC.UnidadeOrigem <> art.Unidadebase
WHERE UC.UnidadeOrigem NOT IN
	(
	SELECT distinct ARTUND.UnidadeOrigem 'Unit' FROM ArtigoUnidades ARTUND WITH(NOLOCK) 
	WHERE ARTUND.Artigo = art.Artigo  and ARTUND.FactorConversao > 0 and ARTUND.UnidadeDestino = art.UnidadeBase
	)
AND uc.FactorConversao > 0 and (UC.UnidadeOrigem = art.UnidadeVenda or UC.UnidadeOrigem = art.UnidadeCompra) and art.TratamentoDim<>1
UNION 
SELECT cb.Artigo as Code, cb.Unidade as Unit,
COALESCE((select COALESCE(uc.FactorConversao, 1) from UnidadesConversao uc WITH(NOLOCK) WHERE uc.UnidadeOrigem = cb.Unidade and uc.UnidadeDestino = art.UnidadeBase),1) as Quantity
FROM ArtigoCodBarras cb WITH(NOLOCK)
JOIN Artigo art WITH(NOLOCK) on art.Artigo = cb.Artigo
WHERE art.ArtigoAnulado = 0
and cb.Unidade<>art.UnidadeBase
and COALESCE(cb.Unidade,'')<>''
and cb.Unidade not in
	(
	SELECT ARTUND.UnidadeOrigem 'Unit' 
	FROM ArtigoUnidades ARTUND WITH(NOLOCK) 
	WHERE ARTUND.Artigo = art.Artigo and ARTUND.FactorConversao > 0 and ARTUND.UnidadeDestino = art.UnidadeBase
	)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_WarehousesLocations]'))
DROP view [dbo].[v_Kapps_WarehousesLocations]
GO
CREATE view [dbo].[v_Kapps_WarehousesLocations] as 
select 
loc.Armazem AS Warehouse
, '' AS ZoneLocation
, loc.Localizacao AS Location
, loc.Descricao AS Description
, loc.Activa AS LocActiva
, cast(1 as bit) AS Checkdigit
, cast(0 as int) AS LocationType						-- 1(Localizações do tipo Receção), 2(Localizações do tipo expedição)
from ArmazemLocalizacoes loc WITH(NOLOCK)
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Documents]'))
DROP view [dbo].[v_Kapps_Stock_Documents]
GO
CREATE view [dbo].[v_Kapps_Stock_Documents]
as 
select distinct 
CAST(cab.id as varchar(255)) as 'CabKey',		-- Chave unica
cab.Data as 'Date',		-- Data e Hora de criação
cab.Armazem as 'Warehouse',
cab.Responsavel as 'DocumentName',	-- Descrição da contagem
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
from CabecInventarios cab WITH(NOLOCK)
where cab.Estado=0

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
stk.ZoneLocation,
stk.Location,
stk.Stamp as InternalStampDoc
FROM u_Kapps_StockDocs stk WITH(NOLOCK)
WHERE stk.Syncr<>'S'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Lines]'))
DROP view [dbo].[v_Kapps_Stock_Lines]
GO
CREATE view [dbo].[v_Kapps_Stock_Lines] as
select distinct 
CASE WHEN LinDet.ID is null THEN lin.Id ELSE CAST(LinDet.ID AS VARCHAR(255)) + '*' + CAST(LinDet.NumLinha as varchar(15)) END as 'LineKey', -- Chave Unica
LinDet.NumLinha as 'OrigLineNumber',
lin.Artigo as 'Article',
art.Descricao as 'Description',
LinDet.QtdPreparacao as 'Quantity',
(select COALESCE(sum(u_Kapps_StockLines.Qty),0) from u_Kapps_StockLines WITH(NOLOCK) where u_Kapps_StockLines.Status = 'A' and u_Kapps_StockLines.Syncr = 'N'  and (u_Kapps_StockLines.OrigStampHeader=cast(lin.IdCabecInventarios as varchar(255))) and (u_Kapps_StockLines.OrigStampLin=CAST(linDet.ID AS VARCHAR(255)) + '*' + CAST(LinDet.numlinha as varchar(15)) )) as 'QuantityPicked', 
lin.UnidadeBase as 'BaseUnit',
cab.Armazem as 'Warehouse',
LinDet.Localizacao AS Location,
CASE WHEN LinDet.Lote='<L01>' then '' ELSE COALESCE(LinDet.Lote,'') END AS Lot,
CAST(lin.IdCabecInventarios as varchar(255)) as 'CabKey',
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
FROM LinhasInventarios lin WITH(NOLOCK) 
JOIN CabecInventarios cab WITH(NOLOCK) on cab.Id = lin.IdCabecInventarios
JOIN Artigo Art WITH(NOLOCK) ON Art.Artigo = lin.Artigo 
LEFT JOIN ArtigoUnidades ARTUND WITH(NOLOCK) on ARTUND.Artigo = lin.Artigo AND ARTUND.UnidadeOrigem = lin.UnidadeBase AND ARTUND.UnidadeDestino = Art.UnidadeBase
LEFT JOIN LinhasInventariosDetalhe LinDet WITH(NOLOCK) ON lin.Id=LinDet.IdLinhasInventarios
WHERE cab.Estado=0 and art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers_DeliveryLocations]'))
DROP view [dbo].[v_Kapps_Customers_DeliveryLocations]
GO
CREATE view [dbo].[v_Kapps_Customers_DeliveryLocations] as 
select 
mor.MoradaAlternativa AS DeliveryCode,
mor.Cliente AS ClientCode,
cli.Nome AS Name,
mor.Morada AS Address1,
mor.Morada2 AS Address2,
mor.Localidade AS City,
mor.Cp AS PostalCode,
CpLocalidade AS PostalCodeAddress,
mor.Distrito AS AreaCode,
mor.Pais AS Country,
pais.Descricao AS CountryName
from MoradasAlternativasClientes mor WITH(NOLOCK)
left join Clientes cli WITH(NOLOCK) ON mor.Cliente=cli.Cliente
left join Paises pais WITH(NOLOCK) on pais.Pais=mor.Pais
where cli.ClienteAnulado = 0
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
CAST(cab.ID as varchar(36)) as 'PickingKey',
cab.NumDoc as 'Number',
cab.Nome as 'CustomerName',
cab.Data as 'Date',
cab.Entidade as 'Customer',
cab.TipoDoc as 'Document',
tdoc.Descricao as 'DocumentName',
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
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.EntidadeEntrega AS DeliveryCustomer
,cab.MoradaAltEntrega AS DeliveryCode
,'' as OriginWarehouse
,'' as TransitWarehouse
,'' as DestinationWarehouse
--
-- comentar as linhas anteriores e descomentar as linhas seguintes após ter criado os campos de utilizador 
--
--,cab.CDU_ArmazemOrigem as OriginWarehouse
--,cab.CDU_ArmazemTransito as TransitWarehouse
--,cab.CDU_ArmazemDestino as DestinationWarehouse
,'' as Barcode
from CabecDoc cab WITH(NOLOCK)
join Clientes cli WITH(NOLOCK) ON cli.Cliente = cab.Entidade
join DocumentosVenda tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
join CabecDocStatus docs WITH(NOLOCK) on cab.Id = docs.IdCabecDoc 
where docs.Anulado = 0
and docs.Fechado = 0
and docs.Estado = 'P'  -- Mostra apenas os documentos pendentes, comentar esta linha se for necessário mostrar todos
--and COALESCE(cab.CDU_ArmazemOrigem,'')<>'' 							--retirar comentario após ter criado os campos de utilizador 

UNION ALL

select distinct 
CAST(cab.ID as varchar(36)) as 'PickingKey',
cab.NumDoc as 'Number',
cab.Nome as 'CustomerName',
CAST(cab.Data as Date) as 'Date',
cab.Entidade as 'Customer',
cab.TipoDoc as 'Document',
tdoc.Descricao as 'DocumentName',
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
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,Entidade AS DeliveryCustomer 
,cab.MoradaAltEntrega AS DeliveryCode
--
,'' as OriginWarehouse
,'' as TransitWarehouse
,'' as DestinationWarehouse
--
-- comentar as linhas anteriores e descomentar as linhas seguintes após ter criado os campos de utilizador 
--
--,cab.CDU_ArmazemOrigem as OriginWarehouse
--,cab.CDU_ArmazemTransito as TransitWarehouse
--,cab.CDU_ArmazemDestino as DestinationWarehouse
--
,'' as Barcode
from CabecInternos cab WITH(NOLOCK)
left join Clientes cli WITH(NOLOCK) ON cli.Cliente = cab.Entidade
join DocumentosInternos tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
where tdoc.TipoDocumento =1
--and COALESCE(cab.CDU_ArmazemOrigem,'')<>'' 							--retirar comentario após ter criado os campos de utilizador 

UNION ALL

select 
CAST(cab.ID as varchar(36)) as 'PickingKey',
cab.NumDoc as 'Number',
COALESCE(cli.Nome,'') as 'CustomerName',
cab.Data as 'Date',
COALESCE(cab.Entidade,'') as 'Customer',
cab.TipoDoc as 'Document',
tdoc.Descricao as 'DocumentName',
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
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,'' AS DeliveryCustomer
,'' AS DeliveryCode
,'' as OriginWarehouse
,'' as TransitWarehouse
,'' as DestinationWarehouse
--
-- comentar as linhas anteriores e descomentar as linhas seguintes após ter criado os campos de utilizador 
--
--,cab.CDU_ArmazemOrigem as OriginWarehouse
--,cab.CDU_ArmazemTransito as TransitWarehouse
--,cab.CDU_ArmazemDestino as DestinationWarehouse
,'' as Barcode
from CabecSTK cab WITH(NOLOCK)
left join Clientes cli WITH(NOLOCK) ON cli.Cliente = cab.Entidade
left join DocumentosStk tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
where tdoc.TipoDocumento=3 
--and COALESCE(cab.CDU_ArmazemOrigem,'')<>'' 							--retirar comentario após ter criado os campos de utilizador 
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Lines]'))
DROP view [dbo].[v_Kapps_PickTransf_Lines]
GO
CREATE view [dbo].[v_Kapps_PickTransf_Lines] as
select distinct 
CAST(lin.ID AS VARCHAR(36)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PickingLineKey',
lin.Artigo as 'Article',
lin.Descricao as 'Description',
ABS(lin.Quantidade) as 'Quantity',
(SELECT COALESCE(SUM(Ltr.QuantTrans),0)
--+COALESCE(lin.CDU_QuantidadeAlternativa, 0) 										-- descomentar a linha após ter criado o campo de utilizador
FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID) as 'QuantitySatisfied',
lin.Quantidade - ((SELECT COALESCE(SUM(Ltr.QuantTrans),0)
--+COALESCE(lin.CDU_QuantidadeAlternativa, 0) 										-- descomentar a linha após ter criado o campo de utilizador
FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID) + (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and (cast(lin.IdCabecDoc as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi))) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and (cast(lin.IdCabecDoc as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.UnidadeBase AS 'BaseUnit',
lin.Unidade as 'BusyUnit',
CASE WHEN Art.UnidadeBase = lin.Unidade THEN 1 ELSE COALESCE(ARTUND.FactorConversao, uc.FactorConversao) END AS 'ConversionFator',
lin.Armazem as 'Warehouse',
CAST(lin.IdCabecDoc as varchar(36)) as 'PickingKey',
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
'' as 'EXR',
cab.serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, lin.Localizacao AS Location
, CASE WHEN lin.Lote='<L01>' then '' ELSE lin.Lote END AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM LinhasDoc lin WITH(NOLOCK) 
JOIN CabecDoc cab WITH(NOLOCK) ON cab.Id = lin.IdCabecDoc
JOIN Artigo Art WITH(NOLOCK) ON Art.Artigo = lin.Artigo 
LEFT JOIN ArtigoUnidades ARTUND WITH(NOLOCK) on ARTUND.Artigo = lin.Artigo AND ARTUND.UnidadeOrigem = lin.Unidade AND ARTUND.UnidadeDestino = Art.UnidadeBase
LEFT JOIN LinhasDocStatus LinSta WITH(NOLOCK) ON LinSta.IdLinhasDoc = lin.Id
LEFT JOIN UnidadesConversao uc WITH(NOLOCK) on uc.UnidadeOrigem=lin.Unidade and uc.UnidadeDestino=Art.UnidadeBase
WHERE LinSta.Fechado = 0 and Art.TratamentoDim<>1

UNION ALL

select distinct 
CAST(lin.ID AS VARCHAR(36)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PickingLineKey',
lin.Artigo as 'Article',
lin.Descricao as 'Description',
ABS(lin.Quantidade) as 'Quantity',
(SELECT COALESCE(SUM(ABS(Ltr.QuantTrans)), 0)  
--+COALESCE(lin.CDU_QuantidadeAlternativa, 0) 										-- descomentar a linha após ter criado o campo de utilizador
FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE ModuloOrigemCopia = 'N' AND Ltr.IdLinhasDocOrigem = lin.ID) as 'QuantitySatisfied',
ABS(lin.Quantidade) - ((SELECT COALESCE(SUM(Ltr.QuantTrans),0)
--+COALESCE(lin.CDU_QuantidadeAlternativa, 0) 										-- descomentar a linha após ter criado o campo de utilizador
FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID) + (select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and (cast(lin.IdCabecInternos as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi))) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'  and (cast(lin.IdCabecInternos as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.UnidadeBase AS 'BaseUnit',
lin.Unidade as 'BusyUnit',
CASE WHEN Art.UnidadeBase = lin.Unidade THEN 1 ELSE COALESCE(ARTUND.FactorConversao, uc.FactorConversao) END AS 'ConversionFator',
lin.Armazem as 'Warehouse',
CAST(lin.IdCabecInternos as varchar(36)) as 'PickingKey',
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
'' as 'EXR',
cab.serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, lin.Localizacao AS Location
, CASE WHEN lin.Lote='<L01>' then '' ELSE lin.Lote END AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM LinhasInternos lin WITH(NOLOCK) 
JOIN CabecInternos cab WITH(NOLOCK) on cab.Id = lin.IdCabecInternos
JOIN Artigo Art WITH(NOLOCK) on Art.Artigo = lin.Artigo 
LEFT JOIN ArtigoUnidades ARTUND WITH(NOLOCK) on ARTUND.Artigo = lin.Artigo AND ARTUND.UnidadeOrigem = lin.Unidade AND ARTUND.UnidadeDestino = Art.UnidadeBase
LEFT JOIN LinhasDocStatus LinSta WITH(NOLOCK) on LinSta.IdLinhasDoc = lin.Id
LEFT JOIN UnidadesConversao uc WITH(NOLOCK) on uc.UnidadeOrigem=lin.Unidade and uc.UnidadeDestino=Art.UnidadeBase
LEFT JOIN DocumentosInternos tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
where tdoc.TipoDocumento =1

UNION ALL

select
CAST(lin.ID AS VARCHAR(36)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PickingLineKey',
lin.Artigo as 'Article',
lin.Descricao as 'Description',
lin.Quantidade as 'Quantity',
0 as 'QuantitySatisfied',
--COALESCE(lin.CDU_QuantidadeAlternativa, 0) as 'QuantitySatisfied', 	-- descomentar a linha e eliminar a linha anterior após ter criado o campo de utilizador
lin.Quantidade - (
--COALESCE(lin.CDU_QuantidadeAlternativa, 0) + 							-- descomentar a linha após ter criado o campo de utilizador
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and (cast(lin.IdCabecOrig as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi))) as 'QuantityPending',
(select COALESCE(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin WITH(NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and (cast(lin.IdCabecOrig as varchar(255))=u_Kapps_DossierLin.stampbo) and (CAST(lin.ID AS VARCHAR(255)) + '*' + CAST(lin.numlinha as varchar(15)) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.UnidadeBase AS 'BaseUnit',
lin.Unidade as 'BusyUnit',
CASE WHEN Art.UnidadeBase = lin.Unidade THEN 1 ELSE ARTUND.FactorConversao END AS 'ConversionFator',
lin.Armazem as 'Warehouse',
CAST(lin.IdCabecOrig as varchar(36)) as 'PickingKey',
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
'' as 'EXR',
cab.serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, lin.Localizacao AS Location
, CASE WHEN lin.Lote='<L01>' then '' ELSE lin.Lote END AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM LinhasSTK lin WITH(NOLOCK) 
JOIN CabecSTK cab WITH(NOLOCK) ON cab.Id = lin.IdCabecOrig
JOIN Artigo Art WITH(NOLOCK) ON Art.Artigo = lin.Artigo 
left join ArtigoUnidades ARTUND WITH(NOLOCK) on ARTUND.Artigo = lin.Artigo AND ARTUND.UnidadeOrigem = lin.Unidade AND ARTUND.UnidadeDestino = Art.UnidadeBase
left join DocumentosStk tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
where tdoc.TipoDocumento=3 and lin.EntradaSaida='E'
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PalletTransf_Documents]'))
DROP view [dbo].[v_Kapps_PalletTransf_Documents]
GO
CREATE view [dbo].[v_Kapps_PalletTransf_Documents]
as 
select distinct 
CAST(cab.ID as varchar(36)) as 'PickingKey',
cab.NumDoc as 'Number',
cab.Nome as 'CustomerName',
cab.Data as 'Date',
cab.Entidade as 'Customer',
cab.TipoDoc as 'Document',
tdoc.Descricao as 'DocumentName',
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
cab.Serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.EntidadeEntrega AS DeliveryCustomer
,cab.MoradaAltEntrega AS DeliveryCode
,'' as Barcode
from CabecDoc cab WITH(NOLOCK)
join Clientes cli WITH(NOLOCK) ON cli.Cliente = cab.Entidade
join DocumentosVenda tdoc WITH(NOLOCK) on tdoc.Documento = cab.TipoDoc
join CabecDocStatus docs WITH(NOLOCK) on cab.Id = docs.IdCabecDoc 
where docs.Anulado = 0
and docs.Fechado = 0
and docs.Estado = 'P'  -- Mostra apenas os documentos pendentes, comentar esta linha se for necessário mostrar todos
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PalletTransf_Lines]'))
DROP view [dbo].[v_Kapps_PalletTransf_Lines]
GO
CREATE view [dbo].[v_Kapps_PalletTransf_Lines] as
select distinct 
CAST(lin.ID AS VARCHAR(36)) + '*' + CAST(lin.numlinha as varchar(15)) as 'PickingLineKey',
lin.Artigo as 'Article',
lin.Descricao as 'Description',
ABS(lin.Quantidade) as 'Quantity',

(SELECT COALESCE(SUM(Ltr.QuantTrans),0)
--+lin.CDU_qttPallet													-- descomentar a linha após ter criado o campo de utilizador
FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID) as 'QuantitySatisfied',

lin.Quantidade - ((SELECT COALESCE(SUM(Ltr.QuantTrans),0) FROM LinhasDocTrans  Ltr WITH(NOLOCK) WHERE Ltr.IdLinhasDocOrigem = lin.ID)
--+ lin.CDU_qttPallet													-- descomentar a linha após ter criado o campo de utilizador
) as 'QuantityPending',

0 as 'QuantityPicked', 
Art.UnidadeBase AS 'BaseUnit',
lin.Unidade as 'BusyUnit',
CASE WHEN Art.UnidadeBase = lin.Unidade THEN 1 ELSE COALESCE(ARTUND.FactorConversao, uc.FactorConversao) END AS 'ConversionFator',
lin.Armazem as 'Warehouse',
CAST(lin.IdCabecDoc as varchar(36)) as 'PickingKey',
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
'' as 'EXR',
cab.serie as 'SEC',
cab.TipoDoc as 'TPD',
cab.NumDoc as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, lin.Localizacao AS Location
, CASE WHEN lin.Lote='<L01>' then '' ELSE lin.Lote END AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM LinhasDoc lin WITH(NOLOCK) 
JOIN CabecDoc cab WITH(NOLOCK) ON cab.Id = lin.IdCabecDoc
JOIN Artigo Art WITH(NOLOCK) ON Art.Artigo = lin.Artigo 
LEFT JOIN ArtigoUnidades ARTUND WITH(NOLOCK) on ARTUND.Artigo = lin.Artigo AND ARTUND.UnidadeOrigem = lin.Unidade AND ARTUND.UnidadeDestino = Art.UnidadeBase
LEFT JOIN LinhasDocStatus LinSta WITH(NOLOCK) ON LinSta.IdLinhasDoc = lin.Id
LEFT JOIN UnidadesConversao uc WITH(NOLOCK) on uc.UnidadeOrigem=lin.Unidade and uc.UnidadeDestino=Art.UnidadeBase
WHERE LinSta.Fechado = 0 and Art.TratamentoDim<>1
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Status]'))
DROP view [dbo].[v_Kapps_Stock_Status]
GO
CREATE view [dbo].[v_Kapps_Stock_Status] as 
select '' as Code
, '' AS Description
WHERE 1=0
GO
