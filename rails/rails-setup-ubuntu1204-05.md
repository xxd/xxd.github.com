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

####RVM & Ruby 1.9.3 & Ruby 2.0.0 https://ruby-china.org/wiki/rvm-guide
-----------------
	$ su -l root
	$ curl -L https://get.rvm.io | bash -s stable --ruby

	但是如果是部署使用deploy_user用户安装，然后使用source使配置生效
	deploy_user@ubuntu:~$ curl -L https://get.rvm.io | bash -s stable --ruby
	deploy_user@ubuntu:/prod/dev$ source /home/deploy_user/.rvm/scripts/rvm
	deploy_user@ubuntu:/prod/dev$ gem install rails
	
#####用RVM升级Ruby到1.9.3
	$ rvm get latest
	$ rvm reload
	$ rvm get stable
	$ rvm install 1.9.3
	$ rvm use 1.9.3 --default
	
	# 如果发现在执行bundle exec rails c时报错:
	# cannot load such file — readline (LoadError)
	 
	sudo apt-get install libreadline6-dev
	cd ext/readline
	ruby extconf.rb
	make
	sudo make install
	
#####用RVM升级Ruby到2.0.0，并且升级Rails
	$ gem install rails --version '~> 3.2.0'
	$ rvm pkg install openssl
	$ rvm get head
	$ rvm install 2.0.0
	$ rvm use ruby-2.0.0-p0 --default
	$ gem update rails 
	$ gem update --system
	$ gem update rails bundler
	
	$ ruby -v
	ruby 2.0.0p0 (2013-02-24 revision 39474) [x86_64-darwin12.2.0]
	$ gem -v
	2.0.0

	xuexd@ubuntu:~$ gem install bundler rails
	xuexd@ubuntu:~$ gem -v
	2.0.0.rc.2
		

####Rails 3.1
---------
    $ mkdir dev     
    $ git clone git@github.com:vvdpzz/thunderbolt.git
    $ emacs Gemfile
    注释掉 #SystemTimer
    Rails '3.1.0'
    Rake '0.9.2'
    gem 'execjs'
    gem 'therubyracer'
    上边两个Gem解决:`autodetect': Could not find a JavaScript runtime
    如果解决不了：
    $ sudo apt-get install nodejs

Pruction部署配置

     $ rm Gemfile.lock
     $ gem install rails
     $ bundle install
     $ rake db:create RAILS_ENV=production
     $ rake db:migrate RAILS_ENV=production
     $ rake db:seed RAILS_ENV=production
     $ emacs config/environments/production.rb

     预编译active_admin的js,css文件
     	config.assets.precompile += %w( active_admin.css active_admin.js ) 

     预编译其他js,css文件,修改以下两个参数为true
     # Disable Rails's static asset server (Apache or nginx will already do this)
     	config.serve_static_assets = true

     # Compress JavaScripts and CSS
     	config.assets.compress = true

     # Don't fallback to assets pipeline if a precompiled asset is missed
     	config.assets.compile = true
     # config.assets.js_compressor = :yui # 这个导致Muo_Rails不能运行所以注释掉了

[关于文件压缩](http://guides.rubyonrails.org/asset_pipeline.html#javascript-compression)

时区改为北京

	修改config/application.rb，增加下边一行
	config.active_record.default_timezone = :local

解决方法:in `require': no such file to load -- openssl

     $ sudo apt-get install libopenssl-ruby1.9 libssl-dev
     $ cd ~/ruby-1.9.2-p290/ext/openssl
     $ ruby extconf.rb && make && sudo make install

解决方法:An error occured while installing rmagick (2.13.1), and Bundler cannot continue.
 ** [out :: 74.207.224.81] Make sure that `gem install rmagick -v '2.13.1'` succeeds before bundling.  
 
	$ apt-get install imagemagick libmagickwand-dev

