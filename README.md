# wordpress-docker-Automated
基于 docker-compose 部署的 wordpress 全自动管理脚本。支持自动备份，恢复。

# 快速开始
在开始前请确保你的服务器已经安装好了 docker 和 docker-compose 环境。

1. 将这些脚本文件下载到你的服务器任意目录下

2. 配置你自己的环境变量值，在 .env 文件中修改

`MYSQL_ROOT_PASSWORD` 这是你的数据库root用户密码

`MYSQL_DATABAS` 这是你的 wordpress 必须的数据库，给他取一个名字吧，建议用我设置的值 wordpress 

`MYSQL_USER` 这是为 wordpress 及其他服务访问数据库使用的一般用户名，设置一个你喜欢的

`DB_PASSWORD` 这是为这个一般用户设置一个密码吧

`MYSQL_PORT` 数据库的端口号，很抱歉现阶段设置这个是必须的，但是着并不意味着数据库端口号会被开放外部访问，它是安全的。不建议你修改它，除非你对自己有自信。 

`WORDPRESS_PATH`  为你的 wordpress 设置一个安装目录吧。目录必须以 `/` 开头的绝对路径，在这个目录下存储了你站点的全部用户数据。

3. 执行以下命令启动 docker 容器，请在 docker-compose.yaml 文件同路径下执行哟。
docker-compose up -d

4. 访问你的服务器公网ip ，即可看到 wordpress 注册登录页面了，开始你的建站之旅吧。

# 备份和恢复
默认情况下，backup-wp 容器会在每天凌晨 3 点备份。备份文件存储在 $WORDPRESS_PATH/backups-wp 目录下

你也可以手动备份，执行 backup.sh 脚本，根据提示即可完成手动备份。

同一天只会保留最新的一次备份记录。

恢复方法也是执行 backup.sh 脚本，根据提示即可完成恢复。

[恢复备份的源码是这位大牛提供的，非常感谢他。](https://github.com/angelo-v/wordpress-backup)

# 不同服务器的站点迁移

wordpress 在同服务器备份恢复过程中，不会有域名问题。所以我需要解决的就是跨服务器的迁移问题。

1. 首先备份原服务器，在 $WORDPRESS_PATH/backups-wp 目录下找到你的备份文件，同一天有2个文件。比如 backup_20240915.sql.bz2  backup_20240915.tar.gz ，前者是数据库备份，否则是 wordpress 备份。下载并上传到新的服务器。假设新服务器的公网 ip 是 192.168.1.7

2. 在新的服务器上，根据[快速开始](#快速开始)中的说明安装好，为了避免恢复失败，请不要注册，登录或者对新的站点做修改。只要验证通过公网ip  http://192.168.1.7:80 能访问就行。

3. 执行 backup.sh 脚本，根据提示即可完成恢复。通常恢复后无法用  http://192.168.1.7:80 访问了，因为备份中的站点还是原服务器的地址。

4. 执行 updateUri.sh 脚本，根据提示输入新服务器的公网ip地址，比如 http://192.168.1.7:80 ，端口号也要写哟。

5. 完成，验证下 http://192.168.1.7:80 能不能访问站点，已经恢复的数据是否正常。









