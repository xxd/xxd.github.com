
* 通过netstat –i组合检测网络接口状况
* 通过netstat –r组合检测系统的路由表信息
* 通过sar –n组合显示系统的网络运行状态


普通检查
--

总进程总数(超过250要注意)

	$ ps aux | wc -l 
	$ ps -ef | grep nginx | wc -l
	$ watch -n 1 -d "pgrep nginx|wc -l"
	$ sudo netstat -antp | grep 80 | grep ESTABLISHED -c
总用户数

	$ who | wc -l
然后检查IP的重复数 并从小到大排序 注意 “-t\ +0” 中间是两个空格

	$ less pkts | awk {'printf $3"\n"'} | cut -d. -f 1-4 | sort | uniq -c | awk {'printf $1" "$2"\n"'} | sort -n -t\ +0 

系统连接状态：
--

	$ netstat -tunlp|grep name  ＃常用命令，列出服务器上正在跑得app
	$ netstat -ap |grep ssh  #-a 表示所有端口 －p显示pid
	$ netstat -r  #显示路由信息类似于’route -n’的输出


1.查看TCP连接状态

	$ netstat -nat
	$ netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn
	$ netstat -n | awk '/^tcp/ {++state[$NF]}; END {for(key in state) print key,"t",state[key]}'
	或者 
	$ netstat -n | awk '/^tcp/ {++S[$NF]};END {for(a in S) print a, S[a]}'

其他

	$ netstat -n | awk '/^tcp/ {++arr[$NF]};END {for(k in arr) print k,"t",arr[k]}'
	$ netstat -ant | awk '{print $NF}' | grep -v '[a-z]' | sort | uniq -c

2.查找请求数请20个IP（常用于查找攻来源）：

	$ netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n20

查看排列最多TIME_WAIT连接的20个IP：

	$ netstat -nat|grep TIME_WAIT|awk '{print $5}'|sort|uniq -c|sort -rn|head -n20

其他

	netstat -ant |awk '/:80/{split($5,ip,":");++A[ip[1]]}END{for(i in A) print A[i],i}' |sort -rn|head -n20

3.用tcpdump嗅探80端口的访问看看谁最高

	$ tcpdump -i eth0 -tnn dst port 80 -c 1000 | awk -F"." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -nr |head -20
	
	$ tcpdump -A -i eth0:1 "src host 192.0.0.111 and src port 40854" > tmp.log  //这是抓取从192.0.0.111:40854发送过来的通信包

4.查找较多time_wait连接

	$ netstat -n|grep TIME_WAIT|awk '{print $5}'|sort|uniq -c|sort -rn|head -n20
5.找查较多的SYN连接

	$ netstat -an | grep SYN | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | more
6.根据端口列进程

	$ netstat -ntlp | grep 80 | awk '{print $7}' | cut -d/ -f1

lsof查看可疑IP & Port
--

	nmap -PT 192.168.1.127-245　
	
	当我们使用　netstat -apn　查看网络连接的时候，会发现很多类似下面的内容：　
	Proto Recv-Q Send-Q Local Address Foreign Address State PID/Program name　
	tcp 0 52 218.104.81.152：7710 211.100.39.250：29488 ESTABLISHED 6111/1　
	
	显示这台开放了7710端口，那么这个端口属于哪个程序呢？我们可以使用　lsof -i ：7710　命令来查询：　　　
	COMMAND PID USER FD TYPE DEVICE SIZE NODE NAME　　　
	sshd 1990 root 3u IPv4 4836 TCP *：7710 （LISTEN）　
	
	这样，我们就知道了7710端口是属于sshd程序的。　　
	$ lsof -i @192.168.1.10
	COMMAND  PID USER   FD   TYPE        DEVICE  SIZE/OFF NODE NAME
	sshd    1934 root    6u  IPv6 0x300046d21c0 0t1303608  TCP sun:ssh->linux:40379                             (ESTABLISHED)
	sshd    1937 root    4u  IPv6 0x300046d21c0 0t1303608  TCP sun:ssh->linux:40379                             (ESTABLISHED)
	
	$ lsof -i :25
	COMMAND  PID USER   FD   TYPE        DEVICE SIZE/OFF NODE NAME
	sendmail 605 root    5u  IPv4 0x300010ea640      0t0  TCP *:smtp (LISTEN)
	sendmail 605 root    6u  IPv6 0x3000431c180      0t0  TCP *:smtp (LISTEN)
	
####杀掉80端口相关的进程(紧急)

lsof -i :80|grep -v "PID"|awk '{print "kill -9",$2}'|sh 

网络负载
--

	$ sar -n DEV--检查网络流量(rxbyt/s, txbyt/s)是否过高 
	$ cat /proc/net/dev --检查是否有网络错误(drop fifo colls carrier)也可以用命令
	
网站日志分析篇1（Apache & Nginx）：
--

1.获得访问前10位的ip地址

	$ cat access.log|awk '{counts[$(11)]+=1}; END {for(url in counts) print counts[url], url}'
2.访问次数最多的文件或页面,取前20

	awk '{print $11}' /tmp/nginx.access.log | sort | uniq -c | sort -nr | head -20 
