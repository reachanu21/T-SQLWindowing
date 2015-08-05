/*
T-SQL Basic Windowing Queries

Steve Jones, copyright 2014 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.

You are free to use this code inside of your own organization.
*/

-- Simple Grouping by player
SELECT 
 player
 , COUNT(hrcount) 
    FROM dbo.HomeRuns
	GROUP BY player
;

/*
Adam	5
Derek	2
Lonnie	1
Nelson	11
Troy	9
*/










-- group by player and team
SELECT team
    ,   player
    ,   COUNT(hrcount)
    FROM dbo.HomeRuns
    GROUP BY 
		team
    ,   player
	ORDER BY
		team
	  , player
;











-- basic count
SELECT player
    ,   team
    ,   hrdate
    ,   COUNT(*) OVER ( )
    FROM dbo.HomeRuns;
GO









-- Ugh.
-- there are 28 rows, so the count for each row is 28













-- let's add a partition
SELECT player
    ,   team
    ,   hrdate
    ,   COUNT(*) OVER ( PARTITION BY team )
    FROM dbo.HomeRuns;
GO
/*

data	                         Result set
=============================    ==========
Troy	COL		4/7/2013	1		9
Troy	COL		4/18/2013	1		9
Troy	COL		4/22/2013	1		9
Troy	COL		4/23/2013	1		9
Troy	COL		4/25/2013	1		9
Troy	COL		4/28/2013	1		9
Troy	COL		4/29/2013	1		9
Troy	COL		5/05/2013	1		9
Troy	COL		5/09/2013	1		9

Derek	NYY		5/7/2013	1		2
Derek	NYY		6/24/2013	1		2

Nelson	BAL		3/31/2013	1		16
Nelson	BAL		4/2/2013	1		16
Nelson	BAL		4/20/2013	1		16
Nelson	BAL		4/22/2013	1		16
Nelson	BAL		4/23/2013	2		16
Nelson	BAL		4/27/2013	1		16
Nelson	BAL		5/2/2013	1		16
Nelson	BAL		5/4/2013	1		16
Nelson	BAL		5/10/2013	1		16
Nelson	BAL		5/14/2013	1		16
Nelson	BAL		5/15/2013	1		16
Adam	BAL		4/8/2013	1		16
Adam	BAL		5/7/2013	2		16
Adam	BAL		5/10/2013	1		16
Adam	BAL		5/13/2013	1		16
Adam	BAL		5/18/2013	1		16

Lonnie	CLE		5/09/2013	1		1
*/




-- Note this isn't home runs, it's counts.
-- Sum gets total home runs.
SELECT player
    ,   team
    ,   hrdate
    ,   SUM(HRcount) OVER ( PARTITION BY team )
    FROM dbo.HomeRuns;
GO











-- The partitioning really gives me Home Runs for each team.
-- let's remove player
SELECT 
		team
    ,   hrdate
    ,   SUM(HRcount) OVER ( PARTITION BY team )
    FROM dbo.HomeRuns;
GO









-- can I shrink this? 
SELECT distinct
		team
    ,   hrdate
    ,   SUM(HRcount) OVER ( PARTITION BY team )
    FROM dbo.HomeRuns;
GO

















-- easy to consolidate
WITH myhr AS
(
SELECT 
		team
    ,   SUM(HRcount) OVER ( PARTITION BY team ) AS 'hr'
    FROM dbo.HomeRuns
)
SELECT DISTINCT hr
, team
    FROM myhr
 ;
GO













-- Now add ordering
SELECT player
    ,   team
    ,   hrdate
    ,   SUM(HRCount) OVER ( PARTITION BY team ORDER BY team)
    FROM dbo.HomeRuns;
