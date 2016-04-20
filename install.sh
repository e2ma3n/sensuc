#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# sensuc v1.5 [ sending alert when user was logged successfully on system ]
# ------------------------------------------------------------------------ #

# check root privilege
[ "`whoami`" != "root" ] && echo '[-] Please use root user or sudo' && exit 1

# check profile file
[ ! -f /etc/profile ] && echo '[-] /etc/profile not found' && exit 1

# help function
function help_f {
	echo 'Usage: '
	echo '	sudo ./install.sh -i [install program]'
	echo "	sudo ./install.sh -u [help to uninstall program]"
	echo '	sudo ./install.sh -c [check dependencies]'
}

# install program on system
function install_f {
	[ ! -d /opt/sensuc_v1.5/ ] && mkdir -p /opt/sensuc_v1.5/ && echo "[+] Directory created" || echo '[-] Error: /opt/sensuc_v1.5/ exist'
	sleep 1
	[ ! -f /opt/sensuc_v1.5/sensuc-core1.sh ] && cp sensuc-core1.sh /opt/sensuc_v1.5/ && chmod 755 /opt/sensuc_v1.5/sensuc-core1.sh && echo '[+] sensuc-core1.sh copied' || echo '[-] Error: /opt/sensuc_v1.5/sensuc-core1.sh exist'
	sleep 1
	cat /etc/profile | grep '(/opt/sensuc_v1.5/sensuc-core1.sh &) &> /dev/null' &> /dev/null
	if [ "$?" != "0" ] ; then
		echo '(/opt/sensuc_v1.5/sensuc-core1.sh &) &> /dev/null' >> /etc/profile
		echo '[+] sensuc-core1.sh added in /etc/profile'
	else
		echo '[-] Error: maybe sensuc-core1.sh exist in /etc/profile'
		exit 1
	fi
	sleep 1
	[ ! -f /opt/sensuc_v1.5/sensuc-core2.sh ] && cp sensuc-core2.sh /opt/sensuc_v1.5/ && chmod 700 /opt/sensuc_v1.5/sensuc-core2.sh && echo '[+] sensuc-core2.sh copied' || echo '[-] Error: /opt/sensuc_v1.5/sensuc-core2.sh exist'
    sleep 1
	[ ! -f /opt/sensuc_v1.5/sensuc.conf ] && cp sensuc.conf /opt/sensuc_v1.5/ && chmod 644 /opt/sensuc_v1.5/sensuc.conf && echo '[+] sensuc.conf copied' || echo '[-] Error: /opt/sensuc_v1.5/sensuc.conf exist'
	sleep 1
	[ ! -f /opt/sensuc_v1.5/sensuc.sh ] && cp sensuc.sh /opt/sensuc_v1.5/ && chmod 700 /opt/sensuc_v1.5/sensuc.sh && echo "[+] sensuc.sh copied" || echo "[-] Error: /opt/sensuc_v1.5/sensuc.sh exist"
	sleep 1
	[ -f /opt/sensuc_v1.5/sensuc.sh ] && ln -s /opt/sensuc_v1.5/sensuc.sh /usr/bin/sensuc &> /dev/null && echo '[+] symbolic link created' || echo '[-] Error: /opt/sensuc_v1.5/sensuc.sh not found'
	sleep 1
	[ ! -d /opt/sensuc_v1.5/log/ ] && mkdir -p /opt/sensuc_v1.5/log/ && echo '[+] Log Directory created' || echo '[-] /opt/sensuc_v1.5/log/ exist'
	sleep 1
	[ ! -f /opt/sensuc_v1.5/README ] && cp README /opt/sensuc_v1.5/ ; echo '[+] Please see README'
	sleep 0.5
	echo "[+] you have two choises : start manually or Starting up Script As a daemon" ; sleep 0.5
	echo "[!] Warning: You should run program as root" ; sleep 0.5
	echo "[!] Warning: You should edit config file" ; sleep 0.5
	echo "[+] this program now is compatible with sms[dot]ir panel" ; sleep 0.5
	echo "[+] Done"
}

# uninstall program from system
function uninstall_f {
	echo "For uninstall program:"
	echo "	sudo rm -rf /opt/sensuc_v1.5"
	echo "	sudo rm -f /usr/bin/sensuc"
	echo "	remove sensuc-core1.sh from /etc/profile"
}

# check dependencies on system
function check_f {
	echo '[+] check dependencies on system:  '
	for program in cat mailx grep date sed curl sleep awk whoami pgrep kill chmod cp
	do
		sleep 0.5
		if [ ! -z `which $program 2> /dev/null` ] ; then
			echo "[+] $program found"
		else
			echo "[-] Error: $program not found"
		fi
	done
}

case $1 in
	-i) install_f ;;
	-u) uninstall_f ;;
	-c) check_f ;;
	*) help_f ;;
esac
