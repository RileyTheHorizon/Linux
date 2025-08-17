#!/bin/bash

# Реализация команды lsof - список открытых файлов и сокетов

echo "PID    USER    FD     TYPE     DEVICE   SIZE/OFF    NODE    NAME"

# Перебираем все процессы в /proc
for pid in /proc/[0-9]*; do
    pid_num=$(basename "$pid")
    user=$(stat -c %U "$pid")
    
    # Проверяем файловые дескрипторы процесса
    if [ -d "$pid/fd" ]; then
        for fd in "$pid/fd"/*; do
            fd_num=$(basename "$fd")
            link=$(readlink "$fd")
            
            # Определяем тип файла
            if [[ "$link" =~ ^socket: ]]; then
                type="SOCK"
            elif [[ "$link" =~ ^pipe: ]]; then
                type="FIFO"
            elif [[ "$link" =~ ^/dev/ ]]; then
                type="DEV"
            else
                type="REG"
            fi
            
            # Получаем информацию о файле
            if [ -e "$link" ]; then
                device=$(stat -c %D "$link" 2>/dev/null)
                size=$(stat -c %s "$link" 2>/dev/null)
                inode=$(stat -c %i "$link" 2>/dev/null)
            else
                device="-"
                size="-"
                inode="-"
            fi
            
            printf "%-6s %-8s %-6s %-8s %-10s %-12s %-8s %s\n" \
                   "$pid_num" "$user" "$fd_num" "$type" "$device" "$size" "$inode" "$link"
        done
    fi
done


Пример вывода
PID    USER    FD     TYPE     DEVICE   SIZE/OFF    NODE    NAME
1      root     *      REG      -          -            -
102    root     *      REG      -          -            -
1024   riley    0      DEV      3f         0            3        /dev/pts/0
1024   riley    1      DEV      3f         0            3        /dev/pts/0
1024   riley    2      DEV      3f         0            3        /dev/pts/0
1024   riley    255    REG      820        1489         44554    /home/riley/zadanie12.sh
