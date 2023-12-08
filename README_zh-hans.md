# alfred-workflows-tyme-starttask-serach

## Tyme

### Tyme Start

开始Tyme计时，并计时25分钟；

ts 跟随 Tyme Task 名称，选择执行；

keyword: ts 

![image.png](https://pazer-markdown.oss-cn-beijing.aliyuncs.com/img20231103103731.png)

serach:

![image.png](https://pazer-markdown.oss-cn-beijing.aliyuncs.com/img20231103103825.png)

可以搜索对应名称，选择后开始计时；

### Tyme Stop

停止Tyme计时；

keyword: tst

### Tyme Restart

在没有计时的时候，重新开始Tyme上一次记录Task的项目计时；

keyword: tsre


## Timer

Alfred计时器，输入分钟数字，开始计时；

keyword: timer 25

开始25分钟计时

## OmniFocus

### OmniFocus Restart Tasks Due

在OmniFocus 中选中Task对这些Task的截止时间按照传递的间隔顺序，进行排序；（自动跳过周五周六周日）

Keyword：omrt 2

间隔两天设置选中Task的截止时间；

### OmniFocus Sync to iCal

同步OmniFocus中选中的Task任务到iCal，日期时间为截止时间；

keyword: oms

Update：

更新根据OmniFocus当中项目所在文件夹添加入iCal当中的不同日历；需要手动添加iCloud当中的日历，以及建立文件夹与日历之间的添加关系；

### OmniFocus 设置Task截止时间和Now Tag

选中的OmniFocus的Task 增加Now的标签，并将截止时间更改为当前时间

keyword: omt

### OmniFocus 同步完成Task到Obsidian 

将完成项目同步到Obsidian当中；

包含两种情况，一个是今日，一个是每周；

会同步更新，丢弃的项目；

keyword: omsob

参数 1：同步本周报告

没有参数：同步今日报告