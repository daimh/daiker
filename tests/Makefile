Alpine=https://dl-cdn.alpinelinux.org/alpine

define Check
	for ((i=0; i<200; i++)); \
	do \
		! grep -q 'localhost login:' $@.log || break; \
		sleep 1; \
		echo -n .; \
	done
	fuser -k $@.log || :
	grep 'localhost login:' $@.log
	mv $@.log $@
endef

define Wget
	wget -qNP $(@D)
endef

all : var/test1-modloop var/test2-uefi var/test3-cloudimage

var/test3-cloudimage : var/setup
	$(Wget) https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
	daiker run \
		-Q '-serial stdio' \
		$(@D)/overlay.qcow2:$(@D)/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 \
		&> $@.log &
	$(Check)

var/test2-uefi : Iso := alpine-standard-3.24.1-x86_64.iso
var/test2-uefi : var/setup
	$(Wget) $(Alpine)/v3.24/releases/x86_64/$(Iso)
	daiker run -ui $(@D)/$(Iso) $@.qcow2=1G \
		-Q '-serial stdio' \
		&> $@.log &
	$(Check)

var/test1-modloop : Edge := $(Alpine)/edge/releases/x86_64/netboot
var/test1-modloop : var/setup
	$(Wget) $(Edge)/vmlinuz-virt
	$(Wget) $(Edge)/initramfs-virt
	daiker run -c 1 -r 128M -M q35 \
		-Q '-serial stdio' \
		-Q '-kernel $(@D)/vmlinuz-virt' \
		-Q '-initrd $(@D)/initramfs-virt' \
		-Q '-append alpine_repo=https://dl-cdn.alpinelinux.org/alpine/edge/main'$$'\t''modloop=https://dl-cdn.alpinelinux.org/alpine/edge/releases/x86_64/netboot/modloop-virt' \
		&> $@.log &
	$(Check)

var/setup :
	mkdir -p $(@D)
	touch $@
