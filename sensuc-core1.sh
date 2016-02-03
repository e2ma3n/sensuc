# /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# sensuc v1.0 [ sending alert when user was logged successfully on system ]
# ------------------------------------------------------------------------ #

smtp_srv=`cat /opt/sensuc_v1/sensuc.conf | head -n 9 | tail -n 1 | cut -d = -f 2`
smtp_user=`cat /opt/sensuc_v1/sensuc.conf | head -n 11 | tail -n 1 | cut -d = -f 2`
smtp_pass=`cat /opt/sensuc_v1/sensuc.conf | head -n 13 | tail -n 1 | cut -d = -f 2`
mail_to=`cat /opt/sensuc_v1/sensuc.conf | head -n 15 | tail -n 1 | cut -d = -f 2`
IP=`cat /opt/sensuc_v1/sensuc.conf | head -n 17 | tail -n 1 | cut -d = -f 2`
Suser=`cat /opt/sensuc_v1/sensuc.conf | head -n 19 | tail -n 1 | cut -d = -f 2`
Spass=`cat /opt/sensuc_v1/sensuc.conf | head -n 21 | tail -n 1 | cut -d = -f 2`
Sto=`cat /opt/sensuc_v1/sensuc.conf | head -n 23 | tail -n 1 | cut -d = -f 2`
Sline=`cat /opt/sensuc_v1/sensuc.conf | head -n 25 | tail -n 1 | cut -d = -f 2`


if [ -n "$SSH_CLIENT" ] ; then
	t=`date '+DATE: %m/%d/%y%nTIME: %H:%M:%S'`
	msg=`echo "$USER logged into $IP by using ssh from $(echo $SSH_CLIENT | awk '{print $1}')"`
else
	t=`date '+DATE: %m/%d/%y%nTIME: %H:%M:%S'`
	msg=`echo "$USER logged into $IP by using another way"`
fi

function send-mail {
	( echo $t ; echo $msg ) | mailx -v -r "$smtp_user" -s "sensuc - `date '+%m/%d/%y'`" -S smtp=$smtp_srv -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$smtp_user -S smtp-auth-password=$smtp_pass -S ssl-verify=ignore -S nss-config-dir=/etc/pki/nssdb/ $mail_to &> /dev/null
	if [ "$?" != "0" ] ; then
		echo -n "[-] " >> /opt/sensuc_v1/log/errors.log ; date '+DATE: %m/%d/%y TIME: %H:%M:%S' >> /opt/sensuc_v1/log/errors.log
		echo "[-] Error: we have problem on send-mail" >> /opt/sensuc_v1/log/errors.log
		echo "[-] ------------------------------------------------ [-]" >> /opt/sensuc_v1/log/errors.log
	fi
}

function send-sms {
	msg=`echo $msg | sed 's/ /%20/g'`
	msg=`curl "http://n.sms.ir/SendMessage.ashx?text=$msg&lineno=$Sline&to=$Sto&user=$Suser&pass=$Spass"`
	if [ "$msg" != "ok" ] ; then
		echo -n "[-] " >> /opt/sensuc_v1/log/errors.log ; date '+DATE: %m/%d/%y TIME: %H:%M:%S' >> /opt/sensuc_v1/log/errors.log
		echo "[-] Error: we have problem on send-sms" >> /opt/sensuc_v1/log/errors.log
		echo "[-] ------------------------------------------------ [-]" >> /opt/sensuc_v1/log/errors.log
	fi
}

send-mail
send-sms