GO
/*
BAL < COL < NYY
data	                         Result set
=============================    ==========
Nelson	BAL		3/31/2013	1    18
Nelson	BAL		4/2/2013	1    18
Nelson	BAL		4/20/2013	1    18
Nelson	BAL		4/22/2013	1    18
Nelson	BAL		4/23/2013	2    18
Nelson	BAL		4/27/2013	1    18
Nelson	BAL		5/2/2013	1    18
Nelson	BAL		5/4/2013	1    18
Nelson	BAL		5/10/2013	1    18
Nelson	BAL		5/14/2013	1    18
Nelson	BAL		5/15/2013	1    18
Adam	BAL		4/8/2013	1    18
Adam	BAL		5/7/2013	2    18
Adam	BAL		5/10/2013	1    18
Adam	BAL		5/13/2013	1    18
Adam	BAL		5/18/2013	1    18

Lonnie	CLE		5/09/2013	1	 1

Troy	COL		4/7/2013	1    10
Troy	COL		4/18/2013	1    10
Troy	COL		4/22/2013	1    10
Troy	COL		4/23/2013	1    10
Troy	COL		4/25/2013	1    10
Troy	COL		4/28/2013	1    10
Troy	COL		4/29/2013	1    10

Derek	NYY		5/7/2013	1    2
Derek	NYY		6/24/2013	1    2
*/


-- Change ordering to player
SELECT player
    ,   team
    ,   hrdate
    ,   SUM(HRcount) OVER ( PARTITION BY team ORDER BY player )
    FROM dbo.HomeRuns;
GO
/*
Adam < Nelson

data	                         Result set
=============================    ==========
Adam	BAL		4/8/2013	1    6 
Adam	BAL		5/7/2013	2    6
Adam	BAL		5/10/2013	1    6
Adam	BAL		5/13/2013	1    6
Adam	BAL		5/18/2013	1    6 - only the preceding rows to this point
Nelson	BAL		3/31/2013	1    18 - Now we add the other BAL player, so it's 16.
Nelson	BAL		4/2/2013	1    18
Nelson	BAL		4/20/2013	1    18
Nelson	BAL		4/22/2013	1    18
Nelson	BAL		4/23/2013	2    18
Nelson	BAL		4/27/2013	1    18
Nelson	BAL		5/2/2013	1    18
Nelson	BAL		5/4/2013	1    18
Nelson	BAL		5/10/2013	1    18
Nelson	BAL		5/14/2013	1    18
Nelson	BAL		5/15/2013	1    18

Lonnie	CLE		5/09/2013	1	 1

Troy	COL		4/7/2013	1    10
Troy	COL		4/18/2013	1    10
Troy	COL		4/22/2013	1    10
Troy	COL		4/23/2013	1    10
Troy	COL		4/25/2013	1    10
Troy	COL		4/28/2013	1    10
Troy	COL		4/29/2013	1    10
Troy	COL		5/05/2013	1    10
Troy	COL		5/09/2013	1    10

Derek	NYY		5/07/2013	1    2
Derek	NYY		6/24/2013	1    2
*/


-- Change partition and ordering to player
SELECT player
    ,   team
    ,   hrdate
    ,   SUM(HRcount) OVER ( PARTITION BY player ORDER BY player )
    FROM dbo.HomeRuns;
GO
/*
Adam < Derek < Nelson < Troy
BAL < COL < NYY
data	                         Result set
=============================    ==========
Adam	BAL		4/8/2013	1    6 
Adam	BAL		5/7/2013	2    6
Adam	BAL		5/10/2013	1    6
Adam	BAL		5/13/2013	1    6
Adam	BAL		5/18/2013	1    6 - only the preceding rows to this point

Derek	NYY		5/7/2013	1    2
Derek	NYY		6/24/2013	1    2 - new partition, by player

Nelson	BAL		3/31/2013	1    12 - Now we add the other BAL player, but only him, so 12
Nelson	BAL		4/2/2013	1    12
Nelson	BAL		4/20/2013	1    12
Nelson	BAL		4/22/2013	1    12
Nelson	BAL		4/23/2013	2    12
Nelson	BAL		4/27/2013	1    12
Nelson	BAL		5/2/2013	1    12
Nelson	BAL		5/4/2013	1    12
Nelson	BAL		5/10/2013	1    12
Nelson	BAL		5/14/2013	1    12
Nelson	BAL		5/15/2013	1    12

Troy	COL		4/7/2013	1    10
Troy	COL		4/18/2013	1    10
Troy	COL		4/22/2013	1    10
Troy	COL		4/23/2013	1    10
Troy	COL		4/25/2013	1    10
Troy	COL		4/28/2013	1    10
Troy	COL		4/29/2013	1    10
*/

-- Get sum of runs by player by team, that's what we really want.
SELECT player
    ,   team
    ,   hrdate
    ,   SUM(HRcount) OVER ( 
				PARTITION BY team, player 
				ORDER BY player )
    FROM dbo.HomeRuns;
