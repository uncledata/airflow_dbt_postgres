from sqlmesh.core.model import model
import pandas as pd
import hashlib

@model(
    "jaffle_shop.staging.stg_supplies",
    kind="FULL",
    cron="@daily",
    columns={
        "supply_uuid": "STRING", 
        "supply_id": "STRING", 
        "product_id": "STRING", 
        "supply_name": "STRING", 
        "supply_cost": "FLOAT", 
        "is_perishable_supply": "BOOLEAN"
    },
    column_descriptions={
        "supply_uuid": "The unique key of our supplies per cost",
        "supply_id": "Supply identifier",
        "product_id": "Product identifier",
        "supply_name": "Supply name",
        "supply_cost": "Supply cost in dollars",
        "is_perishable_supply": "Whether the supply is perishable"
    },
    description="""
        List of our supply expenses data with basic cleaning and transformation applied.
        One row per supply cost, not per supply. As supply costs fluctuate they receive
        a new row with a new UUID. Thus there can be multiple rows per supply_id.
    """
)
def stg_supplies(context, **kwargs):
    # Get the raw supplies data
    raw_supplies = context.fetchdf(f"select * from {context.resolve_table('jaffle_shop.raw.raw_supplies')}")
    
    # Apply transformations
    df = pd.DataFrame(raw_supplies)
    
    # Generate surrogate key directly (not using the macro)
    df['supply_uuid'] = df.apply(lambda row: hashlib.md5(f"{row['id']}~{row['sku']}".encode()).hexdigest(), axis=1)
    
    # Convert cents to dollars
    df['supply_cost'] = df['cost'] / 100
    
    # Rename columns
    df = df.rename(columns={
        'id': 'supply_id',
        'sku': 'product_id',
        'name': 'supply_name',
        'perishable': 'is_perishable_supply'
    })
    
    # Select only needed columns
    df = df[['supply_uuid', 'supply_id', 'product_id', 'supply_name', 'supply_cost', 'is_perishable_supply']]
    
    return df