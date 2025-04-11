from sqlmesh import macro

@macro()
def cents_to_dollars(evaluator, string_column):
    """Convert cents to dollars with proper rounding"""
    return f"ROUND(CAST({string_column} AS NUMERIC) / 100, 2)"
