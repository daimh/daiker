set -xe
echo opensuse-base > /etc/hostname
sed -ie "s/GRUB_TIMEOUT=8/GRUB_TIMEOUT=0/" /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
zypper addrepo http://download.opensuse.org/distribution/leap/15.3/repo/oss/ oss
