Включить отображение меню Grub   

По умолчанию меню загрузчика Grub скрыто и нет задержки при загрузке. Для отображения меню нужно отредактировать конфигурационный файл.   

root@warmachine:/home/alex# nano /etc/default/grub   
GRUB_DEFAULT=0   
#GRUB_TIMEOUT_STYLE=hidden  
GRUB_TIMEOUT=10   
GRUB_DISTRIBUTOR=`( . /etc/os-release; echo ${NAME:-Ubuntu} ) 2>/dev/null || echo Ubuntu`   
GRUB_CMDLINE_LINUX_DEFAULT=""   
GRUB_CMDLINE_LINUX=""   

Обновляем конфигурацию загрузчика и перезагружаемся для проверки.   
root@warmachine:/home/alex# update-grub   
Sourcing file `/etc/default/grub'   
Generating grub configuration file ...   
Found linux image: /boot/vmlinuz-6.8.0-64-generic   
Found initrd image: /boot/initrd.img-6.8.0-64-generic   
Warning: os-prober will not be executed to detect other bootable partitions.   
Systems on them will not be added to the GRUB boot configuration.   
Check GRUB_DISABLE_OS_PROBER documentation entry.   
Adding boot menu entry for UEFI Firmware Settings ...   
done   

root@warmachine:/home/alex# reboot    
![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/GRUB1.jpg)   

![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/GRUB2.jpg)   
В конце строки, начинающейся с linux, добавляем init=/bin/bash и нажимаем сtrl-x для загрузки в систему   
В целом на этом все, Вы попали в систему. Но есть один нюанс. Рутовая файловая   
система при этом монтируется в режиме Read-Only. Если вы хотите перемонтировать ее в режим Read-Write, можно воспользоваться командой:   
![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/GRUB3.jpg)   

В меню загрузчика на первом уровне выбрать второй пункт (Advanced options…), далее загрузить пункт меню с указанием recovery mode в названии.     
Получим меню режима восстановления.   
 ![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/GRUB4.jpg)    
В этом меню сначала включаем поддержку сети (network) для того, чтобы файловая система перемонтировалась в режим read/write (либо это можно сделать вручную).   
Далее выбираем пункт root и попадаем в консоль с пользователем root. Если вы ранее устанавливали пароль для пользователя root (по умолчанию его нет), то необходимо его ввести.    
В этой консоли можно производить любые манипуляции с системой.     
Установить систему с LVM, после чего переименовать VG    
Мы установили систему Ubuntu 22.04 со стандартной разбивкой диска с использованием  LVM.   
Первым делом посмотрим текущее состояние системы (список Volume Group):   
![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/GRUB5.jpg)    


Далее правим /boot/grub/grub.cfg. Везде заменяем старое название VG на новое (в файле дефис меняется на два дефиса ubuntu--vg ubuntu--otus).   
После чего можем перезагружаться и, если все сделано правильно, успешно грузимся с новым именем Volume Group и проверяем:   

![Image alt](https://github.com/RileyTheHorizon/Linux/blob/main/GRUB6.jpg)    

