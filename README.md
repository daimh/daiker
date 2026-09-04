# daiker — a tiny but powerful virtual machine tool

**daiker** is a lightweight command-line tool for running virtual machines with
QEMU/KVM. The VM runs as a single process with no daemon, database, or VM
management service. It provides a simple interface for common VM operations
while giving you direct access to QEMU when you need it.

Why daiker?

- Tiny — a single executable with minimal dependencies.
- Simple — common VM operations require only a few options.
- Unprivileged — runs as a regular Linux user.
- Flexible — pass arbitrary QEMU options with -Q.
- Lightweight — no daemon, database, or VM management service.


## Prerequisites

1. Enable KVM (for good perfomance):

```bash
modprobe kvm
lsmod | grep kvm
```

2. Verify QEMU is installed:

```bash
which qemu-system-x86_64 || ls /usr/libexec/qemu-kvm
```

## Installation

```bash
wget https://raw.githubusercontent.com/daimh/daiker/master/daiker
chmod +x daiker
mv daiker ~/bin/ 
```

## Quick Start

### 1. Build a base image (Alpine Linux example)

```bash
# Download the ISO:
wget https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-standard-3.23.3-x86_64.iso

# Build base image
daiker build -i alpine-standard-3.23.3-x86_64.iso base.qcow2=1G
```

Inside the VM:
- Login as `root`
- Run `setup-alpine`
- Keep pressing `Enter` to accept default, except:
    - "Which disk would you like to use": sda
    - "How would you like to use it": sys
    - "WARNING: Erase the disks above and continue": y
- After installation: `poweroff`

### 2. Create overlay image.

```bash
daiker run overlay.qcow2:base.qcow2
```

3. Re-run the VM 

```bash
daiker run overlay.qcow2 
```
Tip: On RHEL-based systems, use VNC

[Videos](https://www.youtube.com/watch?v=nG_ql6Mptmo&list=PLcUreuc9RezIrppGh-AEYfV-FOdcE5RHY)

## Advanced Usage

- Forward a random host port to guest SSH

[Video](https://youtu.be/lhzlTCWviHo)

```bash
daiker run -T 22 test1.qcow2
```

- Forward three fixed host ports to guest SSH, RDP and VNC
  - 2299 to SSH 
  - 3399 to RDP 
  - 5999 to VNC
```bash
daiker run -T 22-2299 -T 3389-3399 -D 99 test1.qcow2 
```

- Mount host directory into guest VM

```bash
daiker run -p /tmp test1.qcow2 
# #inside the guest machine
# mount -t 9p daiker-0 /mnt
```

- Create a private network between VMs
[Video](https://youtu.be/nuahSihAbno) Note '-P' in the video is replaced by '-e'

  - start two VMs
```bash
daiker run -e vm1.qcow2
daiker run -e vm2.qcow2 
```

  - Inside each VM, configure the second NIC:
```bash
ip l set eth1 up
ip a a 192.168.8.1/24 dev eth1 # on vm1
ip a a 192.168.8.2/24 dev eth1 # on vm2
```

* Attach a block device to the VM

```bash
cat /proc/partitions # Assume it is /dev/sdz in the commands below
sudo chown -R $USER /dev/sdz
daiker run -Q "-drive file=/dev/sdz,format=raw" windows.qcow2
```

## Help

```bash
daiker -h
daiker build -h
daiker run -h
```
append '-v' to any sub-commands to check out the backend qemu commands

## Contribute

Contributions are always welcome!

## Copyright

Developed by [Manhong Dai](mailto:manhongdai@gmail.com)

Copyright © University of Michigan

License [GPLv3+](https://gnu.org/licenses/gpl.html): GNU GPL version 3 or later 

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

Jin Huan, Manager, KLA
