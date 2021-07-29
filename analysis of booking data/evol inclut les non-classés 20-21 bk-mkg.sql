-- MSSQL Server Script, the variable @input is user declared.
-- The script gives out the supply of hotels for a given country in 2020 and 2021, across segments, including those that do not belong to any.
-- The ouput can be inserted into an Excel spreadsheet that extends the time series into according to the resutls
-- Developper's note: Schema for 2020 and 2021 are different. From 2021 and onwards, schemas should be harmonized. This script shall be adjusted once that occurs.

DECLARE @input AS VARCHAR(100)
SET @input = 'hu'
DECLARE @input_2021 AS VARCHAR(100)
SET @input_2021 = UPPER(@input)
DECLARE @input_2020 AS VARCHAR(100)
SET @input_2020 = CONCAT('%/',LOWER(@input),'/%')

select
	2021 as 'YEAR',
	round(sum(tcd.mkg_0*_2021),0) AS 'mkg_0',
	round(sum(tcd.mkg_1*_2021),0) AS 'mkg_1',
	round(sum(tcd.mkg_2*_2021),0) AS 'mkg_2',
	round(sum(tcd.mkg_3*_2021),0) AS 'mkg_3',
	round(sum(tcd.mkg_4*_2021),0) AS 'mkg_4',
	round(sum(tcd.mkg_0*_2021),0)+round(sum(tcd.mkg_1*_2021),0)+round(sum(tcd.mkg_2*_2021),0)+round(sum(tcd.mkg_3*_2021),0)+round(sum(tcd.mkg_4*_2021),0) AS 'TOTAL'
	from
	(select
		*
		from
		(select
		CONCAT(@input,'-',bk_results.STARS) AS 'CODE',
		bk_results._2021 as '_2021',
		bk_results._2020 as '_2020'
		from
			(select
					STARS_N2021 AS 'STARS',
					sum(NB_2021) as '_2021',
					sum(NB_2020) as '_2020'
					FROM (

						SELECT * FROM (
						  SELECT
							COUNT(URL_) NB_2021,
							CAST(CASE WHEN STARS_ is NULL or STARS_='nan' THEN 0 ELSE CAST(STARS_ AS float) END AS float) STARS_N2021
						  FROM Booking2021 where TYPE_ LIKE '%H�tel%' and PAYS=@input_2021 group by CAST(CASE WHEN STARS_ is NULL or STARS_='nan' THEN 0 ELSE CAST(STARS_ AS float) END AS float)
						) RESULTS2021 FULL JOIN
							(SELECT
								COUNT(URL_) NB_2020,
								CAST(CASE WHEN NBETOILE is NULL THEN 0 ELSE NBETOILE END AS float) STARS_N2020
							FROM Booking2020 where TYPE_ETABLISSEMENT LIKE '%H�tel%' and URL_ LIKE @input_2020 group by CAST(CASE WHEN NBETOILE is NULL THEN 0 ELSE NBETOILE END AS float)
						) RESULTS2020
						ON RESULTS2021.STARS_N2021=RESULTS2020.STARS_N2020) RESULTS_MAIN
						group by STARS_N2021) bk_results) AS results2
						INNER JOIN codes_bk_mkg AS cbm ON results2.CODE=cbm.code_bk_mkg) tcd
UNION

select
	2020 as 'YEAR',
	round(sum(tcd.mkg_0*_2020),0) AS 'mkg_0',
	round(sum(tcd.mkg_1*_2020),0) AS 'mkg_1',
	round(sum(tcd.mkg_2*_2020),0) AS 'mkg_2',
	round(sum(tcd.mkg_3*_2020),0) AS 'mkg_3',
	round(sum(tcd.mkg_4*_2020),0) AS 'mkg_4',
	round(sum(tcd.mkg_0*_2020),0)+round(sum(tcd.mkg_1*_2020),0)+round(sum(tcd.mkg_2*_2020),0)+round(sum(tcd.mkg_3*_2020),0)+round(sum(tcd.mkg_4*_2020),0) AS 'TOTAL'
	from
	(select
		*
		from
		(select
		CONCAT(@input,'-',bk_results.STARS) AS 'CODE',
		bk_results._2021 as '_2021',
		bk_results._2020 as '_2020'
		from
			(select
					STARS_N2021 AS 'STARS',
					sum(NB_2021) as '_2021',
					sum(NB_2020) as '_2020'
					FROM (

						SELECT * FROM (
						  SELECT
							COUNT(URL_) NB_2021,
							CAST(CASE WHEN STARS_ is NULL or STARS_='nan' THEN 0 ELSE CAST(STARS_ AS float) END AS float) STARS_N2021
						  FROM Booking2021 where TYPE_ LIKE '%H�tel%' and PAYS=@input_2021 group by CAST(CASE WHEN STARS_ is NULL or STARS_='nan' THEN 0 ELSE CAST(STARS_ AS float) END AS float)
						) RESULTS2021 FULL JOIN
							(SELECT
								COUNT(URL_) NB_2020,
								CAST(CASE WHEN NBETOILE is NULL THEN 0 ELSE NBETOILE END AS float) STARS_N2020
							FROM Booking2020 where TYPE_ETABLISSEMENT LIKE '%H�tel%' and URL_ LIKE @input_2020 group by CAST(CASE WHEN NBETOILE is NULL THEN 0 ELSE NBETOILE END AS float)
						) RESULTS2020
						ON RESULTS2021.STARS_N2021=RESULTS2020.STARS_N2020) RESULTS_MAIN
						group by STARS_N2021) bk_results) AS results2
						INNER JOIN codes_bk_mkg AS cbm ON results2.CODE=cbm.code_bk_mkg) tcd
