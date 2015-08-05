/*
T-SQL 2005 Window Functions

Copyright 2014 Steve Jones

This code is provided as is.

*/
USE WindowDemo
GO

-- Row_Number()

-- check data
select
    hrid
    , player
    , team
    , hrdate
    , HRcount
  from
    dbo.HomeRuns HR;
go








-- set unique row number, based on dates
select 
 'Counter' = row_number() over (order by hrdate)
 , *
 from dbo.HomeRuns HR
;
/*
order by date only for numbering

data	                         Result set
=============================    ==========
Nelson	BAL		3/31/2013	1    1
Nelson	BAL		4/02/2013	1    2
Troy	COL		4/07/2013	1    3
Adam	BAL		4/8/2013	1    4
Troy	COL		4/18/2013	1    5
Nelson	BAL		4/20/2013	1    6
Nelson	BAL		4/22/2013	1    7
Troy	COL		4/22/2013	1    8
Nelson	BAL		4/23/2013	2    9
Troy	COL		4/23/2013	1    10
Troy	COL		4/25/2013	1    11
Nelson	BAL		4/27/2013	1    12
Troy	COL		4/28/2013	1    13
Troy	COL		4/29/2013	1    14
Nelson	BAL		5/02/2013	1    15
Nelson	BAL		5/04/2013	1    16
Troy	COL		5/05/2013	2    17
Adam	BAL		5/7/2013	2    18
Derek	NYY		5/07/2013	1    29
Lonnie	CLE		5/09/2013	2    20
Troy	COL		5/09/2013	2    21
Nelson	BAL		5/10/2013	1    22
Adam	BAL		5/10/2013	1    23
Adam	BAL		5/13/2013	1    24
Nelson	BAL		5/14/2013	1    25
Nelson	BAL		5/15/2013	1    26
Adam	BAL		5/18/2013	1    27
Derek	NYY		6/24/2013	1    28

*/












select 
	player
	, team
	, hrdate
	, HRcount
	, 'Counter' = row_number() over
  (
	order by player
  )
 from dbo.HomeRuns HR
;











-- Different ordering
select 
	player
	, team
	, hrdate
	, HRcount
	, 'Counter' = row_number() over
  (
	partition by team
	order by player
  )
 from dbo.HomeRuns HR
;











-- Different ordering
select 
	player
	, team
	, hrdate
	, HRcount
	, 'Counter' = row_number() over
  (
	partition by team
	order by hrdate
  )
 from dbo.HomeRuns HR
;
/*
order by date only for numbering

data	                         Result set
=============================    ==========
Nelson	BAL		3/31/2013	1    1
Nelson	BAL		4/02/2013	1    2
Adam	BAL		4/8/2013	1    3
Nelson	BAL		4/20/2013	1    4
Nelson	BAL		4/22/2013	1    5
Nelson	BAL		4/23/2013	2    6
Nelson	BAL		4/27/2013	1    7
Nelson	BAL		5/02/2013	1    8
Nelson	BAL		5/04/2013	1    9
Adam	BAL		5/7/2013	2    10
Nelson	BAL		5/10/2013	1    11
Adam	BAL		5/10/2013	1    12
Adam	BAL		5/13/2013	1    13
Nelson	BAL		5/14/2013	1    14
Nelson	BAL		5/15/2013	1    15
Adam	BAL		5/18/2013	1    16

Lonnie	CLE		5/09/2013	3    1

Troy	COL		4/07/2013	1    1
Troy	COL		4/18/2013	1    2
Troy	COL		4/22/2013	1    3
Troy	COL		4/23/2013	1    4
Troy	COL		4/25/2013	1    5
Troy	COL		4/28/2013	1    6
Troy	COL		4/29/2013	1    7
Troy	COL		5/05/2013	2    8
Troy	COL		5/09/2013	2    9

Derek	NYY		5/07/2013	1    1
Derek	NYY		6/24/2013	1    2

*/



-- RANK
-- Who hit the most home runs each month?
select
    player
  , datename(m, hrdate) as 'HR Month'
  , HRcount
  , rank() over
   ( 
	partition by datepart(m, hrdate) 
	order by HRcount 
	) as 'HR Rank'
  from
    dbo.HomeRuns HR
;


















-- let's reorder
select
    player
  , datename(m, hrdate) as 'HR Month'
  , HRcount
  , rank() over
   ( 
	partition by datepart(m, hrdate) 
	order by HRcount desc
	) as 'HR Rank'
  from
    dbo.HomeRuns HR
;
















-- add row_number
select
    player
  , datename(m, hrdate) as 'HR Month'
  , HRcount
  , row_number() over
		(partition by datepart(m, hrdate)
		 order by hrcount desc
		) as 'counter'
  , rank() over
   ( 
	partition by datepart(m, hrdate) 
	order by HRcount desc
	) as 'HR Rank'
  from
    dbo.HomeRuns HR
;




















-- DENSE_RANK
-- Who hit the most home runs each month?
select
    player
  , datename(m, hrdate) as 'HR Month'
  , HRcount
  , row_number() over
		(partition by datepart(m, hrdate)
		 order by hrcount desc
		) as 'counter'
  , dense_rank() over
   ( 
	partition by datepart(m, hrdate) 
	order by HRcount desc
	) as 'HR Rank'
  from
    dbo.HomeRuns HR
;










-- NTILE
select
    player
  , datename(m, hrdate) as 'HR Month'
  , HRcount
  , ntile(3) over
   ( 
	partition by datepart(m, hrdate) 
	order by HRcount desc
	) as 'HR Rank'
  from
    dbo.HomeRuns HR
;

