- https://github.com/intridea/grape

1 in Gemfile

	gem 'grape'
	$ bundle install

2 config/routes.rb
```ruby
require 'grape'
EtpassAPI::Application.routes.draw do
  mount Etpass::API => "/"
end
```

3 检查

	$ rake middleware 
	最后一行应该能看到
	run TestGrapeAPI::Application.routes
	
	$ rake routes
	已经被指向api了
	etpass_api  / Etpass::API

4 app/models/et_order.rb
```ruby
class EtOrder < ActiveRecord::Base
	attr_accessible :pkid
end
```

5 app/api/etpass/api.rb
#####注意这里的命名方式就是routers.rb中，定义的EtpassAPI，那么前边的Etpass就是module，API就是class

```ruby
require 'grape'

module Etpass

  class API < Grape::API
    prefix 'api' #http://0.0.0.0:3000/api/
    version 'v1' #http://0.0.0.0:3000/api/v1
    format :json #从返回XML变为JSON
    default_format :json
    
    resource :et_order do

      #可以使用 http://0.0.0.0:3000/api/v1/et_order 来访问
      get do
        EtOrder.all
      end

      #可以使用 http://0.0.0.0:3000/api/v1/et_order/1282 来访问，但是没有连接数据库无法实现，需要链接数据库来测试
      # get ':pkid' do
      #   order = EtOrder.find(params[:PKID])
      #   order.Flight_No
      # end

      get '/:pkid' do
        Entry.find(params[:pkid])
      end
    end
  end
end
```


####但是如果你从业务方面有很多的API需要写，总不能都放到一个api.rb文件内，下面讲述如何用api.rb来管理其他的api

#####首先建立lib/api.rb
```ruby
require 'grape'

module Etpass

  class API < Grape::API
    format :json #从返回XML变为JSON
    default_format :json
    
    get '/about' do
      puts 'etpass api dev'
    end
  end
end
Dir["#{Rails.root}/app/api/etpass/*.rb"].each {|file| require file }
```

#####其次建立et_order相关的api，app/api/etpass/et_order_api.rb
```ruby
require 'api'

module Etpass

  class API < Grape::API
    prefix 'api' #http://0.0.0.0:3000/api/
    version 'v1' #http://0.0.0.0:3000/api/v1
    format :json #从返回XML变为JSON
    default_format :json
    
    resource :et_order do

      #可以使用 http://0.0.0.0:3000/api/v1/et_order 来访问
      get do
        EtOrder.all
      end

      #可以使用 http://0.0.0.0:3000/api/v1/et_order/1282 来访问，但是没有连接数据库无法实现，需要链接数据库来测试
      get '/:pkid' do
        EtOrder.find_by_PKID(params[:pkid])#, :with => Entities::EtOrder
      end
    end
  end
end
```

6 上边的两种方法都是访问以下链接

	http://0.0.0.0:3000/api/v1/et_order
	http://0.0.0.0:3000/api/v1/et_order/1282

	第二种方法还写了about页
	http://0.0.0.0:3000/about
	
7 相关链接 

1. [grape](https://github.com/intridea/grape)
2. [grape sample blog api](https://github.com/bloudraak/grape-sample-blog-api)
3. [grape goliath example](https://github.com/djones/grape-goliath-example)
4. [goliath](https://github.com/postrank-labs/goliath)
5. [开发者的视频](http://confreaks.com/videos/475-rubyconf2010-the-grapes-of-rapid)
6. [国人根据视频做的PPT](http://www.slideshare.net/yorzi/rapid-rubyapiongrape-8674582#btnNext)
7. more example
	* [http://blog.solid1pxred.com/post/16487806979/building-an-api-rails-3-vs-grape](http://blog.solid1pxred.com/post/16487806979/building-an-api-rails-3-vs-grape)
	* [https://gist.github.com/1950241](https://gist.github.com/1950241)
	* [https://github.com/bobbytables/grape-example](https://github.com/bobbytables/grape-example)
	
--EOF--