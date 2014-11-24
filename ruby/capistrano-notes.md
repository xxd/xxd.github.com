Capistrano
==========

仓库链接
--------

[rails 环境安装][0]

References
----------

http://help.github.com/deploy-with-capistrano/  
http://www.robinlu.com/blog/archives/117  
https://github.com/leehambley/capistrano-handbook/blob/master/index.markdown


Requirements
------------
### 1 角色定义
WebServer : rails环境 + nginx + passenger + openssh_server  
DBServer : rails 环境 + mysql +redis + openssh_server  
DBSlave : 与DBServer相同   
(DBServer需要配合Capistrano执行数据库的migration等其他任务，需要有rails环境支持)

### 2 系统需求
WebServer、DBServer和DBSlave必须都拥有一个名称相同的账号(默认deploy)，用来部署ror程序，且密码相同,用于从Capistrano客户端建立ssh连接.  
远程服务器的部署文件路径，需对部署账号(deploy)开放权限，建议更改文件、文件夹属主至deploy.  

示例命令:  
`cd $DEPLOY_PATH`  
`sudo chown -R delpoy:deploy $DEPLOY_PATH`

### 3 rake的版本必须一致  


Capistrano客户端环境安装
------------------------


### 1 克隆代码仓库  
	cd ~
	git clone git://github.com/Zhengquan/ror-install--deploy.git
### 2 运行安装脚本
	cd ror-install--deploy && cd ror_install
	chmod +x rails_install.sh
	sudo ./rails_install.sh Capistrano


rails程序部署
------------

### 1 开始部署,进入项目文件,初始化文件
	cd $PROJECT && capify .

### 2 配置deploy.rb文件
	vim config/deply.rb
示例文件:  

	set :application,  "batmanreturns"       #需要部署的项目名称 
	set :repository,   "git://github.com/vvdpzz/batmanreturns.git"  ##代码仓库的地址
	default_run_options[:pty] = true        ##必填，用来在Capistrano客户端显示密码输入提示框
	set :scm, :git 				##仓库类型 subversion or git
	# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
	set :branch, "master"                   ##分支名称
	set :deploy_via, :remote_cache          ##开启远程缓存，每次部署只替换发生变化的文件
	role :web,   "192.168.1.142"                         #  WebServer地址
	role :app,   "192.168.1.142"                         #  应用服务器 默认与WebServer相同
	role :db,  "192.168.1.145", :primary => true # 主数据库服务器地址，必须让:primary指向true
	role :db,   "192.168.1.143" 			#从数据库服务器
	set :deploy_to, "/var/www/#{application}"       #远程Server的部署路径
	set :user, "deploy"                             #用来部署的账号
	
	# if you're still using the script/reaper helper you will need
	# these http://github.com/rails/irs_process_scripts
	
	## 以下部署配合Passenger使用
	# If you are using Passenger mod_rails uncomment this:
	 namespace :deploy do
	   task :start do ; end
	   task :stop do ; end
	   task :restart, :roles => :app, :except => { :no_release => true } do
	     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
	   end
	 end
	

### 3 切换至deploy账号
	su deploy
### 4 检查配置是否有误
	cap deploy:check
or  

	cap shell     #进入cap shell，测试各服务器是否正常

### 5 开始配置,执行数据迁移
	cap deploy:setup & cap deploy:migrate

### 7 在config.rb配置其他Task等


Capistrano其他操作
-----------------
### 1 重启WebServer的Nginx & Passenger服务
	cap deploy:restart	

[0]: https://github.com/Zhengquan/ror-install--deploy
