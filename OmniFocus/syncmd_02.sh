#!/bin/bash
#一旦某行出错则停止
set -e

query="$1"  # 假设 query 是从命令行参数获取的

# 获取第一个逗号前的数字
week_num=$(echo $query | cut -d',' -f1)
echo "Number: $number"


# 删除第一个逗号及其前面的所有内容
str=${query#*,}
str=${str:1}
tempPath=/Users/wangzhifeng/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Base/99_template/
template="$tempPath"00_周记模板.md
destination=/Users/wangzhifeng/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Base/01_Base/04_日记/01_周记/


# 等号两边不能有空格，之前错误一直出在这里

nowdate=$(date "+%Y-%m-%d") 
preday=$(date -v-1d "+%Y-%m-%d") 
year=$(date "+%Y年")
file_name=$year"第"$week_num"周周记"
month=$(date "+%Y年%m月")
tempfilename="$tempPath"$file_name.md
filename="$destination"$file_name.md
week_old="<% tp.date.now("WW")%>"

openURL(){
	open "obsidian://advanced-uri?vault=Base&filepath=01_Base%252F04_%25E6%2597%25A5%25E8%25AE%25B0%252F01_%25E5%2591%25A8%25E8%25AE%25B0%252F"$file_name.md
}

if [ ! -f "$tempfilename" ]; then
	cp -n "$template" "$tempfilename"
	okr="<% tp.date.now(\"YYYY\")%>"
    new_okr=$year
    month_old="<% tp.date.now(\"YYYY年MM\")%>"
    new_month=$month
    week="<% tp.date.now(\"WW\")%>"
    new_week=$week_num
    echo "OKR: $okr"
    echo "Month old: $month_old"
    echo "Week——old: $week_old"
    echo "New OKR: $new_okr"
    echo "New month: $new_month"
    echo "Week num: $week_num"
    echo "Filename: $filename"

    ls -l "$tempfilename"
    awk -v okr="$okr" -v new_okr="$new_okr" -v month_old="$month_old" -v new_month="$new_month" -v week="$week" -v new_week="$new_week" '{gsub(okr, new_okr); gsub(month_old, new_month); gsub(week, new_week); print}' "$tempfilename" > temp && mv temp "$tempfilename"
else
	echo "文件已存在"
fi

rm -rf "$destination"$nowdate.mde
openURL