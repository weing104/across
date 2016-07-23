#!/bin/bash
#==============================================================#
#   Description: bench test script                             #
#   Author: Teddysun <i@teddysun.com>                          #
#   Thanks: LookBack <admin@dwhd.org>                          #
#   Visit:  https://teddysun.com                               #
#==============================================================#

get_opsy() {
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
}

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

speed_test() {
    speedtest=$(wget -4O /dev/null -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
    ipaddress=$(ping -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
    nodeName=$2
    if   [ "${#nodeName}" -lt "8" ]; then
        echo -e "\e[33m$2\e[0m\t\t\t\t\e[32m$ipaddress\e[0m\t\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -lt "13" ]; then
        echo -e "\e[33m$2\e[0m\t\t\t\e[32m$ipaddress\e[0m\t\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -lt "24" ]; then
        echo -e "\e[33m$2\e[0m\t\t\e[32m$ipaddress\e[0m\t\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -ge "24" ]; then
        echo -e "\e[33m$2\e[0m\t\e[32m$ipaddress\e[0m\t\t\e[31m$speedtest\e[0m"
    fi
}



speed() {
    speed_test 'http://cachefly.cachefly.net/100mb.test' 'CacheFly'
    speed_test 'http://speedtest.tokyo.linode.com/100MB-tokyo.bin' 'Linode, Tokyo, JP'
    speed_test 'http://speedtest.singapore.linode.com/100MB-singapore.bin' 'Linode, Singapore, SG
    speed_test 'http://speedtest.tok02.softlayer.com/downloads/test100.zip' 'Softlayer, Tokyo, JP'
    speed_test 'http://speedtest.sng01.softlayer.com/downloads/test100.zip' 'Softlayer, Singapore, SG'
    speed_test 'http://speedtest.hkg02.softlayer.com/downloads/test100.zip' 'Softlayer, HongKong, CN'
    speed_test 'http://mirror.sg.leaseweb.net/speedtest/100mb.bin' 'Leaseweb, Singapore, SG'
    speed_test 'http://mirror.hk.leaseweb.net/speedtest/100mb.bin' 'Leaseweb, HongKong, CN'
}



io_test() {
    (LANG=en_US dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

if  [ -e '/usr/bin/wget' ]; then
    cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
    freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    tram=$( free -m | awk '/Mem/ {print $2}' )
    swap=$( free -m | awk '/Swap/ {print $2}' )
    load=$( uptime | awk -F: '{print $5}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
    opsy=$( get_opsy )
    arch=$( uname -m )
    lbit=$( getconf LONG_BIT )
    host=$( hostname )
    kern=$( uname -r )

    clear
    next
    echo "CPU model            : $cname"
    echo "Number of cores      : $cores"
    echo "CPU frequency        : $freq MHz"
    echo "Total amount of ram  : $tram MB"
    echo "Total amount of swap : $swap MB"
    echo "System uptime        : $up"
    echo "Load average         : $load"
    echo "OS                   : $opsy"
    echo "Arch                 : $arch ($lbit Bit)"
    echo "Kernel               : $kern"
    next

    echo -e "Node Name\t\t\tIPv4 address\t\tDownload Speed"
    speed && next
else
    echo "Error: wget command not found. You must be install wget command at first."
    exit 1
fi

io1=$( io_test )
io2=$( io_test )
io3=$( io_test )
ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
[ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
[ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
[ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
echo "I/O speed(1st run) : $io1"
echo "I/O speed(2nd run) : $io2"
echo "I/O speed(3rd run) : $io3"
echo "Average I/O: $ioavg MB/s"
echo ""
