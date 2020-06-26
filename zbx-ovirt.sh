#!/bin/bash

URL='https://ovengine/ovirt-engine/api'
CACERT='/etc/pki/ovirt-engine/ca.pem'
LOGIN='admin@internal'
PASS='********'
COOKIE='/tmp/ovirt-cookie.txt'

PARAM=$1

_CURLGET(){
    curl -s --cacert "$CACERT" --request GET --user "$LOGIN:$PASS" --cookie "$COOKIE" --cookie-jar "$COOKIE" --header "Content-Type: application/json" --header "Accept: application/json" --header "Prefer: persistent-auth" "$URL/$1"
}

#debug
#echo $JSON | jq '.'

if [[ "$PARAM" == 'hosts' ]]; then
    JSONFULL=$(_CURLGET "$PARAM")
    HOSTS=$(echo "$JSONFULL" | jq -c '.host[]|{name,id}')
    JSON='{"data":['
    SEP=""
    for LINE in $HOSTS; do
	HOST_NAME=$(echo "$LINE" | jq -c '.name')
	HOST_ID=$(echo "$LINE" | jq -c '.id')
    JSON="$JSON $SEP{\"{#HOST_NAME}\":$HOST_NAME, \"{#HOST_ID}\":$HOST_ID}"
	SEP=","
    done
    JSON="$JSON]}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'vms' ]]; then
    JSONFULL=$(_CURLGET "$PARAM")
    VMS=$(echo "$JSONFULL" | jq -c '.vm[]|{name,id}')
    JSON='{"data":['
    SEP=""
    for LINE in $VMS; do
	VM_NAME=$(echo "$LINE" | jq -c '.name')
	VM_ID=$(echo "$LINE" | jq -c '.id')
	JSON="$JSON $SEP{\"{#VM_NAME}\":$VM_NAME, \"{#VM_ID}\":$VM_ID}"
	SEP=","
    done
    JSON="$JSON]}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'host_data' ]]; then
    JSONFULL=$(_CURLGET hosts/"$2")
    echo "$JSONFULL" | jq '.'
fi

if [[ "$PARAM" == 'host_stat' ]]; then
    JSONFULL=$(_CURLGET hosts/"$2"/statistics)
    STATS=$(echo "$JSONFULL" | jq -c '.statistic[]|{name,values}')
    JSON="{"
    SEP=""
    for LINE in $STATS; do
	STAT_NAME=$(echo "$LINE" | jq -c '.name')
	STAT_VALUE=$(echo "$LINE" | jq -c '.values.value[0].datum')
	JSON="$JSON $SEP $STAT_NAME:$STAT_VALUE"
	SEP=","
    done
    JSON="$JSON}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'host_nics' ]]; then
    JSONFULL=$(_CURLGET hosts/"$2"/nics)
    NICS=$(echo "$JSONFULL" | jq -c '.host_nic[]|{name,id,host}')
    JSON='{"data":['
    SEP=""
    for LINE in $NICS; do
	NIC_NAME=$(echo "$LINE" | jq -c '.name')
	NIC_ID=$(echo "$LINE" | jq -c '.id')
	HOST_ID=$(echo "$LINE" | jq -c '.host.id')
	JSON="$JSON $SEP{\"{#NIC_NAME}\":$NIC_NAME, \"{#NIC_ID}\":$NIC_ID, \"{#HOST_ID}\":$HOST_ID}"
	SEP=","
    done
    JSON="$JSON]}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'host_nic_data' ]]; then
    JSONFULL=$(_CURLGET hosts/"$2"/nics/"$3")
    echo "$JSONFULL" | jq '.'
fi

if [[ "$PARAM" == 'host_nic_stat' ]]; then
    JSONFULL=$(_CURLGET hosts/"$2"/nics/"$3"/statistics)
    STATS=$(echo "$JSONFULL" | jq -c '.statistic[]|{name,values}')
    JSON="{"
    SEP=""
    for LINE in $STATS; do
	STAT_NAME=$(echo "$LINE" | jq -c '.name')
	STAT_VALUE=$(echo "$LINE" | jq -c '.values.value[0].datum')
	JSON="$JSON $SEP $STAT_NAME:$STAT_VALUE"
	SEP=","
    done
    JSON="$JSON}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'vm_data' ]]; then
    JSONFULL=$(_CURLGET vms/"$2")
    echo "$JSONFULL" | jq '.'
fi

