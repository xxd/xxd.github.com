## Ubuntu12.04: MySQL Redis MongoDB ROR Nginx
* MySQL Community Server 5.5.15
* Redis 2.4.2
* rvm+Ruby 1.9.2-p290
* Rails 3.1：Unicorn Mongoid capistrano
* Nginx1.0.6
* MongoDB1.8.3

####Basic Packages
--------------
```ruby
$ lsb_release -a 
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install emacs curl git-core build-essential zlib1g-dev libssl-dev  libpcre3-dev libcurl4-openssl-dev libssl-dev libopenssl-ruby libmysqld-dev openssl libssl-dev imagemagick libmagickwand-dev libreadline6-dev
```
以下几个包已经不能使用

     $ sudo apt-get install libopenssl-ruby1.9 ncurses-dev
     $ rvm requirements
     然后安装
     
####Ubuntu配置
----------
语言环境配置

	修改/etc/default/locale
	LANG="zh_CN.UTF-8"  
	LANGUAGE="zh_CN:zh"  
	
	错误：
	perl: warning: Setting locale failed.
	perl: warning: Please check that your locale settings:
	LANGUAGE = "zh_CN:zh",
	LC_ALL = (unset),
	LC_CTYPE = "zh_CN.UTF-8",
	LANG = "zh_CN.UTF-8"
    are supported and installed on your system.
	perl: warning: Falling back to the standard locale ("C").

	解决方法：
	$ sudo locale-gen en_US en_US.UTF-8 zh_CN zh_CN.UTF-8
	Generating locales...
	en_US.ISO-8859-1... done
	en_US.UTF-8... up-to-date
	zh_CN.GB2312... done
	zh_CN.UTF-8... done
	Generation complete.
	
	$ sudo dpkg-reconfigure locales
	
时区配置

	修改/etc/default/rcS 文件，将 UTC=yes 改为 UTC=no
	如果不放心就把/etc/localtime链接到/usr/share/zoneinfo/Asia/Shanghai。
	$ ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

Mysql时区设置,保持Mysql时区和系统时区一致

	#可以通过修改my.cnf,在 [mysqld] 之下加
	default-time-zone = '+8:00'
	#重启Mysql,显示时区设置
	show variables like '%time_zone%';
	
建立用户

	$ groupadd yw
	$ mkdir /home/xuexd
	$ useradd -d /home/xuexd xuexd
	$ passwd xuexd
	$ cd /home/xuexd
	$ chown -R xuexd .
	$ usermod -G yw xuexd
	$ usermod -s /bin/bash xuexd
	$ visudo
     Defaults     env_reset
     # Host alias specification
     Host_Alias LC = li386-141

     # User alias specification
     # Cmnd alias specification
     Cmnd_Alias RM = /bin/rm

     # User privilege specification
     root     ALL=(ALL) ALL
     %yw     LC = ALL,!RM

     Defaults@LC log_year, logfile=/var/log/sudo.log

建立deploy用户

```ruby
USERNAME="deploy_user"
mkdir /prod
mkdir -p /home/$USERNAME
useradd -d /home/$USERNAME $USERNAME
usermod -G www-data $USERNAME
usermod -s /bin/bash $USERNAME
chown $USERNAME:$USERNAME -R /home/$USERNAME
chown $USERNAME:$USERNAME -R /prod
chmod 775 -R /prod
passwd $USERNAME
visudo
```
