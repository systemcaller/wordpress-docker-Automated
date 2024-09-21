#!/bin/bash

# 获取当前日期，格式为 yyyyMMdd
today=$(date +%Y%m%d)

# 显示提示信息并获取用户输入
echo "请输入要执行的操作："
echo "1. 执行备份"
echo "2. 执行恢复"
echo "ctrl c 退出"
read -p "请输入数字： " choice

# 验证日期格式的函数
validate_date() {
  local date="$1"
  # 简洁的正则表达式验证
  if [[ ! $date =~ ^[0-9]{4}(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[01])$ ]]; then
    return 1
  fi

  # 使用date命令直接判断闰年
  year=${date:0:4}
  month=${date:4:2}
  day=${date:6:2}
  if [[ $month -eq 2 && $day -eq 29 ]]; then
    if ! date -d "$year-$month-$day" >/dev/null 2>&1; then
      return 1
    fi
  fi
  return 0
}

case $choice in
  1)
    docker exec backup-wp backup
    echo "备份操作已完成。"
    ;;
  2)
    read -p "请输入要恢复的日期 (yyyyMMdd格式，例如 $today): " restore_date

    while ! validate_date "$restore_date"; do
      echo "日期格式错误，请重新输入（格式为yyyyMMdd）："
      read restore_date
    done

    docker exec backup-wp restore $restore_date
    echo "恢复操作已完成。$restore_date"
    ;;
  *)
    echo "输入无效，请重新输入。"
    ;;
esac
