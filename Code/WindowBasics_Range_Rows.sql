/*
T-SQL Basic Windowing

RANGE and ROWS

Copyright 2014 Steve Jones

This code is provided as is with no warranty implied.

*/
-- Now let's add total as we go
-- We now look back at the entirety of rows in a partition
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

data	                    Result set
=========================   ==========
Nelson	BAL		March		1    1 - Only one in March

Adam	BAL		April		1    1 - one by adam in april
				April	
Nelson	BAL		April		1    2 - 1 for Nelson + 1 for Adam in April = 2
Nelson	BAL		April		1    3 - 2 for Nelson + 1 for Adam in April
Nelson	BAL		April		1    4 - 3 for Nelson + 1 for Adam in April
Nelson	BAL		April		2    6 - 5 for Nelson + 1 for Adam in April
Nelson	BAL		April		1    7 - 6 for Nelson + 1 for Adam in April
 
Adam	BAL		May			2    2 - multi homer game for Adam
Adam	BAL		May			1    3
Adam	BAL		May			1    4
Adam	BAL		May			1    5
				May		
Nelson	BAL		May			1    6 - 1 for Nelson  + 5 for Adam
Nelson	BAL		May			1    7
Nelson	BAL		May			1    8
Nelson	BAL		May			1    9
Nelson	BAL		May			1    10

Troy	COL		April		1    1
Troy	COL		April		1    2
Troy	COL		April		1    3
Troy	COL		April		1    4
Troy	COL		April		1    5
Troy	COL		April		1    6
Troy	COL		April		1    7

Troy	COL		May			2    2
Troy	COL		May			1    3

Derek	NYY		May			1    1 - one in May

Derek	NYY		May			1    1 - new partition, 1 in June for Derek
*/


-- What about HRs / team per month?
SELECT 
		team
    ,   DATENAME(month, hrdate)
    ,   hrdate
    ,   SUM(HRcount) OVER ( 
				PARTITION BY team, MONTH(hrdate)
				ORDER BY team, hrdate
				ROWS UNBOUNDED PRECEDING
				)
    FROM dbo.HomeRuns;
GO

-- what about by month, then team?
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
Adam	BAL		5/7/2013	2    4 - multi homer game for Adam
Derek	NYY		5/7/2013	1    5
Nelson	BAL		5/10/2013	1    6 - Why Nelson first? Random. No ordering by player
Adam	BAL		5/10/2013	1    7
Adam	BAL		5/13/2013	1    8
Nelson	BAL		5/14/2013	1    9
Nelson	BAL		5/15/2013	1    10
Adam	BAL		5/18/2013	1    11

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
    ,   hrdate
	,	HRcount
	,   'Game Total HR for month' = SUM(HRcount) OVER ( 
							PARTITION BY MONTH(hrdate)
							ORDER BY hrdate, team
							ROWS UNBOUNDED PRECEDING
							)
	,   'Month Total HR' = SUM(HRcount) OVER ( 
							PARTITION BY MONTH(hrdate)
							ORDER BY MONTH(hrdate)
							)
    FROM dbo.HomeRuns
;
GO


-- add total for season
SELECT 
		player
	,	team
    ,   DATENAME(month, hrdate)
    ,   hrdate
	,	HRcount
	,   'Game Total HR for month' = SUM(HRcount) OVER ( 
							PARTITION BY MONTH(hrdate)
							ORDER BY hrdate, team
							ROWS UNBOUNDED PRECEDING
							)
	,   'Month Total HR' = SUM(HRcount) OVER ( 
							PARTITION BY MONTH(hrdate)
							ORDER BY MONTH(hrdate)
							)
	,   'Season Total HR' = SUM(HRcount) OVER ( 
							)
    FROM dbo.HomeRuns
;
GO



-- First value/last value
select
	player
	, first_value(player) over
	 (
		order by player
	 ) as 'First'
	, last_value(player) over
	 (
		order by player
	 ) as 'Last'
 from dbo.HomeRuns HR
 ;


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
