#!/bin/bash
#Необходимая информация в письме:

#Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
#Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
#Ошибки веб-сервера/приложения c момента последнего запуска;
#Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта.
#Скрипт должен предотвращать одновременный запуск нескольких копий, до его завершения.

# Конфигурация
LOCKFILE="/tmp/lockfile.lock"
LASTRUNFILE="/tmp/lastrunfile.lastrun"
LOGFILE="/home/riley/access-4560-644067.log"
TMPFILE="/tmp/webstats.tmp"
EMAIL="test@mail.ru" 
SUBJECT="Hourly Web Server Report"

# Функция очистки
cleanup() {
    rm -f "$LOCKFILE" "$TMPFILE"
}

# Обработка прерываний
trap 'cleanup; exit 1' INT TERM EXIT

# Проверка на блокировку + отправка отчета на mail в случае недоступности 
if [ -e "$LOCKFILE" ]; then
    echo "Script is already running. Stopping new iteration." | mailx -s "Script already running" "$EMAIL"
    exit 1
fi

# Создание файла блокировки + отправка отчета на mail в случае недоступности 
touch "$LOCKFILE" || {
    echo "Failed to create lock file" | mailx -s "Script failed" "$EMAIL"
    exit 1
}

# Проверка времени последнего запуска
if [ -e "$LASTRUNFILE" ]; then
    LASTRUN=$(cat "$LASTRUNFILE")
else
    LASTRUN=$(date -d "1 hour ago" +"%d/%b/%Y:%H:%M:%S")
fi

# Записываем текущее время запуска скрипта
date +"%d/%b/%Y:%H:%M:%S" > "$LASTRUNFILE"

# Обрабатываем только новые записи в логе
awk -v last_run="$LASTRUN" '$4 >= "["last_run' "$LOGFILE" > "$TMPFILE"

# Формируем отчет и отправляем по почте
{
    echo "Hourly Web Server Report"
    echo "======================="
    echo "Time Range: From $LASTRUN to $(date +"%d/%b/%Y:%H:%M:%S")"
    echo ""

    echo "Top IP Addresses:"
    awk '{print $1}' "$TMPFILE" | sort | uniq -c | sort -nr | head -10 | awk '{printf "%-8s %s\n", $1, $2}'
    echo ""

    echo "Top Requested URLs:"
    awk '{print $7}' "$TMPFILE" | sort | uniq -c | sort -nr | head -10 | awk '{printf "%-8s %s\n", $1, $2}'
    echo ""

    echo "HTTP Status Codes:"
    awk '{print $9}' "$TMPFILE" | sort | uniq -c | sort -nr | awk '{printf "%-8s %s\n", $1, $2}'
    echo ""

    echo "Server/Application Errors since last run:"
    ERROR_OUTPUT=$(awk -v last_run="$LASTRUN" '
        $4 >= "["last_run && \
        ($9 ~ /^5[0-9]{2}$/ || /\[error\]/) {
            print "    "$0
        }
    ' "$LOGFILE" | tail -20)

    if [ -z "$ERROR_OUTPUT" ]; then
        echo "    No critical errors detected"
    else
        echo "$ERROR_OUTPUT"
    fi
} | mailx -s "$SUBJECT" "$EMAIL"

cleanup
exit 0
