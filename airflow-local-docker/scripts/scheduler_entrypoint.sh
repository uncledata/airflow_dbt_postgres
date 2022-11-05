#!/bin/bash

cd /opt/airflow/transform/data_warehouse && dbt clean && dbt deps
psql postgresql://airflow:airflow@192.168.1.3:5432/postgres -c "SELECT 1 FROM pg_database WHERE datname = 'data_warehouse'" | grep -q 1 || psql postgresql://airflow:airflow@192.168.1.3:5432/postgres -c "CREATE DATABASE data_warehouse"
cd /opt/airflow
airflow db init;
exec airflow scheduler

