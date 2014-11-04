###常用
```
ps aux | sort -nk +4 | tail #内存最多的 10 个运行中的进程
du -sh * | sort -n
du -h --max-depth=1 #ncdu可以更方便的达到此效果
chattr +ai -R test
netstat -anpo | grep php-fpm|wc -l #检查php fastcgi的连接情况
lsof - p PID / pidof 
sudo !!
cp filename{,.bak} #快速备份
!!:gs/foo/bar #上一条命令，并用 :gs/foo/bar 进行替换操作
```

###系统
    # uname -a               # 查看内核/操作系统/CPU信息
    # head -n 1 /etc/issue   # 查看操作系统版本
    # cat /proc/cpuinfo      # 查看CPU信息
    # hostname               # 查看计算机名
    # lspci -tv              # 列出所有PCI设备
    # lsusb -tv              # 列出所有USB设备
    # lsmod                  # 列出加载的内核模块
    # env                    # 查看环境变量
    $ top -z -x -1 -<

###CPU
	$ ps -e -o “%C : %p : %z : %a”|sort -nr # 按cpu利用率从大到小排列
	$ cat /proc/loadavg                     # 检查前三个输出值是否超过了系统逻辑CPU的4倍 
	$ mpstat 1 1                            # 检查%idle是否过低(比如小于5%) 
	$ ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10 #查看最耗CPU的十个进程
	$ vmstat 1 5 #观察si和so值是否较大,也列给出的是可运行进程的数目，检查其是否超过系统逻辑CPU的4倍 

###内存
    # free -m                # 查看内存使用量和交换区使用量
    # df -h                  # 查看各分区使用情况
    # du -sh /home           # 查看/home目录的大小
    # uptime                 # 查看系统运行时间、用户数、负载
    # cat /proc/loadavg      # 查看系统负载
    # grep MemTotal /proc/meminfo   # 查看内存总量
    # grep MemFree /proc/meminfo    # 查看空闲内存量
    # ps -aux|awk '{print $4,$11}'|sort -r ＃看使用内存的百分比
    $ ps -e   -o "%C   : %p : %z : %a"|sort -k5 -n  #按内存从大到小排列
    $ cat /proc/meminfo #检查free值是否过低，也可以用使用free检查swap used值是否过高，如果swap used值过高，进一步检查swap动作是否频繁
    $ ipcs -m #查看共享内存
    $ ls -alh /proc/kcore #查看内存镜像

###磁盘和分区
    # mount | column -t      # 查看挂接的分区状态
    # fdisk -l               # 查看所有分区
    # swapon -s              # 查看所有交换分区
    # hdparm -i /dev/hda     # 查看磁盘参数(仅适用于IDE设备)
    # dmesg | grep IDE       # 查看启动时IDE设备检测状况

###网络
    # ifconfig               # 查看所有网络接口的属性
    # iptables -L            # 查看防火墙设置
    # route -n               # 查看路由表
    # netstat -lntp          # 查看所有监听端口
    # netstat -antp          # 查看所有已经建立的连接
    # netstat -s             # 查看网络统计信息

###进程
    # ps -ef                 # 查看所有进程
    # top                    # 实时显示进程状态

###用户
    # w                        # 查看活动用户
    # id oracle                # 查看oracle用户信息
    # last                     # 查看用户登录日志
    # cut -d: -f1 /etc/passwd  # 查看系统所有用户
    # cut -d: -f1 /etc/group   # 查看系统所有组
    # crontab -l               # 查看当前用户的计划任务

###服务
    # chkconfig --list            # 列出所有系统服务
    # chkconfig --list | grep on  # 列出所有启动的系统服务
    # chkconfig --list | awk '{if ($5=="3:on") print $1}' 
    # chkconfig --list也可以出应用是在inti.d的第几级被打开的

###程序
    # rpm -qa       # 查看所有安装的软件包

####TOP
<pre>
$ top -z -x -1 -<
“先按z键，再按x键” 
z :打开/关闭彩色显示
x :高亮显示排序列
P :按cpu排序, M :按照内存排序
c :看进程的详细路径
k :kill，然后输入PID回车就可以kill掉
按1键 :SMP的系统，会单独显示各个CPU的运行状态
< :改变排序列> :改变排序列
W :把当前配置文件到home目录下.toprc配置文件中F or O :支持更强的选择排序列的方式-b :参数可以帮你在脚本中使用top命令-n :配合-b使用，表示重新刷新一定次数后退出-d :刷新延时时间。例如-d 5 表示top每隔5秒刷新一次。（默认是3秒）
</pre>

