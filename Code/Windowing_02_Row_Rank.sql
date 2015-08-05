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
 


-- Why do this? For example, we can find duplicates.
-- We have players hitting home runs on the same day
WITH    hrsource
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY hrdate ORDER BY ( SELECT
                                                              null
                                                              ) ) AS hrgame
                      , 'game' = hrdate
               FROM     HomeRuns
             )
    SELECT  game
    FROM    hrsource
    WHERE   hrgame > 1;
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
