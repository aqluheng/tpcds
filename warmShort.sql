-- start query 1 in stream 0 using template query1.tpl
with customer_total_return as
(select sr_customer_sk as ctr_customer_sk
,sr_store_sk as ctr_store_sk
,sum(SR_RETURN_AMT) as ctr_total_return
from store_returns
,date_dim
where sr_returned_date_sk = d_date_sk
and d_year =2000
group by sr_customer_sk
,sr_store_sk)
 select  c_customer_id
from customer_total_return ctr1
,store
,customer
where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
from customer_total_return ctr2
where ctr1.ctr_store_sk = ctr2.ctr_store_sk)
and s_store_sk = ctr1.ctr_store_sk
and s_state = 'TN'
and ctr1.ctr_customer_sk = c_customer_sk
order by c_customer_id
limit 100;

-- end query 1 in stream 0 using template query1.tpl
-- start query 28 in stream 0 using template query28.tpl
select  *
from (select avg(ss_list_price) B1_LP
            ,count(ss_list_price) B1_CNT
            ,count(distinct ss_list_price) B1_CNTD
      from store_sales
      where ss_quantity between 0 and 5
        and (ss_list_price between 8 and 8+10 
             or ss_coupon_amt between 459 and 459+1000
             or ss_wholesale_cost between 57 and 57+20)) B1,
     (select avg(ss_list_price) B2_LP
            ,count(ss_list_price) B2_CNT
            ,count(distinct ss_list_price) B2_CNTD
      from store_sales
      where ss_quantity between 6 and 10
        and (ss_list_price between 90 and 90+10
          or ss_coupon_amt between 2323 and 2323+1000
          or ss_wholesale_cost between 31 and 31+20)) B2,
     (select avg(ss_list_price) B3_LP
            ,count(ss_list_price) B3_CNT
            ,count(distinct ss_list_price) B3_CNTD
      from store_sales
      where ss_quantity between 11 and 15
        and (ss_list_price between 142 and 142+10
          or ss_coupon_amt between 12214 and 12214+1000
          or ss_wholesale_cost between 79 and 79+20)) B3,
     (select avg(ss_list_price) B4_LP
            ,count(ss_list_price) B4_CNT
            ,count(distinct ss_list_price) B4_CNTD
      from store_sales
      where ss_quantity between 16 and 20
        and (ss_list_price between 135 and 135+10
          or ss_coupon_amt between 6071 and 6071+1000
          or ss_wholesale_cost between 38 and 38+20)) B4,
     (select avg(ss_list_price) B5_LP
            ,count(ss_list_price) B5_CNT
            ,count(distinct ss_list_price) B5_CNTD
      from store_sales
      where ss_quantity between 21 and 25
        and (ss_list_price between 122 and 122+10
          or ss_coupon_amt between 836 and 836+1000
          or ss_wholesale_cost between 17 and 17+20)) B5,
     (select avg(ss_list_price) B6_LP
            ,count(ss_list_price) B6_CNT
            ,count(distinct ss_list_price) B6_CNTD
      from store_sales
      where ss_quantity between 26 and 30
        and (ss_list_price between 154 and 154+10
          or ss_coupon_amt between 7326 and 7326+1000
          or ss_wholesale_cost between 7 and 7+20)) B6
limit 100;

-- end query 28 in stream 0 using template query28.tpl
-- start query 40 in stream 0 using template query40.tpl
select  
   w_state
  ,i_item_id
  ,sum(case when (cast(d_date as date) < cast ('2000-03-11' as date)) 
 		then cs_sales_price - coalesce(cr_refunded_cash,0) else 0 end) as sales_before
  ,sum(case when (cast(d_date as date) >= cast ('2000-03-11' as date)) 
 		then cs_sales_price - coalesce(cr_refunded_cash,0) else 0 end) as sales_after
 from
   catalog_sales left outer join catalog_returns on
       (cs_order_number = cr_order_number 
        and cs_item_sk = cr_item_sk)
  ,warehouse 
  ,item
  ,date_dim
 where
     i_current_price between 0.99 and 1.49
 and i_item_sk          = cs_item_sk
 and cs_warehouse_sk    = w_warehouse_sk 
 and cs_sold_date_sk    = d_date_sk
 and d_date between (cast ('2000-03-11' as date) - interval 30 days)
                and (cast ('2000-03-11' as date) + interval 30 days) 
 group by
    w_state,i_item_id
 order by w_state,i_item_id
limit 100;

-- end query 40 in stream 0 using template query40.tpl
-- start query 82 in stream 0 using template query82.tpl
select  i_item_id
       ,i_item_desc
       ,i_current_price
 from item, inventory, date_dim, store_sales
 where i_current_price between 62 and 62+30
 and inv_item_sk = i_item_sk
 and d_date_sk=inv_date_sk
 and d_date between cast('2000-05-25' as date) and (cast('2000-05-25' as date) + interval 60 days)
 and i_manufact_id in (129,270,821,423)
 and inv_quantity_on_hand between 100 and 500
 and ss_item_sk = i_item_sk
 group by i_item_id,i_item_desc,i_current_price
 order by i_item_id
 limit 100;

-- end query 82 in stream 0 using template query82.tpl
