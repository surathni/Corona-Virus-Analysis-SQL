--code to check NULL values--
SELECT *
FROM [Corona Virus Dataset]
WHERE Province is null or Country_Region is null or
Latitude is null or Longitude is null or Date is null or
Confirmed is null or Deaths is null 
or Recovered is null;

--code to check NULL values method 2--
SELECT 
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS Province_Null_Count,
	SUM(CASE WHEN Country_Region IS NULL THEN 1 ELSE 0 END) AS Countryregion_Null_Count,
    SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS Latitude_Null_Count,
    SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS Longitude_Null_Count,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_Null_Count,
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS Confirmed_Null_Count,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS Deaths_Null_Count,
	SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS Recovered_Null_Count
FROM [Corona Virus Dataset];



--Updating null value with 0--
UPDATE [Corona Virus Dataset]
SET Province = COALESCE(Province, 0),
    Country_Region = COALESCE(Country_Region, 0),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date = COALESCE(Date, 0),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);


--total number of rows--
SELECT COUNT(*) AS Total_Rows
FROM [Corona Virus Dataset];



--start_date and end_date--
SELECT 
MIN(TRY_CONVERT(date, Date,103)) AS start_date,
MAX(TRY_CONVERT(date, Date,103)) AS end_date
FROM [Corona Virus Dataset];



--Number of month present in dataset--
SELECT COUNT(DISTINCT CONCAT(YEAR(TRY_CONVERT(date,Date,105)),'-', 
MONTH(TRY_CONVERT(date,Date,105)))) AS NumberOfMonths
FROM [Corona Virus Dataset];


--monthly average for confirmed, deaths, recovered--
SELECT 
    DATEPART(YEAR, TRY_CONVERT(date, Date,105)) AS Year,
    DATEPART(MONTH, TRY_CONVERT(date, Date,105)) AS Month,
    AVG(CONVERT(float, TRY_CONVERT(int, Confirmed))) AS Average_Confirmed,
    AVG(CONVERT(float, TRY_CONVERT(int, Deaths))) AS Average_Deaths,
    AVG(CONVERT(float, TRY_CONVERT(int, Recovered))) AS Average_Recovered
FROM
[Corona Virus Dataset]
WHERE
    DATEPART(YEAR, TRY_CONVERT(date, Date,105)) IN (2020, 2021)
GROUP BY
	DATEPART(YEAR, TRY_CONVERT(date, Date,105)),
	DATEPART(MONTH, TRY_CONVERT(date, Date,105))
ORDER BY
	Year, Month;



--minimum values for confirmed, deaths, recovered per year--

SELECT
	YEAR(TRY_CONVERT(date, Date,105)) AS Year,
	MIN (TRY_CONVERT (int, Confirmed)) AS min_confirmed,
	MIN (TRY_CONVERT (int, Deaths)) AS min_deahs,
	MIN (Recovered) AS min_recovered

FROM 
	[Corona Virus Dataset]
GROUP BY 
	YEAR(TRY_CONVERT(date, Date,105));


--maximum values of confirmed, deaths, recovered per year--


SELECT
	YEAR(TRY_CONVERT(date, Date,105)) AS Year,
	MAX (TRY_CONVERT (int, Confirmed)) AS max_confirmed,
	MAX (TRY_CONVERT (int, Deaths)) AS max_deahs,
	MAX (Recovered) AS max_recovered

FROM 
	[Corona Virus Dataset]
GROUP BY 
	YEAR(TRY_CONVERT(date, Date,105));


--total number of case of confirmed, deaths, recovered each month--


SELECT
	YEAR(TRY_CONVERT(date, Date,105)) AS Year,
	MONTH(TRY_CONVERT(date, Date,105)) AS Month,
	SUM (TRY_CONVERT (int, Confirmed)) AS Total_confirmed,
	SUM (TRY_CONVERT (int, Deaths)) AS Total_deaths,
	SUM (TRY_CONVERT (INT, Recovered)) AS Total_recovered
FROM 
	[Corona Virus Dataset]
GROUP BY 
	YEAR(TRY_CONVERT(date, Date,105)),
	MONTH(TRY_CONVERT(date, Date,105))
ORDER BY
	Year, Month;



