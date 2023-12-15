#!/bin/bash
#一旦某行出错则停止
set -e

query=$1
# query="0,234"
IFS=',' read -r yesterday query <<< "$query"


template=/Users/wangzhifeng/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Base/99_template/tp_journal.md
destination=/Users/wangzhifeng/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Base/01_Base/04_日记/
# 等号两边不能有空格，之前错误一直出在这里

if [ "$yesterday" -eq 1 ]; then
    nowdate=$(date -v-1d +%Y-%m-%d)
    preday=$(date -v-2d +%Y-%m-%d)
    week=$(date -v-1d +%Y年%U周)
else
    nowdate=$(date +%Y-%m-%d)
    preday=$(date -v-1d +%Y-%m-%d)
    week=$(date +%Y年%U周)
fi
echo "Nowdate: $nowdate"
echo "Preday: $preday"
echo "Week: $week"
filename="$destination"$nowdate.md


openURL(){
	open "obsidian://advanced-uri?vault=Base&filepath=01_Base%252F04_%25E6%2597%25A5%25E8%25AE%25B0%252F"$nowdate.md
}

if [ -f "$filename" ]; then
    
    # 获取包含 'Tyme' 的行号
    number=$(grep -n 'Tyme' "$filename" | cut -d: -f1)
    number=$(($number+1))
    # 使用 sed 删除从行号到文件末尾的内容
    sed -ie "${number},\$d" "$filename"
    # 删除文件
	rm -rf "$destination"$nowdate.mde
    printf "$query" >> "$filename"
    openURL
else
    cp "$template" "$filename"

	old_word="YYYY-MM-DD"
	new_word=$preday

	oldweek="YYYY年第WW周"
	newweek=$week

	sed -ie "s/$old_word/$new_word/g; s/$oldweek/$newweek/; " "$filename"
	rm -rf "$destination"$nowdate.mde
	openURL
fi