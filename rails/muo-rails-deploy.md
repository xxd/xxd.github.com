**@production**

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

**@local**
```ruby
tar -zcvf muo_rails.tar.gz muo_rails
scp muo_rails.tar.gz deploy_user@106.187.101.82:/prod
```

**@production**
```ruby
su - deploy_user
sudo apt-get install nodejs
bundle install
cd /prod/muo_rails/
rails s
http://106.187.101.82:3000

部署unicorn：config里找到unicorn.sh
/etc/init.d/unicorn.sh start
安装Nginx：config里找到nginx.conf

emacs config/environments/production.rb 
config.assets.precompile += %w( active_admin.css active_admin.js )
config.serve_static_assets = true
config.assets.compress = true
config.assets.compile = true

bundle exec unicorn_rails -c /prod/muo_rails/config/unicorn.rb -E production -D
```

----

--EOF--