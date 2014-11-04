###常用
```ruby
ps aux | sort -nk +4 | tail #内存最多的 10 个运行中的进程
du -sh * | sort -n
du -h --max-depth=1 #ncdu可以更方便的达到此效果
chattr +ai -R test
netstat -anpo | grep php-fpm|wc -l #检查php fastcgi的连接情况
lsof - p PID / pidof 
sudo !!
cp filename{,.bak} #快速备份
!!:gs/foo/bar #上一条命令，并用 :gs/foo/bar 进行替换操作
top -z -x -1 -< 
```

####实现sudo 命令免密码执行
近期在进行一个自动化脚本时，由于需要在非root 用户下执行，即：sudo -A command/XXX.sh
此时在正常情况下当脚本执行到sudo时需要手动向控制台输入密码，这里利用环境变量SUDO_ASKPASS来实现免密码执行

1、创建一个密码文件，如_PWD_TEMP_
    vim  _PWD_TEMP_
    #! /bin/bash
    echo  yourpassword

2、在脚本中执行sudo 命令之前引入环境变量SUDO_ASKPASS
    export SUDO_ASKPASS=./_PWD_TEMP_

3、执行命令
    sudo -A  command/XXX.sh

#####查看系统中占用端口的进程
$ netstat -tulnp
Netstat是很常用的用来查看Linux网络系统的工具之一，这个参数可以背下来：
-t: 显示TCP链接信息
-u: 显示UDP链接信息
-l: 显示监听状态的端口
-n: 直接显示ip，不做名称转换
-p: 显示相应的进程PID以及名称（要root权限）
如果要查看关于sockets更详细占用信息等，可以使用lsof工具。

