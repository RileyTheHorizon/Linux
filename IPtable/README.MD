Описание/Пошаговая инструкция выполнения домашнего задания:
Что нужно сделать?

реализовать knocking port
centralRouter может попасть на ssh inetrRouter через knock скрипт
пример в материалах.
добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
запустить nginx на centralServer.
пробросить 80й порт на inetRouter2 8080.
дефолт в инет оставить через inetRouter.

Работа knocking port

vagrant@centralRouter:~$ ./knock.sh 192.168.255.1 7000 8000 9000
Starting Nmap 7.80 ( https://nmap.org ) at 2025-11-08 16:09 UTC
Nmap scan report for 192.168.255.1
Host is up (0.0016s latency).

PORT     STATE  SERVICE
7000/tcp closed afs3-fileserver
MAC Address: 08:00:27:B5:8E:55 (Oracle VirtualBox virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 0.23 seconds
Starting Nmap 7.80 ( https://nmap.org ) at 2025-11-08 16:09 UTC
Nmap scan report for 192.168.255.1
Host is up (0.00094s latency).

PORT     STATE  SERVICE
8000/tcp closed http-alt
MAC Address: 08:00:27:B5:8E:55 (Oracle VirtualBox virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 0.14 seconds
Starting Nmap 7.80 ( https://nmap.org ) at 2025-11-08 16:09 UTC
Nmap scan report for 192.168.255.1
Host is up (0.00068s latency).

PORT     STATE  SERVICE
9000/tcp closed cslistener
MAC Address: 08:00:27:B5:8E:55 (Oracle VirtualBox virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 0.13 seconds
vagrant@centralRouter:~$ ssh vagrant@192.168.255.1
The authenticity of host '192.168.255.1 (192.168.255.1)' can't be established.
ED25519 key fingerprint is SHA256:3Kx0owYyde1lkXFpWq6kKB89SP6CVZJfGsqBOMtTEP8.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.255.1' (ED25519) to the list of known hosts.
Last login: Sat Nov  8 15:28:51 2025 from 172.17.136.254
vagrant@inetRouter:~$ exit
logout
Connection to 192.168.255.1 closed.
