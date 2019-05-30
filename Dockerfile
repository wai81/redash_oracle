FROM redash/base:latest

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

# We first copy only the requirements file, to avoid rebuilding on every file
# change.
COPY requirements.txt requirements_dev.txt requirements_all_ds.txt requirements_oracle_ds.txt ./
RUN pip install -r requirements.txt -r requirements_dev.txt -r requirements_all_ds.txt -r requirements_oracle_ds.txt

COPY . ./
RUN npm install && npm run build && rm -rf node_modules
RUN chown -R redash /app
USER redash

ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["server"]
