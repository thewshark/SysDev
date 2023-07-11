CREATE PROCEDURE [dbo].[SPMSS_DocDossIntern]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@EstabSeparator CHAR(1),
	@EstabSeparatorFor CHAR(1),
	@Imp1 CHAR(10),
	@Imp2 CHAR(10),
	@Imp3 CHAR(10),
	@ValidateDocLines INT,
	@ValidateDocSequence INT,
	@ValidateDocTotals NUMERIC(19,6),
	@memissao VARCHAR(15) = 'EURO'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @CliNumTmp VARCHAR(20)
	DECLARE @CliLocEnt VARCHAR(20)	
	DECLARE @CondVendTmp VARCHAR(30)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocTipo VARCHAR(10)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocArmazem INT
	DECLARE @DocAnul CHAR(1)
	DECLARE @DocParam INT
	DECLARE @DocParamFor INT 
	DECLARE @CliTipo VARCHAR(20) 
	DECLARE @CliZona VARCHAR(20) 
	DECLARE @CliSegmento VARCHAR(25)
	DECLARE @CliTelef VARCHAR(60)
	DECLARE @CliNome VARCHAR(55)
	DECLARE @CliMorada VARCHAR(55)
	DECLARE @CliLocal VARCHAR(43)
	DECLARE @CliCPostal VARCHAR(45)
	DECLARE @CliNCont VARCHAR(18)
	DECLARE @CliPais INT
	DECLARE @CliLocTesoura VARCHAR(50)
	DECLARE @CliContado INT
	DECLARE @DocDesc NUMERIC(19,6)
	DECLARE @DocAssinatura VARCHAR(1000)
	DECLARE @DocVsAssinatura VARCHAR(50)
	DECLARE @DocTipoSAFT VARCHAR(10)
	DECLARE @horasl VARCHAR(8)

	DECLARE @bistamp CHAR(25)
	DECLARE @bostamp CHAR(25)
	DECLARE @boano INT
	DECLARE @obrano INT
	DECLARE @ndos INT
	DECLARE @nmdos VARCHAR(24)
	DECLARE @dataobra DATETIME
	DECLARE @nome CHAR(55)
	DECLARE @morada VARCHAR(55)
	DECLARE @moeda VARCHAR(11)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @no INT
	DECLARE @obs VARCHAR(67)
	DECLARE @etotaldeb NUMERIC(19,6)
	DECLARE @estot1 NUMERIC(19,6)
	DECLARE @estot2 NUMERIC(19,6)
	DECLARE @estot3 NUMERIC(19,6)
	DECLARE @estot4 NUMERIC(19,6)
	DECLARE @vendedor INT
	DECLARE @vendnm VARCHAR(20)
	DECLARE @ncont VARCHAR(18)
	DECLARE @ebo_2tvall NUMERIC(19,6)

	DECLARE @etotal NUMERIC(19,6)
	DECLARE @ebo_1tvall NUMERIC(19,6)
	DECLARE @ebo_totp1 NUMERIC(19,6)
	DECLARE @ebo_totp2 NUMERIC(19,6)
	DECLARE @edescc NUMERIC(19,6)
	DECLARE @estab INT

	DECLARE @inome VARCHAR(50)
	DECLARE @tpstamp CHAR(25)
	DECLARE @tpdesc VARCHAR(55)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)

	DECLARE @ebo12_bins NUMERIC(19,6)
	DECLARE @ebo12_iva NUMERIC(19,6)
	DECLARE @ebo22_bins NUMERIC(19,6)
	DECLARE @ebo22_iva NUMERIC(19,6)
	DECLARE @ebo32_bins NUMERIC(19,6)
	DECLARE @ebo32_iva NUMERIC(19,6)
	DECLARE @ebo42_bins NUMERIC(19,6)
	DECLARE @ebo42_iva NUMERIC(19,6)
	DECLARE @ebo52_bins NUMERIC(19,6)
	DECLARE @ebo52_iva NUMERIC(19,6)
	DECLARE @ebo62_bins NUMERIC(19,6)
	DECLARE @ebo62_iva NUMERIC(19,6)
	DECLARE @ebo72_bins NUMERIC(19,6)
	DECLARE @ebo72_iva NUMERIC(19,6)
	DECLARE @ebo82_bins NUMERIC(19,6)
	DECLARE @ebo82_iva NUMERIC(19,6)
	DECLARE @ebo92_bins NUMERIC(19,6)
	DECLARE @ebo92_iva NUMERIC(19,6)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	DECLARE @ArmOrigem VARCHAR(30)
	DECLARE @ArmDestino VARCHAR(30)
	
	DECLARE @etotalciva NUMERIC(19,6)
	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT
	DECLARE @atcodeid VARCHAR(200)
	DECLARE @cdata DATETIME
	DECLARE @chora VARCHAR(8)
	DECLARE @DocACL VARCHAR(2000)
	DECLARE @DocTip VARCHAR(1)
	DECLARE @CODPAIS VARCHAR(60)
	DECLARE @DESCRPAIS VARCHAR(60)

	DECLARE @ENTIDADE VARCHAR(1)
	DECLARE @InvoiceNO VARCHAR(60)
	DECLARE @ATCUD VARCHAR(100)

	DECLARE @paStamp CHAR(25)
	DECLARE @DCCSSR VARCHAR(10)
	DECLARE @DCCSND INT
	DECLARE @Anul INT
    DECLARE @motanul VARCHAR(100)
	DECLARE @TabIva INT
	
	DECLARE @bdemp VARCHAR(2)
	
	DECLARE @motiseimp VARCHAR(60)
	DECLARE @codmotiseimp VARCHAR(3)
	
	DECLARE @contImp INT
	
	/*Impostos*/
	DECLARE @dcci1v NUMERIC(19,6)
	DECLARE @dcci2v NUMERIC(19,6)
	DECLARE @dcci3v NUMERIC(19,6)
	DECLARE @ecovalor NUMERIC(19,6)
	
	/*Validações*/
	DECLARE @DCCPNS CHAR(1)
	DECLARE @DOCValorizado CHAR(1)
	DECLARE @ContAnt INT
	DECLARE @ContLinhas INT
	DECLARE @ContLinhasTerminal INT
	DECLARE @TotalDOC NUMERIC(19,6)
	DECLARE @DiffVAL NUMERIC(19,6)
	DECLARE @Msg VARCHAR(200)
	DECLARE @MsgErro VARCHAR(200)
	DECLARE @DOC VARCHAR(80)

	DECLARE curCabBO CURSOR FOR
	SELECT 
		ISNULL(DCCTPD, ''),
		ISNULL(DCCSER, ''),
		ISNULL(DCCNDC, 0),
		ISNULL(DCCDTA, ''),
		ISNULL(DCCCLI, ''),
		ISNULL(DCCLCE, ''),
		ISNULL(DCCNOM, ''),
		ISNULL(DCCMOR, ''),
		ISNULL(DCCLOC, ''),
		ISNULL(DCCCPT, ''),
		ISNULL(DCCNCT, ''),
		ISNULL(DCCVLI, 0),
		ISNULL(DCCVLL, 0),
		ISNULL(DCCVDC, 0),
		ISNULL(DCCOBS, ''),
		ISNULL(DCCVND, ''),
		ISNULL(DCCTERM, 0),
		ISNULL(DCCCVD, ''),
		ISNULL(DCCDCG, 0),
		ISNULL(DCCARO, ''),
		ISNULL(DCCARD, ''),
		ISNULL(DCCANU, 'N'),
		ISNULL(DCCSIG, ''),
		ISNULL(DCCSIV, 0),
		ISNULL(DCCTSF, ''),
		ISNULL(DCCHOR, ''),
		ISNULL(DCCTDC, 0),
		ISNULL(DCCACL, ''),
		ISNULL(DCCTIP, ''),
		ISNULL(DCCPAI, ''),
		ISNULL(DCCSSR, ''),
		ISNULL(DCCSND, 0),
		ISNULL(DCCI1V,0),
		ISNULL(DCCI2V,0),
		ISNULL(DCCI3V,0),
		ISNULL(DCCPNS,'N')
	FROM MSDCC(nolock)
	WHERE DCCSYNCR = 'N' AND DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC ORDER BY DCCDTA, DCCHOR

	OPEN curCabBo
		
		FETCH NEXT FROM curCabBO INTO @DocTipo, @DocSerie, @obrano, @dataobra, @CliNumTmp, @CliLocEnt, @nome, @morada, @local, @codpost, @ncont, @etotal, @etotaldeb, @edescc, @obs, @vendedor, @DocTerminal, @CondVendTmp, @DocDesc, @ArmOrigem, @ArmDestino, @DocAnul, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @etotalciva, @DocACL, @DocTip, @CODPAIS, @DCCSSR, @DCCSND, @dcci1v, @dcci2v, @dcci3v, @DCCPNS
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				BEGIN TRANSACTION

				EXECUTE SPMSS_GetDadosDoc 1, @DocTipo, @DocSerie, @ndos OUTPUT, @nmdos OUTPUT, @DocParamFor OUTPUT, @DocParam OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT																																										  
				select @contImp = count(1) from ts inner join ts2 on ts.tsstamp=ts2stamp where ts2.docsimport=1 and ndos=@ndos

				if (@contImp = 0 and @DocTipoSAFT<>'')
					RAISERROR('A série não está configurada para documentos importados para o documento!',16,1)
				
				IF (@dcci1v > 0 AND @Imp1='')
					RAISERROR('Documento com imposto 1 sem estar configurado!',16,1)

				IF (@dcci2v > 0 AND @Imp2='')
					RAISERROR('Documento com imposto 2 sem estar configurado!',16,1)

				IF (@dcci3v > 0 AND @Imp3='')
					RAISERROR('Documento com imposto 3 sem estar configurado!',16,1)

				SET @ecovalor = 0
				
				SET @ENTIDADE = ''
				IF (LEN(@CliNumTmp) > 1)
				BEGIN
					IF ((SUBSTRING(@CliNumTmp, 1, 2) = 'F.') OR (CHARINDEX(@EstabSeparatorFor, @CliNumTmp) > 0))

						SET @ENTIDADE = 'F'
					ELSE IF ((SUBSTRING(@CliNumTmp, 1, 2) = 'P.'))
						SET @ENTIDADE = 'P'
				END
					
				IF (@ENTIDADE = 'F')
				BEGIN
					IF CHARINDEX(@EstabSeparatorFor, @CliNumTmp) > 0
					BEGIN
						SET @estab = CAST(RIGHT(@CliNumTmp, LEN(@CliNumTmp) - CHARINDEX(@EstabSeparatorFor, @CliNumTmp)) AS INT)
						SET @CliNumTmp = LEFT(@CliNumTmp, CHARINDEX(@EstabSeparatorFor, @CliNumTmp) - 1)
					END
					ELSE
					BEGIN
						/*IF LEFT(@CliLocEnt, 3) = 'LCD' SET @CliLocEnt = '0'
							SET @estab = @CliLocEnt*/
						IF LEFT(@CliLocEnt, 3) = 'LCD' SET @CliLocEnt = '0'
						SET @estab = CAST(@CliLocEnt AS INT)
					END
					IF (SUBSTRING(@CliNumTmp, 1, 2) = 'F.')
						SET @no = CAST(SUBSTRING(@CliNumTmp, 3, LEN(@CliNumTmp) - 2) AS INT)
					ELSE
						SET @no = CAST(@CliNumTmp AS INT)

					EXECUTE SPMSS_GetForInfo @no, @estab, @CliTipo OUTPUT, @CliZona OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @fref OUTPUT, @ccusto OUTPUT
					SET @CliSegmento = ''
				END
				ELSE IF (@ENTIDADE = 'P')
				BEGIN
					SET @estab = 0
					
					IF (SUBSTRING(@CliNumTmp, 1, 2) = 'P.')
						SET @no = CAST(SUBSTRING(@CliNumTmp, 3, LEN(@CliNumTmp) - 2) AS INT)
					ELSE
						SET @no = CAST(@CliNumTmp AS INT)

					SET @CliTipo = ''
					SET @CliZona = ''
					SET @CliTelef = ''
					SET @CliPais = 0 
					SET @moeda = '' 
					SET @fref = '' 
					SET @ccusto = ''
					
					SET @CliSegmento = ''
				END
				ELSE
				BEGIN
				IF CHARINDEX(@EstabSeparator, @CliNumTmp) > 0
				BEGIN
					SET @no = CAST(LEFT(@CliNumTmp, CHARINDEX(@EstabSeparator, @CliNumTmp) - 1) AS INT)
					SET @estab = CAST(RIGHT(@CliNumTmp, LEN(@CliNumTmp) - CHARINDEX(@EstabSeparator, @CliNumTmp)) AS INT)
				END
				ELSE
				BEGIN
					SET @no = CAST(@CliNumTmp AS INT)
					/*IF LEFT(@CliLocEnt, 3) = 'LCD' SET @CliLocEnt = '0'
					SET @estab = @CliLocEnt*/
					IF LEFT(@CliLocEnt, 3) = 'LCD' SET @CliLocEnt = '0'
					SET @estab = CAST(@CliLocEnt AS INT)
				END
				END

				/*IF ((@estab <= 0) AND (CAST(@CliLocEnt AS INT) > 0))
					SET @estab = @CliLocEnt*/

				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @bostamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				SET @horasl = LEFT(@horasl, 2) + ':' + SUBSTRING(@horasl, 3, 2) + ':' + SUBSTRING(@horasl, 5, 2)

				SET @boano = YEAR(@dataobra)

				IF dbo.ExtractFromACL(@DocACL, 67) <> ''
					SET @InvoiceNO = dbo.ExtractFromACL(@DocACL, 67)
				ELSE IF (@DocTipoSAFT <> '')
					SET @InvoiceNO = @DCCTPD + ' ' + @DocSerie + '/' + CAST(@obrano AS VARCHAR(48)) --@DocTipoSAFT + ' ' + @DocSerie + '/' + CAST(@obrano AS VARCHAR(48)) 
				ELSE
					SET @InvoiceNO = ''

				/*Validar se o documento anterior existe, caso o parâmetro @ValidateDocSequence está a 1 e senão é o primeiro número da série*/
				IF (@ValidateDocSequence = 1 and @DCCPNS<>'S' AND @obrano > 1)
				BEGIN
					SELECT @ContAnt = COUNT(1) FROM bo (NOLOCK) WHERE ndos=@ndos and boano=@boano and obrano=(@obrano - 1)

					SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' BOSTAMP = ' + @bostamp
					SET @MsgErro = @DOC + ' Documento anterior não existe!'

					if @ContAnt = 0
						RAISERROR(@MsgErro,16,1)
				END
				
				EXECUTE SPMSS_GetVendNome @vendedor, @vendnm OUTPUT

				SET @ebo_2tvall = @etotaldeb

				SET @ebo_1tvall = @etotal
				SET @ebo_totp1 = @etotal
				SET @ebo_totp2 = @etotal
				

				IF ((@ENTIDADE <> 'F') AND (@ENTIDADE <> 'P'))
				BEGIN
					IF @DocTip = 'S'
					BEGIN
						IF @no <= 0
							SELECT TOP 1 @no=no FROM CL WITH (NOLOCK) WHERE clivd = 1 order by no

						EXECUTE SPMSS_GetCliInfo @no, @estab, @CliTipo OUTPUT, @CliZona OUTPUT, @CliSegmento OUTPUT, @CliTelef OUTPUT, @nome OUTPUT, @morada OUTPUT, @local OUTPUT, @codpost OUTPUT, @ncont OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @CliLocTesoura OUTPUT, @CliContado OUTPUT, @fref OUTPUT, @ccusto OUTPUT, @TabIva OUTPUT
					END						
					ELSE
						EXECUTE SPMSS_GetCliInfo2 @no, @estab, @CliTipo OUTPUT, @CliZona OUTPUT, @CliSegmento OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @CliLocTesoura OUTPUT, @CliContado OUTPUT, @fref OUTPUT, @ccusto OUTPUT, @TabIva OUTPUT
				END


				IF @CliContado is null
					set @CliContado = 0
				

				SET @inome = 'MSS'

				EXECUTE SPMSS_GetCondVend @CondVendTmp, @tpstamp OUTPUT, @tpdesc OUTPUT

				IF @tpstamp IS NULL
                    SET @tpstamp = ''
                IF @tpdesc IS NULL
                    SET @tpdesc = ''
					
				SET @estot1 = 0
				SET @estot2 = 0
				SET @estot3 = 0
				SET @estot4 = 0
			
				-- Número do programa certificado
				IF @DocAssinatura <> ''
				BEGIN
					IF dbo.ExtractFromACL(@DocACL, 2) <> ''
						SET @DocVsAssinatura  = dbo.ExtractFromACL(@DocACL, 2)  + @DocVsAssinatura
					ELSE
						SET @DocVsAssinatura = '0240.' + @DocVsAssinatura
				END
				ELSE
				BEGIN
					SET @DocVsAssinatura = ''
				END
				
				IF dbo.ExtractFromACL(@DocACL, 13) <> ''
				BEGIN
					SET @atcodeid = dbo.ExtractFromACL(@DocACL, 13)
					SET @cdata = dbo.StringToDate(dbo.ExtractFromACL(@DocACL, 21))
					SET @chora = LEFT(dbo.ExtractFromACL(@DocACL, 22), 4)
				END
				ELSE
				BEGIN
					SET @atcodeid = ''
					SET @cdata = 0
					SET @chora = ''
				END
				

				EXECUTE SPMSS_DocDossInternIVAs @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @ebo12_bins OUTPUT, @ebo12_iva OUTPUT, @ebo22_bins OUTPUT, @ebo22_iva OUTPUT, @ebo32_bins OUTPUT, @ebo32_iva OUTPUT, @ebo42_bins OUTPUT, @ebo42_iva OUTPUT, @ebo52_bins OUTPUT, @ebo52_iva OUTPUT, @ebo62_bins OUTPUT, @ebo62_iva OUTPUT, @ebo72_bins OUTPUT, @ebo72_iva OUTPUT, @ebo82_bins OUTPUT, @ebo82_iva OUTPUT, @ebo92_bins OUTPUT, @ebo92_iva OUTPUT, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora


				SELECT @DESCRPAIS=nome FROM paises WHERE nomeabrvsaft=@CODPAIS
				IF @DESCRPAIS IS NULL
				BEGIN
					SET @DESCRPAIS = ''
				END

				SET @paStamp = ''
				IF (@DCCSND > 0)
				BEGIN

					IF (@DCCSSR <> '0')
						SELECT @paStamp = pastamp FROM pa (NOLOCK)  WHERE u_nomss = @DCCSND and (ISNULL(u_sermss, '')= @DCCSSR)
					ELSE

						SELECT @paStamp = pastamp FROM pa (NOLOCK)  WHERE nopat = @DCCSND

				END

				IF @DocAnul = 'S'
				BEGIN
					SET @Anul = 1;
				END
				ELSE
				BEGIN
					SET @Anul = 0;
				END	

				if (upper(@Imp1) = 'ECOVALOR' and @dcci1v>0)
					SET @ecovalor = @dcci1v
				else if (upper(@Imp2) = 'ECOVALOR' and @dcci2v>0)
					SET @ecovalor = @dcci2v
				else if (upper(@Imp3) = 'ECOVALOR' and @dcci3v>0)
					SET @ecovalor = @dcci3v
                
				-- verificar se existem linhas com IVA 0 para preencher na ft2 o motivo de isenção e respectivo código
				SELECT TOP 1 @motiseimp = DCLPLI, @codmotiseimp = dbo.ExtractFromACL(DCLACL, 12) FROM MSDCL WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC AND DCLPLI <> ''
				IF @motiseimp IS NULL
				BEGIN
					SET @motiseimp = ''
					SET @codmotiseimp = ''
				END
				
				INSERT INTO bo2 (bo2stamp, Armazem, Ar2mazem, Assinatura, VersaoChave, TipoSaft, horasl, etotalciva, morada, local, codpost, ebo72_bins, ebo72_iva, ebo82_bins, ebo82_iva, ebo92_bins, ebo92_iva, atcodeid,xpddata,xpdhora,anulado, ettecoval2, ttecoval2, ettecoval, ttecoval) VALUES (@bostamp, CAST(@ArmOrigem as int), CAST(@ArmDestino as int), @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @etotalciva, @morada, @local, @codpost, @ebo72_bins, @ebo72_iva, @ebo82_bins, @ebo82_iva, @ebo92_bins, @ebo92_iva,@atcodeid,@cdata,@chora,@Anul, @ecovalor, dbo.EurToEsc(@ecovalor), @ecovalor, dbo.EurToEsc(@ecovalor))

				SET @motanul = dbo.ExtractFromACL(@DocACL, 11)

				INSERT INTO bo3 (bo3stamp,codpais,descpais,ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, documentnumberori, motanul, taxpointdt, codmotiseimp, motiseimp) VALUES(@bostamp, @CODPAIS, @DESCRPAIS, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @InvoiceNO, @motanul, @usrdata, @codmotiseimp, @motiseimp)
				
				if (@ecovalor > 0)
				BEGIN
					SET @etotaldeb = @etotaldeb + @ecovalor
					SET @ebo_totp2 = @ebo_totp2 + @ecovalor
					SET @ebo_2tvall = @etotaldeb
				END

				DECLARE @DEVOLUCAO CHAR(1)
				SET @DEVOLUCAO = dbo.ExtractFromACL(@DocACL, 27)
				
				IF @DocAnul = 'S'
				BEGIN
					/*INSERT INTO bo (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, obs, moeda, etotaldeb, estot1, estot2, estot3, estot4, vendedor, vendnm, ncont, ebo_2tvall, etotal, ebo_1tvall, ebo_totp1, ebo_totp2, edescc, tipo, zona, segmento, estab, memissao, inome, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fechada, ebo12_bins, ebo12_iva, ebo22_bins, ebo22_iva, ebo32_bins, ebo32_iva, ebo42_bins, ebo42_iva, ebo52_bins, ebo52_iva, ebo62_bins, ebo62_iva, pastamp) 
					VALUES (@bostamp, @boano, @obrano, @ndos, @nmdos, @dataobra, @nome, @morada, @local, @codpost, @no, @obs, @moeda, 0, 0, 0, 0, 0, @vendedor, @vendnm, @ncont, 0, 0, 0, 0, 0, 0, @CliTipo, @CliZona, @CliSegmento, @estab, @memissao, @inome, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, 1, @ebo12_bins, @ebo12_iva, @ebo22_bins, @ebo22_iva, @ebo32_bins, @ebo32_iva, @ebo42_bins, @ebo42_iva, @ebo52_bins, @ebo52_iva, @ebo62_bins, @ebo62_iva, @paStamp) */
					
					INSERT INTO bo (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, obs, moeda, etotaldeb, estot1, estot2, estot3, estot4, vendedor, vendnm, ncont, ebo_2tvall, etotal, ebo_1tvall, ebo_totp1, ebo_totp2, edescc, tipo, zona, segmento, estab, memissao, inome, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fref, ccusto, lifref, dataopen, ebo_2tdes1, ebo12_bins, ebo12_iva, ebo22_bins, ebo22_iva, ebo32_bins, ebo32_iva, ebo42_bins, ebo42_iva, ebo52_bins, ebo52_iva, ebo62_bins, ebo62_iva, pastamp) 
					VALUES (@bostamp, @boano, @obrano, @ndos, @nmdos, @dataobra, @nome, @morada, @local, @codpost, @no, @obs, @moeda, @etotaldeb, @estot1, @estot2, @estot3, @estot4, @vendedor, @vendnm, @ncont, @ebo_2tvall, @etotal, @ebo_1tvall, @ebo_totp1, @ebo_totp2, @edescc, @CliTipo, @CliZona, @CliSegmento, @estab, @memissao, @inome, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @fref, @ccusto, @lifref, @dataobra, @edescc, @ebo12_bins, @ebo12_iva, @ebo22_bins, @ebo22_iva, @ebo32_bins, @ebo32_iva, @ebo42_bins, @ebo42_iva, @ebo52_bins, @ebo52_iva, @ebo62_bins, @ebo62_iva, @paStamp) 
					
					EXECUTE SPMSS_DocDossInternUSR @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @no

					SET @bistamp = 'MSS_' + @DateStr + @TimeStr

					INSERT INTO bi2(bi2stamp) VALUES (@bistamp)
				
					EXECUTE SPMSS_DocDossInternLin @DCCEXR, @DCCTPD, @DCCSER, @obrano, @EstabSeparator, @no, @estab, @bostamp, @dataobra, @dataobra, @local, @morada, @codpost, @nome, @DocDesc, @ArmOrigem, @ArmDestino, @ENTIDADE, @DocAnul, @Imp1, @Imp2, @Imp3, @DEVOLUCAO

					
					/*INSERT INTO bi (bistamp, ref, design, lordem, ndos, bostamp, armazem, qtt, altura, largura, espessura, peso, stipo,usr1,usr2,usr3,usr4,usr5,usr6, ivaincl, cpoc, stns, usalote, obrano,epu,pu, edebito,debito,eslvu,slvu,ettdeb,ttdeb, esltt,sltt,no, epcusto,pcusto, ar2mazem,desconto,desc2,desc3,desc4,desc5,iva,dataobra,rdata,uni2qtt,unidade,unidad2,tabiva,vendedor,vendnm,estab,nmdos,local,morada,codpost,nome,eprorc,prorc,codigo,rescli,forref,zona,segmento,familia,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora, vumoeda, ttmoeda, fechada) 
					VALUES (@bistamp, '', 'Documento anulado', 10000, @ndos, @bostamp, 0, 0, 0, 0, 0, 0, 4, '','','','','','', 0, 0, 0, 0, @obrano, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @no, 0, 0, 0,0,0,0,0,0,0,@dataobra,@dataobra,0,'','',0,@vendedor,@vendnm,@estab,@nmdos,@local,@morada,@codpost,@nome,0,0,'',@DocParam,'',@CliZona,'','',@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora, 0, 0, 1)*/
				END
				ELSE
				BEGIN
					INSERT INTO bo (bostamp, boano, obrano, ndos, nmdos, dataobra, nome, morada, local, codpost, no, obs, moeda, etotaldeb, estot1, estot2, estot3, estot4, vendedor, vendnm, ncont, ebo_2tvall, etotal, ebo_1tvall, ebo_totp1, ebo_totp2, edescc, tipo, zona, segmento, estab, memissao, inome, tpstamp, tpdesc, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, fref, ccusto, lifref, dataopen, ebo_2tdes1, ebo12_bins, ebo12_iva, ebo22_bins, ebo22_iva, ebo32_bins, ebo32_iva, ebo42_bins, ebo42_iva, ebo52_bins, ebo52_iva, ebo62_bins, ebo62_iva, pastamp) 
					VALUES (@bostamp, @boano, @obrano, @ndos, @nmdos, @dataobra, @nome, @morada, @local, @codpost, @no, @obs, @moeda, @etotaldeb, @estot1, @estot2, @estot3, @estot4, @vendedor, @vendnm, @ncont, @ebo_2tvall, @etotal, @ebo_1tvall, @ebo_totp1, @ebo_totp2, @edescc, @CliTipo, @CliZona, @CliSegmento, @estab, @memissao, @inome, @tpstamp, @tpdesc, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @fref, @ccusto, @lifref, @dataobra, @edescc, @ebo12_bins, @ebo12_iva, @ebo22_bins, @ebo22_iva, @ebo32_bins, @ebo32_iva, @ebo42_bins, @ebo42_iva, @ebo52_bins, @ebo52_iva, @ebo62_bins, @ebo62_iva, @paStamp) 

					EXECUTE SPMSS_DocDossInternUSR @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @no

					EXECUTE SPMSS_DocDossInternLin @DCCEXR, @DCCTPD, @DCCSER, @obrano, @EstabSeparator, @no, @estab, @bostamp, @dataobra, @dataobra, @local, @morada, @codpost, @nome, @DocDesc, @ArmOrigem, @ArmDestino, @ENTIDADE, @DocAnul, @Imp1, @Imp2, @Imp3, @DEVOLUCAO

				END
				
				SET @DOCValorizado = dbo.ExtractFromACL(@DocACL, 25)

				IF(@ValidateDocTotals >= 0 AND @DOCValorizado = 'S')
				BEGIN
					/*Obter o total do documento do PHC*/
					SELECT @TotalDOC=(etotaldeb + ebo12_iva + ebo22_iva + ebo32_iva + ebo42_iva + ebo52_iva + ebo62_iva) FROM BO WHERE bostamp=@bostamp
					SELECT @TotalDOC=@TotalDOC+(ebo72_iva + ebo82_iva + ebo92_iva) FROM BO2 WHERE bo2stamp=@bostam																				

					SET @DiffVAL = ABS(@etotalciva - @TotalDOC)

					SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' BOSTAMP = ' + @bostamp
					SET @MsgErro = @DOC + ' A diferença do documento do mss para o PHC é superior ao valor parametrizado('+CAST(@DiffVAL AS VARCHAR(25)) + ')'

					if (@DiffVAL > @ValidateDocTotals)
						RAISERROR(@MsgErro,16,1)

					EXECUTE SPMSS_DocDossInternValIVAs  @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @ValidateDocTotals, @Msg OUT

					IF (@Msg<>'')
						RAISERROR(@Msg,16,1)
				END

				IF @ValidateDocLines = 1
				BEGIN
					IF dbo.ExtractFromACL(@DocACL, 46) <> ''
					BEGIN
						SET @ContLinhasTerminal = CAST(dbo.ExtractFromACL(@DocACL, 46) AS INT)

						SELECT @ContLinhas = count(1) FROM bi WHERE bostamp= @bostamp

						SET @DOC = @DCCEXR + ' ' + @DCCTPD + ' ' + @DCCSER + '/' + CAST(@DCCNDC as VARCHAR(10)) + ' BOSTAMP = ' + @bostamp
						SET @MsgErro = @DOC + ' Nº de linhas inserido no PHC (' + CAST(@ContLinhas AS VARCHAR(10)) + ') é diferente do número de linhas geradas no terminal (' + CAST(@ContLinhasTerminal AS VARCHAR(10)) + ')'


						if @ContLinhas <> @ContLinhasTerminal
							RAISERROR(@MsgErro,16,1)
					END
				END
				
				UPDATE MSDCC Set DCCSYNCR='S' WHERE DCCEXR=@DCCEXR AND DCCTPD=@DCCTPD And DCCSER=@DCCSER And DCCNDC=@obrano
				UPDATE MSDCL Set DCLSYNCR='S' WHERE DCLEXR=@DCCEXR AND DCLTPD=@DCCTPD And DCLSER=@DCCSER And DCLNDC=@obrano
				
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				ROLLBACK TRANSACTION
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			
			END CATCH
			
			FETCH NEXT FROM curCabBO INTO @DocTipo, @DocSerie, @obrano, @dataobra, @CliNumTmp, @CliLocEnt, @nome, @morada, @local, @codpost, @ncont, @etotal, @etotaldeb, @edescc, @obs, @vendedor, @DocTerminal, @CondVendTmp, @DocDesc, @ArmOrigem, @ArmDestino, @DocAnul, @DocAssinatura, @DocVsAssinatura, @DocTipoSAFT, @horasl, @etotalciva, @DocACL, @DocTip, @CODPAIS, @DCCSSR, @DCCSND, @dcci1v, @dcci2v, @dcci3v, @DCCPNS
		END
	FIM:
		CLOSE curCabBo
		DEALLOCATE curCabBo
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ServicosEquipamentos
-- Integração de Equipamentos de serviço
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ServicosEquipamentos]
	@SRVEXR varchar(30),	-- exercício do serviço
	@SRVSER varchar(10),	-- série do serviço
	@SRVNDC numeric(19, 0),	-- número do serviço
	@pastamp char(25),		-- Stamp do PAT criado/alterado no PHC
	@EstabSeparator CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

	DECLARE @Codigo varchar(255)
	DECLARE @Serie char(50)
	DECLARE @Serie2 char(50)
	DECLARE @Instal DATETIME
	DECLARE @DataUMP DATETIME
	DECLARE @Fimgar DATETIME
	DECLARE @SEQEDS varchar(255)

	DECLARE @Maquina varchar(20)
	DECLARE @Marca varchar(20)
	DECLARE @Modelo varchar(20)
	DECLARE @mastamp CHAR(50)

	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @Tipo VARCHAR(20)
	DECLARE @tecnico numeric(4, 0)
	DECLARE @tecnnm varchar(20)

	DECLARE @SRVCLI VARCHAR(60)
	DECLARE @SRVLCE VARCHAR(40)
	DECLARE @SRVNOM VARCHAR(120)
	DECLARE @SRVMOR VARCHAR(120)
	DECLARE @SRVLOC VARCHAR(120)
	DECLARE @SRVCPT VARCHAR(120)
	DECLARE @SRVMO2 VARCHAR(120)
	DECLARE @SRVNCT VARCHAR(40)
	DECLARE @SEQOBS VARCHAR(1000)
	DECLARE @SEQACL VARCHAR(2000)
	DECLARE @VENDEDOR VARCHAR(50)
	DECLARE @NomeVENDEDOR VARCHAR(255)

	DECLARE @Cout INT

    DECLARE curEquipamentosSer CURSOR FOR 
	SELECT 
		ISNULL(SEQEQP, ''),
		ISNULL(SEQESN, ''),
		ISNULL(SEQEDI, 0),
		ISNULL(SEQUDS, 0),
		ISNULL(SEQDFG, 0),
		ISNULL(SEQEDS,''),
		ISNULL(SEQOBS,''),
		ISNULL(SEQACL,'')
	FROM MSSEQ(nolock) WHERE SEQEXR = @SRVEXR AND SEQSER = @SRVSER AND SEQNDC = @SRVNDC  AND SEQSYNCR = 'N'

	OPEN curEquipamentosSer

		FETCH NEXT FROM curEquipamentosSer INTO @mastamp,@Serie,@Instal,@DataUMP,@Fimgar,@SEQEDS,@SEQOBS,@SEQACL
		WHILE @@FETCH_STATUS = 0 BEGIN			
			WAITFOR DELAY '00:00:00.200' 
			SET @DateTimeTmp = GETDATE()
			SET @DateStr = dbo.DateToString(@DateTimeTmp)
			SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

			SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
			SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)


			SELECT @Cout = COUNT(mastamp) from ma (NOLOCK) WHERE mastamp = @mastamp
			IF (@Cout > 0)
				UPDATE ma SET Serie=@Serie, Instal=@Instal, Dataump=@DataUMP, Fimgar=@Fimgar, ousrhora=@ousrhora, usrhora=@usrhora WHERE mastamp = @mastamp
			ELSE
			BEGIN
				SET @Serie2 = @mastamp
				SET @mastamp = 'MSS_' + @DateStr + @TimeStr

				IF (@SRVSER <> '0')
					SELECT @tecnico = cm, @tecnnm = nome FROM CM4 (NOLOCK) WHERE cm = @SRVSER
				ELSE
				BEGIN
					SELECT @tecnico = tecnico FROM pa WHERE nopat = @SRVNDC
					SELECT @tecnnm = nome FROM CM4 (NOLOCK) WHERE cm = @tecnico
				END
				
				IF (dbo.ExtractFromACL(@SEQACL, 2) <> '')
				BEGIN
					SELECT @VENDEDOR = dbo.ExtractFromACL(@SEQACL, 2)
					SELECT @NomeVENDEDOR = cmdesc FROM cm3(NOLOCK) WHERE cm=@VENDEDOR
				END
				ELSE
				BEGIN
					SET @VENDEDOR = 0
					SET @NomeVENDEDOR = ''
				END

				IF (dbo.ExtractFromACL(@SEQACL, 8) <> '')
					SET @Marca = dbo.ExtractFromACL(@SEQACL, 8)
				ELSE
					SET @Marca = ''
				IF (dbo.ExtractFromACL(@SEQACL, 9) <> '')
					SET @Modelo = dbo.ExtractFromACL(@SEQACL, 9)
				ELSE
					SET @Modelo = ''
				
				IF (@Serie = '')
					SET @Serie = 'MSS_'+@SRVEXR+'-'+@SRVSER+'-'+CAST(@SRVNDC AS varchar(10)) + '_'+ @DateStr + @TimeStr

				SELECT @SRVCLI = SRVCLI,  @SRVLCE = SRVLCE, @SRVNOM = SRVNOM, @SRVMOR = SRVMOR, @SRVLOC = SRVLOC, @SRVCPT = SRVCPT, @SRVMO2 = SRVMO2, @SRVNCT = SRVNCT FROM MSSRV (NOLOCK) WHERE SRVEXR = @SRVEXR AND SRVSER = @SRVSER AND SRVNDC = @SRVNDC
				IF CHARINDEX(@EstabSeparator, @SRVCLI) > 0
				BEGIN
					SET @SRVLCE = CAST(RIGHT(@SRVCLI, LEN(@SRVCLI) - CHARINDEX(@EstabSeparator, @SRVCLI)) AS INT)
					SET @SRVCLI = CAST(LEFT(@SRVCLI, CHARINDEX(@EstabSeparator, @SRVCLI) - 1) AS INT)
					
				END
				ELSE
				BEGIN
					SET @SRVCLI = CAST(@SRVCLI AS INT)
					SET @SRVLCE = 0
				END
				
				
				INSERT INTO ma(mastamp,design,serie,serie2,marca,maquina,instal,Dataump,Fimgar,ousrhora,usrhora,tecnico,UTECN,no,nome,TECNNM,UTECNNM,MORADA,LOCAL,ESTAB,CODPOST,vendedor,VENDNM) 
				values(@mastamp,@SEQEDS,@Serie,@Serie2,@Marca,@Modelo,@Instal,@DataUMP,@Fimgar,@ousrhora,@usrhora,@tecnico,@tecnico,@SRVCLI,@SRVNOM,@tecnnm,@tecnnm,@SRVMOR,@SRVLOC,@SRVLCE,@SRVCPT,@VENDEDOR,@NomeVENDEDOR)
			END


			UPDATE pa SET mastamp = @mastamp WHERE pastamp = @pastamp

			FETCH NEXT FROM curEquipamentosSer INTO @mastamp,@Serie,@Instal,@DataUMP,@Fimgar,@SEQEDS,@SEQOBS,@SEQACL
		END
	FIM:
		CLOSE curEquipamentosSer
		DEALLOCATE curEquipamentosSer	
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ServicosIntervencoes
-- Integração de Intervenções
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ServicosIntervencoes]
	@SRVEXR varchar(30),	-- exercício do serviço
	@SRVSER varchar(10),	-- série do serviço
	@SRVNDC numeric(19, 0),	-- número do serviço
	@pastamp char(25)		-- stamp do PAT criado/alterado no PHC
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

	DECLARE @mhstamp char(25) 
	DECLARE @nome varchar(55) 
	DECLARE @nopat numeric(10, 0) 
	DECLARE @data datetime 
	DECLARE @tecnico numeric(4, 0)
	DECLARE @tecnnm varchar(30)
	DECLARE @no numeric(10, 0) 
	DECLARE @estab numeric(3, 0)
	DECLARE @hora varchar(5) 
	DECLARE @horaf varchar(5)
	DECLARE @serie varchar(50)
	DECLARE @fref char(20)
	DECLARE @realizada bit
	DECLARE @datapat datetime 
	DECLARE @horapat varchar(5)
	DECLARE @mastamp varchar(25)
	DECLARE @relatorio varchar(max)

	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @SITLIN int
	DECLARE @SITLEQ int
	DECLARE @SITDSC varchar(200)
	DECLARE @SITEQP varchar(30)
	DECLARE @SITEDS varchar(100)
	DECLARE @SITESN varchar(100)
	DECLARE @SITDTI varchar(8)
	DECLARE @SITHRI varchar(6)
	DECLARE @SITDTF varchar(8)
	DECLARE @SITHRF varchar(6)
	DECLARE @SITRLI varchar(max)
	DECLARE @SITACL varchar(2000)
	DECLARE @SITVND varchar(50)
	DECLARE @SITTERM int

	DECLARE @Marca varchar(20)
	DECLARE @Maquina varchar(20)
	DECLARE @Tipo varchar(20)
	DECLARE @mhtipo varchar(20)

	DECLARE @SITDTIHRI Datetime
	DECLARE @SITDTFHRF Datetime
	DECLARE @moh int

	DECLARE @ACL12_mhstamp char(25)
	DECLARE @ACL11_status char(1)
	DECLARE @Append int


    DECLARE curIntervencoes CURSOR FOR 
	SELECT 
		ISNULL(SITLIN, 0),
		ISNULL(SITLEQ, 0),
		ISNULL(SITDSC, ''),
		ISNULL(SITEQP, ''),
		ISNULL(SITEDS, ''),
		ISNULL(SITESN, ''),
		ISNULL(SITDTI, ''),
		ISNULL(SITHRI, ''),
		ISNULL(SITDTF, ''),
		ISNULL(SITHRF, ''),
		ISNULL(SITRLI, ''),
		ISNULL(SITACL, ''),
		ISNULL(SITVND, ''),
		ISNULL(SITTERM, '')
	FROM MSSIT(nolock) WHERE SITEXR = @SRVEXR AND SITSER = @SRVSER AND SITNDC = @SRVNDC AND SITSYNCR = 'N' AND dbo.ExtractFromACL(SITACL, 11) IN ('A','C')

	OPEN curIntervencoes

		FETCH NEXT FROM curIntervencoes INTO @SITLIN,@SITLEQ,@SITDSC,@mastamp,@SITEDS,@SITESN,@SITDTI,@SITHRI,@SITDTF,@SITHRF,@SITRLI,@SITACL,@SITVND,@SITTERM
		WHILE @@FETCH_STATUS = 0 BEGIN			
			WAITFOR DELAY '00:00:00.200' 
			SET @DateTimeTmp = GETDATE()
			SET @DateStr = dbo.DateToString(@DateTimeTmp)
			SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

			SET @ousrinis = 'MSS T-' + CAST(@SITTERM AS VARCHAR(3))
			SET @usrinis = 'MSS T-' + CAST(@SITTERM AS VARCHAR(3))

			SET @ousrdata = @DateStr
			SET @usrdata = @DateStr

			SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
			SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				
			SELECT @datapat = pdata, @horapat = phora, @tecnico = tecnico, @tecnnm = tecnnm, @no = no, @estab = estab, @nome = nome, @nopat = nopat, @fref = fref FROM pa WHERE pastamp = @pastamp

			-- Tecnico
			IF (dbo.ExtractFromACL(@SITACL, 13) <> '')
				SET @tecnico = CAST(dbo.ExtractFromACL(@SITACL, 13) as  numeric)

			-- Dados do equipamento
			SET @Marca = ''
			SET @Maquina = ''
			SET @Tipo = ''
			IF (@mastamp <> '')
				SELECT @Marca = marca, @Maquina = maquina, @Tipo = tipo FROM ma WHERE mastamp = @mastamp
			ELSE
			BEGIN
				SET @Marca = ''
				SET @Maquina = ''
				SET @Tipo = ''
			END

			-- Tipo de intervencao
			SET @mhtipo = dbo.ExtractFromACL(@SITACL, 6)
			SET @moh = 0

			SET @data = dbo.StringToDate(@SITDTI)
			SET @hora = LEFT(@SITHRI, 2) + ':' + SUBSTRING(@SITHRI, 3, 2)
			SET @serie = @SITESN
			SET @SITDTIHRI = CAST(@SITDTI + ' ' + @hora AS datetime)

			IF @SITHRF <> ''
			BEGIN
				SET @realizada = 1
				SET @relatorio = @SITRLI
				SET @horaf = LEFT(@SITHRF, 2) + ':' + SUBSTRING(@SITHRF, 3, 2)
				SET @SITDTFHRF = CAST(@SITDTF + ' ' + @horaf AS datetime)
				SET @moh =  round((datediff(minute, @SITDTIHRI, @SITDTFHRF) / 60.0),2)
			END
			ELSE
			BEGIN
				SET @realizada = 0
				SET @relatorio = ''
				SET @horaf = ''
			END

			SET @Append = 0
			SET @ACL11_status = dbo.ExtractFromACL(@SITACL, 11)
			SET @ACL12_mhstamp = dbo.ExtractFromACL(@SITACL, 12)

			SET @Append = 0
			IF @ACL11_status = 'A'
			BEGIN
				SET @mhstamp = 'MSS_' + @DateStr + @TimeStr
				SET @Append = 1
			END
			ELSE IF ((@ACL11_status = '') OR (@ACL11_status = 'C'))
			BEGIN
				IF (@ACL12_mhstamp <> '')
				BEGIN
					SET @mhstamp = @ACL12_mhstamp
					SET @Append = 0
				END
				ELSE
				BEGIN
					SELECT @mhstamp = mhstamp FROM mh WHERE nopat = @nopat AND data = @data AND hora = @hora
					IF @@ROWCOUNT = 0
						SET @Append = 1
				END
			END

			IF @Append = 1
			BEGIN
				SET @mhstamp = 'MSS_' + @DateStr + @TimeStr

				INSERT INTO mh(mhstamp,nome,nopat,data,tecnico,tecnnm,no,estab,hora,horaf,serie,fref,realizada,datapat,horapat,mastamp,relatorio,marca,maquina,tipo,mhtipo,moh)
				VALUES(@mhstamp,@nome,@nopat,@data,@tecnico,@tecnnm,@no,@estab,@hora,@horaf,@serie,@fref,@realizada,@datapat,@horapat,@mastamp,@relatorio,@Marca,@Maquina,@Tipo,@mhtipo,@moh)
			END
			ELSE
			BEGIN
				UPDATE mh SET
					nome = @nome,
					tecnico = @tecnico,
					tecnnm = @tecnnm,
					hora = @hora,
					horaf = @horaf,
					serie = @serie,
					fref = @fref,
					realizada = @realizada,
					mastamp = @mastamp,
					relatorio = @relatorio,
					marca = @Marca,
					maquina = @Maquina,
					tipo = @Tipo,
					mhtipo = @mhtipo,
					moh = @moh
				WHERE mhstamp = @mhstamp
			ENd
			
			--EXECUTE SPMSS_ServicosUSR @SRVEXR, @SRVSER, @SRVNDC, @pastamp

			FETCH NEXT FROM curIntervencoes INTO @SITLIN,@SITLEQ,@SITDSC,@SITEQP,@SITEDS,@SITESN,@SITDTI,@SITHRI,@SITDTF,@SITHRF,@SITRLI,@SITACL,@SITVND,@SITTERM
		END
	FIM:
		CLOSE curIntervencoes
		DEALLOCATE curIntervencoes	