3.列出传输最大的几个exe文件（分析下载站的时候常用）

	cat access.log |awk '($7~/.exe/){print $10 " " $1 " " $4 " " $7}'|sort -nr|head -20
4.列出输出大于200000byte(约200kb)的exe文件以及对应文件发生次数

	cat access.log |awk '($10 > 200000 && $7~/.exe/){print $7}'|sort -n|uniq -c|sort -nr|head -100
5.如果日志最后一列记录的是页面文件传输时间，则有列出到客户端最耗时的页面

	cat access.log |awk  '($7~/.php/){print $NF " " $1 " " $4 " " $7}'|sort -nr|head -100
6.列出最最耗时的页面(超过60秒的)的以及对应页面发生次数

	cat access.log |awk '($NF > 60 && $7~/.php/){print $7}'|sort -n|uniq -c|sort -nr|head -100
7.列出传输时间超过 30 秒的文件

	cat access.log |awk '($NF > 30){print $7}'|sort -n|uniq -c|sort -nr|head -20
8.统计网站流量（G)

	cat access.log |awk '{sum+=$10} END {print sum/1024/1024/1024}'
9.统计404的连接

	awk '($9 ~/404/)' access.log | awk '{print $9,$7}' | sort
10 统计http status

	cat access.log |awk '{counts[$(9)]+=1}; END {for(code in counts) print code, counts[code]}'cat access.log |awk '{print $9}'|sort|uniq -c|sort -rn
10.蜘蛛分析，查看是哪些蜘蛛在抓取内容。

	$ /usr/sbin/tcpdump -i eth0 -l -s 0 -w - dst port 80 | strings | grep -i user-agent | grep -i -E 'bot|crawler|slurp|spider'
	log_format main '[$time_local] $remote_addr $status $request_time $body_bytes_sent "$request" "$http_referer"';
	access_log      /data0/logs/access.log  main; 
	
	格式如下：
	[21/Mar/2011:11:52:15 +0800] 58.60.188.61 200 0.265 28 "POST /event/time HTTP/1.1" "http://host/loupan/207846/feature"

通过日志查看当天ip连接数，过滤重复

	cat access.log | grep "20/Mar/2011" | awk '{print $3}' | sort | uniq -c | sort -nr
	38 112.97.192.16     
	20 117.136.31.145     
	19 112.97.192.31      
	3 61.156.31.20      
	2 209.213.40.6      
	1 222.76.85.28
当天访问页面排前10的url:

	cat access.log | grep "20/Mar/2011" | awk '{print $8}' | sort | uniq -c | sort -nr | head -n 10

生成压力测试脚本：

	cat /tmp/nginx.access.log | awk '{print $7}' | grep -v "(" | grep -v ")" | awk '{ if(NR%1000==0) {print "sleep 1; date;  wget -q http://192.168.0.11"$1 " --output-document=/dev/null &"} else print "wget -q http://192.168.0.11"$1 " --output-document=/dev/null &" }' >80.sh//制作压力脚本

	cat /var/log/apache2/access.log | awk '{ print $7 } ' | sort | uniq -c | sort -rn | less //查看图片的访问频率

找出访问次数最多的10个IP

	awk '{print $3}' access.log |sort |uniq -c|sort -nr|head  
	10680 10.0.21.17   
	1702 10.0.20.167    
	823 10.0.20.51    
	504 10.0.20.255    
	215 58.60.188.61    
	192 183.17.161.216     
	38 112.97.192.16     
	20 117.136.31.145     
	19 112.97.192.31      
	6 113.106.88.10

找出某天访问次数最多的10个IP

	cat /tmp/access.log | grep "20/Mar/2011" |awk '{print $3}'|sort |uniq -c|sort -nr|head     
	38 112.97.192.16     
	20 117.136.31.145     
	19 112.97.192.31      
	3 61.156.31.20      
	2 209.213.40.6      
	1 222.76.85.28
当天ip连接数最高的ip都在干些什么:

	cat access.log | grep "10.0.21.17" | awk '{print $8}' | sort | uniq -c | sort -nr | head -n 10224 /test/themes/default/img/logo_index.gif    
	224 /test/themes/default/img/bg_index_head.jpg    
	224 /test/themes/default/img/bg_index.gif    
	219 /test/vc.php    
	219 /    
	213 /misc/js/global.js    
	211 /misc/jsext/popup.ext.js    
	211 /misc/js/common.js    
	210 /sladmin/home    
	197 /misc/js/flib.js
找出访问次数最多的几个分钟

	awk '{print $1}' access.log | grep "20/Mar/2011" |cut -c 14-18|sort|uniq -c|sort -nr|head     
	24 16:49     
	19 16:17     
	16 16:51     
	11 16:48      
	4 16:50      
	3 16:52      
	1 20:09      
	1 20:05      
	1 20:03      
	1 19:55
	
网站日分析2(Squid篇）
--

按域统计流量

	$ zcat squid_access.log.tar.gz| awk '{print $10,$7}' |awk 'BEGIN{FS="[ /]"}{trfc[$4]+=$1}END{for(domain in trfc){printf "%st%dn",domain,trfc[domain]}}'

--EOF--