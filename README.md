# Инструкция по установке Redash c поддержкой Oracle
### 1. Клонировать текущий репозитрий
```bash
$ git clone https://github.com/wai81/redash_oracle
```
Зайдите в redash_oracle
```bash
$ cd /redash_oracle
```
### 2 Запустить настройку если увас нет установленого Redash
```bash
#/redash_oracle/
$ chmod a+x setup.sh
$ ./setup.sh
```
### 3. Создайте пользовательское изображение докера для новой установки
```bash
#/redash_oracle/
$ docker build --pull -t redash/redash: .
```
для обновления необходимо принудительне обновнеие изображения
```bash
#/redash_oracle/
$ docker build --pull -t redash/redash:latest -t redash/redash:<actual redash version> .
```
Для поддежки кирилици в запрсах необходимо изменить/добавить кодировку оболочки
проветь какя кодировка командой
```bash
#/redash_oracle/
$ echo $LANG
```
Изменить кодировку
```bash
#/redash_oracle/
$ export LANG=ru_RU.utf8
```
Если у вас был ранее установлен Redash. Сделайте резевную копию директорий /opt/redash и var/lib/postgresql.
Остановите все контейнеры
```bash
#/redash_oracle/
$ docker stop $(docker ps -a -q)
```
или только контейнеры Redash
```bash
$ docker-compose stop server scheduler scheduled_worker adhoc_worker
```
### 4 Развернуть контейнер
Скопируйте из /redash_oracle/docker-compose.yml в /opt/redash перед развертыванием или обновите файл https://github.com/getredash/setup

Для новой установки Redash выполните команды:
```bash
$ cd /opt/redash
$ docker-compose run --rm server create_db
$ docker-compose up -d
```
Для обновления Redash выполните команды:
```bash
$ cd /opt/redash
$ docker-compose run --rm server manage db upgrade
$ docker-compose up -d
```
