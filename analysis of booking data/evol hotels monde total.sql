-- MSSQL Server script

-- @input is user declared [country code]. It measures the change in supply between 2020 and 2021, no distinction for segments

-- Developper's note: Schema for 2020 and 2021 are different. From 2021 and onwards, schemas should be harmonized. This script shall be adjusted once that occurs.


DECLARE @input AS VARCHAR(100)
SET @input = 'qa'
DECLARE @input_2021 AS VARCHAR(100)
SET @input_2021 = UPPER(@input)
DECLARE @input_2020 AS VARCHAR(100)
SET @input_2020 = CONCAT('%/',LOWER(@input),'/%')

SELECT	count(*)
		FROM Booking2021 where TYPE_ LIKE '%Hôtel%' and PAYS=@input_2021

UNION

SELECT	count(*)
		FROM Booking2020 where TYPE_ETABLISSEMENT LIKE '%Hôtel%' and URL_ LIKE @input_2020
