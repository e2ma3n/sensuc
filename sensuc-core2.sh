#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# sensuc v1.5 [ sending alert when user was logged successfully on system ]
# ------------------------------------------------------------------------ #
smtp_srv=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 9 | tail -n 1 | cut -d = -f 2`
smtp_user=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 11 | tail -n 1 | cut -d = -f 2`
smtp_pass=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 13 | tail -n 1 | cut -d = -f 2`
mail_to=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 15 | tail -n 1 | cut -d = -f 2`
IP=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 17 | tail -n 1 | cut -d = -f 2`
Suser=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 19 | tail -n 1 | cut -d = -f 2`
Spass=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 21 | tail -n 1 | cut -d = -f 2`
Sto=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 23 | tail -n 1 | cut -d = -f 2`
Sline=`cat /opt/sensuc_v1.5/sensuc.conf | head -n 25 | tail -n 1 | cut -d = -f 2`

for (( ;; )) ; do

	if [ -f /var/log/auth.log ] ; then
		su_user=`cat /var/log/auth.log | grep "\sSuccessful su for\s" | tr -s " " | cut -d " " -f 1,2,3,6,7,8,9,10,11`
	else
		if [ -f /var/log/secure ] ; then
			su_user=`cat /var/log/secure | grep "\ssu:\s" | grep 'session opened for user' | tr -s " " | cut -d " " -f 1,2,3,7,8,9,10,11,12,13 | sed 's/(uid=0)//'`
		else
			exit 1
		fi
	fi

	if [ ! -z "$su_user" ] ; then
		n=`echo "$su_user" | wc -l`
		for (( i=1 ; i<=$n ; i++ )) ; do
			log=`echo "$su_user" | head -n $i | tail -n 1`
			log=`echo -n $log ; echo " in $IP"`

			grep "$log" /opt/sensuc_v1.5/log/su &> /dev/null
			if [ "$?" != "0" ] ; then
				echo "$log" >> /opt/sensuc_v1.5/log/su
				echo "$log" | mailx -v -r "$smtp_user" -s "sensuc - `echo -n '20' ; date '+%y/%m/%d'`" -S smtp=$smtp_srv -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$smtp_user -S smtp-auth-password=$smtp_pass -S ssl-verify=ignore -S nss-config-dir=/etc/pki/nssdb/ $mail_to &> /dev/null
				if [ "$?" != "0" ] ; then
					echo -n "[-] " >> /opt/sensuc_v1.5/log/errors.log ; date '+DATE: %m/%d/%y TIME: %H:%M:%S' >> /opt/sensuc_v1.5/log/errors.log
					echo "[-] Error: we have problem on send-mail" >> /opt/sensuc_v1.5/log/errors.log
					echo "[-] ------------------------------------------------ [-]" >> /opt/sensuc_v1.5/log/errors.log
				fi

				log=`echo $log | sed 's/ /%20/g'`
				log=`curl "http://n.sms.ir/SendMessage.ashx?text=$log&lineno=$Sline&to=$Sto&user=$Suser&pass=$Spass"`
				if [ "$log" != "ok" ] ; then
					echo -n "[-] " >> /opt/sensuc_v1.5/log/errors.log ; date '+DATE: %m/%d/%y TIME: %H:%M:%S' >> /opt/sensuc_v1.5/log/errors.log
					echo "[-] Error: we have problem on send-sms" >> /opt/sensuc_v1.5/log/errors.log
					echo "[-] ------------------------------------------------ [-]" >> /opt/sensuc_v1.5/log/errors.log
				fi
			fi
			sleep 2
		done
	fi
	sleep 10
done
