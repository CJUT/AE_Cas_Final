with stocks as (
    select
        stock_id,
        store_id,
        product_id,
        product_name,
        brand_name,
        category_name,
        quantity
    from {{ ref("int_local_bike__stocks_details") }}
),

stores as (
    select
        store_id,
        store_name
    from {{ ref("stg_local_bike__stores") }}
)

select
    stores.store_name,
    stocks.product_name,
    stocks.brand_name,
    stocks.category_name,
    stocks.quantity
from stocks
left join stores on stocks.store_id = stores.store_id
