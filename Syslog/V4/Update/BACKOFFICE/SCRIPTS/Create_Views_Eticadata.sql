IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers]'))
DROP view [dbo].[v_Kapps_Customers]
GO
CREATE view [dbo].[v_Kapps_Customers] as 
select cli.strNome as NAME, cli.intCodigo as Code
, '' AS 'NameByLabel', '' AS 'AdressByLabel'
, strNumContrib AS NIF
, CAST('0' as varchar(1)) as RuleForSSCC	-- Regra a usar na criação de SSCC no packing 0-Um SSCC por caixa	1-Um SSCC por cada combinação de Artigo/Lote/Validade
, strMorada_lin1 As Adress
, strMorada_lin2 As Adress1
, strPostal As PostalCode
, strLocalidade As Area
, strdescricao As Country
, strTelefone As Phone
, fltLatitude as Latitude
, fltLongitude as Longitude
, strObs as OBS
, 0 AS InternalCustomer						-- 0 Externo, 1 Interno
, cli.strNome  As ShortName
from Tbl_Clientes cli (NOLOCK)
left join Tbl_Grh_Paises pa (NOLOCK) on  pa.intCodigo = intCodPaisNacionalidade
where (cli.bitInactivo = 0)
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Suppliers]'))
DROP view [dbo].[v_Kapps_Suppliers]
GO
CREATE view [dbo].[v_Kapps_Suppliers] as 
select forn.strNome as NAME, forn.intCodigo as Code
, strNumContrib AS NIF
, strMorada_lin1 As Adress
, strMorada_lin2 As Adress1
, strPostal As PostalCode
, strLocalidade As Area
, strdescricao As Country
, strTelefone As Phone
, fltLatitude as Latitude
, fltLongitude as Longitude
, strObs as OBS
from tbl_fornecedores forn (NOLOCK)
left join Tbl_Grh_Paises pa on  pa.intCodigo = intCountryCodeNationality
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Documents]'))
DROP view [dbo].[v_Kapps_Documents]
GO
CREATE view [dbo].[v_Kapps_Documents]  
as
select  strDescricao as 'Description', 
strAbreviatura as 'Code', 
CASE WHEN (bitDispStocks = 0 and intTpEntidade = 0) THEN 1 ELSE 0 END as 'Orders', 
CASE WHEN (bitDispStocks = 0 and intTpEntidade = 0) THEN 1 ELSE 0 END as 'Sales', 
CASE WHEN (bitDispStocks = 0 and intTpEntidade <> 0) THEN 1 ELSE 0 END  as 'Purchase', 
0 as 'Internal', 
CASE WHEN bitDispStocks = 1 AND intTpMovimento <> 2 THEN 1 ELSE 0 END as 'Stock',
CASE WHEN bitDispStocks = 1 THEN CASE WHEN intTpMovimento = 2 THEN 1 ELSE 0 END ELSE CASE WHEN intTpMovimento = 2 and bitMovimentaStocks=1 then 1 ELSE 0 END END as 'Transfer', 
CASE WHEN (bitDispStocks = 0 and intTpEntidade = 0) THEN 'CL' WHEN (bitDispStocks = 0 and intTpEntidade <> 0) THEN 'FL' WHEN bitDispStocks = 1 THEN CASE WHEN intTpMovimento = 2 THEN '' ELSE 'I' END ELSE 'I' END  as Entity
,1 as 'ValidaStock'
,0 as 'StockBreak'
,'' as DefaultEntity
from Tbl_Tipos_Documentos (NOLOCK)
where intTpEntidade IN (0,2)
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Warehouses]'))
DROP view [dbo].[v_Kapps_Warehouses]
GO
CREATE view [dbo].[v_Kapps_Warehouses] as 
select arm.strDescricao as Description, arm.strCodigo as Code
, arm.bitLocalizacao AS UseLocations					-- (1-Sim) (0-Não)
, '' AS DefaultLocation
from Tbl_Gce_Armazens arm (NOLOCK)
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Articles]'))
DROP view [dbo].[v_Kapps_Articles]
GO
CREATE view [dbo].[v_Kapps_Articles] as 
select art.strDescricao as 'Description', art.strCodigo as 'Code', art.strCodBarras as 'Barcode',
art.bitLotes as 'UseLots', art.bitNumSerie as 'UseSerialNumber',
art.strAbrevMedVnd as 'BaseUnit', ISNULL(arf.strCodFamilia, '') as 'Family', CASE art.bitNaoMovStk WHEN 1 THEN 0 ELSE 1 END as 'MovStock',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5', '' AS 'GTIN'
, '' AS DefaultWarehouse
, '' AS DefaultLocation
, cast(1 as bit) AS UseLocations						-- (1-Sim) (0-Não)
, art.strAbrevMedVnd AS SellUnit
, art.strAbrevMedCmp AS BuyUnit
, 0 as LoteControlOut									-- 0-Manual 1-FIFO, 2-FEFO, 3-LIFO
, 1 as UseExpirationDate
, CAST(0 as bit) as UseWeight							-- (1-Sim) (0-Não)
, 0 AS StoreInNrDays									-- Nº de dias minimo de validade na receção (excepto se existir regra a contrariar em [Validades mínimas])
, 0 AS StoreOutNrDays									-- Nº de dias minimo de validade na expedição (excepto se existir regra a contrariar em [Validades mínimas])
, CAST(0 as int) AS BoxMaxQuantity
from Tbl_Gce_Artigos art (NOLOCK)
left join Tbl_Gce_ArtigosFamilias arf on art.strCodigo=arf.strCodArtigo and arf.strCodTpNivel=(select top 1 strCodigo from Tbl_Gce_Tipos_Familias order by intNivel)
where art.bitInactivo = 0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Barcodes]'))
DROP view [dbo].[v_Kapps_Barcodes]
GO
CREATE view [dbo].[v_Kapps_Barcodes] as 
select bc.strCodArtigo as Code, bc.strCodBarras as Barcode, '' as Unit, bc.fltQuantidade as Quantity
from Tbl_Gce_ArtigosCodigoBarras bc WITH(NOLOCK)
join Tbl_Gce_Artigos art WITH(NOLOCK) on art.strCodigo = bc.strCodArtigo
where art.bitInactivo = 0
UNION ALL
select art.strCodigo, cast(art.intCodInterno as varchar(50)), '' as Unit, -1 as Quantity -- Código interno não sugerir quantidade (-1)
from Tbl_Gce_Artigos art WITH(NOLOCK)
where art.bitInactivo = 0 and art.intCodInterno<>0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock]'))
DROP view [dbo].[v_Kapps_Stock]
GO
CREATE view [dbo].[v_Kapps_Stock] as 
select sa.strCodArtigo as Article, sa.strcodarmazem as Warehouse, sa.fltstockQtd as Stock
, ISNULL(strCodLocalizacao,'') as Location
, strCodLote AS Lote
, sa.fltstockQtd-sa.fltStockReservado as AvailableStock
from Tbl_Gce_ArtigosArmLocalLote sa (NOLOCK)
join Tbl_Gce_Artigos art (NOLOCK) on art.strCodigo = sa.strCodArtigo
where art.bitInactivo = 0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Lots]'))
DROP view [dbo].[v_Kapps_Lots]
GO
CREATE view [dbo].[v_Kapps_Lots] as 
select lot.strCodigo as Lot, lot.strCodArtigo as Article, lot.dtmSaida as ExpirationDate
, lot.dtmEntrada AS ProductionDate
, CAST(1 as bit) as Actif
from Tbl_Gce_ArtigosLotes lot (NOLOCK)
join Tbl_Gce_Artigos art (NOLOCK) on art.strCodigo = lot.strCodArtigo
where art.bitInactivo  = 0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_SerialNumbers]'))
DROP view [dbo].[v_Kapps_SerialNumbers]
GO
CREATE view [dbo].[v_Kapps_SerialNumbers] as 
select ans.strNumSerie1 as SerialNumber, ans.strCodArtigo as Article, ans.strCodArmazem as Warehouse
from Tbl_Gce_ArtigosNumSerie  ans (NOLOCK)
join Tbl_Gce_Artigos art (NOLOCK) on art.strCodigo = ans.strCodArtigo
where art.bitInactivo = 0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Families]'))
DROP view [dbo].[v_Kapps_Families]
GO
CREATE view [dbo].[v_Kapps_Families] as 
select strDescricao as 'Description' ,strCodigo as 'Code' from Tbl_Gce_Familias WITH(NOLOCK) WHERE strCodTpFamilia=(select top 1 strCodigo from Tbl_Gce_Tipos_Familias order by intNivel)
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Documents]'))
DROP view [dbo].[v_Kapps_Picking_Documents]
GO
CREATE view [dbo].[v_Kapps_Picking_Documents]
as 
 select distinct 
(cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9))) as 'PickingKey',
cab.intNumero as 'Number',
cli.strnome as 'CustomerName',
cab.dtmdata as 'Date',
cab.intCodEntidade as 'Customer',
cab.strAbrevTpDoc as 'Document', 
tdoc.strDescricao as 'DocumentName', 
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
cab.strCodExercicio as 'EXR',
cab.strCodSeccao as 'SEC',
cab.strAbrevTpDoc as 'TPD',
cab.intNumero as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.intCodEntidade as DeliveryCustomer
,cab.intDireccao as DeliveryCode
,'' as Barcode
from Mov_Encomenda_Cab cab (NOLOCK)
join Tbl_Clientes cli (NOLOCK) ON cli.intcodigo = cab.intCodEntidade
join Tbl_Tipos_Documentos tdoc (NOLOCK) on tdoc.strAbreviatura = cab.strAbrevTpDoc
left join u_Kapps_DossierLin (NOLOCK) on (u_Kapps_DossierLin.StampBo = (cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9)))) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'
where tdoc.bitdispencomendas = 1
and cab.bitAnulado = 0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Picking_Lines]'))
DROP view [dbo].[v_Kapps_Picking_Lines]
GO
CREATE view [dbo].[v_Kapps_Picking_Lines] as
  Select 
(cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) as 'PickingLineKey', 
lin.strCodArtigo as 'Article', 
Lin.strDescArtigo as 'Description', 
Lin.fltQuantidade as 'Quantity',
(Lin.fltQuantidadeSatisf + Lin.fltQuantidadeAnul) as 'QuantitySatisfied',
Lin.fltQuantidade - ((Lin.fltQuantidadeSatisf + Lin.fltQuantidadeAnul) + (select isnull(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin (NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and ((Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9)))=u_Kapps_DossierLin.stampbo) and ((cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) = u_Kapps_DossierLin.Stampbi)))  as 'QuantityPending',
(select isnull(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin (NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and ((Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9)))=u_Kapps_DossierLin.stampbo) and ((cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.strAbrevMedStk AS 'BaseUnit',
CASE WHEN ISNULL(Art.strAbrevMedVnd,'') <> '' THEN Art.strAbrevMedVnd ELSE Art.strAbrevMedStk END as 'BusyUnit', 
CASE WHEN ISNULL(Art.strAbrevMedVnd,'') = Art.strAbrevMedStk THEN 1 WHEN ISNULL(Art.strAbrevMedVnd,'') <> '' THEN (SELECT uni.fltFactor from Tbl_Gce_UnidadesConversao uni (NOLOCK) where uni.strAbrevUnidade1 = art.strAbrevMedVnd and uni.strAbrevUnidade2 = art.strAbrevMedStk) ELSE 1 END AS 'ConversionFator',
Lin.strCodArmazem as 'Warehouse', 
(Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9))) as 'PickingKey',
Lin.intNumLinhaReserva as 'OriginalLineNumber',
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
Lin.strCodExercicio as 'EXR',
Lin.strCodSeccao as 'SEC',
Lin.strAbrevTpDoc as 'TPD',
Lin.intNumero as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, ISNULL(lin.strCodLocalizacao,'') AS Location
, ISNULL(lin.strCodLote,'') AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM Mov_Encomenda_Lin lin (NOLOCK) 
JOIN Tbl_Gce_Artigos Art (NOLOCK) ON Art.strCodigo = lin.strCodArtigo
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Documents]'))
DROP view [dbo].[v_Kapps_Packing_Documents]
GO
CREATE view [dbo].[v_Kapps_Packing_Documents]
as 
select distinct 
(cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9))) as 'PackingKey',
cab.intNumero as 'Number',
cli.strnome as 'CustomerName',
cab.dtmdata as 'Date',
cab.intCodEntidade as 'Customer',
cab.strAbrevTpDoc as 'Document', 
tdoc.strDescricao as 'DocumentName', 
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
cab.strCodExercicio as 'EXR',
cab.strCodSeccao as 'SEC',
cab.strAbrevTpDoc as 'TPD',
cab.intNumero as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5','' AS 'PurchaseOrder', '' AS 'MySupplierNumber'
,cab.intCodEntidade as DeliveryCustomer
,cab.intDireccao as DeliveryCode
,'' as Barcode
from Mov_Encomenda_Cab cab (NOLOCK)
join Tbl_Clientes cli (NOLOCK) ON cli.intcodigo = cab.intCodEntidade
join Tbl_Tipos_Documentos tdoc (NOLOCK) on tdoc.strAbreviatura = cab.strAbrevTpDoc
left join u_Kapps_DossierLin (NOLOCK) on (u_Kapps_DossierLin.StampBo = (cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9)))) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' 
where tdoc.bitdispencomendas = 1
and cab.bitAnulado = 0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Packing_Lines]'))
DROP view [dbo].[v_Kapps_Packing_Lines]
GO
CREATE view [dbo].[v_Kapps_Packing_Lines] as
  Select 
(cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) as 'PackingLineKey', 
lin.strCodArtigo as 'Article', 
Lin.strDescArtigo as 'Description', 
Lin.fltQuantidade as 'Quantity',
(Lin.fltQuantidadeSatisf + Lin.fltQuantidadeAnul) as 'QuantitySatisfied',
Lin.fltQuantidade - ((Lin.fltQuantidadeSatisf + Lin.fltQuantidadeAnul) + (select isnull(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin (NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and ((Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9)))=u_Kapps_DossierLin.stampbo) and ((cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) = u_Kapps_DossierLin.Stampbi)))  as 'QuantityPending',
(select isnull(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin (NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and ((Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9)))=u_Kapps_DossierLin.stampbo) and ((cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.strAbrevMedStk AS 'BaseUnit',
CASE WHEN ISNULL(Art.strAbrevMedVnd,'') <> '' THEN Art.strAbrevMedVnd ELSE Art.strAbrevMedStk END as 'BusyUnit', 
CASE WHEN ISNULL(Art.strAbrevMedVnd,'') = Art.strAbrevMedStk THEN 1 WHEN ISNULL(Art.strAbrevMedVnd,'') <> '' THEN (SELECT uni.fltFactor from Tbl_Gce_UnidadesConversao uni (NOLOCK) where uni.strAbrevUnidade1 = art.strAbrevMedVnd and uni.strAbrevUnidade2 = art.strAbrevMedStk) ELSE 1 END AS 'ConversionFator',
Lin.strCodArmazem as 'Warehouse', 
(Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9))) as 'PackingKey',
Lin.intNumLinhaReserva as 'OriginalLineNumber',
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
Lin.strCodExercicio as 'EXR',
Lin.strCodSeccao as 'SEC',
Lin.strAbrevTpDoc as 'TPD',
Lin.intNumero as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, ISNULL(lin.strCodLocalizacao,'') AS Location
, ISNULL(lin.strCodLote,'') AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM Mov_Encomenda_Lin lin (NOLOCK) 
JOIN Tbl_Gce_Artigos Art (NOLOCK) ON Art.strCodigo = lin.strCodArtigo
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Documents]'))
DROP view [dbo].[v_Kapps_Reception_Documents]
GO
CREATE view [dbo].[v_Kapps_Reception_Documents]
as 
select distinct
(cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9))) as 'ReceptionKey',
cab.intNumero as 'Number',
cli.strnome as 'SupplierName',
cab.dtmdata as 'Date',
cab.intCodEntidade as 'Supplier',
cab.strAbrevTpDoc as 'Document',
tdoc.strDescricao as 'DocumentName',
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
cab.strCodExercicio as 'EXR',
cab.strCodSeccao as 'SEC',
cab.strAbrevTpDoc as 'TPD',
cab.intNumero as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as ExternalDoc
,'' as Barcode
from Mov_Encomenda_Cab cab (NOLOCK)
join Tbl_Fornecedores cli (NOLOCK) ON cli.intcodigo = cab.intCodEntidade
join Tbl_Tipos_Documentos tdoc (NOLOCK) on tdoc.strAbreviatura = cab.strAbrevTpDoc
left join u_Kapps_DossierLin (NOLOCK) on (u_Kapps_DossierLin.StampBo = (cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9)))) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'
where tdoc.bitdispencomendas = 1
and cab.bitAnulado = 0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Reception_Lines]'))
DROP view [dbo].[v_Kapps_Reception_Lines]
GO
CREATE view [dbo].[v_Kapps_Reception_Lines] as
Select 
(cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) as 'ReceptionLineKey', 
lin.strCodArtigo as 'Article',
Lin.strDescArtigo  as 'Description',
Lin.fltQuantidade  as 'Quantity',
(Lin.fltQuantidadeSatisf + Lin.fltQuantidadeAnul) as 'QuantitySatisfied',
Lin.fltQuantidade - ((Lin.fltQuantidadeSatisf + Lin.fltQuantidadeAnul) + (select isnull(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin (NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and ((Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9)))=u_Kapps_DossierLin.stampbo) and ((cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) = u_Kapps_DossierLin.Stampbi)))  as 'QuantityPending',
(select isnull(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin (NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and ((Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9)))=u_Kapps_DossierLin.stampbo) and ((cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) = u_Kapps_DossierLin.Stampbi))  as 'QuantityPicked', 
Art.strAbrevMedStk AS 'BaseUnit',
CASE WHEN ISNULL(Art.strAbrevMedCmp,'') <> '' THEN Art.strAbrevMedCmp ELSE Art.strAbrevMedStk END as 'BusyUnit', 
CASE WHEN ISNULL(Art.strAbrevMedCmp,'') = Art.strAbrevMedStk THEN 1 WHEN ISNULL(Art.strAbrevMedCmp,'') <> '' THEN (SELECT uni.fltFactor from Tbl_Gce_UnidadesConversao uni (NOLOCK) where uni.strAbrevUnidade1 = art.strAbrevMedCmp and uni.strAbrevUnidade2 = art.strAbrevMedStk) ELSE 1 END AS 'ConversionFator',
Lin.strCodArmazem as 'Warehouse',
(Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9))) as 'ReceptionKey',
Lin.intNumLinhaReserva as 'OriginalLineNumber',
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
Lin.strCodExercicio as 'EXR',
Lin.strCodSeccao as 'SEC',
Lin.strAbrevTpDoc as 'TPD',
Lin.intNumero as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, ISNULL(lin.strCodLocalizacao,'') AS Location
, ISNULL(lin.strCodLote,'') AS Lot
FROM Mov_Encomenda_Lin lin (NOLOCK) 
JOIN Tbl_Gce_Artigos Art (NOLOCK) ON Art.strCodigo = lin.strCodArtigo
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Units]'))
DROP view [dbo].[v_Kapps_Units]
GO
CREATE view [dbo].[v_Kapps_Units] as 
	SELECT distinct art.strCodigo as 'Code', art.strAbrevMedStk as 'Unit', 1 as 'Factor' FROM Tbl_Gce_Artigos art (NOLOCK) WHERE art.bitInactivo = 0
	UNION ALL
	SELECT distinct art.strCodigo as 'Code', art.strAbrevMedVnd as 'Unit', (select uni.fltFactor from Tbl_Gce_UnidadesConversao uni (NOLOCK) where uni.strAbrevUnidade1 = art.strAbrevMedVnd and uni.strAbrevUnidade2 = art.strAbrevMedStk) as 'Factor' FROM Tbl_Gce_Artigos art (NOLOCK) WHERE art.bitInactivo = 0 and art.strAbrevMedVnd <> '' and art.strAbrevMedVnd <> art.strAbrevMedStk
	UNION ALL
	SELECT distinct art.strCodigo as 'Code', art.strAbrevMedCmp as 'Unit', (select uni.fltFactor from Tbl_Gce_UnidadesConversao uni (NOLOCK) where uni.strAbrevUnidade1 = art.strAbrevMedCmp and uni.strAbrevUnidade2 = art.strAbrevMedStk) as 'Factor' FROM Tbl_Gce_Artigos art (NOLOCK) WHERE art.bitInactivo = 0 and art.strAbrevMedCmp <> '' and art.strAbrevMedCmp <> art.strAbrevMedStk
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_WarehousesLocations]'))
DROP view [dbo].[v_Kapps_WarehousesLocations]
GO
CREATE view [dbo].[v_Kapps_WarehousesLocations] as 
select 
 loc.strCodArmazem AS Warehouse