GO
/*
BAL < COL < NYY
data	                         Result set
=============================    ==========
Adam	BAL		4/8/2013	1    6 
Adam	BAL		5/7/2013	2    6
Adam	BAL		5/10/2013	1    6
Adam	BAL		5/13/2013	1    6
Adam	BAL		5/18/2013	1    6 - total home runs in this player

Derek	NYY		5/7/2013	1    2
Derek	NYY		6/24/2013	1    2 - new partition, by player

Nelson	BAL		3/31/2013	1    12 - Now we add the other BAL player, but only him, so 11
Nelson	BAL		4/2/2013	1    12
Nelson	BAL		4/20/2013	1    12
Nelson	BAL		4/22/2013	1    12
Nelson	BAL		4/23/2013	2    12
Nelson	BAL		4/27/2013	1    12
Nelson	BAL		5/2/2013	1    12
Nelson	BAL		5/4/2013	1    12
Nelson	BAL		5/10/2013	1    12
Nelson	BAL		5/14/2013	1    12
Nelson	BAL		5/15/2013	1    12

Troy	COL		4/7/2013	1    7
Troy	COL		4/18/2013	1    7
Troy	COL		4/22/2013	1    7
Troy	COL		4/23/2013	1    7
Troy	COL		4/25/2013	1    7
Troy	COL		4/28/2013	1    7
Troy	COL		4/29/2013	1    7
*/



-- Next we create a total by month
SELECT player
    ,   team
    ,   'Month' = DATENAME(month, hrdate)
    ,   'Total Home Runs' = 
		SUM(HRcount) OVER 
		   ( 
				PARTITION BY team, MONTH(hrdate)
				ORDER BY team, player 
			)
	, HRcount
	, hrdate
    FROM dbo.HomeRuns;
GO
/*
BAL < COL < NYY
MAR < APR < MAY
ADAM < NELSON

data	                         Result set
=============================    ==========
Nelson	BAL		3/31/2013	1    1 - Only one in March

Adam	BAL		4/8/2013	1    1 - one by adam in april
Nelson	BAL		4/2/2013	1    7 - 1+1+1+2+1 = 6 +1 for Adam in April = 7
Nelson	BAL		4/20/2013	1    7
Nelson	BAL		4/22/2013	1    7
Nelson	BAL		4/23/2013	2    7
Nelson	BAL		4/27/2013	1    7
 
Adam	BAL		5/7/2013	2    5 - 2+1+1+1 = 5 for Adam in May
Adam	BAL		5/10/2013	1    5
Adam	BAL		5/13/2013	1    5
Adam	BAL		5/18/2013	1    5
Nelson	BAL		5/2/2013	1    10 - 1+1+1+1+1=5 for Nelson + 5 for Adam = 10 in May
Nelson	BAL		5/4/2013	1    10
Nelson	BAL		5/10/2013	1    10
Nelson	BAL		5/14/2013	1    10
Nelson	BAL		5/15/2013	1    10

Lonnie	CLE		5/09/2013	3	 3
Troy	COL		4/07/2013	1    7 - 7 for Troy in April, 3 in May
Troy	COL		4/18/2013	1    7
Troy	COL		4/22/2013	1    7
Troy	COL		4/23/2013	1    7
Troy	COL		4/25/2013	1    7
Troy	COL		4/28/2013	1    7
Troy	COL		4/29/2013	1    7
Troy	COL		5/05/2013	1    3
Troy	COL		5/09/2013	1    3

Derek	NYY		5/07/2013	1    1 - one in May

Derek	NYY		6/24/2013	1    1 - new partition, 1 in June for Derek
*/

-- Go to a running total by opening the framing clause to all rows before
SELECT player
    ,   team
    ,   DATENAME(month, hrdate)
    ,   SUM(HRcount) OVER ( 
				PARTITION BY team, MONTH(hrdate)
				ORDER BY team, player 
				ROWS UNBOUNDED PRECEDING
				)
    FROM dbo.HomeRuns;
