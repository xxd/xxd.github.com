## Pgdb数据清除：

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

--EOF--