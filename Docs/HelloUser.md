# HelloUser.sh.md
aURORA_JC / 2020-12-03

## 实现步骤
### 排版构思
1. Welcome 欢迎语
2. 系统硬件信息
3. 系统开机时间
4. 用户登录次数
5. 用户上次在线时长 & 关怀语
6. 用户所在地天气
7. 一言

### API 选择
1. **IP归属地查询API**

	`http://ip-api.com/line/${usrIp}?fields=city&lang=zh-CN`
	|${usrIp}|fields|lang|
	| --------- | ------ | ----- |
	|用户IP地址|返回内容|返回语言|
	
	返回示例
	```
	长春
	```
	
2. **天气查询API**

	`http://wttr.in/${usrCity}?lang=zh-cn`
	
	|${usrIp}|lang|
	| --------- | ----- |
	|用户IP归属地|返回语言|
	
	返回示例
	```text
	天气预报： 长春
   
      \   /     晴
       .-.      -16..-9 °C     
    ― (   ) ―   ↗ 26 km/h      
       `-’      10 km          
	   /   \     0.0 mm         
	
	地点: 长春市 / Changchun, 吉林省, 130000, 中国 [43.8844498,125.3178222]
	```
	
3. **一言API**

	`http://yijuzhan.com/api/word.php`
	
	返回示例
	```
	不知何处吹芦管，一夜征人尽望乡——李益《夜上受降城闻笛》
	```

### 信息获取 & 处理
1. **CPU 信息**
	CPU 信息存储在 `/proc/cpuinfo`
	
```bash
  # 获取厂商
  cpuComp=$(cat /proc/cpuinfo | grep "vendor_id" | uniq | cut -d ':' -f2 | cut -d ' ' -f2)
	
  # 获取型号
  cpuName=$(cat /proc/cpuinfo | grep name | cut -d ':' -f2 | uniq)
	
  # 获取核心数
  cpuCores=$(cat /proc/cpuinfo | grep "cpu cores" | uniq | cut -d ':' -f2 | cut -d ' ' -f2)
```

2. **内存信息**
	
	使用 `free -mw` 命令
	
```bash
  memTotal=$(free -mw | head -2 | tail -1 | cut -d ' ' -f12)
```

3. **系统启动时长**

     使用 `uptime -p` 命令

  ```bash
  # 小时数
  upHours=$(uptime -p | cut -d ',' -f1 | cut -d ' ' -f2)
  
  # 分钟数
  upMins=$(uptime -p | cut -d ',' -f2 | cut -d ' ' -f2)
  ```

4. **当前用户名**

     使用 `whoami` 命令

  ```bash
  usrName=$(whoami)
  ```

5. **当前用户近期登录次数**

     使用 `last` 命令

  ```bash
  usrLoginTimes=$(last | grep ${usrName} | cut -d ' ' -f1 | wc -l)
  ```

6. **当前用户上次登录时长**

     使用 `last` 命令

  ```bash
  # 小时数
  usrLastOnlineTimeH=$(last | grep ${usrName} | head -2 | tail -1 | cut -d '(' -f2 | cut -d ')' -f1 | cut -d ':' -f1)
  
  # 分钟数
  usrLastOnlineTimeM=$(last | grep ${usrName} | head -2 | tail -1 | cut -d '(' -f2 | cut -d ')' -f1 | cut -d ':' -f2)
  ```

7. **当前用户IP地址**

     使用 `w -h` 命令

  ```bash
  usrIp=$(w -h | awk '{print $3}' | uniq)
  ```

8. **当前用户IP归属地**

     调用 `ip-api.com`接口 

  ```bash
  getCityApi="http://ip-api.com/line/${usrIp}?fields=city&lang=zh-CN"
  usrCity=$(curl -s ${getCityApi})
  ```

9. **当前用户IP归属地天气**

   定义 `wttr.in`接口 

  ```bash
  getWeatherApi="http://wttr.in/${usrCity}?lang=zh-cn"
  ```

