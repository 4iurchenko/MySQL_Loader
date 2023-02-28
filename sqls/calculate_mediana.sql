--******* Example of calculating Mediana for the dataset. *******-------

--I want to note that the current MySQL server:
-- 1. is not supported window-functions (row_number() and count(1) over())
-- 2. is not supported CTE table expressions
--
--To replace these functions, I implemented @variables as a workaround.
--This example illustrates how to calculate AVG, MIN, MAX, and MEDIANA for mi_pct grouped by date and state.
--
--If we need to satisfy the rest of the metrics according to the requirements,
--we need to create additional 8 queries like that and join them. 
--So, the most challenging part, calculation without window functions, here is implemented.

select t1.first_pmt_date, t1.state, t1.avg_mi_pct, min_mi_pct, max_mi_pct, t2.mi_pct_median
from
(
	SELECT
		first_pmt_date,
		state,
		avg(case when cast(mi_pct as unsigned)=0 then NULL else cast(mi_pct as unsigned) end) as avg_mi_pct,
		min(case when cast(mi_pct as unsigned)=0 then NULL else cast(mi_pct as unsigned) end) as min_mi_pct,
		max(case when cast(mi_pct as unsigned)=0 then NULL else cast(mi_pct as unsigned) end) as max_mi_pct
	FROM AgencyData.CleanFreddieSample
	group by 1, 2
) as t1
join
(
	select
		first_pmt_date,
		state,
		avg(mi_pct) as mi_pct_median
	from
	(
		select
			mi_pct_rownum.first_pmt_date,
			mi_pct_rownum.state,
			mi_pct_rownum.mi_pct,
			mi_pct_rownum.num,
			mi_pct_cnt.cnt
		from
		(
			select
				first_pmt_date,
				state,
				mi_pct,
				-- This construction replaces row_number() window function, which absent in the current MySQL server
				@row_number:=CASE
			        WHEN @v_first_pmt_date = first_pmt_date and @v_state = state
						THEN @row_number + 1
			        ELSE 1
			    END AS num,
			    @v_first_pmt_date:=first_pmt_date v_first_pmt_date,
			    @v_state:=state v_state
			from
			(
				SELECT first_pmt_date, state, case when cast(mi_pct as unsigned)=0 then NULL else cast(mi_pct as unsigned) end as mi_pct
				FROM AgencyData.CleanFreddieSample
				where cast(mi_pct as unsigned) <> 0
			) as t,
			(SELECT @row_number:=0) AS t0
			order by t.first_pmt_date, t.state, mi_pct

		) as mi_pct_rownum
		join
		(
			select first_pmt_date, state, count(1) as cnt
			from
			(
				SELECT first_pmt_date, state, case when cast(mi_pct as unsigned)=0 then NULL else cast(mi_pct as unsigned) end as mi_pct
				FROM AgencyData.CleanFreddieSample
				where cast(mi_pct as unsigned) <> 0
			) as t
			group by 1, 2
		) as mi_pct_cnt
		on mi_pct_rownum.first_pmt_date=mi_pct_cnt.first_pmt_date
			and mi_pct_rownum.state=mi_pct_cnt.state
	) calc
	-- it selects or the middle row, or avg of both rows for even qty of rows
	where num in ( FLOOR((cnt + 1) / 2), FLOOR( (cnt + 2) / 2) )
	group by 1, 2
) as t2 on t1.first_pmt_date=t2.first_pmt_date and t1.state=t2.state
