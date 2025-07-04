1. Создание RAID 1 - Зеркало
root@warmachine:/home/alex# mdadm --create --verbose /dev/md127 -l 1 -n 2 /dev/sd
sda   sda1  sda2  sda3  sdb   sdb1  sdb2
root@warmachine:/home/alex# mdadm --create --verbose /dev/md127 -l 1 -n 2 /dev/sdb1 /dev/sdb2
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 1046528K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md127 started.
2. Проверяем собрался ли RAID 
root@warmachine:/home/alex# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
md127 : active raid1 sdb2[1] sdb1[0]
      1046528 blocks super 1.2 [2/2] [UU]

unused devices: <none>

root@warmachine:/home/alex# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Fri Jul  4 14:07:44 2025
        Raid Level : raid1
        Array Size : 1046528 (1022.00 MiB 1071.64 MB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Fri Jul  4 14:07:49 2025
             State : clean
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : resync

              Name : warmachine:127  (local to host warmachine)
              UUID : 1ec61886:edf217d4:e235c76f:e13e4197
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       18        1      active sync   /dev/sdb2

3. Ломаем RAID

root@warmachine:/home/alex# mdadm /dev/md127 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md127
root@warmachine:/home/alex# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
md127 : active raid1 sdb2[1] sdb1[0](F)
      1046528 blocks super 1.2 [2/1] [_U]


root@warmachine:/home/alex# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Fri Jul  4 14:07:44 2025
        Raid Level : raid1
        Array Size : 1046528 (1022.00 MiB 1071.64 MB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Fri Jul  4 14:21:05 2025
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : warmachine:127  (local to host warmachine)
              UUID : 1ec61886:edf217d4:e235c76f:e13e4197
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       18        1      active sync   /dev/sdb2


4. Извлекаем диск из массива
root@warmachine:/home/alex# mdadm /dev/md127 --remove /dev/sdb1
mdadm: hot removed /dev/sdb1 from /dev/md127

5. Добавляем диск в массив 
root@warmachine:/home/alex# mdadm /dev/md127 --add /dev/sdb1
mdadm: added /dev/sdb1
root@warmachine:/home/alex# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Fri Jul  4 14:07:44 2025
        Raid Level : raid1
        Array Size : 1046528 (1022.00 MiB 1071.64 MB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Fri Jul  4 14:26:09 2025
             State : clean
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : resync

              Name : warmachine:127  (local to host warmachine)
              UUID : 1ec61886:edf217d4:e235c76f:e13e4197
            Events : 39

    Number   Major   Minor   RaidDevice State
       2       8       17        0      active sync   /dev/sdb1
       1       8       18        1      active sync   /dev/sdb2
6. Добавил фс + примонтировал каталоги

root@warmachine:/raid# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
sda                         8:0    0 12,5G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1,8G  0 part  /boot
└─sda3                      8:3    0 10,7G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0   10G  0 lvm   /
sdb                         8:16   0 10,6G  0 disk
├─sdb1                      8:17   0    1G  0 part
│ └─md127                   9:127  0 1022M  0 raid1
│   ├─md127p1             259:0    0  510M  0 part  /raid/part1
│   └─md127p2             259:1    0  510M  0 part  /raid/part2
└─sdb2                      8:18   0    1G  0 part
  └─md127                   9:127  0 1022M  0 raid1
    ├─md127p1             259:0    0  510M  0 part  /raid/part1
    └─md127p2             259:1    0  510M  0 part  /raid/part2
sr0                        11:0    1 1024M  0 rom
root@warmachine:/raid#