GO
/*
BAL < COL < NYY
MAR < APR < MAY
ADAM < NELSON

data	                         Result set
=============================    ==========
Nelson	BAL		3/31/2013	1    1 - Only one in March

Adam	BAL		4/8/2013	1    1 - one by adam in april

Nelson	BAL		4/2/2013	1    2 - 1 for Nelson + 1 for Adam in April = 2
Nelson	BAL		4/20/2013	1    3 - 2 for Nelson + 1 for Adam in April
Nelson	BAL		4/22/2013	1    4 - 3 for Nelson + 1 for Adam in April
Nelson	BAL		4/23/2013	2    6 - 5 for Nelson + 1 for Adam in April
Nelson	BAL		4/27/2013	1    7 - 6 for Nelson + 1 for Adam in April
 
Adam	BAL		5/7/2013	2    2 - multi homer game for Adam
Adam	BAL		5/10/2013	1    3
Adam	BAL		5/13/2013	1    4
Adam	BAL		5/18/2013	1    5
Nelson	BAL		5/2/2013	1    6 - 1 for Nelson  + 5 for Adam
Nelson	BAL		5/4/2013	1    7
Nelson	BAL		5/10/2013	1    8
Nelson	BAL		5/14/2013	1    9
Nelson	BAL		5/15/2013	1    10

Troy	COL		4/7/2013	1    1
Troy	COL		4/18/2013	1    2
Troy	COL		4/22/2013	1    3
Troy	COL		4/23/2013	1    4
Troy	COL		4/25/2013	1    5
Troy	COL		4/28/2013	1    6
Troy	COL		4/29/2013	1    7

Troy	COL		5/05/2013	2    2
Troy	COL		5/09/2013	1    3

Derek	NYY		5/7/2013	1    1 - one in May

Derek	NYY		6/24/2013	1    1 - new partition, 1 in June for Derek
*/


-- What about HRs / team per month?
SELECT 
		team
    ,   'Month' = DATENAME(month, hrdate)
    ,   'Total Home Runs' = 
		SUM(HRcount) OVER ( 
				PARTITION BY team, MONTH(hrdate)
				ORDER BY team, hrdate
				ROWS UNBOUNDED PRECEDING
				)
    ,   hrcount
	,	hrdate
    FROM dbo.HomeRuns;
GO
/*
BAL < COL < NYY
MAR < APR < MAY
ADAM < NELSON

data	                         Result set
=============================    ==========
Nelson	BAL		3/31/2013	1    1 - Only one in March

Adam	BAL		4/8/2013	1    1 - one by adam in april
Nelson	BAL		4/2/2013	1    2 - 1 for Nelson + 1 for Adam in April = 2
Nelson	BAL		4/20/2013	1    3 - 2 for Nelson + 1 for Adam in April
Nelson	BAL		4/22/2013	1    4 - 3 for Nelson + 1 for Adam in April
Nelson	BAL		4/23/2013	2    6 - 5 for Nelson + 1 for Adam in April
Nelson	BAL		4/27/2013	1    7 - 6 for Nelson + 1 for Adam in April
 
Adam	BAL		5/7/2013	2    2 - multi homer game for Adam
Adam	BAL		5/10/2013	1    3
Adam	BAL		5/13/2013	1    4
Adam	BAL		5/18/2013	1    5
Nelson	BAL		5/2/2013	1    6 - 1 for Nelson  + 5 for Adam
Nelson	BAL		5/4/2013	1    7
Nelson	BAL		5/10/2013	1    8
Nelson	BAL		5/14/2013	1    9
Nelson	BAL		5/15/2013	1    10

Troy	COL		4/7/2013	1    1
Troy	COL		4/18/2013	1    2
Troy	COL		4/22/2013	1    3
Troy	COL		4/23/2013	1    4
Troy	COL		4/25/2013	1    5
Troy	COL		4/28/2013	1    6
Troy	COL		4/29/2013	1    7

Troy	COL		5/05/2013	2    2
Troy	COL		5/09/2013	1    3

Derek	NYY		5/7/2013	1    1 - one in May

Derek	NYY		6/24/2013	1    1 - new partition, 1 in June for Derek
*/


-- what about by month, then team?
SELECT 
		player
	,	team
    ,   'Month' = DATENAME(month, hrdate)
    ,   hrdate
    ,   'Total Home Runs' = 
			SUM(HRcount) OVER ( 
				PARTITION BY MONTH(hrdate)
				ORDER BY hrdate, team
				ROWS UNBOUNDED PRECEDING
				)
	, HRcount
	, hrdate
    FROM dbo.HomeRuns;
