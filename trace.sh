iplise=(222.86.174.1 122.192.154.1 116.163.10.1 120.240.86.1 183.240.84.1 112.13.205.1)
iplocal=(黔南电信 徐州联通 长沙联通 江门移动 汕头移动 杭州移动)
if [ ! -f "besttrace" ]; then
	wget -N --no-check-certificate https://raw.githubusercontent.com/weing104/across/master/besttrace && chmod +x besttrace
	fi
clear
echo -e "\n正在测试,请稍等..."
echo -e "——————————————————————————————\n"
for i in {0..5}; do
	./besttrace -q1 -T ${iplise[i]} > /root/traceroute_testlog
	grep -q "223\.120\."  /root/traceroute_testlog
	if [ $? == 0 ];then
		echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动CMI\033[0m"
    else
		grep -q "218\.105\."  /root/traceroute_testlog
		if [ $? == 0 ];then
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通9929\033[0m"
		else
			grep -q "203\.160\."  /root/traceroute_testlog
			if [ $? == 0 ];then
				echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通香港\033[0m"
			else
				grep -q "219\.158\.113\."  /root/traceroute_testlog
				if [ $? == 0 ];then
					grep -q "23\.255\."  /root/traceroute_testlog
					if [ $? == 0 ];then
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通4837\033[0m"
					else
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
					fi
				else
					grep -q "219\.158\.116\."  /root/traceroute_testlog
					if [ $? == 0 ];then
					grep -q "23\.255\."  /root/traceroute_testlog
						if [ $? == 0 ];then
							echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通4837\033[0m"
						else
							echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
						fi
					else
						grep -q "221\.183\." /root/traceroute_testlog
						if [ $? == 0 ];then
							grep -q "59\.43\."  /root/traceroute_testlog
							if [ $? == 0 ];then
								echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;31m电信CN2GIA\033[0m"
							else
								echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动CMI\033[0m"
							fi
						else
							grep -q "221\.176\." /root/traceroute_testlog
							if [ $? == 0 ];then
								grep -q "59\.43\."  /root/traceroute_testlog
								if [ $? == 0 ];then
									echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;31m电信CN2GIA\033[0m"
								else
									echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动CMI\033[0m"
								fi
							else
								grep -q "219\.158\." /root/traceroute_testlog
								if [ $? == 0 ];then
									grep -q "59\.43\."  /root/traceroute_testlog
									if [ $? == 0 ];then
										echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;31m电信CN2GIA\033[0m"
									else
										echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
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
										grep -q "202\.97\."  /root/traceroute_testlog
										if [ $? == 0 ];then
											grep -q "219\.158\." /root/traceroute_testlog
											if [ $? == 0 ];then
												echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
											else
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
	fi
echo 
done
echo -e "——————————————————————————————\n"
rm -f /root/traceroute_testlog
