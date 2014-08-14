### 判断
```
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