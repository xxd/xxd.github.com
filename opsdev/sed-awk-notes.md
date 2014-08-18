## 语法部分
- -F 选项指定分隔符，指定多个分隔符用`awk -F '[;:]'`

>$ echo '    inet 10.150.160.73/16 brd 10.150.255.255 scope global eth1' |awk -F '[/\ ]' '{print $6}'
10.150.160.73

- 列出你最常用的10条命令: 这行命令组合得很妙：history输出用户了命令历史；awk统计并输出列表；sort排序；head截出前10行。

>$ history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head

## 应用部分
### 查找行号
```ruby
#比如说我想要找到包含"CHECKPOINT PROGRESS RECORDS"是第几行,然后打印之后的文本
$ cat orcl_ora_27678.trc|grep -n "CHECKPOINT PROGRESS RECORDS"
27785:CHECKPOINT PROGRESS RECORDS

$ awk '{i=27785-1;o=27785+300} FNR=i FNR=o' orcl_ora_27678.trc

# 简单方法
$ head -30 orcl_ora_27678.trc |tail -15 列出第16-30行

# sed方法，看3967至3969行
cache1-> sed -n '3967, 3969p' /u02/syncFiles/HotelInformation/sisetu_page_data_cg.csv
"16487","特色","平成15年4月翻新隆重开业。","","","","0","0","","","20031121"
"18794","特色","有大型游泳池并且能看到美丽落日的度假酒店。","","","","","0","0","","","20031121"
"11297","特色","适于商务，度假，欢迎广泛利用。","","","","0","0","","","20031121"
# sed方法，看一行
cache1-> sed -n '3968, 1p'
```

### awk去掉重复记录
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

### Ref:
- [awk简明教程](http://coolshell.cn/articles/9070.html)

--EOF--