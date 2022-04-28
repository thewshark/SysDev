CREATE PROCEDURE [dbo].[SPMYMSS_GetStatusFromDoc]
	@DCCEXR VARCHAR(30),
	@DCCTPD VARCHAR(10),
	@DCCSER VARCHAR(4),
	@DCCNDC INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT '' AS DocStatus, '' AS DocAdditionalStatusMessage, '' AS DocStatusDate, '' AS DocStatusTime FROM bo WHERE boano = @DCCEXR AND ndos = @DCCSER AND obrano = @DCCNDC
END