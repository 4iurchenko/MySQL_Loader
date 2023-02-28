select base.year, base.state, IFNULL(data.loan_qty, 0) as prepays_qty
from
(
	-- these constant SELECTs are used to be sure all states and historical period will be shown
	select s.state, y.year
	from
	(
		-- Here "Collate" is used because of local collation is different
		select 'AL' COLLATE utf8mb4_unicode_ci as state union select 'AK' union select 'AZ' union select 'AR' union
		select 'CA' union select 'CO' union select 'CT' union select 'DE' union
		select 'DC' union select 'FL' union select 'GA' union select 'HI' union
		select 'ID' union select 'IL' union select 'IN' union select 'IA' union
		select 'KS' union select 'KY' union select 'LA' union select 'ME' union
		select 'MD' union select 'MA' union select 'MI' union select 'MN' union
		select 'MS' union select 'MO' union select 'MT' union select 'NE' union
		select 'NV' union select 'NH' union select 'NJ' union select 'NM' union
		select 'NY' union select 'NC' union select 'ND' union select 'OH' union
		select 'OK' union select 'OR' union select 'PA' union select 'RI' union
		select 'SC' union select 'SD' union select 'TN' union select 'TX' union
		select 'UT' union select 'VT' union select 'VA' union select 'WA' union
		select 'WV' union select 'WI' union select 'WY'
	) as s
	cross join (
		-- Here "Collate" is used because of trouble with joining constant dictionary with the table
		select '1999' COLLATE utf8mb4_unicode_ci as year union select '2000' union select '2001' union select '2002' union
		select '2003' union select '2004' union select '2005' union select '2006' union
		select '2007' union select '2008' union select '2009' union select '2010' union
		select '2011' union select '2012' union select '2013' union select '2014' union
		select '2015' union select '2016' union select '2017'
	) y
) as base
left outer join
(
	select substring(first_pmt_date, 1, 4) as year, state, count(distinct loan_seq_num) as loan_qty
	FROM AgencyData.CleanFreddieSample
	where status = 'Prepay'
	group by 1, 2
	order by 1, 2
) as data
on base.year = data.year and base.state = data.state
order by 1, 2
;