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