VIRT 进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES

RES 进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA 

下面可以看出有两个
<pre>
top - 11:47:44 up 17 days,  5:57,  2 users,  load average: 2.20, 0.86, 0.47
Tasks: 102 total,   1 running, 101 sleeping,   0 stopped,   0 zombie
Cpu(s):  2.1%us,  0.1%sy,  0.0%ni, 97.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   4129840k total,  3633908k used,   495932k free,   337960k buffers
Swap:   524284k total,     9428k used,   514856k free,  2238604k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                                        
 2595 mysql     20   0  330m 180m 5044 S   11  4.5   2350:01 mysqld                                                                                          
 6736 lxdeploy  20   0  144m  82m 4272 S    3  2.1   0:15.17 ruby                                                                                            
 6724 lxdeploy  20   0  156m  85m 5152 S    1  2.1   0:18.11 ruby                                                                                            
 6727 lxdeploy  20   0  153m  84m 5120 S    1  2.1   0:15.49 ruby                                                                                            
***3458 lxdeploy  20   0 39612  24m 3504 S    1  0.6   0:35.16 ruby***
***3205 lxdeploy  20   0 30772  19m 2428 S    0  0.5  50:55.25 ruby***                                                                                            
 3399 lxdeploy  20   0  127m  70m 2336 S    0  1.7   0:46.69 ruby                                                                                            
 3446 lxdeploy  20   0  138m  78m 2620 S    0  1.9   0:40.12 ruby  
</pre>

###磁盘I/O负载

####iostat
<pre>
$ iostat -x 1 2 #检查I/O使用率(%util)是否超过100% 

$ iostat -d -k 1 10 #查看TPS和吞吐量信息 

$ iostat -d -x -k 1 10 #查看设备使用率（%util）、响应时间（await）

$ iostat -c 1 10 #查看cpu状态
</pre>

####sar
<pre>
在命令行中，n 和t 两个参数组合起来定义采样间隔和次数，t为采样间隔，是必须有的参数，n为采样次数，是可选的，默认值是1，-o file表示将命令结果以二进制格式存放在文件中，file 在此处不是关键字，是文件名。options 为命令行选项，sar命令的选项很多，下面只列出常用选项：
-A：所有报告的总和。 
-u：CPU利用率 
-v：进程、I节点、文件和锁表状态。 
-d：硬盘使用报告。 
-r：没有使用的内存页面和硬盘块。 
-g：串口I/O的情况。 
-b：缓冲区使用情况。 
-a：文件读写情况。 
-c：系统调用情况。 
-R：进程的活动情况。 
-y：终端设备活动情况。 
-w：系统交换活动。

比如 

[root@ks01 ~]# sar -u 2 5  每2秒采集一下信息 收集5次
Linux 2.6.18-194.el5 (ks01.oss.com)     05/03/2011
03:33:47 PM       CPU     %user     %nice   %system   %iowait    %steal     %idle
03:33:49 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
03:33:51 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
03:33:53 PM       all      0.00      0.00      0.00      0.03      0.00     99.97
03:33:55 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
03:33:57 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
Average:          all      0.00      0.00      0.00      0.01      0.00     99.99


* 发现系统IO特别高时，想找到具体哪个进程在进行大量IO，可以这样：--将磁盘读写数据dump出来
	$ echo 1 > /proc/sys/vm/block_dump   
 
* 分析dump后的数据
	$ dmesg | egrep "READ|WRITE|dirtied" | egrep -o '([a-zA-Z]*)' | sort | uniq -c | sort -rn | head 
 
* 查看系统信息
最大可以打开文件的数目，cpu和内存信息
cat /proc/sys/fs/file-max
cat /proc/cpuinfo
cat /proc/meminfo
linux上查看发行版本
cat /etc/issue
   * 查看系统相关信息
uname -a
</pre>

###系统情况
####清除僵死进程

	$ ps -eal | awk '{ if ($2 == "Z") {print $4}}' | kill -9 

####系统备份

	$cd /
	$tar cvpzf backup.tgz --exclude=/proc --exclude=/lost+found --exclude=/backup.tgz --exclude=/mnt --exclude=/sys / 

###发现硬件错误，磁盘错误 

	dmesg |grep error
	cat /etc/fstab