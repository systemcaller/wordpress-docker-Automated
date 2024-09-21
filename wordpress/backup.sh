#!/bin/bash

# 获取当前日期，格式为 yyyyMMdd
today=$(date +%Y%m%d)

# 显示提示信息并获取用户输入
echo "请输入要执行的操作："
echo "1. 执行备份"
echo "2. 执行恢复"
read -p "请输入数字： " choice

# 根据用户输入执行对应命令
case $choice in
    1)
    #    docker exec backup-wp backup
        echo "备份操作已完成。"
        ;;
    2
        read -p "请输入要恢复的日期 (yyyyMMdd格式，例如 $today): " restore_date

        # 验证日期格式和有效性
        while true; do
            # 检查是否为8位数字
            if [[ ! $restore_date =~ ^[0-9]{8}$ ]]; then
                echo "日期格式错误，请重新输入（格式为yyyyMMdd）："
                read restore_date
                continue
            fi

            # 分解日期，检查月和日的范围
            year=${restore_date:0:4}
            month=${restore_date:4:2}
            day=${restore_date:6:2}
            if [[ $month -lt 1 || $month -gt 12 || $day -lt 1 || $day -gt 31 ]]; then
                echo "日期无效，请重新输入（格式为yyyyMMdd）："
                read restore_date
                continue
            fi

            # 检查闰年
            if [[ $month -eq 2 ]]; then
                if [[ $((year % 4)) -ne 0 || ($((year % 100)) -eq 0 && $((year % 400)) -ne 0) ]]; then
                    if [[ $day -gt 28 ]]; then
                        echo "闰年2月最多28天，请重新输入："
                        read restore_date
                        continue
                    fi
                else
                    if [[ $day -gt 29 ]]; then
                        echo "闰年2月最多29天，请重新输入："
                        read restore_date
                        continue
                    fi
                fi
            fi

            # 所有检查通过，退出循环
            break
        done

     #   docker exec backup-wp restore $restore_date
        echo "恢复操作已完成。$restore_date"
        ;;
    *)
        echo "输入无效，请重新输入。"
        ;;
esac
