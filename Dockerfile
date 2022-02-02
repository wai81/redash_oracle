FROM redash/redash:10.1.0.b50633

USER root

RUN apt-get update  -y
RUN apt-get install -y unzip
RUN apt-get install -y libaio-dev  # depends on Oracle
RUN apt-get clean -y

# -- Start setup Oracle
# Add instantclient
ADD oracle/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip

RUN mkdir -p /opt/oracle/
RUN unzip /tmp/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/

ENV ORACLE_HOME=/opt/oracle/instantclient_19_3
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_19_3:$LD_LIBRARY_PATH
ENV PATH=/opt/oracle/instantclient_19_3:$PATH

# Add REDASH ENV to add Oracle Query Runner
ENV REDASH_ADDITIONAL_QUERY_RUNNERS=redash.query_runner.oracle
# -- End setup Oracle

#COPY . ./

RUN chown -R redash /app
RUN pip install cx_Oracle==7.2
RUN pip install --upgrade pip

USER redash

ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["server"]
