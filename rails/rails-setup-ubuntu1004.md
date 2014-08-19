## Ubuntu10.04: MySQL Redis MongoDB ROR Nginx
* MySQL Community Server 5.5.15
* Redis 2.4.2
* rvm+Ruby 1.9.2-p290
* Rails 3.1 (Unicorn Mongoid capistrano)
* Nginx1.0.6
* MongoDB1.8.3

####Basic Packages
--------------
     $ sudo apt-get update
     $ sudo apt-get upgrade
     $ sudo apt-get install vim emacs curl git-core build-essential zlib1g-dev libssl-dev  libpcre3-dev libcurl4-openssl-dev libssl-dev libopenssl-ruby libmysqld-dev openssl libssl-dev imagemagick libmagickwand-dev  libreadline5-dev libopenssl-ruby1.9 ncurses-dev

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
 
将mysql安装目录加入环境变量，在/etc/profile文件末尾中加入以下命令

     $ PATH=/mysql/bin:$PATH
     $ export PATH

设置MySQL root

     $ mysql -u root
     mysql> set password for root@localhost =password('pw1234567!');
     mysql> flush privileges;
     mysql> quit;
     $ mysql -u root -p

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

运行：`sudo /etc/init.d/mysql.server restart`
检查；`sudo netstat -tap | grep mysql`

检查MYSQL查看编码
MYSQL命令: `show variables like'character%'; `

####Redis 2.4.4
-----------
     $ sudo wget http://redis.googlecode.com/files/redis-2.4.4.tar.gz
     $ sudo tar zxvf redis-2.4.4.tar.gz
     $ sudo make
     $ sudo apt-get install tcl8.5
     $ sudo make test
     Testing Redis version 2.4.4 (00000000)
     831 tests, 831 passed, 0 failed     

     修改redis.conf，修改
     daemonize yes
     logfile /tmp/redis.log
     dir /redis/data

添加redis用户

	 $ cp redis-server /usr/bin/
	 $ cp redis-cli /usr/bin/
     $ groupadd redis
     $ useradd -r -g redis redis 
修改权限

	 $ mkdir -p /redis/data
     $ chown -R root:root /redis
     $ chown -R redis:redis /redis/data
     $ 这里写了个Redis自动启动脚本 /etc/init.d/redis.sh
     $ chmod 755 /etc/init.d/redis.sh
     $ ln -s /etc/init.d/redis.sh /etc/rc2.d/S99redis
主从
	$ cp /etc/redis.conf /etc/redis_slave.conf
	$ emacs /etc/redis_slave.conf
		port 6380
		pidfile /var/run/redis_slave.pid
		logfile /tmp/redis_slave.log
		dir /redis/data_slave/
		dbfilename dump_slave.rdb
		slaveof 106.187.43.141 6379
		
	$ sudo scp redis_slave.conf root@202.85.221.32:/redis/redis_slave.conf
	$ /redis/bin/redis-server /redis/redis_slave.conf
	
	进入数据目录，查一下数据文件的散列：
	$ ls /redis/data_slave/
	temp-1330583768.14827.rdb
	同步完成后文件名自动变为dump_slave.rdb
	$ ls /redis/data_slave/
	dump_slave.rdb
	
####memcached
---------
<pre>
wget https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz
tar zxvf libevent-2.0.19-stable.tar.gz 
cd libevent-2.0.19-stable
./configure 
make
make install

wget http://memcached.googlecode.com/files/memcached-1.4.13.tar.gz
tar zxvf memcached-1.4.13.tar.gz 
cd memcached-1.4.13
./configure --prefix=/opt/memcached
make && ldconfig && make test
make install
  
root@gandalf:/opt/memcached# groupadd  memcached 
root@gandalf:/opt/memcached# useradd -r -g memcached  memcached
root@gandalf:/opt/memcached# touch /var/log/memcached.log && chown memcached:memcached /var/log/memcached.log 
root@gandalf:/opt/memcached# /opt/memcached/bin/memcached -u memcached -d -m 1024m -l 0.0.0.0 -p 11211   -v 2>>/var/log/memcached.log
root@gandalf:/opt/memcached# ps aux|grep mem
998       9252  0.0  0.0 126460  1112 ?        Ssl  11:42   0:00 /opt/memcached/bin/memcached -u memcached -d -m 1024m -l 0.0.0.0 -p 11211 -v
root      9259  0.0  0.0   8880   788 pts/1    S+   11:42   0:00 grep --color=auto mem
</pre>

