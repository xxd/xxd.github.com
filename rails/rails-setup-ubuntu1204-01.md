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