-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocFactLin
-- Integração de linhas de documentos de facturação
-- *******************************************************************************************************************
ALTER PROCEDURE [dbo].[SPMSS_DocDocFactLin]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@ftstamp CHAR(25),
	@rdata DATETIME,
	@DCCDCG NUMERIC(18,5),
	@DCCARO VARCHAR(30),
	@DCCARD VARCHAR(30),
	@DCCTSF VARCHAR(10),
	@no INT,
	@estab INT,
	@nome VARCHAR(55),
	@DocAnul CHAR(1),
	@Imp1 CHAR(10),
	@Imp2 CHAR(10),
	@Imp3 CHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @DocTipo VARCHAR(10)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocLinDescV NUMERIC(18,5)
	DECLARE @DocLinDesc1 NUMERIC(6,2)
	DECLARE @DocLinDesc2 NUMERIC(6,2)
	DECLARE @DocLinDesc3 NUMERIC(6,2)
	DECLARE @DocLinDesc4 NUMERIC(6,2)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocIVI VARCHAR(1)
	DECLARE @DocDesc NUMERIC(18,5)
	DECLARE @DocUni2 VARCHAR(4)
	DECLARE @ArtPPond NUMERIC(19,6)
	DECLARE @ArtConv NUMERIC(19,6)
	DECLARE @ArtStock NUMERIC(11,3)
	DECLARE @ArtQttFor NUMERIC(11,3)
	DECLARE @ArtQttCli NUMERIC(11,3)
	DECLARE @ArtQttRec NUMERIC(11,3)
	DECLARE @ArtUsrQtt NUMERIC(11,3)
	DECLARE @ArtForref VARCHAR(20)

	DECLARE @CliTipo VARCHAR(20)
	DECLARE @CliTelef VARCHAR(60)
	DECLARE @CliNome VARCHAR(55)
	DECLARE @CliMorada VARCHAR(55)
	DECLARE @CliLocal VARCHAR(43)
	DECLARE @CliCPostal VARCHAR(45)
	DECLARE @CliNCont VARCHAR(18)
	DECLARE @CliPais INT
	DECLARE @CliZona VARCHAR(20)
	DECLARE @CliSegmento VARCHAR(25)

	DECLARE @fistamp CHAR(25)
	DECLARE @ref VARCHAR(60)
	DECLARE @design VARCHAR(60)
	DECLARE @lordem INT
	DECLARE @ndoc INT
	DECLARE @armazem INT
	DECLARE @qtt NUMERIC(11,3)
	DECLARE @altura NUMERIC(11,3)
	DECLARE @largura NUMERIC(11,3)
	DECLARE @espessura NUMERIC(11,3)
	DECLARE @peso NUMERIC(11,3)
	DECLARE @usr1 VARCHAR(20)
	DECLARE @usr2 VARCHAR(20)
	DECLARE @usr3 VARCHAR(35)
	DECLARE @usr4 VARCHAR(20)
	DECLARE @usr5 VARCHAR(120)
	DECLARE @usr6 VARCHAR(30)
	DECLARE @ivaincl INT
	DECLARE @cpoc INT
	DECLARE @stns INT
	DECLARE @usalote INT 
	DECLARE @lote VARCHAR(30)
	DECLARE @fno INT
	DECLARE @epv NUMERIC(19,6)
	DECLARE @pv NUMERIC(18,5)
	DECLARE @etiliquido NUMERIC(19,6)
	DECLARE @tiliquido NUMERIC(18,5)
	DECLARE @eslvu NUMERIC(19,6)
	DECLARE @slvu NUMERIC(18,5)
	DECLARE @epcp NUMERIC(19,6)
	DECLARE @pcp NUMERIC(18,5) 
	DECLARE @esltt NUMERIC(19,6)
	DECLARE @sltt NUMERIC(18,5)
	DECLARE @ecusto NUMERIC(19,6)
	DECLARE @custo NUMERIC(18,5)
	DECLARE @desconto NUMERIC(6,2)
	DECLARE @desc2 NUMERIC(6,2)
	DECLARE @desc3 NUMERIC(6,2)
	DECLARE @desc4 NUMERIC(6,2)
	DECLARE @desc5 NUMERIC(6,2)
	DECLARE @iva NUMERIC(6,2)
	DECLARE @uni2qtt NUMERIC(11,3)
	DECLARE @unidade VARCHAR(4)
	DECLARE @unidad2 VARCHAR(4)
	DECLARE @tabiva INT
	DECLARE @fivendedor INT
	DECLARE @fivendnm VARCHAR(20)
	DECLARE @nmdoc VARCHAR(20)
	DECLARE @ecomissao INT 
	DECLARE @tipodoc INT
	DECLARE @tipodocFor INT
	DECLARE @tliquido NUMERIC(18,5)
	DECLARE @codigo VARCHAR(18)
	DECLARE @familia VARCHAR(18)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @datalote VARCHAR(8)
	DECLARE @validade VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	DECLARE @ExerDocOrig VARCHAR(30)
	DECLARE @TipoDocOrig VARCHAR(10)
	DECLARE @SerieDocOrig VARCHAR(10)
	DECLARE @NumDocOrig INT
	DECLARE @LinDocOrig INT
	
	DECLARE @orilinstamp VARCHAR(25)
	DECLARE @oriheadstamp VARCHAR(25)
	DECLARE @orindoc INT
	
	DECLARE @To_Close INT
	DECLARE @QtdPend NUMERIC(11,3)
	DECLARE @Sinal NUMERIC(6,2)

	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT

	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @moradaentrega VARCHAR(55)
	DECLARE @localentrega VARCHAR(43)
	DECLARE @codpostentrega VARCHAR(45)

	DECLARE @motiseimp VARCHAR(60)
	DECLARE @codmotiseimp VARCHAR(3)
	DECLARE @DCLACL VARCHAR(2000)

	DECLARE @refCorTam VARCHAR(60)
	DECLARE @Cor VARCHAR(25)
	DECLARE @Tam VARCHAR(25)
	DECLARE @Texteis INT
	DECLARE @DCLLIN INT
	DECLARE @DCLTCL CHAR(1)
	DECLARE @DCLQTM NUMERIC(11,3)
	DECLARE @DCLPRO NUMERIC(19,6)

	DECLARE @NSERIE VARCHAR(60)
	DECLARE @CONT INT
	DECLARE @mastamp CHAR(25)
	DECLARE @ftmastamp CHAR(25)
	DECLARE @bdemp	VARCHAR(2)
	DECLARE @NOSERIE INT
	DECLARE @cont_ftma INT

	SET @CONT = 0
	
		/*impostos*/
	DECLARE @dcli1v NUMERIC (19,6)
	DECLARE @dcli2v NUMERIC(19,6)
	DECLARE @dcli3v NUMERIC(19,6)
	DECLARE @ecovalor NUMERIC(19,6)
	DECLARE @etecoval NUMERIC (19,6)
	DECLARE @eecoval NUMERIC (19,6)
	DECLARE @temeco INT
	DECLARE @ECONOTCALC INT

	DECLARE curFI CURSOR FOR
	SELECT 
		ISNULL(DCLTPD, ''),
		ISNULL(DCLSER, ''),
		ISNULL(DCLNDC, 0),
		CASE WHEN DCLLIN < 1000 THEN ISNULL(DCLLIN*10000, 0)
		ELSE DCLLIN END,
		ISNULL(DCLART, ''),
		ISNULL(DCLQTD, 0.0),
		ISNULL(DCLPRU, 0.0),
		ISNULL(DCLTXI, 0.0),
		ISNULL(DCLTDC, 0.0),
		ISNULL(DCLTD2, 0.0),
		ISNULL(DCLTD3, 0.0),
		ISNULL(DCLTD4, 0.0),
		ISNULL(DCTLOT, ''),
		ISNULL(DCLDSA, ''),
		ISNULL(DCLVD1, 0.0),
		ISNULL(DCLUND, ''),
		ISNULL(DCLALT, 0.0),
		ISNULL(DCLLGR, 0.0),
		ISNULL(DCLCMP, 0.0),
		ISNULL(DCLPES, 0.0),
		ISNULL(DCLVND, ''),
		ISNULL(DCLTERM, 0),
		ISNULL(DCLIVI, 'N'),
		ISNULL(DCLVLD, 0),
		ISNULL(DCLIVA, 0),
		ISNULL(DCLQT2, 0),
		ISNULL(DCLOEX, ''),
		ISNULL(DCLOTP, ''),
		ISNULL(DCLOSR, ''),
		ISNULL(DCLOND, 0),
		ISNULL(DCLOLN, 0),
		ISNULL(DCTDTL, ''),
		ISNULL(DCTDVL, ''),
		ISNULL(DCLPLI, ''),
		ISNULL(DCLACL, ''),
		ISNULL(DCLUN2, ''),
		ISNULL(DCLLIN, 0),
		ISNULL(DCLTCL, ''),
		ISNULL(DCLQTM, 0),
		ISNULL(DCLPRO, 0), --PHC 23
		ISNULL(DCTNSR,''),
		ISNULL(DCLI1V, 0),
		ISNULL(DCLI2V, 0),
		ISNULL(DCLI3V, 0)
	FROM MSDCL(nolock)
	WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC

	OPEN curFI
		
		FETCH NEXT FROM curFI INTO @DocTipo, @DocSerie, @fno, @lordem, @ref, @qtt, @epv, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @fivendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @datalote, @validade, @motiseimp, @DCLACL, @DocUni2, @DCLLIN, @DCLTCL, @DCLQTM, @DCLPRO, @NSERIE, @dcli1v, @dcli2v, @dcli3v
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				
SET @ecovalor = 0

				IF (@dcli1v > 0 AND @Imp1='')
					RAISERROR('Documento com imposto 1 sem estar configurado!',16,1)

				IF (@dcli2v > 0 AND @Imp2='')
					RAISERROR('Documento com imposto 2 sem estar configurado!',16,1)

				IF (@dcli3v > 0 AND @Imp3='')
					RAISERROR('Documento com imposto 3 sem estar configurado!',16,1)

				if (upper(@Imp1) = 'ECOVALOR' and @dcli1v>0)
					SET @ecovalor = @dcli1v
				else if (upper(@Imp2) = 'ECOVALOR' and @dcli2v>0)
					SET @ecovalor = @dcli2v
				else if (upper(@Imp3) = 'ECOVALOR' and @dcli3v>0)
					SET @ecovalor = @dcli3v

				SET @eecoval = 0
				SET @etecoval = 0
				SET @TEMECO = 0
				
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @fistamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @armazem = dbo.StringToNum(@DCCARO)
				IF @armazem <= 0
					SET @armazem = dbo.StringToNum(@DCCARD)
				
				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				-- Verifica se é um artigo com cor e tamanho
				SET @refCorTam = dbo.ExtractFromACL(@DCLACL, 15)
				IF (@refCorTam = 'F')
				BEGIN
					SET @refCorTam = @ref
					EXECUTE SPMSS_GetCorTamanho @DCLACL, @ref OUTPUT, @Cor OUTPUT, @Tam OUTPUT
					SET @Texteis = 1
				END
				ELSE
				BEGIN
					SET @COR = ''
					SET @Tam = ''
					SET @Texteis = 0
				END
				
				EXECUTE SPMSS_GetDadosDoc 2, @DocTipo, @DocSerie, @ndoc OUTPUT, @nmdoc OUTPUT, @tipodocFor OUTPUT, @tipodoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT

				EXECUTE SPMSS_GetArtInfo @ref, @usr1 OUTPUT, @usr2 OUTPUT, @usr3 OUTPUT, @usr4 OUTPUT, @usr5 OUTPUT, @usr6 OUTPUT, @familia OUTPUT, @ecusto OUTPUT, @codigo OUTPUT, @ArtForref OUTPUT, @ivaincl OUTPUT, @ecomissao OUTPUT, @cpoc OUTPUT, @stns OUTPUT, @usalote OUTPUT, @epcp OUTPUT, @unidad2 OUTPUT, @ArtConv OUTPUT,	@ArtStock OUTPUT, @ArtQttFor OUTPUT, @ArtQttCli OUTPUT,	@ArtQttRec OUTPUT, @ArtUsrQtt OUTPUT
				
				EXECUTE SPMSS_GetArtPCusto @ref, @DocPCusto, @ecusto OUTPUT
				
				EXECUTE SPMSS_GetVendNome @fivendedor, @fivendnm OUTPUT
				
				IF @usalote = 0
					SET @lote = ''
				
				IF @tipodoc = 3	 --******************* Quando são notas de crédito os totais têm de ser integrados com sinal negativo
					SET @Sinal = -1
				ELSE
					SET @Sinal = 1
				
				
				
				SET @ettiva = @ettiva * @Sinal
				SET @edescc = @edescc * @Sinal
				SET @memissao = 'EURO'
				
				EXECUTE SPMSS_CalcDescontos @DocLinDescV, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @epv, @qtt, @DCCDCG, @desconto OUTPUT, @desc2 OUTPUT, @desc3 OUTPUT, @desc4 OUTPUT, @desc5 OUTPUT
				
				IF @DocIVI = 'S'
				begin
					IF (dbo.ExtractFromACL(@DCLACL, 24) <> '')
						SET @DocDesc = CAST(dbo.ExtractFromACL(@DCLACL, 24) AS NUMERIC(19,6))
					ELSE
						SET @DocDesc = 0
						
					if (@ecovalor > 0)
					begin
						SET @eecoval = @ecovalor
						SET @etecoval = @eecoval * @qtt
						SET @eslvu = (@epv - @DocLinDescV + @eecoval) / (@iva/100+1)
						SET @esltt = (@qtt * @epv - @DocDesc + @etecoval) / (@iva/100+1)
						SET @TEMECO=1
					end
					else
					begin
						SET @eslvu = (@epv - @DocLinDescV) / (@iva/100+1)
						SET @esltt = (@qtt * @epv - @DocDesc) / (@iva/100+1)
					end
					SET @ivaincl = 1
						
					SET @etiliquido = (@qtt * @epv)-@DocDesc
						
						
						-- só no fim é que arredonda a 2 casas
					SET @etiliquido = round(@etiliquido,2) * @Sinal
					SET @tliquido = @etiliquido  * @Sinal
				end
				ELSE
				BEGIN
					SET @etiliquido = CAST(dbo.ExtractFromACL(@DCLACL, 3) AS NUMERIC(19,6)) * @Sinal
					SET @tliquido = (@etiliquido * (@iva/100+1)) * @Sinal

					if (@ecovalor > 0)
					begin
						SET @eecoval = @ecovalor
						SET @etecoval = @eecoval * @qtt
						SET @eslvu = @epv - round((@DocDesc / @qtt), 2) + @eecoval
						SET @esltt = @qtt * @epv - @DocDesc + @etecoval
						SET @TEMECO=1
					end
					else
					begin
						SET @eslvu = @epv - round((@DocDesc / @qtt), 2)
						SET @esltt = @qtt * @epv - @DocDesc
					end

					SET @ivaincl = 0
				END
				
				/*Linha com ecovalor*/
				IF @ecovalor > 0
				BEGIN
					EXECUTE SPMSS_DocECOVal @ref, @fistamp, @ftstamp, @DocTerminal, 1
					EXECUTE SPMSS_DocECOValP @ref, @fistamp, @ftstamp, @DocTerminal, 1
					EXECUTE SPMSS_DocECOValO @ref, @fistamp, @ftstamp, @DocTerminal, 1
				END
				
				IF (@DCLTCL = 'Q')
				BEGIN
					SET @uni2qtt = @DCLQTM
					SET @unidad2 = dbo.ExtractFromACL(@DCLACL, 25)
				END
				ELSE
				BEGIN
					IF @unidad2 <> ''
					BEGIN
						IF @DocUni2 <> @unidad2
							SET @uni2qtt = @qtt * @ArtConv
					END
					ELSE
						SET @uni2qtt = 0
				END
				
				
				SET @orilinstamp = ''
				SET @oriheadstamp = ''
				
				IF @TipoDocOrig <> ''
				BEGIN
					EXECUTE SPMSS_GetDocOrigStamp @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @DCCTSF, @orilinstamp OUTPUT, @oriheadstamp OUTPUT, @QtdPend OUTPUT, @orindoc OUTPUT
				END
				-- verificar se o lote existe na tabela se e caso não exista fazer o insert antes de inserir a linha
				IF @lote <> ''
				BEGIN
					EXECUTE SPMSS_CheckLote @ref, @design, @lote, @datalote, @validade, @DocTerminal, @rdata
				END
				
				-- ler dados do local de entrega
				SELECT @morada = DCCMOR, @local = DCCLOC, @codpost = DCCCPT, @moradaentrega = DCCEMO, @localentrega = DCCELO, @codpostentrega = DCCECP FROM MSDCC(nolock)	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC
				IF (@moradaentrega = '') AND (@localentrega = '') AND (@codpostentrega = '')
				BEGIN
					SET @moradaentrega = @morada
					SET @localentrega = @local
					SET @codpostentrega = @codpost
				END

				SET @codmotiseimp = dbo.ExtractFromACL(@DCLACL, 12)

				--Se for isento é preciso validar o códido iva para garantir que é bem inserido na tabela fi (linhas das faturas)
				if @iva=0.0
						EXECUTE SPMSS_GetTabIVAFromDoc @DCCEXR, @DCCTPD, @DCCSER, @DCCNDC, @iva, @tabiva OUTPUT

			    IF @NSERIE<>''
				BEGIN
					SET @NOSERIE=1
				END
				ELSE
				BEGIN
					SET @NOSERIE=0
				END

				IF @DCCTSF <> 'NC'
				BEGIN
					IF @orilinstamp IS NULL
						SET @orilinstamp = ''
					
					INSERT INTO fi (fistamp, ref, design, lordem, ndoc, ftstamp, armazem, qtt, altura, largura, espessura, peso, usr1, usr2, usr3, usr4, usr5, usr6, ivaincl, cpoc, stns, usalote, lote, fno, epv, pv, etiliquido, tiliquido, eslvu, slvu, epcp, pcp, esltt, sltt, ecusto, custo, desconto, desc2, desc3, desc4, desc5, iva, rdata, uni2qtt, unidade, unidad2, tabiva, fivendedor, fivendnm, nmdoc, ecomissao, tipodoc, tliquido, codigo, familia, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, bistamp, evaldesc, morada, local, codpost, motiseimp, codmotiseimp, cor, tam, texteis, epvori, pvori, taxpointdt, series, noserie,temeco,eecoval,ecoval,etecoval,tecoval) 
					VALUES (@fistamp, @ref, @design, @lordem, @ndoc, @ftstamp, @armazem, @qtt, @altura, @largura, @espessura, @peso, @usr1, @usr2, @usr3, @usr4, @usr5, @usr6, @ivaincl, @cpoc, @stns, @usalote, @lote, @fno, @epv, dbo.EurToEsc(@epv), @etiliquido, dbo.EurToEsc(@etiliquido), @eslvu, dbo.EurToEsc(@eslvu), @epcp, dbo.EurToEsc(@epcp), @esltt, dbo.EurToEsc(@esltt), @ecusto, dbo.EurToEsc(@ecusto), @desconto, @desc2, @desc3, @desc4, @desc5, @iva, @rdata, @uni2qtt, @unidade, @unidad2, @tabiva, @fivendedor, @fivendnm, @nmdoc, @ecomissao, @tipodoc, @tliquido, @codigo, @familia, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora, @orilinstamp,  @DocLinDescV, @moradaentrega, @localentrega, @codpostentrega, @motiseimp, @codmotiseimp, @Cor, @Tam, @Texteis, @DCLPRO, dbo.EurToEsc(@DCLPRO),@usrdata,@NSERIE,@NOSERIE, @temeco,@eecoval,dbo.EurToEsc(@eecoval),@etecoval,dbo.EurToEsc(@etecoval))
				
					EXEC SPMSS_DocDocFactLinUSR @DCCEXR,@DCCTPD,@DCCSER,@DCCNDC,@ftstamp,@fistamp,@ref,@DCLLIN

					IF @orilinstamp IS NOT NULL
					BEGIN
						IF @QtdPend = @qtt
						BEGIN
							UPDATE bi SET fechada = 1, datafecho = @rdata WHERE bistamp = @orilinstamp
						END
					
						SELECT @To_Close = COUNT(*) FROM BI(nolock) WHERE bostamp = @oriheadstamp AND fechada = 0 and ref <> ''

						IF @To_Close = 0
						BEGIN
							UPDATE bo SET fechada = 1, datafecho = @rdata WHERE bostamp = @oriheadstamp			
						END
					END
				END
				ELSE
				BEGIN
					IF @orilinstamp IS NULL
						SET @orilinstamp = ''

					INSERT INTO fi (fistamp, ref, design, lordem, ndoc, ftstamp, armazem, qtt, altura, largura, espessura, peso, usr1, usr2, usr3, usr4, usr5, usr6, ivaincl, cpoc, stns, usalote, lote, fno, epv, pv, etiliquido, tiliquido, eslvu, slvu, epcp, pcp, esltt, sltt, ecusto, custo, desconto, desc2, desc3, desc4, desc5, iva, rdata, uni2qtt, unidade, unidad2, tabiva, fivendedor, fivendnm, nmdoc, ecomissao, tipodoc, tliquido, codigo, familia, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, evaldesc, fnoft, ndocft, ftanoft, ofistamp, morada, local, codpost, motiseimp, codmotiseimp, cor, tam, texteis, epvori, pvori, series, noserie,temeco,eecoval,ecoval,etecoval,tecoval) 
					VALUES (@fistamp, @ref, @design, @lordem, @ndoc, @ftstamp, @armazem, @qtt, @altura, @largura, @espessura, @peso, @usr1, @usr2, @usr3, @usr4, @usr5, @usr6, @ivaincl, @cpoc, @stns, @usalote, @lote, @fno, @epv, dbo.EurToEsc(@epv), @etiliquido, dbo.EurToEsc(@etiliquido), @eslvu, dbo.EurToEsc(@eslvu), @epcp, dbo.EurToEsc(@epcp), @esltt, dbo.EurToEsc(@esltt), @ecusto, dbo.EurToEsc(@ecusto), @desconto, @desc2, @desc3, @desc4, @desc5, @iva, @rdata, @uni2qtt, @unidade, @unidad2, @tabiva, @fivendedor, @fivendnm, @nmdoc, @ecomissao, @tipodoc, @tliquido, @codigo, @familia, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora,  @DocLinDescV, @NumDocOrig, @orindoc, @ExerDocOrig, @orilinstamp, @moradaentrega, @localentrega, @codpostentrega, @motiseimp, @codmotiseimp, @Cor, @Tam, @Texteis, @DCLPRO, dbo.EurToEsc(@DCLPRO),@NSERIE,@NOSERIE, @temeco,@eecoval,dbo.EurToEsc(@eecoval),@etecoval,dbo.EurToEsc(@etecoval))

					EXEC SPMSS_DocDocFactLinUSR @DCCEXR,@DCCTPD,@DCCSER,@DCCNDC,@ftstamp,@fistamp,@ref,@DCLLIN

					IF @oriheadstamp IS NOT NULL
						UPDATE ft SET facturada = 1, fnoft = @fno, nmdocft = @nmdoc WHERE ftstamp = @oriheadstamp			
					ELSE
					BEGIN
					WAITFOR DELAY '00:00:00.050' 
						SET @DateTimeTmp = GETDATE()
				
						SET @DateStr = dbo.DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
						SET @fistamp = 'MSS_' + @DateStr + @TimeStr
						SET @lordem = @lordem + 1

						SET @design = 'Orig. não encontrada:Ex:' + @ExerDocOrig + ',Cód:' + @TipoDocOrig + ',Sér:' + @SerieDocOrig + ',Num:' + CAST(@NumDocOrig AS VARCHAR(10))

						INSERT INTO fi (fistamp, design, lordem, ndoc, ftstamp, fno, fivendedor, fivendnm, nmdoc, tipodoc, ofistamp) 
						VALUES (@fistamp, @design, @lordem, @ndoc, @ftstamp, @fno, @fivendedor, @fivendnm, @nmdoc, @tipodoc, '')
					END
				END

				IF @NSERIE<>''
				BEGIN
				 SET @CONT= @CONT+1
				    IF @CONT > 1
					BEGIN
						update ft set SERIES=CAST(SERIES AS VARCHAR(60)) + CAST(',' as VARCHAR(1)) + @NSERIE where ftstamp=@ftstamp
				    END
					ELSE
					BEGIN
						update ft set SERIES=@NSERIE where ftstamp=@ftstamp
					END

					--INDICAR QUE ESTE ARTIGO COM O SERIAL NUMBER @NSERIE JÁ DEU SAIDA DO ARMAZEM
					--UPDATE MA SET NO=@no, CASA=0 WHERE SERIE=@NSERIE AND NOARM=@armazem

					WAITFOR DELAY '00:00:00.050' 
						SET @DateTimeTmp = GETDATE()
				
						SET @DateStr = dbo.DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

					SET @ftmastamp = 'MSS_' + @DateStr + @TimeStr

					IF @DocAnul = 'N'
					BEGIN
						SELECT @mastamp=mastamp FROM MA (NOLOCK) WHERE SERIE=@NSERIE AND NOARM=@armazem

						--Inserir nºs de série nos documentos de faturação
						INSERT INTO FTMA (ftmastamp,ftstamp,fistamp,mastamp,serie,serie2,ref,design,nome,no,nmdoc,fno,ndoc,fdata,estab,tipodoc,armazem,obs,recnum,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,marcada,maserierpl,serprvef)
						Values(@ftmastamp,@ftstamp,@fistamp,@mastamp,@NSERIE,'',@ref,@design,@nome,@no,@nmdoc,@fno,@ndoc,@rdata,@estab,@tipodoc,@armazem,'',@CONT,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0,'',0)  
					END
				END
				
				IF @@ERROR <> 0
				BEGIN
					SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
					SET @ErrorMessage = 'Insert fi - ' + @ErrorMessage
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				END
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curFI INTO @DocTipo, @DocSerie, @fno, @lordem, @ref, @qtt, @epv, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @fivendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @datalote, @validade, @motiseimp, @DCLACL, @DocUni2, @DCLLIN, @DCLTCL, @DCLQTM, @DCLPRO, @NSERIE, @dcli1v, @dcli2v, @dcli3v
		END
	FIM:
		CLOSE curFI
		DEALLOCATE curFI
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDossInternLin
-- Integração de linhas de dossiers internos
-- *******************************************************************************************************************
ALTER PROCEDURE [dbo].[SPMSS_DocDossInternLin]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@EstabSeparator CHAR(1),
	@no INT,
	@estab INT,
	@bostamp CHAR(25),
	@dataobra DATETIME,
	@rdata DATETIME,
	@local VARCHAR(55),
	@morada VARCHAR(55),
	@codpost VARCHAR(55),
	@nome VARCHAR(55),
	@DCCDCG NUMERIC(18,5),
	@ArmOrigem VARCHAR(30),
	@ArmDestino VARCHAR(30),
	@Entidade VARCHAR(1),
	@DocAnul VARCHAR(1),
	@Imp1 CHAR(10),
	@Imp2 CHAR(10),
	@Imp3 CHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @DocTipo VARCHAR(10)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocLinDescV NUMERIC(18,5)
	DECLARE @DocLinDesc1 NUMERIC(6,2)
	DECLARE @DocLinDesc2 NUMERIC(6,2)
	DECLARE @DocLinDesc3 NUMERIC(6,2)
	DECLARE @DocLinDesc4 NUMERIC(6,2)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocParam INT
	DECLARE @DocParamFor INT
	DECLARE @DocPCusto INT
	DECLARE @DocIVI VARCHAR(1)
	DECLARE @DocDesc NUMERIC(18,5)
	DECLARE @DocUni2 VARCHAR(4)
	DECLARE @DCLACL VARCHAR(2000)
	DECLARE @ArtComissao INT 
	DECLARE @ArtPPond NUMERIC(19,6)
	DECLARE @ArtConv NUMERIC(18,5)
	DECLARE @ArtStock NUMERIC(11,3)
	DECLARE @ArtQttFor NUMERIC(11,3)
	DECLARE @ArtQttCli NUMERIC(11,3)
	DECLARE @ArtQttRec NUMERIC(11,3)
	DECLARE @ArtUsrQtt NUMERIC(11,3)

	DECLARE @CliTipo VARCHAR(20)
	DECLARE @CliTelef VARCHAR(60)
	DECLARE @CliNome VARCHAR(55)
	DECLARE @CliMorada VARCHAR(55)
	DECLARE @CliLocal VARCHAR(43)
	DECLARE @CliCPostal VARCHAR(45)
	DECLARE @CliNCont VARCHAR(18)
	DECLARE @CliPais INT
	DECLARE @CliLocTesoura VARCHAR(50)
	DECLARE @CliContado INT
	
	DECLARE @bistamp CHAR(25)
	DECLARE @ref VARCHAR(60)
	DECLARE @design VARCHAR(60)
	DECLARE @lordem INT
	DECLARE @ndos INT
	DECLARE @nmdos VARCHAR(24)
	DECLARE @armazem INT
	DECLARE @qtt NUMERIC(11,3)
	DECLARE @altura NUMERIC(11,3)
	DECLARE @largura NUMERIC(11,3)
	DECLARE @espessura NUMERIC(11,3)
	DECLARE @moeda VARCHAR(11)
	DECLARE @peso NUMERIC(11,3)
	DECLARE @stipo INT
	DECLARE @usr1 VARCHAR(20)
	DECLARE @usr2 VARCHAR(20)
	DECLARE @usr3 VARCHAR(35)
	DECLARE @usr4 VARCHAR(20)
	DECLARE @usr5 VARCHAR(120)
	DECLARE @usr6 VARCHAR(30)
	DECLARE @ivaincl INT
	DECLARE @cpoc INT
	DECLARE @stns INT
	DECLARE @usalote INT
	DECLARE @lote VARCHAR(30)
	DECLARE @obrano INT
	DECLARE @epu NUMERIC(19,6)
	DECLARE @pu NUMERIC(18,5)
	DECLARE @edebito NUMERIC(19,6)
	DECLARE @debito NUMERIC(18,5)
	DECLARE @eslvu NUMERIC(19,6)
	DECLARE @slvu NUMERIC(18,5)
	DECLARE @ettdeb NUMERIC(19,6)
	DECLARE @ttdeb NUMERIC(18,5)
	DECLARE @esltt NUMERIC(19,6)
	DECLARE @sltt NUMERIC(18,5)
	DECLARE @epcusto NUMERIC(19,6)
	DECLARE @pcusto NUMERIC(18,5)
	DECLARE @ar2mazem INT
	DECLARE @desconto NUMERIC(18,5)
	DECLARE @desc2 NUMERIC(6,2)
	DECLARE @desc3 NUMERIC(6,2)
	DECLARE @desc4 NUMERIC(6,2)
	DECLARE @desc5 NUMERIC(6,2)
	DECLARE @iva NUMERIC(5,2)
	DECLARE @uni2qtt NUMERIC(11,3)
	DECLARE @unidade VARCHAR(4)
	DECLARE @unidad2 VARCHAR(4)
	DECLARE @tabiva INT
	DECLARE @vendedor INT
	DECLARE @vendnm VARCHAR(20)
	DECLARE @eprorc NUMERIC(19,6)
	DECLARE @prorc NUMERIC(18,5)
	DECLARE @codigo VARCHAR(18)
	DECLARE @forref VARCHAR(20) 
	DECLARE @zona VARCHAR(13)
	DECLARE @segmento VARCHAR(25)
	DECLARE @familia VARCHAR(18)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)

	DECLARE @fref VARCHAR(20)
	DECLARE @ccusto VARCHAR(20)
	DECLARE @datalote VARCHAR(8)
	DECLARE @validade VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	DECLARE @lifref INT 
	DECLARE @stocks INT

	DECLARE @refCorTam VARCHAR(60)
	DECLARE @Cor VARCHAR(25)
	DECLARE @Tam VARCHAR(25)
	DECLARE @Texteis INT
	DECLARE @DCLLIN INT
	DECLARE @DCLTCL CHAR(1)
	DECLARE @DCLQTM NUMERIC(11,3)

	DECLARE @ExerDocOrig VARCHAR(30)
	DECLARE @TipoDocOrig VARCHAR(10)
	DECLARE @SerieDocOrig VARCHAR(10)
	DECLARE @NumDocOrig INT
	DECLARE @LinDocOrig INT

	DECLARE @orilinstamp VARCHAR(25)
	DECLARE @oriheadstamp VARCHAR(25)
	DECLARE @orindoc INT

	DECLARE @To_Close INT
	DECLARE @QtdPend NUMERIC(11,3)

	DECLARE @NSERIE VARCHAR(60)
	DECLARE @CONT INT
	DECLARE @NOSERIE INT
	DECLARE @mastamp CHAR(25)
	DECLARE @bomastamp CHAR(25)
	DECLARE @situacao CHAR(60)
	DECLARE @bdemp	VARCHAR(2)

	SET @CONT = 0
	
	/*impostos*/
	DECLARE @dcli1v NUMERIC (19,6)
	DECLARE @dcli2v NUMERIC(19,6)
	DECLARE @dcli3v NUMERIC(19,6)
	DECLARE @ecovalor NUMERIC(19,6)
	DECLARE @etecoval NUMERIC (19,6)
	DECLARE @eecoval NUMERIC (19,6)
	DECLARE @temeco INT
	DECLARE @ECONOTCALC INT

	DECLARE curBI CURSOR FOR
	SELECT 
		ISNULL(DCLTPD, ''),
		ISNULL(DCLSER, ''),
		ISNULL(DCLNDC, 0),
		CASE WHEN DCLLIN < 1000 THEN ISNULL(DCLLIN*10000, 0)
		ELSE DCLLIN END,
		ISNULL(DCLART, ''),
		ISNULL(DCLQTD, 0.0),
		ISNULL(DCLPRU, 0.0),
		ISNULL(DCLTXI, 0.0),
		ISNULL(DCLTDC, 0.0),
		ISNULL(DCLTD2, 0.0),
		ISNULL(DCLTD3, 0.0),
		ISNULL(DCLTD4, 0.0),
		ISNULL(DCTLOT, ''),
		ISNULL(DCLDSA, ''),
		ISNULL(DCLVD1, 0.0),
		ISNULL(DCLUND, ''),
		ISNULL(DCLALT, 0.0),
		ISNULL(DCLLGR, 0.0),
		ISNULL(DCLCMP, 0.0),
		ISNULL(DCLPES, 0.0),
		ISNULL(DCLVND, ''),
		ISNULL(DCLTERM, 0),
		ISNULL(DCLIVI, 'N'),
		ISNULL(DCLVLD, 0),
		ISNULL(DCLIVA, 0),
		ISNULL(DCLQT2, 0),
		ISNULL(DCTDTL, ''),
		ISNULL(DCTDVL, ''),
		ISNULL(DCLUN2, ''),
		ISNULL(DCLACL, ''),
		ISNULL(DCLLIN, 0),
		ISNULL(DCLTCL, ''),
		ISNULL(DCLQTM, 0),
		ISNULL(DCLOEX, ''),
		ISNULL(DCLOTP, ''),
		ISNULL(DCLOSR, ''),
		ISNULL(DCLOND, 0),
		ISNULL(DCLOLN, 0),
		ISNULL(DCTNSR,''),
		ISNULL(DCLI1V, 0),
		ISNULL(DCLI2V, 0),
		ISNULL(DCLI3V, 0)
	FROM MSDCL(nolock)
	WHERE DCLTIPO = 'P' AND DCLEXR = @DCCEXR AND DCLTPD=@DCCTPD And DCLSER=@DCCSER And DCLNDC=@DCCNDC
	Order By DCLLIN

	OPEN curBI
		FETCH NEXT FROM curBI INTO @DocTipo, @DocSerie, @obrano, @lordem, @ref, @qtt, @epu, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @vendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @datalote, @validade, @DocUni2, @DCLACL, @DCLLIN, @DCLTCL, @DCLQTM, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @NSERIE, @dcli1v, @dcli2v, @dcli3v
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
				SET @ecovalor = 0
			    
				IF (@dcli1v > 0 AND @Imp1='')
					RAISERROR('Documento com imposto 1 sem estar configurado!',16,1)

				IF (@dcli2v > 0 AND @Imp2='')
					RAISERROR('Documento com imposto 2 sem estar configurado!',16,1)

				IF (@dcli3v > 0 AND @Imp3='')
					RAISERROR('Documento com imposto 3 sem estar configurado!',16,1)

				if (upper(@Imp1) = 'ECOVALOR' and @dcli1v>0)
					SET @ecovalor = @dcli1v
				else if (upper(@Imp2) = 'ECOVALOR' and @dcli2v>0)
					SET @ecovalor = @dcli2v
				else if (upper(@Imp3) = 'ECOVALOR' and @dcli3v>0)
					SET @ecovalor = @dcli3v

				SET @eecoval = 0
				SET @etecoval = 0
				SET @TEMECO = 0
				
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @bistamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				-- Verifica se é um artigo com cor e tamanho
				SET @refCorTam = dbo.ExtractFromACL(@DCLACL, 15)
				IF (@refCorTam = 'F')
				BEGIN
					SET @refCorTam = @ref
					EXECUTE SPMSS_GetCorTamanho @DCLACL, @ref OUTPUT, @Cor OUTPUT, @Tam OUTPUT
					SET @Texteis = 1
				END
				ELSE
				BEGIN
					SET @COR = ''
					SET @Tam = ''
					SET @Texteis = 0
				END

				EXECUTE SPMSS_GetDadosDoc 1, @DocTipo, @DocSerie, @ndos OUTPUT, @nmdos OUTPUT, @DocParamFor OUTPUT, @DocParam OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT
				
				EXECUTE SPMSS_GetArtInfo @ref, @usr1 OUTPUT, @usr2 OUTPUT, @usr3 OUTPUT, @usr4 OUTPUT, @usr5 OUTPUT, @usr6 OUTPUT, @familia OUTPUT, @epcusto OUTPUT, @codigo OUTPUT, @forref OUTPUT, @ivaincl OUTPUT, @ArtComissao OUTPUT, @cpoc OUTPUT, @stns OUTPUT, @usalote OUTPUT, @ArtPPond OUTPUT, @unidad2 OUTPUT, @ArtConv OUTPUT,	@ArtStock OUTPUT, @ArtQttFor OUTPUT, @ArtQttCli OUTPUT,	@ArtQttRec OUTPUT, @ArtUsrQtt OUTPUT
				
				EXECUTE SPMSS_GetArtPCusto @ref, @DocPCusto, @epcusto OUTPUT

				EXECUTE SPMSS_GetVendNome @vendedor, @vendnm OUTPUT
				
				SET @stipo = 4
				SET @eprorc = @qtt * @epu

				IF (@DCLTCL = 'Q')
				BEGIN
					SET @uni2qtt = @DCLQTM
					SET @unidad2 = dbo.ExtractFromACL(@DCLACL, 25)
				END
				ELSE
				BEGIN
					IF @unidad2 <> ''
					BEGIN
						IF @DocUni2 <> @unidad2
							SET @uni2qtt = @qtt * @ArtConv
					END
					ELSE
						SET @uni2qtt = 0
				END

				
				IF @usalote = 0
					SET @lote = ''

				IF @DocIVI = 'S'
				begin
					IF (dbo.ExtractFromACL(@DCLACL, 24) <> '')
						SET @DocDesc = CAST(dbo.ExtractFromACL(@DCLACL, 24) AS NUMERIC(19,6))
					ELSE
						SET @DocDesc = 0

					if (@ecovalor > 0)
					BEGIN
						SET @eecoval = @ecovalor
						SET @etecoval = @eecoval * @qtt 
						SET @eslvu = (@epu + @etecoval) / (@iva/100+1) 
						SET @ettdeb = ((@qtt * @epu - @docdesc) + @etecoval)
						SET @esltt = ((@qtt * @epu - @docdesc + @etecoval) / (@iva/100+1))

						SET @TEMECO=1
					END
					ELSE
					BEGIN
						SET @edebito = @epu 
						SET @eslvu = @epu / (@iva/100+1)
						SET @ettdeb = (@qtt * @epu - @docdesc)
						SET @esltt = (@qtt * @epu - @docdesc) / (@iva/100+1)
					END

					SET @ivaincl = 1
				end
				ELSE
				BEGIN
					if (@ecovalor > 0)
					BEGIN
						SET @TEMECO=1
						SET @ECONOTCALC=''
						SET @eecoval = @ecovalor
						set @etecoval= @eecoval * @qtt
						SET @edebito = @epu
						SET @eslvu = @epu + @etecoval 
						SET @ettdeb = (((@qtt * @epu) - @docdesc) + @etecoval)
						SET @esltt = (((@qtt * @epu) - @docdesc) + @etecoval)
					END
					ELSE
					BEGIN
						SET @edebito = @epu
						SET @eslvu = @epu
						SET @ettdeb = @qtt * @epu - @docdesc
						SET @esltt = @qtt * @epu - @docdesc
				    END

					SET @ivaincl = 0
				END
				
				/*Linha com ecovalor*/
				IF @ecovalor > 0
				BEGIN
					EXECUTE SPMSS_DocECOVal @ref, @bistamp, @bostamp, @DocTerminal, 0
					EXECUTE SPMSS_DocECOValP @ref, @bistamp, @bostamp, @DocTerminal, 0
					EXECUTE SPMSS_DocECOValO @ref, @bistamp, @bostamp, @DocTerminal, 0
				END
			
				IF @stocks = 0
				BEGIN
					SET @eslvu = 0
					SET @esltt = 0
				END

				IF (@Entidade = 'F')
				BEGIN
					EXECUTE SPMSS_GetForInfo @no, @estab, @CliTipo OUTPUT, @Zona OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @fref OUTPUT, @ccusto OUTPUT
					SET @Segmento = ''
				END
				ELSE IF (@Entidade = 'P')
				BEGIN
					SET @CliTipo = '' 
					SET @Zona = ''
					SET @CliTelef = ''
					SET @CliPais = ''
					SET @moeda = ''
					SET @fref = ''
					SET @ccusto = ''
					SET @Segmento = ''
				END
				ELSE
					EXECUTE SPMSS_GetCliInfo2 @no, @estab, @CliTipo OUTPUT, @Zona OUTPUT, @Segmento OUTPUT, @CliTelef OUTPUT, @CliPais OUTPUT, @moeda OUTPUT, @CliLocTesoura OUTPUT, @CliContado OUTPUT, @fref OUTPUT, @ccusto OUTPUT

				IF @CliContado is null
					set @CliContado = 0

				SELECT @nome = nome, @morada = morada, @local = local, @codpost = codpost FROM bo WHERE bostamp = @bostamp

				SET @armazem = dbo.StringToNum(@ArmOrigem)
				SET @Ar2mazem = dbo.StringToNum(@ArmDestino)

				EXECUTE SPMSS_CalcDescontos @DocLinDescV, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @epu, @qtt, @DCCDCG, @desconto OUTPUT, @desc2 OUTPUT, @desc3 OUTPUT, @desc4 OUTPUT, @desc5 OUTPUT

				SET @orilinstamp = ''
				SET @oriheadstamp = ''
				
				IF @TipoDocOrig <> ''
				BEGIN
					EXECUTE SPMSS_GetDocOrigStamp @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, '', @orilinstamp OUTPUT, @oriheadstamp OUTPUT, @QtdPend OUTPUT, @orindoc OUTPUT
				END

				INSERT INTO bi2(bi2stamp, bostamp, local,morada,codpost) VALUES (@bistamp, @bostamp, @local,@morada,@codpost)
				
				-- verificar se o lote existe na tabela se e caso não exista fazer o insert antes de inserir a linha
				IF @lote <> ''
				BEGIN
					EXECUTE SPMSS_CheckLote @ref, @design, @lote, @datalote, @validade, @DocTerminal, @rdata
				END

				IF @NSERIE<>''
				BEGIN
					SET @NOSERIE=1
				END
				ELSE
				BEGIN
					SET @NOSERIE=0
				END

				INSERT INTO bi (bistamp, ref, design, lordem, ndos, bostamp, armazem, qtt, altura, largura, espessura, peso, stipo,usr1,usr2,usr3,usr4,usr5,usr6, ivaincl, cpoc, stns, usalote, obrano,epu,pu, edebito,debito,eslvu,slvu,ettdeb,ttdeb, esltt,sltt,no, epcusto,pcusto, ar2mazem,desconto,desc2,desc3,desc4,desc5,iva,dataobra,rdata,uni2qtt,unidade,unidad2,tabiva,vendedor,vendnm,estab,nmdos,local,morada,codpost,nome,eprorc,prorc,codigo,rescli,resfor,forref,zona,segmento,familia,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora, lote, lifref, dataopen, cor, tam, texteis, OBISTAMP, oobistamp, series, noserie,temeco,eecoval,ecoval,etecoval,tecoval) 
				VALUES (@bistamp, @ref, @design, @lordem, @ndos, @bostamp, @armazem, @qtt, @altura, @largura, @espessura, @peso, @stipo, @usr1,@usr2,@usr3,@usr4,@usr5,@usr6, @ivaincl, @cpoc, @stns, @usalote, @obrano, @epu, dbo.EurToEsc(@epu), @edebito, dbo.EurToEsc(@edebito), @eslvu, dbo.EurToEsc(@eslvu), @ettdeb, dbo.EurToEsc(@ettdeb), @esltt, dbo.EurToEsc(@esltt), @no, @epcusto, dbo.EurToEsc(@epcusto), @ar2mazem,@desconto,@desc2,@desc3,@desc4,@desc5,@iva,@dataobra,@rdata,@uni2qtt,@unidade,@unidad2,@tabiva,@vendedor,@vendnm,@estab,@nmdos,@local,@morada,@codpost,@nome,@eprorc,dbo.EurToEsc(@eprorc),@codigo,@DocParam,@DocParamFor,@forref,@zona,@segmento,@familia,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora, @lote, @lifref, @dataobra, @Cor, @Tam, @Texteis, @orilinstamp, @orilinstamp, @NSERIE, @NOSERIE, @temeco,@eecoval,dbo.EurToEsc(@eecoval),@etecoval,dbo.EurToEsc(@etecoval))
				
				-- Actualizar totais no cabeçalho com base nos valores das linhas
				UPDATE bo SET estot4 = estot4 + @eprorc, esdeb4 = esdeb4 + @ettdeb, ecusto = ecusto + (@epcusto * @qtt) WHERE bostamp = @bostamp

				IF @orilinstamp IS NOT NULL
				BEGIN
					IF @QtdPend = @qtt
					BEGIN
						UPDATE bi SET fechada = 1, datafecho = @rdata WHERE bistamp = @orilinstamp
					END
					
					SELECT @To_Close = COUNT(*) FROM BI(nolock) WHERE bostamp = @oriheadstamp AND fechada = 0 and ref <> ''

					IF @To_Close = 0
					BEGIN
						UPDATE bo SET fechada = 1, datafecho = @rdata WHERE bostamp = @oriheadstamp			
					END
				END

				/*Processamento dos nºs de série*/
				IF @NSERIE<>''
				BEGIN
				 SET @CONT= @CONT+1
				    IF @CONT > 1
					BEGIN
						update bo set SERIES=CAST(SERIES AS VARCHAR(60)) + CAST(',' as VARCHAR(1)) + @NSERIE where bostamp=@bostamp
				    END
					ELSE
					BEGIN
						update bo set SERIES=@NSERIE where bostamp=@bostamp
					END

				    SELECT @mastamp=mastamp, @situacao=situacao FROM MA WHERE SERIE=@NSERIE AND NOARM=@ArmOrigem

					--UPDATE MA SET noarm=@ArmDestino, armdatain=@usrdata, usrdata=@usrdata, usrhora=@usrhora WHERE SERIE=@NSERIE AND NOARM=@ArmOrigem

					WAITFOR DELAY '00:00:00.050' 
						SET @DateTimeTmp = GETDATE()
				
						SET @DateStr = dbo.DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

					SET @bomastamp = 'MSS_' + @DateStr + @TimeStr

					IF @DocAnul = 'N'
					BEGIN
						--Inserir nºs de série nos documentos de faturação
						INSERT INTO boma (bomastamp,bostamp,bistamp,serie,serie2,ref,design,marca,maquina,tipo,fref,ccusto,ncusto,situacao,nome,no,estab,nmdos,obrano,dataobra,armazem,ar2mazem,bdemp,ctrmastamp,mastamp,ndos,foserie,ftserie,trfarm,retequi,producao,refprod,recnum,obs,user1,user2,user3,user4,emconf,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,marcada,trocaequi,ocliequi,maserierpl,serprvef)
						Values(@bomastamp,@bostamp,@bistamp,@NSERIE,'',@ref,@design,@usr1,@usr2,@usr4,'','','',@situacao,@nome,@no,@estab,@nmdos,@obrano,@usrdata,@armazem,@ArmDestino,@bdemp,'',@mastamp,@ndos,0,0,1,0,0,0,@CONT,'','','','','',0,@usrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0,0,0,'',0)  
					END
				END

				EXECUTE SPMSS_DocDossInternLinUSR @DCCEXR, @DCCTPD, @DCCSER, @obrano, @bostamp, @bistamp, @no, @ref, @DCLLIN

			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				GOTO FIM
			
			END CATCH
			
			FETCH NEXT FROM curBI INTO @DocTipo, @DocSerie, @obrano, @lordem, @ref, @qtt, @epu, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @vendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @datalote, @validade, @DocUni2, @DCLACL, @DCLLIN, @DCLTCL, @DCLQTM, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @NSERIE, @dcli1v, @dcli2v, @dcli3v
			
		END
	FIM:
		CLOSE curBI
		DEALLOCATE curBI
