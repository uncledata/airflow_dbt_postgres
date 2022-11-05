FROM apache/airflow:2.4.2-python3.9
USER root
WORKDIR /opt
RUN apt-get update && apt-get install git gcc libpq-dev build-essential -y

USER airflow
COPY requirements.txt requirements.txt
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt


COPY ./scripts /opt/scripts

EXPOSE 8080