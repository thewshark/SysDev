CREATE TABLE MSAGR(
	AGRSTP varchar(60),
	AGRDTI varchar(16),
	AGRDTF varchar(16),
	AGRHRI varchar(12),
	AGRHRF varchar(12),
	AGRTPR bigint,
	AGRFRQ bigint,
	AGRDIA varchar(20),
	AGRRFC varchar(2000),
	AGRAGD varchar(60),
	AGRCLI varchar(60),
	AGRLCE varchar(60),
	AGRRTC varchar(60),
	AGRRTL varchar(60),
	AGRCLA varchar(60),
	AGRLCA varchar(60),
	AGRORI varchar(1),
	AGRUSR varchar(100),
	AGRVND varchar(30),
	AGRACL varchar(4000),
	AGRVEND VARCHAR(50)  NULL ,
	AGRSYNCR VARCHAR(1),
	AGRTIPO VARCHAR(1),
	AGRTERM BIGINT
);
GO
CREATE UNIQUE INDEX AGR1 ON MSAGR(AGRSTP,AGRTERM)