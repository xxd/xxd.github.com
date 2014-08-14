### 时间
```Ruby
date "+%Y_%m_%d %H:%M:%S"    
2013_02_19 13:14:58  

date -d tomorrow
DATE_TIME=`date -d'1 hour ago' +%Y-%m-%d-%H`
```

### 判断
```Ruby
[ -f "somefile" ] ：判断是否是一个文件 
[ -x "/bin/ls" ] ：判断/bin/ls是否存在并有可执行权限，-r测试文件可读性
[ -n "$var" ] ：判断$var变量是否有值，测试空串用-z
[ -e "somefile" ]：判断文件是否存在
[ -d "somefile" ]：判断是否为文件夹
[ -r "somefile" ]：判断文件是否可读
[ -w "somefile" ] ：判断文件是否可写
[ "$a" = "$b" ] ：判断$a和$a是否相等 
[ -f "$file" ] 判断$file是否是一个文件
[ $a -lt 3 ] 判断$a的值是否小于3，同样-gt和-le分别表示大于或小于等于
[ cond1 -a cond2 ] 判断cond1和cond2是否同时成立，-o表示cond1和cond2有一成
```

### 传入参数
```Ruby
emacs variable 
#!/bin/sh   
echo "number:$#"   
echo "scname:$0"   
echo "first :$1"   
echo "second:$2"   
echo "argume:$@"   
echo "show parm list:$*"   
echo "show process id:$$"   
echo "show precomm stat: $?"   

结果：
number:2   
scname:./variable   
first:aa   
second:bb   
argume:aa bb   
show parm list:aa bb   
show process id:24544   
show precomm stat:0   

解释：
$# 是传给脚本的参数个数 
$0 是脚本本身的名字 
$1 是传递给该shell脚本的第一个参数 $2 是传递给该shell脚本的第二个参数 
$@ 是传给脚本的所有参数的列表 
$* 是以一个单字符串显示所有向脚本传递的参数，与位置变量不同，参数可超过9 
$$ 是脚本运行的当前进程ID号 PID
$? 是显示最后命令的退出状态，0表示没有错误，其他表示有错误 
```

### For In
```Ruby
for a in 7 8 9 11
do
    echo -n "$a "
done

for table in $(mysql -u bdm_r -pc2f447a2e7 -h 10.200.91.71 -P 3324 bigdata_data_market -e "show tables;" | awk 'NR>1')
do
    echo $table
    mysql -u bdm_r -pc2f447a2e7 -h 10.200.91.71 -P 3324 bigdata_data_market -e "desc ${table};"
done

arr=("a" "b" "c")
echo "arr is (${arr[@]})"
echo "item in array:"
for i in ${arr[@]}
do
 echo "$i"
done
echo "参数,\$*表示脚本输入的所有参数："
for i in $* ; do
    echo $i
done
```

### For Loop
```Ruby
for ((i=38; i>0; i--)) ;do
YESTERDAY=`date -dyesterday +%Y%m%d`
TWO_DAYS_BEFORE=`date -d"2 days ago" +%Y%m%d`

YESTERDAY=`date -d"$i days ago" +%Y%m%d`
two=`expr $i + 1`
TWO_DAYS_BEFORE=`date -d"$two days ago" +%Y%m%d`

echo "run data for ====== $YESTERDAY =======, using user base: $TWO_DAYS_BEFORE !"

YM=`date -dyesterday +%Y%m`
YM=`date -d"$i days ago" +%Y%m`
done
```

### while loop
```Ruby
while [ cond1 ] && { || } [ cond2 ] …; do
…
done

#!/bin/bash
file=$1
cat $file | while read line
do
	filename=`echo $file | cut -c 1-16 `
	tar -zcvfP /letv/logs/va/split/$filename.tar.gz /letv/logs/va/split/$filename
done

#!/bin/bash
cd `dirname $0`
ARCHDAY=+2
cat /usr/local/nginx/scripts/minutesOfLog | while read dir ;do
  find /logs/$dir -mtime $ARCHDAY -a -type f -a -name "*.tar.gz" -exec ls -l {} \;
done

#!/bin/bash
YEAR=`date +%Y`
MONTH=`date +%m`
ARCHDIR=/letvmfsmount/upload/$YEAR/$YEAR$MONTH
ARCHDAY=+3
find $ARCHDIR -mtime $ARCHDAY -a -type f -a -name "*.*" -exec ls -l {} \;
find $ARCHDIR -mtime $ARCHDAY -a -type f -a -name "*.*" -maxdepth 1 -exec /bin/rm -rf {} \;
```

### until loop
```Ruby
until [ cond1 ] && { || } [ cond2 ] …; do
…
done
```

### List
```Ruby
LIST="rootfs usr data data2"
for d in $LIST; do
用for in语句自动对字符串按空格遍历的特性，对多个目录遍历
for i in {1..10}
for i in stringchar {1..10}
awk 'BEGIN{for(i=1; i<=10; i++) print i}'
```

--EOF--