, '' AS ZoneLocation 
,loc.strCodLocalizacao AS Location
,loc.strCodLocalizacao AS Description
,cast(1 as bit) AS LocActiva 
, cast(1 as bit) AS Checkdigit
, cast(0 as int) AS LocationType		-- 1(Localizações do tipo Receção), 2(Localizações do tipo expedição)
from Tbl_Gce_ArmazensLocalizacoes loc
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Documents]'))
DROP view [dbo].[v_Kapps_Stock_Documents]
GO
CREATE view [dbo].[v_Kapps_Stock_Documents]
as 
select distinct 
(cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9))) as 'CabKey', -- Chave unica
cab.dtmData as 'Date',			-- Data e Hora de criação
'' as 'Warehouse',
'' as 'DocumentName',			-- Descrição da contagem
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
cab.strCodExercicio as 'EXR',	-- Exercicio
cab.strCodSeccao as 'SEC',		-- Serie/Secção
cab.strAbrevTpDoc as 'TPD',		-- Tipo Documento
cab.intNumero as 'NDC',			-- Numero de Documento
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5',
'' as DocType,				-- 'C' Cega
'' as ZoneLocation,
'' as Location,
'' as InternalStampDoc
from Mov_Inventario cab WITH(NOLOCK)
where cab.bitAnulado=0 and cab.bitAcertoStkEfectuado=0
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
FROM u_Kapps_StockDocs stk
WHERE stk.Syncr<>'S'
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Lines]'))
DROP view [dbo].[v_Kapps_Stock_Lines]
GO
CREATE view [dbo].[v_Kapps_Stock_Lines] as
Select distinct 
CAST(intNumContagem as varchar(9))+'*'+CAST(intNumLinha as varchar(9)) as 'LineKey', -- Chave Unica
intNumLinha as 'OrigLineNumber',
strCodArtigo as 'Article',
'' as 'Description',
fltQuantidade as 'Quantity',
0 as 'QuantityPicked', 
strAbrevMedida as 'BaseUnit',
ISNULL(strCodArmazem,'') as 'Warehouse',
ISNULL(strCodLocalizacao,'') AS Location,
ISNULL(strCodLote,'') AS Lot,
(strCodSeccao + '*' + strAbrevTpDoc + '*' + strCodExercicio + '*' + CAST(intNumero as varchar(9))) as 'CabKey',
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
strCodExercicio as 'EXR',			-- Exercicio
strCodSeccao as 'SEC',			-- Serie/Secção
strAbrevTpDoc as 'TPD',			-- TipoDocumento
intNumero as 'NDC',			-- Numero Documento
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
FROM Mov_InventarioCont_Lin
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Customers_DeliveryLocations]'))
DROP view [dbo].[v_Kapps_Customers_DeliveryLocations]
GO
CREATE view [dbo].[v_Kapps_Customers_DeliveryLocations] as 
select 
mor.intNumero AS DeliveryCode,
cli.intCodigo AS ClientCode,
cli.strNome AS Name,
mor.strMorada_lin1 AS Address1,
mor.strMorada_lin2 AS Address2,
mor.strLocalidade AS City,
mor.strPostal AS PostalCode,
zon.strDescricao AS PostalCodeAddress,
'' AS AreaCode,
zon.strAbrevPais AS Country,
pai.strdescricao AS CountryName
from Tbl_Direccoes mor WITH(NOLOCK)
left join Tbl_Clientes cli WITH(NOLOCK) ON mor.intCodigo=cli.intCodigo
left join Tbl_SubZonas zon WITH(NOLOCK) ON zon.strAbreviatura=mor.strAbrevSubZona
left join Tbl_Grh_Paises pai WITH(NOLOCK) ON pai.strCodISONorma2=zon.strAbrevPais
where cli.bitInactivo = 0
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
'' AS RuleType,			--(R - Restringe / A - Autoriza)
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
(cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9))) as 'PickingKey',
cab.intNumero as 'Number',
cli.strnome as 'CustomerName',
cab.dtmdata as 'Date',
cab.intCodEntidade as 'Customer',
cab.strAbrevTpDoc as 'Document', 
tdoc.strDescricao as 'DocumentName', 
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
cab.strCodExercicio as 'EXR',
cab.strCodSeccao as 'SEC',
cab.strAbrevTpDoc as 'TPD',
cab.intNumero as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
,cab.intCodEntidade as DeliveryCustomer
,cab.intDireccao as DeliveryCode
,'' as OriginWarehouse
,'' as TransitWarehouse
,'' as DestinationWarehouse
,'' as Barcode
from Mov_Encomenda_Cab cab (NOLOCK)
join Tbl_Clientes cli (NOLOCK) ON cli.intcodigo = cab.intCodEntidade
join Tbl_Tipos_Documentos tdoc (NOLOCK) on tdoc.strAbreviatura = cab.strAbrevTpDoc
left join u_Kapps_DossierLin (NOLOCK) on (u_Kapps_DossierLin.StampBo = (cab.strCodSeccao + '*' + cab.strAbrevTpDoc + '*' + cab.strCodExercicio + '*' + CAST(cab.intNumero as varchar(9)))) and u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N'
where tdoc.bitdispencomendas = 1
and cab.bitAnulado = 0
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_PickTransf_Lines]'))
DROP view [dbo].[v_Kapps_PickTransf_Lines]
GO
CREATE view [dbo].[v_Kapps_PickTransf_Lines] as
  Select 
(cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) as 'PickingLineKey', 
lin.strCodArtigo as 'Article', 
Lin.strDescArtigo as 'Description', 
Lin.fltQuantidade as 'Quantity',
(Lin.fltQuantidadeSatisf + Lin.fltQuantidadeAnul) as 'QuantitySatisfied',
Lin.fltQuantidade - ((Lin.fltQuantidadeSatisf + Lin.fltQuantidadeAnul) + (select isnull(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin (NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and ((Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9)))=u_Kapps_DossierLin.stampbo) and ((cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) = u_Kapps_DossierLin.Stampbi)))  as 'QuantityPending',
(select isnull(sum(u_Kapps_DossierLin.Qty2),0) from u_Kapps_DossierLin (NOLOCK) where u_Kapps_DossierLin.Status = 'A' and u_Kapps_DossierLin.Integrada = 'N' and ((Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9)))=u_Kapps_DossierLin.stampbo) and ((cast(Lin.intNumLinha as varchar(9)) + '*' + cast(Lin.intNumLinhaReserva as varchar(9))) = u_Kapps_DossierLin.Stampbi)) as 'QuantityPicked', 
Art.strAbrevMedStk AS 'BaseUnit',
CASE WHEN ISNULL(Art.strAbrevMedVnd,'') <> '' THEN Art.strAbrevMedVnd ELSE Art.strAbrevMedStk END as 'BusyUnit', 
CASE WHEN ISNULL(Art.strAbrevMedVnd,'') = Art.strAbrevMedStk THEN 1 WHEN ISNULL(Art.strAbrevMedVnd,'') <> '' THEN (SELECT uni.fltFactor from Tbl_Gce_UnidadesConversao uni (NOLOCK) where uni.strAbrevUnidade1 = art.strAbrevMedVnd and uni.strAbrevUnidade2 = art.strAbrevMedStk) ELSE 1 END AS 'ConversionFator',
Lin.strCodArmazem as 'Warehouse', 
(Lin.strCodSeccao + '*' + Lin.strAbrevTpDoc + '*' + Lin.strCodExercicio + '*' + CAST(Lin.intNumero as varchar(9))) as 'PickingKey',
Lin.intNumLinhaReserva as 'OriginalLineNumber',
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
Lin.strCodExercicio as 'EXR',
Lin.strCodSeccao as 'SEC',
Lin.strAbrevTpDoc as 'TPD',
Lin.intNumero as 'NDC',
'' as 'Filter1','' as 'Filter2','' as 'Filter3','' as 'Filter4','' as 'Filter5'
, ISNULL(lin.strCodLocalizacao,'') AS Location
, ISNULL(lin.strCodLote,'') AS Lot
, '' as PalletType
, 0 as PalletMaxUnits
FROM Mov_Encomenda_Lin lin (NOLOCK) 
JOIN Tbl_Gce_Artigos Art (NOLOCK) ON Art.strCodigo = lin.strCodArtigo
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_Kapps_Stock_Status]'))
DROP view [dbo].[v_Kapps_Stock_Status]
GO
CREATE view [dbo].[v_Kapps_Stock_Status] as 
select '' as Code
, '' AS Description
WHERE 1=0
GO