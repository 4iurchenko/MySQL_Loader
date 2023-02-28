select
	first_pmt_date as month,
	state,
	avg(cast(mi_pct as unsigned)) as avg_mi_pct,
	min(cast(mi_pct as unsigned)) as min_mi_pct,
	max(cast(mi_pct as unsigned)) as max_mi_pct,
	avg(credit_score) as avg_credit_score,
	min(credit_score) as min_credit_score,
	max(credit_score) as max_credit_score,
	avg(num_units) as avg_num_units,
	min(num_units) as min_num_units,
	max(num_units) as max_num_units,
	avg(orig_cltv) as avg_orig_cltv,
	min(orig_cltv) as min_orig_cltv,
	max(orig_cltv) as max_orig_cltv,
	avg(orig_dti) as avg_orig_dti,
	min(orig_dti) as min_orig_dti,
	max(orig_dti) as max_orig_dti,
	avg(orig_upb) as avg_orig_upb,
	min(orig_upb) as min_orig_upb,
	max(orig_upb) as max_orig_upb,
	avg(orig_ir) as avg_orig_ir,
	min(orig_ir) as min_orig_ir,
	max(orig_ir) as max_orig_ir
from
(
	SELECT
		first_pmt_date,
		state,
        -- The following case-when is used to convert ' ' and '000' to NULLs to calculate metrics properly
		case when cast(mi_pct as unsigned)=0 then NULL else cast(mi_pct as unsigned) end as mi_pct,
		case when cast(credit_score as unsigned)=0 then NULL else cast(credit_score as unsigned) end as credit_score,
		case when cast(num_units as unsigned)=0 then NULL else cast(num_units as unsigned) end as num_units,
		case when cast(orig_cltv as unsigned)=0 then NULL else cast(orig_cltv as unsigned) end as orig_cltv,
		case when cast(orig_dti as unsigned)=0 then NULL else cast(orig_dti as unsigned) end as orig_dti,
		case when cast(orig_upb as unsigned)=0 then NULL else cast(orig_upb as unsigned) end as orig_upb,
		case when cast(orig_ir as decimal(6, 3))=0 then NULL else cast(orig_ir as decimal(6, 3)) end as orig_ir
	FROM
		AgencyData.CleanFreddieSample
) as converted
group by 1, 2
order by 1, 2
