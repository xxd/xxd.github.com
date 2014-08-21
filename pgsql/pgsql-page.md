### 参考：
- 日常维护
    - http://www.zlovezl.cn/articles/15-advanced-postgresql-commands-with-examples/
    - http://my.oschina.net/Kenyon/blog/85395
- 性能查询
    - http://my.oschina.net/Kenyon/blog/75757

###基础命令：
```ruby
psql -h 123.126.32.82 -U postgres
select * from pg_database;
SELECT typname,typlen from pg_type where typtype='b'; #pg的字段类型
select pg_size_pretty(pg_database_size('postgres')); #数据库大小
 pg_size_pretty 
----------------
 363 GB
(1 row)
SELECT relname, relpages*8/1024/1024 FROM pg_class ORDER BY relpages DESC; #数据库中的表的物理大小，relpages - 关系页数（默认情况下一个页大小是8kb）

postgres=# SELECT pg_size_pretty(pg_total_relation_size('t_stat_vid_pv_today')); 包含索引
 pg_size_pretty 
----------------
 58 GB
(1 row)

postgres=# SELECT pg_size_pretty(pg_relation_size('t_stat_vid_pv_today')); 不包含索引
 pg_size_pretty 
----------------
 40 GB
(1 row)

select pg_size_pretty(pg_total_relation_size('t_stat_vid_pv_today'));
select pg_size_pretty(pg_total_relation_size('t_stat_file_d'));
select pg_size_pretty(pg_total_relation_size('i_t_stat_vid_pv_today_day_time'));
select pg_size_pretty(pg_total_relation_size('t_stat_smokping_path'));
select pg_size_pretty(pg_total_relation_size('t_stat_vid_vv_today'));
select pg_size_pretty(pg_total_relation_size('t_as_pid_value_model '));
select pg_size_pretty(pg_total_relation_size('i_t_stat_vid_vv_today_day_time_vid'));
select pg_size_pretty(pg_total_relation_size('t_stat_smokping_path_http'));
select pg_size_pretty(pg_total_relation_size('t_play_quality_day'));
select pg_size_pretty(pg_total_relation_size('i_t_stat_smokping_path_day_time_hour'));

# \l       相当于mysql的，mysql> show databases;
# \dt      相当于mysql的，mysql> show tables;
# \d test  相当于mysql的，mysql> desc test;  
SELECT pg_stat_get_backend_pid(s.backendid) AS procpid,
pg_stat_get_backend_activity(s.backendid) AS current_query
FROM (SELECT pg_stat_get_backend_idset() AS backendid) AS s; 正在运行的SQL
```

----

