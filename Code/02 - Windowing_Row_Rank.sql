/*
T-SQL Basic Windowing

ROW_NUMBER and RANKing

Copyright 2015 Steve Jones

This code is provided as is with no warranty implied. Please be 
sure that you test this code and it's impact on your system before
deploying it to any production database.
*/
USE WindowDemo
GO
-- Look at our data
SELECT  hrid ,
        player ,
        team ,
        hrdate ,
        HRcount
FROM    dbo.HomeRuns;
GO




-- add a row_number to the results.
SELECT  ROW_NUMBER() OVER ( ORDER BY ( SELECT   NULL
                                     ) ) AS rowcounter
      , hrid
      , player
      , team
      , hrdate
      , HRcount
FROM    HomeRuns;
GO
-- Not terribly interesting
-- Basically matches the PK in this case.
-- Note: DO NOT assume this is the case without an ORDER BY




-- Let's look at a better row counter
SELECT  'Rowcnt' = ROW_NUMBER() OVER ( ORDER BY team )
      , hrid
      , player
      , team
      , hrdate
      , HRcount
FROM    HomeRuns;
GO



-- Adjust the row_number() with a partition
-- Now we reset by team
SELECT  'Rowcnt' = ROW_NUMBER() OVER ( PARTITION BY team ORDER BY team )
      , hrid
      , player
      , team
      , hrdate
      , HRcount
FROM    HomeRuns;
GO
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


-- Further change the row_number with a second partition.
-- Now we reset by player (within a team)
SELECT  'Rowcnt' = ROW_NUMBER() OVER ( PARTITION BY team, player ORDER BY team, player )
      , player
      , team
      , hrdate
      , HRcount
FROM    HomeRuns;
GO
/*
BAL Adam
BAL Nelson

CLE Lonnie

COL Troy

NYY Derek

*/





-----------------------------------------------------------
-----------------------------------------------------------
--
--  Ranking
--
-----------------------------------------------------------
-----------------------------------------------------------

 

-- However, what if I want players by team
SELECT  DENSE_RANK() OVER ( ORDER BY team ) AS TeamDenseRank
      , player
      , team
      , hrdate
      , HRcount
FROM    HomeRuns;
GO

-- compare with rank
SELECT  RANK() OVER ( ORDER BY team ) AS RankTeam
      , player
      , team
      , hrdate
      , HRcount
FROM    HomeRuns;
go




-- Change ranking to be by player
SELECT  DENSE_RANK() OVER ( ORDER BY player ) AS PlayerRanks
      , *
FROM    HomeRuns;
 GO
 /*
 4 Ranks, for 4 players

 1 = Adam
 2 = Derek
 3 = Lonnie
 4 = Nelson
 5 = Troy
 */
 




------------------------------------------------------------------------------
------------------------------------------------------------------------------
--   Better Demos
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Why do this? For example, we can find duplicates.
-- We have players hitting home runs on the same day. What are the dates?
WITH    hrsource
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY hrdate ORDER BY ( SELECT
                                                              null
                                                              ) ) AS hrgame
                      , 'game' = hrdate
               FROM     HomeRuns
             )
    SELECT  game
    FROM    hrsource
    WHERE   hrgame > 1
	ORDER BY game;
 GO


-- raw data
WITH    hrsource
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY hrdate ORDER BY ( SELECT
                                                              null
                                                              ) ) AS hrgame
                      , 'game' = hrdate
               FROM     HomeRuns
             )
    SELECT  game, hrgame
    FROM    hrsource
 GO


-- get the players
WITH    hrsource
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY hrdate ORDER BY ( SELECT
                                                              null
                                                              ) ) AS hrgame
                      , 'game' = hrdate
               FROM     HomeRuns
             )
    SELECT  game,player
    FROM    hrsource
	 INNER JOIN dbo.HomeRuns
	  ON hrsource.game = dbo.HomeRuns.hrdate
    WHERE   hrgame > 1
	ORDER BY game;
 GO



-- get data from dbo.Players
-- NOT included in setup code
-- let's get an ordering of home run hitters
SELECT 
 hrcount = ROW_NUMBER() OVER (PARTITION BY p.franchName ORDER BY hr DESC)
,  p.nameFirst
 , p.nameLast
 , p.franchName
 , p.HR
  FROM  dbo.Players p




-- get data from dbo.Players
-- NOT included in setup code
-- let's just get the top 3 per team.
-- read more at http://www.sqlservercentral.com/articles/T-SQL/71571/ - Returning the Top X row for each group (SQL Spackle)
WITH    HRCTE
          AS ( SELECT   hrcount = ROW_NUMBER() OVER ( PARTITION BY p.franchName ORDER BY HR DESC )
                      , p.nameFirst
                      , p.nameLast
                      , p.franchName
                      , p.HR
               FROM     dbo.Players p
             )
    SELECT  *
    FROM    HRCTE
    WHERE   hrcount <= 3;


-- Let's add ranking functions
-- go to top 5 to see differences (Diamondbacks v Orioles)
;
WITH    HRCTE
          AS ( SELECT   hrorder = ROW_NUMBER() OVER ( PARTITION BY p.franchName ORDER BY HR DESC )
                      , p.nameFirst
                      , p.nameLast
                      , p.franchName
                      , p.HR
               FROM     dbo.Players p
             )
    SELECT  hrdenserank = DENSE_RANK() OVER ( PARTITION BY HRCTE.franchName ORDER BY HR DESC )
          , hrrank = RANK() OVER ( PARTITION BY HRCTE.franchName ORDER BY HR DESC )
          , *
    FROM    HRCTE
    WHERE   HRCTE.hrorder <= 5;










