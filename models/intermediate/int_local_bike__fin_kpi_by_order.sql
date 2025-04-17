select
    order_id,
    count(distinct product_id) as nb_products_by_order,
    round(sum(quantity * list_price * (1 - discount)), 2)
        as total_amount_by_order,
    round(sum(quantity * list_price * (discount)), 2)
        as total_discount_by_order,
    round(avg(discount), 2) as avg_discount_by_order
from {{ ref("stg_local_bike__order_items") }}
group by 1
