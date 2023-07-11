CREATE DATABASE SYSLOG_GENERAL_DATA;
GO
IF (select FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))=1
begin
	EXEC SYSLOG_GENERAL_DATA.dbo.sp_fulltext_database @action = 'enable';
end
GO
ALTER DATABASE SYSLOG_GENERAL_DATA SET ANSI_NULL_DEFAULT OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET ANSI_NULLS OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET ANSI_PADDING OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET ANSI_WARNINGS OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET ARITHABORT OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET AUTO_CLOSE OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET AUTO_SHRINK OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE SYSLOG_GENERAL_DATA SET CURSOR_CLOSE_ON_COMMIT OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET CURSOR_DEFAULT  GLOBAL;
ALTER DATABASE SYSLOG_GENERAL_DATA SET CONCAT_NULL_YIELDS_NULL OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET NUMERIC_ROUNDABORT OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET QUOTED_IDENTIFIER OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET RECURSIVE_TRIGGERS OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET DISABLE_BROKER;
ALTER DATABASE SYSLOG_GENERAL_DATA SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET DATE_CORRELATION_OPTIMIZATION OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET TRUSTWORTHY OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET ALLOW_SNAPSHOT_ISOLATION OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET PARAMETERIZATION SIMPLE;
ALTER DATABASE SYSLOG_GENERAL_DATA SET READ_COMMITTED_SNAPSHOT OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET HONOR_BROKER_PRIORITY OFF;
ALTER DATABASE SYSLOG_GENERAL_DATA SET RECOVERY SIMPLE;
ALTER DATABASE SYSLOG_GENERAL_DATA SET MULTI_USER;
ALTER DATABASE SYSLOG_GENERAL_DATA SET PAGE_VERIFY CHECKSUM ;
ALTER DATABASE SYSLOG_GENERAL_DATA SET DB_CHAINING OFF;
EXEC sys.sp_db_vardecimal_storage_format N'SYSLOG_GENERAL_DATA', N'ON';
GO
ALTER DATABASE SYSLOG_GENERAL_DATA SET  READ_WRITE;
GO

USE SYSLOG_GENERAL_DATA;
GO
CREATE TABLE Companies(
	CompanyID numeric(18, 0) NULL,
	CompanyName nvarchar(100) NULL
);
CREATE TABLE CompaniesProperties(
	CompanyID numeric(18, 0) NULL,
	ParameterID nvarchar(100) NULL,
	ParameterValue nvarchar(500) NULL,
	Description nvarchar(100) NULL
);
CREATE TABLE Devices(
	DeviceID numeric(18, 0) NULL,
	DeviceName nvarchar(100) NULL,
	DeviceAssignedCompanies nvarchar(100) NULL
);
CREATE TABLE DevicesProperties(
	DeviceID numeric(18, 0) NULL,
	ParameterID nvarchar(100) NULL,
	ParameterValue nvarchar(200) NULL,
	Description nvarchar(100) NULL
);
CREATE TABLE General(
	Type nvarchar(100) NULL,
	ParameterID nvarchar(100) NULL,
	ParameterValue nvarchar(200) NULL,
	Description nvarchar(100) NULL
);
CREATE TABLE ParametersProperties(
	ParameterType nvarchar(100) NULL,
	ParameterID nvarchar(100) NULL,
	ParameterDefaultValue nvarchar(100) NULL,
	ParameterDescription nvarchar(100) NULL
);
GO

