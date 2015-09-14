/*
T-SQL Basic Windowing

RANGE and ROWS

Copyright 2014 Steve Jones

This code is provided as is with no warranty implied.

*/
USE WindowDemo
GO

-- Now let's add total as we go
-- We now look back at the entirety of rows in a partition
SELECT player
    ,   team
    ,   DATENAME(month, hrdate)
    ,   HRtotal = SUM(HRcount) OVER ( 
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


-- Let's change to look at a different frame.
-- what if we look at range?
SELECT 
		team
    ,   DATENAME(month, hrdate)
    ,   hrdate
    ,   HRtotal = SUM(HRcount) OVER ( 
				PARTITION BY team, MONTH(hrdate)
				ORDER BY team, hrdate
				RANGE UNBOUNDED PRECEDING
				)
    FROM dbo.HomeRuns;
GO
-- this is the default




-- let's limit to just two rows.
SELECT 
		team
    ,   DATENAME(month, hrdate)
    ,   hrdate
	, HRcount
    ,   HRtotal = SUM(HRcount) OVER ( 
				PARTITION BY team, MONTH(hrdate)
				ORDER BY team, hrdate
				ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
				)
    FROM dbo.HomeRuns;
GO



-- change to 3 rows
SELECT 
		team
    ,   DATENAME(month, hrdate)
    ,   hrdate
	, HRcount
    ,   HRtotal = SUM(HRcount) OVER ( 
				PARTITION BY team, MONTH(hrdate)
				ORDER BY team, hrdate
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
				)
    FROM dbo.HomeRuns;
GO

-- go forward 1 row
SELECT 
		team
    ,   DATENAME(month, hrdate)
    ,   hrdate
	, HRcount
    ,   HRtotal = SUM(HRcount) OVER ( 
				PARTITION BY team, MONTH(hrdate)
				ORDER BY team, hrdate
				ROWS BETWEEN 2 PRECEDING AND 1 FOLLOWING
				)
    FROM dbo.HomeRuns;
GO
-- looking at 4 rows each time (almost)
-- watch the month


