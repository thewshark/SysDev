CREATE FUNCTION [dbo].[SetString]
(
@Source VARCHAR(2000), 
@Rank INT, 
@Value VARCHAR(1000), 
@Separator INT 
) 
RETURNS VARCHAR(2000) 
AS 
BEGIN 
	DECLARE @Result VARCHAR(1000)
	IF @Source = '' OR @Rank = 0
	BEGIN
		SET @Result = @Source
		GOTO FIM
	END
	DECLARE @NSeparators INT
	DECLARE @SepCount INT 
	DECLARE @PosStart INT 
	DECLARE @PosEnd INT 
	SET @NSeparators = Len(@Source) - Len(Replace(@Source, Char(@Separator), '')) / Len(Char(@Separator))
	IF @NSeparators < @Rank - 1
	BEGIN
		SET @Result = @Source
		WHILE @NSeparators < @Rank - 1
		BEGIN
			SET @Result = @Result + Char(@Separator)
			SET @NSeparators = @NSeparators + 1
		END
		SET @Result = @Result + @Value
	END
	ELSE
	BEGIN
		SET @SepCount = 0 
		SET @PosStart = 0
		SET @PosEnd = 0
		WHILE @SepCount <  @Rank - 1
		BEGIN 
			SET @PosStart = CHARINDEX(CHAR(@Separator), @Source, @PosStart) + 1
			SET @SepCount = @SepCount + 1 
		END 
		SET @PosEnd = CHARINDEX(CHAR(@Separator), @Source, @PosStart) 
		IF @PosStart < 1
			SET @PosStart = 1
		IF LEN(@Source) >= @PosStart and @PosEnd = 0 
			SET @PosEnd = LEN(@Source) + 1 
		SET @Result =  STUFF(@Source, @PosStart, @PosEnd-@PosStart, @Value) 
	END
FIM:
RETURN @Result
END 
GO