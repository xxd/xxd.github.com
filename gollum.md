#### 1.安装
```
apt-get install ruby ruby-dev make
apt-get install nodejs 
apt-get install libicu-dev
apt-get install inotify-tools
gem install gollum
gem install redcarpet #markdown support
#gem install github-markdown #github-markdown support
pip install Pygments #代码高亮需要
gem install org-ruby
```

#### 图片(https://github.com/mojombo/gollum-demo/blob/master/Mordor/Eye-Of-Sauron.md)
`![Alt attribute text Here](images/YOURIMAGE.ext)`

#### sync.sh
```ruby
#!/bin/bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(cd $DIR && git pull)
```

#### gitmonitor.sh (http://blog.bigcay.com/blog/2013/04/30/Upload-Images-To-Gollum/)
```ruby
#!/bin/bash

UPLOAD_PATH=/root/xxd.github.com/upload

while inotifywait -q -r -e ATTRIB,CLOSE_WRITE,CREATE,DELETE  $UPLOAD_PATH; do
  cd $UPLOAD_PATH
  git add -A
  git commit -a -m 'Commit to Git repository automatically.'
done
```

#### Todo:
- 直接pow來啓動gollum就行了，幾乎不用config。

#### 参考:
- https://gist.github.com/SaitoWu/3300447
- https://github.com/dudarev/wiki/wiki/Wiki-Usage
- https://github.com/gollum/gollum
- http://www.nomachetejuggling.com/2012/05/15/personal-wiki-using-github-and-gollum-on-os-x/