解决方法:ndefined method `exitstatus' for nil:NilClass
(in /prod/dev/magic/releases/20111220083725/app/assets/javascripts/active_admin.js)  

	$ apt-get install openjdk-6-jre-headless

Rakefile

	 $ emacs Rakefile
	 添加rake命令用来启动压缩 (这部分将会合并到capistrano)
        namespace :custom do 
          desc "Restart unicorn & rails services"
          task :restarts do
            puts "Refresh the assets..."
            %x[rake assets:clean && rake assets:precompile]
            puts "Restarting unicorn..."
            %x[/etc/init.d/unicorn_init restart]
            puts "Restarting nginx..."
            %x[sudo /etc/init.d/nginx restart]
          end
          
          desc "Stop unicorn & rails services"
          task :stops do
            puts "Stop unicorn..."
            %x[/etc/init.d/unicorn_init stop]
            puts "Stop nginx..."
            %x[sudo /etc/init.d/nginx stop]
          end
        end
     $ ruby extconf.rb
     $ sudo make && sudo make install
     重新 $ sudo gem install rails
     $ PATH=/usr/local/ruby/bin:$PATH
     $ export PATH

####capistrano
----------
	$ gem install capistrano
	$ capify .
编辑配置文件

	$ emacs config/deploy.rb 
	参考 deploy.conf
在服务器端建立部署用户

	$ sudo groupadd lxdeploy
	$ sudo useradd -g lxdeploy lxdeploy
	$ sudo passwd lxdeploy
	(部署密码:见production分支的config/deploy.rb文件)
	$ sudo mdkir /prod  	#部署路径的顶级目录需要改变属主
	$ sudo chown -R lxdeploy:lxdeploy /prod  
本地：第一次运行

	$ cap deploy:setup
	报错：sh: sudo: command not found 
	解决:
	>vi  /etc/sudoers
	#Defaults    requiretty #将这行注释掉
	这个命令会在服务器上配置好相关的目录结构.然后再运行:
	$ cap deploy:check
本地：第一次部署用的命令是:

	$ cap deploy:cold
本地：以后部署都可以直接用:

	$ cap deploy
服务器端启动

	$ cap deploy:start
	$ env DEPLOY=PRODUCTION cap deploy:start
修改 nginx 配置:

	$ root  /prod/dev/magic/current/public/; 
	
####Unicorn
-------
    $ gem install unicorn
在网站里再创建一个unicorn配置文件

	$ emacs config/unicorn.rb
启动和停止

     $ /prod/dev/magic_admin/current# bundle exec unicorn_rails -c /prod/dev/magic_admin/current/config/unicorn.rb -E production -D
     $ pgrep -lf unicorn
     14088 unicorn master -c config/unicorn.rb -D                                     
     14135 unicorn worker[0] -c config/unicorn.rb -D                                  
     14139 unicorn worker[1] -c config/unicorn.rb -D
     $ killall unicorn
     如果不行就
     $ kill -9 14088
     
     $ _pid=cat tmp/pids/unicorn.pid; sudo kill -USR2 $_pid; sudo kill -QUIT $_pid; ps -ef | grep unicorn | grep master
设置unicorn启动脚本 
[unicorn.sh](init.d/unicorn.sh)

     自启动脚本@/etc/init.d/unicorn
     $ sudo chmod 755 /etc/init.d/unicorn
     $ sudo update-rc.d unicorn defaults
     $ /etc/init.d/unicorn start

配置文件(未使用)

     $ sudo mkdir /etc/unicorn
     $ sudo emacs /etc/unicorn/myproject.conf
     加入下边
     RAILS_ROOT=/prod/dev/thunderbolt
     RAILS_ENV=production

unicorn 无缝重启

	更新应用
	kill -USR2 `cat /prod/dev/magic_admin/current/tmp/pids/unicorn.pid`

	暂时停止旧的版本。测试更新应用没问题
	kill -WINCH cat ~/application/current/tmp/pids/unicorn.pid.oldbin

	如果新版本没问题，杀掉旧版本
	kill -QUIT cat `cat /prod/dev/magic_admin/current/tmp/pids/unicorn.pid`

	如果新版本有问题，恢复旧版本

	kill -HUP cat ~/application/current/tmp/pids/unicorn.pid.oldbin
	kill -QUIT cat ~/application/current/tmp/pids/unicorn.pid

unicorn 简化重启步骤

	kill -USR2 cat ~/application/current/tmp/pids/unicorn.pid
	kill -QUIT cat ~/application/current/tmp/pids/unicorn.pid·oldbin

####thin
----
	group :development do
	 gem 'thin'
	end

devlopment

	rails s 或者 thin start
production
	
	bundle exec rails server thin -p $PORT
	
####Nginx
-----
####pcre
     
     sudo wget http://sourceforge.net/projects/pcre/files/pcre/8.32/pcre-8.32.tar.gz/download > /usr/local/src/pcre-8.32.tar.gz

     $ tar xvzf pcre-8.32.tar.gz

以上链接有时被墙，使用下边方法

	$ sudo wget http://downloads.sourceforge.net/project/pcre/pcre/8.21/pcre-8.21.tar.bz2
	$ sudo tar jxvf pcre-8.21.tar.bz2

    $ cd pcre-8.20
    $ ./configure --prefix=/usr/local
    $ make && make install
[nginx-gridfs](https://github.com/mdirolf/nginx-gridfs)

     $ sudo git clone git://github.com/mdirolf/nginx-gridfs.git
     $ cd nginx-gridfs
     $ sudo git submodule init
     $ sudo git submodule update

####安装Nginx

	 $ sudo wget http://nginx.org/download/nginx-1.2.6.tar.gz > /usr/local/src/nginx-1.2.6.tar.gz
     $ sudo tar xvzf nginx-1.2.6.tar.gz
     $ cd nginx-1.2.6
     $ sudo ./configure --prefix=/opt/nginx --with-http_realip_module --with-pcre=../pcre-8.32 --with-http_stub_status_module --with-http_gzip_static_module --with-http_ssl_module --add-module=/usr/local/src/nginx-gridfs

####nginx-gridfs 编译问题

* 关闭-Werror选项

  	需要修改`objs/Makefile`文件,删除CFLAGS的-Werror选项
	sudo emacs objs/Makefile
	sudo make && sudo make install
	
* bison_oid变量未定义
  修改`nginx-gridfs/ngx_http_gridfs_module.c`引用的头文件  
		#include "mongo-c-driver/src/mongo.h"  
		#include "mongo-c-driver/src/bson.h"  
		#include "mongo-c-driver/src/gridfs.h" 
* 在定义nginx-gridfs模块路径时,不要使用相对路径，否则会找不到config文件,不能包含  
  (~|..)符号
* Nginx无法启动:  
  error while loading shared libraries: libpcre.so.0: cannot open shared object file: No such file or directory   
  在/lib中创建一个symbol link到/usr/local/pcre/lib/libpcre.so.0

	ln -s  /usr/local/pcre/lib/libpcre.so.0  /lib

#####Nginx用户

In nginx.conf you may have stumbled upon this line:

	user nobody nogroup; # for systems with a "nogroup"

While this works, it’s generally adviced to run as a seperate user (which we have more control over than nobody) for security reasons and increased control. We’ll create an nginx user and a web group.

	$ sudo useradd -s /sbin/nologin -r nginx
	$ sudo groupadd web
	$ sudo usermod -a -G web nginx
Configure your static path in [nginx.conf](conf/nginx_origin_for_unicorn.conf) to /var/www, and change the owner of that directory to the web group:

	$ sudo mkdir /var/www
	$ sudo chgrp -R web /var/www # set /var/www owner group to "web"
	$ sudo chmod -R 775 /var/www # group write permission
Add yourself to the web group to be able to modify the contents of /var/www:

	$ sudo usermod -a -G web USERNAME

#####自动启动脚本[nginx.sh](init.d/nginx_init.sh)

     $ sudo chmod 755 /etc/init.d/nginx_init.sh
     $ sudo ln -s /etc/init.d/nginx_init.sh /etc/rc2.d/S99nginx
	启动
	 $ sudo /opt/nginx/sbin/nginx -c /opt/nginx/conf/nginx.conf
	停止
	 $ ps -ef | grep nginx #在进程列表里面找master进程，它的编号就是主进程号了。
	 $ kill -QUIT 主进程号 #从容停止Nginx：
	 $ kill -TERM 主进程号 #快速停止Nginx
	 $ pkill -9 nginx #强制停止Nginx

####MongoDB
-------
	64bit:
	$ sudo wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.2.2.tgz
	32bit:
	$ sudo wget http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.2.2.tgz

	以下以64bit为例
	sudo tar zxvf mongodb-linux-x86_64-2.2.2.tgz
	sudo mkdir /mongodb
	sudo cp -R mongodb-linux-x86_64-2.2.2/* /mongodb

创建mongodb:mongodb用户

	sudo groupadd mongodb
	sudo useradd -r -g mongodb mongodb
	sudo chown -R root:root /mongodb
	sudo mkdir -p /mongodb/data
	sudo chown -R mongodb:mongodb /mongodb/data
启动&客户端
启动脚本[mongodb_init.sh](init.d/mongodb_init.sh)

	sudo chmod +x /etc/init.d/mongodb_init.sh
	sudo update-rc.d mongodb_init.sh defaults  
	ls -l /etc/rc*.d |grep mongodb  
清除日志文件  

	$ sudo rm /tmp/mongodb.log  
	#或者
	$ sudo chown mongodb:mongodb /tmp/mongodb.log  

启动  

	$ sudo /etc/init.d/mongodb_init.sh start | stop | restart
	
手工启动：

	$ mongod --chuid=mongodb:mongodb --dbpath=/mongodb/data/ --logpath=/mongodb/data/MongoDB.log --logappend 

备份恢复

	$ mongodump -h 127.0.0.1:27017 -d magic_production -o /tmp
	$ mongorestore -h 127.0.0.1:27017 -d magic_production --directoryperdb /tmp --drop

Replica set配置
有三台服务器组成Replica set 

	Primary:li386-141
	Secondary: li386-117
	Arbiter: li386-159

每台上分别执行

	$ /mongodb/bin/mongod --dbpath /mongodb/data --noauth --logpath /tmp/mongodb.log --logappend --replSet lxset

进入Primary执行

	> rs.initiate()

	PRIMARY> rs.add("li386-117")

	PRIMARY> rs.addArb("li388-159:27017");
	{ "ok" : 1 }

分别进入另外两台服务器查看角色

	root@li388-117:/usr/local/mongodb-linux-i686-2.0.2/bin# ./mongo
	MongoDB shell version: 2.0.2
	connecting to: test
	SECONDARY> 

	root@li388-159:/usr/local/mongodb-linux-i686-2.0.2/bin# ./mongo
	MongoDB shell version: 2.0.2
	connecting to: test
	ARBITER> 
	
####Mongoid
-------
[官网](http://mongoid.org/)
[238-mongoid](http://railscasts.com/episodes/238-mongoid)
增加新Gem

	Gemfile
	gem "mongoid", "~> 2.2"
	gem "bson_ext", "~> 1.3"
	$ bundle install
生成配置文件

	$ rails g mongoid:config
修改 application.rb

	保持require 'rails/all'
	添加以下
	require "action_controller/railtie"
	require "action_mailer/railtie"
	require "active_resource/railtie"
	require "rails/test_unit/railtie"
	require "sprockets/railtie"
建立model千万不要使用references

	$ rails g model location user:不要用references location:string
生成migration出现`error  mongoid [not found]`,需要明确指定所使用的ORM

	$ rails g migration AddLockedToUsers -o active_record
	
####MySQL Community Server 5.5.15
-----------------------------
[官方文档](http://dev.mysql.com/doc/refman/5.6/en/installing-source-distribution.html)

安装之前使用cmake编译MySQL5.5.15

     $ wget http://www.cmake.org/files/v2.8/cmake-2.8.5.tar.gz
     $ tar -zxvf cmake-2.8.5.tar.gz
     $ cd  cmake-2.8.5
     $ ./configure
     $ sudo make && sudo make install
 
使用ncurses库编译安装MySQL

     $ wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz
     $ tar -zxvf ncurses-5.9.tar.gz
     $ cd ncurses-5.9
     $ ./configure
     $ sudo make && sudo make install
 
编译安装MySQL

     $ groupadd mysql
     $ useradd -r -g mysql mysql
 
     $ wget http://download.softagency.net/mysql/Downloads/MySQL-5.5/mysql-5.5.18.tar.gz
	#5.6
     $ wget http://download.softagency.net/mysql/Downloads/MySQL-5.6/mysql-5.6.3-m6.tar.gz
     $ tar -zxvf mysql-5.5.15.tar.gz
     $ cd mysql-5.5.15
     $ sudo cmake .
     也可定制
     $ sudo cmake -DCMAKE_INSTALL_PREFIX=/mysql -DMYSQL_UNIX_ADDR=/var/run/mysqld/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8,gbk -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_DATADIR=/mysql/data -DMYSQL_USER=mysql
     $ sudo make && sudo make install

配置MySQL

     $ cd /mysql
     $ chown -R mysql .
     $ chgrp -R mysql .
     $ ./scripts/mysql_install_db --basedir=/mysql --datadir=/mysql/data/ --user=mysql
     #mysql_install_db出现FATAL ERROR: Could not find mysqld错误解决，
     是因为安装时/etc/mysql文件夹下有个配置文件my.cnf，而在安装时运行了cp support-files/my-medium.cnf /etc/my.cnf，造成这个，解决方法:
	$ mv  /etc/mysql/my.cnf   /etc/mysql/my.cnf.bak
	$ cp  support-files/my-medium.cnf   /etc/my.cnf

     $ chown -R root .
     $ chown -R mysql:mysql data
     $ cp support-files/my-medium.cnf /etc/my.cnf
     $ bin/mysqld_safe --user=mysql &
     $ cp support-files/mysql.server /etc/init.d/mysql.server
 
设置开机启动mysql服务

     $ ln -s /etc/init.d/mysql.server /etc/rc2.d/S99mysql
     $ ln -s /etc/init.d/mysql.server /etc/rc0.d/K01mysql
     $ ln -s /etc/init.d/mysql.server /etc/rc3.d/S99mysql //redhat
 
将mysql安装目录加入环境变量，在/etc/profile文件末尾中加入以下命令

     $ PATH=/mysql/bin:$PATH
     $ export PATH

设置MySQL root

     $ mysql -u root
     mysql> set password for root@localhost =password('pw1234567!');
     mysql> flush privileges;
     mysql> quit;
     $ mysql -u root -p

####UTF-8编码方式
设置MYSQL的UTF-8编码方式(mysql-5.5.15):

     修改/etc/mysql/my.cnf添加如下内容
     [mysql]
     default-character-set = utf8
     
     [mysqld]
     default-character-set = utf8
     init_connect = 'SET NAMES utf8'

     [client]
     default-character-set = utf8
设置MYSQL的UTF-8编码方式(mysql-5.5.16)

	修改/etc/mysql/my.cnf添加如下内容
	[mysqld]
	character_set_server = utf8
	init_connect = 'SET NAMES utf8'
如果还有问题那么需要配置外部的SQL文件，直接写在SQL文件的最前面：

	SET NAMES ‘utf8′;
它相当于下面的三句指令：

	SET character_set_client = utf8;
	SET character_set_results = utf8;
	SET character_set_connection = utf8;

运行：`sudo /etc/init.d/mysql.server restart`
检查；`sudo netstat -tap | grep mysql`

检查MYSQL查看编码，数据库编码应该已经全改成utf8
MYSQL命令: `show variables like'character%'; `

####MySQL5.5 Deb包
----
	
	$ dpkg -i mysql-MVER-DVER-CPU.deb
	The Debian package installs files in the /opt/mysql/server-5.5 directory.
	
	mkdir /opt/mysql/server-5.5/data/
	mkdir /opt/mysql/server-5.5/log/
	mkdir /opt/mysql/server-5.5/errorlog/
	mkdir /opt/mysql/server-5.5/slowlog/
	
	chown mysql:mysql -R /opt/mysql/server-5.5/data/
	…
	…
	…
	
	sudo scripts/mysql_install_db --basedir=/opt/mysql/server-5.5/  --datadir=/opt/mysql/server-5.5/data/ --user=mysql

	$ cd /opt/mysql/server-5.5
	$ chown -R root .
	$ chown -R mysql:mysql data
	…
	…
	…
	$ cp support-files/my-medium.cnf /etc/my.cnf
	$ bin/mysqld_safe --user=mysql &
	$ cp support-files/mysql.server /etc/init.d/mysql.server
	$ sudo ln -s /etc/init.d/mysql.server /etc/rc2.d/S99mysql
	$ sudo ln -s /etc/init.d/mysql.server /etc/rc0.d/K01mysql
	

####mariadb 5.5.28a
--------------

安装mariadb和安装官方版本和percona的方法基本一致：
下载相关软件源码包

	wget http://downloads.mariadb.org/f/mariadb-5.5.28a/kvm-tarbake-jaunty-x86/mariadb-5.5.28a.tar.gz/from/http:/ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb
	sudo mv mariadb mariadb-5.5.28a.tar.gz
	wget http://www.cmake.org/files/v2.8/cmake-2.8.5.tar.gz

安装cmake，mysql-5.5后需要使用cmake配置

	sudo tar zxf cmake-2.8.5.tar.gz
	cd cmake-2.8.5
	sudo ./bootstrap
	sudo make
	sudo make install
	cd ..

配置编译器，提高性能

	sudo CFLAGS="-O3"
	sudo CXX=gcc
	sudo CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti"

mysql-5.1版本使用以下编译参数，5.5以前添加以下参数增加性能

	./configure –prefix=/usr/local/mysql –enable-assembler –with-mysqld-ldflags=-all-static

开始安装mariadb

	yum install ncurses-devel -y
	yum install libaio-devel -y
	
	sudo apt-get install libaio-dev
	sudo apt-get install ncurses-dev
	
	sudo useradd mysql
	sudo tar -zxvf mariadb-5.5.28a.tar.gz
	cd mariadb-5.5.28a
	sudo cmake . -LH|more //CMake下查看MySQL的编译配置

	sudo cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mariadb-5.5.28a -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1  -DENABLED_LOCAL_INFILE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci   -DWITH_DEBUG=0 -DBUILD_CONFIG=mysql_release -DFEATURE_SET=community -DWITH_EMBEDDED_SERVER=OFF

	sudo make -j 8      //-j指定用于编译的CPU核数，可以加快编译速度
	sudo make install
	sudo cp support-files/my-innodb-heavy-4G.cnf /etc/my.cnf	
	sudo /usr/local/mariadb-5.5.28a/scripts/mysql_install_db --basedir=/usr/local/mariadb-5.5.28a/  --datadir=/usr/local/mariadb-5.5.28a/data/ --user=mysql
	
	sudo /usr/local/mariadb-5.5.28a/bin/mysqld_safe --user=mysql &
	
	$ sudo mkdir /usr/share/mysql
	$ sudo cp /usr/local/mariadb-5.5.28a/share/english/errmsg.sys /usr/share/mysql/errmsg.sys
	$ sudo mkdir /var/lib/mysql/
	$ sudo touch /var/lib/mysql/dba.err
	$ sudo chown mysql:mysql /var/lib/mysql/dba.err

####Percona-Server-5.5.17
---
1、下载percona

	wget http://www.percona.com/redir/downloads/Percona-Server-5.5/Percona-Server-5.5.17-22.1/source/Percona-Server-5.5.17-rel22.1.tar.gz

2、下载cmake

	wget http://www.cmake.org/files/v2.8/cmake-2.8.5.tar.gz

3、安装cmake
<pre>
 tar zxf cmake-2.8.5.tar.gz
 cd cmake-2.8.5
 ./bootstrap
 make
 make install
 cd ..
</pre>
4、安装percona
<pre>
 yum install libaio-devel -y
 useradd mysql
 tar -zxvf Percona-Server-5.5.17-rel22.1.tar.gz
 cd Percona-Server-5.5.17-rel22.1
 cmake . -LH|more //CMake下查看MySQL的编译配置
 cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/perconamysql -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1  -DENABLED_LOCAL_INFILE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci   -DWITH_DEBUG=0 -DBUILD_CONFIG=mysql_release -DFEATURE_SET=community -DWITH_EMBEDDED_SERVER=OFF
 make && make install
 cp support-files/my-innodb-heavy-4G.cnf /etc/my.cnf
 /usr/local/perconamysql/scripts/mysql_install_db --basedir=/usr/local/perconamysql/  --datadir=/usr/local/perconamysql/data/ --user=mysql
 /usr/local/perconamysql/bin/mysqld_safe --user=mysql &
</pre>

5、修改rc.lcoal让数据库开机自动启动，修改.bash_profile添加mysql工具的环境变量
root@localhost ~]# cat /etc/rc.local
```ruby
	#!/bin/sh
	touch /var/lock/subsys/local
	/usr/local/perconamysql/bin/mysqld_safe --user=mysql &
```

[root@localhost ~]# cat .bash_profile

	# .bash_profile
	# Get the aliases and functions
	if [ -f ~/.bashrc ]; then
        . ~/.bashrc
	fi

	# User specific environment and startup programs

	PATH=$PATH:$HOME/bin:/usr/local/perconamysql/bin

	export PATH
	unset USERNAME