if [[ "$PARAM" == 'vm_stat' ]]; then
    JSONFULL=$(_CURLGET vms/"$2"/statistics)
    STATS=$(echo "$JSONFULL" | jq -c '.statistic[]|{name,values}')
    JSON="{"
    SEP=""
    for LINE in $STATS; do
	STAT_NAME=$(echo "$LINE" | jq -c '.name')
	STAT_VALUE=$(echo "$LINE" | jq -c '.values.value[0].datum')
	JSON="$JSON $SEP $STAT_NAME:$STAT_VALUE"
	SEP=","
    done
    JSON="$JSON}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'vm_nics' ]]; then
    JSONFULL=$(_CURLGET vms/"$2"/nics)
    NICS=$(echo "$JSONFULL" | jq -c '.nic[]|{name,id,vm}')
    JSON='{"data":['
    SEP=""
    for LINE in $NICS; do
	NIC_NAME=$(echo "$LINE" | jq -c '.name')
	NIC_ID=$(echo "$LINE" | jq -c '.id')
	VM_ID=$(echo "$LINE" | jq -c '.vm.id')
	JSON="$JSON $SEP{\"{#NIC_NAME}\":$NIC_NAME, \"{#NIC_ID}\":$NIC_ID, \"{#VM_ID}\":$VM_ID}"
	SEP=","
    done
    JSON="$JSON]}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'vm_nic_data' ]]; then
    JSONFULL=$(_CURLGET vms/"$2"/nics/"$3")
    echo "$JSONFULL" | jq '.'
fi

if [[ "$PARAM" == 'vm_nic_stat' ]]; then
    JSONFULL=$(_CURLGET vms/"$2"/nics/"$3"/statistics)
    STATS=$(echo "$JSONFULL" | jq -c '.statistic[]|{name,values}')
    JSON="{"
    SEP=""
    for LINE in $STATS; do
	STAT_NAME=$(echo "$LINE" | jq -c '.name')
	STAT_VALUE=$(echo "$LINE" | jq -c '.values.value[0].datum')
	JSON="$JSON $SEP $STAT_NAME:$STAT_VALUE"
	SEP=","
    done
    JSON="$JSON}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'vm_disks' ]]; then
    JSONFULL=$(_CURLGET vms/"$2"/diskattachments)
    DISKS=$(echo "$JSONFULL" | jq -c '.disk_attachment[]|{logical_name,id}')
    JSON='{"data":['
    SEP=""
    for LINE in $DISKS; do
	DISK_NAME=$(echo "$LINE" | jq -c '.logical_name')
	DISK_ID=$(echo "$LINE" | jq -c '.id')
	JSON="$JSON $SEP{\"{#DISK_NAME}\":$DISK_NAME, \"{#DISK_ID}\":$DISK_ID}"
	SEP=","
    done
    JSON="$JSON]}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'vm_disk_data' ]]; then
    JSONFULL=$(_CURLGET disks/"$2")
    echo "$JSONFULL" | jq '.'
fi

if [[ "$PARAM" == 'vm_disk_stat' ]]; then
    JSONFULL=$(_CURLGET disks/"$2"/statistics)
    STATS=$(echo "$JSONFULL" | jq -c '.statistic[]|{name,values}')
    JSON="{"
    SEP=""
    for LINE in $STATS; do
	STAT_NAME=$(echo "$LINE" | jq -c '.name')
	STAT_VALUE=$(echo "$LINE" | jq -c '.values.value[0].datum')
	JSON="$JSON $SEP $STAT_NAME:$STAT_VALUE"
	SEP=","
    done
    JSON="$JSON}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'storagedomains' ]]; then
    JSONFULL=$(_CURLGET "$PARAM")
    STORAGEDOMAINS=$(echo "$JSONFULL" | jq -c '.storage_domain[]|{name,id}')
    JSON='{"data":['
    SEP=""
    for LINE in $STORAGEDOMAINS; do
	STORAGEDOMAIN_NAME=$(echo "$LINE" | jq -c '.name')
	STORAGEDOMAIN_ID=$(echo "$LINE" | jq -c '.id')
	JSON="$JSON $SEP{\"{#STORAGEDOMAIN_NAME}\":$STORAGEDOMAIN_NAME, \"{#STORAGEDOMAIN_ID}\":$STORAGEDOMAIN_ID}"
	SEP=","
    done
    JSON="$JSON]}"
    echo "$JSON" | jq '.'
fi

if [[ "$PARAM" == 'storagedomain_data' ]]; then
    JSONFULL=$(_CURLGET storagedomains/"$2")
    echo "$JSONFULL" | jq '.'
fi
