#!/bin/bash
# -i : uninstall before install, do not delete domaincfg.ini

AEGIS_INSTALL_DIR="/usr/local/aegis"
AEGIS_SYSTEMD_SERVICE_PATH="/etc/systemd/system/aegis.service"
UNINSTALL_FOR_INSTALL=1     # 1 is false, 0 is true, default is false
UUID=""
#check linux Gentoo os 
var=`lsb_release -a | grep Gentoo`
if [ -z "${var}" ]; then 
	var=`cat /etc/issue | grep Gentoo`
fi
checkCoreos=`cat /etc/os-release 2>/dev/null | grep coreos`
if [ -d "/etc/runlevels/default" -a -n "${var}" ]; then
	LINUX_RELEASE="GENTOO"
elif [ -f "/etc/os-release" -a -n "${checkCoreos}" ]; then
	LINUX_RELEASE="COREOS"
	AEGIS_INSTALL_DIR="/opt/aegis"
else 
	LINUX_RELEASE="OTHER"
fi

AEGIS_UPDATE_SITE_ARRAY[0]="update2.aegis.aliyun.com"
AEGIS_UPDATE_SITE_ARRAY[1]="update4.aegis.aliyun.com"
AEGIS_UPDATE_SITE_ARRAY[2]="update5.aegis.aliyun.com"
AEGIS_UPDATE_SITE_ARRAY[3]="update.aegis.aliyun.com"

stop_aegis_pkill(){
    pkill -9 AliHips >/dev/null 2>&1
    /usr/local/aegis/alihips/AliHips --stopdriver
    pkill -9 AliYunDun >/dev/null 2>&1
    pkill -9 AliYunDunMonitor >/dev/null 2>&1
    pkill -9 AliYunDunUpdate >/dev/null 2>&1
    
    pkill -9 AliNet >/dev/null 2>&1
    pkill -9 AliWebGuard >/dev/null 2>&1
    
    # TODO: do not kill AliSecGuard to avoid soft lock bug for old version
    # pkill -9 AliSecGuard >/dev/null 2>&1
    pkill -9 AliDetect >/dev/null 2>&1
    pkill -9 AliSecCheck >/dev/null 2>&1
    /usr/local/aegis/AliNet/AliNet --stopdriver
    /usr/local/aegis/AliWebguard/AliWebGuard --stopdriver

    # /usr/local/aegis/AliSecGuard/AliSecGuard --stopdriver
    
    DRIVER_OWNER_FILE_PATH="/usr/local/aegis/AliSecGuard/driver_owner.txt"
    if [ -f "${DRIVER_OWNER_FILE_PATH}" ]; then
        DRIVER_OWNER_PATH=$(cat "${DRIVER_OWNER_FILE_PATH}")
        "${DRIVER_OWNER_PATH}" --stopdriver
    fi
    printf "%-40s %40s\n" "Stopping aegis" "[  OK  ]"
}

# can not remove all aegis folder, because there is backup file in globalcfg
remove_aegis(){
    kprobeArr=(
        "/sys/kernel/debug/tracing/instances/aegis_do_sys_open/set_event"
        "/sys/kernel/debug/tracing/instances/aegis_inet_csk_accept/set_event"
        "/sys/kernel/debug/tracing/instances/aegis_tcp_connect/set_event"
        "/sys/kernel/debug/tracing/instances/aegis/set_event"
        "/sys/kernel/debug/tracing/instances/aegis_/set_event"
        "/sys/kernel/debug/tracing/instances/aegis_accept/set_event"
        "/sys/kernel/debug/tracing/kprobe_events"
        "/usr/local/aegis/aegis_debug/tracing/set_event"
        "/usr/local/aegis/aegis_debug/tracing/kprobe_events"
    )
    
    for value in ${kprobeArr[@]}
    do
        if [ -f "$value" ]; then
            echo > $value
        fi
    done
    
    rm -f ${AEGIS_INSTALL_DIR}/globalcfg/install_info.ini
    if [ -d "${AEGIS_INSTALL_DIR}" ];then
        umount ${AEGIS_INSTALL_DIR}/aegis_debug
        if [ -d "${AEGIS_INSTALL_DIR}/cgroup/cpu" ];then
            umount ${AEGIS_INSTALL_DIR}/cgroup/cpu
        fi
        if [ -d "${AEGIS_INSTALL_DIR}/cgroup" ];then
            umount ${AEGIS_INSTALL_DIR}/cgroup
        fi
        rm -rf ${AEGIS_INSTALL_DIR}/aegis_client
        rm -rf ${AEGIS_INSTALL_DIR}/aegis_update
        rm -rf ${AEGIS_INSTALL_DIR}/alihids
        
        # when uninstall.sh call by AliAqsInstall_64, it can not delete domaincfg.ini, because it may create new domaincfg.ini for install
        # UNINSTALL_FOR_INSTALL is 0 when call by AliAqsInstall_64
        if [ ${UNINSTALL_FOR_INSTALL} == 1 ]; then
            echo "remove domaincfg.ini"
            rm -f ${AEGIS_INSTALL_DIR}/globalcfg/domaincfg.ini
        fi
    fi
}

