在 Linux 上你可找到 grep, egrep, fgrep 这几个程序, 其差异大致如下: 
```
* **grep**: 传统的 grep 程序, 在没有参数的情况下, 只输出符合 RE 字符串之句子. 常见参数如下: 
-v: 逆反模示, 只输出"不含" RE 字符串之句子. 
-r: 递归模式, 可同时处理所有层级子目录里的文件. 
-q: 静默模式, 不输出任何结果(stderr 除外. 常用以获取 return value, 符合为 true, 否则为 false .) 
-i 不区分大小写（只适用于单字符）。
-w: 整词比对, 类似 \<word\> . 
-n: 同时输出行号. (grep -n "48" data.f) 
-c: 只输出符合比对的行数. 
-l: 只输出符合比对的文件名称. 
-o: 只输出符合 RE 的字符串. (gnu 新版独有, 不见得所有版本都支持.) 
-E: 切换为 egrep . 
-h 查询多文件时不显示文件名。
-s 不显示不存在或无匹配文本的错误信息。同`> /dev/null 2>&1`
-B n：显示grep行以及上边的n行 `dmidecode -t system|grep -B 4 "Serial Number"`

* **egrep**: 为 grep 的扩充版本, 改良了许多传统 grep 不能或不便的操作. 比方说: 
    - grep 之下不支持 ? 与 + 这两种 modifier, 但 egrep 则可. 
    - grep 不支持 a|b 或 (abc|xyz) 这类"或一"比对, 但 egrep 则可. 
    - grep 在处理 {n,m} 时, 需用 \{ 与 \} 处理, 但 egrep 则不需. 

* **fgrep**: 不作 RE 处理, 表达式仅作一般字符串处理, 所有 meta 均失去功能
```

--------------

```
第1列：城市位置编号。
第2列：月份。
第3列：存储代码及出库年份。
第4列：产品代号。
第5列：产品统一标价。
第6列：标识号。
第7列：合格数量。
$ cat data.f
48      Dec     3BC1977 LPSX    68.00   LVX2A   138
483     Sept    5AP1996 USP     65.00   LVX2C   189
47      Oct     3ZL1998 LPSX    43.00   KVM9D   512
219     dec     2CC1999 CAD     23.00   PLV2C   68
484     nov     7PL1996 CAD     49.00   PLV2C   234
483     may     5PA1998 USP     37.00   KVM9D   644
216     sept    3ZL1998 USP     86.00   KVM9E   234

* grep -c "48" data.f **计算行数**代替 wc -l
* grep "48\>" data.f **精确**匹配48，而不返回484和483等包含“48”的字符串
* grep -i "sept" data.f 屏蔽月份Sept的**大小写**敏感，也可用下一个
* grep '[sS]ept' data.f 模糊取S和s
* grep "48[34]" data.f
* grep "^[^48]" data.f 行首不是4或8
* grep -v "^[^48]" data.f 上一个的反例，等于grep "^[48]" data.f
* grep 'K...D' data.f 抽取已知长度为5个字符以K开头，以D结尾的代码
* grep '[A-Z]..C' data.f
* grep '5..199[6,8]' data.f 查询所有以5开始以1 9 9 6或1 9 9 8结尾的所有记
* grep '[0-9][0-5[0-6]' data.f 但是我觉得这种方式没有awk好，而且差很远
* grep '^[0-9][0-5][0-6]' data.f
* grep '4\{2,\}' data.f 数字4至少重复**出现2次**的所有行
* grep '9\{3,\}' data.f 数字9**至少重复出现3次**的所有行
* grep '9\{3\}' data.f 数字9**必须重复出现3次**的所有行
* grep '8\{2,6\}3' myfile 数字8出现**最少2次最多6次**以3结尾
* grep -E '219|216' data.f 抽取城市代码为219或216
* grep -c '^$' myfile 显示空行数
* grep -n '^$' myfile 显示哪些行是空行
* grep '\.' myfile 诸如$ . ' " * [] ^ | \ + ? ,必须在特定字符前加\。假设要查询包含“.”的所有行
* grep 'conftroll\.conf' myfile 查询文件名
* grep '^[a-z]\{1,6\}\.[A-Z]\{1,2\}' filename 匹配文件名最多六个小写字符，后跟句点，接着是两个大写字符
* [0-9]\{3\}\.[0-9]\{3\}\.' 匹配IP地址

[ [ : u p p e r : ] ] [ A - Z ] [ [ : a l n u m : ] ] [ 0 - 9 a - zA-Z]
[ [ : l o w e r : ] ] [ a - z ] [ [ : s p a c e : ] ] 空格或t a b键
[ [ : d i g i t : ] ] [ 0 - 9 ] [ [ : a l p h a : ] ] [ a - z A - Z ]

* grep '5[[:upper:]][[:upper]]' data.f 5开头，后跟至少两个大写字母
* grep '[[:upper:]][[:upper:]][P,D]' data.f 以P或D结尾
* grep "l.*s" testfile
* grep "ng$" testfile 匹配ng结尾
* STR="Mary Joe Peter Pauline"
* echo $STR | grep "Mary"  结果为Mary Joe Peter Pauline
* cat grepstrings
484
47
* egrep -f grepstrings data.f
* egrep '(3ZL|2CC)' data.f 意即“|”符号两边之一或全部 32L或2CC
* who |egrep (louise|matty|pauline)
* egrep '(shutdown |reboot) (s)?' * 文件列表，包括s h u t d o w n、s h u t d o w n s、r e b o o t和r e b o o t s

#####去除所有的--和空格行和开头的空格
	grep -v ^-- /tmp/luo.txt|grep -v ^$ /tmp/luo1.txt
	vim /tmp/luo1.txt
	sed -n '1,23'p /tmp/luo1.txt /tmp/luo2.txt
	截取下面两行和之间的内容。注意是下面行是第一次出现的时候
	STARTUP NOMOUNT
	..................
	SIZE 30408704  REUSE AUTOEXTEND ON NEXT 655360  MAXSIZE 32767M;
  
	sed -i 's/^ //' /tmp/luo2.txt
```