GO
/*
BAL < COL < NYY
MAR < APR < MAY
ADAM < NELSON

data	                         Result set
=============================    ==========
Nelson	BAL		3/31/2013	1    1 - Only one in March

Nelson	BAL		4/2/2013	1    1 - 1 for Nelson
Troy	COL		4/7/2013	1    2 - 1 for Troy + 1 for Nelson
Adam	BAL		4/8/2013	1    3 - 1 for Troy, Nelson, Adam
Troy	COL		4/18/2013	1    4
Nelson	BAL		4/20/2013	1    5
Nelson	BAL		4/22/2013	1    6
Troy	COL		4/22/2013	1    7
Nelson	BAL		4/23/2013	2    9 - multi homer game skips 8
Troy	COL		4/23/2013	1    10 - Why Nelson before Troy? BAL < COL
Troy	COL		4/25/2013	1    11
Nelson	BAL		4/27/2013	1    12
Troy	COL		4/28/2013	1    13
Troy	COL		4/29/2013	1    14 - total for April
 
Nelson	BAL		5/2/2013	1    1 for Nelson 
Nelson	BAL		5/4/2013	1    2
Troy	COL		5/5/2013	2    4 - multi homer for Troy
Adam	BAL		5/7/2013	2    6 - multi homer game for Adam
Derek	NYY		5/7/2013	1    7
Troy	COL		5/9/2013	1    8 - multi homer for Troy
Nelson	BAL		5/10/2013	1    9 - Why Nelson first? Random. No ordering by player
Adam	BAL		5/10/2013	1    10
Adam	BAL		5/13/2013	1    11
Nelson	BAL		5/14/2013	1    12
Nelson	BAL		5/15/2013	1    13
Adam	BAL		5/18/2013	1    14

Derek	NYY		6/24/2013	1    1 - new partition, 1 in June for Derek

*/


-- presentation results separately.
-- second ORDER BY is for viewing
SELECT 
		player
	,	team
    ,   DATENAME(month, hrdate)
    ,   hrdate
    ,   SUM(HRcount) OVER ( 
				PARTITION BY MONTH(hrdate)
				ORDER BY hrdate, team
				ROWS UNBOUNDED PRECEDING
				)
	, HRcount
	, hrdate
    FROM dbo.HomeRuns
ORDER BY 
	player
;
GO

-- numbers all out of order.



-- let's change the FRAMING
-- in this case, unbounded preceeding and following
SELECT 
		player
	,	team
    ,   DATENAME(month, hrdate)
    ,   hrdate
    ,   SUM(HRcount) OVER ( 
				PARTITION BY MONTH(hrdate)
				ORDER BY hrdate, team
				ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED following
				)
    FROM dbo.HomeRuns
;
GO
/*
Now we get totals by month for all items.
Mar - 1
Apr - 14
May - 11
June - 1
*/

-- Let's get running by game and month.
SELECT 
		player
	,	team
    ,   DATENAME(month, hrdate)
	,   'Game Running HR for month' = SUM(HRcount) OVER ( 
							PARTITION BY MONTH(hrdate)
							ORDER BY hrdate, team
							ROWS UNBOUNDED PRECEDING
							)
	,   'Month Total HR' = SUM(HRcount) OVER ( 
							PARTITION BY MONTH(hrdate)
							ORDER BY MONTH(hrdate)
							)
    ,   hrdate
	,	HRcount
    FROM dbo.HomeRuns
;
GO


-- add total for season
SELECT 
		player
	,	team
    ,   DATENAME(month, hrdate)
	,   'Game Running HR for month' = SUM(HRcount) OVER ( 
							PARTITION BY MONTH(hrdate)
							ORDER BY hrdate, team
							ROWS UNBOUNDED PRECEDING
							)
	,   'Month Total HR' = SUM(HRcount) OVER ( 
							PARTITION BY MONTH(hrdate)
							ORDER BY MONTH(hrdate)
							)
	,   'Season Total HR' = SUM(HRcount) OVER 
							( 
							)
	, 'Percentage complete' = SUM(HRcount) OVER ( 
							ORDER BY hrdate, team
							ROWS UNBOUNDED PRECEDING
							)
						/ CAST( SUM(HRcount) OVER 
							( 
							) AS numeric(5, 2) )
						* 100.0
    ,   hrdate
	,	HRcount
    FROM dbo.HomeRuns
;
GO



