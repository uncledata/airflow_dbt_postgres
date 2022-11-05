# Intro

When running some PoC or trying out how different tools plays together, usually I create docker image or create docker-compose for this purpose. Noticed that somehow not always I push the to GitHub. This lead me going over and over these combinations.

To avoid this for the future I decided to create initial combination of what's usually on my mind when playing around:

* Airflow
* Postgres (is used as Airflow DB + Data warehouse)
* dbt 

# Notes

Airflow webserver runs on port 8181!

I'm lazy and everywhere I've used *airflow:airflow* combination as username and password. Playing around locally won't hurt if afterwards anyway I'm going to turn off my playground. Database is reachable in local network on *192.168.1.3:5432*

Added dbt_profiles_example_postgres.yml file as a reminder how it should look like. 

Since sometimes I have primary/secondary project going for PoC I'm using *~/.dbt_sandbox/profiles.yml* for complete isolation and ability to re-use same names.

Never tried to play around with networks before. This was my approach (stiched stuff found on stackoverflow/google). Would be nice to hear if that's actually how it's supposed to be.

# Folder structure

* airflow-local-docker - all matters related to airflow environment.
* dags - dasg folder where you'd put all your dags
* transform - dbt folder initialized

# Run

```bash
docker-compose build && docker-compose pull && docker-compose up
```