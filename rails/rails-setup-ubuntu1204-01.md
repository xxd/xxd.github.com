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
