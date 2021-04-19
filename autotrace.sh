# install besttrace
if [ ! -f "besttrace" ]; then
	arch=$(uname -m)
    if [ "${arch}" == "i686" ]; then
    	wget -O besttrace https://github.com/flyzy2005/shell/raw/master/besttrace32
    else
    	wget https://github.com/flyzy2005/shell/raw/master/besttrace
    fi
    chmod +x besttrace
fi

# start to use besttrace

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

clear
next

ip_list=(222.86.174.1 116.163.10.1 120.240.86.1 202.115.255.2)
ip_addr=(黔南电信 长沙联通 江门移动 成都教育网)
# ip_len=${#ip_list[@]}

for i in {0..3}
do
	echo ${ip_addr[$i]}
	./besttrace -q 1 ${ip_list[$i]}
	next
done