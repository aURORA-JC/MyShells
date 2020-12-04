#!/bin/bash
# get server info
cpuComp=$(cat /proc/cpuinfo | grep "vendor_id" | uniq | cut -d ':' -f2 | cut -d ' ' -f2)
cpuName=$(cat /proc/cpuinfo | grep name | cut -d ':' -f2 | uniq)
cpuCores=$(cat /proc/cpuinfo | grep "cpu cores" | uniq | cut -d ':' -f2 | cut -d ' ' -f2)
memTotal=$(free -mw | head -2 | tail -1 | cut -d ' ' -f12)

# whoami get user's name
usrName=$(whoami)

# get user's login times
usrLoginTimes=$(last | grep ${usrName} | cut -d ' ' -f1 | wc -l)
usrLastOnlineTimeH=$(last | grep ${usrName} | head -2 | tail -1 | cut -d '(' -f2 | cut -d ')' -f1 | cut -d ':' -f1)
usrLastOnlineTimeM=$(last | grep ${usrName} | head -2 | tail -1 | cut -d '(' -f2 | cut -d ')' -f1 | cut -d ':' -f2)

# w -h get user's ip
usrIp=$(w -h | awk '{print $3}' | uniq)

# ip-api.com get user's local
getCityApi="http://ip-api.com/line/${usrIp}?fields=city&lang=zh-CN"
usrCity=$(curl -s ${getCityApi})

# wttr.in get local weather
getWeatherApi="http://wttr.in/${usrCity}?lang=zh-cn"

# yijunzhan.com get maxim
getMaximApi="http://yijuzhan.com/api/word.php"

# get, format weather & maxim
# weather info
wget -q ${getWeatherApi} -O weatheraw
head -n 1 weatheraw > info
sed -n '38,39p' weatheraw >> info
sed -n '3,7p' weatheraw >> info
tail -n 2 weatheraw >> info

# maxim info
curl -s ${getMaximApi} >> info
sed -i 's/——/ —— /g' info
sed -i 's/\r/\n/g' info

# welcome message here - somewhere without color is better
echo -e "\033[31m██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗██╗██╗██╗\033[0m";
echo -e "\033[32m██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝██║██║██║\033[0m";
echo -e "\033[33m██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗  ██║██║██║\033[0m";
echo -e "\033[34m██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  ╚═╝╚═╝╚═╝\033[0m";
echo -e "\033[35m╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗██╗██╗██╗\033[0m";
echo -e "\033[36m ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝╚═╝╚═╝\033[0m";
echo -e "\033[30;47m=======================================================================\033[0m";
echo -e "\033[34m${cpuComp}'s\033[0m\033[1;34m${cpuName}\033[0m\033[34m x ${cpuCores}\033[0m - \033[1;33m${memTotal} MB 内存\033[0m\033[33m已安装！\033[0m";
cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("自上次启动运行时间：\033[1;33m%d\033[0m 天 \033[1;33m%d\033[0m 时 \033[1;33m%d\033[0m 分 \033[1;33m%d\033[0m 秒\n",run_days,run_hour,run_minute,run_second)}'
echo -e "用户 \033[1;32m${usrName}\033[0m，近一段时间内，您累积登录 \033[1;32m${usrLoginTimes}\033[0m 次";
echo -e "上次在线时长 \033[1;32m${usrLastOnlineTimeH}\033[0m 小时，\033[1;32m${usrLastOnlineTimeM}\033[0m 分。注意休息，预防职业病！";
echo -e "\033[30;47m=======================================================================\033[0m";
cat info
echo -e "\033[30;47m=======================================================================\033[0m";

# clean files
rm -rf weatheraw
rm -rf info
