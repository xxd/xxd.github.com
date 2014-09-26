###Ruby常用

- 三元操作符
```Ruby
if boolean?
  do_one_thing
else
  do_something_else
end

Ruby 和其他很多语言一样（包括 C/C++，Perl，PHP 和 Java），提供了一种更为简单的表达式来替换这种流程控制结构——三元操作符（之所以起了这个名字，是因为三元操作符涉及三个部分）：

boolean? ? do_one_thing : do_something_else

def foo
  do_stuff
  boolean? ? "bar" : "baz"
end
```

```Ruby
>>> foo = [2, 18, 9, 22, 17, 24, 8, 12, 27]
>>> 
>>> print filter(lambda x: x % 3 == 0, foo)
[18, 9, 24, 12, 27]
>>> 
>>> print map(lambda x: x * 2 + 10, foo)
[14, 46, 28, 54, 44, 58, 26, 34, 64]
>>> 
>>> print reduce(lambda x, y: x + y, foo)
139

x=""
puts "x is not empty" if !x.empty?
x="a"
puts "x is not empty" if !x.empty?

string = "foobar"
puts "The string '#{string}' is nonempty." unless string.empty?

 ('a'..'z').to_a.shuffle[0..7].join  # 将取出的元素合并成字符串

 ###inspect用法
 >> puts (1..5).to_a            # 把数组作为字符串输出
1
2
3
4
5
>> puts (1..5).to_a.inspect    # 输出一个数组字面量形式
[1, 2, 3, 4, 5]
>> puts :name, :name.inspect
name
:name
>> puts "It worked!", "It worked!".inspect
It worked!
"It worked!"
>> flash = { success: "It worked!", error: "It failed." }
=> {:success=>"It worked!", :error=>"It failed."}
>> flash.each do |key, value|
?>   puts "Key #{key.inspect} has value #{value.inspect}"
>> end
```

```Ruby
pattern = Regexp.new(ARGV[0])
filename = ARGV[1]

file = open(filename)
while text = file.get do
	if pattern =~ text
		print t
	end
end
file.close
``` 

将英文文本中出现最多的10个单词进行输出
	$ cat xdict_1.1.txt | tr -s ' ' '\n' | sort | uniq -c | sort -rn | head -n 10
```Ruby
   1 中国人民政治协商会议	1428
   1 中华人民共和国海关	1484
   1 中国石油天然气公司	1480
   1 中华人民共和国政府	1477
   1 中国科学技术出版社	1461
   1 中国石油天然气集团	1461
   1 重庆经济技术开发区	1453
   1 中国互联网信息中心	1445
   1 北京科学技术出版社	1442
   1 中国人民大学出版社	1442
```

#### 第五章 条件判断

if | unless | case

####unless
```Ruby
a = 10
b = 20
unless a > b
	print "a 并不比 b 大\n"
end
```

#### 第六章 循环
times | for..in | while | until | each | collect | loop |

4.times {
	print "打印四次\n"
}

##### each和collect区别
each 与 collect都进行了block参数得操作 
区别 each返回调用者，collect返回的是计算后得到的新的collection 
不过 两者都不会改变调用者原始值

以下是each 
```Ruby
irb(main):003:0> array=[1,2,3,4,5] 
=> [1, 2, 3, 4, 5] 
irb(main):004:0> array.each {|x| puts x} 
1 
2 
3 
4 
5 
=> [1, 2, 3, 4, 5] 
```
以下是collect 
```Ruby
irb(main):005:0> (1..4).collect {|x| puts x} 
1 
2 
3 
4 
=> [nil, nil, nil, nil] 
这里的(1..4)是enumerable，由于collect返回的是计算后得到的值，但是这里没有计算后得到的值，所以返回nil。
```
下边看一个有计算后得到值的例子，看看返回什么
```Ruby
irb(main):006:0> arr1 = [1,2,3] 
=> [1, 2, 3] 
irb(main):007:0> arr1.each {|i| i*=2 } 
=> [1, 2, 3] 

irb(main):008:0> arr1.each {|i| puts i*2 } 
2 
4 
6 
=> [1, 2, 3] 

------------------------------------------------------ 
arr2 = [1,2,3] 
irb(main):010:0> arr2.collect {|i| i*2 } 
=> [2, 4, 6] 
```

