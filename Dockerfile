FROM redash/redash:latest

RUN apt-get update  -y
RUN apt-get install -y unzip
RUN apt-get install -y libaio-dev  # depends on Oracle
RUN apt-get clean -y

# Oracle instantclient
ADD oracle/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip
ADD oracle/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip /tmp/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip


RUN mkdir -p /opt/oracle/
RUN unzip /tmp/instantclient-basic-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-jdbc-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-odbc-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-sdk-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-19.3.0.0.0dbru.zip -d /opt/oracle/

RUN ln -s /opt/oracle/instantclient_19_3 /opt/oracle/instantclient
RUN ln -s /opt/oracle/instantclient/libclntsh.so.19.3 /opt/oracle/instantclient/libclntsh.so
RUN ln -s /opt/oracle/instantclient/sqlplus /usr/local/bin/sqlplus



ENV ORACLE_HOME=/opt/oracle/instantclient
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/oracle/instantclient
ENV PATH=/opt/oracle/instantclient_19_3:$PATH

RUN pip install cx_Oracle==5.2.1

USER redash
#Add REDASH ENV to add Oracle Query Runner 
ENV REDASH_ADDITIONAL_QUERY_RUNNERS=redash.query_runner.oracle
