#!/usr/bin/env python3
import sys
import os
import shutil
from datetime import datetime, timedelta
import webbrowser
from urllib.parse import quote
import re
import json


def open_url(url):
    # 打开 URL
    webbrowser.open(url)


# 获取命令行参数
query = sys.argv[1]

# 获取周数和其他参数
week_num, *other_args = query.split(',')

# 设置文件路径
tempPath = "/Users/wangzhifeng/Library/Mobile Documents/iCloud~md~obsidian/Documents/Base/99_template/"
template = tempPath + "00_周记模板.md"
destination = "/Users/wangzhifeng/Library/Mobile Documents/iCloud~md~obsidian/Documents/Base/01_Base/04_日记/01_周记/"

# 获取当前日期
nowdate = datetime.now().strftime("%Y-%m-%d")
preday = (datetime.now() - timedelta(days=1)).strftime("%Y-%m-%d")
year = datetime.now().strftime("%Y年")
year_ = datetime.now().strftime("%Y")

file_name = year + "第" + week_num + "周周记"
month = datetime.now().strftime("%Y年%m")
tempfilename = tempPath + file_name + ".md"
filename = destination + file_name + ".md"

# 替换模板中的内容
if not os.path.exists(filename):
    shutil.copy(template, tempfilename)
    with open(tempfilename, 'r') as file:
        filedata = file.read()
    filedata = filedata.replace("<% tp.date.now(\"YYYY\")%>", year_)
    filedata = filedata.replace("<% tp.date.now(\"YYYY年MM\")%>", month)
    filedata = filedata.replace("<% tp.date.now(\"WW\")%>", week_num)
    with open(tempfilename, 'w') as file:
        file.write(filedata)
        shutil.move(tempfilename, filename)
        # time.sleep(1)
else:
    print("文件已存在")


# 打开文件并读取内容
with open(filename, 'r') as file:
    lines = file.readlines()

# 将 lines 转换为字符串
content = ''.join(lines)

# 将 *other_args 转换为字符串
other_args_str = ' '.join(other_args)

print(other_args_str)

# 找到 "## 本周总结" 或 "## Weekly Review" 以下的所有内容，并替换为 *other_args_str
new_content = re.sub(r'(## 本周总结|## Weekly Review).*', '', content, flags=re.DOTALL)
new_content += '\n\n' + other_args_str

# 将修改后的内容写回文件
with open(filename, 'w') as file:
    file.write(new_content)
    

# 原始 URL
file_name_url = quote(file_name + '.md')
url = 'obsidian://open?vault=Base&file=01_Base%2F04_%E6%97%A5%E8%AE%B0%2F01_%E5%91%A8%E8%AE%B0%2F' + file_name_url


# 使用示例
open_url(url)