#####循环控制
break | next | redo 
```Ruby
i = 0
["Perl","Python","Ruby","shceme"].each {|lang|
	i += 1
	if i == 3
		redo #这里可以替换成break, next
	end
	print [i, lang]
}

结果
break：
[1, "Perl"]
[2, "Python"]

next:
[1, "Perl"]
[2, "Python"]
[4, "scheme"]

redo:
[1, "Perl"]
[2, "Python"]
[4, "Ruby"]
[5, "scheme"]
```

####第七章 方法Method
##### 实例方法 instance Method
	"10,20,30,40".split(",")
	[1,2,3,4].index(2)
	1000.integer?

##### 类方法 class Method
	a = Array.new
	file.get
	Time.now

##### 函数方法 function Method
	sin(3.14)
	print "hello!"

####第八章 类Class
```Ruby
class String
	def count_word
		ary = self.split(/\s+/)
		return ary.size
	end
end

str = "Just Another Ruby Newbie"
p str.count_word
```


#### 正则
	空白行 /^\s*$/
	#号开头 /^#/
	以空白来分隔 split(/\s+/)


#### Array和Hash的一些操作
```Ruby
def show
  # 下边这个@question是array，所有的find和find_by_id或者find_by_xxx返回的都是array
  # 还有一种查询方式是a = User.where("id=4813729731435734") 或者 a = User.where(:id => 4813729731435734),
  # a的类型是ActiveRecord::Relation
  @question = Question.find params[:id]
  
  #下边是把Array转换为Hash
  q_hash = @question.serializable_hash
  # 然后合并两个Hash
  q_data = q_hash.merge! User.basic_hash @question.user_id

  answers = Answer.where(:question_id => params[:id])
  # 以下就是把每一个问题都和回答它的用户信息拼接起来
  a_hash = answers.collect{ |answer| answer.serializable_hash.merge!(User.basic_hash answer.user_id)}
  q_data = q_data.merge!({:answers => a_hash})
  
  # include参数表示也一并到answer和comment表把这个question_id的纪录也一并select出来
  @question = Question.find(params[:id], :include => [:answers, :comments])
  answers = Answer.find(:all, :include => [:user, :comments], :conditions =>["question_id = ?", params[:id]])
  a_hash = answers.collect{ |answer| answer.serializable_hash.merge!(User.basic_hash answer.user_id)}
  q_data = q_data.merge!({:answers => a_hash})
  respond_to do |format|
    format.html
    format.json { render :json => q_data, :status => :ok } 
  end
end
```
以下是上边一些重要步骤在rails c中操作的结果
```Ruby
ruby-1.9.2-p290 :025 > @question = Question.find_by_id(1260181844536139)
  Question Load (1.6ms)  SELECT `questions`.* FROM `questions` WHERE `questions`.`id` = 1260181844536139 LIMIT 1
 => #<Question id: 1260181844536139, user_id: 7635744011930656, title: "坝上哪个地段风光适宜摄影爱好者旅游", content: "过几天想去坝上，请问坝上哪个地段风光适宜摄影爱好者旅游拍片？谢谢！", credit: #<BigDecimal:7fae76ea74b0,'0.0',9(18)>, end_date: "2011-12-25 08:45:51", votes_count: 0, answers_count: 4, comments_count: 0, correct_answer_id: 0, followed_questions_count: 0, created_at: "2011-11-22 08:35:43", updated_at: "2011-11-22 08:45:51", favorite_questions_count: 0, category_id: 3, is_complete: true, markdown: nil> 
 
ruby-1.9.2-p290 :026 > q_hash = @question.serializable_hash
 => {"answers_count"=>4, "category_id"=>3, "comments_count"=>0, "content"=>"过几天想去坝上，请问坝上哪个地段风光适宜摄影爱好者旅游拍片？谢谢！", "correct_answer_id"=>0, "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "credit"=>#<BigDecimal:7fae76ea74b0,'0.0',9(18)>, "end_date"=>Sun, 25 Dec 2011 16:45:51 CST +08:00, "favorite_questions_count"=>0, "followed_questions_count"=>0, "id"=>1260181844536139, "is_complete"=>true, "markdown"=>nil, "title"=>"坝上哪个地段风光适宜摄影爱好者旅游", "updated_at"=>Tue, 22 Nov 2011 16:45:51 CST +08:00, "user_id"=>7635744011930656, "votes_count"=>0} 
 
ruby-1.9.2-p290 :027 > q_data = q_hash.merge! User.basic_hash @question.user_id
  User Load (0.5ms)  SELECT id, name FROM `users` WHERE `users`.`id` = 7635744011930656 LIMIT 1
 => {"answers_count"=>4, "category_id"=>3, "comments_count"=>0, "content"=>"过几天想去坝上，请问坝上哪个地段风光适宜摄影爱好者旅游拍片？谢谢！", "correct_answer_id"=>0, "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "credit"=>#<BigDecimal:7fae76ea74b0,'0.0',9(18)>, "end_date"=>Sun, 25 Dec 2011 16:45:51 CST +08:00, "favorite_questions_count"=>0, "followed_questions_count"=>0, "id"=>1260181844536139, "is_complete"=>true, "markdown"=>nil, "title"=>"坝上哪个地段风光适宜摄影爱好者旅游", "updated_at"=>Tue, 22 Nov 2011 16:45:51 CST +08:00, "user_id"=>7635744011930656, "votes_count"=>0, :user=>{"id"=>7635744011930656, "name"=>"陈浩"}} 
 
ruby-1.9.2-p290 :028 > answers = Answer.where(:question_id =>1260181844536139)
  Answer Load (1.9ms)  SELECT `answers`.* FROM `answers` WHERE `answers`.`question_id` = 1260181844536139
 => [#<Answer id: 3221973916623096, user_id: 1445448313056813, question_id: 1260181844536139, content: "请教一下坝上具体指的是什么地方", is_correct: false, votes_count: 0, comments_count: 0, created_at: "2011-11-22 08:35:43", updated_at: "2011-11-22 08:35:43", is_complete: true, markdown: nil>, #<Answer id: 2400715422522302, user_id: 1445448313056813, question_id: 1260181844536139, content: "请教一下坝上具体指的是什么地方椰奶咖啡 发表于 2010-8-9 23:16 \n据百度百科介绍：", is_correct: false, votes_count: 0, comments_count: 0, created_at: "2011-11-22 08:35:43", updated_at: "2011-11-22 08:35:43", is_complete: true, markdown: nil>, #<Answer id: 2706318822816496, user_id: 1445448313056813, question_id: 1260181844536139, content: "谢谢了，受益匪浅。", is_correct: false, votes_count: 0, comments_count: 0, created_at: "2011-11-22 08:35:43", updated_at: "2011-11-22 08:35:43", is_complete: true, markdown: nil>, #<Answer id: 2168847328629188, user_id: 1445448313056813, question_id: 1260181844536139, content: "坝上秋色，晚段时间再去吧", is_correct: false, votes_count: 0, comments_count: 0, created_at: "2011-11-22 08:35:43", updated_at: "2011-11-22 08:35:43", is_complete: true, markdown: nil>] 
 
ruby-1.9.2-p290 :029 > a_hash = answers.collect{ |answer| answer.serializable_hash.merge!(User.basic_hash answer.user_id)}
  User Load (0.6ms)  SELECT id, name FROM `users` WHERE `users`.`id` = 1445448313056813 LIMIT 1
  User Load (0.3ms)  SELECT id, name FROM `users` WHERE `users`.`id` = 1445448313056813 LIMIT 1
  User Load (0.3ms)  SELECT id, name FROM `users` WHERE `users`.`id` = 1445448313056813 LIMIT 1
  User Load (0.2ms)  SELECT id, name FROM `users` WHERE `users`.`id` = 1445448313056813 LIMIT 1
 => [{"comments_count"=>0, "content"=>"请教一下坝上具体指的是什么地方", "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "id"=>3221973916623096, "is_complete"=>true, "is_correct"=>false, "markdown"=>nil, "question_id"=>1260181844536139, "updated_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "user_id"=>1445448313056813, "votes_count"=>0, :user=>{"id"=>1445448313056813, "name"=>"陈政宇"}}, {"comments_count"=>0, "content"=>"请教一下坝上具体指的是什么地方椰奶咖啡 发表于 2010-8-9 23:16 \n据百度百科介绍：", "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "id"=>2400715422522302, "is_complete"=>true, "is_correct"=>false, "markdown"=>nil, "question_id"=>1260181844536139, "updated_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "user_id"=>1445448313056813, "votes_count"=>0, :user=>{"id"=>1445448313056813, "name"=>"陈政宇"}}, {"comments_count"=>0, "content"=>"谢谢了，受益匪浅。", "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "id"=>2706318822816496, "is_complete"=>true, "is_correct"=>false, "markdown"=>nil, "question_id"=>1260181844536139, "updated_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "user_id"=>1445448313056813, "votes_count"=>0, :user=>{"id"=>1445448313056813, "name"=>"陈政宇"}}, {"comments_count"=>0, "content"=>"坝上秋色，晚段时间再去吧", "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "id"=>2168847328629188, "is_complete"=>true, "is_correct"=>false, "markdown"=>nil, "question_id"=>1260181844536139, "updated_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "user_id"=>1445448313056813, "votes_count"=>0, :user=>{"id"=>1445448313056813, "name"=>"陈政宇"}}] 

ruby-1.9.2-p290 :030 > q_data = q_data.merge!({:answers => a_hash})
 => {"answers_count"=>4, "category_id"=>3, "comments_count"=>0, "content"=>"过几天想去坝上，请问坝上哪个地段风光适宜摄影爱好者旅游拍片？谢谢！", "correct_answer_id"=>0, "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "credit"=>#<BigDecimal:7fae76ea74b0,'0.0',9(18)>, "end_date"=>Sun, 25 Dec 2011 16:45:51 CST +08:00, "favorite_questions_count"=>0, "followed_questions_count"=>0, "id"=>1260181844536139, "is_complete"=>true, "markdown"=>nil, "title"=>"坝上哪个地段风光适宜摄影爱好者旅游", "updated_at"=>Tue, 22 Nov 2011 16:45:51 CST +08:00, "user_id"=>7635744011930656, "votes_count"=>0, :user=>{"id"=>7635744011930656, "name"=>"陈浩"}, :answers=>[{"comments_count"=>0, "content"=>"请教一下坝上具体指的是什么地方", "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "id"=>3221973916623096, "is_complete"=>true, "is_correct"=>false, "markdown"=>nil, "question_id"=>1260181844536139, "updated_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "user_id"=>1445448313056813, "votes_count"=>0, :user=>{"id"=>1445448313056813, "name"=>"陈政宇"}}, {"comments_count"=>0, "content"=>"请教一下坝上具体指的是什么地方椰奶咖啡 发表于 2010-8-9 23:16 \n据百度百科介绍：", "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "id"=>2400715422522302, "is_complete"=>true, "is_correct"=>false, "markdown"=>nil, "question_id"=>1260181844536139, "updated_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "user_id"=>1445448313056813, "votes_count"=>0, :user=>{"id"=>1445448313056813, "name"=>"陈政宇"}}, {"comments_count"=>0, "content"=>"谢谢了，受益匪浅。", "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "id"=>2706318822816496, "is_complete"=>true, "is_correct"=>false, "markdown"=>nil, "question_id"=>1260181844536139, "updated_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "user_id"=>1445448313056813, "votes_count"=>0, :user=>{"id"=>1445448313056813, "name"=>"陈政宇"}}, {"comments_count"=>0, "content"=>"坝上秋色，晚段时间再去吧", "created_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "id"=>2168847328629188, "is_complete"=>true, "is_correct"=>false, "markdown"=>nil, "question_id"=>1260181844536139, "updated_at"=>Tue, 22 Nov 2011 16:35:43 CST +08:00, "user_id"=>1445448313056813, "votes_count"=>0, :user=>{"id"=>1445448313056813, "name"=>"陈政宇"}}]} 

ruby-1.9.2-p290 :032 > @question = Question.find_by_id(1260181844536139, :include => [:answers, :comments])
  Question Load (1.1ms)  SELECT `questions`.* FROM `questions` WHERE `questions`.`id` = 1260181844536139 LIMIT 1
  Answer Load (1.1ms)  SELECT id, user_id, question_id, content, is_correct, votes_count, comments_count, created_at, markdown FROM `answers` WHERE `answers`.`question_id` IN (1260181844536139)
  User Load (0.5ms)  SELECT id, name, credit, reputation, about_me, avatar_url FROM `users` WHERE `users`.`id` IN (1445448313056813)
  Photo Load (0.8ms)  SELECT id, magic_id, salt, caption, image FROM `photos` WHERE `photos`.`magic_id` IN (3221973916623096, 2400715422522302, 2706318822816496, 2168847328629188)
  Comment Load (0.7ms)  SELECT id, user_id, magic_id, name, content, created_at FROM `comments` WHERE `comments`.`magic_id` IN (1260181844536139) ORDER BY created_at DESC
 => #<Question id: 1260181844536139, user_id: 7635744011930656, title: "坝上哪个地段风光适宜摄影爱好者旅游", content: "过几天想去坝上，请问坝上哪个地段风光适宜摄影爱好者旅游拍片？谢谢！", credit: #<BigDecimal:7fae76961000,'0.0',9(18)>, end_date: "2011-12-25 08:45:51", votes_count: 0, answers_count: 4, comments_count: 0, correct_answer_id: 0, followed_questions_count: 0, created_at: "2011-11-22 08:35:43", updated_at: "2011-11-22 08:45:51", favorite_questions_count: 0, category_id: 3, is_complete: true, markdown: nil> 
```

