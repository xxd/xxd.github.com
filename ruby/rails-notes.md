#### View：erg文件
- 使用render把代码模块化，把关于HTML shim和header的代码放到views/layouts/shim和header两个文件中，然后使用render调用（参考：http://railstutorial-china.org/chapter5.html#section-5-1-3）
```Ruby
<%= render 'layouts/shim' %>
<%= render 'layouts/header' %>
```
- xx_path直接指向路由，例如`signup_path`指向的就是routers.rb中的`match '/signup', to: 'users#new', via: 'get'`
```ruby
<%= link_to "Sign up now!", signup_path, class: "btn btn-large btn-primary" %>
```
- include ActionView::Helpers::TextHelper的`pluralize`方法，就是合并两个字符串
```ruby
>> include ActionView::Helpers::TextHelper
>> pluralize(1, "error")
=> "1 error"
```
- 默认情况下帮助函数只可以在视图中使用，不能在控制器中使用，而我们需要同时在控制器和视图中使用帮助函数，所以我们就手动引入帮助函数所在的模块。
```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
end
```

#### Model：Users.rb
- Rails4.0 中已经集成好了，只需调用一个方法就可以了，这个方法是 has_secure_password。只要数据库中有 password_digest 列，在模型文件中加入 has_secure_password 方法后就能验证用户身份了。
- 如果遇到`[deprecated] I18n.enforce_available_locales will default to true in the future`错误，`config/application.rb`文件内`class Application < Rails::Application`之后添加`I18n.enforce_available_locales = true`

#### 命令行
- rails generate命令
    * rails generate controller 生成 Users 控制器和 new 方法：（3步就可以手工完成上边的内容了(没建立JS和CSS两个文件)，手工建立了`user_controller.rb`，然后在里边添加了new方法，之后在app/views/下建立一个Users文件夹，里边建立一个`new.html.erb`，最后在`routers.rb`中加入`get "users/new"`就可以完成，参考：http://railstutorial-china.org/chapter5.html#section-5-4-1）
    ```ruby
    rails generate controller Users new --no-test-framework
    rails destroy  controller FooBars baz quux
    ```
    * rails generate model 生成 User 模型，以及 name 和 email 属性所用的命令。然后建立数据库表格
    ```ruby
    rails generate model User name:string email:string #生成确保建表文件db/migrate/[timestamp]_create_USERS.rb
    rails destroy model Foo
    bundle exec rake db:migrate#执行SQL语句
    bundle exec rake db:rollback #回滚SQL语句
    rake db:migrate VERSION=0 # 回到最开始的状态
    ```
    * rails generate migration向现有的表内增加内容
    ```ruby
    rails generate migration add_index_to_users_email #生成确保 Email 唯一性的迁移文件
db/migrate/[timestamp]_add_index_to_users_email.rb
    rails generate migration add_password_digest_to_users password_digest:string #增加字段
    bundle exec rake db:migrate #执行SQL语句
    ```
- rails console
```ruby
    User.new
    user = User.new(name: "Michael Hartl", email: "mhartl@example.com")
    user.save
    user.name
    user.respond_to?(:name)
    User.find(1)
    User.find_by_email("mhartl@example.com")
    User.find_by(email: "mhartl@example.com") #4.0以后
    User.first
    User.all
    user.destroy
    user
    user.update_attribute(:name, "The Dude")
    user.update_attributes(name: "The Dude", email: "dude@abides.org")
```