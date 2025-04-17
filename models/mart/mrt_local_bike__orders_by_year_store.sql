with stores_staffs as (
    select
        stores.store_id,
        stores.store_name,
        staffs.staff_id,
        staffs.first_name || " " || staffs.last_name as staff_name
    from {{ ref("stg_local_bike__staffs") }} as staffs
    inner join
        {{ ref("stg_local_bike__stores") }} as stores
        on staffs.store_id = stores.store_id
),

stores_staffs_orders as (
    select
        EXTRACT(year from orders.order_date) as order_year,
        orders.store_id,
        orders.staff_id,
        COUNT(distinct orders.customer_id) as nb_customers,
        COUNT(distinct orders.order_id) as nb_orders,
        ROUND(SUM(fin_order.nb_products_by_order), 2) as nb_products_ordered,
        ROUND(SUM(fin_order.total_amount_by_order), 2) as total_amount_ordered,
        ROUND(SUM(fin_order.total_discount_by_order), 2)
            as total_discount_accorded
    from {{ ref("stg_local_bike__orders") }} as orders
    left join
        {{ ref("int_local_bike__fin_kpi_by_order") }} as fin_order
        on orders.order_id = fin_order.order_id
    group by 1, 2, 3
)

select
    stores_staffs.store_name,
    stores_staffs.staff_name,
    stores_staffs_orders.order_year,
    stores_staffs_orders.nb_customers,
    stores_staffs_orders.nb_orders,
    stores_staffs_orders.nb_products_ordered,
    stores_staffs_orders.total_amount_ordered,
    stores_staffs_orders.total_discount_accorded,
    stores_staffs_orders.total_discount_accorded
    / (
        stores_staffs_orders.total_discount_accorded
        + stores_staffs_orders.total_amount_ordered
    ) as discount_rate
from stores_staffs_orders
left join
    stores_staffs
    on
        stores_staffs_orders.store_id = stores_staffs.store_id
        and stores_staffs_orders.staff_id = stores_staffs.staff_id
