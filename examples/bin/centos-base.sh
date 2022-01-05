set -xe
yum -y install deltarpm 
yum -y update
systemctl disable firewalld
echo centos-base > /etc/hostname
sed -ie "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
sed -ie "s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/" /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
