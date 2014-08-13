### 用户，组管理

- 查看本机用户：
500以上的用户：`cat /etc/passwd |cut -f 1 -d :`

- 建立用户
```
USERNAME="chenshu"
mkdir -p /home/$USERNAME
useradd -d /home/$USERNAME $USERNAME
usermod -s /bin/bash $USERNAME
chown $USERNAME:$USERNAME -R /home/$USERNAME
passwd $USERNAME

USERNAME="fengxinping"
mkdir -p /letv/$USERNAME
useradd -d /letv/$USERNAME $USERNAME
usermod -s /bin/bash $USERNAME
chown $USERNAME:$USERNAME -R /letv/$USERNAME
passwd $USERNAME
```

### 配置文件

- /etc/group文件包含所有组 
- /etc/shadow和/etc/passwd系统存在的所有用户名 

### 如何限制用户的最小密码长度
修改/etc/login.defs里面的PASS_MIN_LEN的值。比如限制用户最小密码长度是8：
>PASS_MIN_LEN 8

### 如何使新用户首次登陆后强制修改密码
`useradd -p '' testuser; chage -d 0 testuser`
	
### 防止任何人使用su 命令成为root
```
emacs /etc/pam.d/su，在开头添加下面两行：
auth sufficient /lib/security/pam_rootok.so
auth required /lib/security/Pam_wheel.so group=wheel
然后把用户添加到"wheel"组：chmod -G10 usernam
```

### 设定登录黑名单
```
emacs /etc/pam.d/sshd
增加
auth required /lib/security/pam_listfile.so item=user sense=deny file=/etc/	sshd_user_deny_list onerr=succeed
所有/etc/sshd_user_deny_list里面的用户被拒绝ssh登录
```

### 禁止某个用户通过ssh登录
```
在/etc/ssh/sshd_conf添加
AllowUsers 用户名
或者
AllowGroups 组名
或者
DenyUsers 用户名
```

### 只允许某个IP登录，拒绝其他所有IP
```
在 /etc/hosts.allow 写:
sshd: 1.2.3.4
在 /etc/hosts.deny 写:
sshd: ALL
用 iptables 也行:
iptables -I INPUT -p tcp -dport 22 -j DROP
iptables -I INPUT -p tcp -dport 22 -s 1.2.3.4 -j ACCEPT
```

### 常用命令

- **whois**
- **whoami**
- **who** 目前登陆的人
    * -H或--heading 　显示各栏位的标题信息列。 
    * -i或-u或--idle 　显示闲置时间，若该用户在前一分钟之内有进行任何动作，将标示成"."号，如果该用户已超过24小时没有任何动作，则标示出"old"字符串。 
    * -m 　此参数的效果和指定"am i"字符串相同。 
    * -q或--count 　只显示登入系统的帐号名称和总人数。 
    * -s 　此参数将忽略不予处理，仅负责解决who指令其他版本的兼容性问题。 
    * -w或-T或--mesg或--message或--writable 　显示用户的信息状态栏。

- **w** [用户名称] ：显示目前登入系统的用户信息。 
    * -f 　开启或关闭显示用户从何处登入系统。 
    * -h 　不显示各栏位的标题信息列。 
    * -l 　使用详细格式列表，此为预设值。 
    * -s 　使用简洁格式列表，不显示用户登入时间，终端机阶段作业和程序所耗费的CPU时间。 
    * -u 　忽略执行程序的名称，以及该程序耗费CPU时间的信息。

- **finger** [选项] [使用者] [用户@主机] 
    * -s 显示用户的注册名、实际姓名、终端名称、写状态、停滞时间、登录时间等信息
    * -l 除了用-s选项显示的信息外，还显示用户主目录、登录shell、邮件状态等信息，以及用户主目录下的.plan、.project和.forward文件的内容。 
    * -p 除了不显示.plan文件和.project文件以外，与-l选项相同。

----

--EOF--