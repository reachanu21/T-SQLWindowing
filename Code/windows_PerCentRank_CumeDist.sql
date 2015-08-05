/*
T-SQL Basic Windowing

Percentages

Copyright 2014 Steve Jones

This code is provided as is with no warranty implied.

*/
USE WindowDemo
GO



-- get percentage in ranking.
WITH    TotalHRsByTeam
          AS ( SELECT team
                ,   SUM(hrcount) AS 'TotalHR'
                FROM dbo.HomeRuns
                GROUP BY team
             )
    SELECT team
        ,   TotalHR
        ,   PERCENT_RANK() OVER ( ORDER BY TotalHR  ) AS 'Ranking'
        FROM TotalHRsByTeam;
GO





-- Add CUME_DIST
WITH    TotalHRsByTeam
          AS ( SELECT team
                ,   SUM(hrcount) AS 'TotalHR'
                FROM dbo.HomeRuns
                GROUP BY team
             )
    SELECT team
        ,   TotalHR
        ,   PERCENT_RANK() OVER ( ORDER BY TotalHR ) AS 'Ranking'
        ,   CUME_DIST() OVER ( ORDER BY TotalHR ) AS 'Ranking'
        FROM TotalHRsByTeam;
GO




-- add partitioning by player
WITH    TotalHRsByTeam
          AS ( SELECT team
                ,   player
                ,   SUM(hrcount) AS 'TotalHR'
                FROM dbo.HomeRuns
                GROUP BY team
                ,   player
             )
    SELECT team
        ,   player
        ,   TotalHR
        ,   PERCENT_RANK() OVER ( PARTITION BY team ORDER BY TotalHR ) AS 'Percent Ranking'
        ,   CUME_DIST() OVER ( PARTITION BY team ORDER BY TotalHR ) AS 'CUME Ranking'
        FROM TotalHRsByTeam;
GO

