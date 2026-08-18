--pivot
--below is source data
Product A	10
Product A	15
Product B	20
Product C	5

--below query pivots a vertical query result (see above) to a horizontal query result
select *
from (
    select product_name, quantity
    from sales
    order by 1) 
pivot (
    sum(quantity) sm, count(quantity) ct
    for product_name
in ('Product A' as prod_a, 'Product B' as prod_b, 'Product C' as prod_c)
)


select sale_date, to_char(sale_date,'mm/dd/yyyy hh24:mi:ss')
from sales

select *
from (
    select a.*, lead(trxn_timestamp) over (order by trxn_timestamp) next_trxn_timestamp, a.trxn_timestamp - lead(trxn_timestamp) over (order by trxn_timestamp) timestamp_diff
    from (
        select 1 trx_id, 101 merchant,1 cc_id,100 amt, to_timestamp('09/25/2022 12:00:00','mm/dd/yyyy hh24:mi:ss') trxn_timestamp
        from dual
        union all
        select 2, 101,1,100, to_timestamp('09/25/2022 12:08:00','mm/dd/yyyy hh24:mi:ss')
        from dual
        union all
        select 3, 101,1,100, to_timestamp('09/25/2022 12:28:00','mm/dd/yyyy hh24:mi:ss')
        from dual
    ) a
)
where timestamp_diff <= numtodsinterval(10,'MINUTE')