END
GO


-- *******************************************************************************************************************
-- Stored Procedure SPMSS_DocDocComprasLin
-- Integração de linhas de documentos de facturação
-- *******************************************************************************************************************

ALTER PROCEDURE [dbo].[SPMSS_DocDocComprasLin]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT,
	@fostamp CHAR(25),
	@rdata DATETIME,
	@DCCDCG NUMERIC(18,5),
	@DCCARO VARCHAR(30),
	@DCCARD VARCHAR(30),
	@DCCTSF VARCHAR(10),
	@DocNome VARCHAR(20),
	@DCCRQC VARCHAR(30),
	@estab INT,
	@no INT,
	@nome Varchar(55),
	@ccusto VARCHAR(20),
	@DocAnul CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateStr CHAR(8)
	DECLARE @TimeStr CHAR(11)
	DECLARE @DateTimeTmp DATETIME
	DECLARE @DocTipo VARCHAR(10)
	DECLARE @DocSerie VARCHAR(10)
	DECLARE @DocLinDescV NUMERIC(18,5)
	DECLARE @DocLinDesc1 NUMERIC(6,2)
	DECLARE @DocLinDesc2 NUMERIC(6,2)
	DECLARE @DocLinDesc3 NUMERIC(6,2)
	DECLARE @DocLinDesc4 NUMERIC(6,2)
	DECLARE @DocTerminal VARCHAR(5)
	DECLARE @DocIVI VARCHAR(1)
	DECLARE @DocDesc NUMERIC(18,5)
	DECLARE @DocUni2 VARCHAR(4)
	DECLARE @ArtPPond NUMERIC(19,6)
	DECLARE @ArtConv NUMERIC(19,6)
	DECLARE @ArtStock NUMERIC(11,3)
	DECLARE @ArtQttFor NUMERIC(11,3)
	DECLARE @ArtQttCli NUMERIC(11,3)
	DECLARE @ArtQttRec NUMERIC(11,3)
	DECLARE @ArtUsrQtt NUMERIC(11,3)
	DECLARE @ArtForref VARCHAR(20)

	DECLARE @ForTipo VARCHAR(20)
	DECLARE @ForTelef VARCHAR(60)
	DECLARE @ForNome VARCHAR(55)
	DECLARE @ForMorada VARCHAR(55)
	DECLARE @ForLocal VARCHAR(43)
	DECLARE @ForCPostal VARCHAR(45)
	DECLARE @ForNCont VARCHAR(18)
	DECLARE @ForPais INT
	DECLARE @ForZona VARCHAR(20)
	DECLARE @ForSegmento VARCHAR(25)

	DECLARE @fnstamp CHAR(25)
	DECLARE @ref VARCHAR(60)
	DECLARE @design VARCHAR(60)
	DECLARE @lordem INT
	DECLARE @ndoc INT
	DECLARE @armazem INT
	DECLARE @qtt NUMERIC(11,3)
	DECLARE @altura NUMERIC(11,3)
	DECLARE @largura NUMERIC(11,3)
	DECLARE @espessura NUMERIC(11,3)
	DECLARE @peso NUMERIC(11,3)
	DECLARE @usr1 VARCHAR(20)
	DECLARE @usr2 VARCHAR(20)
	DECLARE @usr3 VARCHAR(35)
	DECLARE @usr4 VARCHAR(20)
	DECLARE @usr5 VARCHAR(120)
	DECLARE @usr6 VARCHAR(30)
	DECLARE @ivaincl INT
	DECLARE @cpoc INT
	DECLARE @stns INT
	DECLARE @usalote INT 
	DECLARE @lote VARCHAR(30)
	DECLARE @fno INT
	DECLARE @epv NUMERIC(19,6)
	DECLARE @pv NUMERIC(18,5)
	DECLARE @etiliquido NUMERIC(19,6)
	DECLARE @tiliquido NUMERIC(18,5)
	DECLARE @eslvu NUMERIC(19,6)
	DECLARE @slvu NUMERIC(18,5)
	DECLARE @epcp NUMERIC(19,6)
	DECLARE @pcp NUMERIC(18,5) 
	DECLARE @esltt NUMERIC(19,6)
	DECLARE @sltt NUMERIC(18,5)
	DECLARE @ecusto NUMERIC(19,6)
	DECLARE @custo NUMERIC(18,5)
	DECLARE @desconto NUMERIC(6,2)
	DECLARE @desc2 NUMERIC(6,2)
	DECLARE @desc3 NUMERIC(6,2)
	DECLARE @desc4 NUMERIC(6,2)
	DECLARE @desc5 NUMERIC(6,2)
	DECLARE @iva NUMERIC(6,2)
	DECLARE @uni2qtt NUMERIC(11,3)
	DECLARE @unidade VARCHAR(4)
	DECLARE @unidad2 VARCHAR(4)
	DECLARE @tabiva INT
	DECLARE @fivendedor INT
	DECLARE @fivendnm VARCHAR(20)
	DECLARE @nmdoc VARCHAR(20)
	DECLARE @ecomissao INT 
	DECLARE @tipodoc INT
	DECLARE @tipodocFor INT
	DECLARE @tliquido NUMERIC(18,5)
	DECLARE @codigo VARCHAR(18)
	DECLARE @familia VARCHAR(18)
	DECLARE @ousrinis VARCHAR(30)
	DECLARE @ousrdata DATETIME
	DECLARE @ousrhora VARCHAR(8)
	DECLARE @usrinis VARCHAR(30)
	DECLARE @usrdata DATETIME
	DECLARE @usrhora VARCHAR(8)
	DECLARE @datalote VARCHAR(8)
	DECLARE @validade VARCHAR(8)
	
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	
	DECLARE @ExerDocOrig VARCHAR(30)
	DECLARE @TipoDocOrig VARCHAR(10)
	DECLARE @SerieDocOrig VARCHAR(10)
	DECLARE @NumDocOrig INT
	DECLARE @LinDocOrig INT
	
	DECLARE @orilinstamp VARCHAR(25)
	DECLARE @oriheadstamp VARCHAR(25)
	DECLARE @orindoc INT
	
	DECLARE @To_Close INT
	DECLARE @QtdPend NUMERIC(11,3)
	DECLARE @Sinal NUMERIC(6,2)

	DECLARE @DocPCusto INT
	DECLARE @lifref INT
	DECLARE @stocks INT

	DECLARE @morada VARCHAR(55)
	DECLARE @local VARCHAR(43)
	DECLARE @codpost VARCHAR(45)
	DECLARE @moradaentrega VARCHAR(55)
	DECLARE @localentrega VARCHAR(43)
	DECLARE @codpostentrega VARCHAR(45)

	DECLARE @motiseimp VARCHAR(60)
	DECLARE @codmotiseimp VARCHAR(3)
	DECLARE @DCLACL VARCHAR(2000)

	DECLARE @refCorTam VARCHAR(60)
	DECLARE @Cor VARCHAR(25)
	DECLARE @Tam VARCHAR(25)
	DECLARE @Texteis INT
	DECLARE @DCLLIN INT
	DECLARE @bdemp	VARCHAR(2)

	DECLARE @NSERIE VARCHAR(60)
	DECLARE @CONT INT
	DECLARE @NOSERIE INT
	DECLARE @bomastamp CHAR(25)
	DECLARE @situacao CHAR(60)
	DECLARE @mastamp CHAR(25)
	DECLARE @fomastamp CHAR(25)

	SET @CONT = 0

	DECLARE curFN CURSOR FOR
	SELECT 
		ISNULL(DCLTPD, ''),
		ISNULL(DCLSER, ''),
		ISNULL(DCLNDC, 0),
		CASE WHEN DCLLIN < 1000 THEN ISNULL(DCLLIN*10000, 0)
		ELSE DCLLIN END,
		ISNULL(DCLART, ''),
		ISNULL(DCLQTD, 0.0),
		ISNULL(DCLPRU, 0.0),
		ISNULL(DCLTXI, 0.0),
		ISNULL(DCLTDC, 0.0),
		ISNULL(DCLTD2, 0.0),
		ISNULL(DCLTD3, 0.0),
		ISNULL(DCLTD4, 0.0),
		ISNULL(DCTLOT, ''),
		ISNULL(DCLDSA, ''),
		ISNULL(DCLVD1, 0.0),
		ISNULL(DCLUND, ''),
		ISNULL(DCLALT, 0.0),
		ISNULL(DCLLGR, 0.0),
		ISNULL(DCLCMP, 0.0),
		ISNULL(DCLPES, 0.0),
		ISNULL(DCLVND, ''),
		ISNULL(DCLTERM, 0),
		ISNULL(DCLIVI, 'N'),
		ISNULL(DCLVLD, 0),
		ISNULL(DCLIVA, 0),
		ISNULL(DCLQT2, 0),
		ISNULL(DCLOEX, ''),
		ISNULL(DCLOTP, ''),
		ISNULL(DCLOSR, ''),
		ISNULL(DCLOND, 0),
		ISNULL(DCLOLN, 0),
		ISNULL(DCTDTL, ''),
		ISNULL(DCTDVL, ''),
		ISNULL(DCLPLI, ''),
		ISNULL(DCLACL, ''),
		ISNULL(DCLUN2, ''),
		ISNULL(DCLLIN, 0),
		ISNULL(DCTNSR,'')
	FROM MSDCL(nolock)
	WHERE DCLEXR = @DCCEXR AND DCLTPD = @DCCTPD AND DCLSER = @DCCSER AND DCLNDC = @DCCNDC

	OPEN curFN
		
		FETCH NEXT FROM curFN INTO @DocTipo, @DocSerie, @fno, @lordem, @ref, @qtt, @epv, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @fivendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @datalote, @validade, @motiseimp, @DCLACL, @DocUni2, @DCLLIN, @NSERIE
		
		WHILE @@FETCH_STATUS = 0 BEGIN
			BEGIN TRY
			
				WAITFOR DELAY '00:00:00.200' 
				SET @DateTimeTmp = GETDATE()
				
				SET @DateStr = dbo.DateToString(@DateTimeTmp)
				SET @TimeStr = dbo.TimeToString(@DateTimeTmp)
				
				SET @fnstamp = 'MSS_' + @DateStr + @TimeStr

				SET @ousrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))
				SET @usrinis = 'MSS T-' + CAST(@DocTerminal AS VARCHAR(3))

				SET @ousrdata = @DateStr
				SET @usrdata = @DateStr

				SET @armazem = dbo.StringToNum(@DCCARO)
				IF @armazem <= 0
					SET @armazem = dbo.StringToNum(@DCCARD)
				IF (@armazem ='')
					SET @armazem = @fivendedor
				
				SET @ousrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)
				SET @usrhora = LEFT(@TimeStr, 2) + ':' + SUBSTRING(@TimeStr, 3, 2) + ':' + SUBSTRING(@TimeStr, 5, 2)

				-- Verifica se é um artigo com cor e tamanho
				SET @refCorTam = dbo.ExtractFromACL(@DCLACL, 15)
				IF (@refCorTam = 'F')
				BEGIN
					SET @refCorTam = @ref
					EXECUTE SPMSS_GetCorTamanho @DCLACL, @ref OUTPUT, @Cor OUTPUT, @Tam OUTPUT
					SET @Texteis = 1
				END
				ELSE
				BEGIN
					SET @COR = ''
					SET @Tam = ''
					SET @Texteis = 0
				END
				
				EXECUTE SPMSS_GetDadosDoc 3, @DocTipo, @DocSerie, @ndoc OUTPUT, @nmdoc OUTPUT, @tipodocFor OUTPUT, @tipodoc OUTPUT, @DocPCusto OUTPUT, @lifref OUTPUT, @stocks OUTPUT, @bdemp OUTPUT

				EXECUTE SPMSS_GetArtInfo @ref, @usr1 OUTPUT, @usr2 OUTPUT, @usr3 OUTPUT, @usr4 OUTPUT, @usr5 OUTPUT, @usr6 OUTPUT, @familia OUTPUT, @ecusto OUTPUT, @codigo OUTPUT, @ArtForref OUTPUT, @ivaincl OUTPUT, @ecomissao OUTPUT, @cpoc OUTPUT, @stns OUTPUT, @usalote OUTPUT, @epcp OUTPUT, @unidad2 OUTPUT, @ArtConv OUTPUT,	@ArtStock OUTPUT, @ArtQttFor OUTPUT, @ArtQttCli OUTPUT,	@ArtQttRec OUTPUT, @ArtUsrQtt OUTPUT
				
				EXECUTE SPMSS_GetArtPCusto @ref, @DocPCusto, @ecusto OUTPUT
				
				EXECUTE SPMSS_GetVendNome @fivendedor, @fivendnm OUTPUT
				
				IF @usalote = 0
					SET @lote = ''
				
				IF @tipodoc = 3	 --******************* Quando são notas de crédito os totais têm de ser integrados com sinal negativo
					SET @Sinal = -1
				ELSE
					SET @Sinal = 1
				
				SET @etiliquido = (@qtt * @epv - @DocDesc) * @Sinal
				SET @tliquido = ((@qtt * @epv - @DocDesc) * (@iva/100+1)) * @Sinal
				
				IF @DocIVI = 'S'
				begin
					SET @eslvu = @epv - round((@DocDesc / @qtt), 2) / (@iva/100+1)
					SET @esltt = (@qtt * @epv - @DocDesc) / (@iva/100+1)
					SET @ivaincl = 1
				end
				ELSE
				BEGIN
					SET @eslvu = @epv - round((@DocDesc / @qtt), 2)
					SET @esltt = @qtt * @epv - @DocDesc
					SET @ivaincl = 0
				END
				
				IF @unidad2 <> ''
				BEGIN
					IF @DocUni2 <> @unidad2
						SET @uni2qtt = @qtt * @ArtConv
				END
				ELSE
					SET @uni2qtt = 0
				
				EXECUTE SPMSS_CalcDescontos @DocLinDescV, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @epv, @qtt, @DCCDCG, @desconto OUTPUT, @desc2 OUTPUT, @desc3 OUTPUT, @desc4 OUTPUT, @desc5 OUTPUT
				
				SET @orilinstamp = ''
				SET @oriheadstamp = ''
				
				IF @TipoDocOrig <> ''
				BEGIN
					EXECUTE SPMSS_GetDocOrigStamp @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @DCCTSF, @orilinstamp OUTPUT, @oriheadstamp OUTPUT, @QtdPend OUTPUT, @orindoc OUTPUT
				END
				-- verificar se o lote existe na tabela se e caso não exista fazer o insert antes de inserir a linha
				IF @lote <> ''
				BEGIN
					EXECUTE SPMSS_CheckLote @ref, @design, @lote, @datalote, @validade, @DocTerminal, @rdata
				END
				
				-- ler dados do local de entrega
				SELECT @morada = DCCMOR, @local = DCCLOC, @codpost = DCCCPT, @moradaentrega = DCCEMO, @localentrega = DCCELO, @codpostentrega = DCCECP FROM MSDCC(nolock)	WHERE DCCEXR = @DCCEXR AND DCCTPD = @DCCTPD AND DCCSER = @DCCSER AND DCCNDC = @DCCNDC
				IF (@moradaentrega = '') AND (@localentrega = '') AND (@codpostentrega = '')
				BEGIN
					SET @moradaentrega = @morada
					SET @localentrega = @local
					SET @codpostentrega = @codpost
				END

				SET @codmotiseimp = dbo.ExtractFromACL(@DCLACL, 12)


				IF @orilinstamp IS NULL
						SET @orilinstamp = ''	
						
				IF @NSERIE<>''
				BEGIN
					SET @NOSERIE=1
				END
				ELSE
				BEGIN
					SET @NOSERIE=0
				END
								

					INSERT INTO fn(fnstamp, ref, design, docnome, adoc, qtt, iva, ivaincl, tabiva, armazem, lordem, data, etiliquido, epv, eslvu, esltt, desconto, desc2, desc3, desc4, usr1, usr2, usr3, usr4, usr5, usr6, familia, ncmassa, ncunsup, fostamp, ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora,noserie,series) 
					VALUES(@fnstamp, @ref, @design, @docnome, @DCCRQC, @qtt, @iva, @ivaincl, @tabiva, @armazem, @lordem, @rdata, @etiliquido, @epv, @eslvu, @esltt,  @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4,  @usr1, @usr2, @usr3, @usr4, @usr5, @usr6, @familia, @qtt, @qtt, @fostamp, @ousrinis, @ousrdata, @ousrhora, @usrinis, @usrdata, @usrhora,@noserie,@NSERIE)

					EXEC SPMSS_DocDocComprasLinUSR @DCCEXR,@DCCTPD,@DCCSER,@DCCNDC,@fostamp,@fnstamp,@ref,@DCLLIN

				/*Processamento dos nºs de série*/
				IF @NSERIE<>''
				BEGIN
				 SET @CONT= @CONT+1
				    IF @CONT > 1
					BEGIN
						update fo set SERIES=CAST(SERIES AS VARCHAR(60)) + CAST(',' as VARCHAR(1)) + @NSERIE where fostamp=@fostamp
				    END
					ELSE
					BEGIN
						update fo set SERIES=@NSERIE where fostamp=@fostamp
					END

					WAITFOR DELAY '00:00:00.050' 
						SET @DateTimeTmp = GETDATE()
				
						SET @DateStr = dbo.DateToString(@DateTimeTmp)
						SET @TimeStr = dbo.TimeToString(@DateTimeTmp)

					SET @fomastamp = 'MSS_' + @DateStr + @TimeStr

					IF @DocAnul = 'N'
					BEGIN
						INSERT INTO FOMA (fomastamp,fostamp,fnstamp,serie,ref,design,marca,maquina,tipo,ccusto,situacao,nome,no,estab,nmdoc,adoc,data,armazem,doccode,recnum,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,marcada)
						Values(@fomastamp,@fostamp,@fnstamp,@NSERIE,@ref,@design,@usr1,@usr2,@usr4,@ccusto,'Disponivel',@nome,@no,@estab,@docnome,@DCCRQC,@usrdata,@armazem,@DocSerie,@CONT,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0)		
					END

					--INSERT INTO FOMA (fomastamp,fostamp,fnstamp,serie,ref,design,marca,maquina,tipo,ccusto,situacao,nome,no,estab,nmdoc,adoc,data,armazem,doccode,recnum,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora,marcada)
					--Values(@fomastamp,@fostamp,@fnstamp,@NSERIE,@ref,@design,@usr1,@usr2,@usr4,@ccusto,'Disponivel',@nome,@no,@estab,@docnome,@DCCRQC,@usrdata,@armazem,@DocSerie,@CONT,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora,0)		

					/*INSERT INTO MA (mastamp,tipo,no,situacao,serie,marca,maquina,ref,design,casa,retfor,armdatain,noarm,estab,ccusto,periodo,vendedor,flnome,flno,flestab,flnomea,flnoa,flestaba,flnmdoc,fladoc,fldata,snno,ftnmdoc,ftfno,ftndoc,psobs,foorigem,fomastamp,fostamp,indisponivel,focl,ousrinis,ousrdata,ousrhora,usrinis,usrdata,usrhora)
					VALUES (@mastamp,@usr4,0,'Disponivel',@NSERIE,@usr1,@usr2,@ref, @design,1,0,@usrdata,@armazem,@estab,@ccusto,0,0,@nome,@no,@estab,'',0,0,@docnome,@DCCRQC,@usrdata,0,'',0,0,'','FO',@fomastamp,@fostamp,0,0,@ousrinis,@ousrdata,@ousrhora,@usrinis,@usrdata,@usrhora)*/

				END
				
				IF @@ERROR <> 0
				BEGIN
					SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
					SET @ErrorMessage = 'Insert fn - ' + @ErrorMessage
					RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				END
			END TRY
			BEGIN CATCH
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
				
				GOTO FIM
			END CATCH
			
			FETCH NEXT FROM curFN INTO @DocTipo, @DocSerie, @fno, @lordem, @ref, @qtt, @epv, @iva, @DocLinDesc1, @DocLinDesc2, @DocLinDesc3, @DocLinDesc4, @lote, @design, @DocLinDescV, @unidade, @altura, @largura, @espessura, @peso, @fivendedor, @DocTerminal, @DocIVI, @Docdesc, @TabIva, @uni2qtt, @ExerDocOrig, @TipoDocOrig, @SerieDocOrig, @NumDocOrig, @LinDocOrig, @datalote, @validade, @motiseimp, @DCLACL, @DocUni2, @DCLLIN, @NSERIE
		END
	FIM:
		CLOSE curFN
		DEALLOCATE curFN
END
GO