#####Find
	$ find 对应目录 -name "FILENAME"  -mtime +5  -exec rm -rf {} \; 
	$ find -type f -size 0 -exec rm -rf {} \;  删除0字节文件
	$ find / -name *.jpg -exec wc -c {} \;|awk '{print $1}'|awk '{a+=$1}END{print a}'  统计所有jpg的文件的大小
	$ find ./ccc/* -type d -exec mkdir -p ./ddd/{} \; 复制目录结构方法1
	$ find ./ -type d -exec mkdir -p ./ddd/{} \; 复制目录结构方法2

#####Grep
在 Linux 上你可找到 grep, egrep, fgrep 这几个程序, 其差异大致如下: 
* **grep**: 传统的 grep 程序, 在没有参数的情况下, 只输出符合 RE 字符串之句子. 常见参数如下: 
-v: 逆反模示, 只输出"不含" RE 字符串之句子. 
-r: 递归模式, 可同时处理所有层级子目录里的文件. 
-q: 静默模式, 不输出任何结果(stderr 除外. 常用以获取 return value, 符合为 true, 否则为 false .) 
-i 不区分大小写（只适用于单字符）。
-w: 整词比对, 类似 \<word\> . 
-n: 同时输出行号. (grep -n "48" data.f) 
-c: 只输出符合比对的行数. 
-l: 只输出符合比对的文件名称. 
-o: 只输出符合 RE 的字符串. (gnu 新版独有, 不见得所有版本都支持.) 
-E: 切换为 egrep . 
-h 查询多文件时不显示文件名。
-s 不显示不存在或无匹配文本的错误信息。同`> /dev/null 2>&1`
-B n：显示grep行以及上边的n行 `dmidecode -t system|grep -B 4 "Serial Number"`

* **egrep**: 为 grep 的扩充版本, 改良了许多传统 grep 不能或不便的操作. 比方说: 
    - grep 之下不支持 ? 与 + 这两种 modifier, 但 egrep 则可. 
    - grep 不支持 a|b 或 (abc|xyz) 这类"或一"比对, 但 egrep 则可. 
    - grep 在处理 {n,m} 时, 需用 \{ 与 \} 处理, 但 egrep 则不需. 

* **fgrep**: 不作 RE 处理, 表达式仅作一般字符串处理, 所有 meta 均失去功能

--------------

#####tar
将整个/home/www/images 目录下的文件全部打包为 /home/www/images.tar
	
	$ tar -cvf /home/www/images.tar /home/www/images ← 仅打包不压缩
	$ tar -zcvf /home/www/images.tar.gz /home/www/images ← 打包后gzip压缩
	$ tar jfvx Python-2.7.tar.bz2 ← 解压bz2
	$ tar -zxvf /home/images.tar.gz  ←解压

#####cut
http://www.cnblogs.com/dong008259/archive/2011/12/09/2282679.html
cut  [-bn] [file] 或 cut [-c] [file]  或  cut [-df] [file]
主要参数
-b ：以字节为单位进行分割。这些字节位置将忽略多字节字符边界，除非也指定了 -n 标志。
-c ：以字符为单位进行分割。
-d ：自定义分隔符，默认为制表符。
-f  ：与-d一起使用，指定显示哪个区域。
-n ：取消分割多字节字符。仅和 -b 标志一起使用。如果字符的最后一个字节落在由 -b 标志的 List 参数指示的<br />范围之内，该字符将被写出；否则，该字符将被排除。

cut命令主要是接受三个定位方法：
第一，字节（bytes），用选项-b
第二，字符（characters），用选项-c
第三，域（fields），用选项-f

$ who|cut -b 3
c
c
c
每一行的第3个字节

$ cat /etc/passwd|head -n 5|cut -d : -f 1
root
bin
daemon
adm
lp

$ cat /etc/passwd|head -n 20|cut -d : -f 1,3-5
以:分割第1，3，4，5列

#####内存计算
>$ free -m
total used free shared buffers cached
Mem: 2516 1450 1066 0 99 794
-/+ buffers/cache: 556 1959
Swap: 4692 0 4692
free mem: used – buffers – cached = 1450 – 99 – 794 = 557

#####踢人
    pkill -kill -t tty
    tty　所踢用户的TTY

#####shift用法
```shell
shift可以用来向左移动位置参数。
Shell的名字 $0
第一个参数 $1
第二个参数 $2
第n个参数 $n
所有参数 $@ 或 $*
参数个数 $#

shift默认是shift 1
以下边为例：
cat shift.sh
#----------------------------输出文字-开始----------------------------
#!/bin/bash
until [ -z "$1" ]  # Until all parameters used up
do
  echo "$@ "
  shift
done
#----------------------------输出文字-结束----------------------------

sh shift.sh 1 2 3 4 5 6 7 8 9
#----------------------------输出文字-开始----------------------------
1 2 3 4 5 6 7 8 9 
2 3 4 5 6 7 8 9 
3 4 5 6 7 8 9 
4 5 6 7 8 9 
5 6 7 8 9 
6 7 8 9 
7 8 9 
8 9 
9 
#----------------------------输出文字-结束----------------------------
```
#####使用 sed 來移除整列都是空白(沒有資料)的行
```shell
sed '/^$/d' 註: sed '/\\n/d' 沒有用. XD
  常使用在移除註解時, ex: (移除開頭是 # 的列) cat xxx.conf | grep -v '^#' | sed '/^\\s*$/d'
  Handy one-liners for SED  - SED 常用命令, 一行語法、範例全集, 若 SED 遇到問題, 建議都可於此篇找找答案.
  Shell 設計入門 - Sed
-----------------找出每行开头是 #091112的-----------------
  -rw-rw---- 1 mysql mysql 104862665 2009-11-13 01:20 mysql-bin.008062
  -rw-rw---- 1 mysql mysql 104857981 2009-11-13 02:22 mysql-bin.008063
  -rw-rw---- 1 mysql mysql 104860932 2009-11-13 03:08 mysql-bin.008064
  -rw-rw---- 1 mysql mysql 104877508 2009-11-13 03:13 mysql-bin.008065
  -rw-rw---- 1 mysql mysql 104858064 2009-11-13 03:20 mysql-bin.008066
  -rw-rw---- 1 mysql mysql 104858078 2009-11-13 06:22 mysql-bin.008067
  -rw-rw---- 1 mysql mysql   9952231 2009-11-13 06:25 mysql-bin.008068
  -rw-rw---- 1 mysql mysql 104857825 2009-11-13 10:20 mysql-bin.008069
  -rw-rw---- 1 mysql mysql 104858624 2009-11-13 12:35 mysql-bin.008070
  -rw-rw---- 1 mysql mysql 104857886 2009-11-13 15:23 mysql-bin.008071
  -rw-rw---- 1 mysql mysql 104857727 2009-11-13 18:22 mysql-bin.008072
  -rw-rw---- 1 mysql mysql 104857901 2009-11-13 21:21 mysql-bin.008073
  $ sudo mysqlbinlog /data/ETPASS/mysql-bin.008062 \u3e00 /tmp/mysql-bin.2009-11-16
  $ sudo mysqlbinlog /data/ETPASS/mysql-bin.008063 \u3e00\u3e00 /tmp/mysql-bin.2009-11-16
  
  $ awk '{if($1=="#091112") print $0}' /tmp/mysql-bin.2009-11-16 \u3e00 /tmp/mysql-bin.2009-11-16.awk
  $ awk '{if($1=="#091113") print $0}' /tmp/mysql-bin.2009-11-16 \u3e00\u3e00 /tmp/mysql-bin.2009-11-16.awk
  --python 找出每行开头是 #091112的\u0cff把这一行保存
  $ awk '{print $2}' /tmp/mysql-bin.2009-11-16.awk \u3e00 /tmp/mysql-bin.2009-11-16.awk.$2
```

#####DD
  dd命令是不是就是要比文件系统的copy慢?
  $ dd if=ocr of=/dev/raw/raw1
  256977+0 records in
  256977+0 records out
  131572224 bytes (132 MB) copied, 297.253 seconds, 443 kB/s
  
  加上参数bs=10m 就快了很多倍
  附上dd 的参数
  2.参数
  1. if=文件名\u1aff输入文件名\u0cff缺省为标准输入。即指定源文件。\u3c00 if=input file \u3e00 　
  2. of=文件名\u1aff输出文件名\u0cff缺省为标准输出。即指定目的文件。\u3c00 of=output file \u3e00 　　
  3. ibs=bytes\u1aff一次读入bytes个字节\u0cff即指定一个块大小为bytes个字节。　　
    obs=bytes\u1aff一次输出bytes个字节\u0cff即指定一个块大小为bytes个字节
  bs=bytes\u1aff同时设置读入/输出的块大小为bytes个字节
  4. cbs=bytes\u1aff一次转换bytes个字节\u0cff即指定转换缓冲区大小。　　
  5. skip=blocks\u1aff从输入文件开头跳过blocks个块后再开始复制。　　
  6. seek=blocks\u1aff从输出文件开头跳过blocks个块后再开始复制。　　 
  注意\u1aff通常只用当输出文件是磁盘或磁带时才有效\u0cff即备份到磁盘或磁带时才有效。　　
  7. count=blocks\u1aff仅拷贝blocks个块\u0cff块大小等于ibs指定的字节数。　　
  8. conv=conversion\u1aff用指定的参数转换文件。　　 
  ascii\u1aff转换ebcdic为ascii 　　 
  ebcdic\u1aff转换ascii为ebcdic 　　 
  ibm\u1aff转换ascii为alternate ebcdic 　　 
  block\u1aff把每一行转换为长度为cbs\u0cff不足部分用空格填充　　 
  unblock\u1aff使每一行的长度都为cbs\u0cff不足部分用空格填充　　 
  lcase\u1aff把大写字符转换为小写字符　　 
  ucase\u1aff把小写字符转换为大写字符　　 
  swab\u1aff交换输入的每对字节　　 
  noerror\u1aff出错时不停止　　 
  notrunc\u1aff不截短输出文件　　 
  sync\u1aff将每个输入块填充到ibs个字节\u0cff不足部分用空\u08ffNUL\u09ff字符补齐
  
#####记录用户的操作

有时候我们需要记录Linux用户的操作记录用于审计\u0cff因此就要避免用户可以自行清除操作日志\u0cff一个简单的方式是使用script功能。
  首先在用户的profile文件中开启记录功能\u1aff
  [banping@linux ~]$ cd /home/banping/
  [banping@linux ~]$ vi .bash_profile
  # write log
  exec /usr/bin/script -a -f -q /tmp/test/script-`date +%Y%m%d%k%M`.lst
  
  这行脚本的意思是在/tmp/test目录下以时间为文件名来记录操作信息\u0cff由于是写在了.bash_profile文件中\u0cff用户登入到Linux系统的时候就会触发执行。
  然后我们在/tmp下建立test目录存放操作日志信息即可\u1aff
  
  [banping@linux tmp]# mkdir test
  这样就实现了记录的功能\u0cff而要防止用户自行修改\u0cff我们可以设置这些文件只能被附加\u0cff不能被修改或删除\u1aff
  
  [root@linux banping]# chattr +a .bash_profile
  [root@linux tmp]# chattr +a -R test
  
  这样登录用户就无法修改这些信息了\u0cff以下是一个简单的测试\u1aff
  [root@tomcat tmp]# cd test
  [root@tomcat test]# touch 1.txt
  [root@tomcat test]# rm 1.txt
  rm: remove regular empty file '1.txt'? y
  rm: cannot remove '1.txt': Operation not permitted
  [root@tomcat test]# cd ..
  [root@tomcat tmp]# chattr -a -R test
  [root@tomcat tmp]# cd test
  [root@tomcat test]# rm 1.txt
  rm: remove regular empty file '1.txt'? y


摘自《最牛B的 Linux Shell 命令 系列连载》(http://www.isspy.com/most_useful_linux_commands_4/)

大括号在bash里面是一个排列的意义，可以试试这个：
     $ echo {a,b,c}{a,b,c}{a,b,c}
将输出三个集合的全排列:
aaa aab aac aba abb abc aca acb acc
baa bab bac bba bbb bbc bca bcb bcc
caa cab cac cba cbb cbc cca ccb ccc

#####清空或创建一个文件
     $ file.txt
在shell里面是标准输出重定向符，即把（前部个命令的）命令行输出转往一个文件内，但这里没有“前部命令”，输出为空，于是就覆盖（或创建）成一个空文件了。

有些脚本的写法是:>file.txt，因为:是bash默认存在的空函数。

单纯创建文件也可以用$touch file.txt，touch本来是用作修改文件的时间戳，但如果文件不存在，就自动创建了。

#####在午夜的时候执行某命令
     $ echo cmd | at midnight
说的就是at这个组件，通常跟cron相提并论，不过at主要用于定时一次性任务，而cron定时周期性任务。
at的参数比较人性化，跟英语语法一样，可以tomorrow, next week之类的，详细的查看手册man at。

#####用diff对比远程文件跟本地文件
     $ ssh user@host cat /path/to/remotefile | diff /path/to/localfile -
    


更友好的显示当前挂载的文件系统
$ mount | column -t
这条命令适用于任何文件系统，column 用于把输出结果进行列表格式化操作，这里最主要的目的是让大家熟悉一下 columnt 的用法。

下面是单单使用 mount 命令的结果：
$ mount
/dev/root on / type ext3 (rw)
/proc on /proc type proc (rw)
/dev/mapper/lvmraid-home on /home type ext3 (rw,noatime)
而加了 column -t 命令后就成为这样了：

$ mount | column -t
/dev/root on / type ext3 (rw)
/proc on /proc type proc (rw)
/dev/mapper/lvmraid-home on /home type ext3 (rw,noatime)
另外你可加上列名称来改善输出结果

$ (echo "DEVICE - PATH - TYPE FLAGS" && mount) | column -t
DEVICE                    -   PATH   -     TYPE   FLAGS
/dev/root                 on  /      type  ext3   (rw)
/proc                     on  /proc  type  proc   (rw)
/dev/mapper/lvmraid-home  on  /home  type  ext3   (rw,noatime)
列2和列4并不是很友好，我们可以用 awk 来再处理一下

$ (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4="";1') | column -t
DEVICE                    PATH   TYPE   FLAGS
/dev/root                 /      ext3   (rw)
/proc                     /proc  proc   (rw)
/dev/mapper/lvmraid-home  /home  ext3   (rw,noatime)
最后我们可以设置一个别名，为 nicemount

$ nicemount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4="";1') | column -t; }

试一下

$ nicemount
DEVICE                    PATH   TYPE   FLAGS
/dev/root                 /      ext3   (rw)
/proc                     /proc  proc   (rw)
/dev/mapper/lvmraid-home  /home  ext3   (rw,noatime)

。

#####实时某个目录下查看最新改动过的文件
$ watch -d -n 1 'df; ls -FlAt /path'
watch 是实时监控工具，-d 参数会高亮显示变化的区域，-n 1 参数表示刷新间隔为 1 秒。
df; ls -FlAt /path 运行了两条命令，df 是输出磁盘使用情况，ls -FlAt 则列出 /path 下面的所有文件。
ls -FlAt 的参数详解：
-F 在文件后面加一个文件符号表示文件类型，共有 /=>@| 这几种类型， 表示可执行文件，/ 表示目录，= 表示接口( sockets) ，> 表示门， @ 表示符号链接， | 表示管道。
-l 以列表方式显示
-A 显示 . 和 ..
-t 根据时间排序文件

#####用 Wget 的递归方式下载整个网站
$ wget --random-wait -r -p -e robots=off -U Mozilla www.example.com
参数解释：
–random-wait 等待 0.5 到 1.5 秒的时间来进行下一次请求
-r 开启递归检索
-e robots=off 忽略 robots.txt
-U Mozilla 设置 User-Agent 头为 Mozilla

其它一些有用的参数：

–limit-rate=20K 限制下载速度为 20K
-o logfile.txt 记录下载日志
-l 0 删除深度（默认为5）
-wait=1h 每下载一个文件后等待1小时


#####简易计时器
     $ time read
运行命令开始算起，到结束时按一下Enter，就显示出整个过程的时间，精确到ms级别。

time是用来计算一个进程在运行到结束过程耗费多少时间的程序，它的输出通常有三项：
$ time ls /opt
...
real    0m0.008s
user    0m0.003s
sys     0m0.007s
real指整个程序对真实世界而言运行所需时间，user指程序在用户空间运行的时间，sys指程序对系统调用锁占用时间。

read本来是一个读取用户输入的命令，常见用法是read LINE，用户输入并回车后，键入的内容就被保存到$LINE变量内，但在键入回车前，这个命令是一直阻塞的。

可见time read这命令灵活地利用了操作系统的阻塞。用这个命令来测试一壶水多久煮滚应该是不错的。

#####远程关掉一台Windows机器
	$ net rpc shutdown -I IP_ADDRESS -U username%password
Windows平台上的net命令是比较强大的，因为其后台是一个RPC类的系统服务，大家应该看过win下用net use \\ip\ipc$ *这样一个命令建立IPC空连接，入侵主机的事情。

Linux下的net命令是samba组件的程序，通常包含在smbclient内，可以跟windows主机的文件、打印机共享等服务进行通讯，但是也支持rpc命令。

上述命令就是在远程Windows主机上执行了shutdown命令。当然这不一定成功，关系到win主机上面的安全设置。net命令能够控制到win主机就是了。

#####利用中间管道嵌套使用SSH
	$ ssh -t host_A ssh host_B
如果目标机器host_B处于比较复杂的网络环境，本机无法直接访问，但另外一台host_A能够访问到host_B，而且也能被本机访问到，那上述命令就解决了方便登录host_B的问题。

#####但理论上这个过程是可以无限嵌套的，比如：
	$ ssh -t host1 ssh -t host2 ssh -t host3 ssh -t host4 ...
嗯那神马FBI CIA的，有本事来捉我吧～

#####我想知道一台服务器什么时候重启完
系统管理员最常做的事情是重启系统。但是服务器的重启过程往往得花上好几分钟，什么你的服务器4个scsi卡？16个硬盘？系统是Redhat？还完全安装所有组件？好吧，它重启的时间都够你吃顿饭了，所以我很想知道它什么时候回来。

ping命令有个audible ping参数，-a，当它终于ping通你的服务器时会让小喇叭叫起来。

	$ ping -a IP

#####检查Gmail新邮件	
	$ curl -u you@gmail.com --silent "https://mail.google.com/mail/feed/atom" | perl -ne \' print "Subject: $1 " if /<title>(.+?)<\/title>/ && $title++;
    $ print "(from $1)\n" if /<email>(.+?)<\/email>/; '

#####linux清空文件方法
<pre>
echo "" > test.txt（文件大小被截为1字节）
> test.txt（文件大小被截为0字节）
cat /dev/null > test.txt（文件大小被截为0字节）
</pre>

##### sendmail
	$ apt-get install sendemail libio-socket-ssl-perl libnet-ssleay-perl

	$ sendemail -s smtp.gmail.com -f luexiaoyw@gmail.com -t xuexiaodong79@gmail.com -u hello -m "A hello from Christans to buddhists via gmail" -xu luexiaoyw -xp pw1234567! -o tls=auto

#####更改Linux启动时用图形界面还是字符界面

cd /etc
vi inittab

	将id:5:initdefault: 其中5表示默认图形界面
	改id:3: initdefault: 3表示字符界面

#####禁止在后台使用CTRL-ALT-DELETE重起机器
<pre>
cd /etc/inittab
vi inittab 在文件找到下面一行
	# Trap CTRL-ALT-DELETE
	ca::ctrlaltdel:/sbin/shutdown -t3 -r now （注释掉这一行）
</pre>

######实现RedHat非正常关机的自动磁盘修复

	先登录到服务器，然后在/etc/sysconfig里增加一个文件autofsck,内容如下：
	AUTOFSCK_DEF_CHECK=yes
	PROMPT=yes

###系统
    # uname -a               # 查看内核/操作系统/CPU信息
    # head -n 1 /etc/issue   # 查看操作系统版本
    # cat /proc/cpuinfo      # 查看CPU信息
    # hostname               # 查看计算机名
    # lspci -tv              # 列出所有PCI设备
    # lsusb -tv              # 列出所有USB设备
    # lsmod                  # 列出加载的内核模块
    # env                    # 查看环境变量

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