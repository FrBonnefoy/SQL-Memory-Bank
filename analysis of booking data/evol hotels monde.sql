-- MSSQL Server script

-- @input is user declared [country code]. It measures the change in supply between 2020 and 2021, there is a distinction for segments.

-- Developper's note: Schema for 2020 and 2021 are different. From 2021 and onwards, schemas should be harmonized. This script shall be adjusted once that occurs.


DECLARE @input AS VARCHAR(100)
SET @input = 'pl'
DECLARE @input_2021 AS VARCHAR(100)
SET @input_2021 = UPPER(@input)
DECLARE @input_2020 AS VARCHAR(100)
SET @input_2020 = CONCAT('%/',LOWER(@input),'/%')

SELECT
		COUNT(URL_) NB_2021,
		CAST(STARS_ AS float) STARS_N2021
		FROM Booking2021 where (STARS_ is not NULL and STARS_<>'nan') and TYPE_ LIKE '%H�tel%' and PAYS=@input_2021 group by CAST(STARS_ AS float) order by CAST(STARS_ AS float)

SELECT
	COUNT(URL_) NB_2020,
	CAST(NBETOILE AS float) STARS_N2020
FROM Booking2020 where (NBETOILE is not NULL and NBETOILE<>0) and TYPE_ETABLISSEMENT LIKE '%H�tel%' and URL_ LIKE @input_2020 group by CAST(NBETOILE AS float)