uninstall_systemd_service()
{
    if [ -f "$AEGIS_SYSTEMD_SERVICE_PATH" ]; then
        systemctl stop aegis 2>/dev/null
        systemctl --no-reload disable aegis 2>/dev/null
        rm -f "$AEGIS_SYSTEMD_SERVICE_PATH"
    fi
    return 0
}

uninstall_service() {
   
   if [ -f "/etc/init.d/aegis" ]; then
		/etc/init.d/aegis stop  >/dev/null 2>&1
		rm -f /etc/init.d/aegis 
   fi

	if [ $LINUX_RELEASE = "GENTOO" ]; then
		rc-update del aegis default 2>/dev/null
		if [ -f "/etc/runlevels/default/aegis" ]; then
			rm -f "/etc/runlevels/default/aegis" >/dev/null 2>&1;
		fi
    elif [ -f /etc/init.d/aegis ]; then
         /etc/init.d/aegis  uninstall
	    for ((var=2; var<=5; var++)) do
			if [ -d "/etc/rc${var}.d/" ];then
				 rm -f "/etc/rc${var}.d/S80aegis"
		    elif [ -d "/etc/rc.d/rc${var}.d" ];then
				rm -f "/etc/rc.d/rc${var}.d/S80aegis"
			fi
		done
    fi
    
    # uninstall systemd service
    uninstall_systemd_service
}

wait_aegis_exit()
{
    var=1
    limit=10
    echo "wait aegis exit";

    while [[ $var -lt $limit ]]; do 
        if [ -n "$(ps -ef|grep aegis_client|grep -v grep)" ]; then
            sleep 1
        else
            return
        fi
         
        ((var++))
    done     
    
    echo "wait AliYunDun process exit fail, possibly due to self-protection, please uninstall aegis or disable self-protection from the aegis console."
    exit 6
}

report_uninstall_result()
{
    echo "start report uninstall"

	checkValue=0
    for((; checkValue < ${#AEGIS_UPDATE_SITE_ARRAY[@]}; checkValue++)) 
    do
        echo "${AEGIS_UPDATE_SITE_ARRAY[checkValue]}"
        curl --retry 2 --connect-timeout 5 -m 30 --header "Content-Type: application/json" --request POST --data "{\"version\": 4,\"data\": {\"uuid\": \"${UUID}\", \"type\": \"uninstall\"}}"  "https://${AEGIS_UPDATE_SITE_ARRAY[checkValue]}/update"
        if [ $? == 0 ]; then
			return $checkValue
		fi
    done;
    
	echo "report uninstall result error" 1>&2
	exit 1
}

# entry
if [ `id -u` -ne "0" ]; then
    echo "ERROR: This script must be run as root." 1>&2
    exit 8
fi

#parse argument
for arg in "$@"
do
	argkey="${arg:0:2}"
	argvalue="${arg#*=}"
    
	if [ "${argkey}" == "-i" ]; then 
		UNINSTALL_FOR_INSTALL=0
        echo "uninstall for install"
	elif [ "${argkey}" == "-d" ]; then
		UUID=${argvalue}
    elif [ "${argkey}" == "-u" ]; then
        AEGIS_UPDATE_SITE_ARRAY=(${argvalue//|/ })
        echo "specify udpate domain argument is ${argvalue}"
    else
        # old AliYunDun just send uuid as argument
        UUID="${arg}"
	fi
done
echo "uuid is ${UUID}"

stop_aegis_pkill
wait_aegis_exit
uninstall_service
remove_aegis
umount ${AEGIS_INSTALL_DIR}/aegis_debug
printf "%-40s %40s\n" "Uninstalling aegis"  "[  OK  ]"

# report uninstall result
if [ -n "${UUID}" -a "${UNINSTALL_FOR_INSTALL}" != 0 ]; then
    report_uninstall_result
fi
