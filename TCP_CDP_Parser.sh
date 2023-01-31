#!/bin/bash

######################################
# Author: Administrone ///////////// #
# Function: Parse TCPDump CDP Output #
######################################

#///VARIABLES
FilterDeviceID="Device-ID"
FilterDevicePlatform="Platform"
FilterMgmtAddress="Management Addresses"
FilterPortDescription="Port Description"
FilterPortID="Port-ID"
FilterVLanNative="Native VLAN ID"
FilterVLanVOIP="VoIP"
FilterDuplex="Duplex"
OutputDeviceID=""
OutputFilter=""
OutputMgmtAddress=""
OutputPortDescription=""
OutputPortID=""
OutputVLanNative=""
OutputVLanVOIP=""
OutputDuplex=""


#///FUNCTIONS

#function ReloadIF (){
#clear
#printf "RELOADING INTERFACE ETH0, PLEASE WAIT..."
#sleep 3
#ifconfig eth0 down
#sleep 3
#ifconfig eth0 up
#sleep 5
#}

function RunTCPDump (){
clear
printf "PLEASE CONNECT ETHERNET AT THIS TIME"
sleep 5
clear
printf "RUNNING TCPDUMP TO COLLECT CDP INFORMATION...\n\n"
sleep 3
tcpdump -nn -vv -i en0 -s 1500 -c 1 'ether[20:2] == 0x2000' > DUMP.txt
tcpdump -vv -i en0 -c 100 >> DUMP.txt
}

function RunTCPDumpAgain (){
clear
printf "REPORT NOT READY, RUNNING AGAIN...    CTRL-C TO EXIT AT ANY TIME\n\n"
tcpdump -nn -vv -i en0 -s 1500 -c 1 'ether[20:2] == 0x2000' >> DUMP.txt
EvalVarNotEmpty

}

function EvalVarNotEmpty (){
if [ "${OutputDeviceID}" == "" ] || [ "$OutputDevicePlatform" ] || [ "${OutputMgmtAddress}" == "" ] || [ "${OutputPortID}" == "" ] || [ "${OutputVLanNative}" == "" ] || [ "${OutputVLanVOIP}" == "" ] || [ "${OutputDuplex}" == "" ]
#if [ "${OutputDeviceID}" == "" ] || [ 1 != 2 ]
then
clear
printf "DISPLAYING DATA COLLECTED SO FAR...\n\n"
printf "Device ID: ${OutputDeviceID}\n"
printf "Device Platform: ${OutputDevicePlatform}\n"
printf "Management Address: ${OutputMgmtAddress}\n"
printf "Port Description: ${OutputPortDescription}\n"
printf "Port ID: ${OutputPortID}\n"
printf "Native VLan: ${OutputVLanNative}\n"
printf "Voice VLan: ${OutputVLanVOIP}\n"
printf "Duplex: ${OutputDuplex}\n\n"
sleep 5
RunTCPDumpAgain
else
ParseOutput
fi
}

function ParseOutput (){

OutputDeviceID=$(cat DUMP.txt | grep -m 1 "${FilterDeviceID}" | awk '{ print $7 }')
OutputDevicePlatform=$(cat DUMP.txt | grep -m 1 "${FilterDevicePlatform}" | awk '{ print $7 $8 $9 $10 }')
OutputMgmtAddress=$(cat DUMP.txt | grep -m 1 "${FilterMgmtAddress}" | awk '{ print $10 }')
OutputPortDescription=$(cat DUMP.txt | grep -m 1 "${FilterPortDescription}" | awk '{ print $7 $8 $9 }')
OutputPortID=$(cat DUMP.txt | grep -m 1 "${FilterPortID}" | awk '{ print $7 }')
OutputVLanNative=$(cat DUMP.txt | grep -m 1 "${FilterVLanNative}"| awk '{ print $9 }')
OutputVLanVOIP=$(cat DUMP.txt | grep -m 1 "${FilterVLanVOIP}" | awk '{ print $13 }')
OutputDuplex=$(cat DUMP.txt | grep -m 1 "${FilterDuplex}" | awk '{ print $7 }')
}

function PrintOutput (){

clear
printf "TCPDump Cisco Discovery Protocol Output:\n\n"
printf "Device ID: ${OutputDeviceID}\n"
printf "Device Platform: ${OutputDevicePlatform}\n"
printf "Management Address: ${OutputMgmtAddress}\n"
printf "Port Description: ${OutputPortDescription}\n"
printf "Port ID: ${OutputPortID}\n"
printf "Native VLan: ${OutputVLanNative}\n"
printf "Voice VLan: ${OutputVLanVOIP}\n"
printf "Duplex: ${OutputDuplex} duplex\n\n"
}



#///EXECUTION 

#ReloadIF
RunTCPDump
ParseOutput
EvalVarNotEmpty
PrintOutput