####RVM & Ruby 1.9.3
-----------------
	$ su -l root
	$ curl -L https://get.rvm.io | bash -s stable --ruby
	
	
	升级到1.9.3
	$ rvm get latest
	$ rvm reload
	$ rvm get stable
	$ rvm install 1.9.3
	$ rvm use 1.9.3 --default
	
	# 如果发现在执行bundle exec rails c时报错:
	# cannot load such file — readline (LoadError)
	 
	sudo apt-get install libreadline5-dev
	cd ext/readline
	ruby extconf.rb
	make
	sudo make install

####Nginx
-----
#####pcre

     $sudo curl -OL h ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.20.tar.gz > /usr/local/src/pcre-8.20.tar.gz
     
     $ sudo mkdir -p /usr/local/src
     $ cd /usr/local/src
     $ tar xvzf pcre-8.20.tar.gz

以上链接有时被墙，使用下边方法

	$ sudo wget http://downloads.sourceforge.net/project/pcre/pcre/8.21/pcre-8.21.tar.bz2
	$ sudo tar jxvf pcre-8.21.tar.bz2

    $ cd pcre-8.20
    $ sudo ./configure --prefix=/usr/local
    $ sudo make && sudo make install
[nginx-gridfs](https://github.com/mdirolf/nginx-gridfs)

     $ git clone git://github.com/mdirolf/nginx-gridfs.git
     $ cd nginx-gridfs
     $ git submodule init
     $ git submodule update

#####Nginx

	 $ sudo wget http://nginx.org/download/nginx-1.0.6.tar.gz > /usr/local/src/nginx-1.0.6.tar.gz
     $ tar xvzf nginx-1.0.6.tar.gz
     $ cd nginx-1.0.6
     $ ./configure --prefix=/opt/nginx --with-http_realip_module --with-http_stub_status_module  --with-http_gzip_static_module --with-http_ssl_module --add-module=../nginx-gridfs
     $ sudo make && sudo make install
自动启动脚本[nginx.sh](init.d/nginx.sh)

     $ chmod 755 /etc/init.d/nginx.sh
     $ ln -s /etc/init.d/nginx.sh /etc/rc2.d/S99nginx
	启动
	 $ nginx -c /usr/nginx/conf/nginx.conf
	停止
	 $ ps -ef | grep nginx #在进程列表里面找master进程，它的编号就是主进程号了。
	 $ kill -QUIT 主进程号 #从容停止Nginx：
	 $ kill -TERM 主进程号 #快速停止Nginx
	 $ pkill -9 nginx #强制停止Nginx

#####nginx-gridfs 编译问题

* 关闭-Werror选项
  执行configure之后，编辑objs/Makefile文件,删除CFLAGS的-Werror选项  
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

####MongoDB
-------
	64bit:
	$ wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.0.1.tgz
	32bit:
	$ wget http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.0.2.tgz

	以下以64bit为例
	$ tar zxvf mongodb-linux-x86_64-2.0.1.tgz
	$ mkdir /mongodb
	$ cp -R mongodb-linux-x86_64-2.0.1/* /mongodb
	#创建mongodb:mongodb用户
	$ groupadd mongodb
	$ useradd -r -g mongodb mongodb
	$ chown -R root:root /mongodb
	$ mkdir -p /mongodb/data
	$ chown -R mongodb:mongodb /mongodb/data
		
启动&客户端
启动脚本[mongodb.sh](init.d/mongodb.sh)

	$ chmod +x /etc/init.d/mongodb.sh
	$ update-rc.d mongodb.sh defaults  
	$ ls -l /etc/rc*.d |grep mongodb  
清除日志文件  

	$ sudo rm /tmp/mongodb.log  
	#或者
	$ sudo chown mongodb:mongodb /tmp/mongodb.log  

启动  

	$ /etc/init.d/mongodb.sh start | stop | restart
	
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

#####Rails 3.1
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
  		config.assets.js_compressor = :yui

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

#####Unicorn
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
	
#####capistrano
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
	
#####Mongoid
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

#####Xen-Ubuntu-server
-----------------
  	#安装ython-software-properties
	$ sudo apt-get install python-software-properties
	#添加ppa源
	$ sudo add-apt-repository ppa:ukplc-team/xen-stable
    $ Sudo apt-get update
	$ sudo apt-get install ubuntu-xen-server

#####Recommendify
------------
OS X

	brew install hiredis
		
Linux:(**采用源码安装**)

	git clone https://github.com/antirez/hiredis.git && cd hiredis && make && sudo make install && sudo ldconfig

#####rmagick
-------
出现错误:(OS x) 

	ld: library not found for -lgomp
解决方案:[Mac Rmagick wont install with Xcode 4.2](http://stackoverflow.com/questions/7961091/mac-rmagick-wont-install-with-xcode-4-2)

#####Munin
------
* 在监控服务器上安装Munin Master:
	
		apt-get install munin
* 在监控节点安装Munin-node
	
		apt-get install  munin-node
* 根据不同服务器上的应用，安装Munin的redis、mysql、unicorn、nginx等的监控插件

		# Perl类库
   		$ sudo cpan
   		> install Redis
   		> install IPC::ShareLite
   		> install Cache::Cache
   		> install Cache::Memcached
   	
  		 # Python类库
   		$ sudo apt-get install python-pip 
    	$ sudo pip install pymongo sphinxsearch

1. redis

```   
   $ cd /usr/share/munin/plugins
   $ sudo wget https://raw.github.com/lvexiao/contrib/master/plugins/redis/redis_ && sudo chmod +x redis_
   $ bash
   $  for i in connected_clients per_sec keys_per_sec used_keys used_memory; do
        sudo ln -s /usr/share/munin/plugins/redis_ /etc/munin/plugins/redis_127.0.0.1_6379_${i}__redis_master
   done  
2. redis-speed
   $ sudo wget https://raw.github.com/lvexiao/contrib/master/plugins/redis/redis-speed && sudo chmod +x redis-speed
   $ sudo ln -s /usr/share/munin/plugins/redis-speed /etc/munin/plugins/redis-speed_127.0.0.1_6379__redis_master
3. resque
```
* memcached

```
	# memcached 缓存大小、连接数量、命中率、对象数量、请求数量、网络流量
   $ for i in bytes_ connections_ hits_ items_ requests_ traffic_; do
	 	sudo wget https://raw.github.com/lvexiao/contrib/master/plugins/memcached/memcached_${i} && sudo chmod +x memcached_${i}
		sudo ln -s /usr/share/munin/plugins/memcached_${i} /etc/munin/plugins/memcached_${i}127_0_0_1_11211
	done
```
* mongodb

 ```  
   for i in btree conn lock mem ops;do sudo wget https://raw.github.com/lvexiao/contrib/master/plugins/mongodb/mongo_${i} && sudo chmod +x mongo_${i}; 
   		sudo ln -s /usr/share/munin/plugins/mongo_${i} /etc/munin/plugins/mongo_${i}
   done
```   
* mysql

```
   $ vim /etc/munin/plugin-conf.d/munin-node
	增加
	[mysql_*]
		env.mysqluser admin
		env.mysqlpassword $ngrserver$   
	
	for i in connections bin_relay_log commands files_tables innodb_bpool innodb_bpool_act innodb_insert_buf innodb_io innodb_io_pend innodb_rows innodb_semaphores innodb_tnx innodb_tnx network_traffic qcache qcache_mem select_types slow sorts table_locks tmp_tables;do
		sudo ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_${i}
	done
```	
* Sphinx
 
```
	$ sudo wget https://raw.github.com/lvexiao/contrib/master/plugins/sphinx/sphindex_ && sudo chmod +x sphindex_
	$ 
```

* Unicorn

```
	$ sudo wget https://raw.github.com/lvexiao/contrib/master/plugins/unicorn/unicorn_memory_status && sudo chmod +x unicorn_memory_status
	# 修改rails_root
	 sudo ln -s /usr/share/munin/plugins/unicorn_memory_status  /etc/munin/plugins/unicorn_memory_status
	 
	 $ sudo wget https://raw.github.com/lvexiao/contrib/master/plugins/unicorn/unicorn_status && sudo chmod +x unicorn_status
	 # 修改rails_root
	 $ sudo ln -s /usr/share/munin/plugins/unicorn_status /etc/munin/plugins/unicorn_statu
```
* Nginx

```
Nginx-Memory:
	sudo wget https://raw.github.com/lvexiao/contrib/master/plugins/nginx/nginx_memory && sudo chmod +x nginx_memory
	sudo ln -s /usr/share/munin/plugins/nginx_memory /etc/munin/plugins/ 
	sudo ln -s /usr/share/munin/plugins/nginx_status /etc/munin/plugins/
```

* 重启Munin节点

   		$ sudo service munin-node restart   	
   
#####其他
----
关闭SELINUX
修改 /etc/selinux/config 将SELINUX=enforcing 改成SELINUX=disabled  需要重启

关于/etc/init.d下的脚本的另一种管理方法
统一建立在config/下例如

	$ chmod +x config/unicorn_init.sh
	$ sudo ln -s /prod/dev/magic/current/config/unicorn_init.sh /etc/init.d/unicorn
	$ sudo service unicorn restart

#####维护页
------
部署的时候,如果 #{shared_path}/system/maintenance.html 存在，则rewrite至维护页面

如果维护结束的时候 需要删除这个文件 

	$ rm -f #{shared_path}/system/maintenance.html  

#####Mysql主从
---------
设置Mysql 从服务器跳过错误的SQL语句  

	SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1;

--EOF--