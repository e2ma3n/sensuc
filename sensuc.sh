#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# sensuc v1.5 [ sending alert when user was logged successfully on system ]
# ------------------------------------------------------------------------ #

# check root privilege
[ "`whoami`" != "root" ] && echo -e '[-] Please use root user or sudo' && exit 1

# check config file
[ ! -f /opt/sensuc_v1.5/sensuc.conf ] && echo -e "\e[91m[-]\e[0m Error: can not find config file" && exit 1

# check sensuc-core.sh
[ ! -f /opt/sensuc_v1.5/sensuc-core2.sh ] && echo -e "\e[91m[-]\e[0m Error: can not find sensuc-core2.sh" && exit 1

# help function
function usage_f {
	echo "Usage: "
	echo "	sensuc --start"
	echo "	sensuc --stop"
	echo "	sensuc --status"
	echo "	sensuc --test_mail"
	echo "	sensuc --test_sms"
}

function start_f {
	pgrep -f sensuc-core2.sh &> /dev/null
	if [ "$?" = "0" ] ; then
		echo -e "\e[91m[-]\e[0m Error: sensuc service is active"
	else
		/opt/sensuc_v1.5/sensuc-core2.sh &> /dev/null &
		[ "$?" = "0" ] && echo "[+] Starting sensuc ..." && sleep 2 && echo -e "\e[92m[+]\e[0m Ok" || echo -e "\e[91m[-]\e[0m Error: sensuc service not started"
	fi
}

function stop_f {
	kill `pgrep -f sensuc-core2.sh` &> /dev/null
	[ "$?" = "0" ] && echo "[+] Stoping sensuc ..." && sleep 2 && echo -e "\e[92m[+]\e[0m Ok" || echo -e "\e[91m[-]\e[0m Error: sensuc service is inactive"
}

function status_f {
	pgrep -f sensuc-core2.sh &> /dev/null
        if [ "$?" = "0" ] ; then
		echo -e "\e[92m[+]\e[0m sensuc service is active"
	else
		echo -e "\e[91m[-]\e[0m sensuc service is inactive"
	fi
}

function test_mail {
	smtp_srv=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 9 | tail -n 1 | cut -d = -f 2`
	smtp_user=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 11 | tail -n 1 | cut -d = -f 2`
	smtp_pass=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 13 | tail -n 1 | cut -d = -f 2`
	mail_to=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 15 | tail -n 1 | cut -d = -f 2`
	IP=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 17 | tail -n 1 | cut -d = -f 2`
	t=`echo -n '20' ; date '+%y/%m/%d'`

	text="Sensuc Testing - $IP"
	echo "$text" | mailx -v -r "$smtp_user" -s "Sensuc - $t" -S smtp=$smtp_srv -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$smtp_user -S smtp-auth-password=$smtp_pass -S ssl-verify=ignore -S nss-config-dir=/etc/pki/nssdb/ $mail_to
}

function test_sms {
	Suser=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 19 | tail -n 1 | cut -d = -f 2`
	Spass=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 21 | tail -n 1 | cut -d = -f 2`
	Sto=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 23 | tail -n 1 | cut -d = -f 2`
	Sline=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 25 | tail -n 1 | cut -d = -f 2`

	msg="Sensuc_Testing"
	curl "http://n.sms.ir/SendMessage.ashx?text=$msg&lineno=$Sline&to=$Sto&user=$Suser&pass=$Spass" ; echo
}

case $1 in
	--start) start_f ;;
	--stop) stop_f ;;
	--status) status_f ;;
	--test_mail) test_mail ;;
	--test_sms) test_sms ;;
	*) usage_f ;;
esac
