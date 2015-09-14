/*
T-SQL Basic Windowing

Percentages

Copyright 2014 Steve Jones

This code is provided as is with no warranty implied.

*/

USE WindowDemo
GO

-- PERCENTILE_DIST()

-- get total home runs by player by month

select
	player
	, datename(m, hrdate) as 'Month of HR'
	, sum(hrcount)as 'Total HRs'
	, datepart(m, hrdate) as 'MonthNum'
	from dbo.HomeRuns HR
	group by 
		player
		, datename(m, hrdate)
		, datepart(m, hrdate)
	order by
		datepart(m, hrdate)
		, player
;
go




select
	player
	, datename(m, hrdate) as 'Month of HR'
	, sum(hrcount)as 'Total HRs'
	, percent_rank() over
	 (
		order by hrcount
	 ) AS 'PercentRank'
	from dbo.HomeRuns HR
	group by 
		player
		, datename(m, hrdate)
		, datepart(m, hrdate)
		, hrcount
	order by
		datepart(m, hrdate)
		, player
;
go