### 性能查看第1种方法
```ruby
top -c --查看何种类型
sh viewsql.sh PID
emacs viewsql.sh
#!/bin/sh
######################################################
# viewsql.sh                                         #
# Author:xuexiaodong                                 #
# use to show all active session's sql in PostgreSQL.#
######################################################

if test -z $1 ;then
echo "Usage: $0 pid"
exit 10
fi
echo "select * from (SELECT pg_stat_get_backend_pid(s.backendid) AS procpid, pg_stat_get_backend_activity(s.backendid) AS current_query FROM (SELECT pg_stat_get_backend_idset() AS backendid) AS s) as querystring where procpid=$1;" | psql  -h 123.126.32.82 -U postgres

###找到所有运行的SQL
emacs viewAllSql.sh
#!/bin/sh
######################################################
# viewAllSql.sh                                      #
# Author:xuexiaodong                                 #
# use to show all active session's sql in PostgreSQL.#
######################################################

echo "SELECT procpid, start, now() - start AS lap, current_query 
FROM 
    (SELECT backendid, 
        pg_stat_get_backend_pid(S.backendid) AS procpid, 
        pg_stat_get_backend_activity_start(S.backendid) AS start, 
       pg_stat_get_backend_activity(S.backendid) AS current_query 
    FROM 
        (SELECT pg_stat_get_backend_idset() AS backendid) AS S 
    ) AS S 
WHERE current_query <> '<IDLE>' 
ORDER BY lap DESC;" | psql  -h 123.126.32.82 -U postgres | grep -v "+"


找到后使用explain 
postgres=# show client_encoding;
 client_encoding 
-----------------
 GBK
(1 row)

postgres=# \encoding UTF8
postgres=# explain select count(*) from ( select t.name,a.pid,sum(a.vv) vv,sum(a.cv) cv,sum(a.uv) uv from 
(select cid,pid,cast(vv as int) as vv,cv,uv from t_mobile_rank where ch  in ('04','06') and day_time>='20140730' and  day_time<='20140730') a left join (select c.name,cast(c.pid as VARCHAR) as pid from con_album_info c) t on a.pid=t.pid left join (select cast (id as VARCHAR) as id from meta_cid) b on a.cid=b.id where (b.id ='rootvv' or  'rootvv'='rootvv')    and t.name like '%奔跑吧少年%' group by t.name,a.pid  order by vv desc) asdf;
postgres=# EXPLAIN select count(*) from ( select t.name,a.pid,sum(a.vv) vv,sum(a.cv) cv,sum(a.uv) uv from (select cid,pid,cast(vv as int) as vv,cv,uv from t_mobile_rank where ch not in ('04','06') and day_time>='20140721' and  day_time<='20140721') a left join (select c.name,cast(c.pid as VARCHAR) as pid from con_album_info c) t on a.pid=t.pid left join (select cast (id as VARCHAR) as id from meta_cid) b on a.cid=b.id where (b.id ='rootvv' or  'rootvv'='rootvv') and t.name like '%我们一起来%' group by t.name,a.pid  order by vv desc) asdf;

postgres=# EXPLAIN ANALYZE query select count(*) from ( select t.name,a.pid,sum(a.vv) vv,sum(a.cv) cv,sum(a.uv) uv from (select cid,pid,cast(vv as int) as vv,cv,uv from t_mobile_rank where ch not in ('04','06') and day_time>='20140721' and  day_time<='20140721') a left join (select c.name,cast(c.pid as VARCHAR) as pid from con_album_info c) t on a.pid=t.pid left join (select cast (id as VARCHAR) as id from meta_cid) b on a.cid=b.id where (b.id ='rootvv' or  'rootvv'='rootvv') and t.name like '%我们一起来%' group by t.name,a.pid  order by vv desc) asdf;

select count(*) from ( select title,vv_dsk,vv_m,vv_tv,id from
(select c.name title,sum(a.vv_dsk) vv_dsk,sum(a.vv_m) vv_m,sum(vv_tv) vv_tv,0 id 
	from t_stat_vid_vv_today a,  video_info b, album c,v_cid d  where a.day_time >= '20140717' and a.day_time <=

看表结构索引
# \d con_album_info
然后找表上是否有index
# select * from pg_indexes where tablename='con_album_info';

#查看准备建索引字段的选择性
select count(distinct COLUMN_NAME),count(*)  from TABLE_NAME;
select count(distinct name),count(distinct pid),count(*)  from con_album_info;
 count | count | count 
-------+-------+-------
 48356 | 53591 | 53591
(1 row)
选择性不好，还是全表扫描好

francs=> create index idx_con_album_info_name_pid on con_album_info using btree ( name, pid);
CREATE INDEX
francs=> analyze con_album_info;

create index idx_t_mobile_rank_name_pid on t_mobile_rank using btree (cid,pid,vv,cv,uv,ch,day_time);
create index idx_con_album_info_name_pid on con_album_info using btree ( name, pid);
analyze t_mobile_rank;


###方法2：查看总等待，然后杀掉费资源的
SELECT datname,procpid,query_start, current_query,waiting,client_addr FROM pg_stat_activity WHERE waiting='t';
说明：
datname表示数据库名
procpid表示当前的SQL对应的PID
query_start表示SQL执行开始时间
current_query表示当前执行的SQL语句
waiting表示是否正在执行，t表示正在执行，f表示已经执行完成
client_addr表示客户端IP地址

###kill方式
SELECT pg_cancel_backend(PID); ##这种方式只能kill select查询，对update、delete 及DML不生效)
SELECT pg_terminate_backend(PID); ##这种可以kill掉各种操作(select、update、delete、drop等)操作
kill -9 PID;

###方法3：慢查询
more /data/pgdb/data/postgresql.conf
logging_collector = on
log_destination = 'csvlog'
log_directory = '/data/pgdb/pg_log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_connections = on
log_disconnections = on
log_rotation_age = 1d
log_rotation_size = 20MB


###SQL
生成1到1000这一千个数字并插入到numbers表中。
# INSERT INTO numbers (num) VALUES ( generate_series(1,1000));

查询某列中第二大的值
# SELECT MAX(num) from number_table where num  < ( select MAX(num) from number_table );

查询某列第二小的值
# SELECT MIN(num) from number_table where num > ( select MIN(num) from number_table );

如何把某一次查询的结果保存为一个文件？
# \o output_file
# SELECT * FROM pg_class;
上面这个查询的结果将会被保存到到"output_file"文件中。当重定向被激活后，之后的所有查询都不再会把结果 打印在屏幕上了。如果要再次打开屏幕输出，需要再执行一次不带任何参数的 o 命令。
# \o

MD5
SELECT crypt ( 'sathiya', gen_salt('md5') );
# \i /usr/share/postgresql/8.1/contrib/pgcrypto.sql

1. https://wiki.postgresql.org/wiki/Performance_Optimization

```

------

### Pgdb数据清除：

1. 查看所需要清除数据的结构的类型及时间区间，并确认是否有day_time列索引。
查看结构：`\d t_stat_vid_pv_today`
如无day_time索引，创建索引：`create index day_time on t_stat_vid_pv_today(day_time)`
查看时间区间：`Select min(day_time),max(day_time) from t_stat_vid_pv_today;`

2. 清除数据
对于近几个月无数据的表，直接清除并回收物理空间
清除数据：`truncate table  t_stat_vid_pv_today;`
回收物理空间：`VACUUM  t_stat_vid_pv_today;`

对于近期有数据的表t_play_quality_day 、t_as_pid_value_model，直接删除历史数据由于数据较多，锁表时间较长，删除时间耗时较长，可创建新表，将近几个月的数据`insert into  new_table  select * from old_table;`然后rname表名用新表替换旧表，再将旧表的数据清除（前提是无更新数据写入）
- 建新表，表结构一致: `create table t_play_quality_day_20140812_new as select * from  t_play_quality_day where 1=9;`
- 补原表存在的索引: `create index i_t_play_quality_day_1 on t_play_quality_day_20140812_new(day_time); `
- 写入近几个月的数据: `insert into t_play_quality_day_20140812_new select * from t_play_quality_day where day_time >= '2014-05-01';`
- rename表名: `alter table t_play_quality_day rename to t_play_quality_day_old;`, `alter table t_play_quality_day_20140812_new rename to t_play_quality_day;`
- 清除旧表: `truncate table t_play_quality_day_old;` 
- 回收物理空间: `VACUUM  t_play_quality_day_old;`

### 主从
```
配置文件添加：
wal_level = hot_standby
synchronous_commit = local
max_wal_senders = 3

数据同步用户添加：
ruser

访问权限文件添加：
host   replication     ruser     ip/32		md5
```

--EOF--