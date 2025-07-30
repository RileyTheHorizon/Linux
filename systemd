 Cоздаём файл с конфигурацией для сервиса в директории /etc/default - из неё сервис будет брать необходимые переменные.
root@warmachine:/home/alex# cat /etc/default/watchlog
# Configuration file for my watchlog service
# Place it to /etc/default

# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/watchlog.log
Затем создаем /var/log/watchlog.log и пишем туда строки на своё усмотрение,
плюс ключевое слово ‘ALERT’
Создадим скрипт:
root@warmachine:/opt# cat > /opt/watchlog.sh
#!/bin/bash

WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
logger "$DATE: I found word, Master!"
else
exit 0
fi
Команда logger отправляет лог в системный журнал.
Добавим права на запуск файла:
root@warmachine:/opt# chmod +x /opt/watchlog.sh
Создадим юнит для сервиса:
root@warmachine:/opt# cat > /etc/systemd/system/watchlog.service
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/default/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
Создадим юнит для таймера:
root@warmachine:/opt# cat > /etc/systemd/system/watchlog.timer
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
Затем достаточно только запустить timer:
root@warmachine:/etc/systemd/system# systemctl start watchlog.timer
И убедиться в результате: root@warmachine:/opt# tail -n 1000 /var/log/syslog  | grep word
2025-07-30T13:29:06.533804+00:00 warmachine root: Ср 30 июл 2025 13:29:06 UTC: I found word, Master!
2025-07-30T13:29:50.151655+00:00 warmachine root: Ср 30 июл 2025 13:29:50 UTC: I found word, Master!
2025-07-30T13:30:26.081931+00:00 warmachine root: Ср 30 июл 2025 13:30:26 UTC: I found word, Master!
2025-07-30T13:31:01.251711+00:00 warmachine root: Ср 30 июл 2025 13:31:01 UTC: I found word, Master!
2025-07-30T13:31:42.917193+00:00 warmachine root: Ср 30 июл 2025 13:31:42 UTC: I found word, Master!
2025-07-30T13:32:20.072521+00:00 warmachine root: Ср 30 июл 2025 13:32:20 UTC: I found word, Master!
Устанавливаем spawn-fcgi и необходимые для него пакеты:
root@warmachine:/opt# apt install spawn-fcgi php php-cgi php-cli \
 apache2 libapache2-mod-fcgid -y
 необходимо создать файл с настройками для будущего сервиса в файле /etc/spawn-fcgi/fcgi.conf.
Он должен получится следующего вида:

root@warmachine:/opt# cat > /etc/spawn-fcgi/fcgi.conf
# You must set some working options before the "spawn-fcgi" service will work.
# If SOCKET points to a file, then this file is cleaned up by the init script.
#
# See spawn-fcgi(1) for all possible options.
#
# Example :
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u www-data -g www-data -s $SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cgi"

root@warmachine:/etc/systemd/system# cat > /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/spawn-fcgi/fcgi.conf
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
Убеждаемся, что все успешно работает:
root@warmachine:/etc/systemd/system# systemctl start spawn-fcgi
root@warmachine:/etc/systemd/system# systemctl status spawn-fcgi
● spawn-fcgi.service - Spawn-fcgi startup service by Otus
     Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; preset: enabled)
     Active: active (running) since Wed 2025-07-30 14:05:09 UTC; 3s ago
   Main PID: 10511 (php-cgi)
      Tasks: 33 (limit: 2249)
     Memory: 14.6M (peak: 14.7M)
        CPU: 39ms
     CGroup: /system.slice/spawn-fcgi.service
             ├─10511 /usr/bin/php-cgi
             ├─10512 /usr/bin/php-cgi
             ├─10513 /usr/bin/php-cgi
             ├─10514 /usr/bin/php-cgi
             ├─10515 /usr/bin/php-cgi
             ├─10516 /usr/bin/php-cgi
             ├─10517 /usr/bin/php-cgi
             ├─10518 /usr/bin/php-cgi
             ├─10519 /usr/bin/php-cgi
             ├─10520 /usr/bin/php-cgi
             ├─10521 /usr/bin/php-cgi
             ├─10522 /usr/bin/php-cgi
             ├─10523 /usr/bin/php-cgi
             ├─10524 /usr/bin/php-cgi
             ├─10525 /usr/bin/php-cgi
             ├─10526 /usr/bin/php-cgi
             ├─10527 /usr/bin/php-cgi
             ├─10528 /usr/bin/php-cgi
             ├─10529 /usr/bin/php-cgi
             ├─10530 /usr/bin/php-cgi
             ├─10531 /usr/bin/php-cgi
             ├─10532 /usr/bin/php-cgi
             ├─10533 /usr/bin/php-cgi
             ├─10534 /usr/bin/php-cgi
             ├─10535 /usr/bin/php-cgi
             ├─10536 /usr/bin/php-cgi
             ├─10537 /usr/bin/php-cgi
             ├─10538 /usr/bin/php-cgi
             ├─10539 /usr/bin/php-cgi
             ├─10540 /usr/bin/php-cgi
             ├─10541 /usr/bin/php-cgi
             ├─10542 /usr/bin/php-cgi
             └─10543 /usr/bin/php-cgi

июл 30 14:05:09 warmachine systemd[1]: Started spawn-fcgi.service - Spawn-fcgi startup service by Otus.
Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно

Установим Nginx из стандартного репозитория:
root@warmachine:/etc/systemd/system# apt install nginx -y
Для запуска нескольких экземпляров сервиса модифицируем исходный service для использования различной конфигурации, а также PID-файлов. Для этого создадим новый Unit для работы с шаблонами (/etc/systemd/system/nginx@.service):
root@warmachine:/etc/systemd/system# cat > /etc/systemd/system/nginx@.service

# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx-%I.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-%I.conf -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-%I.conf -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -c /etc/nginx/nginx-%I.conf -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx-%I.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target

Далее необходимо создать два файла конфигурации (/etc/nginx/nginx-first.conf, /etc/nginx/nginx-second.conf). Их можно сформировать из стандартного конфига /etc/nginx/nginx.conf, с модификацией путей до PID-файлов и разделением по портам:
root@warmachine:/etc/nginx# ps afx | grep nginx
  11295 pts/1    S+     0:00                              \_ grep --color=auto nginx
  11273 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on;
  11274 ?        S      0:00  \_ nginx: worker process
  11284 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on;
  11285 ?        S      0:00  \_ nginx: worker process







