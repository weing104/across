iplise=(180.149.128.1 180.153.28.1 113.108.209.1 123.125.99.1 58.247.0.49 210.21.4.130 211.136.25.153 221.183.55.22 211.139.129.5)
iplocal=(北京电信 上海电信 广州电信 北京联通 上海联通 广州联通 北京移动 上海移动 广州移动)
if [ ! -f "besttrace" ]; then
	wget -N --no-check-certificate https://raw.githubusercontent.com/weing104/across/master/besttrace && chmod +x besttrace
	fi
clear
echo -e "\n正在测试,请稍等..."
echo -e "——————————————————————————————\n"
for i in {0..8}; do
	./besttrace -q1 -T ${iplise[i]} > /root/traceroute_testlog
	grep -q "223\.120\."  /root/traceroute_testlog
	if [ $? == 0 ];then
		echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动CMI\033[0m"
    else
		grep -q "218\.105\."  /root/traceroute_testlog
		if [ $? == 0 ];then
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通9929\033[0m"
		else
			grep -q "59\.43\." /root/traceroute_testlog
			if [ $? == 0 ];then
				grep -q "222\.183\."  /root/traceroute_testlog
				if [ $? == 0 ];then
					echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;32m电信CN2GIA\033[0m"
				fi
			else
				grep -q "59\.43\." /root/traceroute_testlog
				if [ $? == 0 ];then
					grep -q "222\.176\."  /root/traceroute_testlog
					if [ $? == 0 ];then
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;32m电信CN2GIA\033[0m"
					fi
				else
					grep -q "59\.43\." /root/traceroute_testlog
					if [ $? == 0 ];then
						grep -q "219\.158\."  /root/traceroute_testlog
						if [ $? == 0 ];then
							echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;32m电信CN2GIA\033[0m"
						fi
					else
						grep -q "59\.43\." /root/traceroute_testlog
						if [ $? == 0 ];then
							grep -q "202\.97\."  /root/traceroute_testlog
							if [ $? == 0 ];then
								echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;32m电信CN2GT\033[0m"
								else
								echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;31m电信CN2GIA\033[0m"
							fi
						else
							grep -q "219\.158\."  /root/traceroute_testlog
							if [ $? == 0 ];then
								grep -q "219\.158\.113\." /root/traceroute_testlog
								if [ $? == 0 ];then
									echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通4837\033[0m"
								fi
							else
								grep -q "219\.158\."  /root/traceroute_testlog
								if [ $? == 0 ];then
									grep -q "219\.158\.116\." /root/traceroute_testlog
									if [ $? == 0 ];then
										echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通4837\033[0m"
									fi
								else
									grep -q "219\.158\."  /root/traceroute_testlog
									if [ $? == 0 ];then
										echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
									else
										grep -q "202\.97\."  /root/traceroute_testlog
										if [ $? == 0 ];then
											echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;34m电信163\033[0m"
										fi
									fi
								fi
							fi
						fi						
					fi
				fi
			fi
		fi
	fi
echo 
done
echo -e "——————————————————————————————\n"
rm -f /root/traceroute_testlog
