#!/bin/bash

loadkeys ru
setfont cyr-sun16
echo 'Установка ArchLinux'

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo '2.4 создание разделов'
(
 echo g;

 echo n;
 echo ;
 echo;
 echo +300M;
 echo y;
 echo t;
 echo 1;

 echo n;
 echo;
 echo;
 echo +31G;
 echo y;
 
  
 echo n;
 echo;
 echo;
 echo;
 echo y;
  
 echo w;
) | fdisk /dev/nvme0n1

echo 'Ваша разметка диска'
fdisk -l

echo '2.4.2 Форматирование дисков'

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4  /dev/nvme0n1p2
mkfs.ext4  /dev/nvme0n1p3

echo '2.4.3 Монтирование дисков'
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
mount /dev/nvme0n1p3 /mnt/home

echo '3.1 Выбор зеркал для загрузки.'
rm -rf /etc/pacman.d/mirrorlist
wget https://git.io/mirrorlist
mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/archuefi2.sh)"