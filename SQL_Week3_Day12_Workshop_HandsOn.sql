select * from dbo.City

select
	Name
,	case
		when Population is null then 0
		else Population
	end as Col2
,	IIF(Population IS NULL, 0, Population) as P
from
	dbo.City


--select 

select
	
from
	dbo.City as c



