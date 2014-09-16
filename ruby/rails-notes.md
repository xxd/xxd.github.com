- 使用render把代码模块化，把关于HTML shim和header的代码放到views/layouts/shim和header两个文件中，然后使用render调用
```Ruby
<%= render 'layouts/shim' %>
<%= render 'layouts/header' %>
```

