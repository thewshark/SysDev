CREATE PROCEDURE [dbo].[SPMYMSS_GetStatusFromDocuments]
	@DateFrom VARCHAR(8), -- Formato YYYYMMDD
	@TimeFrom VARCHAR(8),  -- Formato HH:MM:SS porque usrhora é alfanumérico
	@DocumentsSeries VARCHAR(1000) -- Séries dos documentos configurados  separados por vírgula
AS
BEGIN
	SET NOCOUNT ON;

	SELECT boano AS DCCEXR, '' AS DCCTPD, ndos AS DCCSER, obrano AS DCCNDC, '' AS DocStatus, '' AS DocAdditionalStatusMessage, '' AS DocStatusDate, '' AS DocStatusTime FROM bo (nolock) WHERE ndos IN (@DocumentsSeries) AND (ousrdata > @DateFrom OR (ousrdata = @DateFrom AND ousrhora >= @TimeFrom))
END