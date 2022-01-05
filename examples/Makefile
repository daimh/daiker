DISTROS=centos opensuse
PORT_web=55550
PORT_centos=55551
PORT_opensuse=55552
SSH=ssh -T -o BatchMode=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i var/ssh-key
WAIT=for ((i=1; ; i++)); do ! $(SSH) -p $1 root@localhost hostname || break; sleep 2; echo "MSG-001: ssh -p $1, attempt $$i"; done
var/done : $(addprefix var/,$(addsuffix -base.qcow2,$(DISTROS)))
	fuser -k $(PORT_web)/tcp || :
	touch $@
define BASE_TMPL
var/$1-base.qcow2 : var/$1-autoinstall var/web
	rm -f $$@.tmp
	which daiker || (echo "run 'wget https://raw.githubusercontent.com/daimh/daiker/master/daiker && chmod +x daiker', and move it to your PATH"; exit 1)
	daiker build -H 50 -c 8 -r 2 -i $$<.iso -T 22-$$(PORT_$1) $$@.tmp &
	$$(call WAIT,$$(PORT_$1))
	$(SSH) -p $$(PORT_$1) root@localhost < bin/$1-base.sh
	$(SSH) -p $$(PORT_$1) root@localhost <<< poweroff || :
	mv $$@.tmp $$@
endef
$(foreach O,$(DISTROS),$(eval $(call BASE_TMPL,$O)))
#centos
var/centos-autoinstall : var/CentOS-7-x86_64-Minimal-2009
	mkdir -p $@-dir
	bsdtar xfp $<.iso -C$@-dir
	sed -ie "s/timeout 600/timeout 1/; s/rd.live.check quiet/inst.ks=http:\/\/10.0.2.2:$(PORT_web)\/kickstart.cfg/" $@-dir/isolinux/isolinux.cfg
	rm $@-dir/isolinux/isolinux.cfge
	cd $(@D) && genisoimage -l -r -J -V "CentOS 7 x86_64" -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -o $(@F).iso $(@F)-dir
	rm -rf $@-dir
	touch $@
var/CentOS-7-x86_64-Minimal-2009 :
	mkdir -p $(@D)
	wget -P $(@D) -c http://centos.mirror.shastacoe.net/centos/7/isos/x86_64/$(@F).iso
	touch $@
#opensuse
var/opensuse-autoinstall : var/openSUSE-Leap-15.3-DVD-x86_64-Current
	mkdir -p $@-dir
	bsdtar xfp $<.iso -C$@-dir
	chmod -R u+w $@-dir
	sed -ie "s/timeout\t\t600/timeout\t\t1/; s/default harddisk/default linux/; s/splash=silent showopts$$/autoyast=http:\/\/10.0.2.2:$(PORT_web)\/autoyast.xml/" $@-dir/boot/x86_64/loader/isolinux.cfg
	rm $@-dir/boot/x86_64/loader/isolinux.cfge
	cd $(@D) && genisoimage -l -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b boot/x86_64/loader/isolinux.bin -o $(@F).iso $(@F)-dir
	rm -rf $@-dir
	touch $@
var/openSUSE-Leap-15.3-DVD-x86_64-Current :
	mkdir -p $(@D)
	wget -P $(@D) -c https://download.opensuse.org/distribution/leap/15.3/iso/$(@F).iso
	touch $@
#common
var/web : var/ssh-key bin/kickstart.cfg bin/autoyast.xml
	mkdir -p $@-dir
	sed -e "s/PORT_web/$(PORT_web)/" bin/kickstart.cfg > $@-dir/kickstart.cfg
	sed -e "s/PORT_web/$(PORT_web)/" bin/autoyast.xml > $@-dir/autoyast.xml
	cp $<.pub $@-dir/authorized_keys
	fuser -k $(PORT_web)/tcp || :
	cd var/web-dir && python3 -m http.server $(PORT_web) --bind 127.0.0.1 &
	touch $@
var/ssh-key :
	ssh-keygen -t ed25519 -N "" -f $@