--how corona virus spread out with respect to confirmed case--



SELECT
	COUNT(Confirmed) AS TotalConfirmedCases,
	AVG(TRY_CONVERT(BIGINT, Confirmed)) AS AverageConfirmedCases,
	SUM(POWER(TRY_CONVERT(BIGINT, Confirmed) - AVG_Cases.AverageConfirmedCases, 2))/COUNT(Confirmed) AS VarianceConfirmedCases,
	SQRT(SUM(POWER(TRY_CONVERT(BIGINT, Confirmed) - AVG_Cases.AverageConfirmedCases, 2))/COUNT(Confirmed)) AS StdDevConfirmedCases
FROM
[Corona Virus Dataset],
	(SELECT AVG(TRY_CONVERT(BIGINT, Confirmed)) AS AverageConfirmedCases FROM [Corona Virus Dataset]) AS AVG_Cases;


--how corona virus spread out with respect to death case per month--



SELECT
	DATEPART(YEAR, TRY_CONVERT(date, Date,105)) AS Year,
	DATEPART(MONTH, TRY_CONVERT(date, Date,105)) AS Month,
	COUNT(Deaths) AS TotalDeathsCases,
	AVG(TRY_CONVERT(BIGINT, Deaths)) AS AverageDeathsCases,
	SUM(POWER(TRY_CONVERT(BIGINT, Deaths) - AVG_Cases.AverageDeathsCases, 2))/COUNT(Deaths) AS VarianceDeathsCases,
	SQRT(SUM(POWER(TRY_CONVERT(BIGINT, Deaths) - AVG_Cases.AverageDeathsCases, 2))/COUNT(Deaths)) AS StdDevDeathsCases
FROM
[Corona Virus Dataset],
	(SELECT AVG(TRY_CONVERT(BIGINT, Deaths)) AS AverageDeathsCases FROM [Corona Virus Dataset]) AS AVG_Cases

GROUP BY 
	DATEPART(YEAR, TRY_CONVERT(date, Date,105)),
	DATEPART(MONTH, TRY_CONVERT(date, Date,105))

ORDER BY 
Year, Month;



--how corona virus spread out with respect to recovered case--



SELECT
	COUNT(Recovered) AS TotalRecoveredCases,
	AVG(TRY_CONVERT(BIGINT, Recovered)) AS AverageRecoveredCases,
	SUM(POWER(TRY_CONVERT(BIGINT, Recovered) - AVG_Cases.AverageRecoveredCases, 2))/COUNT(Recovered) AS VarianceRecoveredCases,
	SQRT(SUM(POWER(TRY_CONVERT(BIGINT, Recovered) - AVG_Cases.AverageRecoveredCases, 2))/COUNT(Recovered)) AS StdDevRecoveredCases
FROM
[Corona Virus Dataset],
	(SELECT AVG(TRY_CONVERT(BIGINT, Recovered)) AS AverageRecoveredCases FROM [Corona Virus Dataset]) AS AVG_Cases;




--Country having highest number of the Confirmed case--



SELECT TOP 1
	Country_Region AS Country,
	SUM(CAST(Confirmed AS INT)) AS TotalConfirmedCases

FROM
	[Corona Virus Dataset]
WHERE
	ISNUMERIC(Confirmed)=1
GROUP BY
	Country_Region
ORDER BY
	SUM(CAST(Confirmed AS INT)) DESC;


--Country having lowest number of the death case--

SELECT TOP 1
	Country_Region AS Country,
	SUM(CAST(Deaths AS INT)) AS TotalDeathCases

FROM
	[Corona Virus Dataset]
WHERE
	ISNUMERIC(Deaths)=1
GROUP BY
	Country_Region
HAVING 
	SUM(CAST(Confirmed AS INT)) = 0
ORDER BY
	TotalDeathCases ASC;


--top 5 countries having highest recovered case--




SELECT TOP 5
	Country_Region AS Country,
	sum(cast(Recovered AS INT)) AS TotalRecoveredCases
FROM
	[Corona Virus Dataset]
WHERE 
	ISNUMERIC(recovered) =1
GROUP BY
	Country_Region
ORDER BY 
	TotalRecoveredCases DESC;


	





