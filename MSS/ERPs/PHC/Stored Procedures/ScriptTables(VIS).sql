-- Creating the MSVIS table
CREATE TABLE MSVIS (
    VISDTI VARCHAR (16),
    VISHRI VARCHAR (12),
    VISDTF VARCHAR (16),
    VISHRF VARCHAR (12),
    VISTIP VARCHAR (60),
    VISCLI VARCHAR (60),
    VISLCE VARCHAR (40),
    VISSTS VARCHAR (1),
    VISGP1 VARCHAR (30),
    VISGP2 VARCHAR (30),
    VISGP3 VARCHAR (30),
    VISGPT VARCHAR (1),
    VISGTS VARCHAR (28),
    VISRIE VARCHAR (30),
    VISRIS VARCHAR (10),
    VISRIN INT,
    VISRFE VARCHAR (30),
    VISRFS VARCHAR (10),
    VISRFN INT,
    VISSU1 VARCHAR (4000),
    VISSU2 VARCHAR (4000),
    VISSU3 VARCHAR (4000),
    VISLUS VARCHAR (50),
    VISVEN VARCHAR (60),
    VISRTC VARCHAR (30),
    VISRTL VARCHAR (30),
	VISAGD varchar (80),
	VISCTP varchar (1),
	VISTCA varchar (1),
	VISDIN varchar (16),
	VISHIN varchar (12),
	VISDIR varchar (16),
	VISHIR varchar (12),
	VISDFR varchar (16),
	VISHFR varchar (12),
    VISACL VARCHAR (4000),
    VISVND VARCHAR(50)  NULL ,
	VISSYNCR VARCHAR(1) NULL ,
	VISTIPO VARCHAR(1) null,
	VISTERM BIGINT null
);
CREATE UNIQUE INDEX WDIDX_MSVIS_VISK01 ON MSVIS (VISDTI,VISHRI,VISVND);
CREATE INDEX WDIDX_MSVIS_VISVND ON MSVIS (VISVND);
CREATE INDEX WDIDX_MSVIS_VISSYN ON MSVIS (VISSYNCR);
GO

--********************* TR_MSSVIS_CHECK_DUPLICATE ************************************
CREATE TRIGGER TR_MSSVIS_CHECK_DUPLICATE ON MSVIS INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @DataIni VARCHAR(8)
	DECLARE @HoraIni VARCHAR(6)
	DECLARE @Vnd VARCHAR(50)
	
	DECLARE @DiaCount INT

	SELECT @DataIni = VISDTI, @HoraIni = VISHRI, @Vnd = VISVND FROM INSERTED
	SELECT @DiaCount = Count(*) FROM MSVIS(nolock) WHERE VISDTI = @DataIni AND VISHRI = @HoraIni AND VISVND = @Vnd
	IF @DiaCount > 0
		DELETE FROM MSVIS WHERE VISDTI = @DataIni AND VISHRI = @HoraIni AND VISVND = @Vnd

	INSERT INTO MSVIS SELECT * FROM INSERTED
END
GO
--********************* // TR_MSSVIS_CHECK_DUPLICATE ************************************