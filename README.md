# Инструкция по установке Redash c поддержкой Oracle
### 1. Клонировать текущий репозитрий
```bash
```
### 2. Скачать Redash v7.0.0
```bash
$ curl -L -O https://github.com/getredash/redash/archive/v7.0.0.zip
$ unzip v7.0.0.zip && cd ./redahs 
```
### 3.Создать папку redash/oracle/
```bash
$ mkdir oracle
```
### 4 Скопировать файлы клиента ORACLE
instantclient-*.zip
```bash
$ mv /redash_oracle/oracle/instantclient-*.zip oracle/
```
Для поддежки кирилтци в запрсах необходимо изменить/добавить кодировку оболочки
проветь какя кодировка командой
```bash
$ echo $LANG
```
Изменить кодировку
```bash
$ export LANG=ru_RU.utf8
```
Если у вас был ранее установлен Redash. Сделайте резевную копию директорий /opt/redash и var/lib/postgresql.
Остановите все контейнеры
```bash
$ docker stop $(docker ps -a -q)
```
### 5 Запустить настройку 
Скопируйте из /redash_oracle/setup.sh в /redash/setup/
```bash
# redash/setup/
$ chmod a+x setup.sh
$ ./setup.sh
```
### 6 Построить Docker образ
Перезаписать /redash/requirements_oracle_ds.txt следующим содержимым
```bash
cx_Oracle
```
Скопируйте из /redash_oracle/Dockerfile в /redash/ и затем создайте образ
```bash
$ docker build -t sa/redash .
```
### 7 Развернуть контейнер
Скопируйте из /redash_oracle/docker-compose.yml в /opt/redash перед развертыванием.

Для новой установки Redash выполните команды:
```bash
$ cd /opt/redash
$ docker-compose run --rm server create_db
$ docker-compose up -d
$ docker-compose logs -f
```
Для обновления Redash выполните команды:
```bash
$ cd /opt/redash
$ docker-compose run --rm server manage db upgrade
$ docker-compose up -d
$ docker-compose logs -f
```
