- [MySQL性能优化的最佳经验，随时补充](http://www.jianshu.com/p/5dd73a35d70f)

####常用
```ruby
SHOW [GLOBAL | SESSION] VARIABLES [LIKE ' pattern ' | WHERE expr ]; 
show full processlist->慢日志分析Top10->explain(然后建好联合索引)
mysql -uroot -p  -e "show full processlist" | grep -v Sleep | sort -k6rn >sort.tmp # 如果发现IOWait很高，请查看临时表的生成情况，特别是disk tmp table:
MySql的QueryCache想要命中的话`要求查询语句与之前的一模一样，包括大小写必须一致、不能增减空格等等。`包括comment都必须是一样的，因为mysql使用简单的hash来确保的。
<insert into … on duplicate key update | replace into 多行数据]] > 笔记：
`insert DELAYED into dkv values (1,2,'new 12a'),(1,3,'new 33ba'),(1,4,'new 23222'),(1,6,'new 12333'),(1,8,'new vaaaa'),(1,20,'new vaff'),(1,25,'new vaff') ON DUPLICATE KEY UPDATE val=VALUES(val);`
`replace into dkv values(1,2,'new 12a'),(1,3,'new 33ba'),(1,4,'new 23222'),(1,6,'new 12333'),(1,8,'new vaaaa'),(1,20,'new vaff'),(1,25,'new vaff');`
一条霸气的分析binlog的命令：
mysqlbinlog -vv   mysql-bin.000039    |  \
  grep -i -e "^update" -e "^insert" -e "^delete" -e "^replace" -e "^alter"  | \
  cut -c1-100 | tr '[A-Z]' '[a-z]' |  \
  sed -e "s/\t/ /g;s/\`//g;s/(.*$//;s/ set .*$//;s/ as .*$//" | sed -e "s/ where .*$//" |  \
  sort | uniq -c | sort -nr
`SELECT ip_country FROM geoip WHERE INET_ATON('174.36.207.186') BETWEEN begin_ip_num AND end_ip_num LIMIT 1;` #INET_ATON() and INET_NTOA()
```