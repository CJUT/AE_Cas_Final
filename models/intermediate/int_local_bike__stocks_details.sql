with stocks as (
    select
        stock_id,
        store_id,
        product_id,
        quantity
    from {{ ref("stg_local_bike__stocks") }}
),

products as (
    select
        product_id,
        brand_id,
        product_name,
        category_id
    from {{ ref("stg_local_bike__products") }}
),

brands as (
    select
        brand_id,
        brand_name
    from {{ ref("stg_local_bike__brands") }}
),

categories as (
    select
        category_id,
        category_name
    from {{ ref("stg_local_bike__categories") }}
)

select
    stocks.stock_id,
    stocks.store_id,
    stocks.product_id,
    products.product_name,
    brands.brand_name,
    categories.category_name,
    stocks.quantity
from stocks
left join products on stocks.product_id = products.product_id
left join brands on products.brand_id = brands.brand_id
left join categories on products.category_id = categories.category_id
