/*
T-SQL Basic Windowing

Running Totals

Copyright 2014 Steve Jones

This code is provided as is.

*/

-- The old way
select
    hr.team
  , hr.player
  , hr.hrid
  , hr.hrdate
  , hr.HRcount
  , 'Running Total' = sum(hr2.HRcount)
  from
    dbo.HomeRuns HR
  inner join dbo.HomeRuns HR2
  on
	HR2.hrid <= HR.hrid
  group by
	hr.hrid
  , hr.team
  , hr.player
  , hr.hrdate
  , hr.HRcount
  order by
    hr.hrid
  , hr.team
  , hr.player
  , hr.HRcount
;
go


-- new way with windows
select
	hr.hrid
  , hr.team
  , hr.player
  , hr.hrdate
  , hr.HRcount
  , sum(hr.HRcount) over
    (
	  order by hrid
	) as 'Total'
  from
    dbo.HomeRuns HR
;
go












