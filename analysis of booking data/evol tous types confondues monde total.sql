-- MSSQL Server script

-- @input is user declared [country code]. It measures the change in supply between 2020 and 2021, there is a distinction for segments nor types of accomodation.

-- Developper's note: Schema for 2020 and 2021 are different. From 2021 and onwards, schemas should be harmonized. This script shall be adjusted once that occurs.

DECLARE @input AS VARCHAR(100)
SET @input = 'es'
DECLARE @input_2021 AS VARCHAR(100)
SET @input_2021 = UPPER(@input)
DECLARE @input_2020 AS VARCHAR(100)
SET @input_2020 = CONCAT('%/',LOWER(@input),'/%')

SELECT	2021 as 'YEAR',
		count(*) as NB_HOTELS
		FROM Booking2021 where PAYS=@input_2021 and TYPE_ LIKE '%H�tel%'

UNION

SELECT
		2020 as 'YEAR',
		count(*)
		FROM Booking2020 where URL_ LIKE @input_2020 and TYPE_ETABLISSEMENT LIKE '%H�tel%'
