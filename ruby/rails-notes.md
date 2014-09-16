- 使用render把代码模块化，把关于HTML shim和header的代码放到views/layouts/shim和header两个文件中，然后使用render调用（参考：http://railstutorial-china.org/chapter5.html#section-5-1-3）
```Ruby
<%= render 'layouts/shim' %>
<%= render 'layouts/header' %>
```
