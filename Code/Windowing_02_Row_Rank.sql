/*
T-SQL Basic Windowing

ROW_NUMBER and RANKing

Copyright 2014 Steve Jones

This code is provided as is.

*/
USE WindowDemo
GO

-- add a row_number to the results.
SELECT 
 ROW_NUMBER()
 OVER
 ( ORDER BY (SELECT NULL)
  ) AS test
  , *
  FROM homeruns
 ;
go
-- Not terribly interesting


-- better row counter
select
    'Rowcnt' = row_number() over ( order by team )
  , player
  , team
  , hrdate
  , hrcount
  from
    homeruns;
go




-- reset by team
select
    'Rowcnt' = row_number() over ( partition by team order by team )
  , hrid
  , player
  , team
  , hrdate
  , hrcount
  from
    homeruns;
go
/*
Break up into partitions.
BAL
BAL
...

CLE

COL
COL
...

NYY
*/


-- reset by player
select
    'Rowcnt' = row_number() over ( partition by team, player order by team, player )
  , player
  , team
  , hrdate
  , hrcount
  from
    homeruns;
GO
/*
BAL Adam
BAL Nelson

CLE Lonnie

COL Troy

NYY Derek

*/



-- However, what if I want players by team
SELECT 
 DENSE_RANK()
 OVER
 ( ORDER BY TEAM
  ) AS TeamDenseRank
  , player
  , team
  , hrdate
  , hrcount
  FROM homeruns
 ;
go

-- compare with rank
SELECT 
 RANK()
 OVER
 ( ORDER BY TEAM
  ) AS RankTeam
  , player
  , team
  , hrdate
  , hrcount
  FROM homeruns
 ;
go




-- Change ranking to be by player
select 
 DENSE_RANK()
 OVER
 ( ORDER BY player
  ) AS PlayerRanks
  , *
  FROM homeruns
 ;
 GO
 /*
 4 Ranks, for 4 players

 1 = Adam
 2 = Derek
 3 = Lonnie
 4 = Nelson
 5 = Troy
 */
 



 -- example, find dups.
 -- We have players hitting home runs on the same day
WITH hrsource AS
(
SELECT 
 ROW_NUMBER()
 OVER
 ( PARTITION BY
	hrdate
	ORDER BY (SELECT NULL)
  ) AS hrgame
  , 'game' = hrdate
  FROM homeruns
)
SELECT	
 game
FROM hrsource
WHERE hrgame > 1
;
 GO


