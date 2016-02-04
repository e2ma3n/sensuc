#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# sensuc v1.0 [ sending alert when user was logged successfully on system ]
# ------------------------------------------------------------------------ #

# check root privilege
[ "`whoami`" != "root" ] && echo '[-] Please use root user or sudo' && exit 1

# check profile file
[ ! -f /etc/profile ] && echo '[-] /etc/profile not found' && exit 1

# help function
function help_f {
	echo 'Usage: '
	echo '	sudo ./install.sh -i [install program]'
	echo '	sudo ./install.sh -c [check dependencies]'
}

# install program on system
function install_f {
	[ ! -d /opt/sensuc_v1/ ] && mkdir -p /opt/sensuc_v1/ && echo "[+] Directory created" || echo '[-] Error: /opt/sensuc_v1/ exist'
	sleep 1
	[ ! -f /opt/sensuc_v1/sensuc-core1.sh ] && cp sensuc-core1.sh /opt/sensuc_v1/ && chmod 755 /opt/sensuc_v1/sensuc-core1.sh && echo '[+] sensuc-core1.sh copied' || echo '[-] Error: /opt/sensuc_v1/sensuc-core1.sh exist'
	sleep 1
	cat /etc/profile | grep '(/opt/sensuc_v1/sensuc-core1.sh &) &> /dev/null' &> /dev/null
	if [ "$?" != "0" ] ; then
		echo '(/opt/sensuc_v1/sensuc-core1.sh &) &> /dev/null' >> /etc/profile
		echo '[+] sensuc-core1.sh added in /etc/profile'
	else
		echo '[-] Error: maybe sensuc-core1.sh exist in /etc/profile'
		exit 1
	fi
	sleep 1
	[ ! -f /opt/sensuc_v1/sensuc-core2.sh ] && cp sensuc-core2.sh /opt/sensuc_v1/ && chmod 700 /opt/sensuc_v1/sensuc-core2.sh && echo '[+] sensuc-core2.sh copied' || echo '[-] Error: /opt/sensuc_v1/sensuc-core2.sh exist'
    sleep 1
	[ ! -f /opt/sensuc_v1/sensuc.conf ] && cp sensuc.conf /opt/sensuc_v1/ && chmod 644 /opt/sensuc_v1/sensuc.conf && echo '[+] sensuc.conf copied' || echo '[-] Error: /opt/sensuc_v1/sensuc.conf exist'
	sleep 1
	[ ! -f /opt/sensuc_v1/sensuc.sh ] && cp sensuc.sh /opt/sensuc_v1/ && chmod 700 /opt/sensuc_v1/sensuc.sh && echo "[+] sensuc.sh copied" || echo "[-] Error: /opt/sensuc_v1/sensuc.sh exist"
	sleep 1
	[ -f /opt/sensuc_v1/sensuc.sh ] && ln -s /opt/sensuc_v1/sensuc.sh /usr/bin/sensuc &> /dev/null && echo '[+] symbolic link created' || echo '[-] Error: /opt/sensuc_v1/sensuc.sh not found'
	sleep 1
	[ ! -d /opt/sensuc_v1/log/ ] && mkdir -p /opt/sensuc_v1/log/ && echo '[+] Log Directory created' || echo '[-] /opt/sensuc_v1/log/ exist'
	sleep 1
	[ ! -f /opt/sensuc_v1/README ] && cp README /opt/sensuc_v1/ ; echo '[+] Please see README'
}

# check dependencies on system
function check_f {
	echo '[+] check dependencies on system:  '
	for program in cat mailx grep date sed curl sleep awk whoami pgrep kill chmod cp
	do
		if [ ! -z `which $program 2> /dev/null` ] ; then
			echo "[+] $program found"
		else
			echo "[-] Error: $program not found"
		fi
	done
}

case $1 in
	-i) install_f ;;
	-c) check_f ;;
	*) help_f ;;
esac
