/*
T-SQL Basic Windowing

First and Last values

Copyright 2014 Steve Jones

This code is provided as is with no warranty implied.

*/

USE WindowDemo
GO


-- Get the first value of a frame
SELECT 
	player
,	FIRST_VALUE(player) OVER
		(
			ORDER BY player
		)
 FROM dbo.HomeRuns
 ;
 GO
 
-- Get the last value
SELECT 
	player
,	LAST_VALUE(player) OVER
		(
			ORDER BY player
		)
 FROM dbo.HomeRuns
 ;
 GO
 

 -- Why does the name change?




-- default framing - Unbounded preceeding and current row
-- try again
 SELECT 
	player
,	LAST_VALUE(player) OVER
		(
			ORDER BY player
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
		)
 FROM dbo.HomeRuns
 ;
 GO



 -- Put these together
SELECT 
	player
,	FIRST_VALUE(player) OVER
		(
			ORDER BY player
		) AS 'First player'
,	LAST_VALUE(player) OVER
		(
			ORDER BY player
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
		) AS 'Last Player'
 FROM dbo.HomeRuns
 ;
 GO



 -- IF we want this to "run", then
SELECT 
	player
,	FIRST_VALUE(player) OVER
		(
			ORDER BY player
		) AS 'First player'
,	LAST_VALUE(player) OVER
		(
			ORDER BY player
		) AS 'Last Player'
 FROM dbo.HomeRuns
 ;
 GO


 -- get first and last, absolutely
select
	player
	, first_value(player) over
	 (
		order by player
		rows unbounded preceding
	 ) as 'First'
	, last_value(player) over
	 (
		order by player
		rows between unbounded preceding and unbounded following
	 ) as 'Last'
 from dbo.HomeRuns HR
 ;

 --
