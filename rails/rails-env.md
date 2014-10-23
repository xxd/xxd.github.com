- [Ruby on Rails Tutorial 原书第 2 版（涵盖 Rails 4）](http://railstutorial-china.org/rails4/)

###环境
```
$ rvm list known
$ rvm install 2.1.2
$ rvm use 2.1.2 --default
$ rvm gemset create rails4
$ rvm use 2.1.2@rails4 --default
$ rvm gemset list
$ gem install rails --version 4.0.4 --no-ri --no-rdoc
```

###Rails项目
```
$ mkdir rails_projects
$ cd rails_projects
$ rails new first_app
改gemfile
$ bundle update
$ bundle install
$ rails server
------
cd rails_projects
rails new demo_app
cd demo_app
rails generate scaffold User name:string email:string
bundle exec rake db:migrate
rails generate scaffold Micropost content:string user_id:integer
bundle exec rake db:migrate
rails server
rails console
------
rails new sample_app --skip-test-unit
传入命令的控制器名使用的是驼峰式命名法，生成的控制器文件名使用的是蛇底式命名法，因此名为 StaticPages 的控制器对应的文件名为 static_pages_controller.rb。这只是一个约定
```

###Git
```
$ git init

修改.gitignore 文件
# Ignore bundler config.
/.bundle

# Ignore the default SQLite database.
/db/*.sqlite3
/db/*.sqlite3-journal

# Ignore all logfiles and tempfiles.
/log/*.log
/tmp

# Ignore other unneeded files.
database.yml
doc/
*.swp
*~
.project
.DS_Store
.idea
.secret

$ git add .
$ git status
$ git commit -m "Initial commit"
$ git log
$ git remote add origin git@github.com:<username>/first_app.git
$ git push -u origin master
$ git checkout -b modify-README
$ git branch
```