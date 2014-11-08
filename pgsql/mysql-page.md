- [MySQL性能优化的最佳经验，随时补充](http://www.jianshu.com/p/5dd73a35d70f)

####要点
- show full processlist->慢日志分析Top10->explain(然后建好联合索引)
- MySql的QueryCache想要命中的话`要求查询语句与之前的一模一样，包括大小写必须一致、不能增减空格等等。`包括comment都必须是一样的，因为mysql使用简单的hash来确保的。

####常用
- [MySQL常用命令](http://blog.chinaunix.net/uid-26784799-id-3470279.html)：
```ruby
SHOW [GLOBAL | SESSION] VARIABLES [LIKE ' pattern ' | WHERE expr ]; 
mysql -uroot -p  -e "show full processlist" | grep -v Sleep | sort -k6rn >sort.tmp #如果发现IOWait很高，请查看临时表的生成情况，特别是disk tmp table:
mysql> mysql -uroot -p  -e "show global status like '%tmp%'" #如果发现IOWait很高，请查看临时表的生成情况，特别是disk tmp table
mysqlbinlog -vv   mysql-bin.000039    |  \
  grep -i -e "^update" -e "^insert" -e "^delete" -e "^replace" -e "^alter"  | \
  cut -c1-100 | tr '[A-Z]' '[a-z]' |  \
  sed -e "s/\t/ /g;s/\`//g;s/(.*$//;s/ set .*$//;s/ as .*$//" | sed -e "s/ where .*$//" |  \
  sort | uniq -c | sort -nr #一条霸气的分析binlog的命令：
`SELECT ip_country FROM geoip WHERE INET_ATON('174.36.207.186') BETWEEN begin_ip_num AND end_ip_num LIMIT 1;` #INET_ATON() and INET_NTOA()
$ tcpdump -A "dst port 3306" #纯粹Linux相关的(查看3306端口的通信具体内容)
$ /usr/sbin/tcpdump -i eth0 -s 0 -l -w - dst port 3306 | strings | egrep -i 'SELECT|UPDATE|DELETE|INSERT|SET|COMMIT|ROLLBACK|CREATE|DROP|ALTER|CALL' > /tmp/mysql.tcpdump.log #查询MySQL执行各类CRUD的频率
```

####SQL写法与调优
- <insert into … on duplicate key update | replace into 多行数据]] > 笔记：
```
`insert DELAYED into dkv values (1,2,'new 12a'),(1,3,'new 33ba'),(1,4,'new 23222'),(1,6,'new 12333'),(1,8,'new vaaaa'),(1,20,'new vaff'),(1,25,'new vaff') ON DUPLICATE KEY UPDATE val=VALUES(val);`
`replace into dkv values(1,2,'new 12a'),(1,3,'new 33ba'),(1,4,'new 23222'),(1,6,'new 12333'),(1,8,'new vaaaa'),(1,20,'new vaff'),(1,25,'new vaff');`
```

- 强制索引 FORCE INDEX(Index_Name)
```
SELECT A.*，B.description FROM A LEFT JOIN B FORCE INDEX(Index_4) ON A.name=B.name;
```

- 强制Join STRAIGHT_JOIN
```
SELECT film.film_id, film.title, film.release_year, actor.actor_id FROM sakila.film STRAIGHT_JOIN sakila.film_actor USING(film_id); 
```

- mysqlsla
```
xuexd@li386-141:/mysql/slowlog$ sudo mysqlsla -lt slow /mysql/slowlog/mysql-slow.log
```

- 主从问题解决
```
mysql> Show slave status \G查看Master状态：
mysql> Show master status;重置Slave（慎用）
mysql> reset slave;
Slave出现问题了，先跳过这一条语句（请确认所要跳过的具体内容不会影响后面的同步，确认方法查看Binlog文件）：
mysql> set global sql_slave_skip_counter=1; (记得先暂停Slave：stop slave; 然后重启Slave：start slave;)   
```

- BINLOG的删除与查看
```
在/etc/mysql/my.cnf中加入:
expire_logs_days = 10

在运行时修改：
show binary logs;   
show variables like '%log%';   
set global expire_logs_days = 10;
```

- 手动删除10天前的MySQL binlog日志：
```
PURGE MASTER LOGS BEFORE DATE_SUB(CURRENT_DATE, INTERVAL 10 DAY);  
show master logs;
```

- 查看方法
```
mysqlbinlog /home/xuexd/binlog_tmp/mysql-bin.000016 --user=lxdev |grep DELETE |head -10
```