/*
Windowing Demo Setup 

Copyright 2015 Steve Jones

This code is provided as is with no warranty.
*/

/*
-- If needed , create and use a DB
create database WindowDemo;
go
*/

USE WindowDemo
go

-- Create a table
CREATE TABLE HomeRuns
( hrid INT IDENTITY(1,1)
, player VARCHAR(200)
, team VARCHAR(200)
, hrdate DATE
, HRcount TINYINT
CONSTRAINT hr_IDX PRIMARY KEY (hrid)
);
GO


/*
Populate with data.

Note these items:
COL
	- 1 player
	- 7 records
	- 7 home runs
NYY
	- 1 player
	- 2 records
	- 2 home runs
BAL
	- 2 players
	- 16 records
	- 18 home runs

*/
INSERT HomeRuns (player, team, hrdate, HRcount)
 VALUES ('Troy', 'COL', '4/7/2013', 1)
      , ('Troy', 'COL', '4/18/2013', 1)
      , ('Troy', 'COL', '4/22/2013', 1)
      , ('Troy', 'COL', '4/23/2013', 1)
      , ('Troy', 'COL', '4/25/2013', 1)
      , ('Troy', 'COL', '4/28/2013', 1)
      , ('Troy', 'COL', '4/29/2013', 1)
      , ('Troy', 'COL', '5/5/2013', 2)
      , ('Troy', 'COL', '5/9/2013', 1)
      , ('Derek', 'NYY', '5/7/2013', 1)
      , ('Derek', 'NYY', '6/24/2013', 1)
      , ('Nelson', 'BAL', '3/31/2013', 1)
      , ('Nelson', 'BAL', '4/2/2013', 1)
      , ('Nelson', 'BAL', '4/20/2013', 1)
      , ('Nelson', 'BAL', '4/22/2013', 1)
      , ('Nelson', 'BAL', '4/23/2013', 2)
      , ('Nelson', 'BAL', '4/27/2013', 1)
      , ('Nelson', 'BAL', '5/2/2013', 1)
      , ('Nelson', 'BAL', '5/4/2013', 1)
      , ('Nelson', 'BAL', '5/10/2013', 1)
      , ('Nelson', 'BAL', '5/14/2013', 1)
      , ('Nelson', 'BAL', '5/15/2013', 1)
      , ('Adam', 'BAL', '4/8/2013', 1)
      , ('Adam', 'BAL', '5/7/2013', 2)
      , ('Adam', 'BAL', '5/10/2013', 1)
      , ('Adam', 'BAL', '5/13/2013', 1)
      , ('Adam', 'BAL', '5/18/2013', 1)
      , ('Lonnie', 'CLE', '5/9/2013', 3)
;
GO
-- Check the data
SELECT
      hrid
    , player
    , team
    , hrdate
    , HRcount
 FROM dbo.HomeRuns HR
;
go