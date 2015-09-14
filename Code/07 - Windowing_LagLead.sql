/*
T-SQL Basic Windowing

LEAD and LAG

Copyright 2014 Steve Jones

This code is provided as is with no warranty implied.

*/
USE WindowDemo
GO


 -- ranges of no home runs
 SELECT 
	player
,	'CurrentHR' = hrdate
,	'NextHR' = LEAD(hrdate)
				OVER (
					PARTITION BY player
					ORDER BY hrdate
				)
 FROM dbo.HomeRuns
 ORDER BY
	hrdate
 ;








-- add calculation of lapse
 -- ranges of no home runs
 SELECT 
	player
,	'Days Between HRs' = DATEDIFF(d, hrdate, LEAD(hrdate)
				OVER (
					PARTITION BY player
					ORDER BY hrdate
				)
				) 
,	'CurrentHR' = hrdate
,	'NextHR' = LEAD(hrdate)
				OVER (
					PARTITION BY player
					ORDER BY hrdate
				)
 FROM dbo.HomeRuns
 ORDER BY
	[Days Between HRs] desc
 ;



 -- ugly, clean up the code
 -- ranges of no home runs
 SELECT 
	player
,	'CurrentHR' = hrdate
,	'NextHR' = LEAD(hrdate)
				OVER (
					PARTITION BY player
					ORDER BY hrdate
				)
,	'Days Between HRs' = DATEDIFF(d, hrdate, NextHR) - 1
 FROM dbo.HomeRuns
 ORDER BY
	player
	, hrdate
 ;

 
-- An error


-- can't use this directly because the column doesn't exist, but we can with a CTE
WITH HRGaps AS
(
 SELECT 
	player
,	'CurrentHR' = hrdate
,	'NextHR' = LEAD(hrdate)
				OVER (
					PARTITION BY player
					ORDER BY hrdate
				)
 FROM dbo.HomeRuns
) 
select 
	player
,	'Days Between HRs' = COALESCE( CAST( DATEDIFF(d, CurrentHR, NextHR) - 1 AS VARCHAR(20)), 'Open')
, CurrentHR
, NextHR
 FROM HRGaps
 ORDER BY
	player
	, CurrentHR
;


-- no home runs?
-- Use the same technique
WITH HRGaps AS
(
 SELECT 
	player
,	'CurrentHR' = hrdate
,	'NextHR' = LEAD(hrdate)
				OVER (
					PARTITION BY player
					ORDER BY hrdate
				)
 FROM dbo.HomeRuns
) 
select 
	player
,	'start' = DATEADD( d, 1, CurrentHR)
,   'end' = DATEADD(d, -1, NextHR)
,	'days' = DATEDIFF(d, DATEADD( d, 1, CurrentHR), DATEADD( d, -1, NextHR))
 FROM HRGaps
 WHERE NextHR IS NOT NULL
 ORDER BY
	HRGaps.player
	, CurrentHR
;



-- Change to team, no home runs
WITH    HRGaps
          AS ( SELECT team
                ,   'CurrentHR' = hrdate
                ,   'NextHR' = LEAD(hrdate) OVER ( PARTITION BY team ORDER BY hrdate )
                FROM dbo.HomeRuns
             )
    SELECT team
        ,   'start' = DATEADD(d, 1, CurrentHR)
        ,   'end' = DATEADD(d, -1, NextHR)
        ,   'days' = DATEDIFF(d, CurrentHR,
                              DATEADD(d, -1, NextHR)) 
        FROM HRGaps
        WHERE NextHR IS NOT NULL
		AND NextHR > DATEADD( d, 1, CurrentHR)
        ORDER BY team
        ,   CurrentHR;




-- lag
-- how many days since I hit a home run?
select 
	player
,	hrdate as 'Current Home Run game'
, lag(hrdate) over
 (
	partition by player
	order by hrdate
 ) as 'last home run'
, datediff( d, lag(hrdate) over
			(
			partition by player
			order by hrdate
			)
 , hrdate ) as 'days since last HR'
 from dbo.HomeRuns HR
;


-- lag previous row, but NULL is ugly
-- add parameters
select 
	player
,	hrdate as 'Current Home Run game'
, lag(hrdate, 1, '') over
 (
	partition by player
	order by hrdate
 ) as 'last home run'
, isnull( cast( datediff( d, lag(hrdate) over
			(
			partition by player
			order by hrdate
			)
		 , hrdate )
		as varchar(50))	, 'Hasn''t started yet') as 'days since last HR'
 from dbo.HomeRuns HR
;




-- Peek forward, LEAD
select 
  player
, hrdate as 'Current Home Run game'
, HRcount
, lead(hrdate, 1, '') over
 (
	partition by player
	order by hrdate
 ) as 'next home run'
, isnull( cast(
		 datediff( d, hrdate, lead(hrdate) over
			(
			partition by player
			order by hrdate
			)
		)
	as varchar(50)), 'Done for the season') as 'days to next HR'
 from dbo.HomeRuns HR
;

