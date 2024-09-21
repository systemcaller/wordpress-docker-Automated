#!/bin/bash

# 加载 .env 文件获取环境变量
source .env

# 提示用户输入站点地址
read -p "请输入要修改的站点地址： " site_url

# 转义特殊字符（如果需要）
# site_url_escaped=$(echo "$site_url" | sed "s/'/'\\\\''/g")
printf "$MYSQL_DATABASE"

# 构造 SQL 语句
sql="UPDATE $MYSQL_DATABASE.wp_options SET option_value='$site_url' WHERE option_id IN (2, 3);"

# 打印即将执行的SQL命令
printf "即将执行的SQL命令：\n%s\n" "$sql"

# 执行 SQL 语句
docker exec mysql mysql -u $MYSQL_USER -p$DB_PASSWORD -e "$sql" 2>/dev/null

# 检查执行结果
if [ $? -eq 0 ]; then
  echo "站点地址更新成功！"

  # 查询更新后的结果
  query_sql="SELECT option_name, option_value FROM $MYSQL_DATABASE.wp_options WHERE option_id IN (2, 3);"
  query_result=$(docker exec mysql mysql -u $MYSQL_USER -p$DB_PASSWORD -e "$query_sql")
  echo "更新后的结果："
  echo "$query_result"
else
  echo "站点地址更新失败，请检查数据库连接和SQL语句。"
fi