以前收集的一些笔记
### map, %w
```Ruby
 (1..5).map { |i| i**2 }          # The ** notation is for 'power'.
= [1, 4, 9, 16, 25]

 %w[a b c]                        # Recall that %w makes string arrays.
= ["a", "b", "c"]

 %w[a b c].map { |char| char.upcase }
= ["A", "B", "C"]

 addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
= ["user@foo.com", "THE_USER@foo.bar.org", "first.last@foo.jp"]

 addresses.each do |address|
?   puts address
 end
user@foo.com
THE_USER@foo.bar.org
first.last@foo.jp

```

```Ruby
 ('a'..'z').to_a                     # An alphabet array
= ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
"p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
 ('a'..'z').to_a.shuffle             # Shuffle it.
= ["c", "g", "l", "k", "h", "z", "s", "i", "n", "d", "y", "u", "t", "j", "q",
"b", "r", "o", "f", "e", "w", "v", "m", "a", "x", "p"]
 ('a'..'z').to_a.shuffle[0..7]       # Pull out the first eight elements.
= ["f", "w", "i", "a", "h", "p", "c", "x"]
 ('a'..'z').to_a.shuffle[0..7].join  # Join them together to make one string.
= "mznpybuj"

 flash = { :success = "It worked!", :error = "It failed. :-(" }
= {:success="It worked!", :error="It failed. :-("}
 flash.each do |key, value|
?   puts "Key #{key.inspect} has value #{value.inspect}"
 end
Key :success has value "It worked!"
Key :error has value "It failed. :-("
```

