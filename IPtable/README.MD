## Задание

1. Реализовать knocking port: centralRouter может попасть на ssh inetRouter через knock скрипт
([пример](https://wiki.archlinux.org/title/Port_knocking)).
2. Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
запустить nginx на centralServer.
3. Пробросить 80й порт на inetRouter2 8080.
4. Дефолт в инет оставить через inetRouter.

Работа knocking port в log.file
