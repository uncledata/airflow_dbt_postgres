#!/bin/bash
airflow users create -u admin -p admin -r Admin -e test@test.com -f admin -l admin ;
airflow webserver