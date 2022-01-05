# daiker, a teeny-tiny but potent virtual machine tool

Unlike Docker, daiker doesn't need any special privilege. A regular Linux account with or without X is enough.

Unlike Singularity, daiker is a full virtualization just like a real machine. You can even run Windows on it.

## Prerequisites
```
lsmod |grep kvm #verify kvm kernel module
which qemu-system-x86_64 #verify if qemu is installed
```

## Installation
```
wget https://raw.githubusercontent.com/daimh/daiker/master/daiker
chmod +x daiker
mv daiker ~/bin/ # or any directory in PATH
```

## Examples
This example shows daiker automatically install Linux virtual machines without either user interaction or root privilege. CentOS 7 and OpenSUSE 15.3 were tested on 2022-01-04.
```
cd examples
make
cd var
daiker run -b centos-base.qcow2 centos-test.qcow2 
daiker run -b opensuse-base.qcow2 opensuse-test.qcow2 
```

## Test steps. [Videos](https://www.youtube.com/watch?v=nG_ql6Mptmo&list=PLcUreuc9RezIrppGh-AEYfV-FOdcE5RHY)

1. build a base image, here we use Alpine Linux as an example
```
wget http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-standard-3.12.1-x86_64.iso
daiker build -i alpine-standard-3.12.1-x86_64.iso alpine-base.qcow2 
# #inside the guest machine
# setup-alpine
# poweroff
```
2. create a few new guest machines
```
daiker run -b alpine-base.qcow2 test1.qcow2 
daiker run -b alpine-base.qcow2 test2.qcow2 
```
3. boot the new machine if it was poweroff
```
daiker run test1.qcow2 
```

## Advanced usage
* allow outside to access SSH service on a guest machine. [Video](https://youtu.be/lhzlTCWviHo)
```
daiker run -T 22 test1.qcow2
```
* mount a directory on the host to the guest machine
```
daiker run -M /tmp test1.qcow2 
# #inside the guest machine
# mount -t 9p daiker-0 /mnt
```
* build a cluster of guest machines that can talk to each other. [Video](https://youtu.be/nuahSihAbno)
```
daiker run -P test1.qcow2
daiker run -P test2.qcow2 
# #inside guest machine test1
# ip l set eth1 up
# ip a a 192.168.8.1/24 dev eth1
# ping 192.168.8.2
# #inside guest machine test2
# ip l set eth1 up
# ip a a 192.168.8.2/24 dev eth1
```
* attach a block device to the host
```
cat /proc/partitions # please make sure it is the right device!!! Assume it is /dev/sdz in the commands below
sudo chown -R $USER /dev/sdz
daiker run -Q "-drive file=/dev/sdz,format=raw" windows.qcow2
```

## Help
```
daiker -h
```
append '-v' to any sub-commands to check out the backend qemu commands

## Contribute

Contributions are always welcome!

## Copyright

Developed by [Manhong Dai](mailto:manhongdai@gmail.com)

Copyright © 2022 KLA Corporation. License [GPLv3+](https://gnu.org/licenses/gpl.html): GNU GPL version 3 or later 

This is free software: you are free to change and redistribute it.

There is NO WARRANTY, to the extent permitted by law.

## Acknowledgment

Ruth Freedman, MPH, former administrator of MNI, UMICH

Fan Meng, Ph.D., Research Associate Professor, Psychiatry, UMICH

Huda Akil, Ph.D., Director of MNI, UMICH

Stanley J. Watson, M.D., Ph.D., Director of MNI, UMICH

Sohail Nadimi, Senior Engineer, KLA

Raghuram Bondalapati, Manager, KLA

Vijay Ramachandran, Director, KLA
