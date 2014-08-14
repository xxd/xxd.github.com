- [awk简明教程](http://coolshell.cn/articles/9070.html)

-F 选项指定分隔符，指定多个分隔符用awk -F '[;:]'
    $ echo '    inet 10.150.160.73/16 brd 10.150.255.255 scope global eth1' |awk -F '[/\ ]' '{print $6}'
10.150.160.73

#####列出你最常用的10条命令
这行命令组合得很妙：history输出用户了命令历史；awk统计并输出列表；sort排序；head截出前10行。

	$ history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head

####awk去掉重复记录
```ruby
awk '!a[$0]++' xhyt_app_001.txt 
#说明: 
#!a[$0]++ 
#将每一行以数组下标形式存入数组中 
#从0开始,有相同的加1,并取非. 

date +"%Y-%m-%d %H:%M:%S" && awk '!a[$0]++' xhyt_app_001.txt > app.txt && date +"%Y-%m-%d %H:%M:%S" && mv xhyt_app_001.txt xhyt_app_0001_bak.txt && mv app.txt xhyt_app_001.txt 

#增加开始时间,结束时间. 
#将输出后的文件重命名,将源文件改名_bak
```