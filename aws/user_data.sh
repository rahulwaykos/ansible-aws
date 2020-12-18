#!/bin/bash

clear
cat <<EOF> /etc/motd
                                             Welcome                      
                                                             
                    If you want to use ecrypted partition,  Run following commands
                       
                     $ sudo cryptsetup -d /tmp/keyfile luksopen /dev/xvdb centos      
                     $ sudo mkfs.xfs /dev/mapper/centos  
                     $ sudo mount /dev/mapper/centos /mnt                  
                     $ sudo cryptsetup luksClose centos  (Run when done using disk)


EOF
dnf install cryptsetup cracklib-dicts -y

export disk=$(lsblk  --noheadings --raw | awk '{print substr($0,0,4)}' | uniq -c | grep 1 | awk '{print "/dev/"$2}')

dd if=/dev/urandom of=/tmp/keyfile bs=512 count=8


echo "QAZwsx23@#"| sudo cryptsetup -q luksFormat $disk

echo "QAZwsx23@#"| sudo cryptsetup luksAddKey $disk /tmp/keyfile

cryptsetup -d /tmp/keyfile luksOpen $disk removehdd

mkfs.xfs /dev/mapper/removehdd

cryptsetup luksClose removehdd