### String Array Hash
``` Ruby
 s = String.new("foobar")   # A named constructor for a string
= "foobar"
 s.class
= String
 s == "foobar"
= true

 a = Array.new([1, 3, 2])
= [1, 3, 2]
Hashes, in contrast, are different. While the array constructor Array.new takes an initial value for the array, Hash.new takes a default value for the hash, which is the value of the hash for a nonexistent key:

 h = Hash.new
= {}
 h[:foo]            # Try to access the value for the nonexistent key :foo.
= nil
 h = Hash.new(0)    # Arrange for nonexistent keys to return 0 instead of nil.
= {}
 h[:foo]
= 0
```

```ruby
###printing: the most commonly used Ruby function is puts (pronounced “put ess”, for “put string”)
 puts "foo"     # put string
foo
= nil
 print "foo"    # print string (same as puts, but without the newline)
foo= nil
 print "foo\\n"  # Same as puts "foo"
foo
= nil

###to_s
 nil.to_s
= ""
 nil.to_s.empty?
= true

###about the veriable
 @title       # An instance variable in the console
= nil
 puts "There is no such instance variable." if @title.nil?
There is no such instance variable.
= nil
 "#{@title}"  # Interpolating @title when it's nil
= ""

 string = "foobar"
 puts "The string '#{string}' is nonempty." unless string.empty?
The string 'foobar' is nonempty.
= nil

###arrays
 a = [8, 17, 42]
 a.sort
= [8, 17, 42]
 a.reverse
= [17, 8, 42]
 a.shuffle
= [17, 42, 8]
You can also add to arrays with the push method or its equivalent operator, \u3c00\u3c00:
 a.push(6)                  # Pushing 6 onto an array
= [42, 8, 17, 6]
 a \u3c00\u3c00 7                     # Pushing 7 onto an array
= [42, 8, 17, 6, 7]
 a \u3c00\u3c00 "foo" \u3c00\u3c00 "bar"        # Chaining array pushes
= [42, 8, 17, 6, 7, "foo", "bar"]
 a
= [42, 8, 17, 7, "foo", "bar"]
 a.join                       # Join on nothing
= "428177foobar"
 a.join(', ')                 # Join on comma-space
= "42, 8, 17, 7, foo, bar"

 (0..9).to_a            # Use parentheses to call to_a on the range
= [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
 a = %w[foo bar baz quux]         # Use %w to make a string array.
= ["foo", "bar", "baz", "quux"]
 a[0..2]
= ["foo", "bar", "baz"]
 ('a'..'e').to_a
= ["a", "b", "c", "d", "e"]

### Blocks
 (1..5).each { |i| puts 2 * i }
2
4
6
8
10
= 1..5

 (1..5).each do |number|
?   puts 2 * number
   puts '--'
 end
2
--
4
--
6
--
8
--
10
--
= 1..5

 ('a'..'z').to_a                     # An alphabet array
= ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
"p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
 ('a'..'z').to_a.shuffle             # Shuffle it.
= ["c", "g", "l", "k", "h", "z", "s", "i", "n", "d", "y", "u", "t", "j", "q",
"b", "r", "o", "f", "e", "w", "v", "m", "a", "x", "p"]
 ('a'..'z').to_a.shuffle[0..7]       # Pull out the first eight elements.
= ["f", "w", "i", "a", "h", "p", "c", "x"]
 ('a'..'z').to_a.shuffle[0..7].join  # Join them together to make one string.
= "mznpybuj"

 puts (1..5).to_a            # Put an array as a string.
1
2
3
4
5
 puts (1..5).to_a.inspect    # Put a literal array.
[1, 2, 3, 4, 5]

class Word \u3c00 String             # Word inherits from String.
  def palindrome?
    self == self.reverse        # self is the string itself.
  end
end

def array_method
  if self=='split'
    self.split
  elsif self=='shuffle'
    self.shuffle
  else self=='join'
    self.join
  end
end 


def array_method(s)
  if s=='split'
    print s
    s.split('')
  elsif s=='shuffle'
    print s
    s.split('').shuffle
  else s=='join'
    print s
    s.join(', ')
  end
end

### hash password
   password = "secret"
  = "secret"
   encrypted_password = secure_hash(password)
  = "2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b"
   submitted_password = "secret"
  = "secret"
   encrypted_password == secure_hash(submitted_password)
  = true
   secure_hash("second") == hash
  = false
   secure_hash("secret") == hash
  = true
  #------------------
   Time.now.utc
  = Thu Jul 21 03:41:49 UTC 2011
   password = "secret"
  = "secret"
   salt = secure_hash("#{Time.now.utc}--#{password}")
  = "be087c24bb12fa940759e28871a4ecb1d3573f4c95b4a4eb453c3a4d96aeec44"

-------Function, Class, Module---------
  1 function
  def  say_hello(name)
      result="hello,"+name
      return result
  end
  puts say_hello("oec2003")    #返回hello,oec2003
 
  2 class
  class Oec2003
  end
 
  在rails中类通常都会继承Base基类
  class Oec2003\u3c00ActiveRecord::Base
  end
  表示Oec2003继承Base基类\u0cffruby中的继承是用\u3c00实现\u0cffBase基类属于模块ActiveRecord中
  ruby类中的方法可以加访问修饰符来限制访问级别
  class Oec2003
      def method1        #没有加任何修饰符\u0cff默认为public
      end
     
      protected
      def method2     #修饰符为proteted \u0cff注意修饰符是写在方法的上面
      end
 
      private
      def method3
      end
  end
 
  3 module 模块
  模块和类有点相似\u0cff他们都包含一组方法\u0cff常量以及其他的类和模块的定义\u0cff和类不同的是模块不能创建实例。
 
  模块的用途有两个。第一\u1aff起到了命名空间的作用\u0cff使方法的名字不会冲突。第二\u1aff可以使在不同类之间共享同样的功能。如果一个类混入了一个模块\u0cff那么这个类就拥有模块中所有的实例方法\u0cff就好像是在类中定义的一样
  module  Oec2003
  End
 
  include主要用来将一个模块插入\u08ffmix\u09ff到一个类或者其它模块。
  extend 用来在一个对象\u08ffobject\u0cff或者说是instance\u09ff中引入一个模块\u0cff这个类从而也具备了这个模块的方法。
  通常引用模块有以下3种情况\u1aff
  1.在类定义中引入模块\u0cff使模块中的方法成为类的实例方法
  这种情况是最常见的
  直接 include \u3c00module name即可
 
  2.在类定义中引入模块\u0cff使模块中的方法成为类的类方法
  这种情况也是比较常见的
  直接 extend \u3c00module name即可
 
  3.在类定义中引入模块\u0cff既希望引入实例方法\u0cff也希望引入类方法
  这个时候需要使用 include,
 
--------------条件判断语句--------------
  条件中判断是否相等使用==\u0cff注意不要写成了=
  1 if..elsif..else..end
  if  count10
      puts  "count 大于10"
  elsif count==10       #注意此处是elsif  而不是elseif
      puts "count等于10"
  else
      puts "count小于10"
  end
 
  2. while循环
  while  age\u3c0030
      puts age
     age=+1
  end
 
  3. 单行while
  age=age+1 while age\u3c0030
 
  4. until 循环
  a=1
  until a=10
    puts a
    a+=1
  end
 
  5. for..in..循环
  for i in 1..9
     puts i,""
  end
 
  中间还可以穿插
  break 跳出当层循环
  next   忽略本次循环的剩余部分\u0cff开始下一次的循环
  redo   重新开始循环\u0cff还是从这一次开始
  retry  重头开始这个循环体
  times  3.times { print "Hi!" } #Hi!Hi!Hi!
  upto   1.upto(9) {|i| print i if i\u3c007 } #123456
  downto 9.downto(1){|i| print i if i\u3c007 } #654321
  each   (1..9).each {|i| print i if i\u3c007} #123456
  step   0.step(11,3) {|i| print i } #0369
```

--EOF--