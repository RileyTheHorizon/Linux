Обновление ядра:  
1. Подключаемся по ssh к созданной виртуальной машины.  
2. Перед работами проверим текущую версию ядра uname -a  
image  
3. Добавляем официальный PPA  с mainline-ядрами для Ubuntu sudo add-apt-repository ppa:cappelikan/ppa -y, затем sudo apt update
4. image
5. Затем устанавливаем mainline, sudo apt install mainline
6. Устанавливаем последнюю версию ядра (только generic, неудачные/незаверешенные сборки также не включены) mainline install-latest --exclude all
7. Проверяем что ядро появилось в списке установленных ядер mainline list-installed
8. image
9. Выбираем загрузку нового ядра по-умолчанию: sudo grub-set-default 0
10. Далее перезагружаем нашу виртуальную машину с помощью команды sudo reboot
11. Проверяем, что ядро обновилось uname -a
12. image
