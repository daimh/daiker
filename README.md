# daiker, a teeny-tiny virtual machine tool

Unlike Docker, daiker doesn't need any special privilege.

Unlike Singularity, daiker is a full machine level virtualizatione just like a real machine. You can even run Windows on it

## Prerequisites
```
$ lsmod |grep kvm #verify kvm kernel module
$ which qemu-system-x86_64 #verify if qemu is installed
```

## Installation
```
$ wget https://raw.githubusercontent.com/daimh/daiker/master/daiker
$ chmod +x daiker
$ mv daiker ~/bin/ # or move to any directory in your PATH
```

## Test steps, [Video](https://www.youtube.com/watch?v=nG_ql6Mptmo&list=PLcUreuc9RezIrppGh-AEYfV-FOdcE5RHY)

1. build a base image, here we use Alpine Linux as an example
```
$ wget http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-standard-3.12.1-x86_64.iso
$ daiker build -i alpine-standard-3.12.1-x86_64.iso alpine-base.img 
```
2. inside the new machine, type root to login, run 'setup-alpine' to install Alpine, then run 'poweroff'

3. create a few new virtual machines
```
$ daiker run -b alpine-base.img test1.img 
$ daiker run -b alpine-base.img test2.img 
```
4. boot the new machine if it was poweroff
```
$ daiker run test1.img  
$ daiker run -T 22 test1.img #forward a random port on physical machine to port 22 on the virtual machine
```

## Help
```
$ daiker -h
```
append '-v' to any sub-commands to check out the backend qemu commands

## Roadmp
One more interesting feature is planned indeed, please check back later.

## Contribute

Contributions are always welcome!

## Copyright

Developed by [Manhong Dai](mailto:daimh@umich.edu)

Copyright © 2020 University of Michigan. License [GPLv3+](https://gnu.org/licenses/gpl.html): GNU GPL version 3 or later 

This is free software: you are free to change and redistribute it.

There is NO WARRANTY, to the extent permitted by law.

## Acknowledgment

Ruth Freedman, MPH, former administrator of MNI, UMICH

Fan Meng, Ph.D., Research Associate Professor, Psychiatry, UMICH

Huda Akil, Ph.D., Director of MNI, UMICH

Stanley J. Watson, M.D., Ph.D., Director of MNI, UMICH
