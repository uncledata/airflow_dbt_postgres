import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator

DBT_DIR = "/opt/airflow/transform/data_warehouse"

with DAG(
    "my_dag_name", start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    schedule="@daily", catchup=False
) as dag:
    op = BashOperator(task_id="dbt_core_task", bash_command=f"cd {DBT_DIR} && dbt run --select my_first_dbt_model")