END

GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ServicosUSR
-- SP de Utilizador dos serviços
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ServicosUSR]
	@SRVEXR varchar(30),	-- exercício do serviço
	@SRVSER varchar(10),	-- série do serviço
	@SRVNDC numeric(19, 0),	-- número do serviço
	@pastamp char(25)		-- stamp do PAT criado/alterado no PHC
AS
BEGIN
	SET NOCOUNT ON;

	
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_ServicosAnexos
-- Integração de Anexos de Serviços
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_ServicosAnexos]
	@SRVEXR varchar(30),	-- exercício do serviço
	@SRVSER varchar(10),	-- série do serviço
	@SRVNDC numeric(19, 0),	-- número do serviço
	@pastamp char(25)		-- stamp do PAT criado/alterado no PHC
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME

		DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @FOTFIC varchar(2000)
	DECLARE @FOTTERM int

	DECLARE @FileName VARCHAR(200)
	DECLARE @FileExtension VARCHAR(5)
	DECLARE @Temp VARCHAR(200)
	DECLARE @anexosstamp VARCHAR(50)
	DECLARE @fullname VARCHAR(2000)

    DECLARE curAnexos CURSOR FOR 
	SELECT 
		ISNULL(FOTFIC, ''),
		ISNULL(FOTTERM, '')
	FROM MSFOT(nolock) WHERE FOTEXR = @SRVEXR AND FOTTPD = 'SRVC' AND FOTSER = @SRVSER AND FOTNDC = @SRVNDC  AND FOTSYNCR = 'N'

	OPEN curAnexos

		FETCH NEXT FROM curAnexos INTO @FOTFIC, @FOTTERM

		WHILE @@FETCH_STATUS = 0 BEGIN			
			WAITFOR DELAY '00:00:00.200' 
			SET @DateTimeTmp = GETDATE()
			SET @DateStr = dbo.DateToString(@DateTimeTmp)
			SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

			SET @anexosstamp = 'MSS_' + @DateStr + @TimeStr

			SET @usrinis = 'MSS T-' + CAST(@FOTTERM AS VARCHAR(3))
			SET @usrdata = @DateStr
			SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				
			SET @fullname = '<PATH SYNCHRO>\TR' + right('0000' + @FOTTERM, 4) + '\ToPC\' + @FOTFIC

			SET @FileExtension = reverse(left(reverse(@FOTFIC),charindex('.',reverse(@FOTFIC))-1))
			SET @FileName = replace(@FOTFIC, '.'+@FileExtension, '')

			SELECT @Temp=rtrim(ltrim(fname)) FROM anexos WHERE oritable = 'PA' AND fname = @FileName AND recstamp = @pastamp
			IF @Temp = '' or @Temp is null
			begin
				INSERT INTO anexos(anexosstamp, oritable, resumo, recstamp, fullname, fname, fext, flen, tipo, passw, origem, keylook, tpdos, tpdoc, ausrinis, ausrdata, ausrhora, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora) values (@anexosstamp, 'PA', 'Foto Serviço', @pastamp, @fullname, @FileName, @FileExtension, 0, 2, '', '', '', 0, 0, @usrinis, @usrdata, @usrhora, @usrinis, @usrdata, @usrhora, @usrinis, @usrdata, @usrhora)
			end

			FETCH NEXT FROM curAnexos INTO @FOTFIC, @FOTTERM
		END
	FIM:
		CLOSE curAnexos
		DEALLOCATE curAnexos	
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Servicos
-- Integração de Serviços
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_Servicos]
	@EstabSeparator CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @PAExists INT

	DECLARE @no numeric(10, 0)
	DECLARE @estab numeric(3, 0)
	DECLARE @tecnico numeric(4, 0)
	DECLARE @tecnnm varchar(20)
	DECLARE @pastamp char(25)
	DECLARE @nopat numeric(10, 0)
	DECLARE @pdata datetime
	DECLARE @phora varchar(5)
	DECLARE @ptipo varchar(20)
	DECLARE @datat datetime
	DECLARE @horat varchar(5)
	DECLARE @nome varchar(55)
	DECLARE @codpost varchar(55)
	DECLARE @morada varchar(55)
	DECLARE @local varchar(45)
	DECLARE @ncont varchar(20)
	DECLARE @pquem varchar(50)
	DECLARE @problema nvarchar(max)
	DECLARE @fref varchar(20)
	DECLARE @fechado bit
	DECLARE @fdata datetime
	DECLARE @fhora varchar(5)
	DECLARE @fquem varchar(30)
	DECLARE @solucao nvarchar(max)

	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	DECLARE @SRVEXR varchar(30) 
	DECLARE @SRVSER varchar(10) 
	DECLARE @SRVNDC numeric(19, 0) 
	DECLARE @SRVDSC varchar(200) 
	DECLARE @SRVSTP varchar(30) 
	DECLARE @SRVDTR varchar(8) 
	DECLARE @SRVHRR varchar(6) 
	DECLARE @SRVDTA varchar(8) 
	DECLARE @SRVHRI varchar(6) 
	DECLARE @SRVDTF varchar(8) 
	DECLARE @SRVHRF varchar(6) 
	DECLARE @SRVTTO numeric(19, 6) 
	DECLARE @SRVHRA varchar(6) 
	DECLARE @SRVDTI varchar(8) 
	DECLARE @SRVDTC varchar(8) 
	DECLARE @SRVHRC varchar(6) 
	DECLARE @SRVSTS varchar(1) 
	DECLARE @SRVCLI varchar(30) 
	DECLARE @SRVLCE varchar(20) 
	DECLARE @SRVNOM varchar(60) 
	DECLARE @SRVMOR varchar(60) 
	DECLARE @SRVLOC varchar(60) 
	DECLARE @SRVCPT varchar(60) 
	DECLARE @SRVMO2 varchar(60) 
	DECLARE @SRVNCT varchar(20) 
	DECLARE @SRVGP1 varchar(30) 
	DECLARE @SRVGP2 varchar(30) 
	DECLARE @SRVGP3 varchar(30) 
	DECLARE @SRVDIA varchar(500) 
	DECLARE @SRVCNM varchar(60) 
	DECLARE @SRVCTL varchar(30) 
	DECLARE @SRVCTM varchar(30) 
	DECLARE @SRVCEM varchar(100) 
	DECLARE @SRVSNA varchar(30) 
	DECLARE @SRVDNA varchar(200) 
	DECLARE @SRVSPB varchar(30) 
	DECLARE @SRVDPB varchar(200) 
	DECLARE @SRVPRI smallint 
	DECLARE @SRVCAT varchar(1) 
	DECLARE @SRVCDS varchar(200) 
	DECLARE @SRVOBS varchar(500) 
	DECLARE @SRVDTP varchar(10) 
	DECLARE @SRVDSR varchar(10) 
	DECLARE @SRVDND numeric(19, 0) 
	DECLARE @SRVADT varchar(8) 
	DECLARE @SRVANU varchar(1) 
	DECLARE @SRVAHR varchar(6) 
	DECLARE @SRVAMT varchar(30) 
	DECLARE @SRVADS varchar(200) 
	DECLARE @SRVFSR varchar(1) 
	DECLARE @SRVFMT varchar(1) 
	DECLARE @SRVRPT varchar(1000) 
	DECLARE @SRVTD1 varchar(10) 
	DECLARE @SRVGTS varchar(14) 
	DECLARE @SRVGPT varchar(1) 
	DECLARE @SRVNCO varchar(30) 
	DECLARE @SRVTD2 varchar(10) 
	DECLARE @SRVMOE varchar(30) 
	DECLARE @SRVCMB numeric(19, 6) 
	DECLARE @SRVPAI varchar(50) 
	DECLARE @SRVDEX varchar(30) 
	DECLARE @SRVACL varchar(2000) 
	DECLARE @SRVVND varchar(50) 
	DECLARE @SRVTERM BIT

	DECLARE @IGNORASRV VARCHAR(1)

	DECLARE curServicos CURSOR FOR 
	SELECT 
		ISNULL(SRVEXR, ''),
		ISNULL(SRVSER, ''),
		ISNULL(SRVNDC, 0),
		ISNULL(SRVDSC, ''),
		ISNULL(SRVSTP, ''),
		ISNULL(SRVDTR, ''),
		ISNULL(SRVHRR, ''),
		ISNULL(SRVDTA, ''),
		ISNULL(SRVHRI, ''),
		ISNULL(SRVDTF, ''),
		ISNULL(SRVHRF, ''),
		ISNULL(SRVTTO, 0),
		ISNULL(SRVHRA, ''),
		ISNULL(SRVDTI, ''),
		ISNULL(SRVDTC, ''),
		ISNULL(SRVHRC, ''),
		ISNULL(SRVSTS, ''),
		ISNULL(SRVCLI, ''),
		ISNULL(SRVLCE, ''),
		ISNULL(SRVNOM, ''),
		ISNULL(SRVMOR, ''),
		ISNULL(SRVLOC, ''),
		ISNULL(SRVCPT, ''),
		ISNULL(SRVMO2, ''),
		ISNULL(SRVNCT, ''),
		ISNULL(SRVGP1, ''),									
		ISNULL(SRVGP2, ''),
		ISNULL(SRVGP3, ''),
		ISNULL(SRVDIA, ''),
		ISNULL(SRVCNM, ''),
		ISNULL(SRVCTL, ''),
		ISNULL(SRVCTM, ''),
		ISNULL(SRVCEM, ''),
		ISNULL(SRVSNA, ''),
		ISNULL(SRVDNA, ''),
		ISNULL(SRVSPB, ''),
		ISNULL(SRVDPB, ''),
		ISNULL(SRVPRI, 0),
		ISNULL(SRVCAT, ''),
		ISNULL(SRVCDS, ''),
		ISNULL(SRVOBS, ''),
		ISNULL(SRVDTP, ''),
		ISNULL(SRVDSR, ''),
		ISNULL(SRVDND, 0),
		ISNULL(SRVADT, ''),
		ISNULL(SRVANU, ''),
		ISNULL(SRVAHR, ''),
		ISNULL(SRVAMT, ''),
		ISNULL(SRVADS, ''),
		ISNULL(SRVFSR, ''),
		ISNULL(SRVFMT, ''),
		ISNULL(SRVRPT, ''),
		ISNULL(SRVTD1, ''),
		ISNULL(SRVGTS, ''),
		ISNULL(SRVGPT, ''),
		ISNULL(SRVNCO, ''),
		ISNULL(SRVTD2, ''),
		ISNULL(SRVMOE, ''),
		ISNULL(SRVCMB, 0),
		ISNULL(SRVPAI, ''),
		ISNULL(SRVDEX, ''),
		ISNULL(SRVACL, ''),
		ISNULL(SRVVND, ''),
		ISNULL(SRVTERM, 0)
	FROM MSSRV(nolock) WHERE SRVSYNCR = 'N'

	OPEN curServicos

		FETCH NEXT FROM curServicos INTO @SRVEXR, @SRVSER, @SRVNDC, @SRVDSC, @SRVSTP, @SRVDTR, @SRVHRR, @SRVDTA, @SRVHRI, @SRVDTF, @SRVHRF, @SRVTTO, @SRVHRA, @SRVDTI, @SRVDTC, @SRVHRC, @SRVSTS, @SRVCLI, @SRVLCE, @SRVNOM, @SRVMOR, @SRVLOC, @SRVCPT, @SRVMO2, @SRVNCT, @SRVGP1, @SRVGP2, @SRVGP3, @SRVDIA, @SRVCNM, @SRVCTL, @SRVCTM, @SRVCEM, @SRVSNA, @SRVDNA, @SRVSPB, @SRVDPB, @SRVPRI, @SRVCAT, @SRVCDS, @SRVOBS, @SRVDTP, @SRVDSR, @SRVDND, @SRVADT, @SRVANU, @SRVAHR, @SRVAMT, @SRVADS, @SRVFSR, @SRVFMT, @SRVRPT, @SRVTD1, @SRVGTS, @SRVGPT, @SRVNCO, @SRVTD2, @SRVMOE, @SRVCMB, @SRVPAI, @SRVDEX, @SRVACL, @SRVVND, @SRVTERM 
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				BEGIN TRANSACTION

				-- verificar se ? um registo com estabelecimento			
				IF CHARINDEX(@EstabSeparator, @SRVCLI) > 0
				BEGIN
					SET @no = CAST(LEFT(@SRVCLI, CHARINDEX(@EstabSeparator, @SRVCLI) - 1) AS INT)
					SET @estab = CAST(RIGHT(@SRVCLI, LEN(@SRVCLI) - CHARINDEX(@EstabSeparator, @SRVCLI)) AS INT)
				END
				ELSE
				BEGIN
					SET @no = CAST(@SRVCLI AS INT)
					SET @estab = 0
				END

				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

				SET @ousrinis = 'MSS T-' + CAST(@SRVTERM AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@SRVTERM AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				
				SET @IGNORASRV = 0
				IF ((@SRVANU = 'S') AND (@SRVSER <> '0')) 
					SET @IGNORASRV = 1	
				
				IF (@IGNORASRV = 0) 
				BEGIN

					IF (@SRVSER <> '0') -- significa que é um serviço criado no tablet
					BEGIN
						
						SELECT @nopat = (ISNULL(Max(nopat), 0) + 1) FROM pa
						
						IF (dbo.ExtractFromACL(@SRVACL, 10) <> '')
						BEGIN
							SET @tecnico = CAST(dbo.ExtractFromACL(@SRVACL, 10) AS numeric)
							SELECT @tecnnm = nome FROM CM4 (NOLOCK) WHERE cm = @tecnico
						END
						ELSE
						BEGIN
							SELECT @tecnico = cm, @tecnnm = nome FROM CM4 (NOLOCK) WHERE cm = @SRVSER
						END
						-- novo pat do técnico
						SET @PAExists = 0
						SET @pastamp = 'MSS_' + @DateStr + @TimeStr

					END
					ELSE
					BEGIN
						SET @nopat = @SRVNDC
						SELECT @tecnico = tecnico, @pastamp = pastamp FROM pa WHERE nopat = @SRVNDC
						SELECT @tecnnm = nome FROM CM4 (NOLOCK) WHERE cm = @tecnico
						SET @PAExists = 1
					END
				
					SET @datat = dbo.StringToDate(@SRVDTA)
					SET @horat = LEFT(@SRVHRA, 2) + ':' + SUBSTRING(@SRVHRA, 3, 2)
				
					SET @pdata = dbo.StringToDate(@SRVDTR)
					SET @phora = LEFT(@SRVHRR, 2) + ':' + SUBSTRING(@SRVHRR, 3, 2)
					SET @ptipo = @SRVSTP
					SET @nome = LEFT(@SRVNOM, 55)
					SET @codpost = LEFT(@SRVCPT, 55)
					SET @morada = LEFT(@SRVMOR, 55)
					SET @local = LEFT(@SRVLOC, 45)
					SET @ncont = LEFT(@SRVNCT, 20)
					SET @pquem = LEFT(@SRVCNM, 50)
					SET @problema = @SRVDPB
					SET @fref = LEFT(@SRVNCO, 20)

					IF @SRVSTS = 'F'
					BEGIN
						SET @fechado = 1
						SET @fdata = dbo.StringToDate(@SRVDTF)
						SET @fhora = LEFT(@SRVHRF, 2) + ':' + SUBSTRING(@SRVHRF, 3, 2)
						SET @fquem = @tecnnm
						SET @solucao = @SRVRPT
					END
					ELSE
					BEGIN
						SET @fechado = 0
						SET @fdata = dbo.StringToDate('19000101')
						SET @fhora = ''
						SET @fquem = ''
						SET @solucao = ''
					END

					IF @PAExists = 0
					BEGIN
						--INSERT
						INSERT INTO pa(no,estab,tecnico,tecnnm,pastamp,nopat,pdata,phora,ptipo,datat,horat,nome,codpost,morada,local,ncont,pquem,problema,fref,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,fechado,fdata,fhora,fquem,solucao,u_nomss,resumo,u_sermss)
						VALUES(@no,@estab,@tecnico,@tecnnm,@pastamp,@nopat,@pdata,@phora,@ptipo,@datat,@horat,@nome,@codpost,@morada,@local,@ncont,@pquem,@problema,@fref,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,@fechado,@fdata,@fhora,@fquem,@solucao,@SRVNDC,@SRVDSC,@SRVSER)
					END
					ELSE
					BEGIN
						--UPDATE
						UPDATE pa SET
							no = @no,
							estab = @estab,
							--tecnico = @tecnico,
							--tecnnm = @tecnnm,
							pdata = @pdata,
							phora = @phora,
							ptipo = @ptipo,
							datat = @datat,
							horat = @horat,
							nome = @nome,
							codpost = @codpost,
							morada = @morada,
							local = @local,
							ncont = @ncont,
							pquem = @pquem,
							problema = @problema,
							fref = @fref,
							ousrinis = @ousrinis,
							ousrdata = @ousrdata,
							ousrhora = @ousrhora,
							usrinis = @usrinis,
							usrdata = @usrdata,
							usrhora = @usrhora,
							fechado = @fechado,
							fdata = @fdata,
							fhora = @fhora,
							--fquem = @fquem,
							fquem = tecnnm,
							solucao = @solucao,
							resumo = @SRVDSC
						WHERE pastamp = @pastamp
					END

					EXECUTE SPMSS_ServicosAnexos @SRVEXR, @SRVSER, @SRVNDC, @pastamp
					
					EXECUTE SPMSS_ServicosEquipamentos @SRVEXR, @SRVSER, @SRVNDC, @pastamp, @EstabSeparator

					EXECUTE SPMSS_ServicosIntervencoes @SRVEXR, @SRVSER, @SRVNDC, @pastamp

					EXECUTE SPMSS_ServicosUSR @SRVEXR, @SRVSER, @SRVNDC, @pastamp

				END
				UPDATE MSSRV SET SRVSYNCR = 'S' WHERE SRVEXR = @SRVEXR AND SRVSER = @SRVSER AND SRVNDC = @SRVNDC
				UPDATE MSSEQ SET SEQSYNCR = 'S' WHERE SEQEXR = @SRVEXR AND SEQSER = @SRVSER AND SEQNDC = @SRVNDC
				UPDATE MSSIT SET SITSYNCR = 'S' WHERE SITEXR = @SRVEXR AND SITSER = @SRVSER AND SITNDC = @SRVNDC
				
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				ROLLBACK TRANSACTION
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curServicos INTO @SRVEXR, @SRVSER, @SRVNDC, @SRVDSC, @SRVSTP, @SRVDTR, @SRVHRR, @SRVDTA, @SRVHRI, @SRVDTF, @SRVHRF, @SRVTTO, @SRVHRA, @SRVDTI, @SRVDTC, @SRVHRC, @SRVSTS, @SRVCLI, @SRVLCE, @SRVNOM, @SRVMOR, @SRVLOC, @SRVCPT, @SRVMO2, @SRVNCT, @SRVGP1, @SRVGP2, @SRVGP3, @SRVDIA, @SRVCNM, @SRVCTL, @SRVCTM, @SRVCEM, @SRVSNA, @SRVDNA, @SRVSPB, @SRVDPB, @SRVPRI, @SRVCAT, @SRVCDS, @SRVOBS, @SRVDTP, @SRVDSR, @SRVDND, @SRVADT, @SRVANU, @SRVAHR, @SRVAMT, @SRVADS, @SRVFSR, @SRVFMT, @SRVRPT, @SRVTD1, @SRVGTS, @SRVGPT, @SRVNCO, @SRVTD2, @SRVMOE, @SRVCMB, @SRVPAI, @SRVDEX, @SRVACL, @SRVVND, @SRVTERM 
		END
	FIM:
		CLOSE curServicos
		DEALLOCATE curServicos	
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_Integra
-- Procedimento principal que inicia a integração de todos os tipos de registos feitos no MSS
-- SPMSS_Clientes
--			'.' 	-> separador utilizado para identificar que factura a filiais
--			'EURO' 	-> moeda atribuida ao novo cliente
-- SPMSS_Estabelecimentos
--			'.' 	-> separador utilizado para identificar que factura a filiais
--			'EURO' 	-> moeda atribuida ao novo estabelecimento
-- SPMSS_Fornecedores
--			'-' 	-> separador utilizado para identificar que factura a filiais
--			'EURO' 	-> moeda atribuida ao novo fornecedor
-- SPMSS_Servicos
--			'.' 	-> separador utilizado para identificar filiais
-- SPMSS_Docs
--			'.' 	-> separador utilizado para identificar que factura a filiais
--			'-'	 	-> separador utilizado para identificar que factura a filiais de fornecedor
--          ''      -> imposto 1 (Valor possível (ecovalor))
--          ''      -> imposto 2 (Valor possível (ecovalor))
--          ''      -> imposto 3 (Valor possível (ecovalor))
--          1       -> Validar número de linhas de documentos ( 0 – Não / 1 – Sim)
--          1       -> Validar sequência do número de documento ( 0 – Não / 1 – Sim)
--          0       -> Validar totais de documento (Com a margem indicada)
-- SPMSS_Recibo
--			'.' 	-> separador utilizado para identificar que factura a filiais
--			'R10001'-> classificação do recibo
--			94		-> código de movimento de conta corrente dos descontos financeiros
--          1      -> Validar número de linhas de documentos ( 0 – Não / 1 – Sim)
--          1       -> Validar sequência do número de documento ( 0 – Não / 1 – Sim)
--          0       -> Validar totais do recibo (Com a margem indicada)
-- *******************************************************************************************************************
CREATE PROCEDURE [dbo].[SPMSS_Integra]
AS
BEGIN
	SET NOCOUNT ON

	EXEC SPMSS_Clientes '.', 'EURO'
	EXEC SPMSS_Estabelecimentos '.', 'EURO'
	EXEC SPMSS_Fornecedores '-', 'EURO'
	EXEC SPMSS_Prospects'-', 'EURO'
	EXEC SPMSS_Servicos '.'
	EXEC SPMSS_Docs '.', '-','','','',1,1,0
	EXEC SPMSS_Recibo '.', 'R10001', 94,1,1,0
END
GO
