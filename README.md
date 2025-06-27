Обновление ядра:  
1. Подключаемся по ssh к созданной виртуальной машине.  
2. Перед работами проверим текущую версию ядра uname -a  
![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/uname1.jpg)
3. Добавляем официальный PPA  с mainline-ядрами для Ubuntu sudo add-apt-repository ppa:cappelikan/ppa -y, затем sudo apt update
  ![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/capp.jpg)
4. Затем устанавливаем mainline, sudo apt install mainline
5. Устанавливаем последнюю версию ядра (только generic, неудачные/незаверешенные сборки также не включены) mainline install-latest --exclude all
6. Проверяем что ядро появилось в списке установленных ядер mainline list-installed
 ![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/mainline.jpg)
7. Выбираем загрузку нового ядра по-умолчанию: sudo grub-set-default 0
8. Далее перезагружаем нашу виртуальную машину с помощью команды sudo reboot
9. Проверяем, что ядро обновилось uname -a
 ![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/uname2.jpg)
