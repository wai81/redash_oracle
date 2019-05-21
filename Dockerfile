FROM redash/redash:latest

USER root

# Oracle instantclient
ADD oracle/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip

RUN mkdir -p /opt/oracle/
RUN apt-get update  -y
RUN apt-get install -y unzip

RUN unzip /tmp/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/

RUN apt-get install libaio1 -y
RUN apt-get clean -y

ENV ORACLE_HOME=/opt/oracle/instantclient
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/oracle/instantclient
ENV PATH=/opt/oracle/instantclient_19_3:$PATH

# Add REDASH ENV to add Oracle Query Runner
ENV REDASH_ADDITIONAL_QUERY_RUNNERS=redash.query_runner.oracle

RUN pip install cx_Oracle

USER redash