INSERT INTO ParametersProperties (ParameterType, ParameterID, ParameterDefaultValue, ParameterDescription) VALUES 
(N'Companies', N'DatabaseType', N'1', N'SQL, DB2 ou ORACLE'),
(N'Companies', N'DatabaseConnection', N'1', N'1-OLEDB  2-ODBC'),
(N'Companies', N'Company_MIS_General', N'1', N''),
(N'Companies', N'CompanyERP', N'', N'ID da empresa no ERP'),
(N'Companies', N'ERP_OLEDB_Server', N'', N'Servidor OLEDB do ERP'),
(N'Companies', N'ERP_OLEDB_Port', N'', N'Porta OLEDB do servidor onde está o ERP'),
(N'Companies', N'ERP_OLEDB_Database', N'', N'Nome da base de dados do ERP'),
(N'Companies', N'ERP_OLEDB_User', N'', N'Utilizador da BD do ERP'),
(N'Companies', N'ERP_OLEDB_Password', N'', N'Password do utilizador da bases de dados do ERP'),
(N'Companies', N'ERP_SystemDatabase', N'', N'Base de dados de sistema do ERP'),
(N'Companies', N'Driver_Path', N'', N'Caminho para o Driver'),
(N'Companies', N'Company_MIS_Server', N'', N'IP do MIS Communicator'),
(N'Companies', N'Company_MIS_Port', N'', N'Porta do MIS Communicator'),
(N'Companies', N'Company_MIS_Timeout', N'10', N'Timeout do MIS Communicator'),
(N'Companies', N'Company_MIS_Retries', N'3', N'Tentativas do MIS Communicator'),
(N'Companies', N'Company_MIS_EncryptionType', N'', N'Tipo de encriptação do MIS Communicator'),
(N'Companies', N'Company_MIS_Password', N'', N'Password de encriptação do MIS Communicator'),
(N'Companies', N'ERP_ODBC_Collection', N'', N'Collection para ligação ODBC ao ERP'),
(N'Companies', N'ERP_ODBC_Port', N'', N'Porta para ligação ODBC ao ERP'),
(N'Companies', N'ERP_ODBC_Name', N'', N'Nome para ligação ODBC ao ERP'),
(N'Companies', N'ERP_ODBC_User', N'', N'Utilizador para ligação ODBC ao ERP'),
(N'Companies', N'ERP_ODBC_Password', N'', N'Password para ligação ODBC ao ERP'),
(N'Companies', N'ERP_ODBC_ConnectionString', N'', N'Connectionstring completa'),
(N'Companies', N'Company_SMTP_Server', N'', N'Servidor SMTP'),
(N'Companies', N'Company_SMTP_Port', N'', N'Porta SMTP'),
(N'Companies', N'Company_SMTP_User', N'', N'Utilizador SMTP'),
(N'Companies', N'Company_SMTP_Password', N'', N'Password SMTP'),
(N'Companies', N'Company_SMTP_SecureConnection', N'', N'Secure connection SMTP'),
(N'Companies', N'Company_SMTP_UseStartTLS', N'', N'SMTP TLS'),
(N'General', N'General_OnlineLicence', N'1', N'Tipo de licenciamento Syslog'),
(N'General', N'General_LicenceSerialNumber', N'', N'Numero de serie da licença Syslog'),
(N'General', N'General_LicencePassword', N'', N'Password da licença Syslog'),
(N'General', N'General_MIS_Server', N'', N'IP do MIS Communicator'),
(N'General', N'General_MIS_Port', N'', N'Porta do MIS Communicator'),
(N'General', N'General_MIS_Timeout', N'10', N'Timeout do MIS Communicator'),
(N'General', N'General_MIS_Retries', N'3', N'Tentativas do MIS Communicator'),
(N'General', N'General_MIS_EncryptionType', N'', N'Tipo de encriptação do MIS Communicator'),
(N'General', N'General_MIS_Password', N'', N'Password de encriptação do MIS Communicator'),
(N'Devices', N'DeviceManufacturer', N'', N'Fabricante do equipamento'),
(N'Devices', N'DeviceModel', N'', N'Modelo do equipamento'),
(N'Devices', N'DeviceOS', N'', N'Sistema operativo do equipamento'),
(N'Devices', N'DeviceOS_Version', N'', N'Versão do sistema operativo'),
(N'Devices', N'DeviceKeyboardType', N'0', N'Tipo de teclado   0-Virtual   1-Numerico   2-Alfanumerico'),
(N'Devices', N'DeviceBarcodeReader', N'2', N'Tipo de leitor de CB   1-Nativo   2-Wedge   3-Cortex   4-Camera'),
(N'Devices', N'DeviceSupportGS1', N'1', N'Suporta nativamente GS1  0-Não  1-Sim'),
(N'Devices', N'DeviceNotificationID', N'', N'Interno'),
(N'Devices', N'DeviceNotificationUserID', N'', N'Interno'),
(N'Devices', N'DeviceLastUserLogin', N'', N'Utilizador do ultimo login'),
(N'Devices', N'DeviceLastDateLogin', N'', N'Data do ultimo login'),
(N'Devices', N'DeviceLastTimeLogin', N'', N'Hora do ultimo login'),
(N'Devices', N'DeviceRFID_Model', N'', N'Modelo de RFID')
GO
