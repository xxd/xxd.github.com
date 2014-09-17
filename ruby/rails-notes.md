#### erb文件
- 使用render把代码模块化，把关于HTML shim和header的代码放到views/layouts/shim和header两个文件中，然后使用render调用（参考：http://railstutorial-china.org/chapter5.html#section-5-1-3）
```Ruby
<%= render 'layouts/shim' %>
<%= render 'layouts/header' %>
```

- xx_path直接指向路由，例如`signup_path`指向的就是routers.rb中的`match '/signup', to: 'users#new', via: 'get'`
```ruby
  <%= link_to "Sign up now!", signup_path, class: "btn btn-large btn-primary" %>
```

#### 命令行
- rails generate命令
    * rails generate controller 生成 Users 控制器和 new 方法：（3步就可以手工完成上边的内容了(没建立JS和CSS两个文件)，手工建立了`user_controller.rb`，然后在里边添加了new方法，之后在app/views/下建立一个Users文件夹，里边建立一个`new.html.erb`，最后在`routers.rb`中加入`get "users/new"`就可以完成，参考：http://railstutorial-china.org/chapter5.html#section-5-4-1）
    ```ruby
    rails generate controller Users new --no-test-framework
    ```
    * rails generate model 生成 User 模型，以及 name 和 email 属性所用的命令。
    ```ruby
    rails generate model User name:string email:string
    ```