10. **一言**

       定义 `yijuzhan.com`接口 

  ```bash
  getMaximApi="http://yijuzhan.com/api/word.php"
  ```
11. **格式处理**
  ```bash
  # 天气处理
  wget -q ${getWeatherApi} -O weatheraw
  head -n 1 weatheraw > info
  sed -n '38,39p' weatheraw >> info
  sed -n '3,7p' weatheraw >> info
  tail -n 2 weatheraw >> info

  # 一言处理
  curl -s ${getMaximApi} >> info
  sed -i 's/——/ —— /g' info
  sed -i 's/\r/\n/g' info
  ```

### 样式输出（彩色）
  ```bash
  # welcome message here - somewhere without color is better
  echo -e "\033[31m██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗██╗██╗██╗\033[0m";
  echo -e "\033[32m██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝██║██║██║\033[0m";
  echo -e "\033[33m██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗  ██║██║██║\033[0m";
  echo -e "\033[34m██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  ╚═╝╚═╝╚═╝\033[0m";
  echo -e "\033[35m╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗██╗██╗██╗\033[0m";
  echo -e "\033[36m ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝╚═╝╚═╝\033[0m";
  echo -e "\033[30;47m=======================================================================\033[0m";
  echo -e "\033[34m${cpuComp}'s\033[0m\033[1;34m${cpuName}\033[0m\033[34m x ${cpuCores}\033[0m - \033[1;33m${memTotal} MB 内存\033[0m\033[33m已安装！\033[0m";
  echo -e "自上次启动运行时间：\033[1;33m${upHours}\033[0m 小时, \033[1;33m${upMins}\033[0m 分";
  echo -e "用户 \033[1;32m${usrName}\033[0m，近一段时间内，您累积登录 \033[1;32m${usrLoginTimes}\033[0m 次";
  echo -e "上次在线时长 \033[1;32m${usrLastOnlineTimeH}\033[0m 小时，\033[1;32m${usrLastOnlineTimeM}\033[0m 分。注意休息，预防职业病！";
  echo -e "\033[30;47m=======================================================================\033[0m";
cat info
  echo -e "\033[30;47m=======================================================================\033[0m";
  ```

### 清理文件
  ```bash
  rm -rf weatheraw
  rm -rf info
  ```

## 代码总览
  ```bash
  #!/bin/bash
  # get server info
  cpuComp=$(cat /proc/cpuinfo | grep "vendor_id" | uniq | cut -d ':' -f2 | cut -d ' ' -f2)
  cpuName=$(cat /proc/cpuinfo | grep name | cut -d ':' -f2 | uniq)
  cpuCores=$(cat /proc/cpuinfo | grep "cpu cores" | uniq | cut -d ':' -f2 | cut -d ' ' -f2)
  memTotal=$(free -mw | head -2 | tail -1 | cut -d ' ' -f12)

  # get server power on time
  upHours=$(uptime -p | cut -d ',' -f1 | cut -d ' ' -f2)
  upMins=$(uptime -p | cut -d ',' -f2 | cut -d ' ' -f2)

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
  echo -e "自上次启动运行时间：\033[1;33m${upHours}\033[0m 小时, \033[1;33m${upMins}\033[0m 分";
  echo -e "用户 \033[1;32m${usrName}\033[0m，近一段时间内，您累积登录 \033[1;32m${usrLoginTimes}\033[0m 次";
  echo -e "上次在线时长 \033[1;32m${usrLastOnlineTimeH}\033[0m 小时，\033[1;32m${usrLastOnlineTimeM}\033[0m 分。注意休息，预防职业病！";
  echo -e "\033[30;47m=======================================================================\033[0m";
cat info
  echo -e "\033[30;47m=======================================================================\033[0m";

  # clean files
  rm -rf weatheraw
  rm -rf info

  ```

## 效果展示
![DTKUKg.jpg](https://s3.ax1x.com/2020/12/03/DTKUKg.jpg)

## 项目链接
  https://github.com/aURORA-JC/MyShells